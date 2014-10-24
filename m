Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaJXIhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:37:00 -0400
Received: from mail-bl2on0083.outbound.protection.outlook.com ([65.55.169.83]:28704
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755735AbaJXIZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:08 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 06/29] nios2: Memory management
Date: Fri, 24 Oct 2014 16:24:08 +0800
Message-ID: <1414139071-3818-7-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(22564002)(189002)(199003)(50986999)(36756003)(4396001)(50226001)(21056001)(87936001)(106466001)(76176999)(87286001)(88136002)(575784001)(85852003)(86362001)(95666004)(77096002)(20776003)(85306004)(47776003)(89996001)(92566001)(92726001)(62966002)(64706001)(93916002)(2201001)(77156001)(42186005)(105596002)(48376002)(31966008)(102836001)(50466002)(6806004)(229853001)(97736003)(19580395003)(19580405001)(44976005)(68736004)(107046002)(120916001)(104166001)(80022003)(46102003)(76482002)(33646002)(84676001)(99396003)(21314002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB214;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB248;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the initialisation of the memory blocks, MMU
attributes and the memory map.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/mmu.h     |  16 +++
 arch/nios2/include/asm/page.h    | 111 +++++++++++++++++++
 arch/nios2/include/asm/uaccess.h | 231 +++++++++++++++++++++++++++++++++++++++
 arch/nios2/mm/init.c             | 142 ++++++++++++++++++++++++
 arch/nios2/mm/uaccess.c          | 162 +++++++++++++++++++++++++++
 5 files changed, 662 insertions(+)
 create mode 100644 arch/nios2/include/asm/mmu.h
 create mode 100644 arch/nios2/include/asm/page.h
 create mode 100644 arch/nios2/include/asm/uaccess.h
 create mode 100644 arch/nios2/mm/init.c
 create mode 100644 arch/nios2/mm/uaccess.c

diff --git a/arch/nios2/include/asm/mmu.h b/arch/nios2/include/asm/mmu.h
new file mode 100644
index 0000000..d9c0b10
--- /dev/null
+++ b/arch/nios2/include/asm/mmu.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_MMU_H
+#define _ASM_NIOS2_MMU_H
+
+/* Default "unsigned long" context */
+typedef unsigned long mm_context_t;
+
+#endif /* _ASM_NIOS2_MMU_H */
diff --git a/arch/nios2/include/asm/page.h b/arch/nios2/include/asm/page.h
new file mode 100644
index 0000000..7a0d9bd
--- /dev/null
+++ b/arch/nios2/include/asm/page.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * MMU support based on asm/page.h from mips which is:
+ *
+ * Copyright (C) 1994 - 1999, 2000, 03 Ralf Baechle
+ * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_PAGE_H
+#define _ASM_NIOS2_PAGE_H
+
+#include <linux/pfn.h>
+#include <linux/const.h>
+
+/*
+ * PAGE_SHIFT determines the page size
+ */
+#define PAGE_SHIFT	12
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE - 1))
+
+/*
+ * PAGE_OFFSET -- the first address of the first page of memory.
+ */
+#define PAGE_OFFSET	\
+	(CONFIG_NIOS2_MEM_BASE + CONFIG_NIOS2_KERNEL_REGION_BASE)
+
+#ifndef __ASSEMBLY__
+
+/*
+ * This gives the physical RAM offset.
+ */
+#define PHYS_OFFSET		CONFIG_NIOS2_MEM_BASE
+
+/*
+ * It's normally defined only for FLATMEM config but it's
+ * used in our early mem init code for all memory models.
+ * So always define it.
+ */
+#define ARCH_PFN_OFFSET		PFN_UP(PHYS_OFFSET)
+
+#define clear_page(page)	memset((page), 0, PAGE_SIZE)
+#define copy_page(to, from)	memcpy((to), (from), PAGE_SIZE)
+
+struct page;
+
+extern void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
+extern void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
+				struct page *to);
+
+extern unsigned long shm_align_mask;
+
+/*
+ * These are used to make use of C type-checking.
+ */
+typedef struct page *pgtable_t;
+typedef struct { unsigned long pte; } pte_t;
+typedef struct { unsigned long pgd; } pgd_t;
+typedef struct { unsigned long pgprot; } pgprot_t;
+
+#define pte_val(x)	((x).pte)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) })
+#define __pgd(x)	((pgd_t) { (x) })
+#define __pgprot(x)	((pgprot_t) { (x) })
+
+extern unsigned long memory_start;
+extern unsigned long memory_end;
+extern unsigned long memory_size;
+
+extern struct page *mem_map;
+
+#endif /* !__ASSEMBLY__ */
+
+# define __pa(x)		\
+	((unsigned long)(x) - PAGE_OFFSET + PHYS_OFFSET)
+# define __va(x)		\
+	((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))
+
+#define page_to_virt(page)	\
+	((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
+
+# define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
+# define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET &&	\
+					(pfn) < max_mapnr)
+
+# define virt_to_page(vaddr)	pfn_to_page(PFN_DOWN(virt_to_phys(vaddr)))
+# define virt_addr_valid(vaddr)	pfn_valid(PFN_DOWN(virt_to_phys(vaddr)))
+
+# define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
+				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+# define UNCAC_ADDR(addr)	\
+	((void *)((unsigned)(addr) | CONFIG_NIOS2_IO_REGION_BASE))
+# define CAC_ADDR(addr)		\
+	((void *)(((unsigned)(addr) & ~CONFIG_NIOS2_IO_REGION_BASE) |	\
+		CONFIG_NIOS2_KERNEL_REGION_BASE))
+
+#include <asm-generic/memory_model.h>
+
+#include <asm-generic/getorder.h>
+
+#endif /* _ASM_NIOS2_PAGE_H */
diff --git a/arch/nios2/include/asm/uaccess.h b/arch/nios2/include/asm/uaccess.h
new file mode 100644
index 0000000..acedc0a
--- /dev/null
+++ b/arch/nios2/include/asm/uaccess.h
@@ -0,0 +1,231 @@
+/*
+ * User space memory access functions for Nios II
+ *
+ * Copyright (C) 2010-2011, Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009, Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_UACCESS_H
+#define _ASM_NIOS2_UACCESS_H
+
+#include <linux/errno.h>
+#include <linux/thread_info.h>
+#include <linux/string.h>
+
+#include <asm/page.h>
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+struct exception_table_entry {
+	unsigned long insn;
+	unsigned long fixup;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+/*
+ * Segment stuff
+ */
+#define MAKE_MM_SEG(s)		((mm_segment_t) { (s) })
+#define USER_DS			MAKE_MM_SEG(0x80000000UL)
+#define KERNEL_DS		MAKE_MM_SEG(0)
+
+#define get_ds()		(KERNEL_DS)
+
+#define get_fs()		(current_thread_info()->addr_limit)
+#define set_fs(seg)		(current_thread_info()->addr_limit = (seg))
+
+#define segment_eq(a, b)	((a).seg == (b).seg)
+
+#define __access_ok(addr, len)			\
+	(((signed long)(((long)get_fs().seg) &	\
+		((long)(addr) | (((long)(addr)) + (len)) | (len)))) == 0)
+
+#define access_ok(type, addr, len)		\
+	likely(__access_ok((unsigned long)(addr), (unsigned long)(len)))
+
+# define __EX_TABLE_SECTION	".section __ex_table,\"a\"\n"
+
+/*
+ * Zero Userspace
+ */
+
+static inline unsigned long __must_check __clear_user(void __user *to,
+						      unsigned long n)
+{
+	__asm__ __volatile__ (
+		"1:     stb     zero, 0(%1)\n"
+		"       addi    %0, %0, -1\n"
+		"       addi    %1, %1, 1\n"
+		"       bne     %0, zero, 1b\n"
+		"2:\n"
+		__EX_TABLE_SECTION
+		".word  1b, 2b\n"
+		".previous\n"
+		: "=r" (n), "=r" (to)
+		: "0" (n), "1" (to)
+	);
+
+	return n;
+}
+
+static inline unsigned long __must_check clear_user(void __user *to,
+						    unsigned long n)
+{
+	if (!access_ok(VERIFY_WRITE, to, n))
+		return n;
+	return __clear_user(to, n);
+}
+
+extern long __copy_from_user(void *to, const void __user *from,
+				unsigned long n);
+extern long __copy_to_user(void __user *to, const void *from, unsigned long n);
+
+static inline long copy_from_user(void *to, const void __user *from,
+				unsigned long n)
+{
+	if (!access_ok(VERIFY_READ, from, n))
+		return n;
+	return __copy_from_user(to, from, n);
+}
+
+static inline long copy_to_user(void __user *to, const void *from,
+				unsigned long n)
+{
+	if (!access_ok(VERIFY_WRITE, to, n))
+		return n;
+	return __copy_to_user(to, from, n);
+}
+
+extern long strncpy_from_user(char *__to, const char __user *__from,
+				long __len);
+extern long strnlen_user(const char __user *s, long n);
+
+#define __copy_from_user_inatomic	__copy_from_user
+#define __copy_to_user_inatomic		__copy_to_user
+
+/* Optimized macros */
+#define __get_user_asm(val, insn, addr, err)				\
+{									\
+	__asm__ __volatile__(						\
+	"       movi    %0, %3\n"					\
+	"1:   " insn " %1, 0(%2)\n"					\
+	"       movi     %0, 0\n"					\
+	"2:\n"								\
+	"       .section __ex_table,\"a\"\n"				\
+	"       .word 1b, 2b\n"						\
+	"       .previous"						\
+	: "=&r" (err), "=r" (val)					\
+	: "r" (addr), "i" (-EFAULT));					\
+}
+
+#define __get_user_unknown(val, size, ptr, err) do {			\
+	err = 0;							\
+	if (copy_from_user(&(val), ptr, size)) {			\
+		err = -EFAULT;						\
+	}								\
+	} while (0)
+
+#define __get_user_common(val, size, ptr, err)				\
+do {									\
+	switch (size) {							\
+	case 1:								\
+		__get_user_asm(val, "ldbu", ptr, err);			\
+		break;							\
+	case 2:								\
+		__get_user_asm(val, "ldhu", ptr, err);			\
+		break;							\
+	case 4:								\
+		__get_user_asm(val, "ldw", ptr, err);			\
+		break;							\
+	default:							\
+		__get_user_unknown(val, size, ptr, err);		\
+		break;							\
+	}								\
+} while (0)
+
+#define __get_user(x, ptr)						\
+	({								\
+	long __gu_err = -EFAULT;					\
+	const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);		\
+	unsigned long __gu_val;						\
+	__get_user_common(__gu_val, sizeof(*(ptr)), __gu_ptr, __gu_err);\
+	(x) = (__typeof__(x))__gu_val;					\
+	__gu_err;							\
+	})
+
+#define get_user(x, ptr)						\
+({									\
+	long __gu_err = -EFAULT;					\
+	const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);		\
+	unsigned long __gu_val = 0;					\
+	if (access_ok(VERIFY_READ,  __gu_ptr, sizeof(*__gu_ptr)))	\
+		__get_user_common(__gu_val, sizeof(*__gu_ptr),		\
+			__gu_ptr, __gu_err);				\
+	(x) = (__typeof__(x))__gu_val;					\
+	__gu_err;							\
+})
+
+#define __put_user_asm(val, insn, ptr, err)				\
+{									\
+	__asm__ __volatile__(						\
+	"       movi    %0, %3\n"					\
+	"1:   " insn " %1, 0(%2)\n"					\
+	"       movi     %0, 0\n"					\
+	"2:\n"								\
+	"       .section __ex_table,\"a\"\n"				\
+	"       .word 1b, 2b\n"						\
+	"       .previous\n"						\
+	: "=&r" (err)							\
+	: "r" (val), "r" (ptr), "i" (-EFAULT));				\
+}
+
+#define put_user(x, ptr)						\
+({									\
+	long __pu_err = -EFAULT;					\
+	__typeof__(*(ptr)) __user *__pu_ptr = (ptr);			\
+	__typeof__(*(ptr)) __pu_val = (__typeof(*ptr))(x);		\
+	if (access_ok(VERIFY_WRITE, __pu_ptr, sizeof(*__pu_ptr))) {	\
+		switch (sizeof(*__pu_ptr)) {				\
+		case 1:							\
+			__put_user_asm(__pu_val, "stb", __pu_ptr, __pu_err); \
+			break;						\
+		case 2:							\
+			__put_user_asm(__pu_val, "sth", __pu_ptr, __pu_err); \
+			break;						\
+		case 4:							\
+			__put_user_asm(__pu_val, "stw", __pu_ptr, __pu_err); \
+			break;						\
+		default:						\
+			/* XXX: This looks wrong... */			\
+			__pu_err = 0;					\
+			if (copy_to_user(__pu_ptr, &(__pu_val),		\
+				sizeof(*__pu_ptr)))			\
+				__pu_err = -EFAULT;			\
+			break;						\
+		}							\
+	}								\
+	__pu_err;							\
+})
+
+#define __put_user(x, ptr) put_user(x, ptr)
+
+#endif /* _ASM_NIOS2_UACCESS_H */
diff --git a/arch/nios2/mm/init.c b/arch/nios2/mm/init.c
new file mode 100644
index 0000000..e75c75d
--- /dev/null
+++ b/arch/nios2/mm/init.c
@@ -0,0 +1,142 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * based on arch/m68k/mm/init.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/pagemap.h>
+#include <linux/bootmem.h>
+#include <linux/slab.h>
+#include <linux/binfmts.h>
+
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/sections.h>
+#include <asm/tlb.h>
+#include <asm/mmu_context.h>
+#include <asm/cpuinfo.h>
+#include <asm/processor.h>
+
+pgd_t *pgd_current;
+
+/*
+ * paging_init() continues the virtual memory environment setup which
+ * was begun by the code in arch/head.S.
+ * The parameters are pointers to where to stick the starting and ending
+ * addresses of available kernel virtual memory.
+ */
+void __init paging_init(void)
+{
+	unsigned long zones_size[MAX_NR_ZONES];
+
+	memset(zones_size, 0, sizeof(zones_size));
+
+	pagetable_init();
+	pgd_current = swapper_pg_dir;
+
+	zones_size[ZONE_NORMAL] = max_mapnr;
+
+	/* pass the memory from the bootmem allocator to the main allocator */
+	free_area_init(zones_size);
+
+	flush_dcache_range((unsigned long)empty_zero_page,
+			(unsigned long)empty_zero_page + PAGE_SIZE);
+}
+
+void __init mem_init(void)
+{
+	unsigned long end_mem   = memory_end; /* this must not include
+						kernel stack at top */
+
+	pr_debug("mem_init: start=%lx, end=%lx\n", memory_start, memory_end);
+
+	end_mem &= PAGE_MASK;
+	high_memory = __va(end_mem);
+
+	/* this will put all memory onto the freelists */
+	free_all_bootmem();
+	mem_init_print_info(NULL);
+}
+
+void __init mmu_init(void)
+{
+	flush_tlb_all();
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init free_initrd_mem(unsigned long start, unsigned long end)
+{
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
+}
+#endif
+
+void __init_refok free_initmem(void)
+{
+	free_initmem_default(-1);
+}
+
+#define __page_aligned(order) __aligned(PAGE_SIZE << (order))
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned(PGD_ORDER);
+pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
+static struct page *kuser_page[1];
+
+static int alloc_kuser_page(void)
+{
+	extern char __kuser_helper_start[], __kuser_helper_end[];
+	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+	unsigned long vpage;
+
+	vpage = get_zeroed_page(GFP_ATOMIC);
+	if (!vpage)
+		return -ENOMEM;
+
+	/* Copy kuser helpers */
+	memcpy((void *)vpage, __kuser_helper_start, kuser_sz);
+
+	flush_icache_range(vpage, vpage + KUSER_SIZE);
+	kuser_page[0] = virt_to_page(vpage);
+
+	return 0;
+}
+arch_initcall(alloc_kuser_page);
+
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	down_write(&mm->mmap_sem);
+
+	/* Map kuser helpers to user space address */
+	ret = install_special_mapping(mm, KUSER_BASE, KUSER_SIZE,
+				      VM_READ | VM_EXEC | VM_MAYREAD |
+				      VM_MAYEXEC, kuser_page);
+
+	up_write(&mm->mmap_sem);
+
+	return ret;
+}
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	return (vma->vm_start == KUSER_BASE) ? "[kuser]" : NULL;
+}
diff --git a/arch/nios2/mm/uaccess.c b/arch/nios2/mm/uaccess.c
new file mode 100644
index 0000000..4a38ad3
--- /dev/null
+++ b/arch/nios2/mm/uaccess.c
@@ -0,0 +1,162 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009, Wind River Systems Inc
+ * Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ */
+
+#include <linux/export.h>
+#include <linux/uaccess.h>
+
+asm(".global	__copy_from_user\n"
+	"   .type __copy_from_user, @function\n"
+	"__copy_from_user:\n"
+	"   movi  r2,7\n"
+	"   mov   r3,r4\n"
+	"   bge   r2,r6,1f\n"
+	"   xor   r2,r4,r5\n"
+	"   andi  r2,r2,3\n"
+	"   movi  r7,3\n"
+	"   beq   r2,zero,4f\n"
+	"1: addi  r6,r6,-1\n"
+	"   movi  r2,-1\n"
+	"   beq   r6,r2,3f\n"
+	"   mov   r7,r2\n"
+	"2: ldbu  r2,0(r5)\n"
+	"   addi  r6,r6,-1\n"
+	"   addi  r5,r5,1\n"
+	"   stb   r2,0(r3)\n"
+	"   addi  r3,r3,1\n"
+	"   bne   r6,r7,2b\n"
+	"3:\n"
+	"   addi  r2,r6,1\n"
+	"   ret\n"
+	"13:mov   r2,r6\n"
+	"   ret\n"
+	"4: andi  r2,r4,1\n"
+	"   cmpeq r2,r2,zero\n"
+	"   beq   r2,zero,7f\n"
+	"5: andi  r2,r3,2\n"
+	"   beq   r2,zero,6f\n"
+	"9: ldhu  r2,0(r5)\n"
+	"   addi  r6,r6,-2\n"
+	"   addi  r5,r5,2\n"
+	"   sth   r2,0(r3)\n"
+	"   addi  r3,r3,2\n"
+	"6: bge   r7,r6,1b\n"
+	"10:ldw   r2,0(r5)\n"
+	"   addi  r6,r6,-4\n"
+	"   addi  r5,r5,4\n"
+	"   stw   r2,0(r3)\n"
+	"   addi  r3,r3,4\n"
+	"   br    6b\n"
+	"7: ldbu  r2,0(r5)\n"
+	"   addi  r6,r6,-1\n"
+	"   addi  r5,r5,1\n"
+	"   addi  r3,r4,1\n"
+	"   stb   r2,0(r4)\n"
+	"   br    5b\n"
+	".section __ex_table,\"a\"\n"
+	".word 2b,3b\n"
+	".word 9b,13b\n"
+	".word 10b,13b\n"
+	".word 7b,13b\n"
+	".previous\n"
+	);
+EXPORT_SYMBOL(__copy_from_user);
+
+asm(
+	"   .global __copy_to_user\n"
+	"   .type __copy_to_user, @function\n"
+	"__copy_to_user:\n"
+	"   movi  r2,7\n"
+	"   mov   r3,r4\n"
+	"   bge   r2,r6,1f\n"
+	"   xor   r2,r4,r5\n"
+	"   andi  r2,r2,3\n"
+	"   movi  r7,3\n"
+	"   beq   r2,zero,4f\n"
+	/* Bail if we try to copy zero bytes  */
+	"1: addi  r6,r6,-1\n"
+	"   movi  r2,-1\n"
+	"   beq   r6,r2,3f\n"
+	/* Copy byte by byte for small copies and if src^dst != 0 */
+	"   mov   r7,r2\n"
+	"2: ldbu  r2,0(r5)\n"
+	"   addi  r5,r5,1\n"
+	"9: stb   r2,0(r3)\n"
+	"   addi  r6,r6,-1\n"
+	"   addi  r3,r3,1\n"
+	"   bne   r6,r7,2b\n"
+	"3: addi  r2,r6,1\n"
+	"   ret\n"
+	"13:mov   r2,r6\n"
+	"   ret\n"
+	/*  If 'to' is an odd address byte copy */
+	"4: andi  r2,r4,1\n"
+	"   cmpeq r2,r2,zero\n"
+	"   beq   r2,zero,7f\n"
+	/* If 'to' is not divideable by four copy halfwords */
+	"5: andi  r2,r3,2\n"
+	"   beq   r2,zero,6f\n"
+	"   ldhu  r2,0(r5)\n"
+	"   addi  r5,r5,2\n"
+	"10:sth   r2,0(r3)\n"
+	"   addi  r6,r6,-2\n"
+	"   addi  r3,r3,2\n"
+	/* Copy words */
+	"6: bge   r7,r6,1b\n"
+	"   ldw   r2,0(r5)\n"
+	"   addi  r5,r5,4\n"
+	"11:stw   r2,0(r3)\n"
+	"   addi  r6,r6,-4\n"
+	"   addi  r3,r3,4\n"
+	"   br    6b\n"
+	/* Copy remaining bytes */
+	"7: ldbu  r2,0(r5)\n"
+	"   addi  r5,r5,1\n"
+	"   addi  r3,r4,1\n"
+	"12: stb  r2,0(r4)\n"
+	"   addi  r6,r6,-1\n"
+	"   br    5b\n"
+	".section __ex_table,\"a\"\n"
+	".word 9b,3b\n"
+	".word 10b,13b\n"
+	".word 11b,13b\n"
+	".word 12b,13b\n"
+	".previous\n");
+EXPORT_SYMBOL(__copy_to_user);
+
+long strncpy_from_user(char *__to, const char __user *__from, long __len)
+{
+	int l = strnlen_user(__from, __len);
+	int is_zt = 1;
+
+	if (l > __len) {
+		is_zt = 0;
+		l = __len;
+	}
+
+	if (l == 0 || copy_from_user(__to, __from, l))
+		return -EFAULT;
+
+	if (is_zt)
+		l--;
+	return l;
+}
+
+long strnlen_user(const char __user *s, long n)
+{
+	long i;
+
+	for (i = 0; i < n; i++) {
+		char c;
+		if (get_user(c, s + i) == -EFAULT)
+			return 0;
+		if (c == 0)
+			return i + 1;
+	}
+	return n + 1;
+}
-- 
1.8.2.1

