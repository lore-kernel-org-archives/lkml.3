Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3IKEe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:34:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3IKEeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:34:09 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=lpYQF5N65tkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GTO9e9BCcVgA:10 a=zd2uoN0lAAAA:8 a=RpB8WmTJAAAA:8 a=TSbVqHtbAAAA:8 a=VwQbUJbxAAAA:8 a=In_Hgl4hAAAA:8 a=-GgRe3u82Dny4qLpoYUA:9 a=CjuIK1q_8ugA:10 a=Sf_gFPzhefAA:10 a=ro211Ng2IWAA:10 a=8Nk35Wv_634DZkrw:21 a=r87sXt2MqGx8WJa3:21 a=WaW0N-3QInStnYNS:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 00:34:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [000/251] 3.6.11.9-rc1-stable review
Message-ID: <20130911003403.6a6d2977@gandalf.local.home>
In-Reply-To: <20130911042707.738353451@goodmis.org>
References: <20130911042707.738353451@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/i2c/busses/i2c-piix4
b/Documentation/i2c/busses/i2c-piix4 index 1e6634f..a370b20 100644
--- a/Documentation/i2c/busses/i2c-piix4
+++ b/Documentation/i2c/busses/i2c-piix4
@@ -13,7 +13,7 @@ Supported adapters:
   * AMD SP5100 (SB700 derivative found on some server mainboards)
     Datasheet: Publicly available at the AMD website
     http://support.amd.com/us/Embedded_TechDocs/44413.pdf
-  * AMD Hudson-2
+  * AMD Hudson-2, CZ
     Datasheet: Not publicly available
   * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
     Datasheet: Publicly available at the SMSC website
http://www.smsc.com diff --git a/Makefile b/Makefile
index 3d4cbd5..c0562c8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 6
 SUBLEVEL = 11
-EXTRAVERSION = .8
+EXTRAVERSION = .9-rc1
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 589bdba..ca5e665 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -183,7 +183,8 @@ config VECTORS_BASE
 	default DRAM_BASE if REMAP_VECTORS_TO_RAM
 	default 0x00000000
 	help
-	  The base address of exception vectors.
+	  The base address of exception vectors.  This must be two
pages
+	  in size.
 
 config ARM_PATCH_PHYS_VIRT
 	bool "Patch physical to virtual translations at runtime" if
EMBEDDED diff --git a/arch/arm/boot/compressed/atags_to_fdt.c
b/arch/arm/boot/compressed/atags_to_fdt.c index aabc02a..d1153c8 100644
--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -53,6 +53,17 @@ static const void *getprop(const void *fdt, const
char *node_path, return fdt_getprop(fdt, offset, property, len);
 }
 
+static uint32_t get_cell_size(const void *fdt)
+{
+	int len;
+	uint32_t cell_size = 1;
+	const uint32_t *size_len =  getprop(fdt, "/", "#size-cells",
&len); +
+	if (size_len)
+		cell_size = fdt32_to_cpu(*size_len);
+	return cell_size;
+}
+
 static void merge_fdt_bootargs(void *fdt, const char *fdt_cmdline)
 {
 	char cmdline[COMMAND_LINE_SIZE];
@@ -95,9 +106,11 @@ static void merge_fdt_bootargs(void *fdt, const
char *fdt_cmdline) int atags_to_fdt(void *atag_list, void *fdt, int
total_space) {
 	struct tag *atag = atag_list;
-	uint32_t mem_reg_property[2 * NR_BANKS];
+	/* In the case of 64 bits memory size, need to reserve 2 cells
for
+	 * address and size for each bank */
+	uint32_t mem_reg_property[2 * 2 * NR_BANKS];
 	int memcount = 0;
-	int ret;
+	int ret, memsize;
 
 	/* make sure we've got an aligned pointer */
 	if ((u32)atag_list & 0x3)
@@ -137,8 +150,25 @@ int atags_to_fdt(void *atag_list, void *fdt, int
total_space) continue;
 			if (!atag->u.mem.size)
 				continue;
-			mem_reg_property[memcount++] =
cpu_to_fdt32(atag->u.mem.start);
-			mem_reg_property[memcount++] =
cpu_to_fdt32(atag->u.mem.size);
+			memsize = get_cell_size(fdt);
+
+			if (memsize == 2) {
+				/* if memsize is 2, that means that
+				 * each data needs 2 cells of 32 bits,
+				 * so the data are 64 bits */
+				uint64_t *mem_reg_prop64 =
+					(uint64_t *)mem_reg_property;
+				mem_reg_prop64[memcount++] =
+
cpu_to_fdt64(atag->u.mem.start);
+				mem_reg_prop64[memcount++] =
+					cpu_to_fdt64(atag->u.mem.size);
+			} else {
+				mem_reg_property[memcount++] =
+
cpu_to_fdt32(atag->u.mem.start);
+				mem_reg_property[memcount++] =
+					cpu_to_fdt32(atag->u.mem.size);
+			}
+
 		} else if (atag->hdr.tag == ATAG_INITRD2) {
 			uint32_t initrd_start, initrd_size;
 			initrd_start = atag->u.initrd.start;
@@ -150,8 +180,10 @@ int atags_to_fdt(void *atag_list, void *fdt, int
total_space) }
 	}
 
-	if (memcount)
-		setprop(fdt, "/memory", "reg", mem_reg_property,
4*memcount);
+	if (memcount) {
+		setprop(fdt, "/memory", "reg", mem_reg_property,
+			4 * memcount * memsize);
+	}
 
 	return fdt_pack(fdt);
 }
diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts
b/arch/arm/boot/dts/at91sam9n12ek.dts index f4e43e3..84d8bdb 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -14,11 +14,11 @@
 	compatible = "atmel,at91sam9n12ek", "atmel,at91sam9n12",
"atmel,at91sam9"; 
 	chosen {
-		bootargs = "mem=128M console=ttyS0,115200
root=/dev/mtdblock1 rw rootfstype=jffs2";
+		bootargs = "console=ttyS0,115200 root=/dev/mtdblock1
rw rootfstype=jffs2"; };
 
 	memory {
-		reg = <0x20000000 0x10000000>;
+		reg = <0x20000000 0x8000000>;
 	};
 
 	clocks {
diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
index 1496565..49122c4 100644
--- a/arch/arm/include/asm/mmu.h
+++ b/arch/arm/include/asm/mmu.h
@@ -7,6 +7,8 @@ typedef struct {
 #ifdef CONFIG_CPU_HAS_ASID
 	unsigned int id;
 	raw_spinlock_t id_lock;
+#else
+	int		switch_pending;
 #endif
 	unsigned int kvm_seq;
 } mm_context_t;
diff --git a/arch/arm/include/asm/mmu_context.h
b/arch/arm/include/asm/mmu_context.h index 0306bc6..549f1c6 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -121,7 +121,7 @@ static inline void check_and_switch_context(struct
mm_struct *mm,
 		 * on non-ASID CPUs, the old mm will remain valid
until the
 		 * finish_arch_post_lock_switch() call.
 		 */
-		set_ti_thread_flag(task_thread_info(tsk),
TIF_SWITCH_MM);
+		mm->context.switch_pending = 1;
 	else
 		cpu_switch_mm(mm->pgd, mm);
 }
@@ -130,9 +130,21 @@ static inline void check_and_switch_context(struct
mm_struct *mm, finish_arch_post_lock_switch
 static inline void finish_arch_post_lock_switch(void)
 {
-	if (test_and_clear_thread_flag(TIF_SWITCH_MM)) {
-		struct mm_struct *mm = current->mm;
-		cpu_switch_mm(mm->pgd, mm);
+	struct mm_struct *mm = current->mm;
+
+	if (mm && mm->context.switch_pending) {
+		/*
+		 * Preemption must be disabled during cpu_switch_mm()
as we
+		 * have some stateful cache flush implementations.
Check
+		 * switch_pending again in case we were preempted and
the
+		 * switch to this mm was already done.
+		 */
+		preempt_disable();
+		if (mm->context.switch_pending) {
+			mm->context.switch_pending = 0;
+			cpu_switch_mm(mm->pgd, mm);
+		}
+		preempt_enable_no_resched();
 	}
 }
 
diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index ecf9019..5c35852 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -142,7 +142,9 @@ extern void __cpu_copy_user_highpage(struct page
*to, struct page *from, #define clear_page(page)	memset((void
*)(page), 0, PAGE_SIZE) extern void copy_page(void *to, const void
*from); 
+#ifdef CONFIG_KUSER_HELPERS
 #define __HAVE_ARCH_GATE_AREA 1
+#endif
 
 #ifdef CONFIG_ARM_LPAE
 #include <asm/pgtable-3level-types.h>
diff --git a/arch/arm/include/asm/thread_info.h
b/arch/arm/include/asm/thread_info.h index af7b0bd..86682b1 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -153,7 +153,6 @@ extern int vfp_restore_user_hwstate(struct user_vfp
__user *, #define TIF_MEMDIE		18	/* is terminating
due to OOM killer */ #define TIF_RESTORE_SIGMASK	20
 #define TIF_SECCOMP		21
-#define TIF_SWITCH_MM		22	/* deferred switch_mm */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..5492d72 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -784,6 +784,18 @@ ENDPROC(__switch_to)
 #endif
 	.endm
 
+	.macro	kuser_pad, sym, size
+	.if	(. - \sym) & 3
+	.rept	4 - (. - \sym) & 3
+	.byte	0
+	.endr
+	.endif
+	.rept	(\size - (. - \sym)) / 4
+	.word	0xe7fddef1
+	.endr
+	.endm
+
+#ifdef CONFIG_KUSER_HELPERS
 	.align	5
 	.globl	__kuser_helper_start
 __kuser_helper_start:
@@ -874,18 +886,13 @@ kuser_cmpxchg64_fixup:
 #error "incoherent kernel configuration"
 #endif
 
-	/* pad to next slot */
-	.rept	(16 - (. - __kuser_cmpxchg64)/4)
-	.word	0
-	.endr
-
-	.align	5
+	kuser_pad __kuser_cmpxchg64, 64
 
 __kuser_memory_barrier:				@ 0xffff0fa0
 	smp_dmb	arm
 	usr_ret	lr
 
-	.align	5
+	kuser_pad __kuser_memory_barrier, 32
 
 __kuser_cmpxchg:				@ 0xffff0fc0
 
@@ -958,13 +965,14 @@ kuser_cmpxchg32_fixup:
 
 #endif
 
-	.align	5
+	kuser_pad __kuser_cmpxchg, 32
 
 __kuser_get_tls:				@ 0xffff0fe0
 	ldr	r0, [pc, #(16 - 8)]	@ read TLS, set in
kuser_get_tls_init usr_ret	lr
 	mrc	p15, 0, r0, c13, c0, 3	@ 0xffff0fe8 hardware
TLS code
-	.rep	4
+	kuser_pad __kuser_get_tls, 16
+	.rep	3
 	.word	0			@ 0xffff0ff0 software
TLS value, then .endr				@ pad up to
__kuser_helper_version 
@@ -974,14 +982,16 @@
__kuser_helper_version:				@
0xffff0ffc .globl	__kuser_helper_end __kuser_helper_end:
 
+#endif
+
  THUMB(	.thumb	)
 
 /*
  * Vector stubs.
  *
- * This code is copied to 0xffff0200 so we can use branches in the
- * vectors, rather than ldr's.  Note that this code must not
- * exceed 0x300 bytes.
+ * This code is copied to 0xffff1000 so we can use branches in the
+ * vectors, rather than ldr's.  Note that this code must not exceed
+ * a page size.
  *
  * Common stub entry macro:
  *   Enter in IRQ mode, spsr = SVC/USR CPSR, lr = SVC/USR PC
@@ -1028,8 +1038,17 @@ ENDPROC(vector_\name)
 1:
 	.endm
 
-	.globl	__stubs_start
+	.section .stubs, "ax", %progbits
 __stubs_start:
+	@ This must be the first word
+	.word	vector_swi
+
+vector_rst:
+ ARM(	swi	SYS_ERROR0	)
+ THUMB(	svc	#0		)
+ THUMB(	nop			)
+	b	vector_und
+
 /*
  * Interrupt dispatcher
  */
@@ -1124,6 +1143,16 @@ __stubs_start:
 	.align	5
 
 /*=============================================================================
+ * Address exception handler
+
*-----------------------------------------------------------------------------
+ * These aren't too critical.
+ * (they're not supposed to happen, and won't happen in 32-bit data
mode).
+ */
+
+vector_addrexcptn:
+	b	vector_addrexcptn
+
+/*=============================================================================
  * Undefined FIQs
  *-----------------------------------------------------------------------------
  * Enter in FIQ mode, spsr = ANY CPSR, lr = ANY PC
@@ -1136,45 +1165,19 @@ __stubs_start:
 vector_fiq:
 	subs	pc, lr, #4
 
-/*=============================================================================
- * Address exception handler
-
*-----------------------------------------------------------------------------
- * These aren't too critical.
- * (they're not supposed to happen, and won't happen in 32-bit data
mode).
- */
-
-vector_addrexcptn:
-	b	vector_addrexcptn
-
-/*
- * We group all the following data together to optimise
- * for CPUs with separate I & D caches.
- */
-	.align	5
-
-.LCvswi:
-	.word	vector_swi
-
-	.globl	__stubs_end
-__stubs_end:
-
-	.equ	stubs_offset, __vectors_start + 0x200 -
__stubs_start
+	.globl	vector_fiq_offset
+	.equ	vector_fiq_offset, vector_fiq
 
-	.globl	__vectors_start
+	.section .vectors, "ax", %progbits
 __vectors_start:
- ARM(	swi	SYS_ERROR0	)
- THUMB(	svc	#0		)
- THUMB(	nop			)
-	W(b)	vector_und + stubs_offset
-	W(ldr)	pc, .LCvswi + stubs_offset
-	W(b)	vector_pabt + stubs_offset
-	W(b)	vector_dabt + stubs_offset
-	W(b)	vector_addrexcptn + stubs_offset
-	W(b)	vector_irq + stubs_offset
-	W(b)	vector_fiq + stubs_offset
-
-	.globl	__vectors_end
-__vectors_end:
+	W(b)	vector_rst
+	W(b)	vector_und
+	W(ldr)	pc, __vectors_start + 0x1000
+	W(b)	vector_pabt
+	W(b)	vector_dabt
+	W(b)	vector_addrexcptn
+	W(b)	vector_irq
+	W(b)	vector_fiq
 
 	.data
 
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 2adda11..25442f4 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -47,6 +47,11 @@
 #include <asm/irq.h>
 #include <asm/traps.h>
 
+#define FIQ_OFFSET ({					\
+		extern void *vector_fiq_offset;		\
+		(unsigned)&vector_fiq_offset;		\
+	})
+
 static unsigned long no_fiq_insn;
 
 /* Default reacquire function
@@ -80,13 +85,16 @@ int show_fiq_list(struct seq_file *p, int prec)
 void set_fiq_handler(void *start, unsigned int length)
 {
 #if defined(CONFIG_CPU_USE_DOMAINS)
-	memcpy((void *)0xffff001c, start, length);
+	void *base = (void *)0xffff0000;
 #else
-	memcpy(vectors_page + 0x1c, start, length);
+	void *base = vectors_page;
 #endif
-	flush_icache_range(0xffff001c, 0xffff001c + length);
+	unsigned offset = FIQ_OFFSET;
+
+	memcpy(base + offset, start, length);
+	flush_icache_range(0xffff0000 + offset, 0xffff0000 + offset +
length); if (!vectors_high())
-		flush_icache_range(0x1c, 0x1c + length);
+		flush_icache_range(offset, offset + length);
 }
 
 int claim_fiq(struct fiq_handler *f)
@@ -144,6 +152,7 @@ EXPORT_SYMBOL(disable_fiq);
 
 void __init init_FIQ(int start)
 {
-	no_fiq_insn = *(unsigned long *)0xffff001c;
+	unsigned offset = FIQ_OFFSET;
+	no_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
 	fiq_start = start;
 }
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 5770b9d..7cdecea 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -106,7 +106,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
 static int
 armpmu_map_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64
config) {
-	int mapping = (*event_map)[config];
+	int mapping;
+
+	if (config >= PERF_COUNT_HW_MAX)
+		return -ENOENT;
+
+	mapping = (*event_map)[config];
 	return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
 }
 
@@ -316,6 +321,9 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state <
PERF_EVENT_STATE_OFF) return 1;
 
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 693b744..427ddbc 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -508,6 +508,7 @@ unsigned long arch_randomize_brk(struct mm_struct
*mm) }
 
 #ifdef CONFIG_MMU
+#ifdef CONFIG_KUSER_HELPERS
 /*
  * The vectors page is always readable from user space for the
  * atomic helpers and the signal restart code. Insert it into the
@@ -540,9 +541,13 @@ int in_gate_area_no_mm(unsigned long addr)
 {
 	return in_gate_area(NULL, addr);
 }
+#define is_gate_vma(vma)	((vma) = &gate_vma)
+#else
+#define is_gate_vma(vma)	0
+#endif
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
-	return (vma == &gate_vma) ? "[vectors]" : NULL;
+	return is_gate_vma(vma) ? "[vectors]" : NULL;
 }
 #endif
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b0179b8..1392beb 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -807,39 +807,54 @@ void __init trap_init(void)
 	return;
 }
 
-static void __init kuser_get_tls_init(unsigned long vectors)
+#ifdef CONFIG_KUSER_HELPERS
+static void __init kuser_init(void *vectors)
 {
+	extern char __kuser_helper_start[], __kuser_helper_end[];
+	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+
+	memcpy(vectors + 0x1000 - kuser_sz, __kuser_helper_start,
kuser_sz); +
 	/*
 	 * vectors + 0xfe0 = __kuser_get_tls
 	 * vectors + 0xfe8 = hardware TLS instruction at 0xffff0fe8
 	 */
 	if (tls_emu || has_tls_reg)
-		memcpy((void *)vectors + 0xfe0, (void *)vectors +
0xfe8, 4);
+		memcpy(vectors + 0xfe0, vectors + 0xfe8, 4);
 }
+#else
+static void __init kuser_init(void *vectors)
+{
+}
+#endif
 
 void __init early_trap_init(void *vectors_base)
 {
 	unsigned long vectors = (unsigned long)vectors_base;
 	extern char __stubs_start[], __stubs_end[];
 	extern char __vectors_start[], __vectors_end[];
-	extern char __kuser_helper_start[], __kuser_helper_end[];
-	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+	unsigned i;
 
 	vectors_page = vectors_base;
 
 	/*
+	 * Poison the vectors page with an undefined instruction.  This
+	 * instruction is chosen to be undefined for both ARM and Thumb
+	 * ISAs.  The Thumb version is an undefined instruction with a
+	 * branch back to the undefined instruction.
+	 */
+	for (i = 0; i < PAGE_SIZE / sizeof(u32); i++)
+		((u32 *)vectors_base)[i] = 0xe7fddef1;
+
+	/*
 	 * Copy the vectors, stubs and kuser helpers (in entry-armv.S)
 	 * into the vector page, mapped at 0xffff0000, and ensure these
 	 * are visible to the instruction stream.
 	 */
 	memcpy((void *)vectors, __vectors_start, __vectors_end -
__vectors_start);
-	memcpy((void *)vectors + 0x200, __stubs_start, __stubs_end -
__stubs_start);
-	memcpy((void *)vectors + 0x1000 - kuser_sz,
__kuser_helper_start, kuser_sz);
+	memcpy((void *)vectors + 0x1000, __stubs_start, __stubs_end -
__stubs_start); 
-	/*
-	 * Do processor specific fixups for the kuser helpers
-	 */
-	kuser_get_tls_init(vectors);
+	kuser_init(vectors_base);
 
 	/*
 	 * Copy signal return handlers into the vector page, and
@@ -848,6 +863,6 @@ void __init early_trap_init(void *vectors_base)
 	memcpy((void *)(vectors + KERN_SIGRETURN_CODE -
CONFIG_VECTORS_BASE), sigreturn_codes, sizeof(sigreturn_codes));
 
-	flush_icache_range(vectors, vectors + PAGE_SIZE);
+	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
 	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
 }
diff --git a/arch/arm/kernel/vmlinux.lds.S
b/arch/arm/kernel/vmlinux.lds.S index 36ff15b..2f8f92e 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -137,6 +137,23 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__init_begin = .;
 #endif
+	/*
+	 * The vectors and stubs are relocatable code, and the
+	 * only thing that matters is their relative offsets
+	 */
+	__vectors_start = .;
+	.vectors 0 : AT(__vectors_start) {
+		*(.vectors)
+	}
+	. = __vectors_start + SIZEOF(.vectors);
+	__vectors_end = .;
+
+	__stubs_start = .;
+	.stubs 0x1000 : AT(__stubs_start) {
+		*(.stubs)
+	}
+	. = __stubs_start + SIZEOF(.stubs);
+	__stubs_end = .;
 
 	INIT_TEXT_SECTION(8)
 	.exit.text : {
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c
b/arch/arm/mach-davinci/board-dm355-leopard.c index 8e77032..eeeb81f
100644 --- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -75,6 +75,7 @@ static struct davinci_nand_pdata davinci_nand_data = {
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW_SYNDROME,
+	.ecc_bits		= 4,
 	.bbt_options		= NAND_BBT_USE_FLASH,
 };
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c
b/arch/arm/mach-davinci/board-dm644x-evm.c index d34ed55..87a904f 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -152,6 +152,7 @@ static struct davinci_nand_pdata
davinci_evm_nandflash_data = { .parts		=
davinci_evm_nandflash_partition, .nr_parts	=
ARRAY_SIZE(davinci_evm_nandflash_partition), .ecc_mode	=
NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 	.timing		= &davinci_evm_nandflash_timing,
 };
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c
b/arch/arm/mach-davinci/board-dm646x-evm.c index 958679a..5d4b51f 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -89,6 +89,7 @@ static struct davinci_nand_pdata davinci_nand_data = {
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW,
+	.ecc_bits		= 1,
 	.options		= 0,
 };
 
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c
b/arch/arm/mach-davinci/board-neuros-osd2.c index f6b9fc7..58d902a
100644 --- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -88,6 +88,7 @@ static struct davinci_nand_pdata
davinci_ntosd2_nandflash_data = { .parts		=
davinci_ntosd2_nandflash_partition, .nr_parts	=
ARRAY_SIZE(davinci_ntosd2_nandflash_partition), .ecc_mode	=
NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 };
 
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 101b968..6c5a533 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -400,24 +400,28 @@ config CPU_32v3
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v4
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v4T
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v5
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v6
 	bool
@@ -735,6 +739,7 @@ config CPU_BPREDICT_DISABLE
 
 config TLS_REG_EMUL
 	bool
+	select NEED_KUSER_HELPERS
 	help
 	  An SMP system using a pre-ARMv6 processor (there are
apparently a few prototypes like that in existence) and therefore
access to @@ -742,11 +747,43 @@ config TLS_REG_EMUL
 
 config NEEDS_SYSCALL_FOR_CMPXCHG
 	bool
+	select NEED_KUSER_HELPERS
 	help
 	  SMP on a pre-ARMv6 processor?  Well OK then.
 	  Forget about fast user space cmpxchg support.
 	  It is just not possible.
 
+config NEED_KUSER_HELPERS
+	bool
+
+config KUSER_HELPERS
+	bool "Enable kuser helpers in vector page"
if !NEED_KUSER_HELPERS
+	default y
+	help
+	  Warning: disabling this option may break user programs.
+
+	  Provide kuser helpers in the vector page.  The kernel
provides
+	  helper code to userspace in read only form at a fixed
location
+	  in the high vector page to allow userspace to be independent
of
+	  the CPU type fitted to the system.  This permits binaries to
be
+	  run on ARMv4 through to ARMv7 without modification.
+
+	  See Documentation/arm/kernel_user_helpers.txt for details.
+
+	  However, the fixed address nature of these helpers can be
used
+	  by ROP (return orientated programming) authors when creating
+	  exploits.
+
+	  If all of the binaries and libraries which run on your
platform
+	  are built specifically for your platform, and make no use of
+	  these helpers, then you can turn this option off to hinder
+	  such exploits. However, in that case, if a binary or library
+	  relying on those helpers is run, it will receive a SIGILL
signal,
+	  which will terminate the program.
+
+	  Say N here only if you are absolutely certain that you do not
+	  need these helpers; otherwise, the safe option is to say Y.
+
 config DMA_CACHE_RWFO
 	bool "Enable read/write for ownership DMA cache maintenance"
 	depends on CPU_V6K && SMP
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index c2fa21d..50d4aff 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1080,7 +1080,7 @@ static void __init devicemaps_init(struct
machine_desc *mdesc) /*
 	 * Allocate the vector page early.
 	 */
-	vectors = early_alloc(PAGE_SIZE);
+	vectors = early_alloc(PAGE_SIZE * 2);
 
 	early_trap_init(vectors);
 
@@ -1125,15 +1125,27 @@ static void __init devicemaps_init(struct
machine_desc *mdesc) map.pfn = __phys_to_pfn(virt_to_phys(vectors));
 	map.virtual = 0xffff0000;
 	map.length = PAGE_SIZE;
+#ifdef CONFIG_KUSER_HELPERS
 	map.type = MT_HIGH_VECTORS;
+#else
+	map.type = MT_LOW_VECTORS;
+#endif
 	create_mapping(&map);
 
 	if (!vectors_high()) {
 		map.virtual = 0;
+		map.length = PAGE_SIZE * 2;
 		map.type = MT_LOW_VECTORS;
 		create_mapping(&map);
 	}
 
+	/* Now create a kernel read-only mapping */
+	map.pfn += 1;
+	map.virtual = 0xffff0000 + PAGE_SIZE;
+	map.length = PAGE_SIZE;
+	map.type = MT_LOW_VECTORS;
+	create_mapping(&map);
+
 	/*
 	 * Ask the machine support to map in the statically mapped
devices. */
diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index 2291a7d..fa277ae 100644
--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -18,9 +18,11 @@
 #include <asm/machdep.h>
 #include <asm/natfeat.h>
 
+extern long nf_get_id2(const char *feature_name);
+
 asm("\n"
-"	.global nf_get_id,nf_call\n"
-"nf_get_id:\n"
+"	.global nf_get_id2,nf_call\n"
+"nf_get_id2:\n"
 "	.short	0x7300\n"
 "	rts\n"
 "nf_call:\n"
@@ -29,12 +31,25 @@ asm("\n"
 "1:	moveq.l	#0,%d0\n"
 "	rts\n"
 "	.section __ex_table,\"a\"\n"
-"	.long	nf_get_id,1b\n"
+"	.long	nf_get_id2,1b\n"
 "	.long	nf_call,1b\n"
 "	.previous");
-EXPORT_SYMBOL_GPL(nf_get_id);
 EXPORT_SYMBOL_GPL(nf_call);
 
+long nf_get_id(const char *feature_name)
+{
+	/* feature_name may be in vmalloc()ed memory, so make a copy */
+	char name_copy[32];
+	size_t n;
+
+	n = strlcpy(name_copy, feature_name, sizeof(name_copy));
+	if (n >= sizeof(name_copy))
+		return 0;
+
+	return nf_get_id2(name_copy);
+}
+EXPORT_SYMBOL_GPL(nf_get_id);
+
 void nfprint(const char *fmt, ...)
 {
 	static char buf[256];
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index faf6528..5367804 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -26,6 +26,7 @@ config MIPS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_PCI_IOMAP
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select IRQ_FORCED_THREADING
@@ -2392,7 +2393,6 @@ config PCI
 	bool "Support for PCI controller"
 	depends on HW_HAS_PCI
 	select PCI_DOMAINS
-	select GENERIC_PCI_IOMAP
 	select NO_GENERIC_PCI_IOPORT_MAP
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name
of a diff --git a/arch/mips/cavium-octeon/setup.c
b/arch/mips/cavium-octeon/setup.c index 919b0fb..19ce979 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2004-2007 Cavium Networks
  * Copyright (C) 2008 Wind River Systems
  */
+#include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/delay.h>
@@ -504,7 +505,7 @@ void __init prom_init(void)
 	if (cvmx_read_csr(CVMX_L2D_FUS3) & (3ull << 34)) {
 		pr_info("Skipping L2 locking due to reduced L2 cache
size\n"); } else {
-		uint32_t ebase = read_c0_ebase() & 0x3ffff000;
+		uint32_t __maybe_unused ebase = read_c0_ebase() &
0x3ffff000; #ifdef CONFIG_CAVIUM_OCTEON_LOCK_L2_TLB
 		/* TLB refill */
 		cvmx_l2c_lock_mem_region(ebase, 0x100);
diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
index 29d9c23..98ca652 100644
--- a/arch/mips/include/asm/io.h
+++ b/arch/mips/include/asm/io.h
@@ -169,6 +169,11 @@ static inline void * isa_bus_to_virt(unsigned long
address) extern void __iomem * __ioremap(phys_t offset, phys_t size,
unsigned long flags); extern void __iounmap(const volatile void __iomem
*addr); 
+#ifndef CONFIG_PCI
+struct pci_dev;
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem
*addr) {} +#endif
+
 static inline void __iomem * __ioremap_mode(phys_t offset, unsigned
long size, unsigned long flags)
 {
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 352f416..3254335 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -973,6 +973,7 @@ config RELOCATABLE
 	  must live at a different physical address than the primary
 	  kernel.
 
+# This value must have zeroes in the bottom 60 bits otherwise lots
will break config PAGE_OFFSET
 	hex
 	default "0xc000000000000000"
diff --git a/arch/powerpc/include/asm/module.h
b/arch/powerpc/include/asm/module.h index 0192a4e..80de64b 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -87,10 +87,9 @@ struct exception_table_entry;
 void sort_ex_table(struct exception_table_entry *start,
 		   struct exception_table_entry *finish);
 
-#ifdef CONFIG_MODVERSIONS
+#if defined(CONFIG_MODVERSIONS) && defined(CONFIG_PPC64)
 #define ARCH_RELOCATES_KCRCTAB
-
-extern const unsigned long reloc_start[];
+#define reloc_start PHYSICAL_START
 #endif
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_MODULE_H */
diff --git a/arch/powerpc/include/asm/page.h
b/arch/powerpc/include/asm/page.h index f072e97..2e6c4e5a 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -211,9 +211,19 @@ extern long long virt_phys_offset;
 #define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) +
VIRT_PHYS_OFFSET)) #define __pa(x) ((unsigned long)(x) -
VIRT_PHYS_OFFSET) #else
+#ifdef CONFIG_PPC64
+/*
+ * gcc miscompiles (unsigned long)(&static_var) - PAGE_OFFSET
+ * with -mcmodel=medium, so we use & and | instead of - and + on
64-bit.
+ */
+#define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) |
PAGE_OFFSET)) +#define __pa(x) ((unsigned long)(x) &
0x0fffffffffffffffUL) +
+#else /* 32-bit, non book E */
 #define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) +
PAGE_OFFSET - MEMORY_START)) #define __pa(x) ((unsigned long)(x) -
PAGE_OFFSET + MEMORY_START) #endif
+#endif
 
 /*
  * Unfortunately the PLT is in the BSS in the PPC32 ELF ABI,
diff --git a/arch/powerpc/kernel/lparcfg.c
b/arch/powerpc/kernel/lparcfg.c index f5725bc..7ebbae0 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -35,7 +35,13 @@
 #include <asm/vdso_datapage.h>
 #include <asm/vio.h>
 #include <asm/mmu.h>
+#include <asm/machdep.h>
 
+
+/*
+ * This isn't a module but we expose that to userspace
+ * via /proc so leave the definitions here
+ */
 #define MODULE_VERS "1.9"
 #define MODULE_NAME "lparcfg"
 
@@ -419,7 +425,8 @@ static void parse_em_data(struct seq_file *m)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 
-	if (plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
+	if (firmware_has_feature(FW_FEATURE_LPAR) &&
+	    plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
 		seq_printf(m, "power_mode_data=%016lx\n", retbuf[0]);
 }
 
@@ -678,7 +685,6 @@ static int lparcfg_open(struct inode *inode, struct
file *file) }
 
 static const struct file_operations lparcfg_fops = {
-	.owner		= THIS_MODULE,
 	.read		= seq_read,
 	.write		= lparcfg_write,
 	.open		= lparcfg_open,
@@ -704,15 +710,4 @@ static int __init lparcfg_init(void)
 	proc_ppc64_lparcfg = ent;
 	return 0;
 }
-
-static void __exit lparcfg_cleanup(void)
-{
-	if (proc_ppc64_lparcfg)
-		remove_proc_entry("lparcfg",
proc_ppc64_lparcfg->parent); -}
-
-module_init(lparcfg_init);
-module_exit(lparcfg_cleanup);
-MODULE_DESCRIPTION("Interface for LPAR configuration data");
-MODULE_AUTHOR("Dave Engebretsen");
-MODULE_LICENSE("GPL");
+machine_device_initcall(pseries, lparcfg_init);
diff --git a/arch/powerpc/kernel/setup_64.c
b/arch/powerpc/kernel/setup_64.c index 389bd4f..5c9eccc 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -76,7 +76,7 @@
 #endif
 
 int boot_cpuid = 0;
-int __initdata spinning_secondaries;
+int spinning_secondaries;
 u64 ppc64_pft_size;
 
 /* Pick defaults since we might want to patch instructions
diff --git a/arch/powerpc/kernel/vmlinux.lds.S
b/arch/powerpc/kernel/vmlinux.lds.S index 65d1c08..7703569 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -38,9 +38,6 @@ jiffies = jiffies_64 + 4;
 #endif
 SECTIONS
 {
-	. = 0;
-	reloc_start = .;
-
 	. = KERNELBASE;
 
 /*
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c
b/arch/x86/kernel/cpu/mtrr/generic.c index e9fe907..5ac2152 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -510,8 +510,9 @@ generic_get_free_region(unsigned long base,
unsigned long size, int replace_reg) static void
generic_get_mtrr(unsigned int reg, unsigned long *base, unsigned long
*size, mtrr_type *type) {
-	unsigned int mask_lo, mask_hi, base_lo, base_hi;
-	unsigned int tmp, hi;
+	u32 mask_lo, mask_hi, base_lo, base_hi;
+	unsigned int hi;
+	u64 tmp, mask;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could
be called @@ -532,18 +533,18 @@ static void generic_get_mtrr(unsigned
int reg, unsigned long *base, rdmsr(MTRRphysBase_MSR(reg), base_lo,
base_hi); 
 	/* Work out the shifted address mask: */
-	tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
-	mask_lo = size_or_mask | tmp;
+	tmp = (u64)mask_hi << (32 - PAGE_SHIFT) | mask_lo >>
PAGE_SHIFT;
+	mask = size_or_mask | tmp;
 
 	/* Expand tmp with high bits to all 1s: */
-	hi = fls(tmp);
+	hi = fls64(tmp);
 	if (hi > 0) {
-		tmp |= ~((1<<(hi - 1)) - 1);
+		tmp |= ~((1ULL<<(hi - 1)) - 1);
 
-		if (tmp != mask_lo) {
+		if (tmp != mask) {
 			printk(KERN_WARNING "mtrr: your BIOS has
configured an incorrect mask, fixing it.\n");
add_taint(TAINT_FIRMWARE_WORKAROUND);
-			mask_lo = tmp;
+			mask = tmp;
 		}
 	}
 
@@ -551,8 +552,8 @@ static void generic_get_mtrr(unsigned int reg,
unsigned long *base,
 	 * This works correctly if size is a power of two, i.e. a
 	 * contiguous range:
 	 */
-	*size = -mask_lo;
-	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
+	*size = -mask;
+	*base = (u64)base_hi << (32 - PAGE_SHIFT) | base_lo >>
PAGE_SHIFT; *type = base_lo & 0xff;
 
 out_put_cpu:
diff --git a/arch/x86/kernel/cpu/mtrr/main.c
b/arch/x86/kernel/cpu/mtrr/main.c index 6b96110..87f918e 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -305,7 +305,8 @@ int mtrr_add_page(unsigned long base, unsigned long
size, return -EINVAL;
 	}
 
-	if (base & size_or_mask || size & size_or_mask) {
+	if ((base | (base + size - 1)) >>
+	    (boot_cpu_data.x86_phys_bits - PAGE_SHIFT)) {
 		pr_warning("mtrr: base or size exceeds the MTRR
width\n"); return -EINVAL;
 	}
@@ -583,6 +584,7 @@ static struct syscore_ops mtrr_syscore_ops = {
 
 int __initdata changed_by_mtrr_cleanup;
 
+#define SIZE_OR_MASK_BITS(n)  (~((1ULL << ((n) - PAGE_SHIFT)) - 1))
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
  *
@@ -600,7 +602,7 @@ void __init mtrr_bp_init(void)
 
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
-		size_or_mask = 0xff000000;			/*
36 bits */
+		size_or_mask = SIZE_OR_MASK_BITS(36);
 		size_and_mask = 0x00f00000;
 		phys_addr = 36;
 
@@ -619,7 +621,7 @@ void __init mtrr_bp_init(void)
 			     boot_cpu_data.x86_mask == 0x4))
 				phys_addr = 36;
 
-			size_or_mask = ~((1ULL << (phys_addr -
PAGE_SHIFT)) - 1);
+			size_or_mask = SIZE_OR_MASK_BITS(phys_addr);
 			size_and_mask = ~size_or_mask &
0xfffff00000ULL; } else if (boot_cpu_data.x86_vendor ==
X86_VENDOR_CENTAUR && boot_cpu_data.x86 == 6) {
@@ -627,7 +629,7 @@ void __init mtrr_bp_init(void)
 			 * VIA C* family have Intel style MTRRs,
 			 * but don't support PAE
 			 */
-			size_or_mask = 0xfff00000;		/*
32 bits */
+			size_or_mask = SIZE_OR_MASK_BITS(32);
 			size_and_mask = 0;
 			phys_addr = 32;
 		}
@@ -637,21 +639,21 @@ void __init mtrr_bp_init(void)
 			if (cpu_has_k6_mtrr) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
 				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
-				size_or_mask = 0xfff00000;	/*
32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CENTAUR:
 			if (cpu_has_centaur_mcr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CENTAUR];
-				size_or_mask = 0xfff00000;	/*
32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CYRIX:
 			if (cpu_has_cyrix_arr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CYRIX];
-				size_or_mask = 0xfff00000;	/*
32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
b/arch/x86/kernel/cpu/perf_event_intel_uncore.c index 0c0957d..4e5f47a
100644 --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -313,8 +313,8 @@ static struct uncore_event_desc
snbep_uncore_imc_events[] = { static struct uncore_event_desc
snbep_uncore_qpi_events[] = { INTEL_UNCORE_EVENT_DESC(clockticks,
"event=0x14"), INTEL_UNCORE_EVENT_DESC(txl_flits_active,
"event=0x00,umask=0x06"),
-	INTEL_UNCORE_EVENT_DESC(drs_data,
"event=0x02,umask=0x08"),
-	INTEL_UNCORE_EVENT_DESC(ncb_data,
"event=0x03,umask=0x04"),
+	INTEL_UNCORE_EVENT_DESC(drs_data,
"event=0x102,umask=0x08"),
+	INTEL_UNCORE_EVENT_DESC(ncb_data,
"event=0x103,umask=0x04"), { /* end: all zeroes */ },
 };
 
diff --git a/arch/x86/kernel/early-quirks.c
b/arch/x86/kernel/early-quirks.c index 94ab6b9..63bdb29 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -196,15 +196,23 @@ static void __init ati_bugs_contd(int num, int
slot, int func) static void __init intel_remapping_check(int num, int
slot, int func) {
 	u8 revision;
+	u16 device;
 
+	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
 	revision = read_pci_config_byte(num, slot, func,
PCI_REVISION_ID); 
 	/*
-	 * Revision 0x13 of this chipset supports irq remapping
-	 * but has an erratum that breaks its behavior, flag it as such
+ 	 * Revision 13 of all triggering devices id in this quirk have
+	 * a problem draining interrupts when irq remapping is enabled,
+	 * and should be flagged as broken.  Additionally revisions
0x12
+	 * and 0x22 of device id 0x3405 has this problem.
 	 */
 	if (revision == 0x13)
 		set_irq_remapping_broken();
+	else if ((device == 0x3405) &&
+	    ((revision == 0x12) ||
+	     (revision == 0x22)))
+		set_irq_remapping_broken();
 
 }
 
@@ -239,6 +247,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
 	{ PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
+	{ PCI_VENDOR_ID_INTEL, 0x3405, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{}
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f250431..6c5a7dc 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -132,7 +132,7 @@ static void __cpuinit mxcsr_feature_mask_init(void)
 	clts();
 	if (cpu_has_fxsr) {
 		memset(&fx_scratch, 0, sizeof(struct
i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (fx_scratch));
+		asm volatile("fxsave %0" : "+m" (fx_scratch));
 		mask = fx_scratch.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index b4d3c39..2145c1b 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -115,7 +115,7 @@ static void find_start_end(unsigned long flags,
unsigned long *begin, *begin = new_begin;
 		}
 	} else {
-		*begin = TASK_UNMAPPED_BASE;
+		*begin = mmap_legacy_base();
 		*end = TASK_SIZE;
 	}
 }
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 845df68..c1af323 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -98,7 +98,7 @@ static unsigned long mmap_base(void)
  * Bottom-up (legacy) layout on X86_32 did not support randomization,
X86_64
  * does, but not when emulating X86_32
  */
-static unsigned long mmap_legacy_base(void)
+unsigned long mmap_legacy_base(void)
 {
 	if (mmap_is_ia32())
 		return TASK_UNMAPPED_BASE;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index e2d62d6..8cf7449 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -313,6 +313,17 @@ static void xen_align_and_add_e820_region(u64
start, u64 size, int type) e820_add_region(start, end - start, type);
 }
 
+void xen_ignore_unusable(struct e820entry *list, size_t map_size)
+{
+	struct e820entry *entry;
+	unsigned int i;
+
+	for (i = 0, entry = list; i < map_size; i++, entry++) {
+		if (entry->type == E820_UNUSABLE)
+			entry->type = E820_RAM;
+	}
+}
+
 /**
  * machine_specific_memory_setup - Hook for machine specific memory
setup. **/
@@ -353,6 +364,17 @@ char * __init xen_memory_setup(void)
 	}
 	BUG_ON(rc);
 
+	/*
+	 * Xen won't allow a 1:1 mapping to be created to UNUSABLE
+	 * regions, so if we're using the machine memory map leave the
+	 * region as RAM as it is in the pseudo-physical map.
+	 *
+	 * UNUSABLE regions in domUs are not handled and will need
+	 * a patch in the future.
+	 */
+	if (xen_initial_domain())
+		xen_ignore_unusable(map, memmap.nr_entries);
+
 	/* Make sure the Xen-supplied memory map is well-ordered. */
 	sanitize_e820_map(map, memmap.nr_entries, &memmap.nr_entries);
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 76bce6e..72701ac 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -663,8 +663,15 @@ static void __init
xen_hvm_smp_prepare_cpus(unsigned int max_cpus) static int __cpuinit
xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle) {
 	int rc;
-	rc = native_cpu_up(cpu, tidle);
-	WARN_ON (xen_smp_intr_init(cpu));
+	/*
+	 * xen_smp_intr_init() needs to run before native_cpu_up()
+	 * so that IPI vectors are set up on the booting CPU before
+	 * it is marked online in native_cpu_up().
+	*/
+	rc = xen_smp_intr_init(cpu);
+	WARN_ON(rc);
+	if (!rc)
+		rc =  native_cpu_up(cpu, tidle);
 	return rc;
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fb52df9..1bde45f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3959,18 +3959,28 @@ static void cfq_exit_queue(struct
elevator_queue *e) kfree(cfqd);
 }
 
-static int cfq_init_queue(struct request_queue *q)
+static int cfq_init_queue(struct request_queue *q, struct
elevator_type *e) {
 	struct cfq_data *cfqd;
 	struct blkcg_gq *blkg __maybe_unused;
 	int i, ret;
+	struct elevator_queue *eq;
+
+	eq = elevator_alloc(q, e);
+	if (!eq)
+		return -ENOMEM;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO,
q->node);
-	if (!cfqd)
+	if (!cfqd) {
+		kobject_put(&eq->kobj);
 		return -ENOMEM;
+	}
+	eq->elevator_data = cfqd;
 
 	cfqd->queue = q;
-	q->elevator->elevator_data = cfqd;
+	spin_lock_irq(q->queue_lock);
+	q->elevator = eq;
+	spin_unlock_irq(q->queue_lock);
 
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
@@ -4044,6 +4054,7 @@ static int cfq_init_queue(struct request_queue *q)
 
 out_free:
 	kfree(cfqd);
+	kobject_put(&eq->kobj);
 	return ret;
 }
 
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 599b12e..20a1efc 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -337,13 +337,21 @@ static void deadline_exit_queue(struct
elevator_queue *e) /*
  * initialize elevator private data (deadline_data).
  */
-static int deadline_init_queue(struct request_queue *q)
+static int deadline_init_queue(struct request_queue *q, struct
elevator_type *e) {
 	struct deadline_data *dd;
+	struct elevator_queue *eq;
+
+	eq = elevator_alloc(q, e);
+	if (!eq)
+		return -ENOMEM;
 
 	dd = kmalloc_node(sizeof(*dd), GFP_KERNEL | __GFP_ZERO,
q->node);
-	if (!dd)
+	if (!dd) {
+		kobject_put(&eq->kobj);
 		return -ENOMEM;
+	}
+	eq->elevator_data = dd;
 
 	INIT_LIST_HEAD(&dd->fifo_list[READ]);
 	INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
@@ -355,7 +363,9 @@ static int deadline_init_queue(struct request_queue
*q) dd->front_merges = 1;
 	dd->fifo_batch = fifo_batch;
 
-	q->elevator->elevator_data = dd;
+	spin_lock_irq(q->queue_lock);
+	q->elevator = eq;
+	spin_unlock_irq(q->queue_lock);
 	return 0;
 }
 
diff --git a/block/elevator.c b/block/elevator.c
index 6a55d41..ac6316c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -138,7 +138,7 @@ __setup("elevator=", elevator_setup);
 
 static struct kobj_type elv_ktype;
 
-static struct elevator_queue *elevator_alloc(struct request_queue *q,
+struct elevator_queue *elevator_alloc(struct request_queue *q,
 				  struct elevator_type *e)
 {
 	struct elevator_queue *eq;
@@ -166,6 +166,7 @@ err:
 	elevator_put(e);
 	return NULL;
 }
+EXPORT_SYMBOL(elevator_alloc);
 
 static void elevator_release(struct kobject *kobj)
 {
@@ -213,16 +214,7 @@ int elevator_init(struct request_queue *q, char
*name) }
 	}
 
-	q->elevator = elevator_alloc(q, e);
-	if (!q->elevator)
-		return -ENOMEM;
-
-	err = e->ops.elevator_init_fn(q);
-	if (err) {
-		kobject_put(&q->elevator->kobj);
-		return err;
-	}
-
+	err = e->ops.elevator_init_fn(q, e);
 	return 0;
 }
 EXPORT_SYMBOL(elevator_init);
@@ -897,16 +889,9 @@ static int elevator_switch(struct request_queue
*q, struct elevator_type *new_e) spin_unlock_irq(q->queue_lock);
 
 	/* allocate, init and register new elevator */
-	err = -ENOMEM;
-	q->elevator = elevator_alloc(q, new_e);
-	if (!q->elevator)
-		goto fail_init;
-
-	err = new_e->ops.elevator_init_fn(q);
-	if (err) {
-		kobject_put(&q->elevator->kobj);
+	err = new_e->ops.elevator_init_fn(q, new_e);
+	if (err)
 		goto fail_init;
-	}
 
 	if (registered) {
 		err = elv_register_queue(q);
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 5d1bf70..3de89d4 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -59,16 +59,27 @@ noop_latter_request(struct request_queue *q, struct
request *rq) return list_entry(rq->queuelist.next, struct request,
queuelist); }
 
-static int noop_init_queue(struct request_queue *q)
+static int noop_init_queue(struct request_queue *q, struct
elevator_type *e) {
 	struct noop_data *nd;
+	struct elevator_queue *eq;
+
+	eq = elevator_alloc(q, e);
+	if (!eq)
+		return -ENOMEM;
 
 	nd = kmalloc_node(sizeof(*nd), GFP_KERNEL, q->node);
-	if (!nd)
+	if (!nd) {
+		kobject_put(&eq->kobj);
 		return -ENOMEM;
+	}
+	eq->elevator_data = nd;
 
 	INIT_LIST_HEAD(&nd->queue);
-	q->elevator->elevator_data = nd;
+
+	spin_lock_irq(q->queue_lock);
+	q->elevator = eq;
+	spin_unlock_irq(q->queue_lock);
 	return 0;
 }
 
diff --git a/drivers/acpi/acpi_memhotplug.c
b/drivers/acpi/acpi_memhotplug.c index 24c807f..f16ffd4 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -442,6 +442,7 @@ static int acpi_memory_device_add(struct
acpi_device *device) /* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
+		device->driver_data = NULL;
 		kfree(mem_device);
 		return result;
 	}
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 7efaeaa..7663df7 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -117,6 +117,7 @@ struct acpi_battery {
 	struct acpi_device *device;
 	struct notifier_block pm_nb;
 	unsigned long update_time;
+	int revision;
 	int rate_now;
 	int capacity_now;
 	int voltage_now;
@@ -359,6 +360,7 @@ static struct acpi_offsets info_offsets[] = {
 };
 
 static struct acpi_offsets extended_info_offsets[] = {
+	{offsetof(struct acpi_battery, revision), 0},
 	{offsetof(struct acpi_battery, power_unit), 0},
 	{offsetof(struct acpi_battery, design_capacity), 0},
 	{offsetof(struct acpi_battery, full_charge_capacity), 0},
diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 6eff12f..a166b9d 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -91,13 +91,15 @@ static int acpi_find_bridge_device(struct device
*dev, acpi_handle * handle) static acpi_status
do_acpi_find_child(acpi_handle handle, u32 lvl_not_used, void *addr_p,
void **ret_p) {
-	unsigned long long addr;
+	unsigned long long addr, sta;
 	acpi_status status;
 
 	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL,
&addr); if (ACPI_SUCCESS(status) && addr == *((u64 *)addr_p)) {
 		*ret_p = handle;
-		return AE_CTRL_TERMINATE;
+		status = acpi_bus_get_status_handle(handle, &sta);
+		if (ACPI_SUCCESS(status) && (sta &
ACPI_STA_DEVICE_ENABLED))
+			return AE_CTRL_TERMINATE;
 	}
 	return AE_OK;
 }
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 27cecd3..79ba92e 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -93,7 +93,7 @@ config SATA_FSL
 	  If unsure, say N.
 
 config SATA_INIC162X
-	tristate "Initio 162x SATA support"
+	tristate "Initio 162x SATA support (Very Experimental)"
 	depends on PCI
 	help
 	  This option enables support for Initio 162x Serial ATA.
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 80c44c30..1cecf06 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -344,6 +344,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (BayTrail) */
 	{ 0x8086, 0x0F20, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
ich8_2port_sata_byt }, { 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
ich8_2port_sata_byt },
+	/* SATA Controller IDE (Coleto Creek) */
+	{ 0x8086, 0x23a6, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
ich8_2port_sata }, { }	/* terminate list */
 };
 
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 61c59ee..20fd337 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -289,24 +289,24 @@ static int sata_pmp_configure(struct ata_device
*dev, int print_info) 
 	/* Disable sending Early R_OK.
 	 * With "cached read" HDD testing and multiple ports busy on a
SATA
-	 * host controller, 3726 PMP will very rarely drop a deferred
+	 * host controller, 3x26 PMP will very rarely drop a deferred
 	 * R_OK that was intended for the host. Symptom will be all
 	 * 5 drives under test will timeout, get reset, and recover.
 	 */
-	if (vendor == 0x1095 && devid == 0x3726) {
+	if (vendor == 0x1095 && (devid == 0x3726 || devid == 0x3826)) {
 		u32 reg;
 
 		err_mask = sata_pmp_read(&ap->link, PMP_GSCR_SII_POL,
&reg); if (err_mask) {
 			rc = -EIO;
-			reason = "failed to read Sil3726 Private
Register";
+			reason = "failed to read Sil3x26 Private
Register"; goto fail;
 		}
 		reg &= ~0x1;
 		err_mask = sata_pmp_write(&ap->link, PMP_GSCR_SII_POL,
reg); if (err_mask) {
 			rc = -EIO;
-			reason = "failed to write Sil3726 Private
Register";
+			reason = "failed to write Sil3x26 Private
Register"; goto fail;
 		}
 	}
@@ -383,15 +383,19 @@ static void sata_pmp_quirks(struct ata_port *ap)
 	u16 devid = sata_pmp_gscr_devid(gscr);
 	struct ata_link *link;
 
-	if (vendor == 0x1095 && devid == 0x3726) {
-		/* sil3726 quirks */
+	if (vendor == 0x1095 && (devid == 0x3726 || devid == 0x3826)) {
+		/* sil3x26 quirks */
 		ata_for_each_link(link, ap, EDGE) {
 			/* link reports offline after LPM */
 			link->flags |= ATA_LFLAG_NO_LPM;
 
-			/* Class code report is unreliable. */
+			/*
+			 * Class code report is unreliable and SRST
times
+			 * out under certain configurations.
+			 */
 			if (link->pmp < 5)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
+				link->flags |= ATA_LFLAG_NO_SRST |
+					       ATA_LFLAG_ASSUME_ATA;
 
 			/* port 5 is for SEMB device and it doesn't
like SRST */ if (link->pmp == 5)
@@ -399,20 +403,17 @@ static void sata_pmp_quirks(struct ata_port *ap)
 					       ATA_LFLAG_ASSUME_SEMB;
 		}
 	} else if (vendor == 0x1095 && devid == 0x4723) {
-		/* sil4723 quirks */
-		ata_for_each_link(link, ap, EDGE) {
-			/* link reports offline after LPM */
-			link->flags |= ATA_LFLAG_NO_LPM;
-
-			/* class code report is unreliable */
-			if (link->pmp < 2)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
-
-			/* the config device at port 2 locks up on
SRST */
-			if (link->pmp == 2)
-				link->flags |= ATA_LFLAG_NO_SRST |
-					       ATA_LFLAG_ASSUME_ATA;
-		}
+		/*
+		 * sil4723 quirks
+		 *
+		 * Link reports offline after LPM.  Class code report
is
+		 * unreliable.  SIMG PMPs never got SRST reliable and
the
+		 * config device at port 2 locks up on SRST.
+		 */
+		ata_for_each_link(link, ap, EDGE)
+			link->flags |= ATA_LFLAG_NO_LPM |
+				       ATA_LFLAG_NO_SRST |
+				       ATA_LFLAG_ASSUME_ATA;
 	} else if (vendor == 0x1095 && devid == 0x4726) {
 		/* sil4726 quirks */
 		ata_for_each_link(link, ap, EDGE) {
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d6577b9..a3f0bbd 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -290,6 +290,7 @@ static void fsl_sata_set_irq_coalescing(struct
ata_host *host, {
 	struct sata_fsl_host_priv *host_priv = host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
+	unsigned long flags;
 
 	if (count > ICC_MAX_INT_COUNT_THRESHOLD)
 		count = ICC_MAX_INT_COUNT_THRESHOLD;
@@ -302,12 +303,12 @@ static void fsl_sata_set_irq_coalescing(struct
ata_host *host, (count > ICC_MIN_INT_COUNT_THRESHOLD))
 		ticks = ICC_SAFE_INT_TICKS;
 
-	spin_lock(&host->lock);
+	spin_lock_irqsave(&host->lock, flags);
 	iowrite32((count << 24 | ticks), hcr_base + ICC);
 
 	intr_coalescing_count = count;
 	intr_coalescing_ticks = ticks;
-	spin_unlock(&host->lock);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	DPRINTK("intrrupt coalescing, count = 0x%x, ticks = %x\n",
 			intr_coalescing_count, intr_coalescing_ticks);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index dc35f4d..4d238c8 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -6,6 +6,18 @@
  *
  * This file is released under GPL v2.
  *
+ * **** WARNING ****
+ *
+ * This driver never worked properly and unfortunately data corruption
is
+ * relatively common.  There isn't anyone working on the driver and
there's
+ * no support from the vendor.  Do not use this driver in any
production
+ * environment.
+ *
+ *
http://thread.gmane.org/gmane.linux.debian.devel.bugs.rc/378525/focus=54491
+ * https://bugzilla.kernel.org/show_bug.cgi?id=60565
+ *
+ * *****************
+ *
  * This controller is eccentric and easily locks up if something isn't
  * right.  Documentation is available at initio's website but it only
  * documents registers (not programming model).
@@ -809,6 +821,8 @@ static int inic_init_one(struct pci_dev *pdev,
const struct pci_device_id *ent) 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
+	dev_alert(&pdev->dev, "inic162x support is broken with common
data corruption issues and will be disabled by default, contact
linux-ide@vger.kernel.org if in production use\n"); + /* alloc host */
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, NR_PORTS);
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7dda4f7..d63a06b 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -154,6 +154,8 @@ static ssize_t show_mem_removable(struct device
*dev, container_of(dev, struct memory_block, dev);
 
 	for (i = 0; i < sections_per_block; i++) {
+		if (!present_section_nr(mem->start_section_nr + i))
+			continue;
 		pfn = section_nr_to_pfn(mem->start_section_nr + i);
 		ret &= is_mem_section_removable(pfn,
PAGES_PER_SECTION); }
diff --git a/drivers/block/xen-blkback/blkback.c
b/drivers/block/xen-blkback/blkback.c index 4fd1dea..4ed7bf9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -399,7 +399,18 @@ static int dispatch_discard_io(struct xen_blkif
*blkif, int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
 	unsigned long secure;
+	struct phys_req preq;
+
+	preq.sector_number = req->u.discard.sector_number;
+	preq.nr_sects      = req->u.discard.nr_sectors;
 
+	err = xen_vbd_translate(&preq, blkif, WRITE);
+	if (err) {
+		pr_warn(DRV_PFX "access denied: DISCARD [%llu->%llu]
on dev=%04x\n",
+			preq.sector_number,
+			preq.sector_number + preq.nr_sects,
blkif->vbd.pdevice);
+		goto fail_response;
+	}
 	blkif->st_ds_req++;
 
 	xen_blkif_get(blkif);
@@ -410,7 +421,7 @@ static int dispatch_discard_io(struct xen_blkif
*blkif, err = blkdev_issue_discard(bdev, req->u.discard.sector_number,
 				   req->u.discard.nr_sectors,
 				   GFP_KERNEL, secure);
-
+fail_response:
 	if (err == -EOPNOTSUPP) {
 		pr_debug(DRV_PFX "discard op failed, not supported\n");
 		status = BLKIF_RSP_EOPNOTSUPP;
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index b0395b0..e224a48 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -176,24 +176,44 @@ error:
 
 static int ath3k_get_state(struct usb_device *udev, unsigned char
*state) {
-	int pipe = 0;
+	int ret, pipe = 0;
+	char *buf;
+
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	pipe = usb_rcvctrlpipe(udev, 0);
-	return usb_control_msg(udev, pipe, ATH3K_GETSTATE,
-			USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-			state, 0x01, USB_CTRL_SET_TIMEOUT);
+	ret = usb_control_msg(udev, pipe, ATH3K_GETSTATE,
+			      USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
+			      buf, sizeof(*buf), USB_CTRL_SET_TIMEOUT);
+
+	*state = *buf;
+	kfree(buf);
+
+	return ret;
 }
 
 static int ath3k_get_version(struct usb_device *udev,
 			struct ath3k_version *version)
 {
-	int pipe = 0;
+	int ret, pipe = 0;
+	struct ath3k_version *buf;
+	const int size = sizeof(*buf);
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	pipe = usb_rcvctrlpipe(udev, 0);
-	return usb_control_msg(udev, pipe, ATH3K_GETVERSION,
-			USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, version,
-			sizeof(struct ath3k_version),
-			USB_CTRL_SET_TIMEOUT);
+	ret = usb_control_msg(udev, pipe, ATH3K_GETVERSION,
+			      USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
+			      buf, size, USB_CTRL_SET_TIMEOUT);
+
+	memcpy(version, buf, size);
+	kfree(buf);
+
+	return ret;
 }
 
 static int ath3k_load_fwfile(struct usb_device *udev,
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 30ac56b..2d139a6 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -55,6 +55,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple-specific (Broadcom) devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
 
+	/* MediaTek MT76x0E */
+	{ USB_DEVICE(0x0e8d, 0x763f) },
+
 	/* Broadcom SoftSailing reporting vendor specific */
 	{ USB_DEVICE(0x0a5c, 0x21e1) },
 
diff --git a/drivers/char/virtio_console.c
b/drivers/char/virtio_console.c index d2f7eb0..edb2ecb 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -257,9 +257,12 @@ static struct port
*find_port_by_devt_in_portdev(struct ports_device *portdev, unsigned
long flags; 
 	spin_lock_irqsave(&portdev->ports_lock, flags);
-	list_for_each_entry(port, &portdev->ports, list)
-		if (port->cdev->dev == dev)
+	list_for_each_entry(port, &portdev->ports, list) {
+		if (port->cdev->dev == dev) {
+			kref_get(&port->kref);
 			goto out;
+		}
+	}
 	port = NULL;
 out:
 	spin_unlock_irqrestore(&portdev->ports_lock, flags);
@@ -634,6 +637,10 @@ static ssize_t port_fops_read(struct file *filp,
char __user *ubuf, 
 	port = filp->private_data;
 
+	/* Port is hot-unplugged. */
+	if (!port->guest_connected)
+		return -ENODEV;
+
 	if (!port_has_data(port)) {
 		/*
 		 * If nothing's connected on the host just return 0 in
@@ -650,7 +657,7 @@ static ssize_t port_fops_read(struct file *filp,
char __user *ubuf, if (ret < 0)
 			return ret;
 	}
-	/* Port got hot-unplugged. */
+	/* Port got hot-unplugged while we were waiting above. */
 	if (!port->guest_connected)
 		return -ENODEV;
 	/*
@@ -793,14 +800,14 @@ static int port_fops_open(struct inode *inode,
struct file *filp) struct port *port;
 	int ret;
 
+	/* We get the port with a kref here */
 	port = find_port_by_devt(cdev->dev);
+	if (!port) {
+		/* Port was unplugged before we could proceed */
+		return -ENXIO;
+	}
 	filp->private_data = port;
 
-	/* Prevent against a port getting hot-unplugged at the same
time */
-	spin_lock_irq(&port->portdev->ports_lock);
-	kref_get(&port->kref);
-	spin_unlock_irq(&port->portdev->ports_lock);
-
 	/*
 	 * Don't allow opening of console port devices -- that's done
 	 * via /dev/hvc
@@ -1258,14 +1265,6 @@ static void remove_port(struct kref *kref)
 
 	port = container_of(kref, struct port, kref);
 
-	sysfs_remove_group(&port->dev->kobj, &port_attribute_group);
-	device_destroy(pdrvdata.class, port->dev->devt);
-	cdev_del(port->cdev);
-
-	kfree(port->name);
-
-	debugfs_remove(port->debugfs_file);
-
 	kfree(port);
 }
 
@@ -1295,12 +1294,14 @@ static void unplug_port(struct port *port)
 	spin_unlock_irq(&port->portdev->ports_lock);
 
 	if (port->guest_connected) {
+		/* Let the app know the port is going down. */
+		send_sigio_to_port(port);
+
+		/* Do this after sigio is actually sent */
 		port->guest_connected = false;
 		port->host_connected = false;
-		wake_up_interruptible(&port->waitqueue);
 
-		/* Let the app know the port is going down. */
-		send_sigio_to_port(port);
+		wake_up_interruptible(&port->waitqueue);
 	}
 
 	if (is_console_port(port)) {
@@ -1319,6 +1320,14 @@ static void unplug_port(struct port *port)
 	 */
 	port->portdev = NULL;
 
+	sysfs_remove_group(&port->dev->kobj, &port_attribute_group);
+	device_destroy(pdrvdata.class, port->dev->devt);
+	cdev_del(port->cdev);
+
+	kfree(port->name);
+
+	debugfs_remove(port->debugfs_file);
+
 	/*
 	 * Locks around here are not necessary - a port can't be
 	 * opened after we removed the port struct from ports_list
diff --git a/drivers/clocksource/dw_apb_timer_of.c
b/drivers/clocksource/dw_apb_timer_of.c index f7dba5b..929e7ce 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -44,7 +44,7 @@ static void add_clockevent(struct device_node
*event_timer) u32 irq, rate;
 
 	irq = irq_of_parse_and_map(event_timer, 0);
-	if (irq == NO_IRQ)
+	if (irq == 0)
 		panic("No IRQ for clock event timer");
 
 	timer_get_base_and_rate(event_timer, &iobase, &rate);
diff --git a/drivers/gpu/drm/ast/ast_ttm.c
b/drivers/gpu/drm/ast/ast_ttm.c index 2a6027c..566934c 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -348,6 +348,7 @@ int ast_bo_create(struct drm_device *dev, int size,
int align, 
 	astbo->gem.driver_private = NULL;
 	astbo->bo.bdev = &ast->ttm.bdev;
+	astbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	ast_ttm_placement(astbo, TTM_PL_FLAG_VRAM |
TTM_PL_FLAG_SYSTEM); 
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c
b/drivers/gpu/drm/cirrus/cirrus_ttm.c index d4b1b1d..d57bcc8 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -353,6 +353,7 @@ int cirrus_bo_create(struct drm_device *dev, int
size, int align, 
 	cirrusbo->gem.driver_private = NULL;
 	cirrusbo->bo.bdev = &cirrus->ttm.bdev;
+	cirrusbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	cirrus_ttm_placement(cirrusbo, TTM_PL_FLAG_VRAM |
TTM_PL_FLAG_SYSTEM); 
diff --git a/drivers/gpu/drm/i915/i915_dma.c
b/drivers/gpu/drm/i915/i915_dma.c index 0969a7c..4c6e9dd 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1465,6 +1465,11 @@ int i915_driver_load(struct drm_device *dev,
unsigned long flags) dev_priv->dev = dev;
 	dev_priv->info = info;
 
+	spin_lock_init(&dev_priv->irq_lock);
+	spin_lock_init(&dev_priv->error_lock);
+	spin_lock_init(&dev_priv->rps_lock);
+	spin_lock_init(&dev_priv->dpio_lock);
+
 	if (i915_get_bridge_dev(dev)) {
 		ret = -EIO;
 		goto free_priv;
@@ -1585,11 +1590,6 @@ int i915_driver_load(struct drm_device *dev,
unsigned long flags) if (!IS_I945G(dev) && !IS_I945GM(dev))
 		pci_enable_msi(dev->pdev);
 
-	spin_lock_init(&dev_priv->irq_lock);
-	spin_lock_init(&dev_priv->error_lock);
-	spin_lock_init(&dev_priv->rps_lock);
-	spin_lock_init(&dev_priv->dpio_lock);
-
 	if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
 		dev_priv->num_pipe = 3;
 	else if (IS_MOBILE(dev) || !IS_GEN2(dev))
diff --git a/drivers/gpu/drm/i915/i915_reg.h
b/drivers/gpu/drm/i915/i915_reg.h index 3814aa3..9d37a9d 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -575,6 +575,8 @@
 					will not assert AGPBUSY# and
will only be delivered when out of C3. */
 #define   INSTPM_FORCE_ORDERING
(1<<7) /* GEN6+ */ +#define   INSTPM_TLB_INVALIDATE	(1<<9)
+#define   INSTPM_SYNC_FLUSH	(1<<5)
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
 #define FW_BLC2		0x020dc
@@ -4074,7 +4076,7 @@
 #define EDP_LINK_TRAIN_600MV_0DB_IVB		(0x30 <<22)
 #define EDP_LINK_TRAIN_600MV_3_5DB_IVB		(0x36 <<22)
 #define EDP_LINK_TRAIN_800MV_0DB_IVB		(0x38 <<22)
-#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x33 <<22)
+#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x3e <<22)
 
 /* legacy values */
 #define EDP_LINK_TRAIN_500MV_0DB_IVB		(0x00 <<22)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c
b/drivers/gpu/drm/i915/intel_ringbuffer.c index e2a73b3..77ee475 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -793,6 +793,18 @@ void intel_ring_setup_status_page(struct
intel_ring_buffer *ring) 
 	I915_WRITE(mmio, (u32)ring->status_page.gfx_addr);
 	POSTING_READ(mmio);
+
+	/* Flush the TLB for this page */
+	if (INTEL_INFO(dev)->gen >= 6) {
+		u32 reg = RING_INSTPM(ring->mmio_base);
+		I915_WRITE(reg,
+			   _MASKED_BIT_ENABLE(INSTPM_TLB_INVALIDATE |
+					      INSTPM_SYNC_FLUSH));
+		if (wait_for((I915_READ(reg) & INSTPM_SYNC_FLUSH) == 0,
+			     1000))
+			DRM_ERROR("%s: wait for SyncFlush to complete
for TLB invalidation timed out\n",
+				  ring->name);
+	}
 }
 
 static int
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c
b/drivers/gpu/drm/mgag200/mgag200_ttm.c index a707394..95b5377 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -347,6 +347,7 @@ int mgag200_bo_create(struct drm_device *dev, int
size, int align, 
 	mgabo->gem.driver_private = NULL;
 	mgabo->bo.bdev = &mdev->ttm.bdev;
+	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM |
TTM_PL_FLAG_SYSTEM); 
diff --git a/drivers/gpu/drm/radeon/atom.c
b/drivers/gpu/drm/radeon/atom.c index 43672b6..daa1e34 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1222,12 +1222,17 @@ int atom_execute_table(struct atom_context
*ctx, int index, uint32_t * params) int r;
 
 	mutex_lock(&ctx->mutex);
+	/* reset data block */
+	ctx->data_block = 0;
 	/* reset reg block */
 	ctx->reg_block = 0;
 	/* reset fb window */
 	ctx->fb_base = 0;
 	/* reset io mode */
 	ctx->io_mode = ATOM_IO_MM;
+	/* reset divmul */
+	ctx->divmul[0] = 0;
+	ctx->divmul[1] = 0;
 	r = atom_execute_table_locked(ctx, index, params);
 	mutex_unlock(&ctx->mutex);
 	return r;
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c
b/drivers/gpu/drm/radeon/atombios_dp.c index 3623b98..a0b5e1e 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -45,6 +45,41 @@ static char *pre_emph_names[] = {
 };
 
 /***** radeon AUX functions *****/
+
+/* Atom needs data in little endian format
+ * so swap as appropriate when copying data to
+ * or from atom. Note that atom operates on
+ * dw units.
+ */
+static void radeon_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool
to_le) +{
+#ifdef __BIG_ENDIAN
+	u8 src_tmp[20], dst_tmp[20]; /* used for byteswapping */
+	u32 *dst32, *src32;
+	int i;
+
+	memcpy(src_tmp, src, num_bytes);
+	src32 = (u32 *)src_tmp;
+	dst32 = (u32 *)dst_tmp;
+	if (to_le) {
+		for (i = 0; i < ((num_bytes + 3) / 4); i++)
+			dst32[i] = cpu_to_le32(src32[i]);
+		memcpy(dst, dst_tmp, num_bytes);
+	} else {
+		u8 dws = num_bytes & ~3;
+		for (i = 0; i < ((num_bytes + 3) / 4); i++)
+			dst32[i] = le32_to_cpu(src32[i]);
+		memcpy(dst, dst_tmp, dws);
+		if (num_bytes % 4) {
+			for (i = 0; i < (num_bytes % 4); i++)
+				dst[dws+i] = dst_tmp[dws+i];
+		}
+	}
+#else
+	memcpy(dst, src, num_bytes);
+#endif
+}
+
 union aux_channel_transaction {
 	PROCESS_AUX_CHANNEL_TRANSACTION_PS_ALLOCATION v1;
 	PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2 v2;
@@ -66,10 +101,10 @@ static int radeon_process_aux_ch(struct
radeon_i2c_chan *chan, 
 	base = (unsigned char *)(rdev->mode_info.atom_context->scratch
+ 1); 
-	memcpy(base, send, send_bytes);
+	radeon_copy_swap(base, send, send_bytes, true);
 
-	args.v1.lpAuxRequest = 0 + 4;
-	args.v1.lpDataOut = 16 + 4;
+	args.v1.lpAuxRequest = cpu_to_le16((u16)(0 + 4));
+	args.v1.lpDataOut = cpu_to_le16((u16)(16 + 4));
 	args.v1.ucDataOutLen = 0;
 	args.v1.ucChannelID = chan->rec.i2c_id;
 	args.v1.ucDelay = delay / 10;
@@ -103,7 +138,7 @@ static int radeon_process_aux_ch(struct
radeon_i2c_chan *chan, recv_bytes = recv_size;
 
 	if (recv && recv_size)
-		memcpy(recv, base + 16, recv_bytes);
+		radeon_copy_swap(recv, base + 16, recv_bytes, false);
 
 	return recv_bytes;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c
b/drivers/gpu/drm/radeon/radeon_combios.c index f75247d..9a762f9 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -147,7 +147,7 @@ static uint16_t combios_get_table_offset(struct
drm_device *dev, enum radeon_combios_table_offset table)
 {
 	struct radeon_device *rdev = dev->dev_private;
-	int rev;
+	int rev, size;
 	uint16_t offset = 0, check_offset;
 
 	if (!rdev->bios)
@@ -156,174 +156,106 @@ static uint16_t combios_get_table_offset(struct
drm_device *dev, switch (table) {
 		/* absolute offset tables */
 	case COMBIOS_ASIC_INIT_1_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0xc);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0xc;
 		break;
 	case COMBIOS_BIOS_SUPPORT_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x14);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x14;
 		break;
 	case COMBIOS_DAC_PROGRAMMING_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x2a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x2a;
 		break;
 	case COMBIOS_MAX_COLOR_DEPTH_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x2c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x2c;
 		break;
 	case COMBIOS_CRTC_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x2e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x2e;
 		break;
 	case COMBIOS_PLL_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x30);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x30;
 		break;
 	case COMBIOS_TV_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x32);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x32;
 		break;
 	case COMBIOS_DFP_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x34);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x34;
 		break;
 	case COMBIOS_HW_CONFIG_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x36);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x36;
 		break;
 	case COMBIOS_MULTIMEDIA_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x38);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x38;
 		break;
 	case COMBIOS_TV_STD_PATCH_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x3e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x3e;
 		break;
 	case COMBIOS_LCD_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x40);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x40;
 		break;
 	case COMBIOS_MOBILE_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x42);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x42;
 		break;
 	case COMBIOS_PLL_INIT_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x46);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x46;
 		break;
 	case COMBIOS_MEM_CONFIG_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x48);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x48;
 		break;
 	case COMBIOS_SAVE_MASK_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x4a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x4a;
 		break;
 	case COMBIOS_HARDCODED_EDID_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x4c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x4c;
 		break;
 	case COMBIOS_ASIC_INIT_2_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x4e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x4e;
 		break;
 	case COMBIOS_CONNECTOR_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x50);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x50;
 		break;
 	case COMBIOS_DYN_CLK_1_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x52);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x52;
 		break;
 	case COMBIOS_RESERVED_MEM_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x54);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x54;
 		break;
 	case COMBIOS_EXT_TMDS_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x58);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x58;
 		break;
 	case COMBIOS_MEM_CLK_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x5a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x5a;
 		break;
 	case COMBIOS_EXT_DAC_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x5c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x5c;
 		break;
 	case COMBIOS_MISC_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x5e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x5e;
 		break;
 	case COMBIOS_CRT_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x60);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x60;
 		break;
 	case COMBIOS_INTEGRATED_SYSTEM_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x62);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x62;
 		break;
 	case COMBIOS_COMPONENT_VIDEO_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x64);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x64;
 		break;
 	case COMBIOS_FAN_SPEED_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x66);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x66;
 		break;
 	case COMBIOS_OVERDRIVE_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x68);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x68;
 		break;
 	case COMBIOS_OEM_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x6a);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x6a;
 		break;
 	case COMBIOS_DYN_CLK_2_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x6c);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x6c;
 		break;
 	case COMBIOS_POWER_CONNECTOR_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x6e);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x6e;
 		break;
 	case COMBIOS_I2C_INFO_TABLE:
-		check_offset = RBIOS16(rdev->bios_header_start + 0x70);
-		if (check_offset)
-			offset = check_offset;
+		check_offset = 0x70;
 		break;
 		/* relative offset tables */
 	case COMBIOS_ASIC_INIT_3_TABLE:	/* offset from misc
info */ @@ -439,11 +371,16 @@ static uint16_t
combios_get_table_offset(struct drm_device *dev, }
 		break;
 	default:
+		check_offset = 0;
 		break;
 	}
 
-	return offset;
+	size = RBIOS8(rdev->bios_header_start + 0x6);
+	/* check absolute offset tables */
+	if (table < COMBIOS_ASIC_INIT_3_TABLE && check_offset &&
check_offset < size)
+		offset = RBIOS16(rdev->bios_header_start +
check_offset); 
+	return offset;
 }
 
 bool radeon_combios_check_hardcoded_edid(struct radeon_device *rdev)
@@ -965,8 +902,10 @@ struct radeon_encoder_primary_dac
*radeon_combios_get_primary_dac_info(struct dac = RBIOS8(dac_info +
0x3) & 0xf; p_dac->ps2_pdac_adj = (bg << 8) | (dac);
 		}
-		/* if the values are all zeros, use the table */
-		if (p_dac->ps2_pdac_adj)
+		/* if the values are zeros, use the table */
+		if ((dac == 0) || (bg == 0))
+			found = 0;
+		else
 			found = 1;
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c
b/drivers/gpu/drm/radeon/radeon_irq_kms.c index 443bd49..4bc6be5 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -243,9 +243,6 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 {
 	int r = 0;
 
-	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
-	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
-
 	spin_lock_init(&rdev->irq.lock);
 	r = drm_vblank_init(rdev->ddev, rdev->num_crtc);
 	if (r) {
@@ -267,6 +264,10 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 		rdev->irq.installed = false;
 		return r;
 	}
+
+	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
+	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
+
 	DRM_INFO("radeon: irq initialized.\n");
 	return 0;
 }
@@ -286,8 +287,8 @@ void radeon_irq_kms_fini(struct radeon_device *rdev)
 		rdev->irq.installed = false;
 		if (rdev->msi_enabled)
 			pci_disable_msi(rdev->pdev);
+		flush_work_sync(&rdev->hotplug_work);
 	}
-	flush_work_sync(&rdev->hotplug_work);
 }
 
 /**
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c index 21ee782..e1978a2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -29,7 +29,9 @@
 #include "drmP.h"
 #include "ttm/ttm_bo_driver.h"
 
-#define VMW_PPN_SIZE sizeof(unsigned long)
+#define VMW_PPN_SIZE (sizeof(unsigned long))
+/* A future safe maximum remap size. */
+#define VMW_PPN_PER_REMAP ((31 * 1024) / VMW_PPN_SIZE)
 
 static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 			 struct page *pages[],
@@ -38,43 +40,61 @@ static int vmw_gmr2_bind(struct vmw_private
*dev_priv, {
 	SVGAFifoCmdDefineGMR2 define_cmd;
 	SVGAFifoCmdRemapGMR2 remap_cmd;
-	uint32_t define_size = sizeof(define_cmd) + 4;
-	uint32_t remap_size = VMW_PPN_SIZE * num_pages +
sizeof(remap_cmd) + 4; uint32_t *cmd;
 	uint32_t *cmd_orig;
+	uint32_t define_size = sizeof(define_cmd) + sizeof(*cmd);
+	uint32_t remap_num = num_pages / VMW_PPN_PER_REMAP +
((num_pages % VMW_PPN_PER_REMAP) > 0);
+	uint32_t remap_size = VMW_PPN_SIZE * num_pages +
(sizeof(remap_cmd) + sizeof(*cmd)) * remap_num;
+	uint32_t remap_pos = 0;
+	uint32_t cmd_size = define_size + remap_size;
 	uint32_t i;
 
-	cmd_orig = cmd = vmw_fifo_reserve(dev_priv, define_size +
remap_size);
+	cmd_orig = cmd = vmw_fifo_reserve(dev_priv, cmd_size);
 	if (unlikely(cmd == NULL))
 		return -ENOMEM;
 
 	define_cmd.gmrId = gmr_id;
 	define_cmd.numPages = num_pages;
 
+	*cmd++ = SVGA_CMD_DEFINE_GMR2;
+	memcpy(cmd, &define_cmd, sizeof(define_cmd));
+	cmd += sizeof(define_cmd) / sizeof(*cmd);
+
+	/*
+	 * Need to split the command if there are too many
+	 * pages that goes into the gmr.
+	 */
+
 	remap_cmd.gmrId = gmr_id;
 	remap_cmd.flags = (VMW_PPN_SIZE > sizeof(*cmd)) ?
 		SVGA_REMAP_GMR2_PPN64 : SVGA_REMAP_GMR2_PPN32;
-	remap_cmd.offsetPages = 0;
-	remap_cmd.numPages = num_pages;
 
-	*cmd++ = SVGA_CMD_DEFINE_GMR2;
-	memcpy(cmd, &define_cmd, sizeof(define_cmd));
-	cmd += sizeof(define_cmd) / sizeof(uint32);
+	while (num_pages > 0) {
+		unsigned long nr = min(num_pages, (unsigned
long)VMW_PPN_PER_REMAP); +
+		remap_cmd.offsetPages = remap_pos;
+		remap_cmd.numPages = nr;
 
-	*cmd++ = SVGA_CMD_REMAP_GMR2;
-	memcpy(cmd, &remap_cmd, sizeof(remap_cmd));
-	cmd += sizeof(remap_cmd) / sizeof(uint32);
+		*cmd++ = SVGA_CMD_REMAP_GMR2;
+		memcpy(cmd, &remap_cmd, sizeof(remap_cmd));
+		cmd += sizeof(remap_cmd) / sizeof(*cmd);
 
-	for (i = 0; i < num_pages; ++i) {
-		if (VMW_PPN_SIZE <= 4)
-			*cmd = page_to_pfn(*pages++);
-		else
-			*((uint64_t *)cmd) = page_to_pfn(*pages++);
+		for (i = 0; i < nr; ++i) {
+			if (VMW_PPN_SIZE <= 4)
+				*cmd = page_to_pfn(*pages++);
+			else
+				*((uint64_t *)cmd) =
page_to_pfn(*pages++); 
-		cmd += VMW_PPN_SIZE / sizeof(*cmd);
+			cmd += VMW_PPN_SIZE / sizeof(*cmd);
+		}
+
+		num_pages -= nr;
+		remap_pos += nr;
 	}
 
-	vmw_fifo_commit(dev_priv, define_size + remap_size);
+	BUG_ON(cmd != cmd_orig + cmd_size / sizeof(*cmd));
+
+	vmw_fifo_commit(dev_priv, cmd_size);
 
 	return 0;
 }
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 54ec8905..034085d 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -215,7 +215,7 @@ static inline int adt7470_write_word_data(struct
i2c_client *client, u8 reg, u16 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value & 0xFF)
-	       && i2c_smbus_write_byte_data(client, reg + 1, value >>
8);
+	       || i2c_smbus_write_byte_data(client, reg + 1, value >>
8); }
 
 static void adt7470_init_client(struct i2c_client *client)
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 970a161..8f81b11 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -137,6 +137,7 @@ config I2C_PIIX4
 	    ATI SB700/SP5100
 	    ATI SB800
 	    AMD Hudson-2
+	    AMD CZ
 	    Serverworks OSB4
 	    Serverworks CSB5
 	    Serverworks CSB6
diff --git a/drivers/i2c/busses/i2c-piix4.c
b/drivers/i2c/busses/i2c-piix4.c index 8bbd6ec..a216d9d 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -22,7 +22,7 @@
 	Intel PIIX4, 440MX
 	Serverworks OSB4, CSB5, CSB6, HT-1000, HT-1100
 	ATI IXP200, IXP300, IXP400, SB600, SB700/SP5100, SB800
-	AMD Hudson-2
+	AMD Hudson-2, CZ
 	SMSC Victory66
 
    Note: we assume there can only be one device, with one or more
@@ -523,6 +523,7 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP400_SMBUS) }, { PCI_DEVICE(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_SBX00_SMBUS) }, { PCI_DEVICE(PCI_VENDOR_ID_AMD,
PCI_DEVICE_ID_AMD_HUDSON2_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x790b) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e5c773d..28bf5f3 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1376,6 +1376,10 @@ static unsigned long iommu_unmap_page(struct
protection_domain *dom, 
 			/* Large PTE found which maps this address */
 			unmap_size = PTE_PAGE_SIZE(*pte);
+
+			/* Only unmap from the first pte in the page */
+			if ((unmap_size - 1) & bus_addr)
+				break;
 			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
 			for (i = 0; i < count; i++)
 				pte[i] = 0ULL;
@@ -1385,7 +1389,7 @@ static unsigned long iommu_unmap_page(struct
protection_domain *dom, unmapped += unmap_size;
 	}
 
-	BUG_ON(!is_power_of_2(unmapped));
+	BUG_ON(unmapped && !is_power_of_2(unmapped));
 
 	return unmapped;
 }
diff --git a/drivers/macintosh/windfarm_rm31.c
b/drivers/macintosh/windfarm_rm31.c index 3eca6d4..e13d9fd 100644
--- a/drivers/macintosh/windfarm_rm31.c
+++ b/drivers/macintosh/windfarm_rm31.c
@@ -439,15 +439,15 @@ static void backside_setup_pid(void)
 
 /* Slots fan */
 static const struct wf_pid_param slots_param = {
-	.interval	= 5,
-	.history_len	= 2,
-	.gd		= 30 << 20,
-	.gp		= 5 << 20,
-	.gr		= 0,
-	.itarget	= 40 << 16,
-	.additive	= 1,
-	.min		= 300,
-	.max		= 4000,
+	.interval	= 1,
+	.history_len	= 20,
+	.gd		= 0,
+	.gp		= 0,
+	.gr		= 0x00100000,
+	.itarget	= 3200000,
+	.additive	= 0,
+	.min		= 20,
+	.max		= 100,
 };
 
 static void slots_fan_tick(void)
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 034233e..4fc70c8 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1561,7 +1561,6 @@ static int multipath_ioctl(struct dm_target *ti,
unsigned int cmd, unsigned long flags;
 	int r;
 
-again:
 	bdev = NULL;
 	mode = 0;
 	r = 0;
@@ -1579,7 +1578,7 @@ again:
 	}
 
 	if ((pgpath && m->queue_io) || (!pgpath &&
m->queue_if_no_path))
-		r = -EAGAIN;
+		r = -ENOTCONN;
 	else if (!bdev)
 		r = -EIO;
 
@@ -1591,11 +1590,8 @@ again:
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >>
SECTOR_SHIFT) r = scsi_verify_blk_ioctl(NULL, cmd);
 
-	if (r == -EAGAIN && !fatal_signal_pending(current)) {
+	if (r == -ENOTCONN && !fatal_signal_pending(current))
 		queue_work(kmultipathd, &m->process_queued_ios);
-		msleep(10);
-		goto again;
-	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index dd5ba3b..30b364c 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -842,9 +842,8 @@ static int verity_ctr(struct dm_target *ti,
unsigned argc, char **argv) for (i = v->levels - 1; i >= 0; i--) {
 		sector_t s;
 		v->hash_level_block[i] = hash_position;
-		s = verity_position_at_level(v, v->data_blocks, i);
-		s = (s >> v->hash_per_block_bits) +
-		    !!(s & ((1 << v->hash_per_block_bits) - 1));
+		s = (v->data_blocks + ((sector_t)1 << ((i + 1) *
v->hash_per_block_bits)) - 1)
+					>> ((i + 1) *
v->hash_per_block_bits); if (hash_position + s < hash_position) {
 			ti->error = "Hash device offset overflow";
 			r = -E2BIG;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4256200..dd0a1a8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -414,10 +414,12 @@ static int dm_blk_ioctl(struct block_device
*bdev, fmode_t mode, unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
-	struct dm_table *map = dm_get_live_table(md);
+	struct dm_table *map;
 	struct dm_target *tgt;
 	int r = -ENOTTY;
 
+retry:
+	map = dm_get_live_table(md);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
@@ -438,6 +440,11 @@ static int dm_blk_ioctl(struct block_device *bdev,
fmode_t mode, out:
 	dm_table_put(map);
 
+	if (r == -ENOTCONN) {
+		msleep(10);
+		goto retry;
+	}
+
 	return r;
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cd7394b..f40decb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2155,12 +2155,18 @@ static void recovery_request_write(struct mddev
*mddev, struct r10bio *r10_bio) d = r10_bio->devs[1].devnum;
 	wbio = r10_bio->devs[1].bio;
 	wbio2 = r10_bio->devs[1].repl_bio;
+	/* Need to test wbio2->bi_end_io before we call
+	 * generic_make_request as if the former is NULL,
+	 * the latter is free to free wbio2.
+	 */
+	if (wbio2 && !wbio2->bi_end_io)
+		wbio2 = NULL;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		md_sync_acct(conf->mirrors[d].rdev->bdev,
wbio->bi_size >> 9); generic_make_request(wbio);
 	}
-	if (wbio2 && wbio2->bi_end_io) {
+	if (wbio2) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
 			     wbio2->bi_size >> 9);
@@ -3434,7 +3440,7 @@ static struct r10conf *setup_conf(struct mddev
*mddev) 
 	/* FIXME calc properly */
 	conf->mirrors = kzalloc(sizeof(struct
raid10_info)*(mddev->raid_disks +
-
max(0,mddev->delta_disks)),
+
max(0,-mddev->delta_disks)), GFP_KERNEL);
 	if (!conf->mirrors)
 		goto out;
@@ -3578,7 +3584,7 @@ static int run(struct mddev *mddev)
 		    conf->geo.far_offset == 0)
 			goto out_free_conf;
 		if (conf->prev.far_copies != 1 &&
-		    conf->geo.far_offset == 0)
+		    conf->prev.far_offset == 0)
 			goto out_free_conf;
 	}
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0689173..f94452d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3396,6 +3396,7 @@ static void handle_stripe(struct stripe_head *sh)
 	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 		set_bit(STRIPE_SYNCING, &sh->state);
 		clear_bit(STRIPE_INSYNC, &sh->state);
+		clear_bit(STRIPE_REPLACED, &sh->state);
 	}
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -3535,19 +3536,23 @@ static void handle_stripe(struct stripe_head
*sh) handle_parity_checks5(conf, sh, &s, disks);
 	}
 
-	if (s.replacing && s.locked == 0
-	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
+	if ((s.replacing || s.syncing) && s.locked == 0
+	    && !test_bit(STRIPE_COMPUTE_RUN, &sh->state)
+	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
 		/* Write out to replacement devices where possible */
 		for (i = 0; i < conf->raid_disks; i++)
-			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
-			    test_bit(R5_NeedReplace,
&sh->dev[i].flags)) {
+			if (test_bit(R5_NeedReplace,
&sh->dev[i].flags)) {
+				WARN_ON(!test_bit(R5_UPTODATE,
&sh->dev[i].flags)); set_bit(R5_WantReplace, &sh->dev[i].flags);
 				set_bit(R5_LOCKED, &sh->dev[i].flags);
 				s.locked++;
 			}
-		set_bit(STRIPE_INSYNC, &sh->state);
+		if (s.replacing)
+			set_bit(STRIPE_INSYNC, &sh->state);
+		set_bit(STRIPE_REPLACED, &sh->state);
 	}
 	if ((s.syncing || s.replacing) && s.locked == 0 &&
+	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index a9fc249..03f988b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -309,6 +309,7 @@ enum {
 	STRIPE_SYNC_REQUESTED,
 	STRIPE_SYNCING,
 	STRIPE_INSYNC,
+	STRIPE_REPLACED,
 	STRIPE_PREREAD_ACTIVE,
 	STRIPE_DELAYED,
 	STRIPE_DEGRADED,
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 8ca4176..bd773e2 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -117,7 +117,7 @@ config MTD_NAND_OMAP2
 
 config MTD_NAND_OMAP_BCH
 	depends on MTD_NAND && MTD_NAND_OMAP2 && ARCH_OMAP3
-	bool "Enable support for hardware BCH error correction"
+	tristate "Enable support for hardware BCH error correction"
 	default n
 	select BCH
 	select BCH_CONST_PARAMS
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index a746ba2..a956053 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -1007,7 +1007,7 @@ static void arcnet_rx(struct net_device *dev, int
bufnum) 
 	soft = &pkt.soft.rfc1201;
 
-	lp->hw.copy_from_card(dev, bufnum, 0, &pkt,
sizeof(ARC_HDR_SIZE));
+	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, ARC_HDR_SIZE);
 	if (pkt.hard.offset[0]) {
 		ofs = pkt.hard.offset[0];
 		length = 256 - ofs;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c
b/drivers/net/can/usb/peak_usb/pcan_usb.c index 25723d8..925ab8e 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -649,7 +649,7 @@ static int pcan_usb_decode_data(struct
pcan_usb_msg_context *mc, u8 status_len) if ((mc->ptr + rec_len) >
mc->end) goto decode_failed;
 
-		memcpy(cf->data, mc->ptr, rec_len);
+		memcpy(cf->data, mc->ptr, cf->can_dlc);
 		mc->ptr += rec_len;
 	}
 
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index c260af5..1f3ff91 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -175,6 +175,8 @@ static int __init dummy_init_module(void)
 
 	rtnl_lock();
 	err = __rtnl_link_register(&dummy_link_ops);
+	if (err < 0)
+		goto out;
 
 	for (i = 0; i < numdummies && !err; i++) {
 		err = dummy_init_one();
@@ -182,6 +184,8 @@ static int __init dummy_init_module(void)
 	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
+
+out:
 	rtnl_unlock();
 
 	return err;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h
b/drivers/net/ethernet/atheros/atl1c/atl1c.h index b2bf324..0f05565
100644 --- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -520,6 +520,9 @@ struct atl1c_adapter {
 	struct net_device   *netdev;
 	struct pci_dev      *pdev;
 	struct napi_struct  napi;
+	struct page         *rx_page;
+	unsigned int	    rx_page_offset;
+	unsigned int	    rx_frag_size;
 	struct atl1c_hw        hw;
 	struct atl1c_hw_stats  hw_stats;
 	struct mii_if_info  mii;    /* MII interface info */
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c index
1bf5bbf..033226b 100644 ---
a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c +++
b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c @@ -482,10 +482,15 @@
static int atl1c_set_mac_addr(struct net_device *netdev, void *p)
static void atl1c_set_rxbufsize(struct atl1c_adapter *adapter, struct
net_device *dev) {
+	unsigned int head_size;
 	int mtu = dev->mtu;
 
 	adapter->rx_buffer_len = mtu > AT_RX_BUF_SIZE ?
 		roundup(mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN, 8) :
AT_RX_BUF_SIZE; +
+	head_size = SKB_DATA_ALIGN(adapter->rx_buffer_len +
NET_SKB_PAD) +
+		    SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	adapter->rx_frag_size = roundup_pow_of_two(head_size);
 }
 
 static netdev_features_t atl1c_fix_features(struct net_device *netdev,
@@ -953,6 +958,10 @@ static void atl1c_free_ring_resources(struct
atl1c_adapter *adapter) kfree(adapter->tpd_ring[0].buffer_info);
 		adapter->tpd_ring[0].buffer_info = NULL;
 	}
+	if (adapter->rx_page) {
+		put_page(adapter->rx_page);
+		adapter->rx_page = NULL;
+	}
 }
 
 /**
@@ -1642,6 +1651,35 @@ static inline void atl1c_rx_checksum(struct
atl1c_adapter *adapter, skb_checksum_none_assert(skb);
 }
 
+static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter)
+{
+	struct sk_buff *skb;
+	struct page *page;
+
+	if (adapter->rx_frag_size > PAGE_SIZE)
+		return netdev_alloc_skb(adapter->netdev,
+					adapter->rx_buffer_len);
+
+	page = adapter->rx_page;
+	if (!page) {
+		adapter->rx_page = page = alloc_page(GFP_ATOMIC);
+		if (unlikely(!page))
+			return NULL;
+		adapter->rx_page_offset = 0;
+	}
+
+	skb = build_skb(page_address(page) + adapter->rx_page_offset,
+			adapter->rx_frag_size);
+	if (likely(skb)) {
+		adapter->rx_page_offset += adapter->rx_frag_size;
+		if (adapter->rx_page_offset >= PAGE_SIZE)
+			adapter->rx_page = NULL;
+		else
+			get_page(page);
+	}
+	return skb;
+}
+
 static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
 {
 	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
@@ -1662,7 +1700,7 @@ static int atl1c_alloc_rx_buffer(struct
atl1c_adapter *adapter) while (next_info->flags & ATL1C_BUFFER_FREE) {
 		rfd_desc = ATL1C_RFD_DESC(rfd_ring, rfd_next_to_use);
 
-		skb = netdev_alloc_skb(adapter->netdev,
adapter->rx_buffer_len);
+		skb = atl1c_alloc_skb(adapter);
 		if (unlikely(!skb)) {
 			if (netif_msg_rx_err(adapter))
 				dev_warn(&pdev->dev, "alloc rx buffer
failed\n"); diff --git
a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c index
8f6b054..4d84939 100644 ---
a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c +++
b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c @@ -1669,8 +1669,8 @@
check_sum: return 0; }
 
-static void atl1e_tx_map(struct atl1e_adapter *adapter,
-		      struct sk_buff *skb, struct atl1e_tpd_desc *tpd)
+static int atl1e_tx_map(struct atl1e_adapter *adapter,
+			struct sk_buff *skb, struct atl1e_tpd_desc
*tpd) {
 	struct atl1e_tpd_desc *use_tpd = NULL;
 	struct atl1e_tx_buffer *tx_buffer = NULL;
@@ -1681,6 +1681,7 @@ static void atl1e_tx_map(struct atl1e_adapter
*adapter, u16 nr_frags;
 	u16 f;
 	int segment;
+	int ring_start = adapter->tx_ring.next_to_use;
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	segment = (tpd->word3 >> TPD_SEGMENT_EN_SHIFT) &
TPD_SEGMENT_EN_MASK; @@ -1693,6 +1694,9 @@ static void
atl1e_tx_map(struct atl1e_adapter *adapter, tx_buffer->length = map_len;
 		tx_buffer->dma = pci_map_single(adapter->pdev,
 					skb->data, hdr_len,
PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev,
tx_buffer->dma))
+			return -ENOSPC;
+
 		ATL1E_SET_PCIMAP_TYPE(tx_buffer,
ATL1E_TX_PCIMAP_SINGLE); mapped_len += map_len;
 		use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
@@ -1719,6 +1723,13 @@ static void atl1e_tx_map(struct atl1e_adapter
*adapter, tx_buffer->dma =
 			pci_map_single(adapter->pdev, skb->data +
mapped_len, map_len, PCI_DMA_TODEVICE);
+
+		if (dma_mapping_error(&adapter->pdev->dev,
tx_buffer->dma)) {
+			/* Reset the tx rings next pointer */
+			adapter->tx_ring.next_to_use = ring_start;
+			return -ENOSPC;
+		}
+
 		ATL1E_SET_PCIMAP_TYPE(tx_buffer,
ATL1E_TX_PCIMAP_SINGLE); mapped_len  += map_len;
 		use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
@@ -1754,6 +1765,13 @@ static void atl1e_tx_map(struct atl1e_adapter
*adapter, (i * MAX_TX_BUF_LEN),
 							  tx_buffer->length,
 							  DMA_TO_DEVICE);
+
+			if (dma_mapping_error(&adapter->pdev->dev,
tx_buffer->dma)) {
+				/* Reset the ring next to use pointer
*/
+				adapter->tx_ring.next_to_use =
ring_start;
+				return -ENOSPC;
+			}
+
 			ATL1E_SET_PCIMAP_TYPE(tx_buffer,
ATL1E_TX_PCIMAP_PAGE); use_tpd->buffer_addr =
cpu_to_le64(tx_buffer->dma); use_tpd->word2 = (use_tpd->word2 &
(~TPD_BUFLEN_MASK)) | @@ -1771,6 +1789,7 @@ static void
atl1e_tx_map(struct atl1e_adapter *adapter, /* The last buffer info
contain the skb address, so it will be free after unmap */
 	tx_buffer->skb = skb;
+	return 0;
 }
 
 static void atl1e_tx_queue(struct atl1e_adapter *adapter, u16 count,
@@ -1838,10 +1857,13 @@ static netdev_tx_t atl1e_xmit_frame(struct
sk_buff *skb, return NETDEV_TX_OK;
 	}
 
-	atl1e_tx_map(adapter, skb, tpd);
+	if (atl1e_tx_map(adapter, skb, tpd))
+		goto out;
+
 	atl1e_tx_queue(adapter, tpd_req, tpd);
 
 	netdev->trans_start = jiffies; /* NETIF_F_LLTX driver :( */
+out:
 	spin_unlock_irqrestore(&adapter->tx_lock, flags);
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c
b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c index
87592b4..b3c05de 100644 ---
a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c +++
b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c @@ -108,9 +108,8
@@ s32 ixgbe_dcb_config_tx_desc_arbiter_82598(struct ixgbe_hw *hw, 
 	/* Enable arbiter */
 	reg &= ~IXGBE_DPMCS_ARBDIS;
-	/* Enable DFP and Recycle mode */
-	reg |= (IXGBE_DPMCS_TDPAC | IXGBE_DPMCS_TRM);
 	reg |= IXGBE_DPMCS_TSOEF;
+
 	/* Configure Max TSO packet size 34KB including payload and
headers */ reg |= (0x4 << IXGBE_DPMCS_MTSOS_SHIFT);
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c
b/drivers/net/ethernet/realtek/8139cp.c index dd3371b..e933d57 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -478,7 +478,7 @@ rx_status_loop:
 
 	while (1) {
 		u32 status, len;
-		dma_addr_t mapping;
+		dma_addr_t mapping, new_mapping;
 		struct sk_buff *skb, *new_skb;
 		struct cp_desc *desc;
 		const unsigned buflen = cp->rx_buf_sz;
@@ -520,6 +520,13 @@ rx_status_loop:
 			goto rx_next;
 		}
 
+		new_mapping = dma_map_single(&cp->pdev->dev,
new_skb->data, buflen,
+					 PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
+			dev->stats.rx_dropped++;
+			goto rx_next;
+		}
+
 		dma_unmap_single(&cp->pdev->dev, mapping,
 				 buflen, PCI_DMA_FROMDEVICE);
 
@@ -531,12 +538,11 @@ rx_status_loop:
 
 		skb_put(skb, len);
 
-		mapping = dma_map_single(&cp->pdev->dev,
new_skb->data, buflen,
-					 PCI_DMA_FROMDEVICE);
 		cp->rx_skb[rx_tail] = new_skb;
 
 		cp_rx_skb(cp, skb, desc);
 		rx++;
+		mapping = new_mapping;
 
 rx_next:
 		cp->rx_ring[rx_tail].opts2 = 0;
@@ -707,6 +713,22 @@ static inline u32 cp_tx_vlan_tag(struct sk_buff
*skb) TxVlanTag | swab16(vlan_tx_tag_get(skb)) : 0x00;
 }
 
+static void unwind_tx_frag_mapping(struct cp_private *cp, struct
sk_buff *skb,
+				   int first, int entry_last)
+{
+	int frag, index;
+	struct cp_desc *txd;
+	skb_frag_t *this_frag;
+	for (frag = 0; frag+first < entry_last; frag++) {
+		index = first+frag;
+		cp->tx_skb[index] = NULL;
+		txd = &cp->tx_ring[index];
+		this_frag = &skb_shinfo(skb)->frags[frag];
+		dma_unmap_single(&cp->pdev->dev,
le64_to_cpu(txd->addr),
+				 skb_frag_size(this_frag),
PCI_DMA_TODEVICE);
+	}
+}
+
 static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 					struct net_device *dev)
 {
@@ -740,6 +762,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff
*skb, 
 		len = skb->len;
 		mapping = dma_map_single(&cp->pdev->dev, skb->data,
len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping))
+			goto out_dma_error;
+
 		txd->opts2 = opts2;
 		txd->addr = cpu_to_le64(mapping);
 		wmb();
@@ -777,6 +802,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff
*skb, first_len = skb_headlen(skb);
 		first_mapping = dma_map_single(&cp->pdev->dev,
skb->data, first_len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, first_mapping))
+			goto out_dma_error;
+
 		cp->tx_skb[entry] = skb;
 		entry = NEXT_TX(entry);
 
@@ -790,6 +818,11 @@ static netdev_tx_t cp_start_xmit (struct sk_buff
*skb, mapping = dma_map_single(&cp->pdev->dev,
 						 skb_frag_address(this_frag),
 						 len,
PCI_DMA_TODEVICE);
+			if (dma_mapping_error(&cp->pdev->dev,
mapping)) {
+				unwind_tx_frag_mapping(cp, skb,
first_entry, entry);
+				goto out_dma_error;
+			}
+
 			eor = (entry == (CP_TX_RING_SIZE - 1)) ?
RingEnd : 0; 
 			ctrl = eor | len | DescOwn;
@@ -848,11 +881,16 @@ static netdev_tx_t cp_start_xmit (struct sk_buff
*skb, if (TX_BUFFS_AVAIL(cp) <= (MAX_SKB_FRAGS + 1))
 		netif_stop_queue(dev);
 
+out_unlock:
 	spin_unlock_irqrestore(&cp->lock, intr_flags);
 
 	cpw8(TxPoll, NormalTxPoll);
 
 	return NETDEV_TX_OK;
+out_dma_error:
+	kfree_skb(skb);
+	cp->dev->stats.tx_dropped++;
+	goto out_unlock;
 }
 
 /* Set or clear the multicast filter for this adaptor.
@@ -1023,6 +1061,10 @@ static int cp_refill_rx(struct cp_private *cp)
 
 		mapping = dma_map_single(&cp->pdev->dev, skb->data,
 					 cp->rx_buf_sz,
PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping)) {
+			kfree_skb(skb);
+			goto err_out;
+		}
 		cp->rx_skb[i] = skb;
 
 		cp->rx_ring[i].opts2 = 0;
diff --git a/drivers/net/ethernet/sun/sunvnet.c
b/drivers/net/ethernet/sun/sunvnet.c index a108db3..1d68059 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1243,6 +1243,8 @@ static int vnet_port_remove(struct vio_dev *vdev)
 		dev_set_drvdata(&vdev->dev, NULL);
 
 		kfree(port);
+
+		unregister_netdev(vp->dev);
 	}
 	return 0;
 }
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 344dceb..635d01c 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -290,11 +290,17 @@ static int __init ifb_init_module(void)
 
 	rtnl_lock();
 	err = __rtnl_link_register(&ifb_link_ops);
+	if (err < 0)
+		goto out;
 
-	for (i = 0; i < numifbs && !err; i++)
+	for (i = 0; i < numifbs && !err; i++) {
 		err = ifb_init_one(i);
+		cond_resched();
+	}
 	if (err)
 		__rtnl_link_unregister(&ifb_link_ops);
+
+out:
 	rtnl_unlock();
 
 	return err;
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 0f0f9ce..43d3ed8 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -642,6 +642,28 @@ static int macvtap_skb_to_vnet_hdr(const struct
sk_buff *skb, return 0;
 }
 
+static unsigned long iov_pages(const struct iovec *iv, int offset,
+			       unsigned long nr_segs)
+{
+	unsigned long seg, base;
+	int pages = 0, len, size;
+
+	while (nr_segs && (offset >= iv->iov_len)) {
+		offset -= iv->iov_len;
+		++iv;
+		--nr_segs;
+	}
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		base = (unsigned long)iv[seg].iov_base + offset;
+		len = iv[seg].iov_len - offset;
+		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >>
PAGE_SHIFT;
+		pages += size;
+		offset = 0;
+	}
+
+	return pages;
+}
 
 /* Get packet from user space buffer */
 static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr
*m, @@ -656,6 +678,7 @@ static ssize_t macvtap_get_user(struct
macvtap_queue *q, struct msghdr *m, int vnet_hdr_len = 0;
 	int copylen = 0;
 	bool zerocopy = false;
+	size_t linear;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = q->vnet_hdr_sz;
@@ -687,42 +710,35 @@ static ssize_t macvtap_get_user(struct
macvtap_queue *q, struct msghdr *m, if (unlikely(count > UIO_MAXIOV))
 		goto err;
 
-	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY))
-		zerocopy = true;
+	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
+		copylen = vnet_hdr.hdr_len ? vnet_hdr.hdr_len :
GOODCOPY_LEN;
+		linear = copylen;
+		if (iov_pages(iv, vnet_hdr_len + copylen, count)
+		    <= MAX_SKB_FRAGS)
+			zerocopy = true;
+	}
 
-	if (zerocopy) {
-		/* Userspace may produce vectors with count greater
than
-		 * MAX_SKB_FRAGS, so we need to linearize parts of the
skb
-		 * to let the rest of data to be fit in the frags.
-		 */
-		if (count > MAX_SKB_FRAGS) {
-			copylen = iov_length(iv, count -
MAX_SKB_FRAGS);
-			if (copylen < vnet_hdr_len)
-				copylen = 0;
-			else
-				copylen -= vnet_hdr_len;
-		}
-		/* There are 256 bytes to be copied in skb, so there
is enough
-		 * room for skb expand head in case it is used.
-		 * The rest buffer is mapped from userspace.
-		 */
-		if (copylen < vnet_hdr.hdr_len)
-			copylen = vnet_hdr.hdr_len;
-		if (!copylen)
-			copylen = GOODCOPY_LEN;
-	} else
+	if (!zerocopy) {
 		copylen = len;
+		linear = vnet_hdr.hdr_len;
+	}
 
 	skb = macvtap_alloc_skb(&q->sk, NET_IP_ALIGN, copylen,
-				vnet_hdr.hdr_len, noblock, &err);
+				linear, noblock, &err);
 	if (!skb)
 		goto err;
 
 	if (zerocopy)
 		err = zerocopy_sg_from_iovec(skb, iv, vnet_hdr_len,
count);
-	else
+	else {
 		err = skb_copy_datagram_from_iovec(skb, 0, iv,
vnet_hdr_len, len);
+		if (!err && m && m->msg_control) {
+			struct ubuf_info *uarg = m->msg_control;
+			uarg->callback(uarg, false);
+		}
+	}
+
 	if (err)
 		goto err_kfree;
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ef7710f..9ab7b34 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -685,6 +685,30 @@ static int zerocopy_sg_from_iovec(struct sk_buff
*skb, const struct iovec *from, return 0;
 }
 
+
+static unsigned long iov_pages(const struct iovec *iv, int offset,
+			       unsigned long nr_segs)
+{
+	unsigned long seg, base;
+	int pages = 0, len, size;
+
+	while (nr_segs && (offset >= iv->iov_len)) {
+		offset -= iv->iov_len;
+		++iv;
+		--nr_segs;
+	}
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		base = (unsigned long)iv[seg].iov_base + offset;
+		len = iv[seg].iov_len - offset;
+		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >>
PAGE_SHIFT;
+		pages += size;
+		offset = 0;
+	}
+
+	return pages;
+}
+
 /* Get packet from user space buffer */
 static ssize_t tun_get_user(struct tun_struct *tun, void *msg_control,
 			    const struct iovec *iv, size_t total_len,
@@ -692,7 +716,7 @@ static ssize_t tun_get_user(struct tun_struct *tun,
void *msg_control, {
 	struct tun_pi pi = { 0, cpu_to_be16(ETH_P_IP) };
 	struct sk_buff *skb;
-	size_t len = total_len, align = NET_SKB_PAD;
+	size_t len = total_len, align = NET_SKB_PAD, linear;
 	struct virtio_net_hdr gso = { 0 };
 	int offset = 0;
 	int copylen;
@@ -731,34 +755,24 @@ static ssize_t tun_get_user(struct tun_struct
*tun, void *msg_control, return -EINVAL;
 	}
 
-	if (msg_control)
-		zerocopy = true;
-
-	if (zerocopy) {
-		/* Userspace may produce vectors with count greater
than
-		 * MAX_SKB_FRAGS, so we need to linearize parts of the
skb
-		 * to let the rest of data to be fit in the frags.
-		 */
-		if (count > MAX_SKB_FRAGS) {
-			copylen = iov_length(iv, count -
MAX_SKB_FRAGS);
-			if (copylen < offset)
-				copylen = 0;
-			else
-				copylen -= offset;
-		} else
-				copylen = 0;
-		/* There are 256 bytes to be copied in skb, so there
is enough
-		 * room for skb expand head in case it is used.
+	if (msg_control) {
+		/* There are 256 bytes to be copied in skb, so there is
+		 * enough room for skb expand head in case it is used.
 		 * The rest of the buffer is mapped from userspace.
 		 */
-		if (copylen < gso.hdr_len)
-			copylen = gso.hdr_len;
-		if (!copylen)
-			copylen = GOODCOPY_LEN;
-	} else
+		copylen = gso.hdr_len ? gso.hdr_len : GOODCOPY_LEN;
+		linear = copylen;
+		if (iov_pages(iv, offset + copylen, count) <=
MAX_SKB_FRAGS)
+			zerocopy = true;
+	}
+
+	if (!zerocopy) {
 		copylen = len;
+		linear = gso.hdr_len;
+	}
 
 	skb = tun_alloc_skb(tun, align, copylen, gso.hdr_len, noblock);
+	skb = tun_alloc_skb(tun, align, copylen, linear, noblock);
 	if (IS_ERR(skb)) {
 		if (PTR_ERR(skb) != -EAGAIN)
 			tun->dev->stats.rx_dropped++;
@@ -767,8 +781,13 @@ static ssize_t tun_get_user(struct tun_struct
*tun, void *msg_control, 
 	if (zerocopy)
 		err = zerocopy_sg_from_iovec(skb, iv, offset, count);
-	else
+	else {
 		err = skb_copy_datagram_from_iovec(skb, 0, iv, offset,
len);
+		if (!err && msg_control) {
+			struct ubuf_info *uarg = msg_control;
+			uarg->callback(uarg, false);
+		}
+	}
 
 	if (err) {
 		tun->dev->stats.rx_dropped++;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 83d2b0c..fc04222 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -528,7 +528,7 @@ static int virtnet_poll(struct napi_struct *napi,
int budget) {
 	struct virtnet_info *vi = container_of(napi, struct
virtnet_info, napi); void *buf;
-	unsigned int len, received = 0;
+	unsigned int r, len, received = 0;
 
 again:
 	while (received < budget &&
@@ -545,8 +545,9 @@ again:
 
 	/* Out of packets? */
 	if (received < budget) {
+		r = virtqueue_enable_cb_prepare(vi->rvq);
 		napi_complete(napi);
-		if (unlikely(!virtqueue_enable_cb(vi->rvq)) &&
+		if (unlikely(virtqueue_poll(vi->rvq, r)) &&
 		    napi_schedule_prep(napi)) {
 			virtqueue_disable_cb(vi->rvq);
 			__napi_schedule(napi);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c index d066f25..e8e3929
100644 --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3562,7 +3562,7 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct
ath_hw *ah, int chain, static void ar9003_hw_ant_ctrl_apply(struct
ath_hw *ah, bool is2ghz) {
 	int chain;
-	u32 regval;
+	u32 regval, value;
 	u32 ant_div_ctl1;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
@@ -3570,7 +3570,11 @@ static void ar9003_hw_ant_ctrl_apply(struct
ath_hw *ah, bool is2ghz) AR_PHY_SWITCH_CHAIN_2,
 	};
 
-	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
+
AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED); +
+	value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
 	if (AR_SREV_9462(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
b/drivers/net/wireless/ath/ath9k/ar9003_phy.h index 84d3d49..3dead81
100644 --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -339,6 +339,8 @@
 
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
+#define AR9300_EXT_LNA_CTL_GPIO_AR9485 9
+
 /*
  * AGC Field Definitions
  */
diff --git a/drivers/net/wireless/ath/ath9k/calib.c
b/drivers/net/wireless/ath/ath9k/calib.c index e5cceb0..00960b7 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -388,7 +388,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct
ath9k_channel *chan) 
 	if (!caldata) {
 		chan->noisefloor = nf;
-		ah->noise = ath9k_hw_getchan_noise(ah, chan);
 		return false;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
b/drivers/net/wireless/ath/ath9k/htc_drv_init.c index 01248b9..4303173
100644 --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -824,6 +824,7 @@ static int ath9k_init_device(struct ath9k_htc_priv
*priv, if (error != 0)
 		goto err_rx;
 
+	ath9k_hw_disable(priv->ah);
 #ifdef CONFIG_MAC80211_LEDS
 	/* must be initialized before ieee80211_register_hw */
 	priv->led_cdev.default_trigger =
ieee80211_create_tpt_led_trigger(priv->hw, diff --git
a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c index 47e61d0..c1289b6
100644 --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c +++
b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c @@ -448,6 +448,7 @@
static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv, struct
ieee80211_conf *cur_conf = &priv->hw->conf; bool txok;
 	int slot;
+	int hdrlen, padsize;
 
 	slot = strip_drv_header(priv, skb);
 	if (slot < 0) {
@@ -504,6 +505,15 @@ send_mac80211:
 
 	ath9k_htc_tx_clear_slot(priv, slot);
 
+	/* Remove padding before handing frame back to mac80211 */
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+
+	padsize = hdrlen & 3;
+	if (padsize && skb->len > hdrlen + padsize) {
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
 	/* Send status to mac80211 */
 	ieee80211_tx_status(priv->hw, skb);
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c index e032723..d0ed5c6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -172,8 +172,7 @@ static void ath_restart_work(struct ath_softc *sc)
 {
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9485(sc->sc_ah) ||
-	    AR_SREV_9550(sc->sc_ah))
+	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9330(sc->sc_ah))
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work,
 				     msecs_to_jiffies(ATH_PLL_WORK_INTERVAL));
 
diff --git a/drivers/net/wireless/b43/Kconfig
b/drivers/net/wireless/b43/Kconfig index 3876c7e..af40211 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -28,7 +28,7 @@ config B43
 
 config B43_BCMA
 	bool "Support for BCMA bus"
-	depends on B43 && BCMA
+	depends on B43 && (BCMA = y || BCMA = B43)
 	default y
 
 config B43_BCMA_EXTRA
@@ -39,7 +39,7 @@ config B43_BCMA_EXTRA
 
 config B43_SSB
 	bool
-	depends on B43 && SSB
+	depends on B43 && (SSB = y || SSB = B43)
 	default y
 
 # Auto-select SSB PCI-HOST support, if possible
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c
b/drivers/net/wireless/hostap/hostap_ioctl.c index 18054d9..dbec2ff
100644 --- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -522,9 +522,9 @@ static int prism2_ioctl_giwaplist(struct net_device
*dev, 
 	data->length = prism2_ap_get_sta_qual(local, addr, qual,
IW_MAX_AP, 1); 
-	memcpy(extra, &addr, sizeof(struct sockaddr) * data->length);
+	memcpy(extra, addr, sizeof(struct sockaddr) * data->length);
 	data->flags = 1; /* has quality information */
-	memcpy(extra + sizeof(struct sockaddr) * data->length, &qual,
+	memcpy(extra + sizeof(struct sockaddr) * data->length, qual,
 	       sizeof(struct iw_quality) * data->length);
 
 	kfree(addr);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c
b/drivers/net/wireless/iwlegacy/4965-mac.c index 34f61a0..f6624b8 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4411,12 +4411,12 @@ il4965_irq_tasklet(struct il_priv *il)
 		 * is killed. Hence update the killswitch state here.
The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(S_ALIVE, &il->status)) {
-			if (hw_rf_kill)
-				set_bit(S_RFKILL, &il->status);
-			else
-				clear_bit(S_RFKILL, &il->status);
+		if (hw_rf_kill) {
+			set_bit(S_RFKILL, &il->status);
+		} else {
+			clear_bit(S_RFKILL, &il->status);
 			wiphy_rfkill_set_hw_state(il->hw->wiphy,
hw_rf_kill);
+			il_force_reset(il, true);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -5285,6 +5285,9 @@ il4965_alive_start(struct il_priv *il)
 
 	il->active_rate = RATES_MASK;
 
+	il_power_update_mode(il, true);
+	D_INFO("Updated power mode\n");
+
 	if (il_is_associated(il)) {
 		struct il_rxon_cmd *active_rxon =
 		    (struct il_rxon_cmd *)&il->active;
@@ -5315,9 +5318,6 @@ il4965_alive_start(struct il_priv *il)
 	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
-	il_power_update_mode(il, true);
-	D_INFO("Updated power mode\n");
-
 	return;
 
 restart:
diff --git a/drivers/net/wireless/iwlegacy/common.c
b/drivers/net/wireless/iwlegacy/common.c index 0370403..3d26831 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4658,6 +4658,7 @@ il_force_reset(struct il_priv *il, bool external)
 
 	return 0;
 }
+EXPORT_SYMBOL(il_force_reset);
 
 int
 il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif
*vif, diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
b/drivers/net/wireless/iwlwifi/dvm/mac80211.c index 7a2cf52..515376d
100644 --- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -941,7 +941,10 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool
is_success) if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
&priv->status))
+	if (!test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
&priv->status))
+		return;
+
+	if (ctx->vif)
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c
b/drivers/net/wireless/iwlwifi/pcie/drv.c index f4c3500..71e887c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -132,6 +132,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x423C, 0x1306, iwl5150_abg_cfg)}, /* Half
Mini Card */ {IWL_PCI_DEVICE(0x423C, 0x1221, iwl5150_agn_cfg)}, /* Mini
Card */ {IWL_PCI_DEVICE(0x423C, 0x1321, iwl5150_agn_cfg)}, /* Half Mini
Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1326, iwl5150_abg_cfg)}, /* Half
Mini Card */ 
 	{IWL_PCI_DEVICE(0x423D, 0x1211, iwl5150_agn_cfg)}, /* Mini
Card */ {IWL_PCI_DEVICE(0x423D, 0x1311, iwl5150_agn_cfg)}, /* Half Mini
Card */ diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c
b/drivers/net/wireless/iwlwifi/pcie/trans.c index dbeebef..d7eeb96
100644 --- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2100,16 +2100,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct
pci_dev *pdev, spin_lock_init(&trans_pcie->irq_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
-	/* W/A - seems to solve weird behavior. We need to remove this
if we
-	 * don't want to stay in L1 all the time. This wastes a lot of
power */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
PCIE_LINK_STATE_L1 |
-			       PCIE_LINK_STATE_CLKPM);
-
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
 		goto out_no_pci;
 	}
 
+	/* W/A - seems to solve weird behavior. We need to remove this
if we
+	 * don't want to stay in L1 all the time. This wastes a lot of
power */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	pci_set_master(pdev);
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
diff --git a/drivers/net/wireless/mwifiex/sdio.c
b/drivers/net/wireless/mwifiex/sdio.c index 82cf0fa..821d9d2 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1455,8 +1455,8 @@ static int mwifiex_sdio_host_to_card(struct
mwifiex_adapter *adapter, /* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) pkt_len;
-	*(u16 *) &payload[2] = type;
+	*(__le16 *)&payload[0] = cpu_to_le16((u16)pkt_len);
+	*(__le16 *)&payload[2] = cpu_to_le16(type);
 
 	/*
 	 * This is SDIO specific header
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
b/drivers/net/wireless/rt2x00/rt2800lib.c index 6c85ba5..fe0e278 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4980,8 +4980,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev
*rt2x00dev) default_power2 = rt2x00_eeprom_addr(rt2x00dev,
EEPROM_TXPOWER_A2); 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].default_power1 = default_power1[i];
-			info[i].default_power2 = default_power2[i];
+			info[i].default_power1 = default_power1[i -
14];
+			info[i].default_power2 = default_power2[i -
14]; }
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c
b/drivers/net/wireless/rt2x00/rt2x00queue.c index f7e74a0..cff62c0
100644 --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -875,13 +875,8 @@ void rt2x00queue_index_inc(struct queue_entry
*entry, enum queue_index index)
spin_unlock_irqrestore(&queue->index_lock, irqflags); }
 
-void rt2x00queue_pause_queue(struct data_queue *queue)
+void rt2x00queue_pause_queue_nocheck(struct data_queue *queue)
 {
-	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags)
||
-	    !test_bit(QUEUE_STARTED, &queue->flags) ||
-	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
-		return;
-
 	switch (queue->qid) {
 	case QID_AC_VO:
 	case QID_AC_VI:
@@ -897,6 +892,15 @@ void rt2x00queue_pause_queue(struct data_queue
*queue) break;
 	}
 }
+void rt2x00queue_pause_queue(struct data_queue *queue)
+{
+	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags)
||
+	    !test_bit(QUEUE_STARTED, &queue->flags) ||
+	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
+		return;
+
+	rt2x00queue_pause_queue_nocheck(queue);
+}
 EXPORT_SYMBOL_GPL(rt2x00queue_pause_queue);
 
 void rt2x00queue_unpause_queue(struct data_queue *queue)
@@ -958,7 +962,7 @@ void rt2x00queue_stop_queue(struct data_queue
*queue) return;
 	}
 
-	rt2x00queue_pause_queue(queue);
+	rt2x00queue_pause_queue_nocheck(queue);
 
 	queue->rt2x00dev->ops->lib->stop_queue(queue);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c
b/drivers/net/wireless/rt2x00/rt61pci.c index b8ec961..7e475a9 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2822,7 +2822,8 @@ static int rt61pci_probe_hw_mode(struct
rt2x00_dev *rt2x00dev) tx_power = rt2x00_eeprom_addr(rt2x00dev,
EEPROM_TXPOWER_A_START); for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 =
TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i -
14]); }
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c
b/drivers/net/wireless/rt2x00/rt73usb.c index 248436c..55d30ba 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2167,7 +2167,8 @@ static int rt73usb_probe_hw_mode(struct
rt2x00_dev *rt2x00dev) tx_power = rt2x00_eeprom_addr(rt2x00dev,
EEPROM_TXPOWER_A_START); for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 =
TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i -
14]); }
 	}
 
diff --git a/drivers/net/wireless/zd1201.c
b/drivers/net/wireless/zd1201.c index 48273dd..4312eca 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -98,10 +98,12 @@ static int zd1201_fw_upload(struct usb_device *dev,
int apfw) goto exit;
 
 	err = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), 0x4,
-	    USB_DIR_IN | 0x40, 0,0, &ret, sizeof(ret),
ZD1201_FW_TIMEOUT);
+	    USB_DIR_IN | 0x40, 0, 0, buf, sizeof(ret),
ZD1201_FW_TIMEOUT); if (err < 0)
 		goto exit;
 
+	memcpy(&ret, buf, sizeof(ret));
+
 	if (ret & 0x80) {
 		err = -EIO;
 		goto exit;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index ecac034..110c26c 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -275,8 +275,7 @@ no_skb:
 			break;
 		}
 
-		__skb_fill_page_desc(skb, 0, page, 0, 0);
-		skb_shinfo(skb)->nr_frags = 1;
+		skb_add_rx_frag(skb, 0, page, 0, 0, PAGE_SIZE);
 		__skb_queue_tail(&np->rx_batch, skb);
 	}
 
@@ -771,7 +770,6 @@ static RING_IDX xennet_fill_frags(struct
netfront_info *np, struct sk_buff_head *list)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	int nr_frags = shinfo->nr_frags;
 	RING_IDX cons = np->rx.rsp_cons;
 	struct sk_buff *nskb;
 
@@ -780,19 +778,21 @@ static RING_IDX xennet_fill_frags(struct
netfront_info *np, RING_GET_RESPONSE(&np->rx, ++cons);
 		skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
 
-		__skb_fill_page_desc(skb, nr_frags,
-				     skb_frag_page(nfrag),
-				     rx->offset, rx->status);
+		if (shinfo->nr_frags == MAX_SKB_FRAGS) {
+			unsigned int pull_to =
NETFRONT_SKB_CB(skb)->pull_to; 
-		skb->data_len += rx->status;
+			BUG_ON(pull_to <= skb_headlen(skb));
+			__pskb_pull_tail(skb, pull_to -
skb_headlen(skb));
+		}
+		BUG_ON(shinfo->nr_frags >= MAX_SKB_FRAGS);
+
+		skb_add_rx_frag(skb, shinfo->nr_frags,
skb_frag_page(nfrag),
+				rx->offset, rx->status, PAGE_SIZE);
 
 		skb_shinfo(nskb)->nr_frags = 0;
 		kfree_skb(nskb);
-
-		nr_frags++;
 	}
 
-	shinfo->nr_frags = nr_frags;
 	return cons;
 }
 
@@ -878,7 +878,8 @@ static int handle_incoming_queue(struct net_device
*dev, while ((skb = __skb_dequeue(rxq)) != NULL) {
 		int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
 
-		__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
+		if (pull_to > skb_headlen(skb))
+			__pskb_pull_tail(skb, pull_to -
skb_headlen(skb)); 
 		/* Ethernet work: Delayed to here as it peeks the
header. */ skb->protocol = eth_type_trans(skb, dev);
@@ -964,35 +965,10 @@ err:
 		skb_shinfo(skb)->frags[0].page_offset = rx->offset;
 		skb_frag_size_set(&skb_shinfo(skb)->frags[0],
rx->status); skb->data_len = rx->status;
+		skb->len += rx->status;
 
 		i = xennet_fill_frags(np, skb, &tmpq);
 
-		/*
-		 * Truesize approximates the size of true data plus
-		 * any supervisor overheads. Adding hypervisor
-		 * overheads has been shown to significantly reduce
-		 * achievable bandwidth with the default receive
-		 * buffer size. It is therefore not wise to account
-		 * for it here.
-		 *
-		 * After alloc_skb(RX_COPY_THRESHOLD), truesize is set
-		 * to RX_COPY_THRESHOLD + the supervisor
-		 * overheads. Here, we add the size of the data pulled
-		 * in xennet_fill_frags().
-		 *
-		 * We also adjust for any unused space in the main
-		 * data area by subtracting (RX_COPY_THRESHOLD -
-		 * len). This is especially important with drivers
-		 * which split incoming packets into header and data,
-		 * using only 66 bytes of the main data area (see the
-		 * e1000 driver for example.)  On such systems,
-		 * without this last adjustement, our achievable
-		 * receive throughout using the standard receive
-		 * buffer size was cut by 25%(!!!).
-		 */
-		skb->truesize += skb->data_len - RX_COPY_THRESHOLD;
-		skb->len += skb->data_len;
-
 		if (rx->flags & XEN_NETRXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;
 		else if (rx->flags & XEN_NETRXF_data_validated)
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 91a375f..17fad3b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -390,6 +390,8 @@ static void __unflatten_device_tree(struct
boot_param_header *blob, mem = (unsigned long)
 		dt_alloc(size + 4, __alignof__(struct device_node));
 
+	memset((void *)mem, 0, size);
+
 	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
 
 	pr_debug("  unflattening %lx...\n", mem);
diff --git a/drivers/platform/olpc/olpc-ec.c
b/drivers/platform/olpc/olpc-ec.c index 0f9f859..f911952 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -330,7 +330,7 @@ static int __init olpc_ec_init_module(void)
 	return platform_driver_register(&olpc_ec_plat_driver);
 }
 
-module_init(olpc_ec_init_module);
+arch_initcall(olpc_ec_init_module);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/rapidio/switches/idt_gen2.c
b/drivers/rapidio/switches/idt_gen2.c index 809b7a3..5d3b0f0 100644
--- a/drivers/rapidio/switches/idt_gen2.c
+++ b/drivers/rapidio/switches/idt_gen2.c
@@ -15,6 +15,8 @@
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
 #include <linux/delay.h>
+
+#include <asm/page.h>
 #include "../rio.h"
 
 #define LOCAL_RTE_CONF_DESTID_SEL	0x010070
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index f6adde4..3743ac9 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -3,7 +3,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 /*
@@ -23,6 +23,7 @@
  *            Christof Schmitt
  *            Martin Petermann
  *            Sven Schuetz
+ *            Steffen Maier
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -415,6 +416,8 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct
ccw_device *ccw_device) adapter->dma_parms.max_segment_size =
ZFCP_QDIO_SBALE_LEN; adapter->ccw_device->dev.dma_parms =
&adapter->dma_parms; 
+	adapter->stat_read_buf_num = FSF_STATUS_READS_RECOM;
+
 	if (!zfcp_scsi_adapter_register(adapter))
 		return adapter;
 
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 92d3df6..e36fc02 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -102,10 +102,13 @@ static void zfcp_erp_action_dismiss_port(struct
zfcp_port *port) 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&port->erp_action);
-	else
-		shost_for_each_device(sdev, port->adapter->scsi_host)
+	else {
+		spin_lock(port->adapter->scsi_host->host_lock);
+		__shost_for_each_device(sdev, port->adapter->scsi_host)
 			if (sdev_to_zfcp(sdev)->port == port)
 				zfcp_erp_action_dismiss_lun(sdev);
+		spin_unlock(port->adapter->scsi_host->host_lock);
+	}
 }
 
 static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter
*adapter) @@ -592,9 +595,11 @@ static void
_zfcp_erp_lun_reopen_all(struct zfcp_port *port, int clear, {
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock(port->adapter->scsi_host->host_lock);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			_zfcp_erp_lun_reopen(sdev, clear, id, 0);
+	spin_unlock(port->adapter->scsi_host->host_lock);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action
*act) @@ -1435,8 +1440,10 @@ void zfcp_erp_set_adapter_status(struct
zfcp_adapter *adapter, u32 mask) atomic_set_mask(common_mask,
&port->status); read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host)
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host)
 		atomic_set_mask(common_mask,
&sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1470,11 +1477,13 @@ void zfcp_erp_clear_adapter_status(struct
zfcp_adapter *adapter, u32 mask) }
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host) {
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host) {
 		atomic_clear_mask(common_mask,
&sdev_to_zfcp(sdev)->status); if (clear_counter)
 			atomic_set(&sdev_to_zfcp(sdev)->erp_counter,
0); }
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1488,16 +1497,19 @@ void zfcp_erp_set_port_status(struct zfcp_port
*port, u32 mask) {
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	unsigned long flags;
 
 	atomic_set_mask(mask, &port->status);
 
 	if (!common_mask)
 		return;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			atomic_set_mask(common_mask,
 					&sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock,
flags); }
 
 /**
@@ -1512,6 +1524,7 @@ void zfcp_erp_clear_port_status(struct zfcp_port
*port, u32 mask) struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
+	unsigned long flags;
 
 	atomic_clear_mask(mask, &port->status);
 
@@ -1521,13 +1534,15 @@ void zfcp_erp_clear_port_status(struct
zfcp_port *port, u32 mask) if (clear_counter)
 		atomic_set(&port->erp_counter, 0);
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port) {
 			atomic_clear_mask(common_mask,
 					  &sdev_to_zfcp(sdev)->status);
 			if (clear_counter)
 				atomic_set(&sdev_to_zfcp(sdev)->erp_counter,
0); }
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock,
flags); }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 48f875f..961e327 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -483,12 +483,8 @@ static int
zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req) 
 	fc_host_port_name(shost) = nsp->fl_wwpn;
 	fc_host_node_name(shost) = nsp->fl_wwnn;
-	fc_host_port_id(shost) = ntoh24(bottom->s_id);
-	fc_host_speed(shost) =
-		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 |
FC_COS_CLASS3; 
-	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval &
ZFCP_FSF_TIMER_INT_MASK; adapter->stat_read_buf_num =
max(bottom->status_read_buf_num, (u16)FSF_STATUS_READS_RECOM);
@@ -496,6 +492,19 @@ static int
zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req) if
(fc_host_permanent_port_name(shost) == -1)
fc_host_permanent_port_name(shost) = fc_host_port_name(shost); 
+	zfcp_scsi_set_prot(adapter);
+
+	/* no error return above here, otherwise must fix call chains
*/
+	/* do not evaluate invalid fields */
+	if (req->qtcb->header.fsf_status ==
FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE)
+		return 0;
+
+	fc_host_port_id(shost) = ntoh24(bottom->s_id);
+	fc_host_speed(shost) =
+		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
+
+	adapter->hydra_version = bottom->adapter_type;
+
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
 		adapter->peer_d_id = ntoh24(bottom->peer_d_id);
@@ -517,8 +526,6 @@ static int zfcp_fsf_exchange_config_evaluate(struct
zfcp_fsf_req *req) return -EIO;
 	}
 
-	zfcp_scsi_set_prot(adapter);
-
 	return 0;
 }
 
@@ -563,8 +570,14 @@ static void
zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN; adapter->hydra_version
= 0; 
+		/* avoids adapter shutdown to be able to recognize
+		 * events such as LINK UP */
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
+		if (zfcp_fsf_exchange_config_evaluate(req))
+			return;
 		break;
 	default:
 		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh3");
diff --git a/drivers/s390/scsi/zfcp_qdio.c
b/drivers/s390/scsi/zfcp_qdio.c index 50b5615..925fb1f 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -224,11 +224,9 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_qdio
*qdio, struct zfcp_qdio_req *q_req, 
 static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
 {
-	spin_lock_irq(&qdio->req_q_lock);
 	if (atomic_read(&qdio->req_q_free) ||
 	    !(atomic_read(&qdio->adapter->status) &
ZFCP_STATUS_ADAPTER_QDIOUP)) return 1;
-	spin_unlock_irq(&qdio->req_q_lock);
 	return 0;
 }
 
@@ -246,9 +244,8 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 {
 	long ret;
 
-	spin_unlock_irq(&qdio->req_q_lock);
-	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
-			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
+	ret = wait_event_interruptible_lock_irq_timeout(qdio->req_q_wq,
+		       zfcp_qdio_sbal_check(qdio), qdio->req_q_lock, 5
* HZ); 
 	if (!(atomic_read(&qdio->adapter->status) &
ZFCP_STATUS_ADAPTER_QDIOUP)) return -EIO;
@@ -262,7 +259,6 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1");
 	}
 
-	spin_lock_irq(&qdio->req_q_lock);
 	return -EIO;
 }
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c
b/drivers/s390/scsi/zfcp_scsi.c index 7b31e3f..7b35364 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -3,7 +3,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -311,8 +311,12 @@ static struct scsi_host_template
zfcp_scsi_host_template = { .proc_name		 = "zfcp",
 	.can_queue		 = 4096,
 	.this_id		 = -1,
-	.sg_tablesize		 = 1, /* adjusted later */
-	.max_sectors		 = 8, /* adjusted later */
+	.sg_tablesize		 =
(((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) -
2),
+				   /* GCD, adjusted later */
+	.max_sectors		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER
- 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) -
2) * 8,
+				   /* GCD, adjusted later */
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 	.cmd_per_lun		 = 1,
 	.use_clustering		 = 1,
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..e34418f 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -93,6 +93,9 @@ static irqreturn_t aac_src_intr_message(int irq, void
*dev_id) int send_it = 0;
 			extern int aac_sync_mode;
 
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+
 			if (!aac_sync_mode) {
 				src_writel(dev, MUnit.ODR_C, bellbits);
 				src_readl(dev, MUnit.ODR_C);
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 6bc74eb..efd9e9e 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -491,6 +491,7 @@ int isci_task_abort_task(struct sas_task *task)
 	struct isci_tmf           tmf;
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
+	int                       target_done_already = 0;
 
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -505,9 +506,11 @@ int isci_task_abort_task(struct sas_task *task)
 	/* If task is already done, the request isn't valid */
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE) &&
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
-	    old_request)
+	    old_request) {
 		idev = isci_get_device(task->dev->lldd_dev);
-
+		target_done_already = test_bit(IREQ_COMPLETE_IN_TARGET,
+					       &old_request->flags);
+	}
 	spin_unlock(&task->task_state_lock);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
@@ -561,7 +564,7 @@ int isci_task_abort_task(struct sas_task *task)
 
 	if (task->task_proto == SAS_PROTOCOL_SMP ||
 	    sas_protocol_ata(task->task_proto) ||
-	    test_bit(IREQ_COMPLETE_IN_TARGET, &old_request->flags) ||
+	    target_done_already ||
 	    test_bit(IDEV_GONE, &idev->flags)) {
 
 		spin_unlock_irqrestore(&ihost->scic_lock, flags);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
b/drivers/scsi/megaraid/megaraid_sas_base.c index ed38454..7593e28
100644 --- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3493,11 +3493,21 @@ static int megasas_init_fw(struct
megasas_instance *instance) break;
 	}
 
-	/*
-	 * We expect the FW state to be READY
-	 */
-	if (megasas_transition_to_ready(instance, 0))
-		goto fail_ready_state;
+	if (megasas_transition_to_ready(instance, 0)) {
+		atomic_set(&instance->fw_reset_no_pci_access, 1);
+		instance->instancet->adp_reset
+			(instance, instance->reg_set);
+		atomic_set(&instance->fw_reset_no_pci_access, 0);
+		dev_info(&instance->pdev->dev,
+			"megasas: FW restarted successfully from
%s!\n",
+			__func__);
+
+		/*waitting for about 30 second before retry*/
+		ssleep(30);
+
+		if (megasas_transition_to_ready(instance, 0))
+			goto fail_ready_state;
+	}
 
 	/* Check if MSI-X is supported while in ready state */
 	msix_enable =
(instance->instancet->read_fw_status_reg(reg_set) & @@ -4817,10
+4827,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
sense, sense_handle); }
 
-	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		dma_free_coherent(&instance->pdev->dev,
-				    kern_sge32[i].length,
-				    kbuff_arr[i],
kern_sge32[i].phys_addr);
+	for (i = 0; i < ioc->sge_count; i++) {
+		if (kbuff_arr[i])
+			dma_free_coherent(&instance->pdev->dev,
+					  kern_sge32[i].length,
+					  kbuff_arr[i],
+					  kern_sge32[i].phys_addr);
 	}
 
 	megasas_return_cmd(instance, cmd);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
b/drivers/scsi/mpt2sas/mpt2sas_scsih.c index b1ebd6f..8718f10 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3995,11 +3995,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void
(*done)(struct scsi_cmnd *)) else
 				mpi_control |=
MPI2_SCSIIO_CONTROL_SIMPLEQ; } else
-/* MPI Revision I (UNIT = 0xA) - removed MPI2_SCSIIO_CONTROL_UNTAGGED
*/ -/*			mpi_control |=
MPI2_SCSIIO_CONTROL_UNTAGGED;
- */
-			mpi_control |= (0x500);
-
+			mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 	} else
 		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 	/* Make sure Device is not raid volume.
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 62b6168..e705ed3 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2926,7 +2926,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data
*data)
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	mdelay(RESET_HOLD_TIME / 1000);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read
*/ diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
b/drivers/scsi/qla2xxx/qla_iocb.c index 70dbf53..f2254d2 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -424,6 +424,8 @@ qla2x00_start_scsi(srb_t *sp)
 			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
 			break;
 		}
+	} else {
+		cmd_pkt->control_flags =
__constant_cpu_to_le16(CF_SIMPLE_TAG); }
 
 	/* Load SCSI command packet. */
@@ -1353,11 +1355,11 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp,
struct cmd_type_crc_2 *cmd_pkt, fcp_cmnd->task_attribute = TSK_ORDERED;
 		    break;
 		default:
-		    fcp_cmnd->task_attribute = 0;
+		    fcp_cmnd->task_attribute = TSK_SIMPLE;
 		    break;
 		}
 	} else {
-		fcp_cmnd->task_attribute = 0;
+		fcp_cmnd->task_attribute = TSK_SIMPLE;
 	}
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status
iocb */ @@ -1563,7 +1565,12 @@ qla24xx_start_scsi(srb_t *sp)
 		case ORDERED_QUEUE_TAG:
 			cmd_pkt->task = TSK_ORDERED;
 			break;
+		default:
+		    cmd_pkt->task = TSK_SIMPLE;
+		    break;
 		}
+	} else {
+		cmd_pkt->task = TSK_SIMPLE;
 	}
 
 	/* Load SCSI command packet. */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..5dba497 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1030,6 +1030,9 @@ int scsi_get_vpd_page(struct scsi_device *sdev,
u8 page, unsigned char *buf, {
 	int i, result;
 
+	if (sdev->skip_vpd_pages)
+		goto fail;
+
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a2ecd324..e157a93 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -673,10 +673,17 @@ static int scsi_setup_flush_cmnd(struct
scsi_device *sdp, struct request *rq) 
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
+	struct scsi_cmnd *SCpnt = rq->special;
+
 	if (rq->cmd_flags & REQ_DISCARD) {
 		free_page((unsigned long)rq->buffer);
 		rq->buffer = NULL;
 	}
+	if (SCpnt->cmnd != rq->cmd) {
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+		SCpnt->cmd_len = 0;
+	}
 }
 
 /**
@@ -1540,21 +1547,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ &&
scsi_prot_sg_count(SCpnt)) sd_dif_complete(SCpnt, good_bytes);
 
-	if (scsi_host_dif_capable(sdkp->device->host,
sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd !=
SCpnt->request->cmd) { -
-		/* We have to print a failed command here as the
-		 * extended CDB gets freed before scsi_io_completion()
-		 * is called.
-		 */
-		if (result)
-			scsi_print_command(SCpnt);
-
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
-
 	return good_bytes;
 }
 
diff --git a/drivers/staging/android/logger.c
b/drivers/staging/android/logger.c index f7b8237d5..e5b797c 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -359,7 +359,7 @@ static ssize_t logger_aio_write(struct kiocb *iocb,
const struct iovec *iov, unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-	size_t orig = log->w_off;
+	size_t orig;
 	struct logger_entry header;
 	struct timespec now;
 	ssize_t ret = 0;
@@ -378,6 +378,8 @@ static ssize_t logger_aio_write(struct kiocb *iocb,
const struct iovec *iov, 
 	mutex_lock(&log->mutex);
 
+	orig = log->w_off;
+
 	/*
 	 * Fix up any readers, pulling them forward to the first
readable
 	 * entry after (what will be) the new write offset. We do this
now diff --git a/drivers/staging/comedi/comedi_fops.c
b/drivers/staging/comedi/comedi_fops.c index 41dea18..d29b050 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1470,6 +1470,7 @@ static int do_cancel_ioctl(struct comedi_device
*dev, unsigned int arg, void *file)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
@@ -1486,7 +1487,11 @@ static int do_cancel_ioctl(struct comedi_device
*dev, unsigned int arg, if (s->busy != file)
 		return -EBUSY;
 
-	return do_cancel(dev, s);
+	ret = do_cancel(dev, s);
+	if (comedi_get_subdevice_runflags(s) & SRF_USER)
+		wake_up_interruptible(&s->async->wait_head);
+
+	return ret;
 }
 
 /*
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 5e319e3..01f00fd 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -378,8 +378,11 @@ static int snd_line6_pcm_free(struct snd_device
*device) */
 static void pcm_disconnect_substream(struct snd_pcm_substream
*substream) {
-	if (substream->runtime && snd_pcm_running(substream))
+	if (substream->runtime && snd_pcm_running(substream)) {
+		snd_pcm_stream_lock_irq(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
+		snd_pcm_stream_unlock_irq(substream);
+	}
 }
 
 /*
diff --git a/drivers/staging/zram/zram_drv.c
b/drivers/staging/zram/zram_drv.c index 6edefde..b9b3342 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -327,8 +327,6 @@ static int zram_bvec_write(struct zram *zram,
struct bio_vec *bvec, u32 index, 
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
 		zram_stat_inc(&zram->stats.pages_zero);
 		zram_set_flag(zram, index, ZRAM_ZERO);
 		ret = 0;
@@ -468,13 +466,20 @@ out:
  */
 static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
-	if (unlikely(
-		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
-		(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1))
||
-		(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
+	u64 start, end, bound;
 
+	/* unaligned request */
+	if (unlikely(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK -
1)))
+		return 0;
+	if (unlikely(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
+		return 0;
+
+	start = bio->bi_sector;
+	end = start + (bio->bi_size >> SECTOR_SHIFT);
+	bound = zram->disksize >> SECTOR_SHIFT;
+	/* out of range range */
+	if (unlikely(start >= bound || end > bound || start > end))
 		return 0;
-	}
 
 	/* I/O request is valid */
 	return 1;
@@ -622,7 +627,9 @@ static void zram_slot_free_notify(struct
block_device *bdev, struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
+	down_write(&zram->lock);
 	zram_free_page(zram, index);
+	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
@@ -633,7 +640,7 @@ static const struct block_device_operations
zram_devops = { 
 static int create_device(struct zram *zram, int device_id)
 {
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
@@ -643,7 +650,6 @@ static int create_device(struct zram *zram, int
device_id) if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -653,11 +659,9 @@ static int create_device(struct zram *zram, int
device_id) /* gendisk structure */
 	zram->disk = alloc_disk(1);
 	if (!zram->disk) {
-		blk_cleanup_queue(zram->queue);
 		pr_warn("Error allocating disk structure for device
%d\n", device_id);
-		ret = -ENOMEM;
-		goto out;
+		goto out_free_queue;
 	}
 
 	zram->disk->major = zram_major;
@@ -686,11 +690,17 @@ static int create_device(struct zram *zram, int
device_id) &zram_disk_attr_group);
 	if (ret < 0) {
 		pr_warn("Error creating sysfs group");
-		goto out;
+		goto out_free_disk;
 	}
 
 	zram->init_done = 0;
+	return 0;
 
+out_free_disk:
+	del_gendisk(zram->disk);
+	put_disk(zram->disk);
+out_free_queue:
+	blk_cleanup_queue(zram->queue);
 out:
 	return ret;
 }
@@ -771,9 +781,11 @@ static void __exit zram_exit(void)
 	for (i = 0; i < num_devices; i++) {
 		zram = &zram_devices[i];
 
+		get_disk(zram->disk);
 		destroy_device(zram);
 		if (zram->init_done)
 			zram_reset_device(zram);
+		put_disk(zram->disk);
 	}
 
 	unregister_blkdev(zram_major, "zram");
diff --git a/drivers/staging/zram/zram_drv.h
b/drivers/staging/zram/zram_drv.h index 572c0b1..a6eb5d9 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -92,8 +92,9 @@ struct zram {
 	void *compress_buffer;
 	struct table *table;
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
-	struct rw_semaphore lock; /* protect compression buffers and
table
-				   * against concurrent read and
writes */
+	struct rw_semaphore lock; /* protect compression buffers,
table,
+				   * 32bit stat counters against
concurrent
+				   * notifications, reads and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
diff --git a/drivers/staging/zram/zram_sysfs.c
b/drivers/staging/zram/zram_sysfs.c index edb0ed4..5e07628 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -186,8 +186,10 @@ static ssize_t mem_used_total_show(struct device
*dev, u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
 
+	down_read(&zram->init_lock);
 	if (zram->init_done)
 		val = zs_get_total_size_bytes(zram->mem_pool);
+	up_read(&zram->init_lock);
 
 	return sprintf(buf, "%llu\n", val);
 }
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c
b/drivers/target/iscsi/iscsi_target_configfs.c index a7b25e7..73adddc
100644 --- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -393,7 +393,7 @@ static ssize_t
__iscsi_##prefix##_store_##name(				\ if
(!capable(CAP_SYS_ADMIN))					\
return -EPERM;						\ \
-	snprintf(auth->name, PAGE_SIZE, "%s",
page);			\
+	snprintf(auth->name, sizeof(auth->name), "%s",
page);		\ if (!strncmp("NULL", auth->name,
4))				\ auth->naf_flags &=
~flags;				\
else								\
diff --git a/drivers/target/target_core_spc.c
b/drivers/target/target_core_spc.c index 6fd434d..290041b 100644 ---
a/drivers/target/target_core_spc.c +++
b/drivers/target/target_core_spc.c @@ -100,9 +100,12 @@ static int
spc_emulate_inquiry_std(struct se_cmd *cmd, char *buf) 
 	buf[7] = 0x2; /* CmdQue=1 */
 
-	snprintf(&buf[8], 8, "LIO-ORG");
-	snprintf(&buf[16], 16, "%s", dev->se_sub_dev->t10_wwn.model);
-	snprintf(&buf[32], 4, "%s", dev->se_sub_dev->t10_wwn.revision);
+	memcpy(&buf[8], "LIO-ORG ", 8);
+	memset(&buf[16], 0x20, 16);
+	memcpy(&buf[16], dev->se_sub_dev->t10_wwn.model,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.model),
16));
+	memcpy(&buf[32], dev->se_sub_dev->t10_wwn.revision,
+	       min_t(size_t,
strlen(dev->se_sub_dev->t10_wwn.revision), 4)); buf[4] = 31; /* Set
additional length to 31 */ 
 	return 0;
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 59c135d..2c51419 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -341,8 +341,8 @@ void hvsilib_establish(struct hvsi_priv *pv)
 
 	pr_devel("HVSI@%x:   ... waiting handshake\n", pv->termno);
 
-	/* Try for up to 200s */
-	for (timeout = 0; timeout < 20; timeout++) {
+	/* Try for up to 400ms */
+	for (timeout = 0; timeout < 40; timeout++) {
 		if (pv->established)
 			goto established;
 		if (!hvsi_get_packet(pv))
diff --git a/drivers/tty/serial/mxs-auart.c
b/drivers/tty/serial/mxs-auart.c index 3a667ee..647609d 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -381,11 +381,18 @@ static void mxs_auart_settermios(struct uart_port
*u, 
 static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 {
-	u32 istatus, istat;
+	u32 istat;
 	struct mxs_auart_port *s = context;
 	u32 stat = readl(s->port.membase + AUART_STAT);
 
-	istatus = istat = readl(s->port.membase + AUART_INTR);
+	istat = readl(s->port.membase + AUART_INTR);
+
+	/* ack irq */
+	writel(istat & (AUART_INTR_RTIS
+		| AUART_INTR_TXIS
+		| AUART_INTR_RXIS
+		| AUART_INTR_CTSMIS),
+			s->port.membase + AUART_INTR_CLR);
 
 	if (istat & AUART_INTR_CTSMIS) {
 		uart_handle_cts_change(&s->port, stat &
AUART_STAT_CTS); @@ -404,12 +411,6 @@ static irqreturn_t
mxs_auart_irq_handle(int irq, void *context) istat &= ~AUART_INTR_TXIS;
 	}
 
-	writel(istatus & (AUART_INTR_RTIS
-		| AUART_INTR_TXIS
-		| AUART_INTR_RXIS
-		| AUART_INTR_CTSMIS),
-			s->port.membase + AUART_INTR_CLR);
-
 	return IRQ_HANDLED;
 }
 
@@ -549,7 +550,7 @@ auart_console_write(struct console *co, const char
*str, unsigned int count) struct mxs_auart_port *s;
 	struct uart_port *port;
 	unsigned int old_ctrl0, old_ctrl2;
-	unsigned int to = 1000;
+	unsigned int to = 20000;
 
 	if (co->index >	MXS_AUART_PORTS || co->index < 0)
 		return;
@@ -570,18 +571,23 @@ auart_console_write(struct console *co, const
char *str, unsigned int count) 
 	uart_console_write(port, str, count,
mxs_auart_console_putchar); 
-	/*
-	 * Finally, wait for transmitter to become empty
-	 * and restore the TCR
-	 */
+	/* Finally, wait for transmitter to become empty ... */
 	while (readl(port->membase + AUART_STAT) & AUART_STAT_BUSY) {
+		udelay(1);
 		if (!to--)
 			break;
-		udelay(1);
 	}
 
-	writel(old_ctrl0, port->membase + AUART_CTRL0);
-	writel(old_ctrl2, port->membase + AUART_CTRL2);
+	/*
+	 * ... and restore the TCR if we waited long enough for the
transmitter
+	 * to be idle. This might keep the transmitter enabled
although it is
+	 * unused, but that is better than to disable it while it is
still
+	 * transmitting.
+	 */
+	if (!(readl(port->membase + AUART_STAT) & AUART_STAT_BUSY)) {
+		writel(old_ctrl0, port->membase + AUART_CTRL0);
+		writel(old_ctrl2, port->membase + AUART_CTRL2);
+	}
 
 	clk_disable(s->clk);
 }
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index fe7faf0..74ae3a5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -711,6 +711,15 @@ resubmit:
 static inline int
 hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
 {
+	/* Need to clear both directions for control ep */
+	if (((devinfo >> 11) & USB_ENDPOINT_XFERTYPE_MASK) ==
+			USB_ENDPOINT_XFER_CONTROL) {
+		int status = usb_control_msg(hdev,
usb_sndctrlpipe(hdev, 0),
+				HUB_CLEAR_TT_BUFFER, USB_RT_PORT,
+				devinfo ^ 0x8000, tt, NULL, 0, 1000);
+		if (status)
+			return status;
+	}
 	return usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
 			       HUB_CLEAR_TT_BUFFER, USB_RT_PORT,
devinfo, tt, NULL, 0, 1000);
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 6af23f2..9ee154b 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -75,6 +75,12 @@ static const struct usb_device_id usb_quirk_list[] =
{ { USB_DEVICE(0x04d8, 0x000c), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* CarrolTouch 4000U */
+	{ USB_DEVICE(0x04e7, 0x0009), .driver_info =
USB_QUIRK_RESET_RESUME }, +
+	/* CarrolTouch 4500U */
+	{ USB_DEVICE(0x04e7, 0x0030), .driver_info =
USB_QUIRK_RESET_RESUME }, +
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 151eca8..06dffc8 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -728,8 +728,8 @@ struct dwc3 {
 
 struct dwc3_event_type {
 	u32	is_devspec:1;
-	u32	type:6;
-	u32	reserved8_31:25;
+	u32	type:7;
+	u32	reserved8_31:24;
 } __packed;
 
 #define DWC3_DEPEVT_XFERCOMPLETE	0x01
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8212dbb..234305a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1558,6 +1558,7 @@ err1:
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 
 err0:
+	dwc->gadget_driver = NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return ret;
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index c788022..20a6b75 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -830,6 +830,7 @@ static int ehci_hub_control (
 				/* resume signaling for 20 msec */
 				ehci->reset_done[wIndex] = jiffies
 						+ msecs_to_jiffies(20);
+				set_bit(wIndex, &ehci->resuming_ports);
 				/* check the port again */
 				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
 						ehci->reset_done[wIndex]);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index cd0fc48..aecfc58 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -93,7 +93,6 @@ static void xhci_pci_quirks(struct device *dev,
struct xhci_hcd *xhci) }
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 			pdev->device ==
PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
-		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps = 64;
 		xhci->quirks |= XHCI_SW_BW_CHECKING;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8848616..21a01ac 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -434,7 +434,7 @@ static void ring_doorbell_for_active_rings(struct
xhci_hcd *xhci, 
 	/* A ring has pending URBs if its TD list is not empty */
 	if (!(ep->ep_state & EP_HAS_STREAMS)) {
-		if (!(list_empty(&ep->ring->td_list)))
+		if (ep->ring && !(list_empty(&ep->ring->td_list)))
 			xhci_ring_ep_doorbell(xhci, slot_id, ep_index,
0); return;
 	}
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2c117ec..a37f20d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1152,9 +1152,6 @@ static int xhci_check_args(struct usb_hcd *hcd,
struct usb_device *udev, }
 
 	xhci = hcd_to_xhci(hcd);
-	if (xhci->xhc_state & XHCI_STATE_HALTED)
-		return -ENODEV;
-
 	if (check_virt_dev) {
 		if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
 			printk(KERN_DEBUG "xHCI %s called with
unaddressed " @@ -1170,6 +1167,9 @@ static int xhci_check_args(struct
usb_hcd *hcd, struct usb_device *udev, }
 	}
 
+	if (xhci->xhc_state & XHCI_STATE_HALTED)
+		return -ENODEV;
+
 	return 1;
 }
 
@@ -4654,6 +4654,13 @@ int xhci_gen_setup(struct usb_hcd *hcd,
xhci_get_quirks_t get_quirks) 
 	get_quirks(dev, xhci);
 
+	/* In xhci controllers which follow xhci 1.0 spec gives a
spurious
+	 * success event after a short transfer. This quirk will
ignore such
+	 * spurious event.
+	 */
+	if (xhci->hci_version > 0x96)
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
+
 	/* Make sure the HC is halted. */
 	retval = xhci_halt(xhci);
 	if (retval)
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c
b/drivers/usb/misc/sisusbvga/sisusb.c index dd573ab..7af163d 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3247,6 +3247,7 @@ static const struct usb_device_id sisusb_table[]
= { { USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
+	{ USB_DEVICE(0x0711, 0x0950) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 5ad932d..e257c51 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -60,6 +60,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A,
DP-L10 SIP/GSM Mobile */ { USB_DEVICE(0x0489, 0xE003) }, /* Pirelli
Broadband S.p.A, DP-L10 SIP/GSM Mobile */ { USB_DEVICE(0x0745,
0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
+	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch
M4100 series, M5300 series, M7100 series */ { USB_DEVICE(0x08e6,
0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC
Device */ { USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC
Bill/Voucher Acceptor */ @@ -123,6 +124,8 @@ static const struct
usb_device_id id_table[] = { { USB_DEVICE(0x10C4, 0x85F8) }, /*
Virtenio Preon32 */ { USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services
CAN-IF */ { USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB
Device */
+	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni
ZigBee USB Device */ { USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs
factory default */ { USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs
factory default */ { USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs
factory default */ @@ -153,6 +156,7 @@ static const struct
usb_device_id id_table[] = { { USB_DEVICE(0x17F4, 0xAAAA) }, /*
Wavesense Jazz blood glucose meter */ { USB_DEVICE(0x1843,
0x0200) }, /* Vaisala USB Instrument Cable */ { USB_DEVICE(0x18EF,
0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662
Cable */ { USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service
Cable */ { USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
diff --git a/drivers/usb/serial/ftdi_sio.c
b/drivers/usb/serial/ftdi_sio.c index 5c3e249..710302ea 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -741,9 +741,34 @@ static struct usb_device_id id_table_combined [] =
{ { USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info =
(kernel_ulong_t)&ftdi_NDI_device_quirk }, { USB_DEVICE(TELLDUS_VID,
TELLDUS_TELLSTICK_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_RTS01_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S03_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_59_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57A_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29A_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29F_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_62B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S01_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_63_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29C_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_81B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_82B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K5D_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K4Y_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K5G_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S05_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_60_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_61_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_62_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_63B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_64_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_65_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_92_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_92D_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_W5R_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_A5R_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_PW1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h
b/drivers/usb/serial/ftdi_sio_ids.h index 1e4bff5..b98e44a 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -808,11 +808,35 @@
 /*
  * RT Systems programming cables for various ham radios
  */
-#define RTSYSTEMS_VID			0x2100	/* Vendor
ID */ -#define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial
converter for VX-7 Radios using FT232RL */ -#define
RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable
*/ -#define RTSYSTEMS_RTS01_PID		0x9e57	/*
USB-RTS01 Radio Cable */ - +#define RTSYSTEMS_VID
0x2100	/* Vendor ID */ +#define RTSYSTEMS_USB_S03_PID
0x9001	/* RTS-03 USB to Serial Adapter */ +#define
RTSYSTEMS_USB_59_PID	0x9e50	/* USB-59 USB to 8 pin plug
*/ +#define RTSYSTEMS_USB_57A_PID	0x9e51	/* USB-57A USB
to 4pin 3.5mm plug */ +#define RTSYSTEMS_USB_57B_PID
0x9e52	/* USB-57B USB to extended 4pin 3.5mm plug */ +#define
RTSYSTEMS_USB_29A_PID	0x9e53	/* USB-29A USB to 3.5mm
stereo plug */ +#define RTSYSTEMS_USB_29B_PID	0x9e54	/*
USB-29B USB to 6 pin mini din */ +#define RTSYSTEMS_USB_29F_PID
0x9e55	/* USB-29F USB to 6 pin modular plug */ +#define
RTSYSTEMS_USB_62B_PID	0x9e56	/* USB-62B USB to 8 pin mini
din plug*/ +#define RTSYSTEMS_USB_S01_PID	0x9e57	/*
USB-RTS01 USB to 3.5 mm stereo plug*/ +#define
RTSYSTEMS_USB_63_PID	0x9e58	/* USB-63 USB to 9 pin
female*/ +#define RTSYSTEMS_USB_29C_PID	0x9e59	/* USB-29C
USB to 4 pin modular plug*/ +#define RTSYSTEMS_USB_81B_PID
0x9e5A	/* USB-81 USB to 8 pin mini din plug*/ +#define
RTSYSTEMS_USB_82B_PID	0x9e5B	/* USB-82 USB to 2.5 mm
stereo plug*/ +#define RTSYSTEMS_USB_K5D_PID	0x9e5C	/*
USB-K5D USB to 8 pin modular plug*/ +#define
RTSYSTEMS_USB_K4Y_PID	0x9e5D	/* USB-K4Y USB to 2.5/3.5 mm
plugs*/ +#define RTSYSTEMS_USB_K5G_PID	0x9e5E	/* USB-K5G
USB to 8 pin modular plug*/ +#define RTSYSTEMS_USB_S05_PID
0x9e5F	/* USB-RTS05 USB to 2.5 mm stereo plug*/ +#define
RTSYSTEMS_USB_60_PID	0x9e60	/* USB-60 USB to 6 pin din*/
+#define RTSYSTEMS_USB_61_PID	0x9e61	/* USB-61 USB to 6
pin mini din*/ +#define RTSYSTEMS_USB_62_PID	0x9e62	/*
USB-62 USB to 8 pin mini din*/ +#define RTSYSTEMS_USB_63B_PID
0x9e63	/* USB-63 USB to 9 pin female*/ +#define
RTSYSTEMS_USB_64_PID	0x9e64	/* USB-64 USB to 9 pin male*/
+#define RTSYSTEMS_USB_65_PID	0x9e65	/* USB-65 USB to 9
pin female null modem*/ +#define RTSYSTEMS_USB_92_PID
0x9e66	/* USB-92 USB to 12 pin plug*/ +#define
RTSYSTEMS_USB_92D_PID	0x9e67	/* USB-92D USB to 12 pin
plug data*/ +#define RTSYSTEMS_USB_W5R_PID	0x9e68	/*
USB-W5R USB to 8 pin modular plug*/ +#define
RTSYSTEMS_USB_A5R_PID	0x9e69	/* USB-A5R USB to 8 pin
modular plug*/ +#define RTSYSTEMS_USB_PW1_PID	0x9e6A	/*
USB-PW1 USB to 8 pin modular plug*/ /*
  * Physik Instrumente
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index caf85ab..c9e3455 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2389,7 +2389,7 @@ static int keyspan_startup(struct usb_serial
*serial) if (d_details == NULL) {
 		dev_err(&serial->dev->dev, "%s - unknown product id
%x\n", __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
-		return 1;
+		return -ENODEV;
 	}
 
 	/* Setup private data for serial driver */
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index b691404..3d3b53d 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -97,6 +97,7 @@ struct urbtracker {
 	struct list_head        urblist_entry;
 	struct kref             ref_count;
 	struct urb              *urb;
+	struct usb_ctrlrequest	*setup;
 };
 
 enum mos7715_pp_modes {
@@ -278,6 +279,7 @@ static void destroy_urbtracker(struct kref *kref)
 	struct mos7715_parport *mos_parport = urbtrack->mos_parport;
 
 	usb_free_urb(urbtrack->urb);
+	kfree(urbtrack->setup);
 	kfree(urbtrack);
 	kref_put(&mos_parport->ref_count, destroy_mos_parport);
 }
@@ -360,7 +362,6 @@ static int write_parport_reg_nonblock(struct
mos7715_parport *mos_parport, struct urbtracker *urbtrack;
 	int ret_val;
 	unsigned long flags;
-	struct usb_ctrlrequest setup;
 	struct usb_serial *serial = mos_parport->serial;
 	struct usb_device *usbdev = serial->dev;
 
@@ -378,14 +379,20 @@ static int write_parport_reg_nonblock(struct
mos7715_parport *mos_parport, kfree(urbtrack);
 		return -ENOMEM;
 	}
-	setup.bRequestType = (__u8)0x40;
-	setup.bRequest = (__u8)0x0e;
-	setup.wValue = get_reg_value(reg, dummy);
-	setup.wIndex = get_reg_index(reg);
-	setup.wLength = 0;
+	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup),
GFP_KERNEL);
+	if (!urbtrack->setup) {
+		usb_free_urb(urbtrack->urb);
+		kfree(urbtrack);
+		return -ENOMEM;
+	}
+	urbtrack->setup->bRequestType = (__u8)0x40;
+	urbtrack->setup->bRequest = (__u8)0x0e;
+	urbtrack->setup->wValue = get_reg_value(reg, dummy);
+	urbtrack->setup->wIndex = get_reg_index(reg);
+	urbtrack->setup->wLength = 0;
 	usb_fill_control_urb(urbtrack->urb, usbdev,
 			     usb_sndctrlpipe(usbdev, 0),
-			     (unsigned char *)&setup,
+			     (unsigned char *)urbtrack->setup,
 			     NULL, 0, async_complete, urbtrack);
 	kref_init(&urbtrack->ref_count);
 	INIT_LIST_HEAD(&urbtrack->urblist_entry);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 3193d25..dc46df5 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -187,7 +187,10 @@
 #define LED_ON_MS	500
 #define LED_OFF_MS	500
 
-static int device_type;
+enum mos7840_flag {
+	MOS7840_FLAG_CTRL_BUSY,
+	MOS7840_FLAG_LED_BUSY,
+};
 
 static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
@@ -244,9 +247,12 @@ struct moschip_port {
 
 	/* For device(s) with LED indicator */
 	bool has_led;
-	bool led_flag;
 	struct timer_list led_timer1;	/* Timer for LED on */
 	struct timer_list led_timer2;	/* Timer for LED off */
+	struct urb *led_urb;
+	struct usb_ctrlrequest *led_dr;
+
+	unsigned long flags;
 };
 
 static bool debug;
@@ -507,11 +513,11 @@ static void mos7840_control_callback(struct urb
*urb) /* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d", __func__,
 		    status);
-		return;
+		goto out;
 	default:
 		dbg("%s - nonzero urb status received: %d", __func__,
 		    status);
-		return;
+		goto out;
 	}
 
 	dbg("%s urb buffer size is %d", __func__, urb->actual_length);
@@ -524,6 +530,8 @@ static void mos7840_control_callback(struct urb
*urb) mos7840_handle_new_msr(mos7840_port, regval);
 	else if (mos7840_port->MsrLsr == 1)
 		mos7840_handle_new_lsr(mos7840_port, regval);
+out:
+	clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mos7840_port->flags);
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16
reg, @@ -534,6 +542,9 @@ static int mos7840_get_reg(struct moschip_port
*mcs, __u16 Wval, __u16 reg, unsigned char *buffer = mcs->ctrl_buf;
 	int ret;
 
+	if (test_and_set_bit_lock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags))
+		return -EBUSY;
+
 	dr->bRequestType = MCS_RD_RTYPE;
 	dr->bRequest = MCS_RDREQ;
 	dr->wValue = cpu_to_le16(Wval);	/* 0 */
@@ -545,6 +556,9 @@ static int mos7840_get_reg(struct moschip_port
*mcs, __u16 Wval, __u16 reg, mos7840_control_callback, mcs);
 	mcs->control_urb->transfer_buffer_length = 2;
 	ret = usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	if (ret)
+		clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags);
+
 	return ret;
 }
 
@@ -571,7 +585,7 @@ static void mos7840_set_led_async(struct
moschip_port *mcs, __u16 wval, __u16 reg)
 {
 	struct usb_device *dev = mcs->port->serial->dev;
-	struct usb_ctrlrequest *dr = mcs->dr;
+	struct usb_ctrlrequest *dr = mcs->led_dr;
 
 	dr->bRequestType = MCS_WR_RTYPE;
 	dr->bRequest = MCS_WRREQ;
@@ -579,10 +593,10 @@ static void mos7840_set_led_async(struct
moschip_port *mcs, __u16 wval, dr->wIndex = cpu_to_le16(reg);
 	dr->wLength = cpu_to_le16(0);
 
-	usb_fill_control_urb(mcs->control_urb, dev,
usb_sndctrlpipe(dev, 0),
+	usb_fill_control_urb(mcs->led_urb, dev, usb_sndctrlpipe(dev,
0), (unsigned char *)dr, NULL, 0, mos7840_set_led_callback, NULL);
 
-	usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	usb_submit_urb(mcs->led_urb, GFP_ATOMIC);
 }
 
 static void mos7840_set_led_sync(struct usb_serial_port *port, __u16
reg, @@ -608,7 +622,19 @@ static void mos7840_led_flag_off(unsigned
long arg) {
 	struct moschip_port *mcs = (struct moschip_port *) arg;
 
-	mcs->led_flag = false;
+	clear_bit_unlock(MOS7840_FLAG_LED_BUSY, &mcs->flags);
+}
+
+static void mos7840_led_activity(struct usb_serial_port *port)
+{
+	struct moschip_port *mos7840_port =
usb_get_serial_port_data(port); +
+	if (test_and_set_bit_lock(MOS7840_FLAG_LED_BUSY,
&mos7840_port->flags))
+		return;
+
+	mos7840_set_led_async(mos7840_port, 0x0301,
MODEM_CONTROL_REGISTER);
+	mod_timer(&mos7840_port->led_timer1,
+				jiffies + msecs_to_jiffies(LED_ON_MS));
 }
 
 /*****************************************************************************
@@ -818,14 +844,8 @@ static void mos7840_bulk_in_callback(struct urb
*urb) return;
 	}
 
-	/* Turn on LED */
-	if (mos7840_port->has_led && !mos7840_port->led_flag) {
-		mos7840_port->led_flag = true;
-		mos7840_set_led_async(mos7840_port, 0x0301,
-					MODEM_CONTROL_REGISTER);
-		mod_timer(&mos7840_port->led_timer1,
-				jiffies + msecs_to_jiffies(LED_ON_MS));
-	}
+	if (mos7840_port->has_led)
+		mos7840_led_activity(port);
 
 	mos7840_port->read_urb_busy = true;
 	retval = usb_submit_urb(mos7840_port->read_urb, GFP_ATOMIC);
@@ -879,18 +899,6 @@ static void mos7840_bulk_out_data_callback(struct
urb
*urb) /************************************************************************/ /*
D R I V E R  T T Y  I N T E R F A C E  F U N C T I O N S
*/ /************************************************************************/
-#ifdef MCSSerialProbe -static int mos7840_serial_probe(struct
usb_serial *serial,
-				const struct usb_device_id *id)
-{
-
-	/*need to implement the mode_reg reading and updating\
-	   structures usb_serial_ device_type\
-	   (i.e num_ports, num_bulkin,bulkout etc) */
-	/* Also we can update the changes  attach */
-	return 1;
-}
-#endif
 
 /*****************************************************************************
  * mos7840_open
@@ -972,20 +980,20 @@ static int mos7840_open(struct tty_struct *tty,
struct usb_serial_port *port) status = mos7840_get_reg_sync(port,
mos7840_port->SpRegOffset, &Data); if (status < 0) {
 		dbg("Reading Spreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset,
Data); if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 
 	Data &= ~0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset,
Data); if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 	/* End of block to be checked */
 
@@ -994,7 +1002,7 @@ static int mos7840_open(struct tty_struct *tty,
struct usb_serial_port *port) &Data);
 	if (status < 0) {
 		dbg("Reading Controlreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x08;		/* Driver done bit */
 	Data |= 0x20;		/* rx_disable */
@@ -1002,7 +1010,7 @@ static int mos7840_open(struct tty_struct *tty,
struct usb_serial_port *port) mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Controlreg failed");
-		return -1;
+		goto err;
 	}
 	/* do register settings here */
 	/* Set all regs to the device default values. */
@@ -1013,21 +1021,21 @@ static int mos7840_open(struct tty_struct *tty,
struct usb_serial_port *port) status = mos7840_set_uart_reg(port,
INTERRUPT_ENABLE_REGISTER, Data); if (status < 0) {
 		dbg("disabling interrupts failed");
-		return -1;
+		goto err;
 	}
 	/* Set FIFO_CONTROL_REGISTER to the default value */
 	Data = 0x00;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER,
Data); if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0xcf;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER,
Data); if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0x03;
@@ -1181,6 +1189,15 @@ static int mos7840_open(struct tty_struct *tty,
struct usb_serial_port *port) serial, mos7840_port, port);
 
 	return 0;
+err:
+	for (j = 0; j < NUM_URBS; ++j) {
+		urb = mos7840_port->write_urb_pool[j];
+		if (!urb)
+			continue;
+		kfree(urb->transfer_buffer);
+		usb_free_urb(urb);
+	}
+	return status;
 }
 
 /*****************************************************************************
@@ -1567,13 +1584,8 @@ static int mos7840_write(struct tty_struct *tty,
struct usb_serial_port *port, data1 = urb->transfer_buffer;
 	dbg("bulkout endpoint is %d", port->bulk_out_endpointAddress);
 
-	/* Turn on LED */
-	if (mos7840_port->has_led && !mos7840_port->led_flag) {
-		mos7840_port->led_flag = true;
-		mos7840_set_led_sync(port, MODEM_CONTROL_REGISTER,
0x0301);
-		mod_timer(&mos7840_port->led_timer1,
-				jiffies + msecs_to_jiffies(LED_ON_MS));
-	}
+	if (mos7840_port->has_led)
+		mos7840_led_activity(port);
 
 	/* send it down the pipe */
 	status = usb_submit_urb(urb, GFP_ATOMIC);
@@ -2392,38 +2404,48 @@ static int mos7810_check(struct usb_serial
*serial) return 0;
 }
 
-static int mos7840_calc_num_ports(struct usb_serial *serial)
+static int mos7840_probe(struct usb_serial *serial,
+				const struct usb_device_id *id)
 {
-	__u16 data = 0x00;
+	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
 	u8 *buf;
-	int mos7840_num_ports;
+	int device_type;
+
+	if (product == MOSCHIP_DEVICE_ID_7810 ||
+		product == MOSCHIP_DEVICE_ID_7820) {
+		device_type = product;
+		goto out;
+	}
 
 	buf = kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
-	if (buf) {
-		usb_control_msg(serial->dev,
usb_rcvctrlpipe(serial->dev, 0),
+	if (!buf)
+		return -ENOMEM;
+
+	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
 			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
-		data = *buf;
-		kfree(buf);
-	}
 
-	if (serial->dev->descriptor.idProduct ==
MOSCHIP_DEVICE_ID_7810 ||
-		serial->dev->descriptor.idProduct ==
MOSCHIP_DEVICE_ID_7820) {
-		device_type = serial->dev->descriptor.idProduct;
-	} else {
-		/* For a MCS7840 device GPIO0 must be set to 1 */
-		if ((data & 0x01) == 1)
-			device_type = MOSCHIP_DEVICE_ID_7840;
-		else if (mos7810_check(serial))
-			device_type = MOSCHIP_DEVICE_ID_7810;
-		else
-			device_type = MOSCHIP_DEVICE_ID_7820;
-	}
+	/* For a MCS7840 device GPIO0 must be set to 1 */
+	if (buf[0] & 0x01)
+		device_type = MOSCHIP_DEVICE_ID_7840;
+	else if (mos7810_check(serial))
+		device_type = MOSCHIP_DEVICE_ID_7810;
+	else
+		device_type = MOSCHIP_DEVICE_ID_7820;
+
+	kfree(buf);
+out:
+	usb_set_serial_data(serial, (void *)(unsigned
long)device_type); +
+	return 0;
+}
+
+static int mos7840_calc_num_ports(struct usb_serial *serial)
+{
+	int device_type = (unsigned long)usb_get_serial_data(serial);
+	int mos7840_num_ports;
 
 	mos7840_num_ports = (device_type >> 4) & 0x000F;
-	serial->num_bulk_in = mos7840_num_ports;
-	serial->num_bulk_out = mos7840_num_ports;
-	serial->num_ports = mos7840_num_ports;
 
 	return mos7840_num_ports;
 }
@@ -2431,6 +2453,7 @@ static int mos7840_calc_num_ports(struct
usb_serial *serial) static int mos7840_port_probe(struct
usb_serial_port *port) {
 	struct usb_serial *serial = port->serial;
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	struct moschip_port *mos7840_port;
 	int status;
 	int pnum;
@@ -2633,6 +2656,14 @@ static int mos7840_port_probe(struct
usb_serial_port *port) if (device_type == MOSCHIP_DEVICE_ID_7810) {
 			mos7840_port->has_led = true;
 
+			mos7840_port->led_urb = usb_alloc_urb(0,
GFP_KERNEL);
+			mos7840_port->led_dr =
kmalloc(sizeof(*mos7840_port->led_dr),
+
GFP_KERNEL);
+			if (!mos7840_port->led_urb
|| !mos7840_port->led_dr) {
+				status = -ENOMEM;
+				goto error;
+			}
+
 			init_timer(&mos7840_port->led_timer1);
 			mos7840_port->led_timer1.function =
mos7840_led_off; mos7840_port->led_timer1.expires =
@@ -2648,8 +2679,6 @@ static int mos7840_port_probe(struct
usb_serial_port *port) mos7840_port->led_timer2.data =
 						(unsigned
long)mos7840_port; 
-			mos7840_port->led_flag = false;
-
 			/* Turn off LED */
 			mos7840_set_led_sync(port,
 						MODEM_CONTROL_REGISTER,
0x0300); @@ -2675,6 +2704,8 @@ static int mos7840_port_probe(struct
usb_serial_port *port) }
 	return 0;
 error:
+	kfree(mos7840_port->led_dr);
+	usb_free_urb(mos7840_port->led_urb);
 	kfree(mos7840_port->dr);
 	kfree(mos7840_port->ctrl_buf);
 	usb_free_urb(mos7840_port->control_urb);
@@ -2695,6 +2726,10 @@ static int mos7840_port_remove(struct
usb_serial_port *port) 
 		del_timer_sync(&mos7840_port->led_timer1);
 		del_timer_sync(&mos7840_port->led_timer2);
+
+		usb_kill_urb(mos7840_port->led_urb);
+		usb_free_urb(mos7840_port->led_urb);
+		kfree(mos7840_port->led_dr);
 	}
 	usb_kill_urb(mos7840_port->control_urb);
 	usb_free_urb(mos7840_port->control_urb);
@@ -2721,9 +2756,7 @@ static struct usb_serial_driver
moschip7840_4port_device = { .throttle = mos7840_throttle,
 	.unthrottle = mos7840_unthrottle,
 	.calc_num_ports = mos7840_calc_num_ports,
-#ifdef MCSSerialProbe
-	.probe = mos7840_serial_probe,
-#endif
+	.probe = mos7840_probe,
 	.ioctl = mos7840_ioctl,
 	.set_termios = mos7840_set_termios,
 	.break_ctl = mos7840_break,
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 27adfce..d53681f 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -348,17 +348,12 @@ static void option_instat_callback(struct urb
*urb); #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
+#define OLIVETTI_PRODUCT_OLICARD200		0xc005
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
 #define CELOT_PRODUCT_CT680M			0x6801
 
-/* ONDA Communication vendor id */
-#define ONDA_VENDOR_ID       0x1ee8
-
-/* ONDA MT825UP HSDPA 14.2 modem */
-#define ONDA_MT825UP         0x000b
-
 /* Samsung products */
 #define SAMSUNG_VENDOR_ID                       0x04e8
 #define SAMSUNG_PRODUCT_GT_B3730                0x6889
@@ -805,7 +800,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0017, 0xff,
0xff, 0xff), .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0018, 0xff,
0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff,
0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0019, 0xff,
0xff, 0xff),
+		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0020, 0xff,
0xff, 0xff) }, { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0021,
0xff, 0xff, 0xff), .driver_info =
(kernel_ulong_t)&net_intf4_blacklist }, @@ -1240,8 +1236,8 @@ static
const struct usb_device_id option_ids[] = { 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID,
OLIVETTI_PRODUCT_OLICARD100) }, { USB_DEVICE(OLIVETTI_VENDOR_ID,
OLIVETTI_PRODUCT_OLICARD145) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID,
OLIVETTI_PRODUCT_OLICARD200) }, { USB_DEVICE(CELOT_VENDOR_ID,
CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
-	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP
modem */ { USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID,
SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung
GT-B3730 LTE USB modem.*/ { USB_DEVICE(YUGA_VENDOR_ID,
YUGA_PRODUCT_CEM600) }, { USB_DEVICE(YUGA_VENDOR_ID,
YUGA_PRODUCT_CEM610) }, @@ -1315,6 +1311,8 @@ static const struct
usb_device_id option_ids[] = { { USB_DEVICE_AND_INTERFACE_INFO(0x2001,
0x7d02, 0xff, 0x00, 0x00) }, { USB_DEVICE_AND_INTERFACE_INFO(0x2001,
0x7d03, 0xff, 0x02, 0x01) }, { USB_DEVICE_AND_INTERFACE_INFO(0x2001,
0x7d03, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff,
0xff) }, /* D-Link DWM-152/C1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff,
0xff) }, /* D-Link DWM-156/C1 */ { } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c
b/drivers/usb/serial/ti_usb_3410_5052.c index c7550bf..33e3cb9 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -383,7 +383,7 @@ static int ti_startup(struct usb_serial *serial)
 	usb_set_serial_data(serial, tdev);
 
 	/* determine device type */
-	if (usb_match_id(serial->interface, ti_id_table_3410))
+	if (serial->type == &ti_1port_device)
 		tdev->td_is_3410 = 1;
 	dbg("%s - device type is %s", __func__,
 				tdev->td_is_3410 ? "3410" : "5052");
@@ -1639,14 +1639,15 @@ static int ti_download_firmware(struct
ti_device *tdev) char buf[32];
 
 	/* try ID specific firmware first, then try generic firmware */
-	sprintf(buf, "ti_usb-v%04x-p%04x.fw", dev->descriptor.idVendor,
-	    dev->descriptor.idProduct);
+	sprintf(buf, "ti_usb-v%04x-p%04x.fw",
+			le16_to_cpu(dev->descriptor.idVendor),
+			le16_to_cpu(dev->descriptor.idProduct));
 	status = request_firmware(&fw_p, buf, &dev->dev);
 
 	if (status != 0) {
 		buf[0] = '\0';
-		if (dev->descriptor.idVendor == MTS_VENDOR_ID) {
-			switch (dev->descriptor.idProduct) {
+		if (le16_to_cpu(dev->descriptor.idVendor) ==
MTS_VENDOR_ID) {
+			switch
(le16_to_cpu(dev->descriptor.idProduct)) { case MTS_CDMA_PRODUCT_ID:
 				strcpy(buf, "mts_cdma.fw");
 				break;
diff --git a/drivers/usb/serial/usb_wwan.c
b/drivers/usb/serial/usb_wwan.c index 188b5b3..5e9e1df 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -299,18 +299,18 @@ static void usb_wwan_indat_callback(struct urb
*urb) tty_kref_put(tty);
 		}
 
-		/* Resubmit urb so we continue receiving */
-		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err) {
-			if (err != -EPERM) {
-				printk(KERN_ERR "%s: resubmit read urb
failed. "
-					"(%d)", __func__, err);
-				/* busy also in error unless we are
killed */
-				usb_mark_last_busy(port->serial->dev);
-			}
-		} else {
+	}
+	/* Resubmit urb so we continue receiving */
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err) {
+		if (err != -EPERM) {
+			printk(KERN_ERR "%s: resubmit read urb failed.
(%d)\n",
+				__func__, err);
+			/* busy also in error unless we are killed */
 			usb_mark_last_busy(port->serial->dev);
 		}
+	} else {
+		usb_mark_last_busy(port->serial->dev);
 	}
 }
 
diff --git a/drivers/usb/storage/unusual_devs.h
b/drivers/usb/storage/unusual_devs.h index 3561322..a9e9a96 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -657,6 +657,13 @@ UNUSUAL_DEV(  0x054c, 0x016a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Submitted by Ren Bigcren <bigcren.ren@sonymobile.com> */
+UNUSUAL_DEV(  0x054c, 0x02a5, 0x0100, 0x0100,
+		"Sony Corp.",
+		"MicroVault Flash Drive",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_READ_CAPACITY_16 ),
+
 /* floppy reports multiple luns */
 UNUSUAL_DEV(  0x055d, 0x2020, 0x0000, 0x0210,
 		"SAMSUNG",
diff --git a/drivers/usb/wusbcore/wa-xfer.c
b/drivers/usb/wusbcore/wa-xfer.c index 57c01ab..1ebc17e 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -1110,6 +1110,12 @@ int wa_urb_dequeue(struct wahc *wa, struct urb
*urb) }
 	spin_lock_irqsave(&xfer->lock, flags);
 	rpipe = xfer->ep->hcpriv;
+	if (rpipe == NULL) {
+		pr_debug("%s: xfer id 0x%08X has no RPIPE.  %s",
+			__func__, wa_xfer_id(xfer),
+			"Probably already aborted.\n" );
+		goto out_unlock;
+	}
 	/* Check the delayed list -> if there, release and complete */
 	spin_lock_irqsave(&wa->xfer_list_lock, flags2);
 	if (!list_empty(&xfer->list_node) && xfer->seg == NULL)
@@ -1493,8 +1499,7 @@ static void wa_xfer_result_cb(struct urb *urb)
 			break;
 		}
 		usb_status = xfer_result->bTransferStatus & 0x3f;
-		if (usb_status == WA_XFER_STATUS_ABORTED
-		    || usb_status == WA_XFER_STATUS_NOT_FOUND)
+		if (usb_status == WA_XFER_STATUS_NOT_FOUND)
 			/* taken care of already */
 			break;
 		xfer_id = xfer_result->dwTransferID;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ef82a0d..c0492d7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1600,7 +1600,7 @@ void vhost_ubuf_put_and_wait(struct
vhost_ubuf_ref *ubufs) kfree(ubufs);
 }
 
-void vhost_zerocopy_callback(struct ubuf_info *ubuf)
+void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool status)
 {
 	struct vhost_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1125af3..2de4ce2 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -191,7 +191,7 @@ bool vhost_enable_notify(struct vhost_dev *, struct
vhost_virtqueue *); 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		    unsigned int log_num, u64 len);
-void vhost_zerocopy_callback(struct ubuf_info *);
+void vhost_zerocopy_callback(struct ubuf_info *, bool);
 int vhost_zerocopy_signal_used(struct vhost_virtqueue *vq);
 
 #define vq_err(vq, fmt, ...) do {                                  \
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..bdac497 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -491,16 +491,18 @@ EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
  * virtqueue_enable_cb - restart callbacks after disable_cb.
  * @vq: the struct virtqueue we're talking about.
  *
- * This re-enables callbacks; it returns "false" if there are pending
- * buffers in the queue, to detect a possible race between the driver
- * checking for more work, and enabling callbacks.
+ * This re-enables callbacks; it returns current queue state
+ * in an opaque unsigned value. This value should be later tested by
+ * virtqueue_poll, to detect a possible race between the driver
checking for
+ * more work, and enabling callbacks.
  *
  * Caller must ensure we don't call this with other virtqueue
  * operations at the same time (except where noted).
  */
-bool virtqueue_enable_cb(struct virtqueue *_vq)
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 last_used_idx;
 
 	START_USE(vq);
 
@@ -510,15 +512,45 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 	 * either clear the flags bit or point the event index at the
next
 	 * entry. Always do both to keep code simple. */
 	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
-	vring_used_event(&vq->vring) = vq->last_used_idx;
+	vring_used_event(&vq->vring) = last_used_idx =
vq->last_used_idx;
+	END_USE(vq);
+	return last_used_idx;
+}
+EXPORT_SYMBOL_GPL(virtqueue_enable_cb_prepare);
+
+/**
+ * virtqueue_poll - query pending used buffers
+ * @vq: the struct virtqueue we're talking about.
+ * @last_used_idx: virtqueue state (from call to
virtqueue_enable_cb_prepare).
+ *
+ * Returns "true" if there are pending used buffers in the queue.
+ *
+ * This does not need to be serialized.
+ */
+bool virtqueue_poll(struct virtqueue *_vq, unsigned last_used_idx)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
 	virtio_mb(vq);
-	if (unlikely(more_used(vq))) {
-		END_USE(vq);
-		return false;
-	}
+	return (u16)last_used_idx != vq->vring.used->idx;
+}
+EXPORT_SYMBOL_GPL(virtqueue_poll);
 
-	END_USE(vq);
-	return true;
+/**
+ * virtqueue_enable_cb - restart callbacks after disable_cb.
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * This re-enables callbacks; it returns "false" if there are pending
+ * buffers in the queue, to detect a possible race between the driver
+ * checking for more work, and enabling callbacks.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ */
+bool virtqueue_enable_cb(struct virtqueue *_vq)
+{
+	unsigned last_used_idx = virtqueue_enable_cb_prepare(_vq);
+	return !virtqueue_poll(_vq, last_used_idx);
 }
 EXPORT_SYMBOL_GPL(virtqueue_enable_cb);
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 99c5345..3987f6f 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -324,7 +324,7 @@ static void init_evtchn_cpu_bindings(void)
 
 	for_each_possible_cpu(i)
 		memset(per_cpu(cpu_evtchn_mask, i),
-		       (i == 0) ? ~0 : 0,
sizeof(*per_cpu(cpu_evtchn_mask, i)));
+		       (i == 0) ? ~0 : 0, NR_EVENT_CHANNELS/8);
 }
 
 static inline void clear_evtchn(int port)
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index b1f60a0..8eb68c9 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -367,18 +367,12 @@ static long evtchn_ioctl(struct file *file,
 		if (unbind.port >= NR_EVENT_CHANNELS)
 			break;
 
-		spin_lock_irq(&port_user_lock);
-
 		rc = -ENOTCONN;
-		if (get_port_user(unbind.port) != u) {
-			spin_unlock_irq(&port_user_lock);
+		if (get_port_user(unbind.port) != u)
 			break;
-		}
 
 		disable_irq(irq_from_evtchn(unbind.port));
 
-		spin_unlock_irq(&port_user_lock);
-
 		evtchn_unbind_from_user(u, unbind.port);
 
 		rc = 0;
@@ -478,26 +472,15 @@ static int evtchn_release(struct inode *inode,
struct file *filp) int i;
 	struct per_user_data *u = filp->private_data;
 
-	spin_lock_irq(&port_user_lock);
-
-	free_page((unsigned long)u->ring);
-
 	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
 		if (get_port_user(i) != u)
 			continue;
 
 		disable_irq(irq_from_evtchn(i));
-	}
-
-	spin_unlock_irq(&port_user_lock);
-
-	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
-		if (get_port_user(i) != u)
-			continue;
-
 		evtchn_unbind_from_user(get_port_user(i), i);
 	}
 
+	free_page((unsigned long)u->ring);
 	kfree(u->name);
 	kfree(u);
 
diff --git a/fs/bio.c b/fs/bio.c
index 71072ab..6e2a362 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -791,12 +791,22 @@ static int __bio_copy_iov(struct bio *bio, struct
bio_vec *iovecs, int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	int ret = 0;
+	struct bio_vec *bvec;
+	int ret = 0, i;
 
-	if (!bio_flagged(bio, BIO_NULL_MAPPED))
-		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, bio_data_dir(bio)
== READ,
-				     0, bmd->is_our_pages);
+	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
+		/*
+		 * if we're in a workqueue, the request is orphaned, so
+		 * don't copy into a random user address space, just
free.
+		 */
+		if (current->mm)
+			ret = __bio_copy_iov(bio, bmd->iovecs,
bmd->sgvecs,
+					     bmd->nr_sgvecs,
bio_data_dir(bio) == READ,
+					     0, bmd->is_our_pages);
+		else if (bmd->is_our_pages)
+			__bio_for_each_segment(bvec, bio, i, 0)
+				__free_page(bvec->bv_page);
+	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index daaca3d..41f6594 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -57,17 +57,24 @@ static void bdev_inode_switch_bdi(struct inode
*inode, struct backing_dev_info *dst)
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
+	bool wakeup_bdi = false;
 
 	if (unlikely(dst == old))		/* deadlock avoidance
*/ return;
 	bdi_lock_two(&old->wb, &dst->wb);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
-	if (inode->i_state & I_DIRTY)
+	if (inode->i_state & I_DIRTY) {
+		if (bdi_cap_writeback_dirty(dst)
&& !wb_has_dirty_io(&dst->wb))
+			wakeup_bdi = true;
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	}
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&old->wb.list_lock);
 	spin_unlock(&dst->wb.list_lock);
+
+	if (wakeup_bdi)
+		bdi_wakeup_thread_delayed(dst);
 }
 
 sector_t blkdev_max_block(struct block_device *bdev)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6d7b589..3b09565 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6950,6 +6950,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int err = 0;
 	int ret;
 	int level;
+	bool root_dropped = false;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -7007,6 +7008,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
 			btrfs_set_lock_blocking(path->nodes[level]);
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
@@ -7023,6 +7025,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				break;
 
 			btrfs_tree_unlock(path->nodes[level]);
+			path->locks[level] = 0;
 			WARN_ON(wc->refs[level] != 1);
 			level--;
 		}
@@ -7118,12 +7121,22 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		free_extent_buffer(root->commit_root);
 		kfree(root);
 	}
+	root_dropped = true;
 out_end_trans:
 	btrfs_end_transaction_throttle(trans, tree_root);
 out_free:
 	kfree(wc);
 	btrfs_free_path(path);
 out:
+	/*
+	 * So if we need to stop dropping the snapshot for whatever
reason we
+	 * need to make sure to add it back to the dead root list so
that we
+	 * keep trying to do the work later.  This also cleans up
roots if we
+	 * don't have it in the radix (like when we recover after a
power fail
+	 * or unmount) so we don't leak memory.
+	 */
+	if (root_dropped == false)
+		btrfs_add_dead_root(root);
 	if (err)
 		btrfs_std_error(root->fs_info, err);
 	return err;
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 9caf0c6..c6828ae 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -369,7 +369,7 @@ find_domain_name(struct cifs_ses *ses, const struct
nls_table *nls_cp) if (blobptr + attrsize > blobend)
 			break;
 		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
-			if (!attrsize)
+			if (!attrsize || attrsize >=
CIFS_MAX_DOMAINNAME_LEN) break;
 			if (!ses->domainName) {
 				ses->domainName =
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 977dc0e..4af59dc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -42,6 +42,7 @@
 #define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
 #define MAX_SERVER_SIZE 15
 #define MAX_SHARE_SIZE 80
+#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
 #define MAX_USERNAME_SIZE 256	/* reasonable maximum for current
servers */ #define MAX_PASSWORD_SIZE 512	/* max for windows
seems to be 256 wide chars */ 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 487db09..8239cba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1611,7 +1611,8 @@ cifs_parse_mount_options(const char *mountdata,
const char *devname, if (string == NULL)
 				goto out_nomem;
 
-			if (strnlen(string, 256) == 256) {
+			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
+					== CIFS_MAX_DOMAINNAME_LEN) {
 				printk(KERN_WARNING "CIFS: domain name
too" " long\n");
 				goto cifs_parse_mount_err;
@@ -2298,8 +2299,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 #ifdef CONFIG_KEYS
 
-/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
-#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
+/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
+#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
 
 /* Populate username and pw fields from keyring if possible */
 static int
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 382c06d..673db0b 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -198,7 +198,7 @@ static void unicode_domain_string(char **pbcc_area,
struct cifs_ses *ses, bytes_ret = 0;
 	} else
 		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr,
ses->domainName,
-					    256, nls_cp);
+					    CIFS_MAX_DOMAINNAME_LEN,
nls_cp); bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2;  /* account for null terminator */
 
@@ -256,8 +256,8 @@ static void ascii_ssetup_strings(char **pbcc_area,
struct cifs_ses *ses, 
 	/* copy domain */
 	if (ses->domainName != NULL) {
-		strncpy(bcc_ptr, ses->domainName, 256);
-		bcc_ptr += strnlen(ses->domainName, 256);
+		strncpy(bcc_ptr, ses->domainName,
CIFS_MAX_DOMAINNAME_LEN);
+		bcc_ptr += strnlen(ses->domainName,
CIFS_MAX_DOMAINNAME_LEN); } /* else we will send a null domain name
 	     so the server will default to its own domain */
 	*bcc_ptr = 0;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4733eab..327b802 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -524,8 +524,7 @@ EXPORT_SYMBOL_GPL(debugfs_remove);
  */
 void debugfs_remove_recursive(struct dentry *dentry)
 {
-	struct dentry *child;
-	struct dentry *parent;
+	struct dentry *child, *next, *parent;
 
 	if (IS_ERR_OR_NULL(dentry))
 		return;
@@ -535,61 +534,37 @@ void debugfs_remove_recursive(struct dentry
*dentry) return;
 
 	parent = dentry;
+ down:
 	mutex_lock(&parent->d_inode->i_mutex);
+	list_for_each_entry_safe(child, next, &parent->d_subdirs,
d_u.d_child) {
+		if (!debugfs_positive(child))
+			continue;
 
-	while (1) {
-		/*
-		 * When all dentries under "parent" has been removed,
-		 * walk up the tree until we reach our starting point.
-		 */
-		if (list_empty(&parent->d_subdirs)) {
-			mutex_unlock(&parent->d_inode->i_mutex);
-			if (parent == dentry)
-				break;
-			parent = parent->d_parent;
-			mutex_lock(&parent->d_inode->i_mutex);
-		}
-		child = list_entry(parent->d_subdirs.next, struct
dentry,
-				d_u.d_child);
- next_sibling:
-
-		/*
-		 * If "child" isn't empty, walk down the tree and
-		 * remove all its descendants first.
-		 */
+		/* perhaps simple_empty(child) makes more sense */
 		if (!list_empty(&child->d_subdirs)) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
-			mutex_lock(&parent->d_inode->i_mutex);
-			continue;
+			goto down;
 		}
-		__debugfs_remove(child, parent);
-		if (parent->d_subdirs.next == &child->d_u.d_child) {
-			/*
-			 * Try the next sibling.
-			 */
-			if (child->d_u.d_child.next !=
&parent->d_subdirs) {
-				child =
list_entry(child->d_u.d_child.next,
-						   struct dentry,
-						   d_u.d_child);
-				goto next_sibling;
-			}
-
-			/*
-			 * Avoid infinite loop if we fail to remove
-			 * one dentry.
-			 */
-			mutex_unlock(&parent->d_inode->i_mutex);
-			break;
-		}
-		simple_release_fs(&debugfs_mount,
&debugfs_mount_count);
+ up:
+		if (!__debugfs_remove(child, parent))
+			simple_release_fs(&debugfs_mount,
&debugfs_mount_count); }
 
-	parent = dentry->d_parent;
+	mutex_unlock(&parent->d_inode->i_mutex);
+	child = parent;
+	parent = parent->d_parent;
 	mutex_lock(&parent->d_inode->i_mutex);
-	__debugfs_remove(dentry, parent);
+
+	if (child != dentry) {
+		next = list_entry(child->d_u.d_child.next, struct
dentry,
+					d_u.d_child);
+		goto up;
+	}
+
+	if (!__debugfs_remove(child, parent))
+		simple_release_fs(&debugfs_mount,
&debugfs_mount_count); mutex_unlock(&parent->d_inode->i_mutex);
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index b4323ba..6d7abb1 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -109,10 +109,10 @@ int __ext4_handle_dirty_metadata(const char
*where, unsigned int line, 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
-		if (err) {
-			/* Errors can only happen if there is a bug */
-			handle->h_err = err;
-			__ext4_journal_stop(where, line, handle);
+		/* Errors can only happen if there is a bug */
+		if (WARN_ON_ONCE(err)) {
+			ext4_journal_abort_handle(where, line,
__func__, bh,
+						  handle, err);
 		}
 	} else {
 		if (inode)
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c690ff9..16481bd 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -706,11 +706,8 @@ repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
 					      inode_bitmap_bh->b_data,
 					      EXT4_INODES_PER_GROUP(sb),
ino);
-		if (ino >= EXT4_INODES_PER_GROUP(sb)) {
-			if (++group == ngroups)
-				group = 0;
-			continue;
-		}
+		if (ino >= EXT4_INODES_PER_GROUP(sb))
+			goto next_group;
 		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
 			ext4_error(sb, "reserved inode found cleared -
" "inode=%lu", ino + 1);
@@ -728,6 +725,9 @@ repeat_in_this_group:
 			goto got; /* we grabbed the inode! */
 		if (ino < EXT4_INODES_PER_GROUP(sb))
 			goto repeat_in_this_group;
+next_group:
+		if (++group == ngroups)
+			group = 0;
 	}
 	err = -ENOSPC;
 	goto out;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f9b129c..7099a33 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1422,7 +1422,7 @@ static const struct mount_opts {
 	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_SET},
 	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_CLEAR},
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC, MOPT_SET | MOPT_EXPLICIT},
-	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR |
MOPT_EXPLICIT},
+	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM, MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
 				    EXT4_MOUNT_JOURNAL_CHECKSUM),
MOPT_SET}, @@ -3405,7 +3405,7 @@ static int ext4_fill_super(struct
super_block *sb, void *data, int silent) }
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+				 "both data=journal and
dioread_nolock"); goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -4583,6 +4583,21 @@ static int ext4_remount(struct super_block *sb,
int *flags, char *data) goto restore_opts;
 	}
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "both data=journal and delalloc");
+			err = -EINVAL;
+			goto restore_opts;
+		}
+		if (test_opt(sb, DIOREAD_NOLOCK)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "both data=journal and
dioread_nolock");
+			err = -EINVAL;
+			goto restore_opts;
+		}
+	}
+
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, "Abort forced by user");
 
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 9197a1b..9f7c758 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3047,6 +3047,14 @@ int jfs_readdir(struct file *filp, void *dirent,
filldir_t filldir) 
 		dir_index = (u32) filp->f_pos;
 
+		/*
+		 * NFSv4 reserves cookies 1 and 2 for . and .. so the
value
+		 * we return to the vfs is one greater than the one we
use
+		 * internally.
+		 */
+		if (dir_index)
+			dir_index--;
+
 		if (dir_index > 1) {
 			struct dir_table_slot dirtab_slot;
 
@@ -3086,7 +3094,7 @@ int jfs_readdir(struct file *filp, void *dirent,
filldir_t filldir) if (p->header.flag & BT_INTERNAL) {
 				jfs_err("jfs_readdir: bad index
table"); DT_PUTPAGE(mp);
-				filp->f_pos = -1;
+				filp->f_pos = DIREND;
 				return 0;
 			}
 		} else {
@@ -3094,7 +3102,7 @@ int jfs_readdir(struct file *filp, void *dirent,
filldir_t filldir) /*
 				 * self "."
 				 */
-				filp->f_pos = 0;
+				filp->f_pos = 1;
 				if (filldir(dirent, ".", 1, 0,
ip->i_ino, DT_DIR))
 					return 0;
@@ -3102,7 +3110,7 @@ int jfs_readdir(struct file *filp, void *dirent,
filldir_t filldir) /*
 			 * parent ".."
 			 */
-			filp->f_pos = 1;
+			filp->f_pos = 2;
 			if (filldir(dirent, "..", 2, 1, PARENT(ip),
DT_DIR)) return 0;
 
@@ -3123,24 +3131,25 @@ int jfs_readdir(struct file *filp, void
*dirent, filldir_t filldir) /*
 		 * Legacy filesystem - OS/2 & Linux JFS < 0.3.6
 		 *
-		 * pn = index = 0:	First entry "."
-		 * pn = 0; index = 1:	Second entry ".."
+		 * pn = 0; index = 1:	First entry "."
+		 * pn = 0; index = 2:	Second entry ".."
 		 * pn > 0:		Real entries, pn=1 ->
leftmost page
 		 * pn = index = -1:	No more entries
 		 */
 		dtpos = filp->f_pos;
-		if (dtpos == 0) {
+		if (dtpos < 2) {
 			/* build "." entry */
 
+			filp->f_pos = 1;
 			if (filldir(dirent, ".", 1, filp->f_pos,
ip->i_ino, DT_DIR))
 				return 0;
-			dtoffset->index = 1;
+			dtoffset->index = 2;
 			filp->f_pos = dtpos;
 		}
 
 		if (dtoffset->pn == 0) {
-			if (dtoffset->index == 1) {
+			if (dtoffset->index == 2) {
 				/* build ".." entry */
 
 				if (filldir(dirent, "..", 2,
filp->f_pos, @@ -3233,6 +3242,12 @@ int jfs_readdir(struct file *filp,
void *dirent, filldir_t filldir) }
 					jfs_dirent->position =
unique_pos++; }
+				/*
+				 * We add 1 to the index because we may
+				 * use a value of 2 internally, and
NFSv4
+				 * doesn't like that.
+				 */
+				jfs_dirent->position++;
 			} else {
 				jfs_dirent->position = dtpos;
 				len = min(d_namleft,
DTLHDRDATALEN_LEGACY); diff --git a/fs/lockd/svclock.c
b/fs/lockd/svclock.c index 8d80c99..57a3922 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -939,6 +939,7 @@ nlmsvc_retry_blocked(void)
 	unsigned long	timeout = MAX_SCHEDULE_TIMEOUT;
 	struct nlm_block *block;
 
+	spin_lock(&nlm_blocked_lock);
 	while (!list_empty(&nlm_blocked) && !kthread_should_stop()) {
 		block = list_entry(nlm_blocked.next, struct nlm_block,
b_list); 
@@ -948,6 +949,7 @@ nlmsvc_retry_blocked(void)
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
 			block, block->b_when);
@@ -957,7 +959,9 @@ nlmsvc_retry_blocked(void)
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		spin_lock(&nlm_blocked_lock);
 	}
+	spin_unlock(&nlm_blocked_lock);
 
 	return timeout;
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a9269f1..1db47bc 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -802,9 +802,10 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh
*fhp, umode_t type, flags = O_WRONLY|O_LARGEFILE;
 	}
 	*filp = dentry_open(&path, flags, current_cred());
-	if (IS_ERR(*filp))
+	if (IS_ERR(*filp)) {
 		host_err = PTR_ERR(*filp);
-	else {
+		*filp = NULL;
+	} else {
 		host_err = ima_file_check(*filp, may_flags);
 
 		if (may_flags & NFSD_MAY_64BIT_COOKIE)
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc9a913..2d8be51 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -345,8 +345,7 @@ static void nilfs_end_bio_write(struct bio *bio,
int err) 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		bio_put(bio);
-		/* to be detected by submit_seg_bio() */
+		/* to be detected by nilfs_segbuf_submit_bio() */
 	}
 
 	if (!uptodate)
@@ -377,12 +376,12 @@ static int nilfs_segbuf_submit_bio(struct
nilfs_segment_buffer *segbuf, bio->bi_private = segbuf;
 	bio_get(bio);
 	submit_bio(mode, bio);
+	segbuf->sb_nbio++;
 	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
 		bio_put(bio);
 		err = -EOPNOTSUPP;
 		goto failed;
 	}
-	segbuf->sb_nbio++;
 	bio_put(bio);
 
 	wi->bio = NULL;
diff --git a/fs/notify/fanotify/fanotify_user.c
b/fs/notify/fanotify/fanotify_user.c index d438036..b670659 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -116,6 +116,7 @@ static int fill_event_metadata(struct
fsnotify_group *group, metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->metadata_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
+	metadata->reserved = 0;
 	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
 	if (unlikely(event->mask & FAN_Q_OVERFLOW))
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4540b8f..1868fe1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -693,14 +693,14 @@ typedef struct {
 } pagemap_entry_t;
 
 struct pagemapread {
-	int pos, len;
+	int pos, len;		/* units: PM_ENTRY_BYTES, not
bytes */ pagemap_entry_t *buffer;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
 
-#define PM_ENTRY_BYTES      sizeof(u64)
+#define PM_ENTRY_BYTES      sizeof(pagemap_entry_t)
 #define PM_STATUS_BITS      3
 #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
 #define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) <<
PM_STATUS_OFFSET) @@ -939,8 +939,8 @@ static ssize_t
pagemap_read(struct file *file, char __user *buf, if (!count)
 		goto out_task;
 
-	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
+	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
 		goto out_task;
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index e60e870..d700e3f 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -19,12 +19,13 @@
 /*
  * LOCKING:
  *
- * We rely on new Alexander Viro's super-block locking.
+ * These guys are evicted from procfs as the very first step in
->kill_sb(). *
  */
 
-static int show_version(struct seq_file *m, struct super_block *sb)
+static int show_version(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	char *format;
 
 	if (REISERFS_SB(sb)->s_properties & (1 << REISERFS_3_6)) {
@@ -66,8 +67,9 @@ static int show_version(struct seq_file *m, struct
super_block *sb) #define DJP( x ) le32_to_cpu( jp -> x )
 #define JF( x ) ( r -> s_journal -> x )
 
-static int show_super(struct seq_file *m, struct super_block *sb)
+static int show_super(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 
 	seq_printf(m, "state: \t%s\n"
@@ -128,8 +130,9 @@ static int show_super(struct seq_file *m, struct
super_block *sb) return 0;
 }
 
-static int show_per_level(struct seq_file *m, struct super_block *sb)
+static int show_per_level(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 	int level;
 
@@ -186,8 +189,9 @@ static int show_per_level(struct seq_file *m,
struct super_block *sb) return 0;
 }
 
-static int show_bitmap(struct seq_file *m, struct super_block *sb)
+static int show_bitmap(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 
 	seq_printf(m, "free_block: %lu\n"
@@ -218,8 +222,9 @@ static int show_bitmap(struct seq_file *m, struct
super_block *sb) return 0;
 }
 
-static int show_on_disk_super(struct seq_file *m, struct super_block
*sb) +static int show_on_disk_super(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *sb_info = REISERFS_SB(sb);
 	struct reiserfs_super_block *rs = sb_info->s_rs;
 	int hash_code = DFL(s_hash_function_code);
@@ -261,8 +266,9 @@ static int show_on_disk_super(struct seq_file *m,
struct super_block *sb) return 0;
 }
 
-static int show_oidmap(struct seq_file *m, struct super_block *sb)
+static int show_oidmap(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *sb_info = REISERFS_SB(sb);
 	struct reiserfs_super_block *rs = sb_info->s_rs;
 	unsigned int mapsize = le16_to_cpu(rs->s_v1.s_oid_cursize);
@@ -291,8 +297,9 @@ static int show_oidmap(struct seq_file *m, struct
super_block *sb) return 0;
 }
 
-static int show_journal(struct seq_file *m, struct super_block *sb)
+static int show_journal(struct seq_file *m, void *unused)
 {
+	struct super_block *sb = m->private;
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 	struct reiserfs_super_block *rs = r->s_rs;
 	struct journal_params *jp = &rs->s_v1.s_journal;
@@ -383,85 +390,24 @@ static int show_journal(struct seq_file *m,
struct super_block *sb) return 0;
 }
 
-/* iterator */
-static int test_sb(struct super_block *sb, void *data)
-{
-	return data == sb;
-}
-
-static int set_sb(struct super_block *sb, void *data)
-{
-	return -ENOENT;
-}
-
-static void *r_start(struct seq_file *m, loff_t * pos)
-{
-	struct proc_dir_entry *de = m->private;
-	struct super_block *s = de->parent->data;
-	loff_t l = *pos;
-
-	if (l)
-		return NULL;
-
-	if (IS_ERR(sget(&reiserfs_fs_type, test_sb, set_sb, 0, s)))
-		return NULL;
-
-	up_write(&s->s_umount);
-	return s;
-}
-
-static void *r_next(struct seq_file *m, void *v, loff_t * pos)
-{
-	++*pos;
-	if (v)
-		deactivate_super(v);
-	return NULL;
-}
-
-static void r_stop(struct seq_file *m, void *v)
-{
-	if (v)
-		deactivate_super(v);
-}
-
-static int r_show(struct seq_file *m, void *v)
-{
-	struct proc_dir_entry *de = m->private;
-	int (*show) (struct seq_file *, struct super_block *) =
de->data;
-	return show(m, v);
-}
-
-static const struct seq_operations r_ops = {
-	.start = r_start,
-	.next = r_next,
-	.stop = r_stop,
-	.show = r_show,
-};
-
 static int r_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open(file, &r_ops);
-
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = PDE(inode);
-	}
-	return ret;
+	return single_open(file, PDE(inode)->data,
+                           PDE(inode)->parent->data);
 }
 
 static const struct file_operations r_file_operations = {
 	.open = r_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = seq_release,
-	.owner = THIS_MODULE,
+	.release = single_release,
 };
 
 static struct proc_dir_entry *proc_info_root = NULL;
 static const char proc_info_root_name[] = "fs/reiserfs";
 
 static void add_file(struct super_block *sb, char *name,
-		     int (*func) (struct seq_file *, struct
super_block *))
+		     int (*func) (struct seq_file *, void *))
 {
 	proc_create_data(name, 0, REISERFS_SB(sb)->procdir,
 			 &r_file_operations, func);
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 4300030..cd4b149 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -499,6 +499,7 @@ int remove_save_link(struct inode *inode, int
truncate) static void reiserfs_kill_sb(struct super_block *s)
 {
 	if (REISERFS_SB(s)) {
+		reiserfs_proc_info_done(s);
 		/*
 		 * Force any pending inode evictions to occur now. Any
 		 * inodes to be removed that have extended attributes
@@ -554,8 +555,6 @@ static void reiserfs_put_super(struct super_block
*s) REISERFS_SB(s)->reserved_blocks);
 	}
 
-	reiserfs_proc_info_done(s);
-
 	reiserfs_write_unlock(s);
 	mutex_destroy(&REISERFS_SB(s)->lock);
 	kfree(s->s_fs_info);
diff --git a/fs/super.c b/fs/super.c
index 0902cfa..7b6e4e5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -349,19 +349,19 @@ EXPORT_SYMBOL(deactivate_super);
  *	and want to turn it into a full-blown active reference.
grab_super()
  *	is called with sb_lock held and drops it.  Returns 1 in case
of
  *	success, 0 if we had failed (superblock contents was already
dead or
- *	dying when grab_super() had been called).
+ *	dying when grab_super() had been called).  Note that this is
only
+ *	called for superblocks not in rundown mode (== ones still on
->fs_supers
+ *	of their type), so increment of ->s_count is OK here.
  */
 static int grab_super(struct super_block *s) __releases(sb_lock)
 {
-	if (atomic_inc_not_zero(&s->s_active)) {
-		spin_unlock(&sb_lock);
-		return 1;
-	}
-	/* it's going away */
 	s->s_count++;
 	spin_unlock(&sb_lock);
-	/* wait for it to die */
 	down_write(&s->s_umount);
+	if ((s->s_flags & MS_BORN) &&
atomic_inc_not_zero(&s->s_active)) {
+		put_super(s);
+		return 1;
+	}
 	up_write(&s->s_umount);
 	put_super(s);
 	return 0;
@@ -493,11 +493,6 @@ retry:
 				destroy_super(s);
 				s = NULL;
 			}
-			down_write(&old->s_umount);
-			if (unlikely(!(old->s_flags & MS_BORN))) {
-				deactivate_locked_super(old);
-				goto retry;
-			}
 			return old;
 		}
 	}
@@ -691,10 +686,10 @@ restart:
 		if (hlist_unhashed(&sb->s_instances))
 			continue;
 		if (sb->s_bdev == bdev) {
-			if (grab_super(sb)) /* drops sb_lock */
-				return sb;
-			else
+			if (!grab_super(sb))
 				goto restart;
+			up_write(&sb->s_umount);
+			return sb;
 		}
 	}
 	spin_unlock(&sb_lock);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index c03af76..20ae95b 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_BLOCK
 
 struct io_cq;
+struct elevator_type;
 
 typedef int (elevator_merge_fn) (struct request_queue *, struct
request **, struct bio *);
@@ -34,7 +35,8 @@ typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *,
struct request *); typedef void (elevator_deactivate_req_fn) (struct
request_queue *, struct request *); 
-typedef int (elevator_init_fn) (struct request_queue *);
+typedef int (elevator_init_fn) (struct request_queue *,
+				struct elevator_type *e);
 typedef void (elevator_exit_fn) (struct elevator_queue *);
 
 struct elevator_ops
@@ -151,6 +153,8 @@ extern int elevator_init(struct request_queue *,
char *); extern void elevator_exit(struct elevator_queue *);
 extern int elevator_change(struct request_queue *, const char *);
 extern bool elv_rq_merge_ok(struct request *, struct bio *);
+extern struct elevator_queue *elevator_alloc(struct request_queue *,
+					struct elevator_type *);
 
 /*
  * Helper functions.
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 642928c..86e6806 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -71,6 +71,8 @@ struct trace_iterator {
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
 
+	cpumask_var_t		started;
+
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
@@ -83,7 +85,7 @@ struct trace_iterator {
 	loff_t			pos;
 	long			idx;
 
-	cpumask_var_t		started;
+	/* All new field here will be zeroed out in pipe_read */
 };
 
 
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 9b0c614..fef94f5 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -82,9 +82,8 @@ static inline int is_vlan_dev(struct net_device *dev)
 }
 
 #define vlan_tx_tag_present(__skb)	((__skb)->vlan_tci &
VLAN_TAG_PRESENT) -#define vlan_tx_nonzero_tag_present(__skb) \
-	(vlan_tx_tag_present(__skb) && ((__skb)->vlan_tci &
VLAN_VID_MASK)) #define vlan_tx_tag_get(__skb)
((__skb)->vlan_tci & ~VLAN_TAG_PRESENT) +#define
vlan_tx_tag_get_id(__skb)	((__skb)->vlan_tci & VLAN_VID_MASK) 
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7f7e00d..db23dde 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -15,6 +15,8 @@
 
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <linux/err.h>
+#include <linux/bug.h>
 
 struct module;
 struct device;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 46bac3e..8c00159 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -388,6 +388,7 @@ extern int sysctl_max_map_count;
 #include <linux/aio.h>
 
 #ifdef CONFIG_MMU
+extern unsigned long mmap_legacy_base(void);
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
 arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index adab092..a45dd48 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -235,11 +235,13 @@ enum {
 /*
  * The callback notifies userspace to release buffers when skb DMA is
done in
  * lower device, the skb last reference should be 0 when calling this.
+ * The zerocopy_success argument is true if zero copy transmit
occurred,
+ * false on data copy or out of memory error caused by data copy
attempt.
  * The ctx field is used to track device context.
  * The desc field is used to track userspace buffer index.
  */
 struct ubuf_info {
-	void (*callback)(struct ubuf_info *);
+	void (*callback)(struct ubuf_info *, bool zerocopy_success);
 	void *ctx;
 	unsigned long desc;
 };
diff --git a/include/linux/user_namespace.h
b/include/linux/user_namespace.h index 4e72922..4eea4ce 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -22,6 +22,7 @@ struct user_namespace {
 	struct uid_gid_map	gid_map;
 	struct kref		kref;
 	struct user_namespace	*parent;
+	int			level;
 	kuid_t			owner;
 	kgid_t			group;
 };
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index a1ba8bb..765a133 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -44,6 +44,10 @@ void virtqueue_disable_cb(struct virtqueue *vq);
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
 
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
+
+bool virtqueue_poll(struct virtqueue *vq, unsigned);
+
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
 
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6c6c20e..e4683e0 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -571,6 +571,63 @@ do
{
\ __wait_event_killable(wq, condition, __ret);		\
__ret;
\ }) +#define __wait_event_interruptible_lock_irq_timeout(wq,
condition,	\
+						    lock,
ret)		\ +do
{
\
+
DEFINE_WAIT(__wait);						\
+
\
+	for (;;)
{							\
+		prepare_to_wait(&wq, &__wait,
TASK_INTERRUPTIBLE);	\
+		if
(condition)						\
+
break;						\
+		if (signal_pending(current))
{				\
+			ret =
-ERESTARTSYS;				\
+
break;						\
+		}
\
+
spin_unlock_irq(&lock);					\
+		ret =
schedule_timeout(ret);				\
+
spin_lock_irq(&lock);					\
+		if
(!ret)						\
+
break;						\
+	}
\
+	finish_wait(&wq,
&__wait);					\ +} while (0)
+
+/**
+ * wait_event_interruptible_lock_irq_timeout - sleep until a condition
gets true or a timeout elapses.
+ *		The condition is checked under the lock. This is
expected
+ *		to be called with the lock taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and reacquired afterwards.
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or signal is received. The @condition
is
+ * checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and is reacquired afterwards.
+ *
+ * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
+ * was interrupted by a signal, and the remaining jiffies otherwise
+ * if the condition evaluated to true before the timeout elapsed.
+ */
+#define wait_event_interruptible_lock_irq_timeout(wq, condition,
lock,	\
+
timeout)		\
+({
\
+	int __ret =
timeout;						\
+
\
+	if
(!(condition))						\
+
__wait_event_interruptible_lock_irq_timeout(		\
+					wq, condition, lock,
__ret);	\
+
__ret;								\
+}) +
 
 /*
  * These are the old interfaces to sleep waiting for an event.
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 826a541..9761757 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -118,7 +118,7 @@ extern struct ndisc_options *ndisc_parse_options(u8
*opt, int opt_len,
  * if RFC 3831 IPv6-over-Fibre Channel is ever implemented it may
  * also need a pad of 2.
  */
-static int ndisc_addr_option_pad(unsigned short type)
+static inline int ndisc_addr_option_pad(unsigned short type)
 {
 	switch (type) {
 	case ARPHRD_INFINIBAND: return 2;
diff --git a/include/net/udp.h b/include/net/udp.h
index 065f379..ad99eed 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -181,6 +181,7 @@ extern int udp_get_port(struct sock *sk, unsigned
short snum, extern void udp_err(struct sk_buff *, u32);
 extern int udp_sendmsg(struct kiocb *iocb, struct sock *sk,
 			    struct msghdr *msg, size_t len);
+extern int udp_push_pending_frames(struct sock *sk);
 extern void udp_flush_pending_frames(struct sock *sk);
 extern int udp_rcv(struct sk_buff *skb);
 extern int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9cf9102..79e528f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2761,13 +2761,17 @@ static void cgroup_cfts_commit(struct
cgroup_subsys *ss, {
 	LIST_HEAD(pending);
 	struct cgroup *cgrp, *n;
+	struct super_block *sb = ss->root->sb;
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't
attached */
-	if (cfts && ss->root != &rootnode) {
+	if (cfts && ss->root != &rootnode &&
+	    atomic_inc_not_zero(&sb->s_active)) {
 		list_for_each_entry(cgrp, &ss->root->allcg_list,
allcg_node) { dget(cgrp->dentry);
 			list_add_tail(&cgrp->cft_q_node, &pending);
 		}
+	} else {
+		sb = NULL;
 	}
 
 	mutex_unlock(&cgroup_mutex);
@@ -2790,6 +2794,9 @@ static void cgroup_cfts_commit(struct
cgroup_subsys *ss, dput(cgrp->dentry);
 	}
 
+	if (sb)
+		deactivate_super(sb);
+
 	mutex_unlock(&cgroup_cft_mutex);
 }
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b1a7801..18ab244b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -723,8 +723,18 @@ perf_lock_task_context(struct task_struct *task,
int ctxn, unsigned long *flags) {
 	struct perf_event_context *ctx;
 
-	rcu_read_lock();
 retry:
+	/*
+	 * One of the few rules of preemptible RCU is that one cannot
do
+	 * rcu_read_unlock() while holding a scheduler (or nested)
lock when
+	 * part of the read side critical section was preemptible --
see
+	 * rcu_read_unlock_special().
+	 *
+	 * Since ctx->lock nests under rq->lock we must ensure the
entire read
+	 * side critical section is non-preemptible.
+	 */
+	preempt_disable();
+	rcu_read_lock();
 	ctx = rcu_dereference(task->perf_event_ctxp[ctxn]);
 	if (ctx) {
 		/*
@@ -740,6 +750,8 @@ retry:
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
 		if (ctx !=
rcu_dereference(task->perf_event_ctxp[ctxn]))
{ raw_spin_unlock_irqrestore(&ctx->lock, *flags);
+			rcu_read_unlock();
+			preempt_enable();
 			goto retry;
 		}
 
@@ -749,6 +761,7 @@ retry:
 		}
 	}
 	rcu_read_unlock();
+	preempt_enable();
 	return ctx;
 }
 
@@ -1708,7 +1721,16 @@ static int __perf_event_enable(void *info)
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
-	if (WARN_ON_ONCE(!ctx->is_active))
+	/*
+	 * There's a time window between 'ctx->is_active' check
+	 * in perf_event_enable function and this place having:
+	 *   - IRQs on
+	 *   - ctx->lock unlocked
+	 *
+	 * where the task could be killed and 'ctx' deactivated
+	 * by perf_event_exit_task.
+	 */
+	if (!ctx->is_active)
 		return -EINVAL;
 
 	raw_spin_lock(&ctx->lock);
@@ -7002,7 +7024,7 @@ inherit_task_group(struct perf_event *event,
struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
+		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
 		if (!child_ctx)
 			return -ENOMEM;
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e3999c2..e522f9a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -719,17 +719,20 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+static void clock_was_set_work(struct work_struct *work)
+{
+	clock_was_set();
+}
+
+static DECLARE_WORK(hrtimer_work, clock_was_set_work);
+
 /*
- * Called from timekeeping code to reprogramm the hrtimer interrupt
- * device. If called from the timer interrupt context we defer it to
- * softirq context.
+ * Called from timekeeping and resume code to reprogramm the hrtimer
+ * interrupt device on all cpus.
  */
 void clock_was_set_delayed(void)
 {
-	struct hrtimer_cpu_base *cpu_base =
&__get_cpu_var(hrtimer_bases); -
-	cpu_base->clock_was_set = 1;
-	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+	schedule_work(&hrtimer_work);
 }
 
 #else
@@ -779,8 +782,10 @@ void hrtimers_resume(void)
 	WARN_ONCE(!irqs_disabled(),
 		  KERN_INFO "hrtimers_resume() called with IRQs
enabled!"); 
+	/* Retrigger on the local CPU */
 	retrigger_next_event(NULL);
-	timerfd_clock_was_set();
+	/* And schedule a retrigger for all others */
+	clock_was_set_delayed();
 }
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer
*timer) @@ -1416,13 +1421,6 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
-	struct hrtimer_cpu_base *cpu_base =
&__get_cpu_var(hrtimer_bases); -
-	if (cpu_base->clock_was_set) {
-		cpu_base->clock_was_set = 0;
-		clock_was_set();
-	}
-
 	hrtimer_peek_ahead_timers();
 }
 
diff --git a/kernel/power/autosleep.c b/kernel/power/autosleep.c
index ca304046..ab79ecb 100644
--- a/kernel/power/autosleep.c
+++ b/kernel/power/autosleep.c
@@ -32,7 +32,8 @@ static void try_to_suspend(struct work_struct *work)
 
 	mutex_lock(&autosleep_lock);
 
-	if (!pm_save_wakeup_count(initial_count)) {
+	if (!pm_save_wakeup_count(initial_count) ||
+		system_state != SYSTEM_RUNNING) {
 		mutex_unlock(&autosleep_lock);
 		goto out;
 	}
diff --git a/kernel/printk.c b/kernel/printk.c
index 2d3fc0e..74a3afb 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1364,9 +1364,9 @@ static int console_trylock_for_printk(unsigned
int cpu) }
 	}
 	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 239a323..f8961bf 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -400,7 +400,15 @@ void tick_check_oneshot_broadcast(int cpu)
 	if (cpumask_test_cpu(cpu,
to_cpumask(tick_broadcast_oneshot_mask))) { struct tick_device *td =
&per_cpu(tick_cpu_device, cpu); 
-		clockevents_set_mode(td->evtdev,
CLOCK_EVT_MODE_ONESHOT);
+		/*
+		 * We might be in the middle of switching over from
+		 * periodic to oneshot. If the CPU has not yet
+		 * switched over, leave the device alone.
+		 */
+		if (td->mode == TICKDEV_MODE_ONESHOT) {
+			clockevents_set_mode(td->evtdev,
+					     CLOCK_EVT_MODE_ONESHOT);
+		}
 	}
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3e9083..0686c13 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3542,6 +3542,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();
diff --git a/kernel/trace/trace_syscalls.c
b/kernel/trace/trace_syscalls.c index 6b245f64..52b2b9f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -303,6 +303,8 @@ void ftrace_syscall_enter(void *ignore, struct
pt_regs *regs, long id) struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int size;
 	int syscall_nr;
 
@@ -318,8 +320,11 @@ void ftrace_syscall_enter(void *ignore, struct
pt_regs *regs, long id) 
 	size = sizeof(*entry) + sizeof(unsigned long) *
sys_data->nb_args; 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->enter_event->event.type, size, 0, 0);
+			sys_data->enter_event->event.type, size,
irq_flags, pc); if (!event)
 		return;
 
@@ -329,7 +334,8 @@ void ftrace_syscall_enter(void *ignore, struct
pt_regs *regs, long id) 
 	if (!filter_current_check_discard(buffer,
sys_data->enter_event, entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0,
0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
@@ -338,6 +344,8 @@ void ftrace_syscall_exit(void *ignore, struct
pt_regs *regs, long ret) struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
@@ -350,8 +358,12 @@ void ftrace_syscall_exit(void *ignore, struct
pt_regs *regs, long ret) if (!sys_data)
 		return;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->exit_event->event.type,
sizeof(*entry), 0, 0);
+			sys_data->exit_event->event.type,
sizeof(*entry),
+			irq_flags, pc);
 	if (!event)
 		return;
 
@@ -361,7 +373,8 @@ void ftrace_syscall_exit(void *ignore, struct
pt_regs *regs, long ret) 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0,
0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 int reg_event_syscall_enter(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..77dccfc 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -243,8 +243,10 @@ static int create_trace_uprobe(int argc, char
**argv) return -EINVAL;
 	}
 	arg = strchr(argv[1], ':');
-	if (!arg)
+	if (!arg) {
+		ret = -EINVAL;
 		goto fail_address_parse;
+	}
 
 	*arg++ = '\0';
 	filename = argv[1];
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a74dc5b..5242e83 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -39,6 +39,9 @@ int create_user_ns(struct cred *new)
 	kuid_t owner = new->euid;
 	kgid_t group = new->egid;
 
+	if (parent_ns->level > 32)
+		return -EUSERS;
+
 	/*
 	 * Verify that we can not violate the policy of which files
 	 * may be accessed that is specified by the root directory,
@@ -62,6 +65,7 @@ int create_user_ns(struct cred *new)
 
 	kref_init(&ns->kref);
 	ns->parent = parent_ns;
+	ns->level = parent_ns->level + 1;
 	ns->owner = owner;
 	ns->group = group;
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0352a81..ce44f31 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2105,6 +2105,15 @@ __acquires(&gcwq->lock)
 		dump_stack();
 	}
 
+	/*
+	 * The following prevents a kworker from hogging CPU
on !PREEMPT
+	 * kernels, where a requeueing work item waiting for something
to
+	 * happen could deadlock with stop_machine as such work item
could
+	 * indefinitely requeue itself while all other CPUs are
trapped in
+	 * stop_machine.
+	 */
+	cond_resched();
+
 	spin_lock_irq(&gcwq->lock);
 
 	/* clear cpu intensive status */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2403a63..89a657a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1242,7 +1242,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !PPC && !S390 && !MICROBLAZE
&& !ARM_UNWIND
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE
&& !ARM_UNWIND help
 	  Provide stacktrace filter for fault-injection capabilities
 
diff --git a/mm/memory.c b/mm/memory.c
index 06ff7fb..e526880 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1106,6 +1106,7 @@ static unsigned long zap_pte_range(struct
mmu_gather *tlb, spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	unsigned long range_start = addr;
 
 again:
 	init_rss_vec(rss);
@@ -1211,12 +1212,14 @@ again:
 		force_flush = 0;
 
 #ifdef HAVE_GENERIC_MMU_GATHER
-		tlb->start = addr;
-		tlb->end = end;
+		tlb->start = range_start;
+		tlb->end = addr;
 #endif
 		tlb_flush_mmu(tlb);
-		if (addr != end)
+		if (addr != end) {
+			range_start = addr;
 			goto again;
+		}
 	}
 
 	return addr;
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index fe29a64..d5f07cb 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -8,7 +8,7 @@
 bool vlan_do_receive(struct sk_buff **skbp)
 {
 	struct sk_buff *skb = *skbp;
-	u16 vlan_id = skb->vlan_tci & VLAN_VID_MASK;
+	u16 vlan_id = vlan_tx_tag_get_id(skb);
 	struct net_device *vlan_dev;
 	struct vlan_pcpu_stats *rx_stats;
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index a841735..52457f5 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -73,6 +73,8 @@ vlan_dev_get_egress_qos_mask(struct net_device *dev,
struct sk_buff *skb) {
 	struct vlan_priority_tci_mapping *mp;
 
+	smp_rmb(); /* coupled with smp_wmb() in
vlan_dev_set_egress_priority() */ +
 	mp = vlan_dev_priv(dev)->egress_priority_map[(skb->priority &
0xF)]; while (mp) {
 		if (mp->priority == skb->priority) {
@@ -248,6 +250,11 @@ int vlan_dev_set_egress_priority(const struct
net_device *dev, np->next = mp;
 	np->priority = skb_prio;
 	np->vlan_qos = vlan_qos;
+	/* Before inserting this element in hash table, make sure all
its fields
+	 * are committed to memory.
+	 * coupled with smp_rmb() in vlan_dev_get_egress_qos_mask()
+	 */
+	smp_wmb();
 	vlan->egress_priority_map[skb_prio & 0xF] = np;
 	if (vlan_qos)
 		vlan->nr_egress_mappings++;
diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index de8df957..2ee3879 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -24,11 +24,11 @@
  */
 void p9_release_pages(struct page **pages, int nr_pages)
 {
-	int i = 0;
-	while (pages[i] && nr_pages--) {
-		put_page(pages[i]);
-		i++;
-	}
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		if (pages[i])
+			put_page(pages[i]);
 }
 EXPORT_SYMBOL(p9_release_pages);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 9b5e388..1012a02 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3317,8 +3317,15 @@ ncls:
 		}
 	}
 
-	if (vlan_tx_nonzero_tag_present(skb))
-		skb->pkt_type = PACKET_OTHERHOST;
+	if (unlikely(vlan_tx_tag_present(skb))) {
+		if (vlan_tx_tag_get_id(skb))
+			skb->pkt_type = PACKET_OTHERHOST;
+		/* Note: we might in the future use prio bits
+		 * and set skb->priority like in vlan_do_receive()
+		 * For the time being, just ignore Priority Code Point
+		 */
+		skb->vlan_tci = 0;
+	}
 
 	/* deliver only exact match when indicated */
 	null_or_dev = deliver_exact ? skb->dev : NULL;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 058bb1e..f7ffed1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -239,7 +239,7 @@ static void neigh_flush_dev(struct neigh_table
*tbl, struct net_device *dev) we must kill timers etc. and move
 				   it to safe state.
 				 */
-				skb_queue_purge(&n->arp_queue);
+				__skb_queue_purge(&n->arp_queue);
 				n->arp_queue_len_bytes = 0;
 				n->output = neigh_blackhole;
 				if (n->nud_state & NUD_VALID)
@@ -302,7 +302,7 @@ static struct neighbour *neigh_alloc(struct
neigh_table *tbl, struct net_device if (!n)
 		goto out_entries;
 
-	skb_queue_head_init(&n->arp_queue);
+	__skb_queue_head_init(&n->arp_queue);
 	rwlock_init(&n->lock);
 	seqlock_init(&n->ha_lock);
 	n->updated	  = n->used = now;
@@ -724,7 +724,9 @@ void neigh_destroy(struct neighbour *neigh)
 	if (neigh_del_timer(neigh))
 		pr_warn("Impossible event\n");
 
-	skb_queue_purge(&neigh->arp_queue);
+	write_lock_bh(&neigh->lock);
+	__skb_queue_purge(&neigh->arp_queue);
+	write_unlock_bh(&neigh->lock);
 	neigh->arp_queue_len_bytes = 0;
 
 	if (dev->netdev_ops->ndo_neigh_destroy)
@@ -870,7 +872,7 @@ static void neigh_invalidate(struct neighbour
*neigh) neigh->ops->error_report(neigh, skb);
 		write_lock(&neigh->lock);
 	}
-	skb_queue_purge(&neigh->arp_queue);
+	__skb_queue_purge(&neigh->arp_queue);
 	neigh->arp_queue_len_bytes = 0;
 }
 
@@ -1222,7 +1224,7 @@ int neigh_update(struct neighbour *neigh, const
u8 *lladdr, u8 new, 
 			write_lock_bh(&neigh->lock);
 		}
-		skb_queue_purge(&neigh->arp_queue);
+		__skb_queue_purge(&neigh->arp_queue);
 		neigh->arp_queue_len_bytes = 0;
 	}
 out:
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 043139d01..eaad7a7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -505,7 +505,7 @@ static void skb_release_data(struct sk_buff *skb)
 
 			uarg = skb_shinfo(skb)->destructor_arg;
 			if (uarg->callback)
-				uarg->callback(uarg);
+				uarg->callback(uarg, true);
 		}
 
 		if (skb_has_frag_list(skb))
@@ -783,7 +783,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t
gfp_mask) for (i = 0; i < num_frags; i++)
 		skb_frag_unref(skb, i);
 
-	uarg->callback(uarg);
+	uarg->callback(uarg, false);
 
 	/* skb frags point to kernel buffers */
 	for (i = num_frags - 1; i >= 0; i--) {
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index bf89b21..ab37b31 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -664,17 +664,10 @@ static int __net_init vti_fb_tunnel_init(struct
net_device *dev) struct iphdr *iph = &tunnel->parms.iph;
 	struct vti_net *ipn = net_generic(dev_net(dev), vti_net_id);
 
-	tunnel->dev = dev;
-	strcpy(tunnel->parms.name, dev->name);
-
 	iph->version		= 4;
 	iph->protocol		= IPPROTO_IPIP;
 	iph->ihl		= 5;
 
-	dev->tstats = alloc_percpu(struct pcpu_tstats);
-	if (!dev->tstats)
-		return -ENOMEM;
-
 	dev_hold(dev);
 	rcu_assign_pointer(ipn->tunnels_wc[0], tunnel);
 	return 0;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 1b5ce96..335f18d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -35,6 +35,8 @@ static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
 static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
+static int tcp_syn_retries_min = 1;
+static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
 static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 
@@ -277,7 +279,9 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_tcp_syn_retries,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &tcp_syn_retries_min,
+		.extra2		= &tcp_syn_retries_max
 	},
 	{
 		.procname	= "tcp_synack_retries",
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index ee4b36a..79336ce 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -774,7 +774,7 @@ send:
 /*
  * Push out all pending data as one UDP datagram. Socket is locked.
  */
-static int udp_push_pending_frames(struct sock *sk)
+int udp_push_pending_frames(struct sock *sk)
 {
 	struct udp_sock  *up = udp_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
@@ -793,6 +793,7 @@ out:
 	up->pending = 0;
 	return err;
 }
+EXPORT_SYMBOL(udp_push_pending_frames);
 
 int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr
*msg, size_t len)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index a26d44c..c088717 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1182,11 +1182,12 @@ static inline struct ipv6_rt_hdr
*ip6_rthdr_dup(struct ipv6_rt_hdr *src, return src ? kmemdup(src,
(src->hdrlen + 1) * 8, gfp) : NULL; }
 
-static void ip6_append_data_mtu(int *mtu,
+static void ip6_append_data_mtu(unsigned int *mtu,
 				int *maxfraglen,
 				unsigned int fragheaderlen,
 				struct sk_buff *skb,
-				struct rt6_info *rt)
+				struct rt6_info *rt,
+				bool pmtuprobe)
 {
 	if (!(rt->dst.flags & DST_XFRM_TUNNEL)) {
 		if (skb == NULL) {
@@ -1198,7 +1199,9 @@ static void ip6_append_data_mtu(int *mtu,
 			 * this fragment is not first, the headers
 			 * space is regarded as data space.
 			 */
-			*mtu = dst_mtu(rt->dst.path);
+			*mtu = min(*mtu, pmtuprobe ?
+				   rt->dst.dev->mtu :
+				   dst_mtu(rt->dst.path));
 		}
 		*maxfraglen = ((*mtu - fragheaderlen) & ~7)
 			      + fragheaderlen - sizeof(struct
frag_hdr); @@ -1215,11 +1218,10 @@ int ip6_append_data(struct sock *sk,
int getfrag(void *from, char *to, struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_cork *cork;
 	struct sk_buff *skb, *skb_prev = NULL;
-	unsigned int maxfraglen, fragheaderlen;
+	unsigned int maxfraglen, fragheaderlen, mtu;
 	int exthdrlen;
 	int dst_exthdrlen;
 	int hh_len;
-	int mtu;
 	int copy;
 	int err;
 	int offset = 0;
@@ -1381,7 +1383,9 @@ alloc_new_skb:
 			/* update mtu and maxfraglen if necessary */
 			if (skb == NULL || skb_prev == NULL)
 				ip6_append_data_mtu(&mtu, &maxfraglen,
-						    fragheaderlen,
skb, rt);
+						    fragheaderlen,
skb, rt,
+						    np->pmtudisc ==
+
IPV6_PMTUDISC_PROBE); 
 			skb_prev = skb;
 
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 4532973..964e3ae 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -256,10 +256,12 @@ static void __net_exit ip6mr_rules_exit(struct
net *net) {
 	struct mr6_table *mrt, *next;
 
+	rtnl_lock();
 	list_for_each_entry_safe(mrt, next, &net->ipv6.mr6_tables,
list) { list_del(&mrt->list);
 		ip6mr_free_table(mrt);
 	}
+	rtnl_unlock();
 	fib_rules_unregister(net->ipv6.mr6_rules_ops);
 }
 #else
@@ -286,7 +288,10 @@ static int __net_init ip6mr_rules_init(struct net
*net) 
 static void __net_exit ip6mr_rules_exit(struct net *net)
 {
+	rtnl_lock();
 	ip6mr_free_table(net->ipv6.mrt6);
+	net->ipv6.mrt6 = NULL;
+	rtnl_unlock();
 }
 #endif
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 103880b..bba556f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1076,10 +1076,13 @@ static void ip6_link_failure(struct sk_buff
*skb) 
 	rt = (struct rt6_info *) skb_dst(skb);
 	if (rt) {
-		if (rt->rt6i_flags & RTF_CACHE)
-			rt6_update_expires(rt, 0);
-		else if (rt->rt6i_node && (rt->rt6i_flags &
RTF_DEFAULT))
+		if (rt->rt6i_flags & RTF_CACHE) {
+			dst_hold(&rt->dst);
+			if (ip6_del_rt(rt))
+				dst_free(&rt->dst);
+		} else if (rt->rt6i_node && (rt->rt6i_flags &
RTF_DEFAULT)) { rt->rt6i_node->fn_sernum = -1;
+		}
 	}
 }
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 08a1878..4328d31 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -955,11 +955,16 @@ static int udp_v6_push_pending_frames(struct sock
*sk) struct udphdr *uh;
 	struct udp_sock  *up = udp_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	struct flowi6 *fl6 = &inet->cork.fl.u.ip6;
+	struct flowi6 *fl6;
 	int err = 0;
 	int is_udplite = IS_UDPLITE(sk);
 	__wsum csum = 0;
 
+	if (up->pending == AF_INET)
+		return udp_push_pending_frames(sk);
+
+	fl6 = &inet->cork.fl.u.ip6;
+
 	/* Grab the skbuff where UDP header space exists. */
 	if ((skb = skb_peek(&sk->sk_write_queue)) == NULL)
 		goto out;
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 34e4185..5c6b2f0 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2072,6 +2072,7 @@ static int pfkey_xfrm_policy2msg(struct sk_buff
*skb, const struct xfrm_policy * pol->sadb_x_policy_type =
IPSEC_POLICY_NONE; }
 	pol->sadb_x_policy_dir = dir+1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
 	pol->sadb_x_policy_priority = xp->priority;
 
@@ -3106,7 +3107,9 @@ static int pfkey_send_acquire(struct xfrm_state
*x, struct xfrm_tmpl *t, struct pol->sadb_x_policy_exttype =
SADB_X_EXT_POLICY; pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = dir+1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = xp->index;
+	pol->sadb_x_policy_priority = xp->priority;
 
 	/* Set sadb_comb's. */
 	if (x->id.proto == IPPROTO_AH)
@@ -3494,6 +3497,7 @@ static int pfkey_send_migrate(const struct
xfrm_selector *sel, u8 dir, u8 type, pol->sadb_x_policy_exttype =
SADB_X_EXT_POLICY; pol->sadb_x_policy_type = IPSEC_POLICY_IPSEC;
 	pol->sadb_x_policy_dir = dir + 1;
+	pol->sadb_x_policy_reserved = 0;
 	pol->sadb_x_policy_id = 0;
 	pol->sadb_x_policy_priority = 0;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 955195c..feca60c 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1837,7 +1837,8 @@ static const struct proto_ops pppol2tp_ops = {
 
 static const struct pppox_proto pppol2tp_proto = {
 	.create		= pppol2tp_create,
-	.ioctl		= pppol2tp_ioctl
+	.ioctl		= pppol2tp_ioctl,
+	.owner		= THIS_MODULE,
 };
 
 #ifdef CONFIG_L2TP_V3
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bb8d96b..cf9523e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -554,6 +554,8 @@ static void ieee80211_get_et_stats(struct wiphy
*wiphy, if (sta->sdata->dev != dev)
 				continue;
 
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bd11c1c..56515ef 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -805,8 +805,14 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr
*)rx->skb->data; struct ieee80211_rx_status *status =
IEEE80211_SKB_RXCB(rx->skb); 
-	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap.
9.2.9) */
-	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
+	/*
+	 * Drop duplicate 802.11 retransmissions
+	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and
recovery")
+	 */
+	if (rx->skb->len >= 24 && rx->sta &&
+	    !ieee80211_is_ctl(hdr->frame_control) &&
+	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 42556ce..17e7104 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -749,6 +749,10 @@ static int ctrl_dumpfamily(struct sk_buff *skb,
struct netlink_callback *cb) struct net *net = sock_net(skb->sk);
 	int chains_to_skip = cb->args[0];
 	int fams_to_skip = cb->args[1];
+	bool need_locking = chains_to_skip || fams_to_skip;
+
+	if (need_locking)
+		genl_lock();
 
 	for (i = chains_to_skip; i < GENL_FAM_TAB_SIZE; i++) {
 		n = 0;
@@ -770,6 +774,9 @@ errout:
 	cb->args[0] = i;
 	cb->args[1] = n;
 
+	if (need_locking)
+		genl_unlock();
+
 	return skb->len;
 }
 
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index ca8e0a5..1f9c314 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -605,6 +605,7 @@ static int atm_tc_dump_class(struct Qdisc *sch,
unsigned long cl, struct sockaddr_atmpvc pvc;
 		int state;
 
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = flow->vcc->dev ?
flow->vcc->dev->number : -1; pvc.sap_addr.vpi = flow->vcc->vpi;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 611d5e9..823f07f 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1469,6 +1469,7 @@ static int cbq_dump_wrr(struct sk_buff *skb,
struct cbq_class *cl) unsigned char *b = skb_tail_pointer(skb);
 	struct tc_cbq_wrropt opt;
 
+	memset(&opt, 0, sizeof(opt));
 	opt.flags = 0;
 	opt.allot = cl->allot;
 	opt.priority = cl->priority + 1;
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 998aa8c..da0980a 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -963,7 +963,10 @@ static void svc_tcp_clear_pages(struct svc_sock
*svsk) len = svsk->sk_tcplen - sizeof(rpc_fraghdr);
 	npages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	for (i = 0; i < npages; i++) {
-		BUG_ON(svsk->sk_pages[i] == NULL);
+		if (svsk->sk_pages[i] == NULL) {
+			WARN_ON_ONCE(1);
+			continue;
+		}
 		put_page(svsk->sk_pages[i]);
 		svsk->sk_pages[i] = NULL;
 	}
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 0afba1b..7e99acd 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -207,10 +207,13 @@ _shift_data_right_pages(struct page **pages,
size_t pgto_base, pgfrom_base -= copy;
 
 		vto = kmap_atomic(*pgto);
-		vfrom = kmap_atomic(*pgfrom);
-		memmove(vto + pgto_base, vfrom + pgfrom_base, copy);
+		if (*pgto != *pgfrom) {
+			vfrom = kmap_atomic(*pgfrom);
+			memcpy(vto + pgto_base, vfrom + pgfrom_base,
copy);
+			kunmap_atomic(vfrom);
+		} else
+			memmove(vto + pgto_base, vto + pgfrom_base,
copy); flush_dcache_page(*pgto);
-		kunmap_atomic(vfrom);
 		kunmap_atomic(vto);
 
 	} while ((len -= copy) != 0);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_marshal.c
b/net/sunrpc/xprtrdma/svc_rdma_marshal.c index 8d2eddd..65b1462 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_marshal.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
@@ -98,6 +98,7 @@ void svc_rdma_rcl_chunk_counts(struct
rpcrdma_read_chunk *ch, */
 static u32 *decode_write_list(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 
 	struct rpcrdma_write_array *ary =
@@ -113,9 +114,12 @@ static u32 *decode_write_list(u32 *va, u32 *vaend)
 		return NULL;
 	}
 	nchunks = ntohl(ary->wc_nchunks);
-	if (((unsigned long)&ary->wc_array[0] +
-	     (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
-	    (unsigned long)vaend) {
+
+	start = (unsigned long)&ary->wc_array[0];
+	end = (unsigned long)vaend;
+	if (nchunks < 0 ||
+	    nchunks > (SIZE_MAX - start) / sizeof(struct
rpcrdma_write_chunk) ||
+	    (start + (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
end) { dprintk("svcrdma: ary=%p, wc_nchunks=%d, vaend=%p\n",
 			ary, nchunks, vaend);
 		return NULL;
@@ -129,6 +133,7 @@ static u32 *decode_write_list(u32 *va, u32 *vaend)
 
 static u32 *decode_reply_array(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 	struct rpcrdma_write_array *ary =
 		(struct rpcrdma_write_array *)va;
@@ -143,9 +148,12 @@ static u32 *decode_reply_array(u32 *va, u32 *vaend)
 		return NULL;
 	}
 	nchunks = ntohl(ary->wc_nchunks);
-	if (((unsigned long)&ary->wc_array[0] +
-	     (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
-	    (unsigned long)vaend) {
+
+	start = (unsigned long)&ary->wc_array[0];
+	end = (unsigned long)vaend;
+	if (nchunks < 0 ||
+	    nchunks > (SIZE_MAX - start) / sizeof(struct
rpcrdma_write_chunk) ||
+	    (start + (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
end) { dprintk("svcrdma: ary=%p, wc_nchunks=%d, vaend=%p\n",
 			ary, nchunks, vaend);
 		return NULL;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a10901b..250e0a6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -846,6 +846,7 @@ static int cfg80211_netdev_notifier_call(struct
notifier_block *nb, cfg80211_leave_mesh(rdev, dev);
 			break;
 		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
 			cfg80211_stop_ap(rdev, dev);
 			break;
 		default:
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1e37dbf..79ad33d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5542,12 +5542,14 @@
EXPORT_SYMBOL(cfg80211_testmode_alloc_event_skb); 
 void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 {
+	struct cfg80211_registered_device *rdev = ((void
**)skb->cb)[0]; void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
-	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), skb, 0,
+				nl80211_testmode_mcgrp.id, gfp);
 }
 EXPORT_SYMBOL(cfg80211_testmode_event);
 #endif
@@ -8378,7 +8380,8 @@ void nl80211_send_mgmt_tx_status(struct
cfg80211_registered_device *rdev, 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index a306bc6..b943e3e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1586,11 +1586,11 @@ out_cud_release:
 	case SIOCX25CALLACCPTAPPRV: {
 		rc = -EINVAL;
 		lock_sock(sk);
-		if (sk->sk_state != TCP_CLOSE)
-			break;
-		clear_bit(X25_ACCPT_APPRV_FLAG, &x25->flags);
+		if (sk->sk_state == TCP_CLOSE) {
+			clear_bit(X25_ACCPT_APPRV_FLAG, &x25->flags);
+			rc = 0;
+		}
 		release_sock(sk);
-		rc = 0;
 		break;
 	}
 
@@ -1598,14 +1598,15 @@ out_cud_release:
 		rc = -EINVAL;
 		lock_sock(sk);
 		if (sk->sk_state != TCP_ESTABLISHED)
-			break;
+			goto out_sendcallaccpt_release;
 		/* must call accptapprv above */
 		if (test_bit(X25_ACCPT_APPRV_FLAG, &x25->flags))
-			break;
+			goto out_sendcallaccpt_release;
 		x25_write_internal(sk, X25_CALL_ACCEPTED);
 		x25->state = X25_STATE_3;
-		release_sock(sk);
 		rc = 0;
+out_sendcallaccpt_release:
+		release_sock(sk);
 		break;
 	}
 
diff --git a/sound/arm/pxa2xx-pcm-lib.c b/sound/arm/pxa2xx-pcm-lib.c
index 76e0d56..823359e 100644
--- a/sound/arm/pxa2xx-pcm-lib.c
+++ b/sound/arm/pxa2xx-pcm-lib.c
@@ -166,7 +166,9 @@ void pxa2xx_pcm_dma_irq(int dma_ch, void *dev_id)
 	} else {
 		printk(KERN_ERR "%s: DMA error on channel %d
(DCSR=%#x)\n", rtd->params->name, dma_ch, dcsr);
+		snd_pcm_stream_lock(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(substream);
 	}
 }
 EXPORT_SYMBOL(pxa2xx_pcm_dma_irq);
diff --git a/sound/core/compress_offload.c
b/sound/core/compress_offload.c index d5103f7..20f55e2 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -582,7 +582,7 @@ static long snd_compr_ioctl(struct file *f,
unsigned int cmd, unsigned long arg) mutex_lock(&stream->device->lock);
 	switch (_IOC_NR(cmd)) {
 	case _IOC_NR(SNDRV_COMPRESS_IOCTL_VERSION):
-		put_user(SNDRV_COMPRESS_VERSION,
+		retval = put_user(SNDRV_COMPRESS_VERSION,
 				(int __user *)arg) ? -EFAULT : 0;
 		break;
 	case _IOC_NR(SNDRV_COMPRESS_GET_CAPS):
diff --git a/sound/core/seq/oss/seq_oss_init.c
b/sound/core/seq/oss/seq_oss_init.c index e3cb46f..b3f39b5 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -31,6 +31,7 @@
 #include <linux/export.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 /*
  * common variables
@@ -60,6 +61,14 @@ static void free_devinfo(void *private);
 #define call_ctl(type,rec) snd_seq_kernel_client_ctl(system_client,
type, rec) 
 
+/* call snd_seq_oss_midi_lookup_ports() asynchronously */
+static void async_call_lookup_ports(struct work_struct *work)
+{
+	snd_seq_oss_midi_lookup_ports(system_client);
+}
+
+static DECLARE_WORK(async_lookup_work, async_call_lookup_ports);
+
 /*
  * create sequencer client for OSS sequencer
  */
@@ -85,9 +94,6 @@ snd_seq_oss_create_client(void)
 	system_client = rc;
 	debug_printk(("new client = %d\n", rc));
 
-	/* look up midi devices */
-	snd_seq_oss_midi_lookup_ports(system_client);
-
 	/* create annoucement receiver port */
 	memset(port, 0, sizeof(*port));
 	strcpy(port->name, "Receiver");
@@ -115,6 +121,9 @@ snd_seq_oss_create_client(void)
 	}
 	rc = 0;
 
+	/* look up midi devices */
+	schedule_work(&async_lookup_work);
+
  __error:
 	kfree(port);
 	return rc;
@@ -160,6 +169,7 @@ receive_announce(struct snd_seq_event *ev, int
direct, void *private, int atomic int
 snd_seq_oss_delete_client(void)
 {
+	cancel_work_sync(&async_lookup_work);
 	if (system_client >= 0)
 		snd_seq_delete_kernel_client(system_client);
 
diff --git a/sound/core/seq/oss/seq_oss_midi.c
b/sound/core/seq/oss/seq_oss_midi.c index 677dc84..862d8489 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -72,7 +72,7 @@ static int send_midi_event(struct seq_oss_devinfo
*dp, struct snd_seq_event *ev,
  * look up the existing ports
  * this looks a very exhausting job.
  */
-int __init
+int
 snd_seq_oss_midi_lookup_ports(int client)
 {
 	struct snd_seq_client_info *clinfo;
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c
b/sound/isa/opti9xx/opti92x-ad1848.c index f8fbe22..e7ec347 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -172,11 +172,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9xx_pnpids);
 
 #endif	/* CONFIG_PNP */
 
-#ifdef OPTi93X
-#define DEV_NAME "opti93x"
-#else
-#define DEV_NAME "opti92x"
-#endif
+#define DEV_NAME KBUILD_MODNAME
 
 static char * snd_opti9xx_names[] = {
 	"unknown",
@@ -1180,7 +1176,7 @@ static int snd_opti9xx_pnp_resume(struct
pnp_card_link *pcard) 
 static struct pnp_card_driver opti9xx_pnpc_driver = {
 	.flags		= PNP_DRIVER_RES_DISABLE,
-	.name		= "opti9xx",
+	.name		= DEV_NAME,
 	.id_table	= snd_opti9xx_pnpids,
 	.probe		= snd_opti9xx_pnp_probe,
 	.remove		= __devexit_p(snd_opti9xx_pnp_remove),
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index e8de831..05093bd 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -769,7 +769,10 @@ static void
snd_card_asihpi_timer_function(unsigned long data) s->number);
 				ds->drained_count++;
 				if (ds->drained_count > 20) {
+					unsigned long flags;
+					snd_pcm_stream_lock_irqsave(s,
flags); snd_pcm_stop(s, SNDRV_PCM_STATE_XRUN);
+
snd_pcm_stream_unlock_irqrestore(s, flags); continue;
 				}
 			} else {
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 31020d2..1231353 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -688,7 +688,9 @@ static void snd_atiixp_xrun_dma(struct atiixp
*chip, struct atiixp_dma *dma) if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp: XRUN detected (DMA %d)\n",
dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 79e204e..3662140 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -638,7 +638,9 @@ static void snd_atiixp_xrun_dma(struct atiixp_modem
*chip, if (! dma->substream || ! dma->running)
 		return;
 	snd_printdd("atiixp-modem: XRUN detected (DMA %d)\n",
dma->ops->type);
+	snd_pcm_stream_lock(dma->substream);
 	snd_pcm_stop(dma->substream, SNDRV_PCM_STATE_XRUN);
+	snd_pcm_stream_unlock(dma->substream);
 }
 
 /*
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 8f23374..80a86b3 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -908,7 +908,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream
*hinfo, per_cvt->assigned = 1;
 	hinfo->nid = per_cvt->cvt_nid;
 
-	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
+	snd_hda_codec_write_cache(codec, per_pin->pin_nid, 0,
 			    AC_VERB_SET_CONNECT_SEL,
 			    mux_idx);
 	snd_hda_spdif_ctls_assign(codec, pin_idx, per_cvt->cvt_nid);
@@ -1921,6 +1921,7 @@ static const struct hda_codec_preset
snd_hda_preset_hdmi[] = { { .id = 0x10de0043, .name = "GPU 43
HDMI/DP",	.patch = patch_generic_hdmi }, { .id =
0x10de0044, .name = "GPU 44 HDMI/DP",	.patch =
patch_generic_hdmi }, { .id = 0x10de0051, .name = "GPU 51
HDMI/DP",	.patch = patch_generic_hdmi }, +{ .id =
0x10de0060, .name = "GPU 60 HDMI/DP",	.patch =
patch_generic_hdmi }, { .id = 0x10de0067, .name = "MCP67
HDMI",	.patch = patch_nvhdmi_2ch }, { .id = 0x10de8001, .name =
"MCP73 HDMI",	.patch = patch_nvhdmi_2ch }, { .id =
0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
@@ -1973,6 +1974,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0042");
MODULE_ALIAS("snd-hda-codec-id:10de0043");
MODULE_ALIAS("snd-hda-codec-id:10de0044");
MODULE_ALIAS("snd-hda-codec-id:10de0051");
+MODULE_ALIAS("snd-hda-codec-id:10de0060");
MODULE_ALIAS("snd-hda-codec-id:10de0067");
MODULE_ALIAS("snd-hda-codec-id:10de8001");
MODULE_ALIAS("snd-hda-codec-id:11069f80"); diff --git
a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c index
dd7f1db..d0bbdf9 100644 --- a/sound/pci/hda/patch_realtek.c +++
b/sound/pci/hda/patch_realtek.c @@ -6860,9 +6860,11 @@ static const
struct alc_fixup alc662_fixups[] = { static const struct snd_pci_quirk
alc662_fixup_tbl[] = { SND_PCI_QUIRK(0x1019, 0x9087, "ECS",
ALC662_FIXUP_ASUS_MODE2),
+	SND_PCI_QUIRK(0x1025, 0x022f, "Acer Aspire One",
ALC662_FIXUP_INV_DMIC), SND_PCI_QUIRK(0x1025, 0x0308, "Acer Aspire
8942G", ALC662_FIXUP_ASPIRE), SND_PCI_QUIRK(0x1025, 0x031c, "Gateway
NV79", ALC662_FIXUP_SKU_IGNORE), SND_PCI_QUIRK(0x1025, 0x0349,
"eMachines eM250", ALC662_FIXUP_INV_DMIC),
+	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27",
ALC662_FIXUP_INV_DMIC), SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire
8943G", ALC662_FIXUP_ASPIRE), SND_PCI_QUIRK(0x103c, 0x1632, "HP
RP5800", ALC662_FIXUP_HP_RP5800), SND_PCI_QUIRK(0x1043, 0x8469, "ASUS
mobo", ALC662_FIXUP_NO_JACK_DETECT), diff --git
a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c index
d34aa42..c05e6b2 100644 --- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -450,7 +450,7 @@ static const struct snd_kcontrol_new
cs42l52_snd_controls[] = { SOC_ENUM("Beep Pitch", beep_pitch_enum),
 	SOC_ENUM("Beep on Time", beep_ontime_enum),
 	SOC_ENUM("Beep off Time", beep_offtime_enum),
-	SOC_SINGLE_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x1f, 0x07,
hl_tlv),
+	SOC_SINGLE_SX_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x07,
0x1f, hl_tlv), SOC_SINGLE("Beep Mixer Switch", CS42L52_BEEP_TONE_CTL,
5, 1, 1), SOC_ENUM("Beep Treble Corner Freq", beep_treble_enum),
 	SOC_ENUM("Beep Bass Corner Freq", beep_bass_enum),
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 4790568..8df4597 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1594,7 +1594,7 @@ static int max98088_dai2_digital_mute(struct
snd_soc_dai *codec_dai, int mute) 
 static void max98088_sync_cache(struct snd_soc_codec *codec)
 {
-       u16 *reg_cache = codec->reg_cache;
+       u8 *reg_cache = codec->reg_cache;
        int i;
 
        if (!codec->cache_sync)
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 8a9f435..d3a68bb 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -347,7 +347,7 @@
 #define SGTL5000_PLL_INT_DIV_MASK		0xf800
 #define SGTL5000_PLL_INT_DIV_SHIFT		11
 #define SGTL5000_PLL_INT_DIV_WIDTH		5
-#define SGTL5000_PLL_FRAC_DIV_MASK		0x0700
+#define SGTL5000_PLL_FRAC_DIV_MASK		0x07ff
 #define SGTL5000_PLL_FRAC_DIV_SHIFT		0
 #define SGTL5000_PLL_FRAC_DIV_WIDTH		11
 
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index ce67200..df24c54 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1600,7 +1600,6 @@ static int wm8962_put_hp_sw(struct snd_kcontrol
*kcontrol, struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -1609,16 +1608,19 @@ static int wm8962_put_hp_sw(struct snd_kcontrol
*kcontrol, return 0;
 
 	/* If the left PGA is enabled hit that VU bit... */
-	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) &
WM8962_HPOUTL_PGA_ENA)
-		return snd_soc_write(codec, WM8962_HPOUTL_VOLUME,
-				     reg_cache[WM8962_HPOUTL_VOLUME]);
+	ret = snd_soc_read(codec, WM8962_PWR_MGMT_2);
+	if (ret & WM8962_HPOUTL_PGA_ENA) {
+		snd_soc_write(codec, WM8962_HPOUTL_VOLUME,
+			      snd_soc_read(codec,
WM8962_HPOUTL_VOLUME));
+		return 1;
+	}
 
 	/* ...otherwise the right.  The VU is stereo. */
-	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) &
WM8962_HPOUTR_PGA_ENA)
-		return snd_soc_write(codec, WM8962_HPOUTR_VOLUME,
-				     reg_cache[WM8962_HPOUTR_VOLUME]);
+	if (ret & WM8962_HPOUTR_PGA_ENA)
+		snd_soc_write(codec, WM8962_HPOUTR_VOLUME,
+			      snd_soc_read(codec,
WM8962_HPOUTR_VOLUME)); 
-	return 0;
+	return 1;
 }
 
 /* The VU bits for the speakers are in a different register to the mute
@@ -3378,7 +3380,6 @@ static int wm8962_probe(struct snd_soc_codec
*codec) int ret;
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
 	struct wm8962_pdata *pdata = dev_get_platdata(codec->dev);
-	u16 *reg_cache = codec->reg_cache;
 	int i, trigger, irq_pol;
 	bool dmicclk, dmicdat;
 
@@ -3436,8 +3437,9 @@ static int wm8962_probe(struct snd_soc_codec
*codec) 
 		/* Put the speakers into mono mode? */
 		if (pdata->spk_mono)
-			reg_cache[WM8962_CLASS_D_CONTROL_2]
-				|= WM8962_SPK_MONO;
+			snd_soc_update_bits(codec,
WM8962_CLASS_D_CONTROL_2,
+				WM8962_SPK_MONO_MASK, WM8962_SPK_MONO);
+
 
 		/* Micbias setup, detection enable and detection
 		 * threasholds. */
diff --git a/sound/soc/s6000/s6000-pcm.c b/sound/soc/s6000/s6000-pcm.c
index 716da86..17f9348 100644
--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -128,7 +128,9 @@ static irqreturn_t s6000_pcm_irq(int irq, void
*data) substream->runtime &&
 		    snd_pcm_running(substream)) {
 			dev_dbg(pcm->dev, "xrun\n");
+			snd_pcm_stream_lock(substream);
 			snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+			snd_pcm_stream_unlock(substream);
 			ret = IRQ_HANDLED;
 		}
 
diff --git a/sound/soc/tegra/tegra30_i2s.c
b/sound/soc/tegra/tegra30_i2s.c index 4418422..b56721a8 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -227,7 +227,7 @@ static int tegra30_i2s_hw_params(struct
snd_pcm_substream *substream, reg = TEGRA30_I2S_CIF_RX_CTRL;
 	} else {
 		val |= TEGRA30_AUDIOCIF_CTRL_DIRECTION_TX;
-		reg = TEGRA30_I2S_CIF_RX_CTRL;
+		reg = TEGRA30_I2S_CIF_TX_CTRL;
 	}
 
 	regmap_write(i2s->regmap, reg, val);
diff --git a/sound/usb/6fire/comm.c b/sound/usb/6fire/comm.c
index 6c3d531..8e68be7 100644
--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -110,19 +110,37 @@ static int usb6fire_comm_send_buffer(u8 *buffer,
struct usb_device *dev) static int usb6fire_comm_write8(struct
comm_runtime *rt, u8 request, u8 reg, u8 value)
 {
-	u8 buffer[13]; /* 13: maximum length of message */
+	u8 *buffer;
+	int ret;
+
+	/* 13: maximum length of message */
+	buffer = kmalloc(13, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
 	usb6fire_comm_init_buffer(buffer, 0x00, request, reg, value,
0x00);
-	return usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+	ret = usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+
+	kfree(buffer);
+	return ret;
 }
 
 static int usb6fire_comm_write16(struct comm_runtime *rt, u8 request,
 		u8 reg, u8 vl, u8 vh)
 {
-	u8 buffer[13]; /* 13: maximum length of message */
+	u8 *buffer;
+	int ret;
+
+	/* 13: maximum length of message */
+	buffer = kmalloc(13, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
 	usb6fire_comm_init_buffer(buffer, 0x00, request, reg, vl, vh);
-	return usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+	ret = usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+
+	kfree(buffer);
+	return ret;
 }
 
 int __devinit usb6fire_comm_init(struct sfire_chip *chip)
@@ -135,6 +153,12 @@ int __devinit usb6fire_comm_init(struct sfire_chip
*chip) if (!rt)
 		return -ENOMEM;
 
+	rt->receiver_buffer = kzalloc(COMM_RECEIVER_BUFSIZE,
GFP_KERNEL);
+	if (!rt->receiver_buffer) {
+		kfree(rt);
+		return -ENOMEM;
+	}
+
 	rt->serial = 1;
 	rt->chip = chip;
 	usb_init_urb(urb);
@@ -152,6 +176,7 @@ int __devinit usb6fire_comm_init(struct sfire_chip
*chip) urb->interval = 1;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(rt->receiver_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create comm data
receiver."); return ret;
@@ -170,6 +195,9 @@ void usb6fire_comm_abort(struct sfire_chip *chip)
 
 void usb6fire_comm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->comm);
+	struct comm_runtime *rt = chip->comm;
+
+	kfree(rt->receiver_buffer);
+	kfree(rt);
 	chip->comm = NULL;
 }
diff --git a/sound/usb/6fire/comm.h b/sound/usb/6fire/comm.h
index d2af0a5..fca24e3 100644
--- a/sound/usb/6fire/comm.h
+++ b/sound/usb/6fire/comm.h
@@ -24,7 +24,7 @@ struct comm_runtime {
 	struct sfire_chip *chip;
 
 	struct urb receiver;
-	u8 receiver_buffer[COMM_RECEIVER_BUFSIZE];
+	u8 *receiver_buffer;
 
 	u8 serial; /* urb serial */
 
diff --git a/sound/usb/6fire/midi.c b/sound/usb/6fire/midi.c
index f0e5179..0c09867 100644
--- a/sound/usb/6fire/midi.c
+++ b/sound/usb/6fire/midi.c
@@ -19,6 +19,10 @@
 #include "chip.h"
 #include "comm.h"
 
+enum {
+	MIDI_BUFSIZE = 64
+};
+
 static void usb6fire_midi_out_handler(struct urb *urb)
 {
 	struct midi_runtime *rt = urb->context;
@@ -156,6 +160,12 @@ int __devinit usb6fire_midi_init(struct sfire_chip
*chip) if (!rt)
 		return -ENOMEM;
 
+	rt->out_buffer = kzalloc(MIDI_BUFSIZE, GFP_KERNEL);
+	if (!rt->out_buffer) {
+		kfree(rt);
+		return -ENOMEM;
+	}
+
 	rt->chip = chip;
 	rt->in_received = usb6fire_midi_in_received;
 	rt->out_buffer[0] = 0x80; /* 'send midi' command */
@@ -169,6 +179,7 @@ int __devinit usb6fire_midi_init(struct sfire_chip
*chip) 
 	ret = snd_rawmidi_new(chip->card, "6FireUSB", 0, 1, 1,
&rt->instance); if (ret < 0) {
+		kfree(rt->out_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "unable to create midi.\n");
 		return ret;
@@ -197,6 +208,9 @@ void usb6fire_midi_abort(struct sfire_chip *chip)
 
 void usb6fire_midi_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->midi);
+	struct midi_runtime *rt = chip->midi;
+
+	kfree(rt->out_buffer);
+	kfree(rt);
 	chip->midi = NULL;
 }
diff --git a/sound/usb/6fire/midi.h b/sound/usb/6fire/midi.h
index 5114ecc..d101ecb 100644
--- a/sound/usb/6fire/midi.h
+++ b/sound/usb/6fire/midi.h
@@ -16,10 +16,6 @@
 
 #include "common.h"
 
-enum {
-	MIDI_BUFSIZE = 64
-};
-
 struct midi_runtime {
 	struct sfire_chip *chip;
 	struct snd_rawmidi *instance;
@@ -32,7 +28,7 @@ struct midi_runtime {
 	struct snd_rawmidi_substream *out;
 	struct urb out_urb;
 	u8 out_serial; /* serial number of out packet */
-	u8 out_buffer[MIDI_BUFSIZE];
+	u8 *out_buffer;
 	int buffer_offset;
 
 	void (*in_received)(struct midi_runtime *rt, u8 *data, int
length); diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index c97d05f..51e3f62f 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -540,7 +540,7 @@ static snd_pcm_uframes_t usb6fire_pcm_pointer(
 	snd_pcm_uframes_t ret;
 
 	if (rt->panic || !sub)
-		return SNDRV_PCM_STATE_XRUN;
+		return SNDRV_PCM_POS_XRUN;
 
 	spin_lock_irqsave(&sub->lock, flags);
 	ret = sub->dma_off;
@@ -578,6 +578,33 @@ static void __devinit usb6fire_pcm_init_urb(struct
pcm_urb *urb, urb->instance.number_of_packets = PCM_N_PACKETS_PER_URB;
 }
 
+static int usb6fire_pcm_buffers_init(struct pcm_runtime *rt)
+{
+	int i;
+
+	for (i = 0; i < PCM_N_URBS; i++) {
+		rt->out_urbs[i].buffer = kzalloc(PCM_N_PACKETS_PER_URB
+				* PCM_MAX_PACKET_SIZE, GFP_KERNEL);
+		if (!rt->out_urbs[i].buffer)
+			return -ENOMEM;
+		rt->in_urbs[i].buffer = kzalloc(PCM_N_PACKETS_PER_URB
+				* PCM_MAX_PACKET_SIZE, GFP_KERNEL);
+		if (!rt->in_urbs[i].buffer)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static void usb6fire_pcm_buffers_destroy(struct pcm_runtime *rt)
+{
+	int i;
+
+	for (i = 0; i < PCM_N_URBS; i++) {
+		kfree(rt->out_urbs[i].buffer);
+		kfree(rt->in_urbs[i].buffer);
+	}
+}
+
 int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 {
 	int i;
@@ -589,6 +616,13 @@ int __devinit usb6fire_pcm_init(struct sfire_chip
*chip) if (!rt)
 		return -ENOMEM;
 
+	ret = usb6fire_pcm_buffers_init(rt);
+	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
+		kfree(rt);
+		return ret;
+	}
+
 	rt->chip = chip;
 	rt->stream_state = STREAM_DISABLED;
 	rt->rate = ARRAY_SIZE(rates);
@@ -610,6 +644,7 @@ int __devinit usb6fire_pcm_init(struct sfire_chip
*chip) 
 	ret = snd_pcm_new(chip->card, "DMX6FireUSB", 0, 1, 1, &pcm);
 	if (ret < 0) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create pcm
instance.\n"); return ret;
@@ -625,6 +660,7 @@ int __devinit usb6fire_pcm_init(struct sfire_chip
*chip) snd_dma_continuous_data(GFP_KERNEL),
 			MAX_BUFSIZE, MAX_BUFSIZE);
 	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX
 				"error preallocating pcm buffers.\n");
@@ -639,17 +675,25 @@ int __devinit usb6fire_pcm_init(struct sfire_chip
*chip) void usb6fire_pcm_abort(struct sfire_chip *chip)
 {
 	struct pcm_runtime *rt = chip->pcm;
+	unsigned long flags;
 	int i;
 
 	if (rt) {
 		rt->panic = true;
 
-		if (rt->playback.instance)
+		if (rt->playback.instance) {
+
snd_pcm_stream_lock_irqsave(rt->playback.instance, flags);
snd_pcm_stop(rt->playback.instance, SNDRV_PCM_STATE_XRUN);
-		if (rt->capture.instance)
+
snd_pcm_stream_unlock_irqrestore(rt->playback.instance, flags);
+		}
+
+		if (rt->capture.instance) {
+
snd_pcm_stream_lock_irqsave(rt->capture.instance, flags);
snd_pcm_stop(rt->capture.instance, SNDRV_PCM_STATE_XRUN);
+
snd_pcm_stream_unlock_irqrestore(rt->capture.instance, flags);
+		}
 
 		for (i = 0; i < PCM_N_URBS; i++) {
 			usb_poison_urb(&rt->in_urbs[i].instance);
@@ -661,6 +705,9 @@ void usb6fire_pcm_abort(struct sfire_chip *chip)
 
 void usb6fire_pcm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->pcm);
+	struct pcm_runtime *rt = chip->pcm;
+
+	usb6fire_pcm_buffers_destroy(rt);
+	kfree(rt);
 	chip->pcm = NULL;
 }
diff --git a/sound/usb/6fire/pcm.h b/sound/usb/6fire/pcm.h
index 3104301..84610cf 100644
--- a/sound/usb/6fire/pcm.h
+++ b/sound/usb/6fire/pcm.h
@@ -32,7 +32,7 @@ struct pcm_urb {
 	struct urb instance;
 	struct usb_iso_packet_descriptor
packets[PCM_N_PACKETS_PER_URB]; /* END DO NOT SEPARATE */
-	u8 buffer[PCM_N_PACKETS_PER_URB * PCM_MAX_PACKET_SIZE];
+	u8 *buffer;
 
 	struct pcm_urb *peer;
 };
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index eafc889..38e9583 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -599,17 +599,16 @@ static int data_ep_set_params(struct
snd_usb_endpoint *ep, ep->stride = frame_bits >> 3;
 	ep->silence_value = format == SNDRV_PCM_FORMAT_U8 ? 0x80 : 0;
 
-	/* calculate max. frequency */
-	if (ep->maxpacksize) {
+	/* assume max. frequency is 25% higher than nominal */
+	ep->freqmax = ep->freqn + (ep->freqn >> 2);
+	maxsize = ((ep->freqmax + 0xffff) * (frame_bits >> 3))
+				>> (16 - ep->datainterval);
+	/* but wMaxPacketSize might reduce this */
+	if (ep->maxpacksize && ep->maxpacksize < maxsize) {
 		/* whatever fits into a max. size packet */
 		maxsize = ep->maxpacksize;
 		ep->freqmax = (maxsize / (frame_bits >> 3))
 				<< (16 - ep->datainterval);
-	} else {
-		/* no max. packet size: just take 25% higher than
nominal */
-		ep->freqmax = ep->freqn + (ep->freqn >> 2);
-		maxsize = ((ep->freqmax + 0xffff) * (frame_bits >> 3))
-				>> (16 - ep->datainterval);
 	}
 
 	if (ep->fill_max)
diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 8b81cb5..d97d35d 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -613,14 +613,24 @@ static int start_usb_playback(struct ua101 *ua)
 
 static void abort_alsa_capture(struct ua101 *ua)
 {
-	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states))
+	unsigned long flags;
+
+	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states)) {
+		snd_pcm_stream_lock_irqsave(ua->capture.substream,
flags); snd_pcm_stop(ua->capture.substream, SNDRV_PCM_STATE_XRUN);
+
snd_pcm_stream_unlock_irqrestore(ua->capture.substream, flags);
+	}
 }
 
 static void abort_alsa_playback(struct ua101 *ua)
 {
-	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states))
+	unsigned long flags;
+
+	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states)) {
+		snd_pcm_stream_lock_irqsave(ua->playback.substream,
flags); snd_pcm_stop(ua->playback.substream, SNDRV_PCM_STATE_XRUN);
+
snd_pcm_stream_unlock_irqrestore(ua->playback.substream, flags);
+	}
 }
 
 static int set_stream_hw(struct ua101 *ua, struct snd_pcm_substream
*substream, diff --git a/sound/usb/usx2y/usbusx2yaudio.c
b/sound/usb/usx2y/usbusx2yaudio.c index 520ef96..43d337d 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -273,7 +273,11 @@ static void usX2Y_clients_stop(struct usX2Ydev
*usX2Y) struct snd_usX2Y_substream *subs = usX2Y->subs[s];
 		if (subs) {
 			if (atomic_read(&subs->state) >=
state_PRERUNNING) {
+				unsigned long flags;
+
+
snd_pcm_stream_lock_irqsave(subs->pcm_substream, flags);
snd_pcm_stop(subs->pcm_substream, SNDRV_PCM_STATE_XRUN);
+
snd_pcm_stream_unlock_irqrestore(subs->pcm_substream, flags); }
 			for (u = 0; u < NRURBS; u++) {
 				struct urb *urb = subs->urb[u];
