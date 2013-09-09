Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3IIJQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:16:02 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:34253 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3IIJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:15:59 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-mm@kvack.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Michel Lespinasse <walken@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/3] sh: Move fpu_counter into ARCH specific thread_struct
Date: Mon, 9 Sep 2013 14:45:21 +0530
Message-ID: <1378718123-7372-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only a couple of arches (sh/x86) use fpu_counter in task_struct so it
can be moved out into ARCH specific thread_struct, reducing the size of
task_struct for other arches.

Compile tested sh defconfig + sh4-linux-gcc (4.6.3)

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
---
 arch/sh/include/asm/fpu.h          |  2 +-
 arch/sh/include/asm/processor_32.h | 10 ++++++++++
 arch/sh/include/asm/processor_64.h | 10 ++++++++++
 arch/sh/kernel/cpu/fpu.c           |  2 +-
 arch/sh/kernel/process_32.c        |  6 +++---
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/sh/include/asm/fpu.h b/arch/sh/include/asm/fpu.h
index 06c4281..09fc2bc 100644
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
index e699a12..18e0377 100644
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
index 1cc7d31..eedd4f6 100644
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
index f8f7af5..4e33224 100644
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
index ebd3933..2885fc9 100644
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

