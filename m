Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbaLBH55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:57:57 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40427 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbaLBH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:57:54 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        shuahkh@osg.samsung.com
Subject: [PATCH V6 7/9] selftests, powerpc: Add test case for TM related ptrace interface
Date: Tue,  2 Dec 2014 13:26:51 +0530
Message-Id: <1417507013-11948-8-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120207-0029-0000-0000-000000BA4C91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds one more test case called 'tm-ptrace' targeting TM
related ptrace interface. This test creates one child process to
run some basic TM transactions and the parent process attaches the
child to do some ptrace probing using the recently added regset
interfaces. The parent process then compares the received values
against the expected values to verify whether it has passed the
given test or not.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 tools/testing/selftests/powerpc/tm/Makefile    |   2 +-
 tools/testing/selftests/powerpc/tm/tm-ptrace.c | 542 +++++++++++++++++++++++++
 2 files changed, 543 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/powerpc/tm/tm-ptrace.c

diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index 2cede23..71d400a 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -1,4 +1,4 @@
-PROGS := tm-resched-dscr
+PROGS := tm-resched-dscr tm-ptrace
 
 all: $(PROGS)
 
diff --git a/tools/testing/selftests/powerpc/tm/tm-ptrace.c b/tools/testing/selftests/powerpc/tm/tm-ptrace.c
new file mode 100644
index 0000000..7a6c7d3
--- /dev/null
+++ b/tools/testing/selftests/powerpc/tm/tm-ptrace.c
@@ -0,0 +1,542 @@
+/*
+ * Test program for TM ptrace interface
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * Copyright 2014 IBM Corporation
+ *
+ * Author: Anshuman Khandual <khandual@linux.vnet.ibm.com>
+ */
+#include <inttypes.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <malloc.h>
+#include <errno.h>
+#include <sys/ptrace.h>
+#include <sys/uio.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/signal.h>
+#include <sys/user.h>
+#include <linux/elf.h>
+#include <linux/types.h>
+
+#include "utils.h"
+
+#define TEST_PASS 0
+#define TEST_FAIL 1
+
+#define MAX_STR_LENGTH 100
+
+/* ELF core notes */
+#define NT_PPC_TM_SPR  0x103	/* PowerPC TM special registers */
+#define NT_PPC_TM_CGPR 0x104	/* PowerpC TM checkpointed GPR */
+#define NT_PPC_TM_CFPR 0x105	/* PowerPC TM checkpointed FPR */
+#define NT_PPC_TM_CVMX 0x106	/* PowerPC TM checkpointed VMX */
+#define NT_PPC_MISC    0x107	/* PowerPC miscellaneous registers */
+
+/* TM instructions */
+#define TBEGIN		".long 0x7C00051D ;"
+#define TEND		".long 0x7C00055D ;"
+
+/* SPR number */
+#define SPRN_DSCR	3
+#define SPRN_TAR	815
+#define SPRN_PPR	896
+
+#define C_DSCR	10		/* TM checkpointed DSCR */
+#define C_TAR	20		/* TM checkpointed TAR */
+#define C_PPR	0x8000000000000	/* TM checkpointed PPR */
+
+#define DSCR	50		/* TM running DSCR */
+#define TAR	60		/* TM running TAR */
+#define PPR	0x4000000000000	/* TM running PPR */
+
+/* Values for GPR-FPR[0..31] */
+#define VAL0	0
+#define VAL1	1
+#define VAL2	2
+#define VAL3	3
+#define VAL4	4
+#define VAL5	5
+#define VAL6	6
+#define VAL7	7
+#define VAL8	8
+#define VAL9	9
+#define VAL10	10
+#define VAL11	11
+#define VAL12	12
+#define VAL13	13
+#define VAL14	14
+#define VAL15	15
+#define VAL_MAX	16
+
+/* Standard data types */
+typedef unsigned int u32;
+typedef __vector128 vector128;
+
+/* NT_PPC_TM_SPR buffer layout */
+struct tm_spr_regs {
+	u64	tm_tfhar;
+	u64	tm_texasr;
+	u64	tm_tfiar;
+	u64	tm_orig_msr;
+	u64	tm_tar;
+	u64	tm_ppr;
+	u64	tm_dscr;
+};
+
+/*
+ * NT_PPC_TM_CGPR buffer layout
+ *
+ * Same as that of struct pt_regs
+ */
+
+/* NT_PPC_TM_CFPR buffer layout */
+struct tm_cfpr {
+	u64	fpr[32];
+	u64	fpscr;
+};
+
+/* NT_PPC_TM_CVMX buffer layout */
+struct tm_cvmx {
+	vector128	vr[32] __attribute__((aligned(16)));
+	vector128	vscr __attribute__((aligned(16)));
+	u32		vrsave;
+};
+
+/* NT_PPC_MISC buffer layout */
+struct misc_regs {
+	u64	dscr;
+	u64	ppr;
+	u64	tar;
+};
+
+/*
+ * do_tm_transaction
+ *
+ * This functions sets the values for TAR, DSCR, PPR, GPR[0..31],
+ * FPR[0..31] registers before starting the trasanction which will
+ * enable the kernel to save them as checkpointed values. Then it
+ * starts the transaction where it loads a different set of values
+ * into the same registers again thus enabling the kernel to save
+ * them off as running values for this transaction. Then the function
+ * gets stuck forcing the process to loop at one single instruction.
+ * The transaction never finishes, thus giving the parent process
+ * the opportunity to trace the running and checkpointed values of
+ * various registers.
+ */
+void do_tm_transaction(void)
+{
+	asm __volatile__(
+		/* TM checkpointed values */
+
+		/* SPR */
+		"li 0, %[c_tar];"	/* TAR */
+		"mtspr %[sprn_tar], 0;"
+		"li 0, %[c_dscr];"	/* DSCR */
+		"mtspr %[sprn_dscr], 0;"
+		"or	1,1,1;"		/* PPR (0x8000000000000) */
+
+		/* GPR[0..31] */
+		"li 0, %[val0];"	/* GPR[0] */
+		"li 1, %[val1];"	/* GPR[1] */
+		"li 2, %[val2];"	/* GPR[2] */
+		"li 3, %[val3];"	/* GPR[3] */
+		"li 4, %[val4];"	/* GPR[4] */
+		"li 5, %[val5];"	/* GPR[5] */
+		"li 6, %[val6];"	/* GPR[6] */
+		"li 7, %[val7];"	/* GPR[7] */
+		"li 8, %[val8];"	/* GPR[8] */
+		"li 9, %[val9];"	/* GPR[9] */
+		"li 10, %[val10];"	/* GPR[10] */
+		"li 11, %[val11];"	/* GPR[11] */
+		"li 12, %[val12];"	/* GPR[12] */
+		"li 13, %[val13];"	/* GPR[13] */
+		"li 14, %[val14];"	/* GPR[14] */
+		"li 15, %[val15];"	/* GPR[15] */
+		"li 16, %[val0];"	/* GPR[16] */
+		"li 17, %[val1];"	/* GPR[17] */
+		"li 18, %[val2];"	/* GPR[18] */
+		"li 19, %[val3];"	/* GPR[19] */
+		"li 20, %[val4];"	/* GPR[20] */
+		"li 21, %[val5];"	/* GPR[21] */
+		"li 22, %[val6];"	/* GPR[22] */
+		"li 23, %[val7];"	/* GPR[23] */
+		"li 24, %[val8];"	/* GPR[24] */
+		"li 25, %[val9];"	/* GPR[25] */
+		"li 26, %[val10];"	/* GPR[26] */
+		"li 27, %[val11];"	/* GPR[27] */
+		"li 28, %[val12];"	/* GPR[28] */
+		"li 29, %[val13];"	/* GPR[29] */
+		"li 30, %[val14];"	/* GPR[30] */
+		"li 31, %[val15];"	/* GPR[31] */
+
+		/* FPR[0..31] */
+		".long 0x7C000166;"	/* GPR[0] --> FPR[0] */
+		".long 0x7C210166;"	/* GPR[1] --> FPR[1] */
+		".long 0x7C420166;"	/* GPR[0] --> FPR[2] */
+		".long 0x7C630166;"	/* GPR[3] --> FPR[3] */
+		".long 0x7C840166;"	/* GPR[4] --> FPR[4] */
+		".long 0x7CA50166;"	/* GPR[5] --> FPR[5] */
+		".long 0x7CC60166;"	/* GPR[6] --> FPR[6] */
+		".long 0x7CE70166;"	/* GPR[7] --> FPR[7] */
+		".long 0x7D080166;"	/* GPR[8] --> FPR[8] */
+		".long 0x7D290166;"	/* GPR[9] --> FPR[9] */
+		".long 0x7d4a0166;"	/* GPR[10] --> FPR[10] */
+		".long 0x7d6b0166;"	/* GPR[11] --> FPR[11] */
+		".long 0x7d8c0166;"	/* GPR[12] --> FPR[12] */
+		".long 0x7dad0166;"	/* GPR[13] --> FPR[13] */
+		".long 0x7dce0166;"	/* GPR[14] --> FPR[14] */
+		".long 0x7def0166;"	/* GPR[15] --> FPR[15] */
+		".long 0x7e100166;"	/* GPR[16] --> FPR[16] */
+		".long 0x7e310166;"	/* GPR[17] --> FPR[17] */
+		".long 0x7e520166;"	/* GPR[18] --> FPR[18] */
+		".long 0x7e730166;"	/* GPR[19] --> FPR[19] */
+		".long 0x7e940166;"	/* GPR[20] --> FPR[20] */
+		".long 0x7eb50166;"	/* GPR[21] --> FPR[21] */
+		".long 0x7ed60166;"	/* GPR[22] --> FPR[22] */
+		".long 0x7ef70166;"	/* GPR[23] --> FPR[23] */
+		".long 0x7f180166;"	/* GPR[24] --> FPR[24] */
+		".long 0x7f390166;"	/* GPR[25] --> FPR[25] */
+		".long 0x7f5a0166;"	/* GPR[26] --> FPR[26] */
+		".long 0x7f7b0166;"	/* GPR[27] --> FPR[27] */
+		".long 0x7f9c0166;"	/* GPR[28] --> FPR[28] */
+		".long 0x7fbd0166;"	/* GPR[29] --> FPR[29] */
+		".long 0x7fde0166;"	/* GPR[30] --> FPR[30] */
+		".long 0x7fff0166;"	/* GPR[31] --> FPR[31] */
+
+		/* TM running values */
+
+		"1: ;"
+		TBEGIN
+		"beq 2f;"
+
+		/* SPR */
+		"li 0, %[tar];"		/* TAR */
+		"mtspr %[sprn_tar], 0;"
+		"li 0, %[dscr];"	/* DSCR */
+		"mtspr %[sprn_dscr], 0;"
+		"or	31,31,31;"	/* PPR (0x4000000000000) */
+
+		/* GPR[0..31] */
+		"li 0, %[val15];"	/* GPR[0] */
+		"li 1, %[val14];"	/* GPR[1] */
+		"li 2, %[val13];"	/* GPR[2] */
+		"li 3, %[val12];"	/* GPR[3] */
+		"li 4, %[val11];"	/* GPR[4] */
+		"li 5, %[val10];"	/* GPR[5] */
+		"li 6, %[val9];"	/* GPR[6] */
+		"li 7, %[val8];"	/* GPR[7] */
+		"li 8, %[val7];"	/* GPR[8] */
+		"li 9, %[val6];"	/* GPR[9] */
+		"li 10, %[val5];"	/* GPR[10] */
+		"li 11, %[val4];"	/* GPR[11] */
+		"li 12, %[val3];"	/* GPR[12] */
+		"li 13, %[val2];"	/* GPR[13] */
+		"li 14, %[val1];"	/* GPR[14] */
+		"li 15, %[val0];"	/* GPR[15] */
+		"li 16, %[val15];"	/* GPR[16] */
+		"li 17, %[val14];"	/* GPR[17] */
+		"li 18, %[val13];"	/* GPR[18] */
+		"li 19, %[val12];"	/* GPR[19] */
+		"li 20, %[val11];"	/* GPR[20] */
+		"li 21, %[val10];"	/* GPR[21] */
+		"li 22, %[val9];"	/* GPR[22] */
+		"li 23, %[val8];"	/* GPR[23] */
+		"li 24, %[val7];"	/* GPR[24] */
+		"li 25, %[val6];"	/* GPR[25] */
+		"li 26, %[val5];"	/* GPR[26] */
+		"li 27, %[val4];"	/* GPR[27] */
+		"li 28, %[val3];"	/* GPR[28] */
+		"li 29, %[val2];"	/* GPR[29] */
+		"li 30, %[val1];"	/* GPR[30] */
+		"li 31, %[val0];"	/* GPR[31] */
+
+		/* FPR[0..31] */
+		".long 0x7C000166;"	/* GPR[0] --> FPR[0] */
+		".long 0x7C210166;"	/* GPR[1] --> FPR[1] */
+		".long 0x7C420166;"	/* GPR[2] --> FPR[2] */
+		".long 0x7C630166;"	/* GPR[3] --> FPR[3] */
+		".long 0x7C840166;"	/* GPR[4] --> FPR[4] */
+		".long 0x7CA50166;"	/* GPR[5] --> FPR[5] */
+		".long 0x7CC60166;"	/* GPR[6] --> FPR[6] */
+		".long 0x7CE70166;"	/* GPR[7] --> FPR[7] */
+		".long 0x7D080166;"	/* GPR[8] --> FPR[8] */
+		".long 0x7D290166;"	/* GPR[9] --> FPR[9] */
+		".long 0x7d4a0166;"	/* GPR[10] --> FPR[10] */
+		".long 0x7d6b0166;"	/* GPR[11] --> FPR[11] */
+		".long 0x7d8c0166;"	/* GPR[12] --> FPR[12] */
+		".long 0x7dad0166;"	/* GPR[13] --> FPR[13] */
+		".long 0x7dce0166;"	/* GPR[14] --> FPR[14] */
+		".long 0x7def0166;"	/* GPR[15] --> FPR[15] */
+		".long 0x7e100166;"	/* GPR[16] --> FPR[16] */
+		".long 0x7e310166;"	/* GPR[17] --> FPR[17] */
+		".long 0x7e520166;"	/* GPR[18] --> FPR[18] */
+		".long 0x7e730166;"	/* GPR[19] --> FPR[19] */
+		".long 0x7e940166;"	/* GPR[20] --> FPR[20] */
+		".long 0x7eb50166;"	/* GPR[21] --> FPR[21] */
+		".long 0x7ed60166;"	/* GPR[22] --> FPR[22] */
+		".long 0x7ef70166;"	/* GPR[23] --> FPR[23] */
+		".long 0x7f180166;"	/* GPR[24] --> FPR[24] */
+		".long 0x7f390166;"	/* GPR[25] --> FPR[25] */
+		".long 0x7f5a0166;"	/* GPR[26] --> FPR[26] */
+		".long 0x7f7b0166;"	/* GPR[27] --> FPR[27] */
+		".long 0x7f9c0166;"	/* GPR[28] --> FPR[28] */
+		".long 0x7fbd0166;"	/* GPR[29] --> FPR[29] */
+		".long 0x7fde0166;"	/* GPR[30] --> FPR[30] */
+		".long 0x7fff0166;"	/* GPR[31] --> FPR[31] */
+
+		"b .;"			/* Get stuck here */
+		TEND
+
+		/* Transaction abort handler */
+		"2: ;"
+		"b 1b;"			/* Start from TBEGIN */
+
+		:: [sprn_dscr]"i"(SPRN_DSCR), [sprn_tar]"i"(SPRN_TAR),
+		[sprn_ppr]"i"(SPRN_PPR), [val0]"i"(VAL0),
+		[val1]"i"(VAL1), [val2]"i"(VAL2), [val3]"i"(VAL3),
+		[val4]"i"(VAL4), [val5]"i"(VAL5), [val6]"i"(VAL6),
+		[val7]"i"(VAL7), [val8]"i"(VAL8), [val9]"i"(VAL9),
+		[val10]"i"(VAL10), [val11]"i"(VAL11), [val12]"i"(VAL12),
+		[val13]"i"(VAL13), [val14]"i"(VAL14), [val15]"i"(VAL15),
+		[c_tar]"i"(C_TAR), [c_dscr]"i"(C_DSCR), [tar]"i"(TAR),
+		[dscr]"i"(DSCR), [ppr]"i"(PPR), [c_ppr]"i"(C_PPR)
+		: "memory", "r7");
+}
+
+void test_result(const u64 variable, const u64 value, const char *str)
+{
+	if (variable == value)
+		printf("%s: %llx (PASSED)\n", str, variable);
+	else
+		printf("%s: %llx (FAILED)\n", str, variable);
+}
+
+int trace_tm_transaction(pid_t child)
+{
+	struct tm_spr_regs *tmspr;
+	struct pt_regs *cregs, *regs;
+	struct tm_cfpr *cfpr, *fpr;
+	struct misc_regs *mregs;
+	struct iovec iov;
+	char str[MAX_STR_LENGTH];
+	int ret, i, j;
+
+	regs = (struct pt_regs *) malloc(sizeof(struct pt_regs));
+	fpr = (struct tm_cfpr *) malloc(sizeof(struct tm_cfpr));
+
+	/* Wait till the tracee hits "b ." instruction */
+	sleep(3);
+
+	ret = ptrace(PTRACE_ATTACH, child, NULL, NULL);
+	if (ret) {
+		printf("ptrace(PTRACE_ATTACH) Failed: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	ret = waitpid(child, NULL, 0);
+	if (ret != child) {
+		printf("PID mismatch: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	/* TM specific SPR */
+	printf("Testing TM specific SPR:\n");
+	iov.iov_base = (struct tm_spr_regs *)
+				malloc(sizeof(struct tm_spr_regs));
+	iov.iov_len = sizeof(struct tm_spr_regs);
+	ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_TM_SPR, &iov);
+	if (ret) {
+		printf("ptrace(NT_PPC_TM_SPR) Failed: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	if (iov.iov_len != sizeof(struct tm_spr_regs)) {
+		printf("ptrace(NT_PPC_TM_SPR): Returned wrong length\n");
+		return TEST_FAIL;
+	}
+
+	tmspr = iov.iov_base;
+
+	printf("TFHAR: %llx\n", tmspr->tm_tfhar);
+	printf("TEXASR: %llx\n", tmspr->tm_texasr);
+	printf("TFIAR: %llx\n", tmspr->tm_tfiar);
+	printf("TM ORIG_MSR: %llx\n", tmspr->tm_orig_msr);
+
+	test_result(tmspr->tm_dscr, C_DSCR, "TM CH DSCR");
+	test_result(tmspr->tm_tar, C_TAR, "TM CH TAR");
+	test_result(tmspr->tm_ppr, C_PPR, "TM CH PPR");
+
+	/* TM checkpointed GPR */
+	printf("Testing TM checkpointed GPR:\n");
+	iov.iov_base = (struct pt_regs *) malloc(sizeof(struct pt_regs));
+	iov.iov_len = sizeof(struct pt_regs);
+	ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_TM_CGPR, &iov);
+	if (ret) {
+		printf("ptrace(NT_PPC_TM_CGPR) Failed: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	if (iov.iov_len != sizeof(struct pt_regs)) {
+		printf("ptrace(NT_PPC_TM_CGPR): Returned wrong length\n");
+		return TEST_FAIL;
+	}
+
+	cregs = iov.iov_base;
+
+	printf("TM CH NIP: %lx\n", cregs->nip);
+	printf("TM CH LINK: %lx\n", cregs->link);
+	printf("TM CH CCR: %lx\n", cregs->ccr);
+
+	for (i = 0; i < VAL_MAX; i++) {
+		sprintf(str, "TM CH GPR[%d]", i);
+		test_result(cregs->gpr[i], i, str);
+	}
+
+	for (j = 0; i < VAL_MAX * 2; j++, i++) {
+		sprintf(str, "TM CH GPR[%d]", i);
+		test_result(cregs->gpr[i], j, str);
+	}
+
+	/* TM checkpointed FPR */
+	printf("Testing TM checkpointed FPR:\n");
+	iov.iov_base = (struct tm_cfpr *) malloc(sizeof(struct tm_cfpr));
+	iov.iov_len = sizeof(struct tm_cfpr);
+	ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_TM_CFPR, &iov);
+	if (ret) {
+		printf("ptrace(NT_PPC_TM_CFPR) Failed: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	if (iov.iov_len != sizeof(struct tm_cfpr)) {
+		printf("ptrace(NT_PPC_TM_CFPR): Returned wrong length\n");
+		return TEST_FAIL;
+	}
+
+	cfpr = iov.iov_base;
+	printf("TM CH FPSCR: %llx\n", cfpr->fpscr);
+
+	for (i = 0; i < VAL_MAX; i++) {
+		sprintf(str, "TM CH FPR[%d]", i);
+		test_result(cfpr->fpr[i], i, str);
+	}
+
+	for (j = 0; i < VAL_MAX * 2; j++, i++) {
+		sprintf(str, "TM CH FPR[%d]", i);
+		test_result(cfpr->fpr[i], j, str);
+	}
+
+	/* TM running GPR */
+	printf("Testing TM running GPR:\n");
+	ret = ptrace(PTRACE_GETREGS, child, NULL, regs);
+	if (ret) {
+		printf("ptrace(PTRACE_GETREGS) Failed: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	printf("TM RN NIP: %lx\n", regs->nip);
+	printf("TM RN LINK: %lx\n", regs->link);
+	printf("TM RN CCR: %lx\n", regs->ccr);
+
+	for (i = 0, j = VAL_MAX - 1; i < VAL_MAX; i++, j--) {
+		sprintf(str, "TM RN GPR[%d]", i);
+		test_result(regs->gpr[i], j, str);
+	}
+
+	for (j = VAL_MAX - 1 ; i < VAL_MAX * 2; i++, j--) {
+		sprintf(str, "TM RN GPR[%d]", i);
+		test_result(regs->gpr[i], j, str);
+	}
+
+	/* TM running FPR */
+	printf("Testing TM running FPR:\n");
+	ret = ptrace(PTRACE_GETFPREGS, child, NULL, fpr);
+	if (ret) {
+		printf("ptrace(PTRACE_GETFPREGS) Failed: %s\n",
+							strerror(errno));
+		return TEST_FAIL;
+	}
+
+	printf("TM RN FPSCR: %llx\n", fpr->fpscr);
+
+	for (i = 0, j = VAL_MAX - 1; i < VAL_MAX; i++, j--) {
+		sprintf(str, "TM RN FPR[%d]", i);
+		test_result(fpr->fpr[i], j, str);
+	}
+
+	for (j = VAL_MAX - 1; i < VAL_MAX * 2; i++, j--) {
+		sprintf(str, "TM RN FPR[%d]", i);
+		test_result(fpr->fpr[i], j, str);
+	}
+
+	/* TM running MISC debug registers */
+	printf("Testing TM running MISC debug registers:\n");
+	iov.iov_base = (struct misc_regs *) malloc(sizeof(struct misc_regs));
+	iov.iov_len = sizeof(struct misc_regs);
+	ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_MISC, &iov);
+	if (ret) {
+		printf("ptrace(NT_PPC_MISC): Failed: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	if (iov.iov_len != sizeof(struct misc_regs)) {
+		printf("ptrace(NT_PPC_TM_MISC): Returned wrong length\n");
+		return TEST_FAIL;
+	}
+
+	mregs = iov.iov_base;
+	test_result(mregs->dscr, DSCR, "TM RN DSCR");
+	test_result(mregs->tar, TAR, "TM RN TAR");
+	test_result(mregs->ppr, PPR, "TM RN PPR");
+
+	ret = ptrace(PTRACE_DETACH, child, NULL, NULL);
+	if (ret) {
+		printf("ptrace(PTRACE_DETACH) Failed: %s\n", strerror(errno));
+		return 1;
+	}
+
+	if (kill(child, SIGTERM)) {
+		printf("kill() Failed\n");
+		return TEST_FAIL;
+	}
+
+	ret = waitpid(child, NULL, 0);
+	if (ret != child) {
+		printf("PID mismatch: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+	return TEST_PASS;
+}
+
+int tm_ptrace_test(void)
+{
+	pid_t child;
+
+	printf("===Testing TM based PTRACE Interface===\n");
+	fflush(stdout);
+	child = fork();
+	if (child < 0) {
+		printf("fork() Failed: %s\n", strerror(errno));
+		return TEST_FAIL;
+	}
+
+	/* Child to run the transaction */
+	if (child == 0)
+		do_tm_transaction();
+
+	/* Parent to trace the child */
+	if (child)
+		trace_tm_transaction(child);
+	return TEST_PASS;
+}
+
+int main(void)
+{
+	return test_harness(tm_ptrace_test, "tm_ptrace");
+}
-- 
1.9.3

