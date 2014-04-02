Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbaDBHJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:09:07 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57558 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbaDBHJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:09:05 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: avagin@openvz.org, oleg@redhat.com, roland@redhat.com, mikey@neuling.org,
        benh@kernel.crashing.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Add new ptrace request macros on PowerPC
Date: Wed,  2 Apr 2014 12:32:21 +0530
Message-Id: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040207-6102-0000-0000-0000053EA25A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch series adds new ELF note sections which are used to
create new ptrace request macros for various transactional memory and
miscellaneous registers on PowerPC. Please find the test case exploiting
the new ptrace request macros and it's results on a POWER8 system.

RFC: https://lkml.org/lkml/2014/4/1/292

============================== Results ==============================
-------TM specific SPR------
TM TFHAR: 100009dc
TM TEXASR: de000001ac000001
TM TFIAR: c00000000003f386
TM CH ORIG_MSR: 900000050000f032
TM CH TAR: 6
TM CH PPR: c000000000000
TM CH DSCR: 1
-------TM checkpointed GPR-----
TM CH GPR[0]: 1000097c
TM CH GPR[1]: 5
TM CH GPR[2]: 6
TM CH GPR[7]: 1
TM CH NIP: 100009dc
TM CH LINK: 1000097c
TM CH CCR: 22000422
-------TM running GPR-----
TM RN GPR[0]: 1000097c
TM RN GPR[1]: 7
TM RN GPR[2]: 8
TM RN GPR[7]: 5
TM RN NIP: 100009fc
TM RN LINK: 1000097c
TM RN CCR: 2000422
-------TM running FPR-----
TM RN FPR[0]: 1002d3a3780
TM RN FPR[1]: 7
TM RN FPR[2]: 8
TM RN FPSCR: 0
-------TM checkpointed FPR-----
TM CH FPR[0]: 1002d3a3780
TM CH FPR[1]: 5
TM CH FPR[2]: 6
TM CH FPSCR: 0
-------Running miscellaneous registers-------
TM RN DSCR: 0
TM RN PPR: c000000000000
TM RN TAR: 8
============================ Test case ==============================
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <errno.h>
#include <sys/ptrace.h>
#include <sys/uio.h>
#include <sys/types.h>
#include <sys/signal.h>
#include <sys/user.h>
#include <linux/elf.h>
#include <linux/types.h>

typedef unsigned long u64;
typedef unsigned int u32;

typedef __vector128 vector128;

/* TM CFPR */
struct tm_cfpr {
	u64     fpr[32];
	u64     fpscr;
};

/* TM CVMX */
struct tm_cvmx {
        vector128       vr[32] __attribute__((aligned(16)));
        vector128       vscr __attribute__((aligned(16)));
	u32		vrsave;	
};

/* TM SPR */
struct tm_spr_regs {
	u64	tm_tfhar;
	u64	tm_texasr;
	u64	tm_tfiar;
	u64	tm_orig_msr;
	u64	tm_tar;
	u64	tm_ppr;
	u64	tm_dscr;
};

/* Miscellaneous registers */
struct misc_regs {
	u64	dscr;
	u64	ppr;
	u64	tar;
};

/* TM instructions */
#define TBEGIN          ".long 0x7C00051D ;"
#define TEND            ".long 0x7C00055D ;"

#define SPRN_DSCR	0x3
#define SPRN_TAR	815

/* Ptrace request macros */
#define PTRACE_GETTM_SPRREGS    0x70
#define PTRACE_SETTM_SPRREGS    0x71
#define PTRACE_GETTM_CGPRREGS   0x72
#define PTRACE_SETTM_CGPRREGS   0x73
#define PTRACE_GETTM_CFPRREGS   0x74
#define PTRACE_SETTM_CFPRREGS   0x75
#define PTRACE_GETTM_CVMXREG    0x76
#define PTRACE_SETTM_CVMXREG    0x77
#define PTRACE_GETMSCREGS	0x78
#define PTRACE_SETMSCREGS	0x79

int main(int argc, char *argv[])
{
	struct tm_spr_regs *tmr1;
	struct pt_regs *pregs1, *pregs2;
	struct tm_cfpr *fpr, *fpr1;
	struct tm_cvmx *vr1;
	struct misc_regs *dbr1;

	pid_t child;
	int ret = 0, status = 0, i = 0, flag = 1;

	tmr1 = (struct tm_spr_regs *) malloc(sizeof(struct tm_spr_regs));
	pregs1 = (struct pt_regs *) malloc(sizeof(struct pt_regs));
	pregs2 = (struct pt_regs *) malloc(sizeof(struct pt_regs));
	fpr = (struct tm_cfpr *) malloc(sizeof(struct tm_cfpr));
	fpr1 = (struct tm_cfpr *) malloc(sizeof(struct tm_cfpr));
	vr1 = (struct tm_cvmx *) malloc(sizeof(struct tm_cvmx));
	dbr1 = (struct misc_regs *) malloc(sizeof(struct misc_regs));

	child = fork();
	if (child < 0) {
		printf("fork() failed \n");
		exit(-1);
	}

	/* Child code */
	if (child == 0) {
		asm __volatile__(
			"6: ;"			/* TM checkpointed values */
			"li 1, 5;"		/* GPR[1] */
			".long 0x7C210166;"	/* FPR[1] */
			"li 2, 6;"		/* GPR[2] */
			".long 0x7C420166;"	/* FPR[2] */
			"mtspr %[tar], 2;"	/* TAR */
			"li 7, 1;"		/* GPR[7] */
 			"mtspr %[dscr], 7;"	/* DSCR */
			"1: ;"
			TBEGIN			/* TM running values */
			"beq 2f ;"
		 	"li 1, 7;"		/* GPR[1] */
                        ".long 0x7C210166;"	/* FPR[1] */
                        "li 2, 8;"		/* GPR[2] */
                        ".long 0x7C420166;"	/* FPR[2] */
                        "mtspr %[tar], 2;"	/* TAR */
                        "li 7, 5;"		/* GPR[7] */
			"mtspr %[dscr], 7;"	/* DSCR */
			"b .;"
			TEND
			"2: ;"			/* Abort handler */
			"b 1b;"			/* Start from TBEGIN */

			"3: ;"
			"b 6b;"			/* Start all over again */
			:: [dscr]"i"(SPRN_DSCR), [tar]"i"(SPRN_TAR)
			: "memory", "r7");
	}

	/* Parent */
	if (child) {
		do {
			/* Wait till child hits "b ." instruction */
			sleep(3);

			memset(tmr1, 0 , sizeof(struct tm_spr_regs));
			memset(pregs1, 0 , sizeof(struct pt_regs));
			memset(pregs2, 0 , sizeof(struct pt_regs));
			memset(fpr1, 0 , sizeof(struct tm_cfpr));
			memset(fpr, 0 , sizeof(struct tm_cfpr));
			memset(vr1, 0 , sizeof(struct tm_cvmx));
			memset(dbr1, 0 , sizeof(struct misc_regs));

			ret = ptrace(PTRACE_ATTACH, child, NULL, NULL);
			if (ret == -1) {
				printf("PTRACE_ATTACH failed: %s\n", strerror(errno));
				exit(-1);
			}

			ret = waitpid(child, NULL, 0);
			if (ret != child) {
				printf("PID does not match\n");
				exit(-1);
			}

			/* TM specific SPR */
			ret = ptrace(PTRACE_GETTM_SPRREGS, child, NULL, tmr1);
			if (ret == -1) {
				printf("PTRACE_GETTM_SPRREGS failed: %s\n", strerror(errno));
				exit(-1);
			}

			printf("-------TM specific SPR------\n");
			printf("TM TFHAR: %lx\n", tmr1->tm_tfhar);
			printf("TM TEXASR: %lx\n", tmr1->tm_texasr);
			printf("TM TFIAR: %lx\n", tmr1->tm_tfiar);
			printf("TM CH ORIG_MSR: %lx\n", tmr1->tm_orig_msr);
			printf("TM CH TAR: %lx\n", tmr1->tm_tar);
			printf("TM CH PPR: %lx\n", tmr1->tm_ppr);
			printf("TM CH DSCR: %lx\n", tmr1->tm_dscr);

			/* TM checkpointed GPR */
			ret = ptrace(PTRACE_GETTM_CGPRREGS, child, NULL, pregs1);
			if (ret == -1) {
				printf("PTRACE_GETTM_CGPRREGS failed: %s\n", strerror(errno));
				exit(-1);
			}

			printf("-------TM checkpointed GPR-----\n");
			printf("TM CH GPR[0]: %lx\n", pregs1->gpr[0]);
			printf("TM CH GPR[1]: %lx\n", pregs1->gpr[1]);
			printf("TM CH GPR[2]: %lx\n", pregs1->gpr[2]);
			printf("TM CH GPR[7]: %lx\n", pregs1->gpr[7]);
			printf("TM CH NIP: %lx\n", pregs1->nip);
			printf("TM CH LINK: %lx\n", pregs1->link);
			printf("TM CH CCR: %lx\n", pregs1->ccr);

			/* TM running GPR */
			ret = ptrace(PTRACE_GETREGS, child, NULL, pregs2);
			if (ret == -1) {
				printf("PTRACE_GETREGS failed: %s\n", strerror(errno));
				exit(-1);
			}

			printf("-------TM running GPR-----\n");
			printf("TM RN GPR[0]: %lx\n", pregs2->gpr[0]);
			printf("TM RN GPR[1]: %lx\n", pregs2->gpr[1]);
			printf("TM RN GPR[2]: %lx\n", pregs2->gpr[2]);
			printf("TM RN GPR[7]: %lx\n", pregs2->gpr[7]);
			printf("TM RN NIP: %lx\n", pregs2->nip);
			printf("TM RN LINK: %lx\n", pregs2->link);
			printf("TM RN CCR: %lx\n", pregs2->ccr);

			/* TM running FPR */
			ret = ptrace(PTRACE_GETFPREGS, child, NULL, fpr);
			if (ret == -1) {
				printf("PTRACE_GETFPREGS failed: %s\n", strerror(errno));
				exit(-1);
			}

			printf("-------TM running FPR-----\n");
			printf("TM RN FPR[0]: %lx\n", fpr->fpr[0]);
			printf("TM RN FPR[1]: %lx\n", fpr->fpr[1]);
			printf("TM RN FPR[2]: %lx\n", fpr->fpr[2]);
			printf("TM RN FPSCR: %lx\n", fpr->fpscr);

			/* TM checkpointed FPR */
			ret = ptrace(PTRACE_GETTM_CFPRREGS, child, NULL, fpr1);
			if (ret == -1) {
				printf("PTRACE_GETTM_CFPRREGS failed: %s\n", strerror(errno));
				exit(-1);
			}
			printf("-------TM checkpointed FPR-----\n");
			printf("TM CH FPR[0]: %lx\n", fpr1->fpr[0]);
			printf("TM CH FPR[1]: %lx\n", fpr1->fpr[1]);
			printf("TM CH FPR[2]: %lx\n", fpr1->fpr[2]);
			printf("TM CH FPSCR: %lx\n", fpr1->fpscr);

			/* Misc debug */
			ret = ptrace(PTRACE_GETMSCREGS, child, NULL, dbr1);
			if (ret == -1) {
				printf("PTRACE_GETMSCREGS failed: %s\n", strerror(errno));
				exit(-1);
			}

			printf("-------Running miscellaneous registers-------\n");
			printf("TM RN DSCR: %lx\n", dbr1->dscr);
			printf("TM RN PPR: %lx\n", dbr1->ppr);
			printf("TM RN TAR: %lx\n", dbr1->tar);
	
			ret = ptrace(PTRACE_DETACH, child, NULL, NULL);
			if (ret == -1) {
				printf("PTRACE_DETACH failed: %s\n", strerror(errno));
				exit(-1);
			}
		} while (0);
	}
	return 0;
}
=====================================================================

Anshuman Khandual (3):
  elf: Add some new PowerPC specifc note sections
  powerpc, ptrace: Add new ptrace request macros for transactional memory
  powerpc, ptrace: Add new ptrace request macro for miscellaneous registers

 arch/powerpc/include/asm/switch_to.h   |   8 +
 arch/powerpc/include/uapi/asm/ptrace.h |  61 +++
 arch/powerpc/kernel/process.c          |  24 ++
 arch/powerpc/kernel/ptrace.c           | 659 +++++++++++++++++++++++++++++++--
 include/uapi/linux/elf.h               |   5 +
 5 files changed, 729 insertions(+), 28 deletions(-)

-- 
1.7.11.7

