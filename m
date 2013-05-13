Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3EMU5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:57:06 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:59531 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3EMU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:56:51 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, "Steven J. Hill" <Steven.Hill@imgtec.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] Revert "MIPS: Allow ASID size to be determined at boot time."
Date: Mon, 13 May 2013 13:56:44 -0700
Message-Id: <1368478604-14732-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368478604-14732-1-git-send-email-ddaney.cavm@gmail.com>
References: <1368478604-14732-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This reverts commit d532f3d26716a39dfd4b88d687bd344fbe77e390.

The original commit has several problems:

1) Doesn't work with 64-bit kernels.

2) Calls TLBMISS_HANDLER_SETUP() before the code is generated.

3) Calls TLBMISS_HANDLER_SETUP() twice in per_cpu_trap_init() when
   only one call is needed.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/mmu_context.h | 95 ++++++++++++++-----------------------
 arch/mips/kernel/genex.S            |  2 +-
 arch/mips/kernel/smtc.c             | 10 ++--
 arch/mips/kernel/traps.c            |  6 +--
 arch/mips/lib/dump_tlb.c            |  5 +-
 arch/mips/lib/r3k_dump_tlb.c        |  7 ++-
 arch/mips/mm/tlb-r3k.c              | 20 ++++----
 arch/mips/mm/tlb-r4k.c              |  2 +-
 arch/mips/mm/tlb-r8k.c              |  2 +-
 arch/mips/mm/tlbex.c                | 49 -------------------
 10 files changed, 61 insertions(+), 137 deletions(-)

diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
index 1554721..8201160 100644
--- a/arch/mips/include/asm/mmu_context.h
+++ b/arch/mips/include/asm/mmu_context.h
@@ -67,68 +67,45 @@ extern unsigned long pgd_current[];
 	TLBMISS_HANDLER_SETUP_PGD(swapper_pg_dir)
 #endif
 #endif /* CONFIG_MIPS_PGD_C0_CONTEXT*/
+#if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
 
-#define ASID_INC(asid)						\
-({								\
-	unsigned long __asid = asid;				\
-	__asm__("1:\taddiu\t%0,1\t\t\t\t# patched\n\t"		\
-	".section\t__asid_inc,\"a\"\n\t"			\
-	".word\t1b\n\t"						\
-	".previous"						\
-	:"=r" (__asid)						\
-	:"0" (__asid));						\
-	__asid;							\
-})
-#define ASID_MASK(asid)						\
-({								\
-	unsigned long __asid = asid;				\
-	__asm__("1:\tandi\t%0,%1,0xfc0\t\t\t# patched\n\t"	\
-	".section\t__asid_mask,\"a\"\n\t"			\
-	".word\t1b\n\t"						\
-	".previous"						\
-	:"=r" (__asid)						\
-	:"r" (__asid));						\
-	__asid;							\
-})
-#define ASID_VERSION_MASK					\
-({								\
-	unsigned long __asid;					\
-	__asm__("1:\taddiu\t%0,$0,0xff00\t\t\t\t# patched\n\t"	\
-	".section\t__asid_version_mask,\"a\"\n\t"		\
-	".word\t1b\n\t"						\
-	".previous"						\
-	:"=r" (__asid));					\
-	__asid;							\
-})
-#define ASID_FIRST_VERSION					\
-({								\
-	unsigned long __asid = asid;				\
-	__asm__("1:\tli\t%0,0x100\t\t\t\t# patched\n\t"		\
-	".section\t__asid_first_version,\"a\"\n\t"		\
-	".word\t1b\n\t"						\
-	".previous"						\
-	:"=r" (__asid));					\
-	__asid;							\
-})
-
-#define ASID_FIRST_VERSION_R3000	0x1000
-#define ASID_FIRST_VERSION_R4000	0x100
-#define ASID_FIRST_VERSION_R8000	0x1000
-#define ASID_FIRST_VERSION_RM9000	0x1000
+#define ASID_INC	0x40
+#define ASID_MASK	0xfc0
+
+#elif defined(CONFIG_CPU_R8000)
+
+#define ASID_INC	0x10
+#define ASID_MASK	0xff0
+
+#elif defined(CONFIG_MIPS_MT_SMTC)
+
+#define ASID_INC	0x1
+extern unsigned long smtc_asid_mask;
+#define ASID_MASK	(smtc_asid_mask)
+#define HW_ASID_MASK	0xff
+/* End SMTC/34K debug hack */
+#else /* FIXME: not correct for R6000 */
+
+#define ASID_INC	0x1
+#define ASID_MASK	0xff
 
-#ifdef CONFIG_MIPS_MT_SMTC
-#define SMTC_HW_ASID_MASK		0xff
-extern unsigned int smtc_asid_mask;
 #endif
 
 #define cpu_context(cpu, mm)	((mm)->context.asid[cpu])
-#define cpu_asid(cpu, mm)	ASID_MASK(cpu_context((cpu), (mm)))
+#define cpu_asid(cpu, mm)	(cpu_context((cpu), (mm)) & ASID_MASK)
 #define asid_cache(cpu)		(cpu_data[cpu].asid_cache)
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 }
 
+/*
+ *  All unused by hardware upper bits will be considered
+ *  as a software asid extension.
+ */
+#define ASID_VERSION_MASK  ((unsigned long)~(ASID_MASK|(ASID_MASK-1)))
+#define ASID_FIRST_VERSION ((unsigned long)(~ASID_VERSION_MASK) + 1)
+
 #ifndef CONFIG_MIPS_MT_SMTC
 /* Normal, classic MIPS get_new_mmu_context */
 static inline void
@@ -137,7 +114,7 @@ get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
 	extern void kvm_local_flush_tlb_all(void);
 	unsigned long asid = asid_cache(cpu);
 
-	if (!ASID_MASK((asid = ASID_INC(asid)))) {
+	if (! ((asid += ASID_INC) & ASID_MASK) ) {
 		if (cpu_has_vtag_icache)
 			flush_icache_all();
 #ifdef CONFIG_VIRTUALIZATION
@@ -200,7 +177,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	 * free up the ASID value for use and flush any old
 	 * instances of it from the TLB.
 	 */
-	oldasid = ASID_MASK(read_c0_entryhi());
+	oldasid = (read_c0_entryhi() & ASID_MASK);
 	if(smtc_live_asid[mytlb][oldasid]) {
 		smtc_live_asid[mytlb][oldasid] &= ~(0x1 << cpu);
 		if(smtc_live_asid[mytlb][oldasid] == 0)
@@ -211,7 +188,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	 * having ASID_MASK smaller than the hardware maximum,
 	 * make sure no "soft" bits become "hard"...
 	 */
-	write_c0_entryhi((read_c0_entryhi() & ~SMTC_HW_ASID_MASK) |
+	write_c0_entryhi((read_c0_entryhi() & ~HW_ASID_MASK) |
 			 cpu_asid(cpu, next));
 	ehb(); /* Make sure it propagates to TCStatus */
 	evpe(mtflags);
@@ -264,15 +241,15 @@ activate_mm(struct mm_struct *prev, struct mm_struct *next)
 #ifdef CONFIG_MIPS_MT_SMTC
 	/* See comments for similar code above */
 	mtflags = dvpe();
-	oldasid = ASID_MASK(read_c0_entryhi());
+	oldasid = read_c0_entryhi() & ASID_MASK;
 	if(smtc_live_asid[mytlb][oldasid]) {
 		smtc_live_asid[mytlb][oldasid] &= ~(0x1 << cpu);
 		if(smtc_live_asid[mytlb][oldasid] == 0)
 			 smtc_flush_tlb_asid(oldasid);
 	}
 	/* See comments for similar code above */
-	write_c0_entryhi((read_c0_entryhi() & ~SMTC_HW_ASID_MASK) |
-	                 cpu_asid(cpu, next));
+	write_c0_entryhi((read_c0_entryhi() & ~HW_ASID_MASK) |
+			 cpu_asid(cpu, next));
 	ehb(); /* Make sure it propagates to TCStatus */
 	evpe(mtflags);
 #else
@@ -309,14 +286,14 @@ drop_mmu_context(struct mm_struct *mm, unsigned cpu)
 #ifdef CONFIG_MIPS_MT_SMTC
 		/* See comments for similar code above */
 		prevvpe = dvpe();
-		oldasid = ASID_MASK(read_c0_entryhi());
+		oldasid = (read_c0_entryhi() & ASID_MASK);
 		if (smtc_live_asid[mytlb][oldasid]) {
 			smtc_live_asid[mytlb][oldasid] &= ~(0x1 << cpu);
 			if(smtc_live_asid[mytlb][oldasid] == 0)
 				smtc_flush_tlb_asid(oldasid);
 		}
 		/* See comments for similar code above */
-		write_c0_entryhi((read_c0_entryhi() & ~SMTC_HW_ASID_MASK)
+		write_c0_entryhi((read_c0_entryhi() & ~HW_ASID_MASK)
 				| cpu_asid(cpu, mm));
 		ehb(); /* Make sure it propagates to TCStatus */
 		evpe(prevvpe);
diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 5c2ba9f..9098829 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -493,7 +493,7 @@ NESTED(nmi_handler, PT_SIZE, sp)
 	.set	noreorder
 	/* check if TLB contains a entry for EPC */
 	MFC0	k1, CP0_ENTRYHI
-	andi	k1, 0xff	/* ASID_MASK patched at run-time!! */
+	andi	k1, 0xff	/* ASID_MASK */
 	MFC0	k0, CP0_EPC
 	PTR_SRL k0, _PAGE_SHIFT + 1
 	PTR_SLL k0, _PAGE_SHIFT + 1
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 31d22f3..7186222 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -111,7 +111,7 @@ static int vpe0limit;
 static int ipibuffers;
 static int nostlb;
 static int asidmask;
-unsigned int smtc_asid_mask = 0xff;
+unsigned long smtc_asid_mask = 0xff;
 
 static int __init vpe0tcs(char *str)
 {
@@ -1395,7 +1395,7 @@ void smtc_get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
 	asid = asid_cache(cpu);
 
 	do {
-		if (!ASID_MASK(ASID_INC(asid))) {
+		if (!((asid += ASID_INC) & ASID_MASK) ) {
 			if (cpu_has_vtag_icache)
 				flush_icache_all();
 			/* Traverse all online CPUs (hack requires contiguous range) */
@@ -1414,7 +1414,7 @@ void smtc_get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
 						mips_ihb();
 					}
 					tcstat = read_tc_c0_tcstatus();
-					smtc_live_asid[tlb][ASID_MASK(tcstat)] |= (asiduse)(0x1 << i);
+					smtc_live_asid[tlb][(tcstat & ASID_MASK)] |= (asiduse)(0x1 << i);
 					if (!prevhalt)
 						write_tc_c0_tchalt(0);
 				}
@@ -1423,7 +1423,7 @@ void smtc_get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
 				asid = ASID_FIRST_VERSION;
 			local_flush_tlb_all();	/* start new asid cycle */
 		}
-	} while (smtc_live_asid[tlb][ASID_MASK(asid)]);
+	} while (smtc_live_asid[tlb][(asid & ASID_MASK)]);
 
 	/*
 	 * SMTC shares the TLB within VPEs and possibly across all VPEs.
@@ -1461,7 +1461,7 @@ void smtc_flush_tlb_asid(unsigned long asid)
 		tlb_read();
 		ehb();
 		ehi = read_c0_entryhi();
-		if (ASID_MASK(ehi) == asid) {
+		if ((ehi & ASID_MASK) == asid) {
 		    /*
 		     * Invalidate only entries with specified ASID,
 		     * makiing sure all entries differ.
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 77cff1f..cb14db3 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1656,7 +1656,6 @@ void __cpuinit per_cpu_trap_init(bool is_boot_cpu)
 	unsigned int cpu = smp_processor_id();
 	unsigned int status_set = ST0_CU0;
 	unsigned int hwrena = cpu_hwrena_impl_bits;
-	unsigned long asid = 0;
 #ifdef CONFIG_MIPS_MT_SMTC
 	int secondaryTC = 0;
 	int bootTC = (cpu == 0);
@@ -1740,9 +1739,8 @@ void __cpuinit per_cpu_trap_init(bool is_boot_cpu)
 	}
 #endif /* CONFIG_MIPS_MT_SMTC */
 
-	asid = ASID_FIRST_VERSION;
-	cpu_data[cpu].asid_cache = asid;
-	TLBMISS_HANDLER_SETUP();
+	if (!cpu_data[cpu].asid_cache)
+		cpu_data[cpu].asid_cache = ASID_FIRST_VERSION;
 
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
diff --git a/arch/mips/lib/dump_tlb.c b/arch/mips/lib/dump_tlb.c
index 8a12d00..32b9f21 100644
--- a/arch/mips/lib/dump_tlb.c
+++ b/arch/mips/lib/dump_tlb.c
@@ -11,7 +11,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/tlbdebug.h>
-#include <asm/mmu_context.h>
 
 static inline const char *msk2str(unsigned int mask)
 {
@@ -56,7 +55,7 @@ static void dump_tlb(int first, int last)
 	s_pagemask = read_c0_pagemask();
 	s_entryhi = read_c0_entryhi();
 	s_index = read_c0_index();
-	asid = ASID_MASK(s_entryhi);
+	asid = s_entryhi & 0xff;
 
 	for (i = first; i <= last; i++) {
 		write_c0_index(i);
@@ -86,7 +85,7 @@ static void dump_tlb(int first, int last)
 
 			printk("va=%0*lx asid=%02lx\n",
 			       width, (entryhi & ~0x1fffUL),
-			       ASID_MASK(entryhi));
+			       entryhi & 0xff);
 			printk("\t[pa=%0*llx c=%d d=%d v=%d g=%d] ",
 			       width,
 			       (entrylo0 << 6) & PAGE_MASK, c0,
diff --git a/arch/mips/lib/r3k_dump_tlb.c b/arch/mips/lib/r3k_dump_tlb.c
index 8327698..91615c2 100644
--- a/arch/mips/lib/r3k_dump_tlb.c
+++ b/arch/mips/lib/r3k_dump_tlb.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 
 #include <asm/mipsregs.h>
-#include <asm/mmu_context.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/tlbdebug.h>
@@ -22,7 +21,7 @@ static void dump_tlb(int first, int last)
 	unsigned int asid;
 	unsigned long entryhi, entrylo0;
 
-	asid = ASID_MASK(read_c0_entryhi());
+	asid = read_c0_entryhi() & 0xfc0;
 
 	for (i = first; i <= last; i++) {
 		write_c0_index(i<<8);
@@ -36,7 +35,7 @@ static void dump_tlb(int first, int last)
 
 		/* Unused entries have a virtual address of KSEG0.  */
 		if ((entryhi & 0xffffe000) != 0x80000000
-		    && (ASID_MASK(entryhi) == asid)) {
+		    && (entryhi & 0xfc0) == asid) {
 			/*
 			 * Only print entries in use
 			 */
@@ -45,7 +44,7 @@ static void dump_tlb(int first, int last)
 			printk("va=%08lx asid=%08lx"
 			       "  [pa=%06lx n=%d d=%d v=%d g=%d]",
 			       (entryhi & 0xffffe000),
-			       ASID_MASK(entryhi),
+			       entryhi & 0xfc0,
 			       entrylo0 & PAGE_MASK,
 			       (entrylo0 & (1 << 11)) ? 1 : 0,
 			       (entrylo0 & (1 << 10)) ? 1 : 0,
diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index 4a13c15..a63d1ed 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -51,7 +51,7 @@ void local_flush_tlb_all(void)
 #endif
 
 	local_irq_save(flags);
-	old_ctx = ASID_MASK(read_c0_entryhi());
+	old_ctx = read_c0_entryhi() & ASID_MASK;
 	write_c0_entrylo0(0);
 	entry = r3k_have_wired_reg ? read_c0_wired() : 8;
 	for (; entry < current_cpu_data.tlbsize; entry++) {
@@ -87,13 +87,13 @@ void local_flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 
 #ifdef DEBUG_TLB
 		printk("[tlbrange<%lu,0x%08lx,0x%08lx>]",
-			ASID_MASK(cpu_context(cpu, mm)), start, end);
+			cpu_context(cpu, mm) & ASID_MASK, start, end);
 #endif
 		local_irq_save(flags);
 		size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
 		if (size <= current_cpu_data.tlbsize) {
-			int oldpid = ASID_MASK(read_c0_entryhi());
-			int newpid = ASID_MASK(cpu_context(cpu, mm));
+			int oldpid = read_c0_entryhi() & ASID_MASK;
+			int newpid = cpu_context(cpu, mm) & ASID_MASK;
 
 			start &= PAGE_MASK;
 			end += PAGE_SIZE - 1;
@@ -166,10 +166,10 @@ void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 #ifdef DEBUG_TLB
 		printk("[tlbpage<%lu,0x%08lx>]", cpu_context(cpu, vma->vm_mm), page);
 #endif
-		newpid = ASID_MASK(cpu_context(cpu, vma->vm_mm));
+		newpid = cpu_context(cpu, vma->vm_mm) & ASID_MASK;
 		page &= PAGE_MASK;
 		local_irq_save(flags);
-		oldpid = ASID_MASK(read_c0_entryhi());
+		oldpid = read_c0_entryhi() & ASID_MASK;
 		write_c0_entryhi(page | newpid);
 		BARRIER;
 		tlb_probe();
@@ -197,10 +197,10 @@ void __update_tlb(struct vm_area_struct *vma, unsigned long address, pte_t pte)
 	if (current->active_mm != vma->vm_mm)
 		return;
 
-	pid = ASID_MASK(read_c0_entryhi());
+	pid = read_c0_entryhi() & ASID_MASK;
 
 #ifdef DEBUG_TLB
-	if ((pid != ASID_MASK(cpu_context(cpu, vma->vm_mm))) || (cpu_context(cpu, vma->vm_mm) == 0)) {
+	if ((pid != (cpu_context(cpu, vma->vm_mm) & ASID_MASK)) || (cpu_context(cpu, vma->vm_mm) == 0)) {
 		printk("update_mmu_cache: Wheee, bogus tlbpid mmpid=%lu tlbpid=%d\n",
 		       (cpu_context(cpu, vma->vm_mm)), pid);
 	}
@@ -241,7 +241,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 
 		local_irq_save(flags);
 		/* Save old context and create impossible VPN2 value */
-		old_ctx = ASID_MASK(read_c0_entryhi());
+		old_ctx = read_c0_entryhi() & ASID_MASK;
 		old_pagemask = read_c0_pagemask();
 		w = read_c0_wired();
 		write_c0_wired(w + 1);
@@ -264,7 +264,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 #endif
 
 		local_irq_save(flags);
-		old_ctx = ASID_MASK(read_c0_entryhi());
+		old_ctx = read_c0_entryhi() & ASID_MASK;
 		write_c0_entrylo0(entrylo0);
 		write_c0_entryhi(entryhi);
 		write_c0_index(wired);
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 09653b2..c643de4 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -287,7 +287,7 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 
 	ENTER_CRITICAL(flags);
 
-	pid = ASID_MASK(read_c0_entryhi());
+	pid = read_c0_entryhi() & ASID_MASK;
 	address &= (PAGE_MASK << 1);
 	write_c0_entryhi(address | pid);
 	pgdp = pgd_offset(vma->vm_mm, address);
diff --git a/arch/mips/mm/tlb-r8k.c b/arch/mips/mm/tlb-r8k.c
index 122f920..91c2499 100644
--- a/arch/mips/mm/tlb-r8k.c
+++ b/arch/mips/mm/tlb-r8k.c
@@ -195,7 +195,7 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 	if (current->active_mm != vma->vm_mm)
 		return;
 
-	pid = ASID_MASK(read_c0_entryhi());
+	pid = read_c0_entryhi() & ASID_MASK;
 
 	local_irq_save(flags);
 	address &= PAGE_MASK;
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 2ad41e9..ce9818e 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -29,7 +29,6 @@
 #include <linux/init.h>
 #include <linux/cache.h>
 
-#include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 #include <asm/war.h>
@@ -306,48 +305,6 @@ static struct uasm_reloc relocs[128] __cpuinitdata;
 static int check_for_high_segbits __cpuinitdata;
 #endif
 
-static void __cpuinit insn_fixup(unsigned int **start, unsigned int **stop,
-					unsigned int i_const)
-{
-	unsigned int **p, *ip;
-
-	for (p = start; p < stop; p++) {
-		ip = *p;
-		*ip = (*ip & 0xffff0000) | i_const;
-	}
-	local_flush_icache_range((unsigned long)*p, (unsigned long)((*p) + 1));
-}
-
-#define asid_insn_fixup(section, const)					\
-do {									\
-	extern unsigned int *__start_ ## section;			\
-	extern unsigned int *__stop_ ## section;			\
-	insn_fixup(&__start_ ## section, &__stop_ ## section, const);	\
-} while(0)
-
-/*
- * Caller is assumed to flush the caches before the first context switch.
- */
-static void __cpuinit setup_asid(unsigned int inc, unsigned int mask,
-				 unsigned int version_mask,
-				 unsigned int first_version)
-{
-	extern asmlinkage void handle_ri_rdhwr_vivt(void);
-	unsigned long *vivt_exc;
-
-	asid_insn_fixup(__asid_inc, inc);
-	asid_insn_fixup(__asid_mask, mask);
-	asid_insn_fixup(__asid_version_mask, version_mask);
-	asid_insn_fixup(__asid_first_version, first_version);
-
-	/* Patch up the 'handle_ri_rdhwr_vivt' handler. */
-	vivt_exc = (unsigned long *) &handle_ri_rdhwr_vivt;
-	vivt_exc++;
-	*vivt_exc = (*vivt_exc & ~mask) | mask;
-
-	current_cpu_data.asid_cache = first_version;
-}
-
 static int check_for_high_segbits __cpuinitdata;
 
 static unsigned int kscratch_used_mask __cpuinitdata;
@@ -2226,7 +2183,6 @@ void __cpuinit build_tlb_refill_handler(void)
 	case CPU_TX3922:
 	case CPU_TX3927:
 #ifndef CONFIG_MIPS_PGD_C0_CONTEXT
-		setup_asid(0x40, 0xfc0, 0xf000, ASID_FIRST_VERSION_R3000);
 		if (cpu_has_local_ebase)
 			build_r3000_tlb_refill_handler();
 		if (!run_once) {
@@ -2252,11 +2208,6 @@ void __cpuinit build_tlb_refill_handler(void)
 		break;
 
 	default:
-#ifndef CONFIG_MIPS_MT_SMTC
-		setup_asid(0x1, 0xff, 0xff00, ASID_FIRST_VERSION_R4000);
-#else
-		setup_asid(0x1, smtc_asid_mask, 0xff00, ASID_FIRST_VERSION_R4000);
-#endif
 		if (!run_once) {
 			scratch_reg = allocate_kscratch();
 #ifdef CONFIG_MIPS_PGD_C0_CONTEXT
-- 
1.7.11.7

