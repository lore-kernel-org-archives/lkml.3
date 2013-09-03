Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab3ICTeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:34:25 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33098 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab3ICTeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:34:20 -0400
Message-ID: <acbde1db294932623aad15dd8cc6e37b28340f26.1378235373.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 3 Sep 2013 14:41:36 -0400
Subject: [PATCH 3/3] tile: parameterize VA and PA space more cleanly
To: Gleb Natapov <gleb@redhat.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20130903173931.GO10142@redhat.com>
References: <52091682.8020004@siemens.com>
  <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
  <20130825113953.GN8218@redhat.com>
  <521AAED7.4080407@tilera.com>
  <20130826120445.GD8218@redhat.com>
  <52261D26.7060206@tilera.com>
  <20130903173931.GO10142@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing code relied on the hardware definition (<arch/chip.h>)
to specify how much VA and PA space was available.  It's convenient
to allow customizing this for some configurations, so provide symbols
MAX_PA_WIDTH and MAX_VA_WIDTH in <asm/page.h> that can be modified
if desired.

Additionally, move away from the MEM_XX_INTRPT nomenclature to
define the start of various regions within the VA space.  In fact
the cleaner symbol is, for example, MEM_SV_START, to indicate the
start of the area used for supervisor code; the actual address of the
interrupt vectors is not as important, and can be changed if desired.
As part of this change, convert from "intrpt1" nomenclature (which
built in the old privilege-level 1 model) to a simple "intrpt".

Also strip out some tilepro-specific code supporting modifying the
PL the kernel could run at, since we don't actually support using
different PLs in tilepro, only tilegx.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/page.h       | 52 +++++++++++++++-----------------------
 arch/tile/include/asm/pgtable_32.h |  2 +-
 arch/tile/include/asm/pgtable_64.h |  3 +--
 arch/tile/include/asm/processor.h  |  2 +-
 arch/tile/kernel/head_32.S         |  4 +--
 arch/tile/kernel/head_64.S         |  6 ++---
 arch/tile/kernel/intvec_32.S       |  6 ++---
 arch/tile/kernel/intvec_64.S       |  8 +++---
 arch/tile/kernel/setup.c           |  8 +++---
 arch/tile/kernel/traps.c           |  2 +-
 arch/tile/kernel/vmlinux.lds.S     | 10 ++++----
 arch/tile/mm/init.c                |  8 +++---
 12 files changed, 51 insertions(+), 60 deletions(-)

diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index b4f96c0..980843d 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -148,8 +148,12 @@ static inline __attribute_const__ int get_order(unsigned long size)
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
 
+/* Allow overriding how much VA or PA the kernel will use. */
+#define MAX_PA_WIDTH CHIP_PA_WIDTH()
+#define MAX_VA_WIDTH CHIP_VA_WIDTH()
+
 /* Each memory controller has PAs distinct in their high bits. */
-#define NR_PA_HIGHBIT_SHIFT (CHIP_PA_WIDTH() - CHIP_LOG_NUM_MSHIMS())
+#define NR_PA_HIGHBIT_SHIFT (MAX_PA_WIDTH - CHIP_LOG_NUM_MSHIMS())
 #define NR_PA_HIGHBIT_VALUES (1 << CHIP_LOG_NUM_MSHIMS())
 #define __pa_to_highbits(pa) ((phys_addr_t)(pa) >> NR_PA_HIGHBIT_SHIFT)
 #define __pfn_to_highbits(pfn) ((pfn) >> (NR_PA_HIGHBIT_SHIFT - PAGE_SHIFT))
@@ -160,7 +164,7 @@ static inline __attribute_const__ int get_order(unsigned long size)
  * We reserve the lower half of memory for user-space programs, and the
  * upper half for system code.  We re-map all of physical memory in the
  * upper half, which takes a quarter of our VA space.  Then we have
- * the vmalloc regions.  The supervisor code lives at 0xfffffff700000000,
+ * the vmalloc regions.  The supervisor code lives at the highest address,
  * with the hypervisor above that.
  *
  * Loadable kernel modules are placed immediately after the static
@@ -172,26 +176,19 @@ static inline __attribute_const__ int get_order(unsigned long size)
  * Similarly, for now we don't play any struct page mapping games.
  */
 
-#if CHIP_PA_WIDTH() + 2 > CHIP_VA_WIDTH()
+#if MAX_PA_WIDTH + 2 > MAX_VA_WIDTH
 # error Too much PA to map with the VA available!
 #endif
-#define HALF_VA_SPACE           (_AC(1, UL) << (CHIP_VA_WIDTH() - 1))
 
-#define MEM_LOW_END		(HALF_VA_SPACE - 1)         /* low half */
-#define MEM_HIGH_START		(-HALF_VA_SPACE)            /* high half */
-#define PAGE_OFFSET		MEM_HIGH_START
-#define FIXADDR_BASE		_AC(0xfffffff400000000, UL) /* 4 GB */
-#define FIXADDR_TOP		_AC(0xfffffff500000000, UL) /* 4 GB */
+#define PAGE_OFFSET		(-(_AC(1, UL) << (MAX_VA_WIDTH - 1)))
+#define KERNEL_HIGH_VADDR	_AC(0xfffffff800000000, UL)  /* high 32GB */
+#define FIXADDR_BASE		(KERNEL_HIGH_VADDR - 0x400000000) /* 4 GB */
+#define FIXADDR_TOP		(KERNEL_HIGH_VADDR - 0x300000000) /* 4 GB */
 #define _VMALLOC_START		FIXADDR_TOP
-#define HUGE_VMAP_BASE		_AC(0xfffffff600000000, UL) /* 4 GB */
-#define MEM_SV_START		_AC(0xfffffff700000000, UL) /* 256 MB */
-#define MEM_SV_INTRPT		MEM_SV_START
-#define MEM_MODULE_START	_AC(0xfffffff710000000, UL) /* 256 MB */
+#define HUGE_VMAP_BASE		(KERNEL_HIGH_VADDR - 0x200000000) /* 4 GB */
+#define MEM_SV_START		(KERNEL_HIGH_VADDR - 0x100000000) /* 256 MB */
+#define MEM_MODULE_START	(MEM_SV_START + (256*1024*1024)) /* 256 MB */
 #define MEM_MODULE_END		(MEM_MODULE_START + (256*1024*1024))
-#define MEM_HV_START		_AC(0xfffffff800000000, UL) /* 32 GB */
-
-/* Highest DTLB address we will use */
-#define KERNEL_HIGH_VADDR	MEM_SV_START
 
 #else /* !__tilegx__ */
 
@@ -213,25 +210,18 @@ static inline __attribute_const__ int get_order(unsigned long size)
  * values, and after that, we show "typical" values, since the actual
  * addresses depend on kernel #defines.
  *
- * MEM_HV_INTRPT                   0xfe000000
- * MEM_SV_INTRPT (kernel code)     0xfd000000
+ * MEM_HV_START                    0xfe000000
+ * MEM_SV_START  (kernel code)     0xfd000000
  * MEM_USER_INTRPT (user vector)   0xfc000000
- * FIX_KMAP_xxx                    0xf8000000 (via NR_CPUS * KM_TYPE_NR)
- * PKMAP_BASE                      0xf7000000 (via LAST_PKMAP)
- * HUGE_VMAP                       0xf3000000 (via CONFIG_NR_HUGE_VMAPS)
- * VMALLOC_START                   0xf0000000 (via __VMALLOC_RESERVE)
+ * FIX_KMAP_xxx                    0xfa000000 (via NR_CPUS * KM_TYPE_NR)
+ * PKMAP_BASE                      0xf9000000 (via LAST_PKMAP)
+ * VMALLOC_START                   0xf7000000 (via VMALLOC_RESERVE)
  * mapped LOWMEM                   0xc0000000
  */
 
 #define MEM_USER_INTRPT		_AC(0xfc000000, UL)
-#if CONFIG_KERNEL_PL == 1
-#define MEM_SV_INTRPT		_AC(0xfd000000, UL)
-#define MEM_HV_INTRPT		_AC(0xfe000000, UL)
-#else
-#define MEM_GUEST_INTRPT	_AC(0xfd000000, UL)
-#define MEM_SV_INTRPT		_AC(0xfe000000, UL)
-#define MEM_HV_INTRPT		_AC(0xff000000, UL)
-#endif
+#define MEM_SV_START		_AC(0xfd000000, UL)
+#define MEM_HV_START		_AC(0xfe000000, UL)
 
 #define INTRPT_SIZE		0x4000
 
diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
index e5bdc0e..63142ab 100644
--- a/arch/tile/include/asm/pgtable_32.h
+++ b/arch/tile/include/asm/pgtable_32.h
@@ -89,7 +89,7 @@ static inline int pud_huge_page(pud_t pud)	{ return 0; }
 /* We don't define any pgds for these addresses. */
 static inline int pgd_addr_invalid(unsigned long addr)
 {
-	return addr >= MEM_HV_INTRPT;
+	return addr >= MEM_HV_START;
 }
 
 /*
diff --git a/arch/tile/include/asm/pgtable_64.h b/arch/tile/include/asm/pgtable_64.h
index 7cb8d35..3421177 100644
--- a/arch/tile/include/asm/pgtable_64.h
+++ b/arch/tile/include/asm/pgtable_64.h
@@ -140,8 +140,7 @@ static inline unsigned long pgd_addr_normalize(unsigned long addr)
 /* We don't define any pgds for these addresses. */
 static inline int pgd_addr_invalid(unsigned long addr)
 {
-	return addr >= MEM_HV_START ||
-		(addr > MEM_LOW_END && addr < MEM_HIGH_START);
+	return addr >= KERNEL_HIGH_VADDR || addr != pgd_addr_normalize(addr);
 }
 
 /*
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index c72fcba..5aa5431 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -168,7 +168,7 @@ struct thread_struct {
 #ifndef __ASSEMBLY__
 
 #ifdef __tilegx__
-#define TASK_SIZE_MAX		(MEM_LOW_END + 1)
+#define TASK_SIZE_MAX		(_AC(1, UL) << (MAX_VA_WIDTH - 1))
 #else
 #define TASK_SIZE_MAX		PAGE_OFFSET
 #endif
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index f3f17b0..8d5b40f 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -162,8 +162,8 @@ ENTRY(swapper_pg_dir)
 	.set addr, addr + PGDIR_SIZE
 	.endr
 
-	/* The true text VAs are mapped as VA = PA + MEM_SV_INTRPT */
-	PTE MEM_SV_INTRPT, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
+	/* The true text VAs are mapped as VA = PA + MEM_SV_START */
+	PTE MEM_SV_START, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
 			      (1 << (HV_PTE_INDEX_EXECUTABLE - 32))
 	.org swapper_pg_dir + PGDIR_SIZE
 	END(swapper_pg_dir)
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index 652b814..bd0e12f 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -135,9 +135,9 @@ ENTRY(_start)
 1:
 
 	/* Install the interrupt base. */
-	moveli r0, hw2_last(MEM_SV_START)
-	shl16insli r0, r0, hw1(MEM_SV_START)
-	shl16insli r0, r0, hw0(MEM_SV_START)
+	moveli r0, hw2_last(intrpt_start)
+	shl16insli r0, r0, hw1(intrpt_start)
+	shl16insli r0, r0, hw0(intrpt_start)
 	mtspr SPR_INTERRUPT_VECTOR_BASE_K, r0
 
 	/* Get our processor number and save it away in SAVE_K_0. */
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index f3d26f4..f084f1c 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -353,7 +353,7 @@ intvec_\vecname:
 #ifdef __COLLECT_LINKER_FEEDBACK__
 	.pushsection .text.intvec_feedback,"ax"
 	.org    (\vecnum << 5)
-	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt1, 1 << 8)
+	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt, 1 << 8)
 	jrp     lr
 	.popsection
 #endif
@@ -1890,8 +1890,8 @@ int_unalign:
 	push_extra_callee_saves r0
 	j       do_trap
 
-/* Include .intrpt1 array of interrupt vectors */
-	.section ".intrpt1", "ax"
+/* Include .intrpt array of interrupt vectors */
+	.section ".intrpt", "ax"
 
 #define op_handle_perf_interrupt bad_intr
 #define op_handle_aux_perf_interrupt bad_intr
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index f020f01..c3a2335 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -535,7 +535,7 @@ intvec_\vecname:
 #ifdef __COLLECT_LINKER_FEEDBACK__
 	.pushsection .text.intvec_feedback,"ax"
 	.org    (\vecnum << 5)
-	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt1, 1 << 8)
+	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt, 1 << 8)
 	jrp     lr
 	.popsection
 #endif
@@ -1485,8 +1485,10 @@ STD_ENTRY(fill_ra_stack)
 		__int_hand   \vecnum, \vecname, \c_routine, \processing
 	.endm
 
-/* Include .intrpt1 array of interrupt vectors */
-	.section ".intrpt1", "ax"
+/* Include .intrpt array of interrupt vectors */
+	.section ".intrpt", "ax"
+	.global intrpt_start
+intrpt_start:
 
 #define op_handle_perf_interrupt bad_intr
 #define op_handle_aux_perf_interrupt bad_intr
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 774e819..1021784 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -268,7 +268,7 @@ early_param("vmalloc", parse_vmalloc);
 /*
  * Determine for each controller where its lowmem is mapped and how much of
  * it is mapped there.  On controller zero, the first few megabytes are
- * already mapped in as code at MEM_SV_INTRPT, so in principle we could
+ * already mapped in as code at MEM_SV_START, so in principle we could
  * start our data mappings higher up, but for now we don't bother, to avoid
  * additional confusion.
  *
@@ -1242,7 +1242,7 @@ static void __init validate_va(void)
 #ifndef __tilegx__   /* FIXME: GX: probably some validation relevant here */
 	/*
 	 * Similarly, make sure we're only using allowed VAs.
-	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_INTRPT,
+	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_START,
 	 * and 0 .. KERNEL_HIGH_VADDR.
 	 * In addition, make sure we CAN'T use the end of memory, since
 	 * we use the last chunk of each pgd for the pgd_list.
@@ -1257,7 +1257,7 @@ static void __init validate_va(void)
 		if (range.size == 0)
 			break;
 		if (range.start <= MEM_USER_INTRPT &&
-		    range.start + range.size >= MEM_HV_INTRPT)
+		    range.start + range.size >= MEM_HV_START)
 			user_kernel_ok = 1;
 		if (range.start == 0)
 			max_va = range.size;
@@ -1693,7 +1693,7 @@ insert_ram_resource(u64 start_pfn, u64 end_pfn, bool reserved)
 static int __init request_standard_resources(void)
 {
 	int i;
-	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
+	enum { CODE_DELTA = MEM_SV_START - PAGE_OFFSET };
 
 #if defined(CONFIG_PCI) && !defined(__tilegx__)
 	insert_non_bus_resource();
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index cfff6f9..628661f 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -30,7 +30,7 @@
 
 void __init trap_init(void)
 {
-	/* Nothing needed here since we link code at .intrpt1 */
+	/* Nothing needed here since we link code at .intrpt */
 }
 
 int unaligned_fixup = 1;
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index c7ae53d..8b20163 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -5,7 +5,7 @@
 #include <hv/hypervisor.h>
 
 /* Text loads starting from the supervisor interrupt vector address. */
-#define TEXT_OFFSET MEM_SV_INTRPT
+#define TEXT_OFFSET MEM_SV_START
 
 OUTPUT_ARCH(tile)
 ENTRY(_start)
@@ -13,7 +13,7 @@ jiffies = jiffies_64;
 
 PHDRS
 {
-  intrpt1 PT_LOAD ;
+  intrpt PT_LOAD ;
   text PT_LOAD ;
   data PT_LOAD ;
 }
@@ -24,11 +24,11 @@ SECTIONS
   #define LOAD_OFFSET TEXT_OFFSET
 
   /* Interrupt vectors */
-  .intrpt1 (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
+  .intrpt (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
   {
     _text = .;
-    *(.intrpt1)
-  } :intrpt1 =0
+    *(.intrpt)
+  } :intrpt =0
 
   /* Hypervisor call vectors */
   . = ALIGN(0x10000);
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 3bfa127..c6d2160 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -234,7 +234,7 @@ static pgprot_t __init init_pgprot(ulong address)
 {
 	int cpu;
 	unsigned long page;
-	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
+	enum { CODE_DELTA = MEM_SV_START - PAGE_OFFSET };
 
 #if CHIP_HAS_CBOX_HOME_MAP()
 	/* For kdata=huge, everything is just hash-for-home. */
@@ -538,7 +538,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 		}
 	}
 
-	address = MEM_SV_INTRPT;
+	address = MEM_SV_START;
 	pmd = get_pmd(pgtables, address);
 	pfn = 0;  /* code starts at PA 0 */
 	if (ktext_small) {
@@ -1021,7 +1021,7 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 
 void free_initmem(void)
 {
-	const unsigned long text_delta = MEM_SV_INTRPT - PAGE_OFFSET;
+	const unsigned long text_delta = MEM_SV_START - PAGE_OFFSET;
 
 	/*
 	 * Evict the dirty initdata on the boot cpu, evict the w1data
@@ -1040,7 +1040,7 @@ void free_initmem(void)
 
 	/*
 	 * Free the pages mapped from 0xc0000000 that correspond to code
-	 * pages from MEM_SV_INTRPT that we won't use again after init.
+	 * pages from MEM_SV_START that we won't use again after init.
 	 */
 	free_init_pages("unused kernel text",
 			(unsigned long)_sinittext - text_delta,
-- 
1.8.3.1

