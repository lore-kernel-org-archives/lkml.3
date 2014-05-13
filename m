Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbaEMOBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:01:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759502AbaEMOBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:01:38 -0400
Date: Tue, 13 May 2014 16:01:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 17/19] fs: buffer: Do not use unnecessary atomic
 operations when discarding buffers
Message-ID: <20140513140127.GC2485@laptop.programming.kicks-ass.net>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-18-git-send-email-mgorman@suse.de>
 <20140513110951.GB30445@twins.programming.kicks-ass.net>
 <20140513125007.GQ23991@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513125007.GQ23991@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 01:50:07PM +0100, Mel Gorman wrote:
> > Anyway, nothing wrong with this patch, however, you could, if you really
> > wanted to push things, also include BH_Lock in that clear :-)
> 
> That's a bold strategy Cotton.

:-)

> Untested patch on top
> 
> ---8<---
> diff --git a/fs/buffer.c b/fs/buffer.c
> index e80012d..42fcb6d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1490,6 +1490,8 @@ static void discard_buffer(struct buffer_head * bh)
>  	lock_buffer(bh);
>  	clear_buffer_dirty(bh);
>  	bh->b_bdev = NULL;
> +
> +	smp_mb__before_clear_bit();

Not needed.

>  	b_state = bh->b_state;
>  	for (;;) {
>  		b_state_old = cmpxchg(&bh->b_state, b_state, (b_state & ~BUFFER_FLAGS_DISCARD));
> @@ -1497,7 +1499,13 @@ static void discard_buffer(struct buffer_head * bh)
>  			break;
>  		b_state = b_state_old;
>  	}
> -	unlock_buffer(bh);
> +
> +	/*
> +	 * BUFFER_FLAGS_DISCARD include BH_lock so it has been cleared so the
> +	 * wake_up_bit is the last part of a unlock_buffer
> +	 */
> +	smp_mb__after_clear_bit();

Similarly superfluous.

> +	wake_up_bit(&bh->b_state, BH_Lock);
>  }

The thing is that cmpxchg() guarantees full barrier semantics before and
after the op, and since the loop guarantees at least one cmpxchg() call
its all good.

Now just to confuse everyone, you could have written the loop like:

	b_state = bh->b_state;
	for (;;) {
		b_state_new = b_state & ~BUFFER_FLAGS_DISCARD;
		if (b_state == b_state_new)
			break;
		b_state = cmpxchg(&bh->b_state, b_state, b_state_new);
	}

Which is 'similar' but doesn't guarantee that cmpxchg() gets called.
If you expect the initial value to match the new state, the above form
is slightly faster, but the lack of barrier guarantees can still spoil
the fun.
