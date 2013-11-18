Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab3KRILz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:11:55 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:34558 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3KRILt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:11:49 -0500
Date: Mon, 18 Nov 2013 09:11:43 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] s390/mm,tlb: race of lazy TLB flush vs. recreation
 of TLB entries
Message-ID: <20131118091143.04e3d9c2@mschwide>
In-Reply-To: <CAHkRjk7-iD-2x5tvm4+5jp7HATL-7EdzfOqd=Sqe+XyA3CqC6Q@mail.gmail.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
	<1384330574-18418-3-git-send-email-schwidefsky@de.ibm.com>
	<CAHkRjk6LAmQpkioBdFxH5htYHi75bR2xhfXzfvmQL5Br0kMgvg@mail.gmail.com>
	<20131114091007.0b15dde2@mschwide>
	<20131114132223.GG20261@arm.com>
	<20131114173359.2e3cbd60@mschwide>
	<20131115104437.GA573@darko.cambridge.arm.com>
	<20131115121000.69219fa4@mschwide>
	<20131115121736.72170c36@mschwide>
	<20131115115701.GA1047@darko.cambridge.arm.com>
	<20131115142928.76688783@mschwide>
	<CAHkRjk7-iD-2x5tvm4+5jp7HATL-7EdzfOqd=Sqe+XyA3CqC6Q@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111808-5024-0000-0000-000007DA1A0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013 13:46:07 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> On 15 November 2013 13:29, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > On Fri, 15 Nov 2013 11:57:01 +0000
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> >> On Fri, Nov 15, 2013 at 11:17:36AM +0000, Martin Schwidefsky wrote:
> >> > On Fri, 15 Nov 2013 12:10:00 +0100
> >> > Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> >> >
> >> > > On Fri, 15 Nov 2013 10:44:37 +0000
> >> > > Catalin Marinas <catalin.marinas@arm.com> wrote:
> >> > > > 1. thread-A running with mm-A
> >> > > > 2. context_switch() to thread-B1 causing a switch_mm(mm-B)
> >> > > > 3. switch_mm(mm-B) sets thread-B1's TIF_TLB_WAIT but does _not_ call
> >> > > >    update_mm(mm-B). Hardware still using mm-A
> >> > > > 4. scheduler unlocks and is about to call finish_mm_switch(mm-B)
> >> > > > 5. interrupt and preemption before finish_mm_switch(mm-B)
> >> > > > 6. context_switch() to thread-B2 causing a switch_mm(mm-B) (note here
> >> > > >    that thread-B1 and thread-B2 have the same mm-B)
> >> > > > 7. switch_mm() as in this patch exits early because prev == next
> >> > > > 8. finish_mm_switch(mm-B) is indeed called but TIF_TLB_WAIT is not set
> >> > > >    for thread-B2, therefore no call to update_mm(mm-B)
> >> > > >
> >> > > > So after point 8, you get thread-B2 running (and possibly returning to
> >> > > > user space) with mm-A. Do you see a problem here?
> >> > >
> >> > > Oh, now I get it. Thanks for the patience, this is indeed a problem.
> >> > > And I concur, a per-mm flag is the 'obvious' solution.
> >> >
> >> > Having said that and looking at the code I find this to be not as obvious
> >> > any more. If you have multiple cpus using a per-mm flag can get you into
> >> > trouble:
> >> >
> >> > 1. cpu #1 calls switch_mm and finds that irqs are disabled.
> >> >    mm->context.switch_pending is set
> >> > 2. cpu #2 calls switch_mm for the same mm and finds that irqs are disabled.
> >> >    mm->context.switch_pending is set again
> >> > 3. cpu #1 reaches finish_arch_post_lock_switch and finds switch_pending == 1
> >> > 4. cpu #1 zeroes mm->switch_pending and calls cpu_switch_mm
> >> > 5. cpu #2 reaches finish_arch_post_lock_switch and finds switch_pending == 0
> >> > 6. cpu #2 continues with the old mm
> >> >
> >> > This is a race, no?
> >>
> >> Yes, but we only use this on ARMv5 and earlier and there is no SMP
> >> support.
> >>
> >> On arm64 however, I need to fix that and you made a good point. In my
> >> (not yet public) patch, the switch_pending is cleared after all the
> >> IPIs have been acknowledged but it needs some more thinking. A solution
> >> could be to always do the cpu_switch_mm() in finish_mm_switch() without
> >> any checks but this requires that any switch_mm() call from the kernel
> >> needs to be paired with finish_mm_switch(). So your first patch comes in
> >> handy (but I still need to figure out a quick arm64 fix for cc stable).
> >
> > I am currently thinking about the following solution for s390: keep the
> > TIF_TLB_FLUSH bit per task but do a preempt_disable() in switch_mm()
> > if the switch is incomplete. This pairs with a preempt_enable() in
> > finish_switch_mm() after the update_mm has been done.
> 
> That's the first thing I tried when I noticed the problem but I got
> weird kernel warnings with preempt_enable/disabling spanning across
> the scheduler unlocking. So doesn't seem safe.
> 
> It may work if instead a simple flag you use atomic_inc/dec for the mm flag.

I have not seen the kernel warnings because the detour over finish_switch_mm
is used only rarely. After forcing the detour I got the fallout, doing the
preempt_disable in switch_mm and preempt_enable in finish_switch_mm does not
work. But what does work is to copy the TIF_TLB_FLUSH bit in the __switch_to
function just like the TIF_MCCK_PENDING. That way the TIF_TLB_FLUSH can not
get "hidden" by a preemptive schedule.

The patch to use finish_arch_post_lock_switch instead of finish_switch_mm
would look like this:
--
>From c4d83a9ff8c6d5ca821bab24b5bd77b782a69819 Mon Sep 17 00:00:00 2001
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Fri, 26 Oct 2012 17:17:44 +0200
Subject: [PATCH] sched/mm: call finish_arch_post_lock_switch in idle_task_exit
 and use_mm

The finish_arch_post_lock_switch is called at the end of the task
switch after all locks have been released. In concept it is paired
with the switch_mm function, but the current code only does the
call in finish_task_switch. Add the call to idle_task_exit and
use_mm. One use case for the additional calls is s390 which will
use finish_arch_post_lock_switch to wait for the completion of
TLB flush operations.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/mmu_context.h | 6 ++++++
 kernel/sched/core.c         | 6 ++++--
 kernel/sched/sched.h        | 3 ---
 mm/mmu_context.c            | 3 +--
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
index 70fffeb..38f5550 100644
--- a/include/linux/mmu_context.h
+++ b/include/linux/mmu_context.h
@@ -1,9 +1,15 @@
 #ifndef _LINUX_MMU_CONTEXT_H
 #define _LINUX_MMU_CONTEXT_H
 
+#include <asm/mmu_context.h>
+
 struct mm_struct;
 
 void use_mm(struct mm_struct *mm);
 void unuse_mm(struct mm_struct *mm);
 
+#ifndef finish_arch_post_lock_switch
+# define finish_arch_post_lock_switch()	do { } while (0)
+#endif
+
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c180860..ffa234c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -32,7 +32,7 @@
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
-#include <asm/mmu_context.h>
+#include <linux/mmu_context.h>
 #include <linux/interrupt.h>
 #include <linux/capability.h>
 #include <linux/completion.h>
@@ -4154,8 +4154,10 @@ void idle_task_exit(void)
 
 	BUG_ON(cpu_online(smp_processor_id()));
 
-	if (mm != &init_mm)
+	if (mm != &init_mm) {
 		switch_mm(mm, &init_mm, current);
+		finish_arch_post_lock_switch();
+	}
 	mmdrop(mm);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b2..ad48db3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -850,9 +850,6 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #ifndef finish_arch_switch
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
-#ifndef finish_arch_post_lock_switch
-# define finish_arch_post_lock_switch()	do { } while (0)
-#endif
 
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index 8a8cd02..56ecbbd 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -8,8 +8,6 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 
-#include <asm/mmu_context.h>
-
 /*
  * use_mm
  *	Makes the calling kernel thread take on the specified
@@ -31,6 +29,7 @@ void use_mm(struct mm_struct *mm)
 	tsk->mm = mm;
 	switch_mm(active_mm, mm, tsk);
 	task_unlock(tsk);
+	finish_arch_post_lock_switch();
 
 	if (active_mm != mm)
 		mmdrop(active_mm);
-- 
1.8.3.4

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

