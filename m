Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbaGXGwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:52:39 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39171 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaGXGwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:52:37 -0400
Message-ID: <53D0AD2B.4050004@au1.ibm.com>
Date: Thu, 24 Jul 2014 16:52:27 +1000
From: Sam Bobroff <sam.bobroff@au1.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
CC: mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, davej@redhat.com, davem@davemloft.net
Subject: Re: [PATCH V3 0/3] Add new PowerPC specific ELF core notes
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072406-1396-0000-0000-0000054A5C90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/14 01:15, Anshuman Khandual wrote:
> 	This patch series adds five new ELF core note sections which can be
> used with existing ptrace request PTRACE_GETREGSET/SETREGSET for accessing
> various transactional memory and miscellaneous register sets on PowerPC
> platform. Please find a test program exploiting these new ELF core note
> types on a POWER8 system.
> 
> RFC: https://lkml.org/lkml/2014/4/1/292
> V1:  https://lkml.org/lkml/2014/4/2/43
> V2:  https://lkml.org/lkml/2014/5/5/88
> 
> Changes in V3
> =============
> (1) Added two new error paths in every TM related get/set functions when regset
>     support is not present on the system (ENODEV) or when the process does not
>     have any transaction active (ENODATA) in the context
> 
> (2) Installed the active hooks for all the newly added regset core note types
> 
> Changes in V2
> =============
> (1) Removed all the power specific ptrace requests corresponding to new NT_PPC_*
>     elf core note types. Now all the register sets can be accessed from ptrace
>     through PTRACE_GETREGSET/PTRACE_SETREGSET using the individual NT_PPC* core
>     note type instead
> (2) Fixed couple of attribute values for REGSET_TM_CGPR register set
> (3) Renamed flush_tmreg_to_thread as flush_tmregs_to_thread
> (4) Fixed 32 bit checkpointed GPR support
> (5) Changed commit messages accordingly
> 
> Outstanding Issues
> ==================
> (1) Running DSCR register value inside a transaction does not seem to be saved
>     at thread.dscr when the process stops for ptrace examination.

Since this is fixed by 96d016108640bc2b7fb0ee800737f80923847294, which
is already upstream, you might want to rebase and re-test. It should
pass and then you can remove the outstanding issues :-)

>     
> Test programs

program

When I posted the patch I mentioned above, I was asked to move the test
code into the powerpc kernel selftests so you may want to do this too.

Also, your test program covers everything mine did and more so you might
want to remove mine if you do add this to the selftests.

> =============
> #include <unistd.h>
> #include <stdlib.h>
> #include <string.h>
> #include <malloc.h>
> #include <errno.h>
> #include <sys/ptrace.h>
> #include <sys/uio.h>
> #include <sys/types.h>
> #include <sys/signal.h>
> #include <sys/user.h>

You should include sys/wait.h for waitpid().

> #include <linux/elf.h>
> #include <linux/types.h>
> #include <linux/ptrace.h>
> 
> typedef long long u64;
> typedef unsigned int u32;
> typedef __vector128 vector128;
> 
> /* TM CFPR */
> struct tm_cfpr {
> 	u64	fpr[32];
> 	u64	fpscr;
> };
> 
> /* TM CVMX */
> struct tm_cvmx {
>         vector128	vr[32] __attribute__((aligned(16)));
>         vector128	vscr __attribute__((aligned(16)));
> 	u32		vrsave;	
> };
> 
> /* TM SPR */
> struct tm_spr_regs {
> 	u64	tm_tfhar;
> 	u64	tm_texasr;
> 	u64	tm_tfiar;
> 	u64	tm_orig_msr;
> 	u64	tm_tar;
> 	u64	tm_ppr;
> 	u64	tm_dscr;
> };
> 
> /* Miscellaneous registers */
> struct misc_regs {
> 	u64	dscr;
> 	u64	ppr;
> 	u64	tar;
> };
> 
> /* TM instructions */
> #define TBEGIN          ".long 0x7C00051D ;"
> #define TEND            ".long 0x7C00055D ;"
> 
> /* SPR number */
> #define SPRN_DSCR	0x3
> #define SPRN_TAR	815
> 
> /* ELF core notes */
> #define NT_PPC_TM_SPR  0x103           /* PowerPC transactional memory special registers */
> #define NT_PPC_TM_CGPR 0x104           /* PowerpC transactional memory checkpointed GPR */
> #define NT_PPC_TM_CFPR 0x105           /* PowerPC transactional memory checkpointed FPR */
> #define NT_PPC_TM_CVMX 0x106           /* PowerPC transactional memory checkpointed VMX */
> #define NT_PPC_MISC    0x107           /* PowerPC miscellaneous registers */
> 
> #define VAL1 1
> #define VAL2 2
> #define VAL3 3
> #define VAL4 4
> 
> int main(int argc, char *argv[])
> {
> 	struct tm_spr_regs *tmr1;
> 	struct pt_regs *pregs1, *pregs2;
> 	struct tm_cfpr *fpr, *fpr1;
> 	struct misc_regs *dbr1;
> 	struct iovec iov;
> 
> 	pid_t child;
> 	int ret = 0, status = 0, i = 0, flag = 1;

status, i and flags are all unused.

> 
> 	pregs2 = (struct pt_regs *) malloc(sizeof(struct pt_regs));
> 	fpr = (struct tm_cfpr *) malloc(sizeof(struct tm_cfpr));
> 
> 	child = fork();
> 	if (child < 0) {
> 		printf("fork() failed \n");
> 		exit(-1);
> 	}
> 
> 	/* Child code */
> 	if (child == 0) {
> 		asm __volatile__(
> 			"6: ;"			/* TM checkpointed values */
> 			"li 1, %[val1];"	/* GPR[1] */
> 			".long 0x7C210166;"	/* FPR[1] */
> 			"li 2, %[val2];"	/* GPR[2] */
> 			".long 0x7C420166;"	/* FPR[2] */
> 			"mtspr %[tar], 1;"	/* TAR */
>  			"mtspr %[dscr], 2;"	/* DSCR */
> 			"1: ;"
> 			TBEGIN			/* TM running values */
> 			"beq 2f ;"
> 		 	"li 1, %[val3];"	/* GPR[1] */
>                         ".long 0x7C210166;"	/* FPR[1] */
>                         "li 2, %[val4];"	/* GPR[2] */
>                         ".long 0x7C420166;"	/* FPR[2] */
>                         "mtspr %[tar], 1;"	/* TAR */
> 			"mtspr %[dscr], 2;"	/* DSCR */
> 			"b .;"
> 			TEND
> 			"2: ;"			/* Abort handler */
> 			"b 1b;"			/* Start from TBEGIN */
> 
> 			"3: ;"
> 			"b 6b;"			/* Start all over again */
> 			:: [dscr]"i"(SPRN_DSCR), [tar]"i"(SPRN_TAR), [val1]"i"(VAL1), [val2]"i"(VAL2), [val3]"i"(VAL3), [val4]"i"(VAL4)
> 			: "memory", "r7");
> 	}
> 
> 	/* Parent */
> 	if (child) {
> 		do {
> 			memset(pregs2, 0 , sizeof(struct pt_regs));
> 			memset(fpr, 0 , sizeof(struct tm_cfpr));
> 
> 			/* Wait till child hits "b ." instruction */
> 			sleep(3);
> 
> 			/* Attach tracee */
> 			ret = ptrace(PTRACE_ATTACH, child, NULL, NULL);
> 			if (ret == -1) {
> 				printf("PTRACE_ATTACH failed: %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 
> 			ret = waitpid(child, NULL, 0);
> 			if (ret != child) {
> 				printf("PID does not match\n");
> 				exit(-1);
> 			}
> 
> 			/* TM specific SPR */
> 			iov.iov_base = (struct tm_spr_regs *) malloc(sizeof(struct tm_spr_regs));
> 			iov.iov_len = sizeof(struct tm_spr_regs);
> 			ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_TM_SPR, &iov);
> 			if (ret == -1) {
> 				printf("PTRACE_GETREGSET: NT_PPC_TM_SPR failed %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 
> 			if (iov.iov_len != sizeof(struct tm_spr_regs)) {
> 				printf("NT_PPC_TM_SPR: Length returned is wrong\n");
> 				exit(-1);
> 			}
> 
> 			tmr1 = iov.iov_base;
> 			printf("-------TM specific SPR------\n");
> 			printf("TM TFHAR: %llx\n", tmr1->tm_tfhar);
> 			printf("TM TEXASR: %llx\n", tmr1->tm_texasr);
> 			printf("TM TFIAR: %llx\n", tmr1->tm_tfiar);
> 			printf("TM CH ORIG_MSR: %llx\n", tmr1->tm_orig_msr);
> 			printf("TM CH TAR: %llx\n", tmr1->tm_tar);
> 			printf("TM CH PPR: %llx\n", tmr1->tm_ppr);
> 			printf("TM CH DSCR: %llx\n", tmr1->tm_dscr);
> 
> 			if (tmr1->tm_tar == VAL1)
> 				printf("TAR PASSED\n");
> 			else
> 				printf("TAR FAILED\n");
> 
> 			if (tmr1->tm_dscr == VAL2)
> 				printf("DSCR PASSED\n");
> 			else
> 				printf("DSCR FAILED\n");
> 
> 			/* TM checkpointed GPR */
> 			iov.iov_base = (struct pt_regs *) malloc(sizeof(struct pt_regs));;
> 			iov.iov_len = sizeof(struct pt_regs);
> 			ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_TM_CGPR, &iov);
> 			if (ret == -1) {
> 				printf("PTRACE_GETREGSET: NT_PPC_TM_CGPR failed: %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 
> 			if (iov.iov_len != sizeof(struct pt_regs)) {
> 				printf("NT_PPC_TM_CGPR: Length returned is wrong\n");
> 				exit(-1);
> 			}
> 
> 			pregs1 = iov.iov_base;
> 			printf("-------TM checkpointed GPR-----\n");
> 			printf("TM CH GPR[1]: %x\n", pregs1->gpr[1]);
> 			printf("TM CH GPR[2]: %x\n", pregs1->gpr[2]);
> 			printf("TM CH NIP: %x\n", pregs1->nip);
> 			printf("TM CH LINK: %x\n", pregs1->link);
> 			printf("TM CH CCR: %x\n", pregs1->ccr);

I get a compiler warning for these printfs: they should be "%lx".

> 
> 			if (pregs1->gpr[1] == VAL1)
> 				printf("GPR[1] PASSED\n");
> 			else
> 				printf("GPR[1] FAILED\n");
> 
> 			if (pregs1->gpr[2] == VAL2)
> 				printf("GPR[2] PASSED\n");
> 			else
> 				printf("GPR[2] FAILED\n");
> 
> 			/* TM running GPR */
> 			ret = ptrace(PTRACE_GETREGS, child, NULL, pregs2);
> 			if (ret == -1) {
> 				printf("PTRACE_GETREGS fail: %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 
> 			printf("-------TM running GPR-----\n");
> 			printf("TM RN GPR[1]: %x\n", pregs2->gpr[1]);
> 			printf("TM RN GPR[2]: %x\n", pregs2->gpr[2]);
> 			printf("TM RN NIP: %x\n", pregs2->nip);
> 			printf("TM RN LINK: %x\n", pregs2->link);
> 			printf("TM RN CCR: %x\n", pregs2->ccr);

Same as above, I get warnings and they should be "%lx".
> 
> 			
> 			if (pregs2->gpr[1] == VAL3)
> 				printf("GPR[1] PASSED\n");
> 			else
> 				printf("GPR[1] FAILED\n");
> 
> 			if (pregs2->gpr[2] == VAL4)
> 				printf("GPR[2] PASSED\n");
> 			else
> 				printf("GPR[2] FAILED\n");
> 
> 			/* TM checkpointed FPR */
> 			iov.iov_base = (struct tm_cfpr *) malloc(sizeof(struct tm_cfpr));;
> 			iov.iov_len = sizeof(struct tm_cfpr);
> 			ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_TM_CFPR, &iov);
> 			if (ret == -1) {
> 				printf("PTRACE_GETREGSET: NT_PPC_TM_CFPR: Failed: %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 
> 			if (iov.iov_len != sizeof(struct tm_cfpr)) {
> 				printf("NT_PPC_TM_CFPR: Length returned is wrong\n");
> 				exit(-1);
> 			}
> 
> 			fpr1 = iov.iov_base;
> 			printf("-------TM checkpointed FPR-----\n");
> 			printf("TM CH FPR[1]: %llx\n", fpr1->fpr[1]);
> 			printf("TM CH FPR[2]: %llx\n", fpr1->fpr[2]);
> 			printf("TM CH FPSCR: %llx\n", fpr1->fpscr);
> 
> 			if (fpr1->fpr[1] == VAL1)
> 				printf("FPR[1] PASSED\n");
> 			else
> 				printf("FPR[1] FAILED\n");
> 
> 			if (fpr1->fpr[2] == VAL2)
> 				printf("FPR[2] PASSED\n");
> 			else
> 				printf("FPR[2] FAILED\n");
> 
> 			/* TM running FPR */
> 			ret = ptrace(PTRACE_GETFPREGS, child, NULL, fpr);
> 			if (ret == -1) {
> 				printf("PTRACE_GETFPREGS failed: %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 
> 			printf("-------TM running FPR-----\n");
> 			printf("TM RN FPR[1]: %llx\n", fpr->fpr[1]);
> 			printf("TM RN FPR[2]: %llx\n", fpr->fpr[2]);
> 			printf("TM RN FPSCR: %llx\n", fpr->fpscr);
> 
> 			if (fpr->fpr[1] == VAL3)
> 				printf("FPR[1] PASSED\n");
> 			else
> 				printf("FPR[1] FAILED\n");
> 
> 			if (fpr->fpr[2] == VAL4)
> 				printf("FPR[2] PASSED\n");
> 			else
> 				printf("FPR[2] FAILED\n");
> 
> 			/* Misc registers */
> 			iov.iov_base = (struct misc_regs *) malloc(sizeof(struct misc_regs));
> 			iov.iov_len = sizeof(struct misc_regs);
> 			ret = ptrace(PTRACE_GETREGSET, child, NT_PPC_MISC, &iov);
> 			if (ret == -1) {
> 				printf("PTRACE_GETREGSET: NT_PPC_MISC: Failed: %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 
> 			if (iov.iov_len != sizeof(struct misc_regs)) {
> 				printf("NT_PPC_TM_MISC: Length returned is wrong\n");
> 				exit(-1);
> 			}
> 
> 			dbr1  = iov.iov_base;
> 			printf("-------Running miscellaneous registers-------\n");
> 			printf("TM RN DSCR: %llx\n", dbr1->dscr);
> 			printf("TM RN PPR: %llx\n", dbr1->ppr);
> 			printf("TM RN TAR: %llx\n", dbr1->tar);
> 
> 			if (dbr1->tar == VAL3)
> 				printf("TAR PASSED\n");
> 			else
> 				printf("TAR FAILED\n");
> 
> 			if (dbr1->dscr == VAL4)
> 				printf("DSCR PASSED\n");
> 			else
> 				printf("DSCR FAILED\n");
> 
> 			/* Detach tracee */
> 			ret = ptrace(PTRACE_DETACH, child, NULL, NULL);
> 			if (ret == -1) {
> 				printf("PTRACE_DETACH failed: %s\n", strerror(errno));
> 				exit(-1);
> 			}
> 		} while (0);
> 	}
> 	return 0;
> }
> 
> Test Results
> ============
> (1) 64 bit application ==>
> 
> -------TM specific SPR------
> TM TFHAR: 10000960
> TM TEXASR: de000001ac000001
> TM TFIAR: c0000000000465f6
> TM CH ORIG_MSR: 900000050000f032
> TM CH TAR: 1
> TM CH PPR: c000000000000
> TM CH DSCR: 2
> TAR PASSED
> DSCR PASSED
> -------TM checkpointed GPR-----
> TM CH GPR[1]: 1
> TM CH GPR[2]: 2
> TM CH NIP: 10000960
> TM CH LINK: 10000904
> TM CH CCR: 22000422
> GPR[1] PASSED
> GPR[2] PASSED
> -------TM running GPR-----
> TM RN GPR[1]: 3
> TM RN GPR[2]: 4
> TM RN NIP: 1000097c
> TM RN LINK: 10000904
> TM RN CCR: 2000422
> GPR[1] PASSED
> GPR[2] PASSED
> -------TM checkpointed FPR-----
> TM CH FPR[1]: 1
> TM CH FPR[2]: 2
> TM CH FPSCR: 0
> FPR[1] PASSED
> FPR[2] PASSED
> -------TM running FPR-----
> TM RN FPR[1]: 3
> TM RN FPR[2]: 4
> TM RN FPSCR: 0
> FPR[1] PASSED
> FPR[2] PASSED
> -------Running miscellaneous registers-------
> TM RN DSCR: 0
> TM RN PPR: c000000000000
> TM RN TAR: 3
> TAR PASSED
> DSCR FAILED
> 
> (2) 32 bit application ==>
> 
> -------TM specific SPR------
> TM TFHAR: 100006b8
> TM TEXASR: de000001ac000001
> TM TFIAR: c0000000000465f6
> TM CH ORIG_MSR: 100000050000f032
> TM CH TAR: 1
> TM CH PPR: c000000000000
> TM CH DSCR: 2
> TAR PASSED
> DSCR PASSED
> -------TM checkpointed GPR-----
> TM CH GPR[1]: 1
> TM CH GPR[2]: 2
> TM CH NIP: 100006b8
> TM CH LINK: 1000066c
> TM CH CCR: 22000422
> GPR[1] PASSED
> GPR[2] PASSED
> -------TM running GPR-----
> TM RN GPR[1]: 3
> TM RN GPR[2]: 4
> TM RN NIP: 100006d4
> TM RN LINK: 1000066c
> TM RN CCR: 2000422
> GPR[1] PASSED
> GPR[2] PASSED
> -------TM checkpointed FPR-----
> TM CH FPR[1]: 1
> TM CH FPR[2]: 2
> TM CH FPSCR: 0
> FPR[1] PASSED
> FPR[2] PASSED
> -------TM running FPR-----
> TM RN FPR[1]: 3
> TM RN FPR[2]: 4
> TM RN FPSCR: 0
> FPR[1] PASSED
> FPR[2] PASSED
> -------Running miscellaneous registers-------
> TM RN DSCR: 0
> TM RN PPR: c000000000000
> TM RN TAR: 3
> TAR PASSED
> DSCR FAILED
> 
> 
> Anshuman Khandual (3):
>   elf: Add some new PowerPC specifc note sections
>   powerpc, ptrace: Enable support for transactional memory register sets
>   powerpc, ptrace: Enable support for miscellaneous registers
> 
>  arch/powerpc/include/asm/switch_to.h |   8 +
>  arch/powerpc/kernel/process.c        |  24 +
>  arch/powerpc/kernel/ptrace.c         | 873 +++++++++++++++++++++++++++++++++--
>  include/uapi/linux/elf.h             |   5 +
>  4 files changed, 881 insertions(+), 29 deletions(-)
> 

