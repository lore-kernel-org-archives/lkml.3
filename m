Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbaEMKSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:18:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933595AbaEMKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 136/182] powerpc/tm: Disable IRQ in tm_recheckpoint
Date: Tue, 13 May 2014 11:28:08 +0200
Message-Id: <1a5cfb23d549da509c9a67b41231dc62e51f376c.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e6b8fd028b584ffca7a7255b8971f254932c9fce upstream.

We can't take an IRQ when we're about to do a trechkpt as our GPR state is set
to user GPR values.

We've hit this when running some IBM Java stress tests in the lab resulting in
the following dump:

  cpu 0x3f: Vector: 700 (Program Check) at [c000000007eb3d40]
      pc: c000000000050074: restore_gprs+0xc0/0x148
      lr: 00000000b52a8184
      sp: ac57d360
     msr: 8000000100201030
    current = 0xc00000002c500000
    paca    = 0xc000000007dbfc00     softe: 0     irq_happened: 0x00
      pid   = 34535, comm = Pooled Thread #
  R00 = 00000000b52a8184   R16 = 00000000b3e48fda
  R01 = 00000000ac57d360   R17 = 00000000ade79bd8
  R02 = 00000000ac586930   R18 = 000000000fac9bcc
  R03 = 00000000ade60000   R19 = 00000000ac57f930
  R04 = 00000000f6624918   R20 = 00000000ade79be8
  R05 = 00000000f663f238   R21 = 00000000ac218a54
  R06 = 0000000000000002   R22 = 000000000f956280
  R07 = 0000000000000008   R23 = 000000000000007e
  R08 = 000000000000000a   R24 = 000000000000000c
  R09 = 00000000b6e69160   R25 = 00000000b424cf00
  R10 = 0000000000000181   R26 = 00000000f66256d4
  R11 = 000000000f365ec0   R27 = 00000000b6fdcdd0
  R12 = 00000000f66400f0   R28 = 0000000000000001
  R13 = 00000000ada71900   R29 = 00000000ade5a300
  R14 = 00000000ac2185a8   R30 = 00000000f663f238
  R15 = 0000000000000004   R31 = 00000000f6624918
  pc  = c000000000050074 restore_gprs+0xc0/0x148
  cfar= c00000000004fe28 dont_restore_vec+0x1c/0x1a4
  lr  = 00000000b52a8184
  msr = 8000000100201030   cr  = 24804888
  ctr = 0000000000000000   xer = 0000000000000000   trap =  700

This moves tm_recheckpoint to a C function and moves the tm_restore_sprs into
that function.  It then adds IRQ disabling over the trechkpt critical section.
It also sets the TEXASR FS in the signals code to ensure this is never set now
that we explictly write the TM sprs in tm_recheckpoint.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/include/asm/reg.h  |  1 +
 arch/powerpc/kernel/process.c   | 34 ++++++++++++++++++++++++++++------
 arch/powerpc/kernel/signal_32.c |  2 ++
 arch/powerpc/kernel/signal_64.c |  2 ++
 arch/powerpc/kernel/tm.S        |  2 +-
 5 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 7ca729cac073..cb9c1740cee0 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -208,6 +208,7 @@
 #define SPRN_ACOP	0x1F	/* Available Coprocessor Register */
 #define SPRN_TFIAR	0x81	/* Transaction Failure Inst Addr   */
 #define SPRN_TEXASR	0x82	/* Transaction EXception & Summary */
+#define   TEXASR_FS	__MASK(63-36)	/* Transaction Failure Summary */
 #define SPRN_TEXASRU	0x83	/* ''	   ''	   ''	 Upper 32  */
 #define SPRN_TFHAR	0x80	/* Transaction Failure Handler Addr */
 #define SPRN_CTRLF	0x088
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index aa75b2beba7d..f1106103634b 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -525,6 +525,31 @@ out_and_saveregs:
 	tm_save_sprs(thr);
 }
 
+extern void __tm_recheckpoint(struct thread_struct *thread,
+			      unsigned long orig_msr);
+
+void tm_recheckpoint(struct thread_struct *thread,
+		     unsigned long orig_msr)
+{
+	unsigned long flags;
+
+	/* We really can't be interrupted here as the TEXASR registers can't
+	 * change and later in the trecheckpoint code, we have a userspace R1.
+	 * So let's hard disable over this region.
+	 */
+	local_irq_save(flags);
+	hard_irq_disable();
+
+	/* The TM SPRs are restored here, so that TEXASR.FS can be set
+	 * before the trecheckpoint and no explosion occurs.
+	 */
+	tm_restore_sprs(thread);
+
+	__tm_recheckpoint(thread, orig_msr);
+
+	local_irq_restore(flags);
+}
+
 static inline void tm_recheckpoint_new_task(struct task_struct *new)
 {
 	unsigned long msr;
@@ -543,13 +568,10 @@ static inline void tm_recheckpoint_new_task(struct task_struct *new)
 	if (!new->thread.regs)
 		return;
 
-	/* The TM SPRs are restored here, so that TEXASR.FS can be set
-	 * before the trecheckpoint and no explosion occurs.
-	 */
-	tm_restore_sprs(&new->thread);
-
-	if (!MSR_TM_ACTIVE(new->thread.regs->msr))
+	if (!MSR_TM_ACTIVE(new->thread.regs->msr)){
+		tm_restore_sprs(&new->thread);
 		return;
+	}
 	msr = new->thread.tm_orig_msr;
 	/* Recheckpoint to restore original checkpointed register state. */
 	TM_DEBUG("*** tm_recheckpoint of pid %d "
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index fea2dba1226c..50606e4261a1 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -872,6 +872,8 @@ static long restore_tm_user_regs(struct pt_regs *regs,
 	 * transactional versions should be loaded.
 	 */
 	tm_enable();
+	/* Make sure the transaction is marked as failed */
+	current->thread.tm_texasr |= TEXASR_FS;
 	/* This loads the checkpointed FP/VEC state, if used */
 	tm_recheckpoint(&current->thread, msr);
 	/* Get the top half of the MSR */
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 36b1d1daa236..4456779dba1c 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -519,6 +519,8 @@ static long restore_tm_sigcontexts(struct pt_regs *regs,
 	}
 #endif
 	tm_enable();
+	/* Make sure the transaction is marked as failed */
+	current->thread.tm_texasr |= TEXASR_FS;
 	/* This loads the checkpointed FP/VEC state, if used */
 	tm_recheckpoint(&current->thread, msr);
 
diff --git a/arch/powerpc/kernel/tm.S b/arch/powerpc/kernel/tm.S
index cd809eaa8b5c..8b0518519f9f 100644
--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -306,7 +306,7 @@ dont_backup_fp:
 	 *	Call with IRQs off, stacks get all out of sync for
 	 *	some periods in here!
 	 */
-_GLOBAL(tm_recheckpoint)
+_GLOBAL(__tm_recheckpoint)
 	mfcr	r5
 	mflr	r0
 	std	r5, 8(r1)
-- 
1.9.3

