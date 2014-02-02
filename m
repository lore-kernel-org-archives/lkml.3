Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaBBHUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 02:20:06 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62081 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaBBHUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 02:20:04 -0500
Message-ID: <1391325599.6481.5.camel@europa>
Subject: Re: [PATCH] Make math_state_restore() save and restore the
 interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
Reply-To: sbsiddha@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Date: Sat, 01 Feb 2014 23:19:59 -0800
In-Reply-To: <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	 <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	 <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	 <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	 <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-01 at 17:06 -0800, Suresh Siddha wrote:
> Meanwhile I have the patch removing the delayed dynamic allocation for
> non-eager fpu. will post it after some testing.

Appended the patch for this. Tested for last 4-5 hours on my laptop.

The real fix for Nate's problem will be coming from Linus, with a
slightly modified option-b that Linus proposed. Linus, please let me
know if you want me to spin it. I can do it sunday night.

thanks,
suresh
---
From: Suresh Siddha <sbsiddha@gmail.com>
Subject: x86, fpu: remove the logic of non-eager fpu mem allocation at the first usage

For non-eager fpu mode, thread's fpu state is allocated during the first
fpu usage (in the context of device not available exception). This can be
a blocking call and hence we enable interrupts (which were originally
disabled when the exception happened), allocate memory and disable
interrupts etc. While this saves 512 bytes or so per-thread, there
are some issues in general.

a.  Most of the future cases will be anyway using eager
FPU (because of processor features like xsaveopt, LWP, MPX etc) and
they do the allocation at the thread creation itself. Nice to have
one common mechanism as all the state save/restore code is
shared. Avoids the confusion and minimizes the subtle bugs
in the core piece involved with context-switch.

b. If a parent thread uses FPU, during fork() we allocate
the FPU state in the child and copy the state etc. Shortly after this,
during exec() we free it up, so that we can later allocate during
the first usage of FPU. So this free/allocate might be slower
for some workloads.

c. math_state_restore() is called from multiple places
and it is error pone if the caller expects interrupts to be disabled
throughout the execution of math_state_restore(). Can lead to subtle
bugs like Ubuntu bug #1265841.

Memory savings will be small anyways and the code complexity
introducing subtle bugs is not worth it. So remove
the logic of non-eager fpu mem allocation at the first usage.

Signed-off-by: Suresh Siddha <sbsiddha@gmail.com>
---
 arch/x86/kernel/i387.c    | 14 +++++---------
 arch/x86/kernel/process.c |  6 ------
 arch/x86/kernel/traps.c   | 16 ++--------------
 arch/x86/kernel/xsave.c   |  2 --
 4 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index e8368c6..4e5f770 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -5,6 +5,7 @@
  *  General FPU state handling cleanups
  *	Gareth Hughes <gareth@valinux.com>, May 2000
  */
+#include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/regset.h>
 #include <linux/sched.h>
@@ -186,6 +187,10 @@ void fpu_init(void)
 	if (xstate_size == 0)
 		init_thread_xstate();
 
+	if (!current->thread.fpu.state)
+		current->thread.fpu.state =
+			alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
+
 	mxcsr_feature_mask_init();
 	xsave_init();
 	eager_fpu_init();
@@ -219,8 +224,6 @@ EXPORT_SYMBOL_GPL(fpu_finit);
  */
 int init_fpu(struct task_struct *tsk)
 {
-	int ret;
-
 	if (tsk_used_math(tsk)) {
 		if (cpu_has_fpu && tsk == current)
 			unlazy_fpu(tsk);
@@ -228,13 +231,6 @@ int init_fpu(struct task_struct *tsk)
 		return 0;
 	}
 
-	/*
-	 * Memory allocation at the first usage of the FPU and other state.
-	 */
-	ret = fpu_alloc(&tsk->thread.fpu);
-	if (ret)
-		return ret;
-
 	fpu_finit(&tsk->thread.fpu);
 
 	set_stopped_child_used_math(tsk);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95..cd9c190 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -128,12 +128,6 @@ void flush_thread(void)
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	drop_init_fpu(tsk);
-	/*
-	 * Free the FPU state for non xsave platforms. They get reallocated
-	 * lazily at the first use.
-	 */
-	if (!use_eager_fpu())
-		free_thread_xstate(tsk);
 }
 
 static void hard_disable_TSC(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..3265429 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -623,20 +623,8 @@ void math_state_restore(void)
 {
 	struct task_struct *tsk = current;
 
-	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(tsk)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
+	if (!tsk_used_math(tsk))
+		init_fpu(tsk);
 
 	__thread_fpu_begin(tsk);
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a4b451c..46f6266 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -598,8 +598,6 @@ void xsave_init(void)
 
 static inline void __init eager_fpu_init_bp(void)
 {
-	current->thread.fpu.state =
-	    alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
 	if (!init_xstate_buf)
 		setup_init_fpu_buf();
 }


