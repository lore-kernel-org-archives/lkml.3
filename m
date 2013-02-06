Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3BFSry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:47:54 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:65147 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3BFSrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:47:53 -0500
Date: Wed, 6 Feb 2013 10:47:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] stop_machine: dequeue work before signal completion
Message-ID: <20130206184749.GB2875@htj.dyndns.org>
References: <CAJd=RBBsMaXS5hA1OCX8Sp2y90Crktp6p4a7MSRZ3p6xq6RCmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBsMaXS5hA1OCX8Sp2y90Crktp6p4a7MSRZ3p6xq6RCmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 08:38:43PM +0800, Hillf Danton wrote:
> As handled by the kernel thread, work is dequeued first for further actions.

Ditto as the previous patch.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/stop_machine.c	Wed Feb  6 19:57:12 2013
> +++ b/kernel/stop_machine.c	Wed Feb  6 20:02:12 2013
> @@ -334,23 +334,24 @@ static int __cpuinit cpu_stop_cpu_callba
>  #ifdef CONFIG_HOTPLUG_CPU
>  	case CPU_UP_CANCELED:
>  	case CPU_POST_DEAD:
> -	{
> -		struct cpu_stop_work *work;
> -
>  		sched_set_stop_task(cpu, NULL);
>  		/* kill the stopper */
>  		kthread_stop(stopper->thread);
>  		/* drain remaining works */
>  		spin_lock_irq(&stopper->lock);
> -		list_for_each_entry(work, &stopper->works, list)
> +		while (!list_empty(&stopper->works)) {
> +			struct cpu_stop_work *work;
> +			work = list_first_entry(&stopper->works,
> +					struct cpu_stop_work, list);
> +			list_del_init(&work->list);
>  			cpu_stop_signal_done(work->done, false, 0);
> +		}
>  		stopper->enabled = false;
>  		spin_unlock_irq(&stopper->lock);

Why does this matter?  It's inside spinlock.  What's being made better
by this change?

-- 
tejun
