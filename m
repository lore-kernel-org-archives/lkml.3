Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3JHHrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:47:10 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:58582 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3JHHrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:47:01 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mundt <paul.mundt@gmail.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, <linux-sh@vger.kernel.org>
Subject: [PATCH v2 1/3] sh: Move fpu_counter into ARCH specific thread_struct
Date: Tue, 8 Oct 2013 13:16:27 +0530
Message-ID: <1381218389-16585-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
References: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

Only a couple of arches (sh/x86) use fpu_counter in task_struct so it
can be moved out into ARCH specific thread_struct, reducing the size of
task_struct for other arches.

Compile tested sh defconfig + sh4-linux-gcc (4.6.3)

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-sh@vger.kernel.org
Cc: Paul Mundt <paul.mundt@gmail.com>
---
 arch/sh/include/asm/fpu.h          |  2 +-
 arch/sh/include/asm/processor_32.h | 10 ++++++++++
 arch/sh/include/asm/processor_64.h | 10 ++++++++++
 arch/sh/kernel/cpu/fpu.c           |  2 +-
 arch/sh/kernel/process_32.c        |  6 +++---
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/sh/include/asm/fpu.h b/arch/sh/include/asm/fpu.h
index 06c4281aab65..09fc2bc8a790 100644
--- a/arch/sh/include/asm/fpu.h
+++ b/arch/sh/include/asm/fpu.h
@@ -46,7 +46,7 @@ static inline void __unlazy_fpu(struct task_struct *tsk, struct pt_regs *regs)
 		save_fpu(tsk);
 		release_fpu(regs);
 	} else
-		tsk->fpu_counter = 0;
+		tsk->thread.fpu_counter = 0;
 }
 
 static inline void unlazy_fpu(struct task_struct *tsk, struct pt_regs *regs)
diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index e699a12cdcca..18e0377f72bb 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -111,6 +111,16 @@ struct thread_struct {
 
 	/* Extended processor state */
 	union thread_xstate *xstate;
+
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
 };
 
 #define INIT_THREAD  {						\
diff --git a/arch/sh/include/asm/processor_64.h b/arch/sh/include/asm/processor_64.h
index 1cc7d3197143..eedd4f625d07 100644
--- a/arch/sh/include/asm/processor_64.h
+++ b/arch/sh/include/asm/processor_64.h
@@ -126,6 +126,16 @@ struct thread_struct {
 
 	/* floating point info */
 	union thread_xstate *xstate;
+
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
 };
 
 #define INIT_MMAP \
diff --git a/arch/sh/kernel/cpu/fpu.c b/arch/sh/kernel/cpu/fpu.c
index f8f7af51c128..4e332244ea75 100644
--- a/arch/sh/kernel/cpu/fpu.c
+++ b/arch/sh/kernel/cpu/fpu.c
@@ -44,7 +44,7 @@ void __fpu_state_restore(void)
 	restore_fpu(tsk);
 
 	task_thread_info(tsk)->status |= TS_USEDFPU;
-	tsk->fpu_counter++;
+	tsk->thread.fpu_counter++;
 }
 
 void fpu_state_restore(struct pt_regs *regs)
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index ebd3933005b4..2885fc9d9dcd 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 #endif
 		ti->addr_limit = KERNEL_DS;
 		ti->status &= ~TS_USEDFPU;
-		p->fpu_counter = 0;
+		p->thread.fpu_counter = 0;
 		return 0;
 	}
 	*childregs = *current_pt_regs();
@@ -189,7 +189,7 @@ __switch_to(struct task_struct *prev, struct task_struct *next)
 	unlazy_fpu(prev, task_pt_regs(prev));
 
 	/* we're going to use this soon, after a few expensive things */
-	if (next->fpu_counter > 5)
+	if (next->thread.fpu_counter > 5)
 		prefetch(next_t->xstate);
 
 #ifdef CONFIG_MMU
@@ -207,7 +207,7 @@ __switch_to(struct task_struct *prev, struct task_struct *next)
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
 	 */
-	if (next->fpu_counter > 5)
+	if (next->thread.fpu_counter > 5)
 		__fpu_state_restore();
 
 	return prev;
-- 
1.8.1.2

