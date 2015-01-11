Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbbAKWF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:05:29 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38179 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbAKWFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:17 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 07/11] x86,fpu: store current fpu pointer, instead of fpu_owner_task
Date: Sun, 11 Jan 2015 16:46:29 -0500
Message-Id: <1421012793-30106-8-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

This change has no impact on normal tasks, but it allows tasks
with multiple FPU states(like a KVM vcpu thread) to check
whether its other FPU state is still loaded.

Exported so KVM can use it.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 15 ++++++++-------
 arch/x86/kernel/cpu/common.c        |  5 +++--
 arch/x86/kernel/i387.c              |  2 +-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index a5a40c7..8546c0a 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -42,7 +42,7 @@ extern unsigned int mxcsr_feature_mask;
 extern void fpu_init(void);
 extern void eager_fpu_init(void);
 
-DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);
+DECLARE_PER_CPU(struct fpu *, fpu_owner);
 
 extern void convert_from_fxsr(struct user_i387_ia32_struct *env,
 			      struct task_struct *tsk);
@@ -318,14 +318,14 @@ static inline int __thread_has_fpu(struct task_struct *tsk)
 static inline void __thread_clear_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu = 0;
-	this_cpu_write(fpu_owner_task, NULL);
+	this_cpu_write(fpu_owner, NULL);
 }
 
 /* Must be paired with a 'clts' before! */
 static inline void __thread_set_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu = 1;
-	this_cpu_write(fpu_owner_task, tsk);
+	this_cpu_write(fpu_owner, &tsk->thread.fpu);
 }
 
 /*
@@ -394,13 +394,14 @@ static inline void drop_init_fpu(struct task_struct *tsk)
  */
 static inline void __cpu_disable_lazy_restore(unsigned int cpu)
 {
-	per_cpu(fpu_owner_task, cpu) = NULL;
+	per_cpu(fpu_owner, cpu) = NULL;
 }
 
 static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 {
-	return new == this_cpu_read_stable(fpu_owner_task) &&
-		cpu == new->thread.fpu.last_cpu;
+	struct fpu *new_fpu = &new->thread.fpu;
+	return new_fpu == this_cpu_read_stable(fpu_owner) &&
+		cpu == new_fpu->last_cpu;
 }
 
 static inline void switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
@@ -421,7 +422,7 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 			cpu = ~0;
 
 		old->thread.fpu.last_cpu = cpu;
-		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
+		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner! */
 
 		/* Don't change CR0.TS if we just switch! */
 		if (preload) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 36837bb..ad4d1a9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1143,8 +1143,9 @@ DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
 DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
 EXPORT_PER_CPU_SYMBOL(__preempt_count);
 
-/* Task that currently has its FPU state loaded on the CPU. */
-DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
+/* FPU state that is currently loaded on the CPU. */
+DEFINE_PER_CPU(struct fpu *, fpu_owner);
+EXPORT_PER_CPU_SYMBOL_GPL(fpu_owner);
 
 /*
  * Special IST stacks which the CPU switches to when it calls
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a9a4229..c98f88d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -78,7 +78,7 @@ void __kernel_fpu_begin(void)
 		__save_init_fpu(me);
 		/* We do 'stts()' in __kernel_fpu_end() */
 	} else if (!use_eager_fpu()) {
-		this_cpu_write(fpu_owner_task, NULL);
+		this_cpu_write(fpu_owner, NULL);
 		clts();
 	}
 }
-- 
1.9.3

