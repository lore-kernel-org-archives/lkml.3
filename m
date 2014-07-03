Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030805AbaGCJt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:49:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184AbaGCJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sam Bobroff <sam.bobroff@au1.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 119/198] powerpc: Correct DSCR during TM context switch
Date: Thu,  3 Jul 2014 10:19:22 +0100
Message-Id: <1404379241-8590-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam bobroff <sam.bobroff@au1.ibm.com>

commit 96d016108640bc2b7fb0ee800737f80923847294 upstream.

Correct the DSCR SPR becoming temporarily corrupted if a task is
context switched during a transaction.

The problem occurs while suspending the task and is caused by saving
the DSCR to thread.dscr after it has already been set to the CPU's
default value:

__switch_to() calls __switch_to_tm()
	which calls tm_reclaim_task()
	which calls tm_reclaim_thread()
	which calls tm_reclaim()
		where the DSCR is set to the CPU's default
__switch_to() calls _switch()
		where thread.dscr is set to the DSCR

When the task is resumed, it's transaction will be doomed (as usual)
and the DSCR SPR will be corrupted, although the checkpointed value
will be correct. Therefore the DSCR will be immediately corrected by
the transaction aborting, unless it has been suspended. In that case
the incorrect value can be seen by the task until it resumes the
transaction.

The fix is to treat the DSCR similarly to the TAR and save it early
in __switch_to().

A program exposing the problem is added to the kernel self tests as:
tools/testing/selftests/powerpc/tm/tm-resched-dscr.

Signed-off-by: Sam Bobroff <sam.bobroff@au1.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/include/asm/switch_to.h               |  6 +-
 arch/powerpc/kernel/entry_64.S                     |  6 --
 arch/powerpc/kernel/process.c                      |  8 +-
 tools/testing/selftests/powerpc/Makefile           |  2 +-
 tools/testing/selftests/powerpc/tm/Makefile        | 15 ++++
 .../testing/selftests/powerpc/tm/tm-resched-dscr.c | 90 ++++++++++++++++++++++
 6 files changed, 114 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/powerpc/tm/Makefile
 create mode 100644 tools/testing/selftests/powerpc/tm/tm-resched-dscr.c

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 294c2cedcf7a..671c58f4eb44 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -16,13 +16,15 @@ struct thread_struct;
 extern struct task_struct *_switch(struct thread_struct *prev,
 				   struct thread_struct *next);
 #ifdef CONFIG_PPC_BOOK3S_64
-static inline void save_tar(struct thread_struct *prev)
+static inline void save_early_sprs(struct thread_struct *prev)
 {
 	if (cpu_has_feature(CPU_FTR_ARCH_207S))
 		prev->tar = mfspr(SPRN_TAR);
+	if (cpu_has_feature(CPU_FTR_DSCR))
+		prev->dscr = mfspr(SPRN_DSCR);
 }
 #else
-static inline void save_tar(struct thread_struct *prev) {}
+static inline void save_early_sprs(struct thread_struct *prev) {}
 #endif
 
 extern void giveup_fpu(struct task_struct *);
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 2bd0b885b0fe..062178a9d158 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -431,12 +431,6 @@ BEGIN_FTR_SECTION
 	std	r24,THREAD_VRSAVE(r3)
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 #endif /* CONFIG_ALTIVEC */
-#ifdef CONFIG_PPC64
-BEGIN_FTR_SECTION
-	mfspr	r25,SPRN_DSCR
-	std	r25,THREAD_DSCR(r3)
-END_FTR_SECTION_IFSET(CPU_FTR_DSCR)
-#endif
 	and.	r0,r0,r22
 	beq+	1f
 	andc	r22,r22,r0
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index db9d5540f76f..a78a370748b6 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -622,15 +622,15 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	struct ppc64_tlb_batch *batch;
 #endif
 
-	/* Back up the TAR across context switches.
+	/* Back up the TAR and DSCR across context switches.
 	 * Note that the TAR is not available for use in the kernel.  (To
 	 * provide this, the TAR should be backed up/restored on exception
 	 * entry/exit instead, and be in pt_regs.  FIXME, this should be in
 	 * pt_regs anyway (for debug).)
-	 * Save the TAR here before we do treclaim/trecheckpoint as these
-	 * will change the TAR.
+	 * Save the TAR and DSCR here before we do treclaim/trecheckpoint as
+	 * these will change them.
 	 */
-	save_tar(&prev->thread);
+	save_early_sprs(&prev->thread);
 
 	__switch_to_tm(prev);
 
diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index b315740e4cd9..436953b1719c 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -13,7 +13,7 @@ CFLAGS := -Wall -O2 -flto -Wall -Werror -DGIT_VERSION='"$(GIT_VERSION)"' -I$(CUR
 
 export CC CFLAGS
 
-TARGETS =
+TARGETS = tm
 
 endif
 
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
new file mode 100644
index 000000000000..51267f4184a6
--- /dev/null
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -0,0 +1,15 @@
+PROGS := tm-resched-dscr
+
+all: $(PROGS)
+
+$(PROGS):
+
+run_tests: all
+	@-for PROG in $(PROGS); do \
+		./$$PROG; \
+	done;
+
+clean:
+	rm -f $(PROGS) *.o
+
+.PHONY: all run_tests clean
diff --git a/tools/testing/selftests/powerpc/tm/tm-resched-dscr.c b/tools/testing/selftests/powerpc/tm/tm-resched-dscr.c
new file mode 100644
index 000000000000..ee98e3886af2
--- /dev/null
+++ b/tools/testing/selftests/powerpc/tm/tm-resched-dscr.c
@@ -0,0 +1,90 @@
+/* Test context switching to see if the DSCR SPR is correctly preserved
+ * when within a transaction.
+ *
+ * Note: We assume that the DSCR has been left at the default value (0)
+ * for all CPUs.
+ *
+ * Method:
+ *
+ * Set a value into the DSCR.
+ *
+ * Start a transaction, and suspend it (*).
+ *
+ * Hard loop checking to see if the transaction has become doomed.
+ *
+ * Now that we *may* have been preempted, record the DSCR and TEXASR SPRS.
+ *
+ * If the abort was because of a context switch, check the DSCR value.
+ * Otherwise, try again.
+ *
+ * (*) If the transaction is not suspended we can't see the problem because
+ * the transaction abort handler will restore the DSCR to it's checkpointed
+ * value before we regain control.
+ */
+
+#include <inttypes.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <asm/tm.h>
+
+#define TBEGIN          ".long 0x7C00051D ;"
+#define TEND            ".long 0x7C00055D ;"
+#define TCHECK          ".long 0x7C00059C ;"
+#define TSUSPEND        ".long 0x7C0005DD ;"
+#define TRESUME         ".long 0x7C2005DD ;"
+#define SPRN_TEXASR     0x82
+#define SPRN_DSCR       0x03
+
+int main(void) {
+	uint64_t rv, dscr1 = 1, dscr2, texasr;
+
+	printf("Check DSCR TM context switch: ");
+	fflush(stdout);
+	for (;;) {
+		rv = 1;
+		asm __volatile__ (
+			/* set a known value into the DSCR */
+			"ld      3, %[dscr1];"
+			"mtspr   %[sprn_dscr], 3;"
+
+			/* start and suspend a transaction */
+			TBEGIN
+			"beq     1f;"
+			TSUSPEND
+
+			/* hard loop until the transaction becomes doomed */
+			"2: ;"
+			TCHECK
+			"bc      4, 0, 2b;"
+
+			/* record DSCR and TEXASR */
+			"mfspr   3, %[sprn_dscr];"
+			"std     3, %[dscr2];"
+			"mfspr   3, %[sprn_texasr];"
+			"std     3, %[texasr];"
+
+			TRESUME
+			TEND
+			"li      %[rv], 0;"
+			"1: ;"
+			: [rv]"=r"(rv), [dscr2]"=m"(dscr2), [texasr]"=m"(texasr)
+			: [dscr1]"m"(dscr1)
+			, [sprn_dscr]"i"(SPRN_DSCR), [sprn_texasr]"i"(SPRN_TEXASR)
+			: "memory", "r3"
+		);
+		assert(rv); /* make sure the transaction aborted */
+		if ((texasr >> 56) != TM_CAUSE_RESCHED) {
+			putchar('.');
+			fflush(stdout);
+			continue;
+		}
+		if (dscr2 != dscr1) {
+			printf(" FAIL\n");
+			exit(EXIT_FAILURE);
+		} else {
+			printf(" OK\n");
+			exit(EXIT_SUCCESS);
+		}
+	}
+}
-- 
1.9.1

