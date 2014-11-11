Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaKKF1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:27:10 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40846 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKKF1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:27:06 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com
Subject: [PATCH V4 2/8] powerpc, process: Add functions flush_tm_state, flush_tmregs_to_thread
Date: Tue, 11 Nov 2014 10:56:31 +0530
Message-Id: <1415683597-22819-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111105-0025-0000-0000-00000079DD73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a new function called flush_tm_state to flush
the existing transactional memory state from the thread. It also
creates a function called flush_tmregs_to_thread which will then
be used on subsequent patches in this series.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/switch_to.h |  8 ++++++
 arch/powerpc/kernel/process.c        | 49 +++++++++++++++++++++++++++++-------
 2 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 58abeda..23752a9 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -82,6 +82,14 @@ static inline void flush_spe_to_thread(struct task_struct *t)
 }
 #endif
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+extern void flush_tmregs_to_thread(struct task_struct *);
+#else
+static inline void flush_tmregs_to_thread(struct task_struct *t)
+{
+}
+#endif
+
 static inline void clear_task_ebb(struct task_struct *t)
 {
 #ifdef CONFIG_PPC_BOOK3S_64
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index aa1df89..c36477b 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -745,6 +745,45 @@ void restore_tm_state(struct pt_regs *regs)
 #define __switch_to_tm(prev)
 #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
 
+/*
+ * flush_tm_state
+ *
+ * Flush TM state out so we can copy it.  __switch_to_tm() does this
+ * flush but it removes the checkpointed state from the current CPU and
+ * transitions the CPU out of TM mode.  Hence we need to call
+ * tm_recheckpoint_new_task() (on the same task) to restore the
+ * checkpointed state back and the TM mode.
+ */
+static void flush_tm_state(struct task_struct *src)
+{
+	__switch_to_tm(src);
+	tm_recheckpoint_new_task(src);
+}
+
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+void flush_tmregs_to_thread(struct task_struct *tsk)
+{
+	/*
+	 * If task is not current, it should have been flushed
+	 * already to it's thread_struct during __switch_to().
+	 */
+	if (tsk != current)
+		return;
+
+	preempt_disable();
+	if (tsk->thread.regs) {
+		/*
+		 * If we are still current, the TM state need to
+		 * be flushed to thread_struct as it will be still
+		 * present in the current cpu.
+		 */
+		if (MSR_TM_ACTIVE(tsk->thread.regs->msr))
+			flush_tm_state(tsk);
+	}
+	preempt_enable();
+}
+#endif
+
 struct task_struct *__switch_to(struct task_struct *prev,
 	struct task_struct *new)
 {
@@ -1079,15 +1118,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	flush_altivec_to_thread(src);
 	flush_vsx_to_thread(src);
 	flush_spe_to_thread(src);
-	/*
-	 * Flush TM state out so we can copy it.  __switch_to_tm() does this
-	 * flush but it removes the checkpointed state from the current CPU and
-	 * transitions the CPU out of TM mode.  Hence we need to call
-	 * tm_recheckpoint_new_task() (on the same task) to restore the
-	 * checkpointed state back and the TM mode.
-	 */
-	__switch_to_tm(src);
-	tm_recheckpoint_new_task(src);
+	flush_tm_state(src);
 
 	*dst = *src;
 
-- 
1.9.3

