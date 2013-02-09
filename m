Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3BITRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:17:42 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50188 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab3BITRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:17:41 -0500
Date: Sat, 9 Feb 2013 11:17:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] stop_machine: dequeue work before signal completion
Message-ID: <20130209191737.GD2875@htj.dyndns.org>
References: <CAJd=RBBvE-5f1UyJGu32EHGVCXe6rVYY0010SKa56j7OvtPG7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBvE-5f1UyJGu32EHGVCXe6rVYY0010SKa56j7OvtPG7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Fri, Feb 08, 2013 at 11:42:43AM +0800, Hillf Danton wrote:
> As checked with BUG_ON in the case of CPU_UP_PREPARE, we have to dequeue
> work first for further actions, then stopper reaches sane and clear state.

When a CPU is finally put down in either CPU_UP_CANCELLED or
CPU_POST_DEAD, cpu_stop_cpu_callback() signals immediate completion on
all cpu_stop_works still queued on the dead CPU; unfortunately, this
code is buggy in that it doesn't remove the canceled work items off
the stopper->works leaving it corrupted, which will trigger BUG_ON()
during CPU_UP_PREPARE if the CPU is brought back online.

This bug isn't easily triggered because CPU_DOWN has to race against
cpu_stop calls and most, if not all, cpu stop users pin target CPUs.

Fix it by popping each work item off stopper->works.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Maybe

Cc: stable@vger.kernel.org

> --- a/kernel/stop_machine.c	Fri Feb  8 11:22:44 2013
> +++ b/kernel/stop_machine.c	Fri Feb  8 11:29:40 2013
> @@ -342,8 +342,12 @@ static int __cpuinit cpu_stop_cpu_callba
>  		kthread_stop(stopper->thread);
>  		/* drain remaining works */
>  		spin_lock_irq(&stopper->lock);
> -		list_for_each_entry(work, &stopper->works, list)
> +		while (!list_empty(&stopper->works)) {
> +			work = list_first_entry(&stopper->works,
> +					struct cpu_stop_work, list);
> +			list_del_init(&work->list);
>  			cpu_stop_signal_done(work->done, false);
> +		}

I think your previous version was better with @work declaration moved
inside the while() loop.

Thanks.

-- 
tejun
