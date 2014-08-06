Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaHFM47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:56:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbaHFMzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:55:52 -0400
From: Mel Gorman <mgorman@suse.de>
To: H Peter Anvin <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <mgalbraith@suse.de>, Linux-X86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/3] x86, fpu: Do not copy fpu preload state
Date: Wed,  6 Aug 2014 13:55:46 +0100
Message-Id: <1407329748-3928-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407329748-3928-1-git-send-email-mgorman@suse.de>
References: <1407329748-3928-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__switch_to declares a fpu_switch_t on the stack then calls a prepare
function which declares a second one on the stack and copies the result
back. As the functions are inline the compiler will optimise it correctly
but it looks weird. This patch makes it clear that a single instance of
fpu_switch_t is used.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/include/asm/fpu-internal.h | 14 ++++++--------
 arch/x86/kernel/process_32.c        |  2 +-
 arch/x86/kernel/process_64.c        |  2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 115e368..b8771c4a 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -416,15 +416,14 @@ static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 		cpu == new->thread.fpu.last_cpu;
 }
 
-static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
+static inline void switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu,
+						fpu_switch_t *fpu)
 {
-	fpu_switch_t fpu;
-
 	/*
 	 * If the task has used the math, pre-load the FPU on xsave processors
 	 * or if the past 5 consecutive context-switches used math.
 	 */
-	fpu.preload = tsk_used_math(new) && (use_eager_fpu() ||
+	fpu->preload = tsk_used_math(new) && (use_eager_fpu() ||
 					     new->thread.fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
@@ -433,7 +432,7 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
 
 		/* Don't change CR0.TS if we just switch! */
-		if (fpu.preload) {
+		if (fpu->preload) {
 			new->thread.fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
@@ -442,16 +441,15 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 	} else {
 		old->thread.fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
-		if (fpu.preload) {
+		if (fpu->preload) {
 			new->thread.fpu_counter++;
 			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
-				fpu.preload = 0;
+				fpu->preload = 0;
 			else
 				prefetch(new->thread.fpu.state);
 			__thread_fpu_begin(new);
 		}
 	}
-	return fpu;
 }
 
 /*
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7bc86bb..260ed717 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -257,7 +257,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
 
-	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
+	switch_fpu_prepare(prev_p, next_p, cpu, &fpu);
 
 	/*
 	 * Reload esp0.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca5b02d..b155462 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -284,7 +284,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	unsigned fsindex, gsindex;
 	fpu_switch_t fpu;
 
-	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
+	switch_fpu_prepare(prev_p, next_p, cpu, &fpu);
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
-- 
1.8.4.5

