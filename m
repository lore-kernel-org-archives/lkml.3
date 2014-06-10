Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbaFJUkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:40:33 -0400
Received: from ns.horizon.com ([71.41.210.147]:14138 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753429AbaFJUka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:40:30 -0400
Date: 10 Jun 2014 16:40:28 -0400
Message-ID: <20140610204028.14101.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140610152541.GA12104@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's the adjustment downward which is what gives us the catastrophic
> reseeding --- specifically, it's adjusting the number of bytes down to
> zero until we can transfer enough entropy to make it intractable for
> the adversary to test the 2**N possible pool states that might
> correspond to the observed /dev/random output.

Er, yes, I understand that... as I said, I understand the
purpose and importance of catastrophic reseeding.

Look, maybe it's easier to see in the draft patch appended.
I added a comment pointing out the catastrophic reseeding.

(Your opinions on the issues labelled FIXME in the comments
are definitely solicited.)

An obvious follow-up patch is to delete the last two arguments from
extract_entropy(), since they're always zero in all remaining calls.

> I suspect that the FIPS check is not necessary for intra-pool
> transfers, but quite frankly, I can't be bothered to care about
> improving the efficiency of systems put into FIPS mode.  And there is
> a possibility that changing it might break the FIPS certification.
> Not that I care either way, but I'm just not motiviated to verify that
> any change to improve FIPS efficiency might not break security for the
> use cases that I actually care about.  :-/

I don't care about the efficiency either; I just wanted to avoid the
stack usage of a "u32 tmp[OUTPUT_POOL_WORDS]" when the actual extraction
is done in EXTRACT_SIZE chunks anyhway.

(This stuff is called from fs code in some cases, although I haven't
checked if it's on the page-out path that's always the stack smasher.)

My question was "do I have to preserve that crap when it would be
easier to dike it out?"  Look at the example patch below.

(If I did have to preserve it, then I'd move the check into
extract_buf.)

> The null hypothesis that any change would have to compete against is
> adding a trylock to add_interrupt_randomness(), since the change is
> small, and obviously not going to make things worse.

Er, you seem to underestimate the changes.  It also involves moving the
existing locks outward to encompass entropy accounting in many places in
the code (after which the cmpxchg in credit_entropy is no longer needed
and may be deleted).

> Does that make sense?

The goals make perfect sense, I'm just saying that "add a trylock"
is not a literal implementation guide; there are a lot of consequent
changes that are being glossed over.

I really think the result will be much clearer, but I'll know for
sure when I get there.


Draft patch to reduce stack usage in _xfer_secondary_pool:

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 102c50d3..5bbe5167 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -910,8 +910,9 @@ void add_disk_randomness(struct gendisk *disk)
  *
  *********************************************************************/
 
-static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, int min, int rsvd);
+static size_t account(struct entropy_store *r, size_t nbytes, int min,
+		      int reserved);
+static void extract_buf(struct entropy_store *r, u8 out[EXTRACT_SIZE]);
 
 /*
  * This utility inline function is responsible for transferring entropy
@@ -937,23 +938,51 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 
 static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	__u32	tmp[OUTPUT_POOL_WORDS];
-
-	/* For /dev/random's pool, always leave two wakeups' worth */
-	int rsvd_bytes = r->limit ? 0 : random_read_wakeup_bits / 4;
+	u8	tmp[EXTRACT_SIZE];
 	int bytes = nbytes;
 
 	/* pull at least as much as a wakeup */
 	bytes = max_t(int, bytes, random_read_wakeup_bits / 8);
 	/* but never more than the buffer size */
-	bytes = min_t(int, bytes, sizeof(tmp));
+	bytes = min_t(int, bytes, OUTPUT_POOL_WORDS*sizeof(u32));
 
+	/*
+	 * FIXME: Move this to after account(), so it shows the true amount
+	 * transferred?
+	 */
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
-	bytes = extract_entropy(r->pull, tmp, bytes,
-				random_read_wakeup_bits / 8, rsvd_bytes);
-	mix_pool_bytes(r, tmp, bytes, NULL);
-	credit_entropy_bits(r, bytes*8);
+
+	/*
+	 * This is the only place we call account() with non-zero
+	 * "min" and "reserved" values.  The minimum is used to
+	 * enforce catastrophic reseeding: if we can't get at least
+	 * random_read_wakeup_bits of entropy, don't bother reseeding
+	 * at all, but wait until a useful amount is available.
+	 *
+	 * The "reserved" is used to prevent reads from /dev/urandom
+	 * from emptying the input pool; leave two wakeups' worth
+	 * for /dev/random.
+	 */
+	bytes = account(r->pull, bytes, random_read_wakeup_bits / 8,
+	                r->limit ? 0 : random_read_wakeup_bits / 4);
+
+	/* Now to the actual transfer, in EXTRACT_SIZE units */
+	while (bytes) {
+		int i = min_t(int, bytes, EXTRACT_SIZE);
+
+		extract_buf(r->pull, tmp);
+		mix_pool_bytes(r, tmp, i, NULL);
+		credit_entropy_bits(r, i*8);
+		bytes -= i;
+	}
+
+	/*
+	 * Wipe data just returned from memory.
+	 * FIXME: gcc understands memset and will probably optimize
+	 * this out.  Use OpenBSD-style explicit_bzero()?
+	 */
+	memset(tmp, 0, sizeof(tmp));
 }
 
 /*
@@ -1019,7 +1048,7 @@ retry:
  *
  * Note: we assume that .poolwords is a multiple of 16 words.
  */
-static void extract_buf(struct entropy_store *r, __u8 *out)
+static void extract_buf(struct entropy_store *r, __u8 out[EXTRACT_SIZE])
 {
 	int i;
 	union {
