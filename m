Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3CEQcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:32:35 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:36510 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3CEQcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:32:33 -0500
Date: Tue, 5 Mar 2013 08:32:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: linux-kernel@vger.kernel.org, leiwen@marvell.com
Subject: Re: workqueue panic in 3.4 kernel
Message-ID: <20130305163228.GA12795@htj.dyndns.org>
References: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 05, 2013 at 03:31:45PM +0800, Lei Wen wrote:
> With checking memory,  we find work->data becomes 0x300, when it try
> to call get_work_cwq

Why would that become 0x300?  Who's writing to that memory?  Nobody
should be.

> in delayed_work_timer_fn. Thus cwq becomes NULL before calls __queue_work.
> So it is reasonable kernel get panic when it try to access wq with cwq->wq.
> 
> To fix it, we try to backport below patches:
> commit 60c057bca22285efefbba033624763a778f243bf
> Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date:   Wed Feb 6 18:04:53 2013 -0800
> 
>     workqueue: add delayed_work->wq to simplify reentrancy handling
> 
> commit 1265057fa02c7bed3b6d9ddc8a2048065a370364
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Aug 8 09:38:42 2012 -0700
> 
>     workqueue: fix CPU binding of flush_delayed_work[_sync]()

Neither should affect the problem you described above.  It *could*
make the problem go away just because it would stop using wq->data to
record cwq if the corruption was contained to that field but that
isn't a proper fix and the underlying problem could easily cause other
issues.

> And add below change to make sure __cancel_work_timer cannot preempt
> between run_timer_softirq and delayed_work_timer_fn.
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index bf4888c..0e9f77c 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2627,7 +2627,7 @@ static bool __cancel_work_timer(struct work_struct *work,
>                 ret = (timer && likely(del_timer(timer)));
>                 if (!ret)
>                         ret = try_to_grab_pending(work);
> -               wait_on_work(work);
> +               flush_work(work);
>         } while (unlikely(ret < 0));
> 
>         clear_work_data(work);
> 
> Do you think this fix is enough? And add flush_work directly in
> __cancel_work_timer is ok for
> the fix?

Maybe I'm missing something but it looks like the root cause hasn't
been diagnosed and you're piling up band-aids in workqueue code.  You
might get away with it but could also be making the problem just more
obscure and difficult to debug (reproducible bugs are happy bugs).

I'd suggest finding out who owns the delayed_work item and examining
why the delayed_work is getting corrupted in the first place.

Thanks.

-- 
tejun
