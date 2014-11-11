Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaKKF1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:27:12 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52730 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaKKF1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:27:08 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com
Subject: [PATCH V4 3/8] powerpc, process: Merge functions __switch_to_tm and tm_reclaim_task
Date: Tue, 11 Nov 2014 10:56:32 +0530
Message-Id: <1415683597-22819-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111105-0029-0000-0000-00000091F1A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function tm_reclaim_task is only called from the function
 __switch_to_tm. This patch merges these two functions to make
it more readable without changing the functionality in any way.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/process.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index c36477b..99b41ed 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -585,6 +585,10 @@ static inline void tm_reclaim_task(struct task_struct *tsk)
 	 */
 	struct thread_struct *thr = &tsk->thread;
 
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return;
+	tm_enable();
+
 	if (!thr->regs)
 		return;
 
@@ -696,14 +700,6 @@ static inline void tm_recheckpoint_new_task(struct task_struct *new)
 		 new->pid, mfmsr());
 }
 
-static inline void __switch_to_tm(struct task_struct *prev)
-{
-	if (cpu_has_feature(CPU_FTR_TM)) {
-		tm_enable();
-		tm_reclaim_task(prev);
-	}
-}
-
 /*
  * This is called if we are on the way out to userspace and the
  * TIF_RESTORE_TM flag is set.  It checks if we need to reload
@@ -742,13 +738,13 @@ void restore_tm_state(struct pt_regs *regs)
 
 #else
 #define tm_recheckpoint_new_task(new)
-#define __switch_to_tm(prev)
+#define tm_reclaim_task(prev)
 #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
 
 /*
  * flush_tm_state
  *
- * Flush TM state out so we can copy it.  __switch_to_tm() does this
+ * Flush TM state out so we can copy it.  tm_reclaim_task() does this
  * flush but it removes the checkpointed state from the current CPU and
  * transitions the CPU out of TM mode.  Hence we need to call
  * tm_recheckpoint_new_task() (on the same task) to restore the
@@ -756,7 +752,7 @@ void restore_tm_state(struct pt_regs *regs)
  */
 static void flush_tm_state(struct task_struct *src)
 {
-	__switch_to_tm(src);
+	tm_reclaim_task(src);
 	tm_recheckpoint_new_task(src);
 }
 
@@ -805,7 +801,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	 */
 	save_early_sprs(&prev->thread);
 
-	__switch_to_tm(prev);
+	tm_reclaim_task(prev);
 
 #ifdef CONFIG_SMP
 	/* avoid complexity of lazy save/restore of fpu
-- 
1.9.3

