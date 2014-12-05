Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaLELTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:19:31 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:52128 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLELSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:18:22 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: [PATCH v1 1/5] uaccess: add pagefault_count to thread_info
Date: Fri,  5 Dec 2014 12:18:05 +0100
Message-Id: <1417778289-51567-2-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120511-0021-0000-0000-0000020802E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pagefault_count to the thread_info of all
architectures. It will be used to count the pagefault_disable() levels
on a per-thread basis.

We are not reusing the preempt_count as this is per cpu on x86 and we want to
demangle pagefault_disable() from preemption in the future.

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 arch/alpha/include/asm/thread_info.h      |  1 +
 arch/arc/include/asm/thread_info.h        |  1 +
 arch/arm/include/asm/thread_info.h        |  1 +
 arch/arm64/include/asm/thread_info.h      |  1 +
 arch/avr32/include/asm/thread_info.h      |  1 +
 arch/blackfin/include/asm/thread_info.h   |  1 +
 arch/c6x/include/asm/thread_info.h        |  1 +
 arch/cris/include/asm/thread_info.h       |  1 +
 arch/frv/include/asm/thread_info.h        |  1 +
 arch/hexagon/include/asm/thread_info.h    |  1 +
 arch/ia64/include/asm/thread_info.h       |  1 +
 arch/m32r/include/asm/thread_info.h       |  5 +++--
 arch/m68k/include/asm/thread_info.h       |  1 +
 arch/metag/include/asm/thread_info.h      |  1 +
 arch/microblaze/include/asm/thread_info.h |  1 +
 arch/mips/include/asm/thread_info.h       |  1 +
 arch/mn10300/include/asm/thread_info.h    |  1 +
 arch/openrisc/include/asm/thread_info.h   |  1 +
 arch/parisc/include/asm/thread_info.h     |  1 +
 arch/powerpc/include/asm/thread_info.h    |  1 +
 arch/s390/include/asm/thread_info.h       |  1 +
 arch/score/include/asm/thread_info.h      |  1 +
 arch/sh/include/asm/thread_info.h         |  1 +
 arch/sparc/include/asm/thread_info_32.h   | 20 +++++++++++---------
 arch/sparc/include/asm/thread_info_64.h   | 17 +++++++++--------
 arch/tile/include/asm/thread_info.h       |  1 +
 arch/um/include/asm/thread_info.h         |  1 +
 arch/unicore32/include/asm/thread_info.h  |  1 +
 arch/x86/include/asm/thread_info.h        |  1 +
 arch/xtensa/include/asm/thread_info.h     |  5 +++--
 30 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 48bbea6..1830671 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -22,6 +22,7 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* thread address space */
 	unsigned		cpu;		/* current CPU */
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	unsigned int		status;		/* thread-synchronous flags */
 
 	int bpt_nsaved;
diff --git a/arch/arc/include/asm/thread_info.h b/arch/arc/include/asm/thread_info.h
index 02bc5ec..2fde704 100644
--- a/arch/arc/include/asm/thread_info.h
+++ b/arch/arc/include/asm/thread_info.h
@@ -41,6 +41,7 @@
 struct thread_info {
 	unsigned long flags;		/* low level flags */
 	int preempt_count;		/* 0 => preemptable, <0 => BUG */
+	int pagefault_count;		/* pagefault_disable() levels */
 	struct task_struct *task;	/* main task structure */
 	mm_segment_t addr_limit;	/* thread address space */
 	struct exec_domain *exec_domain;/* execution domain */
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index ce73ab6..bf47d2d 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -51,6 +51,7 @@ struct cpu_context_save {
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+	int			pagefault_count;/* pagefault_disable() levels */
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 459bf8e..2469f15 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -50,6 +50,7 @@ struct thread_info {
 	struct exec_domain	*exec_domain;	/* execution domain */
 	struct restart_block	restart_block;
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+	int			pagefault_count;/* pagefault_disable() levels */
 	int			cpu;		/* cpu */
 };
 
diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index a978f3f..0c1d6f7 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -25,6 +25,7 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;
 	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	__s32			pagefault_count;/* pagefault_disable() levels */
 	__u32			rar_saved;	/* return address... */
 	__u32			rsr_saved;	/* ...and status register
 						   saved by debug handler
diff --git a/arch/blackfin/include/asm/thread_info.h b/arch/blackfin/include/asm/thread_info.h
index 55f473b..3ba26aa 100644
--- a/arch/blackfin/include/asm/thread_info.h
+++ b/arch/blackfin/include/asm/thread_info.h
@@ -41,6 +41,7 @@ struct thread_info {
 	unsigned long flags;	/* low level flags */
 	int cpu;		/* cpu we're on */
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int pagefault_count;	/* pagefault_disable() levels */
 	mm_segment_t addr_limit;	/* address limit */
 	struct restart_block restart_block;
 #ifndef CONFIG_SMP
diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
index d4e9ef8..6b2dcac 100644
--- a/arch/c6x/include/asm/thread_info.h
+++ b/arch/c6x/include/asm/thread_info.h
@@ -44,6 +44,7 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 = preemptable, <0 = BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	mm_segment_t		addr_limit;	/* thread address space */
 	struct restart_block	restart_block;
 };
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 55dede1..3356902 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -32,6 +32,7 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	__u32			tls;		/* TLS for this thread */
 
 	mm_segment_t		addr_limit;	/* thread address space:
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index af29e17..79a97ee 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -36,6 +36,7 @@ struct thread_info {
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 						 * 0-0xBFFFFFFF for user-thead
diff --git a/arch/hexagon/include/asm/thread_info.h b/arch/hexagon/include/asm/thread_info.h
index a59dad3..d54042e 100644
--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -51,6 +51,7 @@ struct thread_info {
 	unsigned long		flags;          /* low level flags */
 	__u32                   cpu;            /* current cpu */
 	int                     preempt_count;  /* 0=>preemptible,<0=>BUG */
+	int                     pagefault_count;/* pagefault_disable() levels */
 	mm_segment_t            addr_limit;     /* segmentation sux */
 	/*
 	 * used for syscalls somehow;
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index 5b17418..14f128c 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -27,6 +27,7 @@ struct thread_info {
 	__u32 status;			/* Thread synchronous flags */
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
+	int pagefault_count;		/* pagefault_disable() levels */
 	struct restart_block restart_block;
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	__u64 ac_stamp;
diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index 0017170..a1ec910 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -29,6 +29,7 @@ struct thread_info {
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thread
@@ -48,8 +49,8 @@ struct thread_info {
 #define TI_STATUS	0x0000000C
 #define TI_CPU		0x00000010
 #define TI_PRE_COUNT	0x00000014
-#define TI_ADDR_LIMIT	0x00000018
-#define TI_RESTART_BLOCK 0x000001C
+#define TI_ADDR_LIMIT	0x0000001C
+#define TI_RESTART_BLOCK 0x0000020
 
 #endif
 
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index 21a4784..5a6a203 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -29,6 +29,7 @@ struct thread_info {
 	struct exec_domain	*exec_domain;	/* execution domain */
 	mm_segment_t		addr_limit;	/* thread address space */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	__u32			cpu;		/* should always be 0 on m68k */
 	unsigned long		tp_value;	/* thread pointer */
 	struct restart_block    restart_block;
diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index 4771133..91729f5 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -33,6 +33,7 @@ struct thread_info {
 	unsigned long status;	/* thread-synchronous flags */
 	u32 cpu;		/* current CPU */
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int pagefault_count;	/* pagefault_disable() levels */
 
 	mm_segment_t addr_limit;	/* thread address space */
 	struct restart_block restart_block;
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index 8c9d365..f905b02 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -70,6 +70,7 @@ struct thread_info {
 	unsigned long		status; /* thread-synchronous flags */
 	__u32			cpu; /* current CPU */
 	__s32			preempt_count; /* 0 => preemptable,< 0 => BUG*/
+	__s32			pagefault_count; /* pagefault_disable() levels */
 	mm_segment_t		addr_limit; /* thread address space */
 	struct restart_block	restart_block;
 
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 7de8658..f9f27ac 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -28,6 +28,7 @@ struct thread_info {
 	unsigned long		tp_value;	/* thread pointer */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 
 	mm_segment_t		addr_limit;	/*
 						 * thread address space limit:
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index bf280ea..f6c03a5 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -45,6 +45,7 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;		/* current CPU */
 	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	__s32			pagefault_count;/* pagefault_disable() levels */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 						   0-0xBFFFFFFF for user-thead
diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
index d797acc..bdabd6e 100644
--- a/arch/openrisc/include/asm/thread_info.h
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -52,6 +52,7 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;		/* current CPU */
 	__s32			preempt_count; /* 0 => preemptable, <0 => BUG */
+	__s32			pagefault_count;/* pagefault_disable() levels */
 
 	mm_segment_t		addr_limit; /* thread address space:
 					       0-0x7FFFFFFF for user-thead
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index a846118..e37b76b 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -14,6 +14,7 @@ struct thread_info {
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	__u32 cpu;			/* current CPU */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
+	int pagefault_count;		/* pagefault_disable() levels */
 	struct restart_block restart_block;
 };
 
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index b034ecd..e8585fd 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -43,6 +43,7 @@ struct thread_info {
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
+	int		pagefault_count;	/* pagefault_disable() levels */
 	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index 4d62fd5..bbf0513f 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -39,6 +39,7 @@ struct thread_info {
 	unsigned long		sys_call_table;	/* System call table address */
 	unsigned int		cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	struct restart_block	restart_block;
 	unsigned int		system_call;
 	__u64			user_timer;
diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
index 656b7ad..d7f748d 100644
--- a/arch/score/include/asm/thread_info.h
+++ b/arch/score/include/asm/thread_info.h
@@ -35,6 +35,7 @@ struct thread_info {
 
 	/* 0 => preemptable, < 0 => BUG */
 	int			preempt_count;
+	int			pagefault_count;/* pagefault_disable() levels */
 
 	/*
 	 * thread address space:
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index ad27ffa..682a466 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -32,6 +32,7 @@ struct thread_info {
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	mm_segment_t		addr_limit;	/* thread address space */
 	struct restart_block	restart_block;
 	unsigned long		previous_sp;	/* sp of previous stack in case
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index 025c984..3dc0054 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -32,6 +32,7 @@ struct thread_info {
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	int			softirq_count;
 	int			hardirq_count;
 
@@ -94,15 +95,16 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define TI_FLAGS	0x0c
 #define TI_CPU		0x10
 #define TI_PREEMPT	0x14	/* preempt_count */
-#define TI_SOFTIRQ	0x18	/* softirq_count */
-#define TI_HARDIRQ	0x1c	/* hardirq_count */
-#define TI_KSP		0x20	/* ksp */
-#define TI_KPC		0x24	/* kpc (ldd'ed with kpc) */
-#define TI_KPSR		0x28	/* kpsr */
-#define TI_KWIM		0x2c	/* kwim (ldd'ed with kpsr) */
-#define TI_REG_WINDOW	0x30
-#define TI_RWIN_SPTRS	0x230
-#define TI_W_SAVED	0x250
+/* #define TI_PAGEFAULT	0x18 */ /* pagefault_count */
+#define TI_SOFTIRQ	0x1c	/* softirq_count */
+#define TI_HARDIRQ	0x20	/* hardirq_count */
+#define TI_KSP		0x24	/* ksp */
+#define TI_KPC		0x28	/* kpc (ldd'ed with kpc) */
+#define TI_KPSR		0x2c	/* kpsr */
+#define TI_KWIM		0x30	/* kwim (ldd'ed with kpsr) */
+#define TI_REG_WINDOW	0x34
+#define TI_RWIN_SPTRS	0x234
+#define TI_W_SAVED	0x254
 /* #define TI_RESTART_BLOCK 0x25n */ /* Nobody cares */
 
 /*
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 798f027..4b54608 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -50,6 +50,7 @@ struct thread_info {
 	__u8			current_ds;
 	__u16			cpu;
 
+	int			pagefault_count;/* pagefault_disable() levels */
 	unsigned long		*utraps;
 
 	struct reg_window 	reg_window[NSWINS];
@@ -87,14 +88,14 @@ struct thread_info {
 #define TI_NEW_CHILD	0x0000003c
 #define TI_CURRENT_DS	0x0000003d
 #define TI_CPU		0x0000003e
-#define TI_UTRAPS	0x00000040
-#define TI_REG_WINDOW	0x00000048
-#define TI_RWIN_SPTRS	0x000003c8
-#define TI_GSR		0x00000400
-#define TI_XFSR		0x00000438
-#define TI_RESTART_BLOCK 0x00000470
-#define TI_KUNA_REGS	0x000004a0
-#define TI_KUNA_INSN	0x000004a8
+#define TI_UTRAPS	0x00000048
+#define TI_REG_WINDOW	0x00000050
+#define TI_RWIN_SPTRS	0x000003d0
+#define TI_GSR		0x00000408
+#define TI_XFSR		0x00000440
+#define TI_RESTART_BLOCK 0x00000478
+#define TI_KUNA_REGS	0x000004a8
+#define TI_KUNA_INSN	0x000004b0
 #define TI_FPREGS	0x000004c0
 
 /* We embed this in the uppermost byte of thread_info->flags */
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 48e4fd0..57032b6 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -33,6 +33,7 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 
 	mm_segment_t		addr_limit;	/* thread address space
 						   (KERNEL_DS or USER_DS) */
diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 1c5b2a8..90b193c 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -19,6 +19,7 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;  /* 0 => preemptable,
 						   <0 => BUG */
+	int			pagefault_count;/* pagefault_disable() levels */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user
 						   0-0xFFFFFFFF for kernel */
diff --git a/arch/unicore32/include/asm/thread_info.h b/arch/unicore32/include/asm/thread_info.h
index af36d8e..1d50fb3 100644
--- a/arch/unicore32/include/asm/thread_info.h
+++ b/arch/unicore32/include/asm/thread_info.h
@@ -69,6 +69,7 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			preempt_count;	/* 0 => preemptable */
 						/* <0 => bug */
+	int			pagefault_count;/* pagefault_disable() levels */
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 547e344..fa075ab 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -30,6 +30,7 @@ struct thread_info {
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			saved_preempt_count;
+	int			pagefault_count;/* pagefault_disable() levels */
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 470153e..079e175 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -49,6 +49,7 @@ struct thread_info {
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	__s32			preempt_count;	/* 0 => preemptable,< 0 => BUG*/
+	__s32			pagefault_count;/* pagefault_disable() levels */
 
 	mm_segment_t		addr_limit;	/* thread address space */
 	struct restart_block    restart_block;
@@ -71,8 +72,8 @@ struct thread_info {
 #define TI_STATUS	 0x0000000C
 #define TI_CPU		 0x00000010
 #define TI_PRE_COUNT	 0x00000014
-#define TI_ADDR_LIMIT	 0x00000018
-#define TI_RESTART_BLOCK 0x000001C
+#define TI_ADDR_LIMIT	 0x0000001c
+#define TI_RESTART_BLOCK 0x00000020
 
 #endif
 
-- 
1.8.5.5

