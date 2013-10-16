Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab3JPLlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:41:51 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49673 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3JPLlu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 16 Oct 2013 07:41:50 -0400
Message-Id: <525E979A02000078000FB730@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 12:41:46 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make FPU state alignment enforcement and checking
 consistent
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in validating only 16-byte alignment when XSAVE is in
use - 64-byte alignment is required here.

There's also no point in enforcing 64-btye alignment when XSAVE is not
in use - 16-byte alignment suffices here.

Also restrict the visibility of task_xstate_cachep by moving it to the
correct internal header (instead of it being declared in one included
by [almost] everyone).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/fpu-internal.h |    5 ++++-
 arch/x86/include/asm/processor.h    |    1 -
 arch/x86/kernel/process.c           |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- 3.12-rc5/arch/x86/include/asm/fpu-internal.h
+++ 3.12-rc5-x86-xstate-alignment/arch/x86/include/asm/fpu-internal.h
@@ -38,6 +38,7 @@ int ia32_setup_frame(int sig, struct ksi
 # define ia32_setup_rt_frame	__setup_rt_frame
 #endif
 
+extern struct kmem_cache *task_xstate_cachep;
 extern unsigned int mxcsr_feature_mask;
 extern void fpu_init(void);
 extern void eager_fpu_init(void);
@@ -573,7 +574,9 @@ static inline int fpu_alloc(struct fpu *
 	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
 	if (!fpu->state)
 		return -ENOMEM;
-	WARN_ON((unsigned long)fpu->state & 15);
+	WARN_ON((unsigned long)fpu->state & (use_xsave() ?
+					     __alignof(fpu->state->xsave) - 1 :
+					     __alignof(fpu->state->fxsave) - 1));
 	return 0;
 }
 
--- 3.12-rc5/arch/x86/include/asm/processor.h
+++ 3.12-rc5-x86-xstate-alignment/arch/x86/include/asm/processor.h
@@ -436,7 +436,6 @@ DECLARE_PER_CPU_ALIGNED(struct stack_can
 
 extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
-extern struct kmem_cache *task_xstate_cachep;
 
 struct perf_event;
 
--- 3.12-rc5/arch/x86/kernel/process.c
+++ 3.12-rc5-x86-xstate-alignment/arch/x86/kernel/process.c
@@ -87,11 +87,13 @@ void arch_release_task_struct(struct tas
 	free_thread_xstate(tsk);
 }
 
-void arch_task_cache_init(void)
+void __init arch_task_cache_init(void)
 {
         task_xstate_cachep =
         	kmem_cache_create("task_xstate", xstate_size,
-				  __alignof__(union thread_xstate),
+				  boot_cpu_has(X86_FEATURE_XSAVE) ?
+				  __alignof(struct xsave_struct) :
+				  __alignof(struct i387_fxsave_struct),
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 



