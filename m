Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaHFMz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:55:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbaHFMzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:55:52 -0400
From: Mel Gorman <mgorman@suse.de>
To: H Peter Anvin <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <mgalbraith@suse.de>, Linux-X86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/3] x86, fpu: Split FPU save state preparation into eagerfpu and !eagerfpu parts
Date: Wed,  6 Aug 2014 13:55:47 +0100
Message-Id: <1407329748-3928-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407329748-3928-1-git-send-email-mgorman@suse.de>
References: <1407329748-3928-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the CPU supports non-lazy FPU support using xsave then a different save
path is used for the FPU during context switch. The xsave path is heavier
than it needs to be so this patch splits the two cases in preparation.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/include/asm/fpu-internal.h | 40 ++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index b8771c4a..8d92807 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -416,15 +416,36 @@ static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 		cpu == new->thread.fpu.last_cpu;
 }
 
-static inline void switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu,
+static inline void switch_eagerfpu_prepare(struct task_struct *old, struct task_struct *new, int cpu,
+						fpu_switch_t *fpu)
+{
+	fpu->preload = tsk_used_math(new);
+
+	if (__thread_has_fpu(old)) {
+		if (!__save_init_fpu(old))
+			cpu = ~0;
+		old->thread.fpu.last_cpu = cpu;
+		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
+	} else {
+		old->thread.fpu_counter = 0;
+		old->thread.fpu.last_cpu = ~0;
+	}
+
+	if (fpu->preload) {
+		new->thread.fpu_counter++;
+		__thread_set_has_fpu(new);
+		prefetch(new->thread.fpu.state);
+	}
+}
+
+static inline void switch_preloadfpu_prepare(struct task_struct *old, struct task_struct *new, int cpu,
 						fpu_switch_t *fpu)
 {
 	/*
 	 * If the task has used the math, pre-load the FPU on xsave processors
 	 * or if the past 5 consecutive context-switches used math.
 	 */
-	fpu->preload = tsk_used_math(new) && (use_eager_fpu() ||
-					     new->thread.fpu_counter > 5);
+	fpu->preload = tsk_used_math(new) && (new->thread.fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
 			cpu = ~0;
@@ -436,14 +457,14 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 			new->thread.fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
-		} else if (!use_eager_fpu())
+		} else
 			stts();
 	} else {
 		old->thread.fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
 		if (fpu->preload) {
 			new->thread.fpu_counter++;
-			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
+			if (fpu_lazy_restore(new, cpu))
 				fpu->preload = 0;
 			else
 				prefetch(new->thread.fpu.state);
@@ -452,6 +473,15 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 	}
 }
 
+static inline void switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu,
+						fpu_switch_t *fpu)
+{
+	if (use_eager_fpu())
+		switch_eagerfpu_prepare(old, new, cpu, fpu);
+	else
+		switch_preloadfpu_prepare(old, new, cpu, fpu);
+}
+
 /*
  * By the time this gets called, we've already cleared CR0.TS and
  * given the process the FPU if we are going to preload the FPU
-- 
1.8.4.5

