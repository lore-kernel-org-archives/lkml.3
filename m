Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3ANLT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:19:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:58496 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab3ANLTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:19:55 -0500
Date: Mon, 14 Jan 2013 12:19:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Gordeev <agordeev@redhat.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -tip] sched/rt: Fix locality of threaded interrupt
 handlers
In-Reply-To: <6b08a3c5c16284fd0221c2b564d451b4b9dcbf18.1357896654.git.agordeev@redhat.com>
Message-ID: <alpine.LFD.2.02.1301141217300.7475@ionos>
References: <6b08a3c5c16284fd0221c2b564d451b4b9dcbf18.1357896654.git.agordeev@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013, Alexander Gordeev wrote:

> When a interrupt affinity mask targets multiple CPUs, the
> RT scheduler selects a runqueue for RT task corresponding
> to a threaded interrupt handler without consideration of
> where the interrupt is actually gets delivered. It leads
> to a suboptimal condition when a hardware interrupt handler
> executes on one CPU while the threaded interrupt handler
> executes on another CPU.
> 
> This fix alters the behaviour of threaded handler wake-ups
> by getting priority to a CPU where the hardware interrupt
> handler is executing. As result, most of the time both
> halves of interrupt handling are kept local.

Nice one.
 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  include/linux/sched.h |    2 ++
>  kernel/irq/handle.c   |    2 +-
>  kernel/sched/core.c   |    5 +++++
>  kernel/sched/rt.c     |   27 +++++++++++++++++++--------
>  4 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 206bb08..cd9cb42 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1061,6 +1061,7 @@ struct sched_domain;
>  #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
>  #define WF_FORK		0x02		/* child wakeup after fork */
>  #define WF_MIGRATED	0x04		/* internal use, task got migrated */
> +#define WF_INTR		0x08		/* threaded handler wakeup from intr */

Please make this WF_LOCAL or something like that. There is no point to
tie this functionality to interrupt threads. The scheduler does not
care at all.
 
>  #define ENQUEUE_WAKEUP		1
>  #define ENQUEUE_HEAD		2
> @@ -2207,6 +2208,7 @@ extern void xtime_update(unsigned long ticks);
>  
>  extern int wake_up_state(struct task_struct *tsk, unsigned int state);
>  extern int wake_up_process(struct task_struct *tsk);
> +extern int wake_up_handler(struct task_struct *tsk);
>  extern void wake_up_new_task(struct task_struct *tsk);
>  #ifdef CONFIG_SMP
>   extern void kick_process(struct task_struct *tsk);
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 131ca17..79456b1 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -126,7 +126,7 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
>  	 */
>  	atomic_inc(&desc->threads_active);
>  
> -	wake_up_process(action->thread);
> +	wake_up_handler(action->thread);

  wake_up_local() or something more generic than wake_up_handler().

Otherwise looks good.

Thanks,

	tglx
