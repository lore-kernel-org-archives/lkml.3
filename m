Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaGSFvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 01:51:45 -0400
Received: from imap.thunk.org ([74.207.234.97]:44762 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaGSFvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 01:51:43 -0400
Date: Sat, 19 Jul 2014 01:42:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, price@mit.edu
Subject: Re: [PATCH] random: check for increase of entropy_count because of
 signed conversion
Message-ID: <20140719054258.GH18775@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	linux-kernel@vger.kernel.org, davej@redhat.com, price@mit.edu
References: <20140718215054.GD18775@thunk.org>
 <1405721239-2630-1-git-send-email-tytso@mit.edu>
 <1405726548.10838.34.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405726548.10838.34.camel@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 01:35:48AM +0200, Hannes Frederic Sowa wrote:
> > +	nfrac = ibytes << (ENTROPY_SHIFT + 3);
> > +	if (entropy_count < 0) {
> 
> Minor nit: maybe also add an unlikely() here?

Yep, done.

> > +	if ((unsigned) entropy_count > nfrac)
> 
> (unsigned) -> (size_t)
>
> size_t could also be (unsigned long) so the plain (unsigned) is
> misleading.

Good point, done.

> (Maybe I wouldn't have done the cast at all, as we compile the kernel
> with -Wno-sign-compare and we have the < 0 check right above, but I
> don't have a strong opinion on that.)

I also wanted to shut up other static code checkers like Coverity.  :-)

> > +	nbytes = min_t(size_t, nbytes, INT_MAX >> ENTROPY_SHIFT);
> 
> Hmm, not sure, nfracs unit is 1/8 bits, so don't we have to limit nbytes
> to INT_MAX >> (ENTROPY_SHIFT + 3) here?

Good catch, done.

> And if we want to be even more correct here, we could switch from
> INT_MAX to SIZE_MAX, as we do all nfrac calculations in the size_t
> domain.

The main reason why I used INT_MAX was as a further safety check to
protect the:

	entropy_count -= nfrac;

calculation, since nfrac is size_t and entropy_count is int.

In fact I think this online change ("nbytes = min_t(size_t, nbytes,
INT_MAX >> (ENTROPY_SHIFT + 3));") would have been enough to fix the
problem all by itself, but the other changes results in code which is
cleaner and easier to understand, and I'm a firm believer in multiple
layers of protection.  :-)

Cheers,

					- Ted

commit 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc
Author: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date:   Fri Jul 18 17:26:41 2014 -0400

    random: check for increase of entropy_count because of signed conversion
    
    The expression entropy_count -= ibytes << (ENTROPY_SHIFT + 3) could
    actually increase entropy_count if during assignment of the unsigned
    expression on the RHS (mind the -=) we reduce the value modulo
    2^width(int) and assign it to entropy_count. Trinity found this.
    
    [ Commit modified by tytso to add an additional safety check for a
      negative entropy_count -- which should never happen, and to also add
      an additional paranoia check to prevent overly large count values to
      be passed into urandom_read().  ]
    
    Reported-by: Dave Jones <davej@redhat.com>
    Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Cc: stable@vger.kernel.org

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a7ac0a..71529e1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -641,7 +641,7 @@ retry:
 		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
 	}
 
-	if (entropy_count < 0) {
+	if (unlikely(entropy_count < 0)) {
 		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
 		WARN_ON(1);
@@ -981,7 +981,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
 	int entropy_count, orig;
-	size_t ibytes;
+	size_t ibytes, nfrac;
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 
@@ -999,7 +999,17 @@ retry:
 	}
 	if (ibytes < min)
 		ibytes = 0;
-	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0)
+
+	if (unlikely(entropy_count < 0)) {
+		pr_warn("random: negative entropy count: pool %s count %d\n",
+			r->name, entropy_count);
+		WARN_ON(1);
+		entropy_count = 0;
+	}
+	nfrac = ibytes << (ENTROPY_SHIFT + 3);
+	if ((size_t) entropy_count > nfrac)
+		entropy_count -= nfrac;
+	else
 		entropy_count = 0;
 
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
@@ -1376,6 +1386,7 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 			    "with %d bits of entropy available\n",
 			    current->comm, nonblocking_pool.entropy_total);
 
+	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
 	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
 
 	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),
