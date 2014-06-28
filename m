Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaF1Ryu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:54:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaF1Rxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Greg Price <price@mit.edu>
Subject: [PATCH 3.15 137/139] random: fix nasty entropy accounting bug
Date: Sat, 28 Jun 2014 10:48:18 -0700
Message-Id: <20140628174611.657619772@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit e33ba5fa7afce1a9f159704121d4e4d110df8185 upstream.

Commit 0fb7a01af5b0 "random: simplify accounting code", introduced in
v3.15, has a very nasty accounting problem when the entropy pool has
has fewer bytes of entropy than the number of requested reserved
bytes.  In that case, "have_bytes - reserved" goes negative, and since
size_t is unsigned, the expression:

       ibytes = min_t(size_t, ibytes, have_bytes - reserved);

... does not do the right thing.  This is rather bad, because it
defeats the catastrophic reseeding feature in the
xfer_secondary_pool() path.

It also can cause the "BUG: spinlock trylock failure on UP" for some
kernel configurations when prandom_reseed() calls get_random_bytes()
in the early init, since when the entropy count gets corrupted,
credit_entropy_bits() erroneously believes that the nonblocking pool
has been fully initialized (when in fact it is not), and so it calls
prandom_reseed(true) recursively leading to the spinlock BUG.

The logic is *not* the same it was originally, but in the cases where
it matters, the behavior is the same, and the resulting code is
hopefully easier to read and understand.

Fixes: 0fb7a01af5b0 "random: simplify accounting code"
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Greg Price <price@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -979,7 +979,6 @@ static void push_to_pool(struct work_str
 static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
-	int have_bytes;
 	int entropy_count, orig;
 	size_t ibytes;
 
@@ -988,17 +987,19 @@ static size_t account(struct entropy_sto
 	/* Can we pull enough? */
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
-	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
 	ibytes = nbytes;
 	/* If limited, never pull more than available */
-	if (r->limit)
-		ibytes = min_t(size_t, ibytes, have_bytes - reserved);
+	if (r->limit) {
+		int have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
+
+		if ((have_bytes -= reserved) < 0)
+			have_bytes = 0;
+		ibytes = min_t(size_t, ibytes, have_bytes);
+	}
 	if (ibytes < min)
 		ibytes = 0;
-	if (have_bytes >= ibytes + reserved)
-		entropy_count -= ibytes << (ENTROPY_SHIFT + 3);
-	else
-		entropy_count = reserved << (ENTROPY_SHIFT + 3);
+	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0)
+		entropy_count = 0;
 
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;


