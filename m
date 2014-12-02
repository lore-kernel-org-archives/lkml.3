Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbaLBH5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:57:45 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40353 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbaLBH5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:57:41 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        shuahkh@osg.samsung.com
Subject: [PATCH V6 4/9] powerpc, ptrace: Enable vr_(get/set) for transactional memory
Date: Tue,  2 Dec 2014 13:26:48 +0530
Message-Id: <1417507013-11948-5-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120207-0029-0000-0000-000000BA4C61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the vr_get which gets the running value of all
the VMX registers and the vr_set which sets the running value of
of all the VMX registers to accommodate in transaction ptrace
interface based requests.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/ptrace.c | 104 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 101 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 2de3b2c..5398c6e 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -530,10 +530,35 @@ static int vr_active(struct task_struct *target,
 	return target->thread.used_vr ? regset->n : 0;
 }
 
+/**
+ * vr_get - get VR registers
+ * @target:	The target task.
+ * @regset:	The user regset structure.
+ * @pos:	The buffer position.
+ * @count:	Number of bytes to copy.
+ * @kbuf:	Kernel buffer to copy from.
+ * @ubuf:	User buffer to copy into.
+ *
+ * When the transaction is active, 'transact_vr' holds the current running
+ * value of all the VMX registers and 'vr_state' holds the last checkpointed
+ * value of all the VMX registers for the current transaction to fall back
+ * on in case it aborts. When transaction is not active 'vr_state' holds
+ * the current running state of all the VMX registers. So this function which
+ * gets the current running values of all the VMX registers, needs to know
+ * whether any transaction is active or not. The userspace interface buffer
+ * layout is as follows.
+ *
+ * struct data {
+ *	vector128	vr[32];
+ *	vector128	vscr;
+ *	vector128	vrsave;
+ * };
+ */
 static int vr_get(struct task_struct *target, const struct user_regset *regset,
 		  unsigned int pos, unsigned int count,
 		  void *kbuf, void __user *ubuf)
 {
+	struct thread_vr_state *addr;
 	int ret;
 
 	flush_altivec_to_thread(target);
@@ -541,8 +566,19 @@ static int vr_get(struct task_struct *target, const struct user_regset *regset,
 	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
 		     offsetof(struct thread_vr_state, vr[32]));
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_fp_to_thread(target);
+		flush_tmregs_to_thread(target);
+		addr = &target->thread.transact_vr;
+	} else {
+		addr = &target->thread.vr_state;
+	}
+#else
+	addr = &target->thread.vr_state;
+#endif
 	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.vr_state, 0,
+				  addr, 0,
 				  33 * sizeof(vector128));
 	if (!ret) {
 		/*
@@ -553,7 +589,16 @@ static int vr_get(struct task_struct *target, const struct user_regset *regset,
 			u32 word;
 		} vrsave;
 		memset(&vrsave, 0, sizeof(vrsave));
+
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+		if (MSR_TM_ACTIVE(target->thread.regs->msr))
+			vrsave.word = target->thread.transact_vrsave;
+		else
+			vrsave.word = target->thread.vrsave;
+#else
 		vrsave.word = target->thread.vrsave;
+#endif
+
 		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
 					  33 * sizeof(vector128), -1);
 	}
@@ -561,10 +606,35 @@ static int vr_get(struct task_struct *target, const struct user_regset *regset,
 	return ret;
 }
 
+/**
+ * vr_set - set VR registers
+ * @target:	The target task.
+ * @regset:	The user regset structure.
+ * @pos:	The buffer position.
+ * @count:	Number of bytes to copy.
+ * @kbuf:	Kernel buffer to copy into.
+ * @ubuf:	User buffer to copy from.
+ *
+ * When the transaction is active, 'transact_vr' holds the current running
+ * value of all the VMX registers and 'vr_state' holds the last checkpointed
+ * value of all the VMX registers for the current transaction to fall back
+ * on in case it aborts. When transaction is not active 'vr_state' holds
+ * the current running state of all the VMX registers. So this function which
+ * sets the current running values of all the VMX registers, needs to know
+ * whether any transaction is active or not. The userspace interface buffer
+ * layout is as follows.
+ *
+ * struct data {
+ *	vector128	vr[32];
+ *	vector128	vscr;
+ *	vector128	vrsave;
+ * };
+ */
 static int vr_set(struct task_struct *target, const struct user_regset *regset,
 		  unsigned int pos, unsigned int count,
 		  const void *kbuf, const void __user *ubuf)
 {
+	struct thread_vr_state *addr;
 	int ret;
 
 	flush_altivec_to_thread(target);
@@ -572,8 +642,19 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
 	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
 		     offsetof(struct thread_vr_state, vr[32]));
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_fp_to_thread(target);
+		flush_tmregs_to_thread(target);
+		addr = &target->thread.transact_vr;
+	} else {
+		addr = &target->thread.vr_state;
+	}
+#else
+	addr = &target->thread.vr_state;
+#endif
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.vr_state, 0,
+				 addr, 0,
 				 33 * sizeof(vector128));
 	if (!ret && count > 0) {
 		/*
@@ -584,11 +665,28 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
 			u32 word;
 		} vrsave;
 		memset(&vrsave, 0, sizeof(vrsave));
+
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+		if (MSR_TM_ACTIVE(target->thread.regs->msr))
+			vrsave.word = target->thread.transact_vrsave;
+		else
+			vrsave.word = target->thread.vrsave;
+#else
 		vrsave.word = target->thread.vrsave;
+#endif
 		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
 					 33 * sizeof(vector128), -1);
-		if (!ret)
+		if (!ret) {
+
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+			if (MSR_TM_ACTIVE(target->thread.regs->msr))
+				target->thread.transact_vrsave = vrsave.word;
+			else
+				target->thread.vrsave = vrsave.word;
+#else
 			target->thread.vrsave = vrsave.word;
+#endif
+		}
 	}
 
 	return ret;
-- 
1.9.3

