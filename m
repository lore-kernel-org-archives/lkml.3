Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbaLBH5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:57:38 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55025 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbaLBH5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:57:34 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        shuahkh@osg.samsung.com
Subject: [PATCH V6 3/9] powerpc, ptrace: Enable fpr_(get/set) for transactional memory
Date: Tue,  2 Dec 2014 13:26:47 +0530
Message-Id: <1417507013-11948-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120207-0025-0000-0000-000000A28BAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the fpr_get which gets the running value of all
the FPR registers and the fpr_set which sets the running value of
of all the FPR registers to accommodate in transaction ptrace
interface based requests.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/ptrace.c | 110 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 104 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index f21897b..2de3b2c 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -357,6 +357,36 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 	return ret;
 }
 
+
+/**
+ * fpr_get - get FPR registers
+ * @target:	The target task.
+ * @regset:	The user regset structure.
+ * @pos:	The buffer position.
+ * @count:	Number of bytes to copy.
+ * @kbuf:	Kernel buffer to copy from.
+ * @ubuf:	User buffer to copy into.
+ *
+ * When the transaction is active, 'transact_fp' holds the current running
+ * value of all FPR registers and 'fp_state' holds the last checkpointed
+ * value of all FPR registers for the current transaction. When transaction
+ * is not active 'fp_state' holds the current running state of all the FPR
+ * registers. So this function which returns the current running values of
+ * all the FPR registers, needs to know whether any transaction is active
+ * or not. The userspace interface buffer layout is as follows.
+ *
+ * struct data {
+ *	u64	fpr[32];
+ *	u64	fpscr;
+ * };
+ *
+ * There are two config options CONFIG_VSX and CONFIG_PPC_TRANSACTIONAL_MEM
+ * which determines the final code in this function. All the combinations of
+ * these two config options are possible except the one below as transactional
+ * memory config pulls in CONFIG_VSX automatically.
+ *
+ *	!defined(CONFIG_VSX) && defined(CONFIG_PPC_TRANSACTIONAL_MEM)
+ */
 static int fpr_get(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count,
 		   void *kbuf, void __user *ubuf)
@@ -367,22 +397,68 @@ static int fpr_get(struct task_struct *target, const struct user_regset *regset,
 #endif
 	flush_fp_to_thread(target);
 
-#ifdef CONFIG_VSX
+#if defined(CONFIG_VSX) && defined(CONFIG_PPC_TRANSACTIONAL_MEM)
+	/* copy to local buffer then write that out */
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_altivec_to_thread(target);
+		flush_tmregs_to_thread(target);
+		for (i = 0; i < 32 ; i++)
+			buf[i] = target->thread.TS_TRANS_FPR(i);
+		buf[32] = target->thread.transact_fp.fpscr;
+	} else {
+		for (i = 0; i < 32 ; i++)
+			buf[i] = target->thread.TS_FPR(i);
+		buf[32] = target->thread.fp_state.fpscr;
+	}
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+#endif
+
+#if defined(CONFIG_VSX) && !defined(CONFIG_PPC_TRANSACTIONAL_MEM)
 	/* copy to local buffer then write that out */
 	for (i = 0; i < 32 ; i++)
 		buf[i] = target->thread.TS_FPR(i);
 	buf[32] = target->thread.fp_state.fpscr;
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+#endif
 
-#else
+
+#if !defined(CONFIG_VSX) && !defined(CONFIG_PPC_TRANSACTIONAL_MEM)
 	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
 		     offsetof(struct thread_fp_state, fpr[32][0]));
-
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.fp_state, 0, -1);
 #endif
 }
 
+/**
+ * fpr_set - set FPR registers
+ * @target:	The target task.
+ * @regset:	The user regset structure.
+ * @pos:	The buffer position.
+ * @count:	Number of bytes to copy.
+ * @kbuf:	Kernel buffer to copy into.
+ * @ubuf:	User buffer to copy from.
+ *
+ * When the transaction is active, 'transact_fp' holds the current running
+ * value of all FPR registers and 'fp_state' holds the last checkpointed
+ * value of all FPR registers for the current transaction. When transaction
+ * is not active 'fp_state' holds the current running state of all the FPR
+ * registers. So this function which setss the current running values of
+ * all the FPR registers, needs to know whether any transaction is active
+ * or not. The userspace interface buffer layout is as follows.
+ *
+ * struct data {
+ *	u64	fpr[32];
+ *	u64	fpscr;
+ * };
+ *
+ * There are two config options CONFIG_VSX and CONFIG_PPC_TRANSACTIONAL_MEM
+ * which determines the final code in this function. All the combinations of
+ * these two config options are possible except the one below as transactional
+ * memory config pulls in CONFIG_VSX automatically.
+ *
+ *	!defined(CONFIG_VSX) && defined(CONFIG_PPC_TRANSACTIONAL_MEM)
+ */
 static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count,
 		   const void *kbuf, const void __user *ubuf)
@@ -393,7 +469,27 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 #endif
 	flush_fp_to_thread(target);
 
-#ifdef CONFIG_VSX
+#if defined(CONFIG_VSX) && defined(CONFIG_PPC_TRANSACTIONAL_MEM)
+	/* copy to local buffer then write that out */
+	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+	if (i)
+		return i;
+
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_altivec_to_thread(target);
+		flush_tmregs_to_thread(target);
+		for (i = 0; i < 32 ; i++)
+			target->thread.TS_TRANS_FPR(i) = buf[i];
+		target->thread.transact_fp.fpscr = buf[32];
+	} else {
+		for (i = 0; i < 32 ; i++)
+			target->thread.TS_FPR(i) = buf[i];
+		target->thread.fp_state.fpscr = buf[32];
+	}
+	return 0;
+#endif
+
+#if defined(CONFIG_VSX) && !defined(CONFIG_PPC_TRANSACTIONAL_MEM)
 	/* copy to local buffer then write that out */
 	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
 	if (i)
@@ -402,12 +498,14 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 		target->thread.TS_FPR(i) = buf[i];
 	target->thread.fp_state.fpscr = buf[32];
 	return 0;
-#else
+#endif
+
+#if !defined(CONFIG_VSX) && !defined(CONFIG_PPC_TRANSACTIONAL_MEM)
 	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
 		     offsetof(struct thread_fp_state, fpr[32][0]));
-
 	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				  &target->thread.fp_state, 0, -1);
+
 #endif
 }
 
-- 
1.9.3

