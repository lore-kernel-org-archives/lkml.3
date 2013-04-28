Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3D1PEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 11:04:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab3D1PEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 11:04:49 -0400
Date: Sun, 28 Apr 2013 17:04:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        DJ Johnston <dj.johnston@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] random: Allow fractional bits to be tracked
In-Reply-To: <1367102679-5178-3-git-send-email-hpa@zytor.com>
Message-ID: <alpine.LRH.2.00.1304281657481.28589@twin.jikos.cz>
References: <1367102679-5178-1-git-send-email-hpa@zytor.com> <1367102679-5178-3-git-send-email-hpa@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Apr 2013, H. Peter Anvin wrote:

> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> Allow fractional bits of entropy to be tracked by scaling the entropy
> counter (fixed point).  This will be used in a subsequent patch that
> accounts for entropy lost due to overwrites.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/char/random.c | 92 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 68 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 106b9b2..5cc8e86 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
[ ... snip ... ]
> @@ -852,28 +875,31 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
>  {
>  	unsigned long flags;
>  	int wakeup_write = 0;
> +	int have_bytes;
>  
>  	/* Hold lock while accounting */
>  	spin_lock_irqsave(&r->lock, flags);
>  
> -	BUG_ON(r->entropy_count > r->poolinfo->poolbits);
> +	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
>  	DEBUG_ENT("trying to extract %zu bits from %s\n",
>  		  nbytes * 8, r->name);
>  
>  	/* Can we pull enough? */
> -	if (r->entropy_count / 8 < min + reserved) {
> +	have_bytes = r->entropy_count >> (ENTROPY_SHIFT + 3);
> +	if (have_bytes < min + reserved) {
>  		nbytes = 0;
>  	} else {
>  		/* If limited, never pull more than available */
> -		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
> -			nbytes = r->entropy_count/8 - reserved;
> +		if (r->limit && nbytes + reserved >= have_bytes)
> +			nbytes = have_bytes - reserved;
>  
> -		if (r->entropy_count / 8 >= nbytes + reserved)
> -			r->entropy_count -= nbytes*8;
> +		if (have_bytes >= nbytes + reserved)
> +			r->entropy_count -= nbytes << (ENTROPY_SHIFT + 3);
>  		else
> -			r->entropy_count = reserved;
> +			r->entropy_count = reserved << (ENTROPY_SHIFT + 3);
>  
> -		if (r->entropy_count < random_write_wakeup_thresh)
> +		if ((r->entropy_count >> ENTROPY_SHIFT)
> +		    < random_write_wakeup_thresh)
>  			wakeup_write = 1;
>  	}

Please note that the code you are patching here (as is in Linus' tree 
currently) is buggy. I have sent a fix for this a week ago; it's now 
sitting in -mm as 
random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch 
so you (or whoever is merging your patchset) are likely to get a conflict 
here.

See my original submission at:

	https://lkml.org/lkml/2013/4/20/33

The patch fixes the issue, and therefore should be merged as soon as 
possible methinks ... but more generally, I am still wondering about the 
actual improvement the lockless cmpxchg-based aproach is actually 
providing. To quote my question from the original submission:

====
BTW, do we have some numbers that would prove how and why exactly is
902c098a3663 fixing real-time throughput by removing the spinlock?

Basically what we have now is producer and consumer over r->entropy_count
being serialized by retried cmpxchg loops, and I would think this could
actually make the whole situation less fair. The reason being that we are
basically spinning anyway in case of conflict on the critical section but
we are lacking the fairness comfort ticket-based spinlocks do provide
us ... hmm?
====

For completness, the patch below.




From: Jiri Kosina <jkosina@suse.cz>
Subject: random: fix accounting race condition with lockless irq entropy_count update

Commit 902c098a3663 ("random: use lockless techniques in the interrupt
path") turned IRQ path from being spinlock protected into lockless
cmpxchg-retry update.

That commit removed r->lock serialization between crediting entropy bits
from IRQ context and accounting when extracting entropy on userspace read
path, but didn't turn the r->entropy_count reads/updates in account() to
use cmpxchg as well.

It has been observed, that under certain circumstances this leads to
read() on /dev/urandom to return 0 (EOF), as r->entropy_count gets
corrupted and becomes negative, which in turn results in propagating 0 all
the way from account() to the actual read() call.

Convert the accounting code to be the proper lockless counterpart of what
has been partially done by 902c098a3663.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN drivers/char/random.c~random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update drivers/char/random.c
--- a/drivers/char/random.c~random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update
+++ a/drivers/char/random.c
@@ -865,16 +865,24 @@ static size_t account(struct entropy_sto
 	if (r->entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
+		int entropy_count, orig;
+retry:
+		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
+		if (r->limit && nbytes + reserved >= entropy_count / 8)
+			nbytes = entropy_count/8 - reserved;
 
-		if (r->entropy_count / 8 >= nbytes + reserved)
-			r->entropy_count -= nbytes*8;
-		else
-			r->entropy_count = reserved;
+		if (entropy_count / 8 >= nbytes + reserved) {
+			entropy_count -= nbytes*8;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		} else {
+			entropy_count = reserved;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		}
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (entropy_count < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
 
-- 
Jiri Kosina
SUSE Labs
