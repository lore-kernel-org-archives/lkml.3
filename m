Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaE2Hkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:40:47 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59817 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaE2Hkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:40:46 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 29 May 2014 16:41:17 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: virtio ring cleanups, which save stack on older gcc
Message-ID: <20140529074117.GI10092@bbox>
References: <87oayh6s3s.fsf@rustcorp.com.au>
 <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty,

On Thu, May 29, 2014 at 04:56:41PM +0930, Rusty Russell wrote:
> They don't make much difference: the easier fix is use gcc 4.8
> which drops stack required across virtio block's virtio_queue_rq
> down to that kmalloc in virtio_ring from 528 to 392 bytes.
> 
> Still, these (*lightly tested*) patches reduce to 432 bytes,
> even for gcc 4.6.4.  Posted here FYI.

I am testing with below which was hack for Dave's idea so don't have
a machine to test your patches until tomorrow.
So, I will queue your patches into testing machine tomorrow morning.

Thanks!

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5c6635b806c..95f169e85dbe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4241,10 +4241,13 @@ EXPORT_SYMBOL_GPL(yield_to);
 void __sched io_schedule(void)
 {
 	struct rq *rq = raw_rq();
+	struct blk_plug *plug = current->plug;
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
-	blk_flush_plug(current);
+	if (plug)
+		blk_flush_plug_list(plug, true);
+
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;

> 
> Cheers,
> Rusty.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
