Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab3KMLmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:42:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55507 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783Ab3KMLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:41:59 -0500
Date: Wed, 13 Nov 2013 12:41:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/2] sched/mm: add finish_switch_mm function
Message-ID: <20131113114143.GJ21461@twins.programming.kicks-ass.net>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
 <1384330574-18418-2-git-send-email-schwidefsky@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384330574-18418-2-git-send-email-schwidefsky@de.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 09:16:13AM +0100, Martin Schwidefsky wrote:
> The switch_mm function is called with the task_lock and/or with
> request queue lock. Add finish_switch_mm to allow an architecture
> to execute some code after the mm has been switched but without
> any locks held. One use case is the s390 architecture which will
> use this to wait for the completion of TLB flush operations.

This so reminds me of what finish_arch_post_lock_switch() was supposed
to do. See commit: 01f23e1630d9 ("sched/arch: Introduce the
finish_arch_post_lock_switch() scheduler callback").

Now you hook into more places; but maybe you can Catalin can come up
with something you both can use?

(preserved patch for Catalin)

> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  include/linux/mmu_context.h |    6 ++++++
>  kernel/sched/core.c         |    7 +++++--
>  mm/mmu_context.c            |    3 +--
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
> index 70fffeb..0971c37 100644
> --- a/include/linux/mmu_context.h
> +++ b/include/linux/mmu_context.h
> @@ -1,9 +1,15 @@
>  #ifndef _LINUX_MMU_CONTEXT_H
>  #define _LINUX_MMU_CONTEXT_H
>  
> +#include <asm/mmu_context.h>
> +
>  struct mm_struct;
>  
>  void use_mm(struct mm_struct *mm);
>  void unuse_mm(struct mm_struct *mm);
>  
> +#ifndef finish_switch_mm
> +#define finish_switch_mm(mm, tsk) do { } while (0)
> +#endif
> +
>  #endif
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1deccd7..89409cb 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -32,7 +32,7 @@
>  #include <linux/init.h>
>  #include <linux/uaccess.h>
>  #include <linux/highmem.h>
> -#include <asm/mmu_context.h>
> +#include <linux/mmu_context.h>
>  #include <linux/interrupt.h>
>  #include <linux/capability.h>
>  #include <linux/completion.h>
> @@ -1996,6 +1996,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	perf_event_task_sched_in(prev, current);
>  	finish_lock_switch(rq, prev);
>  	finish_arch_post_lock_switch();
> +	finish_switch_mm(current->mm, current);
>  
>  	fire_sched_in_preempt_notifiers(current);
>  	if (mm)
> @@ -4140,8 +4141,10 @@ void idle_task_exit(void)
>  
>  	BUG_ON(cpu_online(smp_processor_id()));
>  
> -	if (mm != &init_mm)
> +	if (mm != &init_mm) {
>  		switch_mm(mm, &init_mm, current);
> +		finish_switch_mm(&init_mm, current);
> +	}
>  	mmdrop(mm);
>  }
>  
> diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> index 8a8cd02..11b3d47 100644
> --- a/mm/mmu_context.c
> +++ b/mm/mmu_context.c
> @@ -8,8 +8,6 @@
>  #include <linux/export.h>
>  #include <linux/sched.h>
>  
> -#include <asm/mmu_context.h>
> -
>  /*
>   * use_mm
>   *	Makes the calling kernel thread take on the specified
> @@ -31,6 +29,7 @@ void use_mm(struct mm_struct *mm)
>  	tsk->mm = mm;
>  	switch_mm(active_mm, mm, tsk);
>  	task_unlock(tsk);
> +	finish_switch_mm(mm, tsk);
>  
>  	if (active_mm != mm)
>  		mmdrop(active_mm);
> -- 
> 1.7.9.5
> 
