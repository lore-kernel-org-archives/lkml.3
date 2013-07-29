Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab3G2Rby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:31:54 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:33790 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3G2Rbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:31:49 -0400
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2013 13:31:47 EDT
Date: Mon, 29 Jul 2013 19:15:43 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: gregkh@linuxfoundation.org, abyde@acunu.com, brandon@ifup.org,
        ebiederm@xmission.com, grzegorz.milos@gmail.com,
        konrad.wilk@oracle.com, tim@acunu.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, kexec@lists.infradead.org
Cc: daniel.kiper@oracle.com
Subject: [PATCH] kexec/kdump implementation for Xen PV domU
Message-ID: <20130729171543.GA2600@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

Here I am sending as attachments patches enabling kexec/kdump
support in Xen PV domU. Only x84_64 architecture is supported.
There is no support for i386 but some code could be easily reused.
Here is a description of patches:
  - kexec-tools-2.0.3_20120522.patch: patch for kexec-tools
    which cleanly applies to version 2.0.3,
  - kexec-kernel-only_20120522.patch: main kexec/kdump kernel patch;
    it was prepared for quite old custom version of Xen Linux Kernel 2.6.18;
    it should apply to publicly available Xen Linux Kernel 2.6.18 after
    doing some needed changes,
  - kexec-kernel-only_20121119.patch: patch fixes initial boot
    structures overwrites on machines with memory larger than 1 GiB;
    this is partial solution,
  - kexec-kernel-only_20121203.patch: this patch fixes timer
    issue on Amazon EC2 machines.

kexec-tools patch in general implements new xen-pv loader.
It reads vmlinux ELF file (it could be compressed with gzip
but there is no support for bzImage format) build segments
containing kernel, purgatory and needed boot structures
(start_info, initial P2M, initial page table, etc.).
Some required data (P2M table, hypercall page and start_info)
is taken from kernel via sysfs interface. Finaly kexec syscall
is called and all things are placed in relevant place.
Additionally, this patch contains some fixes for issues which
surfaced during work on kexec/kdump support for Xen PV domU
(e.g. ELF notes issues) and minor cleanups.

Linux Kernel code does segments load, stops processors
if needed, destroys pagetables, move pages in P2M table
if needed, etc. Kernel patches contains also some fixes
and minor cleanups.

During work on kexec/kdump support for Xen PV domU there was
an assumption that we could not change anything in hypervisor
or dom0. It led to the situation in which some hacks should be
used. There are two major tricks in regards to CPU, page tables,
LDT and GDT management and CPU stopping during crash.

Xen does not allow you to destroy CPU context if it was started.
This behavior makes a lot of difficulties if SMP system must be
restarted. Every CPU could be stopped by VCPUOP_down but page tables,
LDT and GDT used when VCPUOP_down is executed on given procesor
are locked (e.g. page tables are pinned and they must be unpinned
before destroying them). This way those CPU strutures could not be
destroyed. There is workaround which gives a chance to stop all
unneeded processors in state where relevant structures are owned by
new kernel and there is no need to destroy them. That way all old
kernel structures could be destoyed and new kernel could be started.
However, this leads to the situation in which new system must run
only one CPU (others are stopped in special way). Now I think that
it could be fixed but it requires some work on code stopping all
unneeded CPUs (the final and correct solution should add special
hypercall to destroy a given CPU context; as I remember relevant
code exists in Xen hypervisor but it could not be called from within
guest). This issue does not appear if UP kernel (or configured in
relevant way) runs on SMP PV domU and user executes kexec or kdump.
In that case new kernel could start all CPUs without any issues.

Additionally, due to lack of NMI implementation in PV domU IPIs are
used to stop extra CPUs during crash. This is not very reliable but
it often works. As I know Konrad Wilk and Boris Ostrovsky were working
on NMI implementation and probably this issue was solved in one way
or another.

Last but not least. New kernels store P2M data as 3 level tree instead
of flat array. Hence, exporting P2M via sysfs would not be so easy.

It should be mentioned that this kexec/kdump implementation could not
work if balloon driver is used.

Now as I can see it is not perfect implementation and some things
could be done in different way. However, some ideas are still valid.

I have tried to comment all non obvious things but if you find
something unclear drop me a line.

All code is GPL 2 licensed (http://www.gnu.org/licenses/gpl-2.0.html).
Feel free to base your development on this patchset but please do not
remove any copyrights. Addtionally, I am happy to help anybody who is
interested in work on this stuff.

Big thank you for Acunu Ltd. (http://www.acunu.com/) for
sponsoring initial work on Xen PV domU.

Daniel

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kexec-kernel-only_20120522.patch"

diff -Npru kexec-kernel-only/arch/i386/kernel/time-xen.c kexec-kernel-only_20120522/arch/i386/kernel/time-xen.c
--- kexec-kernel-only/arch/i386/kernel/time-xen.c	2012-01-25 14:15:45.000000000 +0100
+++ kexec-kernel-only_20120522/arch/i386/kernel/time-xen.c	2012-05-21 13:05:16.000000000 +0200
@@ -1072,10 +1072,11 @@ int local_setup_timer(unsigned int cpu)
 
 	return 0;
 }
+#endif
 
+#if defined(CONFIG_SMP) || defined(CONFIG_KEXEC)
 void local_teardown_timer(unsigned int cpu)
 {
-	BUG_ON(cpu == 0);
 	unbind_from_irqhandler(per_cpu(timer_irq, cpu), NULL);
 }
 #endif
diff -Npru kexec-kernel-only/arch/i386/mm/hypervisor.c kexec-kernel-only_20120522/arch/i386/mm/hypervisor.c
--- kexec-kernel-only/arch/i386/mm/hypervisor.c	2012-01-25 14:15:45.000000000 +0100
+++ kexec-kernel-only_20120522/arch/i386/mm/hypervisor.c	2012-02-22 16:20:31.000000000 +0100
@@ -392,6 +392,7 @@ void xen_destroy_contiguous_region(unsig
 
 	balloon_unlock(flags);
 }
+EXPORT_SYMBOL_GPL(xen_destroy_contiguous_region);
 
 #ifdef __i386__
 int write_ldt_entry(void *ldt, int entry, __u32 entry_a, __u32 entry_b)
diff -Npru kexec-kernel-only/arch/x86_64/Kconfig kexec-kernel-only_20120522/arch/x86_64/Kconfig
--- kexec-kernel-only/arch/x86_64/Kconfig	2012-01-25 14:15:38.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/Kconfig	2012-05-22 12:59:53.000000000 +0200
@@ -589,6 +589,12 @@ config CRASH_DUMP
 	help
 		Generate crash dump after being started by kexec.
 
+config PHYSICAL_START
+	hex "Physical address where the kernel is loaded" if CRASH_DUMP
+	default "0x200000"
+	---help---
+	  This gives the physical address where the kernel is loaded.
+
 config SECCOMP
 	bool "Enable seccomp to safely compute untrusted bytecode"
 	depends on PROC_FS
diff -Npru kexec-kernel-only/arch/x86_64/kernel/crash.c kexec-kernel-only_20120522/arch/x86_64/kernel/crash.c
--- kexec-kernel-only/arch/x86_64/kernel/crash.c	2012-01-25 14:15:33.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/crash.c	2012-05-20 16:53:52.000000000 +0200
@@ -231,6 +231,9 @@ void machine_crash_shutdown(struct pt_re
 		printk(KERN_CRIT "CFG = %x\n", cfg);
 		pci_write_config_dword(mcp55_rewrite, 0x74, cfg);
 	}
+#else
+	if (!is_initial_xendomain())
+		xen_pv_kexec_smp_send_stop();
 #endif /* CONFIG_XEN */
 	crash_save_self(regs);
 }
diff -Npru kexec-kernel-only/arch/x86_64/kernel/crash_dump.c kexec-kernel-only_20120522/arch/x86_64/kernel/crash_dump.c
--- kexec-kernel-only/arch/x86_64/kernel/crash_dump.c	2006-09-20 05:42:06.000000000 +0200
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/crash_dump.c	2012-05-21 18:43:13.000000000 +0200
@@ -7,9 +7,74 @@
 
 #include <linux/errno.h>
 #include <linux/crash_dump.h>
+#include <linux/mm.h>
+#include <linux/pfn.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm/hypercall.h>
+#include <asm/pgtable.h>
+
+#ifdef CONFIG_XEN
+static void *map_oldmem_page(unsigned long pfn)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	struct vm_struct *area;
+
+	area = get_vm_area(PAGE_SIZE, VM_IOREMAP);
+
+	if (!area)
+		return NULL;
+
+	pgd = pgd_offset_k((unsigned long)area->addr);
+
+	pud = pud_alloc(&init_mm, pgd, (unsigned long)area->addr);
+
+	if (!pud)
+		goto err;
+
+	pmd = pmd_alloc(&init_mm, pud, (unsigned long)area->addr);
+
+	if (!pmd)
+		goto err;
+
+	pte = pte_alloc_kernel(pmd, (unsigned long)area->addr);
+
+	if (!pte)
+		goto err;
+
+	if (HYPERVISOR_update_va_mapping((unsigned long)area->addr,
+						pfn_pte_ma(pfn_to_mfn(pfn),
+								PAGE_KERNEL_RO), 0))
+		goto err;
+
+	return area->addr;
+
+err:
+	vunmap(area->addr);
+
+	return NULL;
+}
+
+static void unmap_oldmem_page(void *ptr)
+{
+	vunmap(ptr);
+}
+#else
+static void *map_oldmem_page(unsigned long pfn)
+{
+	return ioremap(PFN_PHYS(pfn), PAGE_SIZE);
+}
+
+static void unmap_oldmem_page(void *ptr)
+{
+	iounmap(ptr);
+}
+#endif /* CONFIG_XEN */
 
 /**
  * copy_oldmem_page - copy one page from "oldmem"
@@ -32,16 +97,29 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+#ifdef CONFIG_XEN
+	if (!phys_to_machine_mapping_valid(pfn)) {
+		memset(buf, 0, csize);
+		return csize;
+	}
+#endif
+
+	vaddr = map_oldmem_page(pfn);
+
+	if (!vaddr) {
+		memset(buf, 0, csize);
+		return csize;
+	}
 
 	if (userbuf) {
 		if (copy_to_user(buf, (vaddr + offset), csize)) {
-			iounmap(vaddr);
+			unmap_oldmem_page(vaddr);
 			return -EFAULT;
 		}
 	} else
-	memcpy(buf, (vaddr + offset), csize);
+		memcpy(buf, (vaddr + offset), csize);
+	
+	unmap_oldmem_page(vaddr);
 
-	iounmap(vaddr);
 	return csize;
 }
diff -Npru kexec-kernel-only/arch/x86_64/kernel/e820-xen.c kexec-kernel-only_20120522/arch/x86_64/kernel/e820-xen.c
--- kexec-kernel-only/arch/x86_64/kernel/e820-xen.c	2012-01-25 14:15:30.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/e820-xen.c	2012-05-21 19:17:52.000000000 +0200
@@ -125,6 +125,7 @@ e820_any_mapped(unsigned long start, uns
 	} 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(e820_any_mapped);
 
 /*
  * This function checks if the entire range <start,end> is mapped with type.
@@ -315,10 +316,10 @@ void __init e820_reserve_resources(struc
 			 *  so we try it repeatedly and let the resource manager
 			 *  test it.
 			 */
-#ifndef CONFIG_XEN
-			request_resource(res, &code_resource);
-			request_resource(res, &data_resource);
-#endif
+			if (!is_initial_xendomain()) {
+				request_resource(res, &code_resource);
+				request_resource(res, &data_resource);
+			}
 #ifdef CONFIG_KEXEC
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
diff -Npru kexec-kernel-only/arch/x86_64/kernel/head-xen.S kexec-kernel-only_20120522/arch/x86_64/kernel/head-xen.S
--- kexec-kernel-only/arch/x86_64/kernel/head-xen.S	2012-01-25 14:15:04.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/head-xen.S	2012-05-22 13:01:35.000000000 +0200
@@ -89,7 +89,7 @@ NEXT_PAGE(hypercall_page)
 
 	.data
 
-	.align 16
+	.align PAGE_SIZE
 	.globl cpu_gdt_descr
 cpu_gdt_descr:
 	.word	gdt_end-cpu_gdt_table-1
@@ -166,7 +166,7 @@ ENTRY(empty_zero_page)
 	.ascii	",ELF_PADDR_OFFSET=0x"
 		utoh __START_KERNEL_map
 	.ascii	",VIRT_ENTRY=0x"
-		utoh (__START_KERNEL_map + 0x200000 + VIRT_ENTRY_OFFSET)
+		utoh (__START_KERNEL_map + CONFIG_PHYSICAL_START + VIRT_ENTRY_OFFSET)
 	.ascii	",HYPERCALL_PAGE=0x"
 		utoh (phys_hypercall_page >> PAGE_SHIFT)
 	.ascii  ",FEATURES=writable_page_tables"
diff -Npru kexec-kernel-only/arch/x86_64/kernel/machine_kexec.c kexec-kernel-only_20120522/arch/x86_64/kernel/machine_kexec.c
--- kexec-kernel-only/arch/x86_64/kernel/machine_kexec.c	2012-01-25 14:15:17.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/machine_kexec.c	2012-05-22 14:37:25.000000000 +0200
@@ -1,9 +1,27 @@
 /*
- * machine_kexec.c - handle transition of Linux booting another kernel
  * Copyright (C) 2002-2005 Eric Biederman  <ebiederm@xmission.com>
+ * Copyright (c) 2011-2012 Acunu Limited
  *
- * This source code is licensed under the GNU General Public License,
- * Version 2.  See the file COPYING for more details.
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #include <linux/mm.h>
@@ -11,20 +29,16 @@
 #include <linux/string.h>
 #include <linux/reboot.h>
 #include <linux/numa.h>
+#include <linux/bootmem.h>
+#include <linux/pfn.h>
+
+#include <xen/hypercall.h>
+
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
 
-#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
-static u64 kexec_pgd[512] PAGE_ALIGNED;
-static u64 kexec_pud0[512] PAGE_ALIGNED;
-static u64 kexec_pmd0[512] PAGE_ALIGNED;
-static u64 kexec_pte0[512] PAGE_ALIGNED;
-static u64 kexec_pud1[512] PAGE_ALIGNED;
-static u64 kexec_pmd1[512] PAGE_ALIGNED;
-static u64 kexec_pte1[512] PAGE_ALIGNED;
-
 #ifdef CONFIG_XEN
 
 /* In the case of Xen, override hypervisor functions to be able to create
@@ -34,17 +48,37 @@ static u64 kexec_pte1[512] PAGE_ALIGNED;
 #include <xen/interface/kexec.h>
 #include <xen/interface/memory.h>
 
+#define x__pte(x) ((pte_t) { (x) } )
 #define x__pmd(x) ((pmd_t) { (x) } )
 #define x__pud(x) ((pud_t) { (x) } )
 #define x__pgd(x) ((pgd_t) { (x) } )
 
+#define x_pte_val(x)   ((x).pte)
 #define x_pmd_val(x)   ((x).pmd)
 #define x_pud_val(x)   ((x).pud)
 #define x_pgd_val(x)   ((x).pgd)
 
+static inline void x_set_pte(pte_t *dst, pte_t val)
+{
+	x_pte_val(*dst) = phys_to_machine(x_pte_val(val));
+}
+
+static inline void x_pte_clear(pte_t *pte)
+{
+	x_pte_val(*pte) = 0;
+}
+
 static inline void x_set_pmd(pmd_t *dst, pmd_t val)
 {
-	x_pmd_val(*dst) = x_pmd_val(val);
+	if (is_initial_xendomain())
+		x_pmd_val(*dst) = x_pmd_val(val);
+	else
+		x_pmd_val(*dst) = phys_to_machine(x_pmd_val(val));
+}
+
+static inline void x_pmd_clear(pmd_t *pmd)
+{
+	x_pmd_val(*pmd) = 0;
 }
 
 static inline void x_set_pud(pud_t *dst, pud_t val)
@@ -67,11 +101,12 @@ static inline void x_pgd_clear (pgd_t * 
 	x_pgd_val(*pgd) = 0;
 }
 
+#define X__PAGE_KERNEL_EXEC \
+         _PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED
 #define X__PAGE_KERNEL_LARGE_EXEC \
          _PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_PSE
 #define X_KERNPG_TABLE _PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY
-
-#define __ma(x) (pfn_to_mfn(__pa((x)) >> PAGE_SHIFT) << PAGE_SHIFT)
+#define X_KERNPG_TABLE_RO _PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_DIRTY
 
 #if PAGES_NR > KEXEC_XEN_NO_PAGES
 #error PAGES_NR is greater than KEXEC_XEN_NO_PAGES - Xen support will break
@@ -81,28 +116,322 @@ static inline void x_pgd_clear (pgd_t * 
 #error PA_CONTROL_PAGE is non zero - Xen support will break
 #endif
 
+#define UPDATE_VA_MAPPING_BATCH	8
+
+#define M2P_UPDATES_SIZE	4
+
+typedef int (*update_pgprot_t)(int cpu, int flush, pgd_t *pgd, unsigned long paddr, pgprot_t pgprot);
+
+/* We need this to fix xenstore and console mapping. */
+static struct mmu_update m2p_updates[M2P_UPDATES_SIZE];
+
+static DEFINE_PER_CPU(multicall_entry_t[UPDATE_VA_MAPPING_BATCH], pb_mcl);
+
+static void remap_page(pgd_t *pgd, unsigned long paddr, unsigned long maddr)
+{
+	pmd_t *pmd;
+	pud_t *pud;
+	pte_t *pte;
+
+	pud = __va(pgd_val(pgd[pgd_index(paddr)]) & PHYSICAL_PAGE_MASK);
+	pmd = __va(pud_val(pud[pud_index(paddr)]) & PHYSICAL_PAGE_MASK);
+	pte = __va(pmd_val(pmd[pmd_index(paddr)]) & PHYSICAL_PAGE_MASK);
+	pte = &pte[pte_index(paddr)];
+
+	x_set_pte(pte, x__pte(machine_to_phys(maddr) |
+				(x_pte_val(*pte) & ~PHYSICAL_PAGE_MASK)));
+}
+
+static int native_page_set_prot(int cpu, int flush, pgd_t *pgd, unsigned long paddr, pgprot_t pgprot)
+{
+	pmd_t *pmd;
+	pud_t *pud;
+	pte_t *pte;
+
+	pud = __va(pgd_val(pgd[pgd_index(paddr)]) & PHYSICAL_PAGE_MASK);
+	pmd = __va(pud_val(pud[pud_index(paddr)]) & PHYSICAL_PAGE_MASK);
+	pte = __va(pmd_val(pmd[pmd_index(paddr)]) & PHYSICAL_PAGE_MASK);
+	pte = &pte[pte_index(paddr)];
+
+	x_set_pte(pte, x__pte(paddr | pgprot_val(pgprot)));
+
+	return 0;
+}
+
+static int xen_page_set_prot(int cpu, int flush, pgd_t *pgd, unsigned long paddr, pgprot_t pgprot)
+{
+	int result = 0;
+	static int seq = 0;
+
+	MULTI_update_va_mapping(per_cpu(pb_mcl, cpu) + seq++, (unsigned long)__va(paddr),
+				pfn_pte(PFN_DOWN(paddr), pgprot), UVMF_INVLPG | UVMF_ALL);
+
+	if (unlikely(seq == UPDATE_VA_MAPPING_BATCH || flush)) {
+		result = HYPERVISOR_multicall_check(per_cpu(pb_mcl, cpu), seq, NULL);
+		seq = 0;
+		if (unlikely(result))
+			pr_info("kexec: %s: HYPERVISOR_multicall_check() failed: %i\n",
+					__func__, result);
+	}
+
+	return result;
+}
+
+static int pgtable_walk(pgd_t *pgds, pgd_t *pgdd,
+			update_pgprot_t update_pgprot,
+			pgprot_t pgprot)
+{
+	int cpu, i, j, k, result;
+	pmd_t *pmd;
+	pud_t *pud;
+	unsigned long paddr;
+
+	cpu = get_cpu();
+
+	for (i = 0; i < PTRS_PER_PGD; ++i) {
+		/* Skip Xen mappings. */
+		if (i == ROOT_PAGETABLE_FIRST_XEN_SLOT)
+			i += ROOT_PAGETABLE_XEN_SLOTS;
+
+		if (pgd_none(pgds[i]))
+			continue;
+
+		paddr = pgd_val(pgds[i]) & PHYSICAL_PAGE_MASK;
+		pud = __va(paddr);
+
+		result = (*update_pgprot)(cpu, 0, pgdd, paddr, pgprot);
+
+		if (result)
+			goto err;
+
+		for (j = 0; j < PTRS_PER_PUD; ++j) {
+			if (pud_none(pud[j]))
+				continue;
+
+			paddr = pud_val(pud[j]) & PHYSICAL_PAGE_MASK;
+			pmd = __va(paddr);
+
+			result = (*update_pgprot)(cpu, 0, pgdd, paddr, pgprot);
+
+			if (result)
+				goto err;
+
+			for (k = 0; k < PTRS_PER_PMD; ++k) {
+				if (pmd_none(pmd[k]))
+					continue;
+
+				paddr = pmd_val(pmd[k]) & PHYSICAL_PAGE_MASK;
+
+				result = (*update_pgprot)(cpu, 0, pgdd, paddr, pgprot);
+
+				if (result)
+					goto err;
+			}
+		}
+	}
+
+	result = (*update_pgprot)(cpu, 1, pgdd, __pa(pgds), pgprot);
+
+err:
+	put_cpu();
+
+	return result;
+}
+
+static int init_transition_pgtable(struct kimage *image)
+{
+	int result;
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pud_t *pud;
+	pte_t *pte;
+	struct mmuext_op pin_op;
+	unsigned long addr;
+
+	/* Map control page at its virtual address. */
+	addr = (unsigned long)page_address(image->control_code_page) + PAGE_SIZE;
+
+	pgd = (pgd_t *)&image->pgd[pgd_index(addr)];
+	x_set_pgd(pgd, x__pgd(__pa(image->pud0) | X_KERNPG_TABLE));
+
+	pud = (pud_t *)&image->pud0[pud_index(addr)];
+	x_set_pud(pud, x__pud(__pa(image->pmd0) | X_KERNPG_TABLE));
+
+	pmd = (pmd_t *)&image->pmd0[pmd_index(addr)];
+	x_set_pmd(pmd, x__pmd(__pa(image->pte0) | X_KERNPG_TABLE));
+
+	pte = (pte_t *)&image->pte0[pte_index(addr)];
+	x_set_pte(pte, x__pte(__pa(addr) | X__PAGE_KERNEL_EXEC));
+
+	/* Map control page at its physical address. */
+	addr = __pa(addr);
+
+	pgd = (pgd_t *)&image->pgd[pgd_index(addr)];
+	x_set_pgd(pgd, x__pgd(__pa(image->pud1) | X_KERNPG_TABLE));
+
+	pud = (pud_t *)&image->pud1[pud_index(addr)];
+	x_set_pud(pud, x__pud(__pa(image->pmd1) | X_KERNPG_TABLE));
+
+	pmd = (pmd_t *)&image->pmd1[pmd_index(addr)];
+	x_set_pmd(pmd, x__pmd(__pa(image->pte1) | X_KERNPG_TABLE));
+
+	pte = (pte_t *)&image->pte1[pte_index(addr)];
+	x_set_pte(pte, x__pte(addr | X__PAGE_KERNEL_EXEC));
+
+	result = pgtable_walk((pgd_t *)image->pgd, NULL,
+				xen_page_set_prot, PAGE_KERNEL_RO);
+
+	if (result)
+		return result;
+
+	pin_op.cmd = MMUEXT_PIN_L4_TABLE;
+	pin_op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(image->pgd)));
+
+	result = HYPERVISOR_mmuext_op(&pin_op, 1, NULL, DOMID_SELF);
+
+	if (result)
+		pr_info("kexec: %s: HYPERVISOR_mmuext_op() failed: %i\n",
+				__func__, result);
+
+	return result;
+}
+
+static int destroy_transition_pgtable(struct kimage *image)
+{
+	int result;
+	struct mmuext_op unpin_op;
+
+	unpin_op.cmd = MMUEXT_UNPIN_TABLE;
+	unpin_op.arg1.mfn = pfn_to_mfn(PFN_DOWN(__pa(image->pgd)));
+
+	result = HYPERVISOR_mmuext_op(&unpin_op, 1, NULL, DOMID_SELF);
+
+	if (result) {
+		pr_info("kexec: %s: HYPERVISOR_mmuext_op() failed: %i\n",
+				__func__, result);
+		return result;
+	}
+
+	return pgtable_walk((pgd_t *)image->pgd, NULL,
+				xen_page_set_prot, PAGE_KERNEL);
+}
+
+static int is_new_start_info(start_info_t *new_start_info)
+{
+	/* Is it new start info? */
+	if (memcmp(new_start_info->magic, xen_start_info->magic,
+						sizeof(new_start_info->magic)))
+		return 0;
+
+	/* It looks like new start info but double check it... */
+	if (new_start_info->store_mfn != xen_start_info->store_mfn)
+		return 0;
+
+	if (new_start_info->console.domU.mfn != xen_start_info->console.domU.mfn)
+		return 0;
+
+	/*
+	 * Here we are almost sure that
+	 * we have found new start info.
+	 */
+	return 1;
+}
+
+/*
+ * Magic pages are behind start info.
+ * This assumption was made in kexec-tools,
+ * xen-pv loader.
+ */
+
+static unsigned long find_magic_pages(struct kimage *image)
+{
+	unsigned long i, segment_start;
+
+	for (i = image->nr_segments - 1; i; --i) {
+		segment_start = image->segment[i].mem;
+
+		if (!is_new_start_info(__va(segment_start)))
+			continue;
+
+		return segment_start + PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+/*
+ * Remap xenstore and console pages (in this order).
+ * This function depends on assumptions made
+ * in kexec-tools, xen-pv loader.
+ */
+
+static void remap_magic_pages(struct kimage *image, pgd_t *pgd)
+{
+	unsigned long magic_paddr;
+
+	memset(m2p_updates, 0, sizeof(m2p_updates));
+
+	magic_paddr = find_magic_pages(image);
+
+	if (!magic_paddr)
+		return;
+
+	/* Remap xenstore page. */
+	remap_page(pgd, magic_paddr, PFN_PHYS(xen_start_info->store_mfn));
+	remap_page(pgd, PFN_PHYS(mfn_to_pfn(xen_start_info->store_mfn)),
+						phys_to_machine(magic_paddr));
+
+	m2p_updates[0].ptr = PFN_PHYS(xen_start_info->store_mfn);
+	m2p_updates[0].ptr |= MMU_MACHPHYS_UPDATE;
+	m2p_updates[0].val = PFN_DOWN(magic_paddr);
+
+	m2p_updates[1].ptr = phys_to_machine(magic_paddr);
+	m2p_updates[1].ptr |= MMU_MACHPHYS_UPDATE;
+	m2p_updates[1].val = mfn_to_pfn(xen_start_info->store_mfn);
+
+	magic_paddr += PAGE_SIZE;
+
+	/* Remap console page. */
+	remap_page(pgd, magic_paddr, PFN_PHYS(xen_start_info->console.domU.mfn));
+	remap_page(pgd, PFN_PHYS(mfn_to_pfn(xen_start_info->console.domU.mfn)),
+						phys_to_machine(magic_paddr));
+
+	m2p_updates[2].ptr = PFN_PHYS(xen_start_info->console.domU.mfn);
+	m2p_updates[2].ptr |= MMU_MACHPHYS_UPDATE;
+	m2p_updates[2].val = PFN_DOWN(magic_paddr);
+
+	m2p_updates[3].ptr = phys_to_machine(magic_paddr);
+	m2p_updates[3].ptr |= MMU_MACHPHYS_UPDATE;
+	m2p_updates[3].val = mfn_to_pfn(xen_start_info->console.domU.mfn);
+}
+
 void machine_kexec_setup_load_arg(xen_kexec_image_t *xki, struct kimage *image)
 {
 	void *control_page;
 	void *table_page;
 
+	table_page = page_address(image->control_code_page);
+
+	if (!is_initial_xendomain()) {
+		remap_magic_pages(image, table_page);
+		return;
+	}
+
 	memset(xki->page_list, 0, sizeof(xki->page_list));
 
 	control_page = page_address(image->control_code_page) + PAGE_SIZE;
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
 
-	table_page = page_address(image->control_code_page);
-
-	xki->page_list[PA_CONTROL_PAGE] = __ma(control_page);
-	xki->page_list[PA_TABLE_PAGE] = __ma(table_page);
+	xki->page_list[PA_CONTROL_PAGE] = virt_to_machine(control_page);
+	xki->page_list[PA_TABLE_PAGE] = virt_to_machine(table_page);
 
-	xki->page_list[PA_PGD] = __ma(kexec_pgd);
-	xki->page_list[PA_PUD_0] = __ma(kexec_pud0);
-	xki->page_list[PA_PUD_1] = __ma(kexec_pud1);
-	xki->page_list[PA_PMD_0] = __ma(kexec_pmd0);
-	xki->page_list[PA_PMD_1] = __ma(kexec_pmd1);
-	xki->page_list[PA_PTE_0] = __ma(kexec_pte0);
-	xki->page_list[PA_PTE_1] = __ma(kexec_pte1);
+	xki->page_list[PA_PGD] = virt_to_machine(image->pgd);
+	xki->page_list[PA_PUD_0] = virt_to_machine(image->pud0);
+	xki->page_list[PA_PUD_1] = virt_to_machine(image->pud1);
+	xki->page_list[PA_PMD_0] = virt_to_machine(image->pmd0);
+	xki->page_list[PA_PMD_1] = virt_to_machine(image->pmd1);
+	xki->page_list[PA_PTE_0] = virt_to_machine(image->pte0);
+	xki->page_list[PA_PTE_1] = virt_to_machine(image->pte1);
 }
 
 #else /* CONFIG_XEN */
@@ -123,16 +452,60 @@ void machine_kexec_setup_load_arg(xen_ke
 
 #endif /* CONFIG_XEN */
 
-static void init_level2_page(pmd_t *level2p, unsigned long addr)
+#ifdef CONFIG_XEN
+static void init_level1_page(pte_t *level1p, unsigned long addr)
 {
 	unsigned long end_addr;
 
 	addr &= PAGE_MASK;
+	end_addr = addr + PMD_SIZE;
+	while (addr < end_addr) {
+		x_set_pte(level1p++, x__pte(addr | X__PAGE_KERNEL_EXEC));
+		addr += PAGE_SIZE;
+	}
+}
+#endif
+
+static int init_level2_page(struct kimage *image, pmd_t *level2p,
+				unsigned long addr, unsigned long last_addr)
+{
+	unsigned long end_addr;
+	int result = 0;
+
+	addr &= PAGE_MASK;
 	end_addr = addr + PUD_SIZE;
+
+	if (is_initial_xendomain()) {
+		while (addr < end_addr) {
+			x_set_pmd(level2p++, x__pmd(addr | X__PAGE_KERNEL_LARGE_EXEC));
+			addr += PMD_SIZE;
+		}
+		return 0;
+	}
+
+#ifdef CONFIG_XEN
+	while ((addr < last_addr) && (addr < end_addr)) {
+		struct page *page;
+		pte_t *level1p;
+
+		page = kimage_alloc_control_pages(image, 0);
+		if (!page) {
+			result = -ENOMEM;
+			goto out;
+		}
+		level1p = (pte_t *)page_address(page);
+		init_level1_page(level1p, addr);
+		x_set_pmd(level2p++, x__pmd(__pa(level1p) | X_KERNPG_TABLE));
+		addr += PMD_SIZE;
+	}
+	/* clear the unused entries */
 	while (addr < end_addr) {
-		x_set_pmd(level2p++, x__pmd(addr | X__PAGE_KERNEL_LARGE_EXEC));
+		x_pmd_clear(level2p++);
 		addr += PMD_SIZE;
 	}
+out:
+	return result;
+#endif
 }
 
 static int init_level3_page(struct kimage *image, pud_t *level3p,
@@ -154,7 +527,7 @@ static int init_level3_page(struct kimag
 			goto out;
 		}
 		level2p = (pmd_t *)page_address(page);
-		init_level2_page(level2p, addr);
+		init_level2_page(image, level2p, addr, last_addr);
 		x_set_pud(level3p++, x__pud(__pa(level2p) | X_KERNPG_TABLE));
 		addr += PUD_SIZE;
 	}
@@ -167,7 +540,6 @@ out:
 	return result;
 }
 
-
 static int init_level4_page(struct kimage *image, pgd_t *level4p,
 				unsigned long addr, unsigned long last_addr)
 {
@@ -203,39 +575,112 @@ out:
 	return result;
 }
 
-
-static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
+#ifdef CONFIG_XEN
+static int init_pgtable(struct kimage *image, pgd_t *level4p)
 {
-	pgd_t *level4p;
-	unsigned long x_end_pfn = end_pfn;
+	int result;
+	unsigned long x_max_pfn;
 
-#ifdef CONFIG_XEN
-	x_end_pfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
-#endif
+	if (is_initial_xendomain())
+		x_max_pfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
+	else {
+		result = init_transition_pgtable(image);
 
-	level4p = (pgd_t *)__va(start_pgtable);
- 	return init_level4_page(image, level4p, 0, x_end_pfn << PAGE_SHIFT);
-}
+		if (result)
+			return result;
 
-int machine_kexec_prepare(struct kimage *image)
-{
-	unsigned long start_pgtable;
-	int result;
+		x_max_pfn = min(xen_start_info->nr_pages, max_pfn);
+	}
 
-	/* Calculate the offsets */
-	start_pgtable = page_to_pfn(image->control_code_page) << PAGE_SHIFT;
+	result = init_level4_page(image, level4p, 0, PFN_PHYS(x_max_pfn));
 
-	/* Setup the identity mapped 64bit page table */
-	result = init_pgtable(image, start_pgtable);
 	if (result)
 		return result;
 
+	if (!is_initial_xendomain()) {
+		pgtable_walk(level4p, level4p, native_page_set_prot,
+				__pgprot(X_KERNPG_TABLE_RO));
+		pgtable_walk((pgd_t *)image->pgd, level4p, native_page_set_prot,
+				__pgprot(X_KERNPG_TABLE_RO));
+	}
+
 	return 0;
 }
+#else
+static int init_pgtable(struct kimage *image, pgd_t *level4p)
+{
+	/* Setup the identity mapped 64bit page table */
+ 	return init_level4_page(image, level4p, 0, PFN_PHYS(max_pfn));
+}
+#endif  /* CONFIG_XEN */
+
+static void free_transition_pgtable(struct kimage *image)
+{
+	free_page((unsigned long)image->pgd);
+	free_page((unsigned long)image->pud0);
+	free_page((unsigned long)image->pud1);
+	free_page((unsigned long)image->pmd0);
+	free_page((unsigned long)image->pmd1);
+	free_page((unsigned long)image->pte0);
+	free_page((unsigned long)image->pte1);
+}
+
+int machine_kexec_prepare(struct kimage *image)
+{
+	image->pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->pgd)
+		goto err;
+
+	image->pud0 = (pud_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->pud0)
+		goto err;
+
+	image->pud1 = (pud_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->pud1)
+		goto err;
+
+	image->pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->pmd0)
+		goto err;
+
+	image->pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->pmd1)
+		goto err;
+
+	image->pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->pte0)
+		goto err;
+
+	image->pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->pte1)
+		goto err;
+
+	return init_pgtable(image, page_address(image->control_code_page));
+
+err:
+	free_transition_pgtable(image);
+
+	return -ENOMEM;
+}
 
 void machine_kexec_cleanup(struct kimage *image)
 {
-	return;
+#ifdef CONFIG_XEN
+	if (is_initial_xendomain())
+		free_transition_pgtable(image);
+	else
+		if (!destroy_transition_pgtable(image))
+			free_transition_pgtable(image);
+#else
+	free_transition_pgtable(image);
+#endif
 }
 
 void arch_crash_save_vmcoreinfo(void)
@@ -267,20 +712,20 @@ NORET_TYPE void machine_kexec(struct kim
 
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
 	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
-	page_list[PA_PGD] = __pa_symbol(&kexec_pgd);
-	page_list[VA_PGD] = (unsigned long)kexec_pgd;
-	page_list[PA_PUD_0] = __pa_symbol(&kexec_pud0);
-	page_list[VA_PUD_0] = (unsigned long)kexec_pud0;
-	page_list[PA_PMD_0] = __pa_symbol(&kexec_pmd0);
-	page_list[VA_PMD_0] = (unsigned long)kexec_pmd0;
-	page_list[PA_PTE_0] = __pa_symbol(&kexec_pte0);
-	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
-	page_list[PA_PUD_1] = __pa_symbol(&kexec_pud1);
-	page_list[VA_PUD_1] = (unsigned long)kexec_pud1;
-	page_list[PA_PMD_1] = __pa_symbol(&kexec_pmd1);
-	page_list[VA_PMD_1] = (unsigned long)kexec_pmd1;
-	page_list[PA_PTE_1] = __pa_symbol(&kexec_pte1);
-	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_PGD] = __pa_symbol(&image->pgd);
+	page_list[VA_PGD] = (unsigned long)image->pgd;
+	page_list[PA_PUD_0] = __pa_symbol(&image->pud0);
+	page_list[VA_PUD_0] = (unsigned long)image->pud0;
+	page_list[PA_PMD_0] = __pa_symbol(&image->pmd0);
+	page_list[VA_PMD_0] = (unsigned long)image->pmd0;
+	page_list[PA_PTE_0] = __pa_symbol(&image->pte0);
+	page_list[VA_PTE_0] = (unsigned long)image->pte0;
+	page_list[PA_PUD_1] = __pa_symbol(&image->pud1);
+	page_list[VA_PUD_1] = (unsigned long)image->pud1;
+	page_list[PA_PMD_1] = __pa_symbol(&image->pmd1);
+	page_list[VA_PMD_1] = (unsigned long)image->pmd1;
+	page_list[PA_PTE_1] = __pa_symbol(&image->pte1);
+	page_list[VA_PTE_1] = (unsigned long)image->pte1;
 
 	page_list[PA_TABLE_PAGE] =
 	  (unsigned long)__pa(page_address(image->control_code_page));
@@ -288,4 +733,124 @@ NORET_TYPE void machine_kexec(struct kim
 	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
 			image->start);
 }
+#else
+typedef NORET_TYPE void (*xen_pv_relocate_kernel_t)(unsigned long indirection_page,
+							unsigned long page_list,
+							unsigned long start_address,
+							int num_cpus, int cpu) ATTRIB_NORET;
+
+extern void local_teardown_timer(unsigned int cpu);
+extern void __xen_smp_intr_exit(unsigned int cpu);
+
+#ifdef CONFIG_SMP
+static atomic_t control_page_ready = ATOMIC_INIT(0);
+static xen_pv_kexec_halt_t xpkh_relocated;
+
+xen_pv_kexec_halt_t get_relocated_xpkh(void)
+{
+	while (!atomic_read(&control_page_ready))
+		udelay(1000);
+
+	return xpkh_relocated;
+}
+#endif
+
+/*
+ * Do not allocate memory (or fail in any way) in machine_kexec().
+ * We are past the point of no return, committed to rebooting now.
+ */
+NORET_TYPE void xen_pv_machine_kexec(struct kimage *image)
+{
+#ifdef CONFIG_SMP
+	int i;
+#endif
+	pgd_t *pgd;
+	struct mmuext_op ldt_op = {
+		.cmd = MMUEXT_SET_LDT,
+		.arg1.linear_addr = 0,
+		.arg2.nr_ents = 0
+	};
+	struct page *next, *page;
+	unsigned long page_list[PAGES_NR];
+	void *table_page;
+	xen_pv_relocate_kernel_t control_page;
+
+	/* Interrupts aren't acceptable while we reboot. */
+	local_irq_disable();
+
+	table_page = page_address(image->control_code_page);
+	control_page = table_page + PAGE_SIZE;
+
+#ifdef CONFIG_SMP
+	xpkh_relocated = (xen_pv_kexec_halt_t)control_page;
+	xpkh_relocated += (void *)xen_pv_kexec_halt - (void *)xen_pv_relocate_kernel;
+#endif
+
+	page_list[PA_CONTROL_PAGE] = __pa(control_page);
+	page_list[PA_TABLE_PAGE] = virt_to_machine(table_page);
+	page_list[VA_PGD] = __pa_symbol(image->pgd);
+	page_list[PA_PGD] = virt_to_machine(image->pgd) | X__PAGE_KERNEL_EXEC;
+	page_list[VA_PUD_0] = __pa_symbol(image->pud0);
+	page_list[PA_PUD_0] = virt_to_machine(image->pud0) | X__PAGE_KERNEL_EXEC;
+	page_list[VA_PMD_0] = __pa_symbol(image->pmd0);
+	page_list[PA_PMD_0] = virt_to_machine(image->pmd0) | X__PAGE_KERNEL_EXEC;
+	page_list[VA_PTE_0] = __pa_symbol(image->pte0);
+	page_list[PA_PTE_0] = virt_to_machine(image->pte0) | X__PAGE_KERNEL_EXEC;
+	page_list[VA_PUD_1] = __pa_symbol(image->pud1);
+	page_list[PA_PUD_1] = virt_to_machine(image->pud1) | X__PAGE_KERNEL_EXEC;
+	page_list[VA_PMD_1] = __pa_symbol(image->pmd1);
+	page_list[PA_PMD_1] = virt_to_machine(image->pmd1) | X__PAGE_KERNEL_EXEC;
+	page_list[VA_PTE_1] = __pa_symbol(image->pte1);
+	page_list[PA_PTE_1] = virt_to_machine(image->pte1) | X__PAGE_KERNEL_EXEC;
+
+	memcpy(control_page, xen_pv_relocate_kernel, PAGE_SIZE);
+
+#ifdef CONFIG_SMP
+	wmb();
+
+	atomic_inc(&control_page_ready);
 #endif
+
+	/* Stop singleshot timer. */
+	if (HYPERVISOR_set_timer_op(0))
+		BUG();
+
+#ifdef CONFIG_SMP
+	for_each_present_cpu(i)
+		__xen_smp_intr_exit(i);
+#else
+	local_teardown_timer(smp_processor_id());
+#endif
+
+	/* Unpin all page tables. */
+	for (page = pgd_list; page; page = next) {
+		next = (struct page *)page->index;
+		pgd = ((struct mm_struct *)page->mapping)->pgd;
+		xen_pgd_unpin(__pa(pgd));
+		xen_pgd_unpin(__pa(__user_pgd(pgd)));
+	}
+
+	xen_pgd_unpin(__pa_symbol(init_level4_user_pgt));
+	xen_pgd_unpin(__pa(xen_start_info->pt_base));
+	xen_pgd_unpin(__pa(init_mm.pgd));
+
+	/* Move NULL segment selector to %ds and %es register. */
+	asm volatile("movl %0, %%ds; movl %0, %%es" : : "r" (0));
+
+	/* Destroy GDT. */
+	if (HYPERVISOR_set_gdt(NULL, 0))
+		BUG();
+
+	/* Destroy LDT. */
+	if (HYPERVISOR_mmuext_op(&ldt_op, 1, NULL, DOMID_SELF))
+		BUG();
+
+	if (m2p_updates[0].ptr)
+		if (HYPERVISOR_mmu_update(m2p_updates, M2P_UPDATES_SIZE,
+							NULL, DOMID_SELF))
+			BUG();
+
+	(*control_page)((unsigned long)image->head, (unsigned long)page_list,
+			image->start, num_present_cpus(), smp_processor_id());
+}
+#endif  /* CONFIG_XEN */
diff -Npru kexec-kernel-only/arch/x86_64/kernel/relocate_kernel.S kexec-kernel-only_20120522/arch/x86_64/kernel/relocate_kernel.S
--- kexec-kernel-only/arch/x86_64/kernel/relocate_kernel.S	2012-01-25 14:15:10.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/relocate_kernel.S	2012-05-21 14:23:42.000000000 +0200
@@ -14,6 +14,12 @@
  * Must be relocatable PIC code callable as a C function
  */
 
+#define DOMID_SELF	0x7ff0
+
+#define UVMF_INVLPG	2
+
+#define TRANSITION_PGTABLE_SIZE	7
+
 #define PTR(x) (x << 3)
 #define PAGE_ALIGNED (1 << PAGE_SHIFT)
 #define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
@@ -292,7 +298,7 @@ identity_mapped:
 	xorq    %rbp, %rbp
 	xorq	%r8,  %r8
 	xorq	%r9,  %r9
-	xorq	%r10, %r9
+	xorq	%r10, %r10
 	xorq	%r11, %r11
 	xorq	%r12, %r12
 	xorq	%r13, %r13
@@ -314,3 +320,379 @@ gdt_80:
 idt_80:
 	.word	0			/* limit */
 	.quad	0			/* base */
+
+#ifdef CONFIG_XEN
+	.globl xen_pv_relocate_kernel
+
+xen_pv_relocate_kernel:
+	/*
+	 * %rdi - indirection_page,
+	 * %rsi - page_list,
+	 * %rdx - start_address,
+	 * %ecx - num_cpus,
+	 * %r8d - cpu.
+	 */
+
+	/* We need these arguments later. Store them in safe place. */
+	movq	%rdi, %r13
+	movq	%rdx, %r14
+	movl	%ecx, %r15d
+
+#ifdef CONFIG_SMP
+	/* Do not take into account our CPU. */
+	decl	%r15d
+
+0:
+	/* Is everybody at entry stage? */
+	cmpl	%r15d, xpkh_stage_cpus(%rip)
+	jne	0b
+
+	/* Reset stage counter. */
+	movl	$0, xpkh_stage_cpus(%rip)
+#endif
+
+	/* Store transition page table addresses in safe place too. */
+	leaq	transition_pgtable_uvm(%rip), %rax
+	movq	%rax, %rbx
+	addq	$0x10, %rax /* *vaddr */
+	addq	$0x18, %rbx /* *pte */
+
+	movq	PTR(VA_PGD)(%rsi), %rcx
+	movq	PTR(PA_PGD)(%rsi), %rdx
+	movq	%rcx, (%rax)
+	movq	%rdx, (%rbx)
+
+	addq	$0x40, %rax
+	addq	$0x40, %rbx
+
+	movq	PTR(VA_PUD_0)(%rsi), %rcx
+	movq	PTR(PA_PUD_0)(%rsi), %rdx
+	movq	%rcx, (%rax)
+	movq	%rdx, (%rbx)
+
+	addq	$0x40, %rax
+	addq	$0x40, %rbx
+
+	movq	PTR(VA_PMD_0)(%rsi), %rcx
+	movq	PTR(PA_PMD_0)(%rsi), %rdx
+	movq	%rcx, (%rax)
+	movq	%rdx, (%rbx)
+
+	addq	$0x40, %rax
+	addq	$0x40, %rbx
+
+	movq	PTR(VA_PTE_0)(%rsi), %rcx
+	movq	PTR(PA_PTE_0)(%rsi), %rdx
+	movq	%rcx, (%rax)
+	movq	%rdx, (%rbx)
+
+	addq	$0x40, %rax
+	addq	$0x40, %rbx
+
+	movq	PTR(VA_PUD_1)(%rsi), %rcx
+	movq	PTR(PA_PUD_1)(%rsi), %rdx
+	movq	%rcx, (%rax)
+	movq	%rdx, (%rbx)
+
+	addq	$0x40, %rax
+	addq	$0x40, %rbx
+
+	movq	PTR(VA_PMD_1)(%rsi), %rcx
+	movq	PTR(PA_PMD_1)(%rsi), %rdx
+	movq	%rcx, (%rax)
+	movq	%rdx, (%rbx)
+
+	addq	$0x40, %rax
+	addq	$0x40, %rbx
+
+	movq	PTR(VA_PTE_1)(%rsi), %rcx
+	movq	PTR(PA_PTE_1)(%rsi), %rdx
+	movq	%rcx, (%rax)
+	movq	%rdx, (%rbx)
+
+	/*
+	 * Get control page physical address now.
+	 * This is impossible after page table switch.
+	 */
+	movq	PTR(PA_CONTROL_PAGE)(%rsi), %rbp
+
+	/* Get identity page table MFN now too. */
+	movq	PTR(PA_TABLE_PAGE)(%rsi), %r12
+	shrq	$PAGE_SHIFT, %r12
+
+	/* Store transition page table MFN. */
+	movq	PTR(PA_PGD)(%rsi), %rax
+	shrq	$PAGE_SHIFT, %rax
+	movq	%rax, mmuext_new_baseptr(%rip)
+	movq	%rax, mmuext_new_user_baseptr(%rip)
+	movq	%rax, mmuext_unpin_table(%rip)
+
+	/* Switch to transition page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$2, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	/* Go to control page physical address. */
+	leaq	(0f - xen_pv_relocate_kernel)(%rbp), %rax
+	jmpq	*%rax
+
+0:
+#ifdef CONFIG_SMP
+	sfence
+
+	/* Store control page physical address. */
+	movq	%rbp, cp_paddr(%rip)
+
+0:
+	/* Is everybody at transition stage? */
+	cmpl	%r15d, xpkh_stage_cpus(%rip)
+	jne	0b
+
+	/* Reset stage counter. */
+	movl	$0, xpkh_stage_cpus(%rip)
+#endif
+
+	/* Store identity page table MFN. */
+	movq	%r12, mmuext_new_baseptr(%rip)
+	movq	%r12, mmuext_new_user_baseptr(%rip)
+
+	/* Switch to identity page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$3, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+#ifdef CONFIG_SMP
+	sfence
+
+	/* Signal that we are at identity stage. */
+	lock	incb xprk_stage_identity(%rip)
+
+0:
+	/* Is everybody at identity stage? */
+	cmpl	%r15d, xpkh_stage_cpus(%rip)
+	jne	0b
+#endif
+
+	/* Map transition page table pages with _PAGE_RW bit set. */
+	leaq	transition_pgtable_uvm(%rip), %rdi
+	movq	$TRANSITION_PGTABLE_SIZE, %rsi
+	movq	$__HYPERVISOR_multicall, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	/* Do the copies */
+	movq	%r13, %rcx 	/* Put the page_list in %rcx */
+	xorq	%rdi, %rdi
+	xorq	%rsi, %rsi
+	jmp	1f
+
+0:	/* top, read another word for the indirection page */
+
+	movq	(%rbx), %rcx
+	addq	$8,	%rbx
+1:
+	testq	$0x1,	%rcx  /* is it a destination page? */
+	jz	2f
+	movq	%rcx,	%rdi
+	andq	$0xfffffffffffff000, %rdi
+	jmp	0b
+2:
+	testq	$0x2,	%rcx  /* is it an indirection page? */
+	jz	2f
+	movq	%rcx,   %rbx
+	andq	$0xfffffffffffff000, %rbx
+	jmp	0b
+2:
+	testq	$0x4,	%rcx  /* is it the done indicator? */
+	jz	2f
+	jmp	3f
+2:
+	testq	$0x8,	%rcx  /* is it the source indicator? */
+	jz	0b	      /* Ignore it otherwise */
+	movq	%rcx,   %rsi  /* For ever source page do a copy */
+	andq	$0xfffffffffffff000, %rsi
+
+	movq	$512,   %rcx
+	rep ; movsq
+	jmp	0b
+
+3:
+#ifdef CONFIG_SMP
+	sfence
+
+	/* Store purgatory() physical address. */
+	movq	%r14, %rax
+	movq	%r14, purgatory_paddr(%rip)
+#endif
+
+	/* Store current CPU number. */
+	movl	%r8d, %r14d
+
+	/* Set unused registers to known values. */
+	xorq	%rbx, %rbx
+	xorq    %rcx, %rcx
+	xorq    %rdx, %rdx
+	xorq    %rsi, %rsi
+	xorq    %rdi, %rdi
+	xorq    %rbp, %rbp
+	xorq	%r8,  %r8
+	xorq	%r9,  %r9
+	xorq	%r10, %r10
+	xorq	%r11, %r11
+	xorq	%r12, %r12
+	xorq	%r13, %r13
+
+	jmpq	*%rax
+
+#ifdef CONFIG_SMP
+	.globl xen_pv_kexec_halt
+
+xen_pv_kexec_halt:
+	/* %edi - cpu. */
+
+	/* Store current CPU number. */
+	movl	%edi, %r14d
+
+	/* Signal that we are at entry stage. */
+	lock	incl xpkh_stage_cpus(%rip)
+
+0:
+	/* Wait for control page physical address. */
+	cmpq	$0, cp_paddr(%rip)
+	jz	0b
+
+	lfence
+
+	movq	cp_paddr(%rip), %rbp
+	movq	cp_paddr(%rip), %r15
+
+	/* Switch to transition page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$2, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	/* Go to control page physical address. */
+	leaq	(0f - xen_pv_relocate_kernel)(%rbp), %rax
+	jmpq	*%rax
+
+0:
+	/* Signal that we are at transition stage. */
+	lock	incl xpkh_stage_cpus(%rip)
+
+0:
+	/* Is xen_pv_relocate_kernel() at identity stage? */
+	cmpb	$0, xprk_stage_identity(%rip)
+	jz	0b
+
+	lfence
+
+	/* Switch to identity page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$2, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	/* Signal that we are at identity stage. */
+	lock	incl xpkh_stage_cpus(%rip)
+
+0:
+	/* Wait for purgatory() physical address. */
+	cmpq	$0, purgatory_paddr(%rip)
+	jz	0b
+
+	lfence
+
+	movq	purgatory_paddr(%rip), %rbx
+
+	/* Set unused registers to known values. */
+	xorq	%rax, %rax
+	xorq    %rcx, %rcx
+	xorq    %rdx, %rdx
+	xorq    %rsi, %rsi
+	xorq    %rdi, %rdi
+	xorq    %rbp, %rbp
+	xorq	%r8,  %r8
+	xorq	%r9,  %r9
+	xorq	%r10, %r10
+	xorq	%r11, %r11
+	xorq	%r12, %r12
+	xorq	%r13, %r13
+	xorq	%r15, %r15
+
+	jmpq	*%rbx
+
+	.align	8
+
+cp_paddr:
+	.quad	0			/* Control page physical address. */
+
+purgatory_paddr:
+	.quad	0			/* purgatory() physical address. */
+
+xpkh_stage_cpus:
+	.long	0			/* Number of CPUs at given stage in xen_pv_kexec_halt(). */
+
+xprk_stage_identity:
+	.byte	0			/* xen_pv_relocate_kernel() is at identity stage. */
+#endif
+
+mmuext_args:
+	.long	MMUEXT_NEW_BASEPTR	/* Operation */
+	.long	0			/* PAD */
+
+mmuext_new_baseptr:
+	.quad	0			/* MFN of target page table directory */
+	.quad	0			/* UNUSED */
+
+	.long	MMUEXT_NEW_USER_BASEPTR	/* Operation */
+	.long	0			/* PAD */
+
+mmuext_new_user_baseptr:
+	.quad	0			/* MFN of user target page table directory */
+	.quad	0			/* UNUSED */
+
+	.long	MMUEXT_UNPIN_TABLE	/* Operation */
+	.long	0			/* PAD */
+
+mmuext_unpin_table:
+	.quad	0			/* MFN of old page table directory */
+	.quad	0			/* UNUSED */
+
+transition_pgtable_uvm:
+	.rept	TRANSITION_PGTABLE_SIZE
+	.quad	__HYPERVISOR_update_va_mapping
+	.fill	3, 8, 0
+	.quad	UVMF_INVLPG
+	.fill	3, 8, 0
+	.endr
+#endif
diff -Npru kexec-kernel-only/arch/x86_64/kernel/setup-xen.c kexec-kernel-only_20120522/arch/x86_64/kernel/setup-xen.c
--- kexec-kernel-only/arch/x86_64/kernel/setup-xen.c	2012-01-25 14:15:36.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/setup-xen.c	2012-04-26 23:53:01.000000000 +0200
@@ -102,8 +102,10 @@ static struct notifier_block xen_panic_b
 
 unsigned long *phys_to_machine_mapping;
 unsigned long *pfn_to_mfn_frame_list_list, *pfn_to_mfn_frame_list[512];
+unsigned long p2m_max_pfn;
 
 EXPORT_SYMBOL(phys_to_machine_mapping);
+EXPORT_SYMBOL(p2m_max_pfn);
 
 DEFINE_PER_CPU(multicall_entry_t, multicall_list[8]);
 DEFINE_PER_CPU(int, nr_multicall_ents);
@@ -475,18 +477,21 @@ static __init void parse_cmdline_early (
 		 * after a kernel panic.
 		 */
 		else if (!memcmp(from, "crashkernel=", 12)) {
-#ifndef CONFIG_XEN
-			unsigned long size, base;
-			size = memparse(from+12, &from);
-			if (*from == '@') {
-				base = memparse(from+1, &from);
-				crashk_res.start = base;
-				crashk_res.end   = base + size - 1;
+#ifdef CONFIG_XEN
+			if (is_initial_xendomain())
+				printk("Ignoring crashkernel command line, "
+					"parameter will be supplied by xen\n");
+			else
+#endif
+			{
+				unsigned long size, base;
+				size = memparse(from+12, &from);
+				if (*from == '@') {
+					base = memparse(from+1, &from);
+					crashk_res.start = base;
+					crashk_res.end   = base + size - 1;
+				}
 			}
-#else
-			printk("Ignoring crashkernel command line, "
-			       "parameter will be supplied by xen\n");
-#endif
 		}
 #endif
 
@@ -785,22 +790,16 @@ void __init setup_arch(char **cmdline_p)
 #endif	/* !CONFIG_XEN */
 #ifdef CONFIG_KEXEC
 #ifdef CONFIG_XEN
-	xen_machine_kexec_setup_resources();
-#else
-	if ((crashk_res.start < crashk_res.end) &&
-	    (crashk_res.end <= (end_pfn << PAGE_SHIFT))) {
-		reserve_bootmem_generic(crashk_res.start,
+	if (is_initial_xendomain())
+		xen_machine_kexec_setup_resources();
+	else
+#endif
+	{
+		if (crashk_res.start != crashk_res.end)
+			reserve_bootmem_generic(crashk_res.start,
 					crashk_res.end - crashk_res.start + 1,
 					BOOTMEM_EXCLUSIVE);
 	}
-	else {
-		printk(KERN_ERR "Memory for crash kernel (0x%lx to 0x%lx) not"
-		       "within permissible range\ndisabling kdump\n",
-		       crashk_res.start, crashk_res.end);
-		crashk_res.end = 0;
-		crashk_res.start = 0;
-	}
-#endif
 #endif
 
 	paging_init();
@@ -814,10 +813,10 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_XEN
 	{
 		int i, j, k, fpp;
-		unsigned long p2m_pages;
 
-		p2m_pages = end_pfn;
-		if (xen_start_info->nr_pages > end_pfn) {
+		p2m_max_pfn = saved_max_pfn ? saved_max_pfn : end_pfn;
+
+		if (xen_start_info->nr_pages > end_pfn && !saved_max_pfn) {
 			/*
 			 * the end_pfn was shrunk (probably by mem=
 			 * kernel parameter); shrink reservation with the HV
@@ -839,18 +838,17 @@ void __init setup_arch(char **cmdline_p)
 						   &reservation);
 			BUG_ON (ret != difference);
 		}
-		else if (end_pfn > xen_start_info->nr_pages)
-			p2m_pages = xen_start_info->nr_pages;
 
 		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 			/* Make sure we have a large enough P->M table. */
 			phys_to_machine_mapping = alloc_bootmem_pages(
-				end_pfn * sizeof(unsigned long));
+				p2m_max_pfn * sizeof(unsigned long));
 			memset(phys_to_machine_mapping, ~0,
-			       end_pfn * sizeof(unsigned long));
+			       p2m_max_pfn * sizeof(unsigned long));
 			memcpy(phys_to_machine_mapping,
 			       (unsigned long *)xen_start_info->mfn_list,
-			       p2m_pages * sizeof(unsigned long));
+			       min(xen_start_info->nr_pages, p2m_max_pfn) *
+			       sizeof(unsigned long));
 			free_bootmem(
 				__pa(xen_start_info->mfn_list),
 				PFN_PHYS(PFN_UP(xen_start_info->nr_pages *
@@ -938,21 +936,23 @@ void __init setup_arch(char **cmdline_p)
 	 * and also for regions reported as reserved by the e820.
 	 */
 	probe_roms();
+
 #ifdef CONFIG_XEN
+	memmap.nr_entries = E820MAX;
+	set_xen_guest_handle(memmap.buffer, machine_e820.map);
+	
 	if (is_initial_xendomain()) {
-		memmap.nr_entries = E820MAX;
-		set_xen_guest_handle(memmap.buffer, machine_e820.map);
-
 		if (HYPERVISOR_memory_op(XENMEM_machine_memory_map, &memmap))
 			BUG();
-		machine_e820.nr_map = memmap.nr_entries;
+	} else
+		if (HYPERVISOR_memory_op(XENMEM_memory_map, &memmap))
+			BUG();
 
-		e820_reserve_resources(machine_e820.map, machine_e820.nr_map);
-	}
-#else
-	e820_reserve_resources(e820.map, e820.nr_map);
+	machine_e820.nr_map = memmap.nr_entries;
 #endif
 
+	e820_reserve_resources(e820.map, e820.nr_map);
+
 	request_resource(&iomem_resource, &video_ram_resource);
 
 	{
diff -Npru kexec-kernel-only/arch/x86_64/kernel/vmlinux.lds.S kexec-kernel-only_20120522/arch/x86_64/kernel/vmlinux.lds.S
--- kexec-kernel-only/arch/x86_64/kernel/vmlinux.lds.S	2012-01-25 14:15:45.000000000 +0100
+++ kexec-kernel-only_20120522/arch/x86_64/kernel/vmlinux.lds.S	2012-05-22 13:02:24.000000000 +0200
@@ -24,7 +24,7 @@ SECTIONS
 {
 /* XEN x86_64 don't work with relocations yet quintela@redhat.com */
 #ifdef CONFIG_X86_64_XEN
-  . = __START_KERNEL_map + 0x200000;
+  . = __START_KERNEL_map + CONFIG_PHYSICAL_START;
 #else	
   . = __START_KERNEL_map;
 #endif
diff -Npru kexec-kernel-only/drivers/char/mem.c kexec-kernel-only_20120522/drivers/char/mem.c
--- kexec-kernel-only/drivers/char/mem.c	2012-01-25 14:15:39.000000000 +0100
+++ kexec-kernel-only_20120522/drivers/char/mem.c	2012-04-27 00:09:57.000000000 +0200
@@ -322,7 +322,7 @@ static ssize_t read_oldmem(struct file *
 
 	while (count) {
 		pfn = *ppos / PAGE_SIZE;
-		if (pfn > saved_max_pfn)
+		if (pfn >= saved_max_pfn)
 			return read;
 
 		offset = (unsigned long)(*ppos % PAGE_SIZE);
diff -Npru kexec-kernel-only/drivers/xen/core/evtchn.c kexec-kernel-only_20120522/drivers/xen/core/evtchn.c
--- kexec-kernel-only/drivers/xen/core/evtchn.c	2012-01-25 14:15:38.000000000 +0100
+++ kexec-kernel-only_20120522/drivers/xen/core/evtchn.c	2012-05-21 13:34:24.000000000 +0200
@@ -510,6 +510,12 @@ int bind_ipi_to_irqhandler(
 }
 EXPORT_SYMBOL_GPL(bind_ipi_to_irqhandler);
 
+void __unbind_from_irqhandler(unsigned int irq, void *dev_id)
+{
+	unbind_from_irq(irq);
+}
+EXPORT_SYMBOL_GPL(__unbind_from_irqhandler);
+
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
 	free_irq(irq, dev_id);
diff -Npru kexec-kernel-only/drivers/xen/core/machine_kexec.c kexec-kernel-only_20120522/drivers/xen/core/machine_kexec.c
--- kexec-kernel-only/drivers/xen/core/machine_kexec.c	2012-01-25 14:15:23.000000000 +0100
+++ kexec-kernel-only_20120522/drivers/xen/core/machine_kexec.c	2012-05-22 14:52:00.000000000 +0200
@@ -1,16 +1,44 @@
 /*
- * drivers/xen/core/machine_kexec.c
- * handle transition of Linux booting another kernel
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #include <linux/kexec.h>
 #include <xen/interface/kexec.h>
 #include <linux/mm.h>
 #include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pfn.h>
+#include <linux/sysfs.h>
+
 #include <asm/hypercall.h>
 
-extern void machine_kexec_setup_load_arg(xen_kexec_image_t *xki,
-					 struct kimage *image);
+extern char hypercall_page[PAGE_SIZE];
+
+static struct bin_attribute p2m_attr;
+static struct bin_attribute si_attr;
 
 int xen_max_nr_phys_cpus;
 struct resource xen_hypervisor_res;
@@ -19,6 +47,13 @@ struct resource *xen_phys_cpus;
 size_t vmcoreinfo_size_xen;
 unsigned long paddr_vmcoreinfo_xen;
 
+#ifdef CONFIG_SMP
+static atomic_t waiting_for_down;
+#endif
+
+extern void machine_kexec_setup_load_arg(xen_kexec_image_t *xki,
+					 struct kimage *image);
+
 void xen_machine_kexec_setup_resources(void)
 {
 	xen_kexec_range_t range;
@@ -124,6 +159,9 @@ void xen_machine_kexec_register_resource
 {
 	int k;
 
+	if (!is_initial_xendomain())
+		return;
+
 	request_resource(res, &xen_hypervisor_res);
 
 	for (k = 0; k < xen_max_nr_phys_cpus; k++)
@@ -152,6 +190,10 @@ int xen_machine_kexec_load(struct kimage
 	memset(&xkl, 0, sizeof(xkl));
 	xkl.type = image->type;
 	setup_load_arg(&xkl.image, image);
+
+	if (!is_initial_xendomain())
+		return 0;
+
 	return HYPERVISOR_kexec_op(KEXEC_CMD_kexec_load, &xkl);
 }
 
@@ -165,6 +207,9 @@ void xen_machine_kexec_unload(struct kim
 {
 	xen_kexec_load_t xkl;
 
+	if (!is_initial_xendomain())
+		return;
+
 	memset(&xkl, 0, sizeof(xkl));
 	xkl.type = image->type;
 	HYPERVISOR_kexec_op(KEXEC_CMD_kexec_unload, &xkl);
@@ -182,17 +227,246 @@ NORET_TYPE void machine_kexec(struct kim
 {
 	xen_kexec_exec_t xke;
 
-	memset(&xke, 0, sizeof(xke));
-	xke.type = image->type;
-	HYPERVISOR_kexec_op(KEXEC_CMD_kexec, &xke);
-	panic("KEXEC_CMD_kexec hypercall should not return\n");
+	if (is_initial_xendomain()) {
+		memset(&xke, 0, sizeof(xke));
+		xke.type = image->type;
+		HYPERVISOR_kexec_op(KEXEC_CMD_kexec, &xke);
+		panic("KEXEC_CMD_kexec hypercall should not return\n");
+	} else
+		xen_pv_machine_kexec(image);
 }
 
+#ifdef CONFIG_SMP
+static void xen_pv_kexec_stop_this_cpu(void *dummy)
+{
+	struct mmuext_op ldt_op = {
+		.cmd = MMUEXT_SET_LDT,
+		.arg1.linear_addr = 0,
+		.arg2.nr_ents = 0
+	};
+	xen_pv_kexec_halt_t xpkh_relocated;
+
+	/* Interrupts aren't acceptable while we reboot. */
+	local_irq_disable();
+
+	cpu_clear(smp_processor_id(), cpu_online_map);
+
+	/* Stop singleshot timer. */
+	if (HYPERVISOR_set_timer_op(0))
+		BUG();
+
+	/* Move NULL segment selector to %ds and %es register. */
+	asm volatile("movl %0, %%ds; movl %0, %%es" : : "r" (0));
+
+	/* Destroy GDT. */
+	if (HYPERVISOR_set_gdt(NULL, 0))
+		BUG();
+
+	/* Destroy LDT. */
+	if (HYPERVISOR_mmuext_op(&ldt_op, 1, NULL, DOMID_SELF))
+		BUG();
+
+	atomic_dec(&waiting_for_down);
+
+	xpkh_relocated = get_relocated_xpkh();
+
+	(*xpkh_relocated)(smp_processor_id());
+}
+
+void xen_pv_kexec_smp_send_stop(void)
+{
+	atomic_set(&waiting_for_down, num_present_cpus() - 1);
+
+	smp_call_function(xen_pv_kexec_stop_this_cpu, NULL, 1, 0);
+
+	/* Wait for all CPUs will be almost ready to come into down state. */
+	while (atomic_read(&waiting_for_down))
+		udelay(1000);
+}
+
+void machine_shutdown(void)
+{
+	int reboot_cpu_id;
+
+	if (is_initial_xendomain())
+		return;
+
+	/* The boot cpu is always logical cpu 0. */
+	reboot_cpu_id = 0;
+
+	/* Make certain the cpu I'm rebooting on is online. */
+	if (!cpu_isset(reboot_cpu_id, cpu_online_map))
+		reboot_cpu_id = smp_processor_id();
+
+	/* Make certain I only run on the appropriate processor. */
+	set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+
+	/*
+	 * O.K. Now that I'm on the appropriate processor,
+	 * stop all of the others.
+	 */
+	xen_pv_kexec_smp_send_stop();
+}
+#else
 void machine_shutdown(void)
 {
 	/* do nothing */
 }
+#endif  /* CONFIG_SMP */
+
+static ssize_t si_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+{
+	if (off >= si_attr.size)
+		return 0;
+
+	count = min(si_attr.size - (size_t)off, count);
+	memcpy(buf, &((char *)xen_start_info)[off], count);
+
+	return count;
+}
+
+static int si_mmap(struct kobject *kobj,
+			struct bin_attribute *attr,
+			struct vm_area_struct *vma)
+{
+	unsigned long off, size;
+
+	if (vma->vm_flags & VM_SHARED)
+		return -EACCES;
+
+	off = vma->vm_pgoff << PAGE_SHIFT;
+	size = vma->vm_end - vma->vm_start;
+
+	if (off + size > PAGE_SIZE)
+		return -EINVAL;
+
+	vma->vm_pgoff += PFN_DOWN(__pa(xen_start_info));
+	vma->vm_flags &= ~VM_MAYSHARE;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+						size, vma->vm_page_prot);
+}
+
+static ssize_t hypercall_page_read(struct kobject *kobj, char *buf,
+						loff_t off, size_t count)
+{
+	if (off >= PAGE_SIZE)
+		return 0;
+
+	count = min(PAGE_SIZE - (size_t)off, count);
+	memcpy(buf, &hypercall_page[off], count);
+
+	return count;
+}
+
+static int hypercall_page_mmap(struct kobject *kobj,
+				struct bin_attribute *attr,
+				struct vm_area_struct *vma)
+{
+	unsigned long size = vma->vm_end - vma->vm_start;
+
+	if (vma->vm_flags & VM_SHARED)
+		return -EACCES;
+
+	if (vma->vm_pgoff + size > PAGE_SIZE)
+		return -EINVAL;
+
+	vma->vm_pgoff = PFN_DOWN(__pa_symbol(hypercall_page));
+	vma->vm_flags &= ~VM_MAYSHARE;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+						size, vma->vm_page_prot);
+}
+
+static ssize_t p2m_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+{
+	if (off >= p2m_attr.size)
+		return 0;
+
+	count = min(p2m_attr.size - (size_t)off, count);
+	memcpy(buf, &((char *)phys_to_machine_mapping)[off], count);
+
+	return count;
+}
+
+static int p2m_mmap(struct kobject *kobj,
+			struct bin_attribute *attr,
+			struct vm_area_struct *vma)
+{
+	unsigned long off, size;
+
+	if (vma->vm_flags & VM_SHARED)
+		return -EACCES;
+
+	off = vma->vm_pgoff << PAGE_SHIFT;
+	size = vma->vm_end - vma->vm_start;
+
+	if (off + size > roundup(p2m_attr.size, PAGE_SIZE))
+		return -EINVAL;
+
+	vma->vm_pgoff += PFN_DOWN(__pa(phys_to_machine_mapping));
+	vma->vm_flags &= ~VM_MAYSHARE;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+						size, vma->vm_page_prot);
+}
+
+static struct bin_attribute si_attr = {
+	.attr = {
+		.name = "start_info",
+		.mode = S_IRUSR,
+		.owner = THIS_MODULE
+	},
+	.size = sizeof(*xen_start_info),
+	.read = si_read,
+	.mmap = si_mmap
+};
+
+static struct bin_attribute hypercall_page_attr = {
+	.attr = {
+		.name = "hypercall_page",
+		.mode = S_IRUSR,
+		.owner = THIS_MODULE
+	},
+	.size = PAGE_SIZE,
+	.read = hypercall_page_read,
+	.mmap = hypercall_page_mmap
+};
+
+static struct bin_attribute p2m_attr = {
+	.attr = {
+		.name = "p2m",
+		.mode = S_IRUSR,
+		.owner = THIS_MODULE
+	},
+	.read = p2m_read,
+	.mmap = p2m_mmap
+};
+
+static int __init kexec_xen_sysfs_init(void)
+{
+	int rc;
+
+	if (is_initial_xendomain())
+		return 0;
+
+	rc = sysfs_create_bin_file(&kernel_subsys.kset.kobj, &si_attr);
+
+	if (rc)
+		return rc;
+
+	rc = sysfs_create_bin_file(&kernel_subsys.kset.kobj, &hypercall_page_attr);
+
+	if (rc)
+		return rc;
+
+	p2m_attr.size = min(xen_start_info->nr_pages, max_pfn);
+	p2m_attr.size *= sizeof(unsigned long);
+
+	return sysfs_create_bin_file(&kernel_subsys.kset.kobj, &p2m_attr);
+}
 
+subsys_initcall(kexec_xen_sysfs_init);
 
 /*
  * Local variables:
diff -Npru kexec-kernel-only/drivers/xen/core/smpboot.c kexec-kernel-only_20120522/drivers/xen/core/smpboot.c
--- kexec-kernel-only/drivers/xen/core/smpboot.c	2012-01-25 14:15:23.000000000 +0100
+++ kexec-kernel-only_20120522/drivers/xen/core/smpboot.c	2012-05-21 13:51:38.000000000 +0200
@@ -148,6 +148,15 @@ static int xen_smp_intr_init(unsigned in
 	return rc;
 }
 
+#ifdef CONFIG_KEXEC
+void __xen_smp_intr_exit(unsigned int cpu)
+{
+	local_teardown_timer(cpu);
+	unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
+	__unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
+}
+#endif
+
 #ifdef CONFIG_HOTPLUG_CPU
 static void xen_smp_intr_exit(unsigned int cpu)
 {
diff -Npru kexec-kernel-only/drivers/xen/xenbus/xenbus_comms.c kexec-kernel-only_20120522/drivers/xen/xenbus/xenbus_comms.c
--- kexec-kernel-only/drivers/xen/xenbus/xenbus_comms.c	2012-01-25 14:15:19.000000000 +0100
+++ kexec-kernel-only_20120522/drivers/xen/xenbus/xenbus_comms.c	2012-02-10 22:06:16.000000000 +0100
@@ -188,8 +188,22 @@ int xb_read(void *data, unsigned len)
 /* Set up interrupt handler off store event channel. */
 int xb_init_comms(void)
 {
+	struct xenstore_domain_interface *intf = xen_store_interface;
 	int err;
 
+	if (intf->req_prod != intf->req_cons)
+		printk(KERN_ERR "XENBUS request ring is not quiescent "
+		       "(%08x:%08x)!\n", intf->req_cons, intf->req_prod);
+
+	if (intf->rsp_prod != intf->rsp_cons) {
+		printk(KERN_WARNING "XENBUS response ring is not quiescent "
+		       "(%08x:%08x): fixing up\n",
+		       intf->rsp_cons, intf->rsp_prod);
+		/* breaks kdump */
+		if (!reset_devices)
+			intf->rsp_cons = intf->rsp_prod;
+	}
+
 	if (xenbus_irq)
 		unbind_from_irqhandler(xenbus_irq, &xb_waitq);
 
diff -Npru kexec-kernel-only/drivers/xen/xenbus/xenbus_probe.c kexec-kernel-only_20120522/drivers/xen/xenbus/xenbus_probe.c
--- kexec-kernel-only/drivers/xen/xenbus/xenbus_probe.c	2012-01-25 14:15:32.000000000 +0100
+++ kexec-kernel-only_20120522/drivers/xen/xenbus/xenbus_probe.c	2012-02-10 21:17:54.000000000 +0100
@@ -1032,11 +1032,136 @@ void unregister_xenstore_notifier(struct
 }
 EXPORT_SYMBOL_GPL(unregister_xenstore_notifier);
 
+#ifdef CONFIG_KEXEC
+static DECLARE_WAIT_QUEUE_HEAD(backend_state_wq);
+static int backend_state;
+
+static void xenbus_reset_backend_state_changed(struct xenbus_watch *w,
+					const char **v, unsigned int l)
+{
+	if (xenbus_scanf(XBT_NIL, v[XS_WATCH_PATH], "", "%i", &backend_state) != 1)
+		backend_state = XenbusStateUnknown;
+	printk(KERN_DEBUG "XENBUS: backend %s %s\n",
+			v[XS_WATCH_PATH], xenbus_strstate(backend_state));
+	wake_up(&backend_state_wq);
+}
+
+static void xenbus_reset_wait_for_backend(char *be, int expected)
+{
+	long timeout;
+	timeout = wait_event_interruptible_timeout(backend_state_wq,
+			backend_state == expected, 5 * HZ);
+	if (timeout <= 0)
+		printk(KERN_INFO "XENBUS: backend %s timed out.\n", be);
+}
+
+/*
+ * Reset frontend if it is in Connected or Closed state.
+ * Wait for backend to catch up.
+ * State Connected happens during kdump, Closed after kexec.
+ */
+static void xenbus_reset_frontend(char *fe, char *be, int be_state)
+{
+	struct xenbus_watch be_watch;
+
+	printk(KERN_DEBUG "XENBUS: backend %s %s\n",
+			be, xenbus_strstate(be_state));
+
+	memset(&be_watch, 0, sizeof(be_watch));
+	be_watch.node = kasprintf(GFP_NOIO | __GFP_HIGH, "%s/state", be);
+	if (!be_watch.node)
+		return;
+
+	be_watch.callback = xenbus_reset_backend_state_changed;
+	backend_state = XenbusStateUnknown;
+
+	printk(KERN_INFO "XENBUS: triggering reconnect on %s\n", be);
+	register_xenbus_watch(&be_watch);
+
+	/* fall through to forward backend to state XenbusStateInitialising */
+	switch (be_state) {
+	case XenbusStateConnected:
+		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateClosing);
+		xenbus_reset_wait_for_backend(be, XenbusStateClosing);
+
+	case XenbusStateClosing:
+		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateClosed);
+		xenbus_reset_wait_for_backend(be, XenbusStateClosed);
+
+	case XenbusStateClosed:
+		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateInitialising);
+		xenbus_reset_wait_for_backend(be, XenbusStateInitWait);
+	}
+
+	unregister_xenbus_watch(&be_watch);
+	printk(KERN_INFO "XENBUS: reconnect done on %s\n", be);
+	kfree(be_watch.node);
+}
+
+static void xenbus_check_frontend(char *class, char *dev)
+{
+	int be_state, fe_state, err;
+	char *backend, *frontend;
+
+	frontend = kasprintf(GFP_NOIO | __GFP_HIGH, "device/%s/%s", class, dev);
+	if (!frontend)
+		return;
+
+	err = xenbus_scanf(XBT_NIL, frontend, "state", "%i", &fe_state);
+	if (err != 1)
+		goto out;
+
+	switch (fe_state) {
+	case XenbusStateConnected:
+	case XenbusStateClosed:
+		printk(KERN_DEBUG "XENBUS: frontend %s %s\n",
+				frontend, xenbus_strstate(fe_state));
+		backend = xenbus_read(XBT_NIL, frontend, "backend", NULL);
+		if (!backend || IS_ERR(backend))
+			goto out;
+		err = xenbus_scanf(XBT_NIL, backend, "state", "%i", &be_state);
+		if (err == 1)
+			xenbus_reset_frontend(frontend, backend, be_state);
+		kfree(backend);
+		break;
+	default:
+		break;
+	}
+out:
+	kfree(frontend);
+}
+
+static void xenbus_reset_state(void)
+{
+	char **devclass, **dev;
+	int devclass_n, dev_n;
+	int i, j;
+
+	devclass = xenbus_directory(XBT_NIL, "device", "", &devclass_n);
+	if (IS_ERR(devclass))
+		return;
+
+	for (i = 0; i < devclass_n; i++) {
+		dev = xenbus_directory(XBT_NIL, "device", devclass[i], &dev_n);
+		if (IS_ERR(dev))
+			continue;
+		for (j = 0; j < dev_n; j++)
+			xenbus_check_frontend(devclass[i], dev[j]);
+		kfree(dev);
+	}
+	kfree(devclass);
+}
+#endif
 
 void xenbus_probe(void *unused)
 {
 	BUG_ON((xenstored_ready <= 0));
 
+#ifdef CONFIG_KEXEC
+	/* reset devices in Connected or Closed state */
+	xenbus_reset_state();
+#endif
+
 	/* Enumerate devices in xenstore. */
 	xenbus_probe_devices(&xenbus_frontend);
 #ifdef CONFIG_XEN
diff -Npru kexec-kernel-only/drivers/xen/xenbus/xenbus_xs.c kexec-kernel-only_20120522/drivers/xen/xenbus/xenbus_xs.c
--- kexec-kernel-only/drivers/xen/xenbus/xenbus_xs.c	2012-01-25 14:15:39.000000000 +0100
+++ kexec-kernel-only_20120522/drivers/xen/xenbus/xenbus_xs.c	2012-02-11 19:04:11.000000000 +0100
@@ -591,6 +591,24 @@ static struct xenbus_watch *find_watch(c
 	return NULL;
 }
 
+static void xs_reset_watches(void)
+{
+#ifdef CONFIG_KEXEC
+	int err, supported = 0;
+
+	err = xenbus_scanf(XBT_NIL, "control",
+				"platform-feature-xs_reset_watches", "%d",
+				&supported);
+
+	if (err != 1 || !supported)
+		return;
+
+	err = xs_error(xs_single(XBT_NIL, XS_RESET_WATCHES, "", NULL));
+	if (err && err != -EEXIST)
+		printk(KERN_WARNING "xs_reset_watches failed: %d\n", err);
+#endif
+}
+
 /* Register callback to watch this node. */
 int register_xenbus_watch(struct xenbus_watch *watch)
 {
@@ -609,8 +627,37 @@ int register_xenbus_watch(struct xenbus_
 
 	err = xs_watch(watch->node, token);
 
-	/* Ignore errors due to multiple registration. */
-	if ((err != 0) && (err != -EEXIST)) {
+	/* Ten fragment kodu jest zbyt generyczny !!!
+	 * Przeniesc do sterownika blkfront i netfront. */
+	/* vbd vbd-51712: 17 adding watch on /local/domain/0/backend/vbd/181/51712/state
+	 * xenbus: failed to write error node for device/vbd/51712 (17 adding watch on /local/domain/0/backend/vbd/181/51712/state)
+	 * xenbus_probe: watch_otherend on device/vbd/51712 failed.
+	 * vbd: probe of vbd-51712 failed with error -17
+	 * vbd vbd-51728: 17 adding watch on /local/domain/0/backend/vbd/181/51728/state
+	 * xenbus: failed to write error node for device/vbd/51728 (17 adding watch on /local/domain/0/backend/vbd/181/51728/state)
+	 * xenbus_probe: watch_otherend on device/vbd/51728 failed.
+	 * vbd: probe of vbd-51728 failed with error -17
+	 * netfront: Initialising virtual ethernet driver.
+	 * vif vif-0: 17 adding watch on /local/domain/0/backend/vif/181/0/state
+	 * xenbus: failed to write error node for device/vif/0 (17 adding watch on /local/domain/0/backend/vif/181/0/state)
+	 * xenbus_probe: watch_otherend on device/vif/0 failed.
+	 * vif: probe of vif-0 failed with error -17
+	 *
+	 * warto zaczac analize od xenbus_dev_probe() -> watch_otherend() */
+	if (err == -EEXIST) {
+		err = xs_unwatch(watch->node, token);
+
+		if (err)
+			printk(KERN_WARNING
+			       "XENBUS Failed to release watch %s: %i\n",
+			       watch->node, err);
+		else
+			err = xs_watch(watch->node, token);
+	}
+	/* Ten fragment kodu jest zbyt generyczny !!!
+	 * Przeniesc do sterownika blkfront i netfront. */
+
+	if (err) {
 		spin_lock(&watches_lock);
 		list_del(&watch->list);
 		spin_unlock(&watches_lock);
@@ -877,5 +924,8 @@ int xs_init(void)
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 
+	/* shutdown watches for kexec boot */
+	xs_reset_watches();
+
 	return 0;
 }
diff -Npru kexec-kernel-only/include/asm-x86_64/kexec.h kexec-kernel-only_20120522/include/asm-x86_64/kexec.h
--- kexec-kernel-only/include/asm-x86_64/kexec.h	2012-01-25 14:15:10.000000000 +0100
+++ kexec-kernel-only_20120522/include/asm-x86_64/kexec.h	2012-05-20 16:49:27.000000000 +0200
@@ -22,8 +22,10 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/mm.h>
 #include <linux/string.h>
 
+#include <asm/io.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 
@@ -91,17 +93,54 @@ relocate_kernel(unsigned long indirectio
 		unsigned long page_list,
 		unsigned long start_address) ATTRIB_NORET;
 
-/* Under Xen we need to work with machine addresses. These macros give the
+/* Under Xen we need to work with machine addresses. These functions give the
  * machine address of a certain page to the generic kexec code instead of
  * the pseudo physical address which would be given by the default macros.
  */
 
 #ifdef CONFIG_XEN
+
+typedef NORET_TYPE void (*xen_pv_kexec_halt_t)(int cpu) ATTRIB_NORET;
+
 #define KEXEC_ARCH_HAS_PAGE_MACROS
-#define kexec_page_to_pfn(page)  pfn_to_mfn(page_to_pfn(page))
-#define kexec_pfn_to_page(pfn)   pfn_to_page(mfn_to_pfn(pfn))
-#define kexec_virt_to_phys(addr) virt_to_machine(addr)
-#define kexec_phys_to_virt(addr) phys_to_virt(machine_to_phys(addr))
+
+static inline unsigned long kexec_page_to_pfn(struct page *page) {
+	if (is_initial_xendomain())
+		return pfn_to_mfn(page_to_pfn(page));
+	else
+		return page_to_pfn(page);
+}
+
+static inline struct page *kexec_pfn_to_page(unsigned long pfn) {
+	if (is_initial_xendomain())
+		return pfn_to_page(mfn_to_pfn(pfn));
+	else
+		return pfn_to_page(pfn);
+}
+
+static inline unsigned long kexec_virt_to_phys(void *addr) {
+	if (is_initial_xendomain())
+		return virt_to_machine(addr);
+	else
+		return virt_to_phys(addr);
+}
+
+static inline void *kexec_phys_to_virt(unsigned long addr) {
+	if (is_initial_xendomain())
+		return phys_to_virt(machine_to_phys(addr));
+	else
+		return phys_to_virt(addr);
+}
+
+extern xen_pv_kexec_halt_t get_relocated_xpkh(void);
+extern void xen_pv_kexec_smp_send_stop(void);
+
+extern NORET_TYPE void xen_pv_relocate_kernel(unsigned long indirection_page,
+						unsigned long page_list,
+						unsigned long start_address,
+						int num_cpus, int cpu) ATTRIB_NORET;
+
+extern NORET_TYPE void xen_pv_kexec_halt(int cpu) ATTRIB_NORET;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -Npru kexec-kernel-only/include/asm-x86_64/mach-xen/asm/maddr.h kexec-kernel-only_20120522/include/asm-x86_64/mach-xen/asm/maddr.h
--- kexec-kernel-only/include/asm-x86_64/mach-xen/asm/maddr.h	2012-01-25 14:15:19.000000000 +0100
+++ kexec-kernel-only_20120522/include/asm-x86_64/mach-xen/asm/maddr.h	2012-04-26 19:52:25.000000000 +0200
@@ -16,6 +16,7 @@ typedef unsigned long maddr_t;
 #ifdef CONFIG_XEN
 
 extern unsigned long *phys_to_machine_mapping;
+extern unsigned long p2m_max_pfn;
 
 #undef machine_to_phys_mapping
 extern unsigned long *machine_to_phys_mapping;
@@ -25,7 +26,7 @@ static inline unsigned long pfn_to_mfn(u
 {
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return pfn;
-	BUG_ON(end_pfn && pfn >= end_pfn);
+	BUG_ON(p2m_max_pfn && pfn >= p2m_max_pfn);
 	return phys_to_machine_mapping[pfn] & ~FOREIGN_FRAME_BIT;
 }
 
@@ -33,7 +34,7 @@ static inline int phys_to_machine_mappin
 {
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return 1;
-	BUG_ON(end_pfn && pfn >= end_pfn);
+	BUG_ON(p2m_max_pfn && pfn >= p2m_max_pfn);
 	return (phys_to_machine_mapping[pfn] != INVALID_P2M_ENTRY);
 }
 
@@ -45,7 +46,7 @@ static inline unsigned long mfn_to_pfn(u
 		return mfn;
 
 	if (unlikely((mfn >> machine_to_phys_order) != 0))
-		return end_pfn;
+		return p2m_max_pfn;
 
 	/* The array access can fail (e.g., device space beyond end of RAM). */
 	asm (
@@ -60,7 +61,7 @@ static inline unsigned long mfn_to_pfn(u
 		"	.quad 1b,3b\n"
 		".previous"
 		: "=r" (pfn)
-		: "m" (machine_to_phys_mapping[mfn]), "m" (end_pfn) );
+		: "m" (machine_to_phys_mapping[mfn]), "m" (p2m_max_pfn) );
 
 	return pfn;
 }
@@ -88,16 +89,16 @@ static inline unsigned long mfn_to_pfn(u
 static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 {
 	unsigned long pfn = mfn_to_pfn(mfn);
-	if ((pfn < end_pfn)
+	if ((pfn < p2m_max_pfn)
 	    && !xen_feature(XENFEAT_auto_translated_physmap)
 	    && (phys_to_machine_mapping[pfn] != mfn))
-		return end_pfn; /* force !pfn_valid() */
+		return p2m_max_pfn; /* force !pfn_valid() */
 	return pfn;
 }
 
 static inline void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
-	BUG_ON(end_pfn && pfn >= end_pfn);
+	BUG_ON(p2m_max_pfn && pfn >= p2m_max_pfn);
 	if (xen_feature(XENFEAT_auto_translated_physmap)) {
 		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
 		return;
diff -Npru kexec-kernel-only/include/asm-x86_64/mach-xen/asm/page.h kexec-kernel-only_20120522/include/asm-x86_64/mach-xen/asm/page.h
--- kexec-kernel-only/include/asm-x86_64/mach-xen/asm/page.h	2012-01-25 14:15:19.000000000 +0100
+++ kexec-kernel-only_20120522/include/asm-x86_64/mach-xen/asm/page.h	2012-04-26 19:08:54.000000000 +0200
@@ -188,7 +188,7 @@ static inline pgd_t __pgd(unsigned long 
 
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 #ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < end_pfn)
+#define pfn_valid(pfn)		((pfn) < p2m_max_pfn)
 #endif
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
diff -Npru kexec-kernel-only/include/asm-x86_64/mach-xen/asm/pgalloc.h kexec-kernel-only_20120522/include/asm-x86_64/mach-xen/asm/pgalloc.h
--- kexec-kernel-only/include/asm-x86_64/mach-xen/asm/pgalloc.h	2012-01-25 14:15:02.000000000 +0100
+++ kexec-kernel-only_20120522/include/asm-x86_64/mach-xen/asm/pgalloc.h	2012-02-02 09:27:14.000000000 +0100
@@ -110,10 +110,12 @@ static inline void pud_free(pud_t *pud)
 	free_page((unsigned long)pud);
 }
 
-static inline void pgd_list_add(pgd_t *pgd)
+static inline void pgd_list_add(pgd_t *pgd, void *mm)
 {
 	struct page *page = virt_to_page(pgd);
 
+	page->mapping = mm;
+
 	spin_lock(&pgd_lock);
 	page->index = (pgoff_t)pgd_list;
 	if (pgd_list)
@@ -134,6 +136,8 @@ static inline void pgd_list_del(pgd_t *p
 	if (next)
 		next->private = (unsigned long)pprev;
 	spin_unlock(&pgd_lock);
+
+	page->mapping = NULL;
 }
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
@@ -146,7 +150,7 @@ static inline pgd_t *pgd_alloc(struct mm
 
 	if (!pgd)
 		return NULL;
-	pgd_list_add(pgd);
+	pgd_list_add(pgd, mm);
 	/*
 	 * Copy kernel pointers in from init.
 	 * Could keep a freelist or slab cache of those because the kernel
@@ -171,6 +175,8 @@ static inline void pgd_free(pgd_t *pgd)
 {
 	pte_t *ptep = virt_to_ptep(pgd);
 
+	pgd_list_del(pgd);
+
 	if (!pte_write(*ptep)) {
 		xen_pgd_unpin(__pa(pgd));
 		BUG_ON(HYPERVISOR_update_va_mapping(
@@ -190,7 +196,6 @@ static inline void pgd_free(pgd_t *pgd)
 			       0));
 	}
 
-	pgd_list_del(pgd);
 	free_pages((unsigned long)pgd, 1);
 }
 
diff -Npru kexec-kernel-only/include/linux/kexec.h kexec-kernel-only_20120522/include/linux/kexec.h
--- kexec-kernel-only/include/linux/kexec.h	2012-01-25 14:15:25.000000000 +0100
+++ kexec-kernel-only_20120522/include/linux/kexec.h	2012-05-22 13:08:23.000000000 +0200
@@ -96,6 +96,16 @@ struct kimage {
 	unsigned int type : 1;
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
+
+#ifdef CONFIG_X86_64
+	pgd_t *pgd;
+	pud_t *pud0;
+	pud_t *pud1;
+	pmd_t *pmd0;
+	pmd_t *pmd1;
+	pte_t *pte0;
+	pte_t *pte1;
+#endif
 };
 
 
@@ -109,6 +119,7 @@ extern int xen_machine_kexec_load(struct
 extern void xen_machine_kexec_unload(struct kimage *image);
 extern void xen_machine_kexec_setup_resources(void);
 extern void xen_machine_kexec_register_resources(struct resource *res);
+extern NORET_TYPE void xen_pv_machine_kexec(struct kimage *image) ATTRIB_NORET;
 #endif
 extern asmlinkage long sys_kexec_load(unsigned long entry,
 					unsigned long nr_segments,
diff -Npru kexec-kernel-only/include/xen/evtchn.h kexec-kernel-only_20120522/include/xen/evtchn.h
--- kexec-kernel-only/include/xen/evtchn.h	2012-01-25 14:15:26.000000000 +0100
+++ kexec-kernel-only_20120522/include/xen/evtchn.h	2012-05-21 13:35:58.000000000 +0200
@@ -82,10 +82,11 @@ extern int bind_ipi_to_irqhandler(
 	void *dev_id);
 
 /*
- * Common unbind function for all event sources. Takes IRQ to unbind from.
+ * Common unbind functions for all event sources. Takes IRQ to unbind from.
  * Automatically closes the underlying event channel (even for bindings
  * made with bind_evtchn_to_irqhandler()).
  */
+extern void __unbind_from_irqhandler(unsigned int irq, void *dev_id);
 extern void unbind_from_irqhandler(unsigned int irq, void *dev_id);
 
 extern void irq_resume(void);
diff -Npru kexec-kernel-only/include/xen/hypercall.h kexec-kernel-only_20120522/include/xen/hypercall.h
--- kexec-kernel-only/include/xen/hypercall.h	1970-01-01 01:00:00.000000000 +0100
+++ kexec-kernel-only_20120522/include/xen/hypercall.h	2011-10-22 18:12:49.000000000 +0200
@@ -0,0 +1,30 @@
+#ifndef __XEN_HYPERCALL_H__
+#define __XEN_HYPERCALL_H__
+
+#include <asm/hypercall.h>
+
+static inline int __must_check
+HYPERVISOR_multicall_check(
+	multicall_entry_t *call_list, unsigned int nr_calls,
+	const unsigned long *rc_list)
+{
+	int rc = HYPERVISOR_multicall(call_list, nr_calls);
+
+	if (unlikely(rc < 0))
+		return rc;
+	BUG_ON(rc);
+	BUG_ON((int)nr_calls < 0);
+
+	for ( ; nr_calls > 0; --nr_calls, ++call_list)
+		if (unlikely(call_list->result != (rc_list ? *rc_list++ : 0)))
+			return nr_calls;
+
+	return 0;
+}
+
+/* A construct to ignore the return value of hypercall wrappers in a few
+ * exceptional cases (simply casting the function result to void doesn't
+ * avoid the compiler warning): */
+#define VOID(expr) ((void)((expr)?:0))
+
+#endif /* __XEN_HYPERCALL_H__ */
diff -Npru kexec-kernel-only/include/xen/interface/arch-x86_64.h kexec-kernel-only_20120522/include/xen/interface/arch-x86_64.h
--- kexec-kernel-only/include/xen/interface/arch-x86_64.h	2012-01-25 14:15:01.000000000 +0100
+++ kexec-kernel-only_20120522/include/xen/interface/arch-x86_64.h	2012-05-20 22:44:26.000000000 +0200
@@ -105,6 +105,11 @@ DEFINE_XEN_GUEST_HANDLE(xen_pfn_t);
 #define FLAT_USER_SS32 FLAT_RING3_SS32
 #define FLAT_USER_SS   FLAT_USER_SS64
 
+#define ROOT_PAGETABLE_FIRST_XEN_SLOT	256
+#define ROOT_PAGETABLE_LAST_XEN_SLOT	271
+#define ROOT_PAGETABLE_XEN_SLOTS \
+		(ROOT_PAGETABLE_LAST_XEN_SLOT - ROOT_PAGETABLE_FIRST_XEN_SLOT + 1)
+
 #define __HYPERVISOR_VIRT_START 0xFFFF800000000000
 #define __HYPERVISOR_VIRT_END   0xFFFF880000000000
 #define __MACH2PHYS_VIRT_START  0xFFFF800000000000
diff -Npru kexec-kernel-only/include/xen/interface/io/xs_wire.h kexec-kernel-only_20120522/include/xen/interface/io/xs_wire.h
--- kexec-kernel-only/include/xen/interface/io/xs_wire.h	2012-01-25 14:15:01.000000000 +0100
+++ kexec-kernel-only_20120522/include/xen/interface/io/xs_wire.h	2012-02-10 21:25:12.000000000 +0100
@@ -26,7 +26,11 @@ enum xsd_sockmsg_type
     XS_SET_PERMS,
     XS_WATCH_EVENT,
     XS_ERROR,
-    XS_IS_DOMAIN_INTRODUCED
+    XS_IS_DOMAIN_INTRODUCED,
+    XS_RESUME,
+    XS_SET_TARGET,
+    XS_RESTRICT,
+    XS_RESET_WATCHES
 };
 
 #define XS_WRITE_NONE "NONE"
diff -Npru kexec-kernel-only/kernel/kexec.c kexec-kernel-only_20120522/kernel/kexec.c
--- kexec-kernel-only/kernel/kexec.c	2012-01-25 14:15:25.000000000 +0100
+++ kexec-kernel-only_20120522/kernel/kexec.c	2012-05-21 19:00:36.000000000 +0200
@@ -351,17 +351,19 @@ static struct page *kimage_alloc_pages(g
 	if (pages) {
 		unsigned int count, i;
 #ifdef CONFIG_XEN
-		int address_bits;
+		if (is_initial_xendomain()) {
+			int address_bits;
 
-		if (limit == ~0UL)
-			address_bits = BITS_PER_LONG;
-		else
-			address_bits = long_log2(limit);
-
-		if (xen_create_contiguous_region((unsigned long)page_address(pages),
-						 order, address_bits) < 0) {
-			__free_pages(pages, order);
-			return NULL;
+			if (limit == ~0UL)
+				address_bits = BITS_PER_LONG;
+			else
+				address_bits = long_log2(limit);
+
+			if (xen_create_contiguous_region((unsigned long)page_address(pages),
+							 order, address_bits) < 0) {
+				__free_pages(pages, order);
+				return NULL;
+			}
 		}
 #endif
 		pages->mapping = NULL;
@@ -383,7 +385,8 @@ static void kimage_free_pages(struct pag
 	for (i = 0; i < count; i++)
 		ClearPageReserved(page + i);
 #ifdef CONFIG_XEN
-	xen_destroy_contiguous_region((unsigned long)page_address(page), order);
+	if (is_initial_xendomain())
+		xen_destroy_contiguous_region((unsigned long)page_address(page), order);
 #endif
 	__free_pages(page, order);
 }
@@ -467,7 +470,6 @@ static struct page *kimage_alloc_normal_
 	return pages;
 }
 
-#ifndef CONFIG_XEN
 static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 						      unsigned int order)
 {
@@ -542,19 +544,16 @@ struct page *kimage_alloc_control_pages(
 		pages = kimage_alloc_normal_control_pages(image, order);
 		break;
 	case KEXEC_TYPE_CRASH:
+#ifdef CONFIG_XEN
+		if (is_initial_xendomain())
+			return kimage_alloc_normal_control_pages(image, order);
+#endif
 		pages = kimage_alloc_crash_control_pages(image, order);
 		break;
 	}
 
 	return pages;
 }
-#else /* !CONFIG_XEN */
-struct page *kimage_alloc_control_pages(struct kimage *image,
-					 unsigned int order)
-{
-	return kimage_alloc_normal_control_pages(image, order);
-}
-#endif
 
 static int kimage_add_entry(struct kimage *image, kimage_entry_t entry)
 {
@@ -857,7 +856,6 @@ out:
 	return result;
 }
 
-#ifndef CONFIG_XEN
 static int kimage_load_crash_segment(struct kimage *image,
 					struct kexec_segment *segment)
 {
@@ -923,19 +921,16 @@ static int kimage_load_segment(struct ki
 		result = kimage_load_normal_segment(image, segment);
 		break;
 	case KEXEC_TYPE_CRASH:
+#ifdef CONFIG_XEN
+		if (is_initial_xendomain())
+			return kimage_load_normal_segment(image, segment);
+#endif
 		result = kimage_load_crash_segment(image, segment);
 		break;
 	}
 
 	return result;
 }
-#else /* CONFIG_XEN */
-static int kimage_load_segment(struct kimage *image,
-				struct kexec_segment *segment)
-{
-	return kimage_load_normal_segment(image, segment);
-}
-#endif
 
 /*
  * Exec Kernel system call: for obvious reasons only root may call it.

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kexec-kernel-only_20121119.patch"

diff -Npru kexec-kernel-only/arch/x86_64/kernel/machine_kexec.c kexec-kernel-only_20121119/arch/x86_64/kernel/machine_kexec.c
--- kexec-kernel-only/arch/x86_64/kernel/machine_kexec.c	2012-09-17 11:56:42.000000000 +0200
+++ kexec-kernel-only_20121119/arch/x86_64/kernel/machine_kexec.c	2012-11-07 13:09:47.000000000 +0100
@@ -833,7 +833,6 @@ NORET_TYPE void xen_pv_machine_kexec(str
 	}
 
 	xen_pgd_unpin(__pa_symbol(init_level4_user_pgt));
-	xen_pgd_unpin(__pa(xen_start_info->pt_base));
 	xen_pgd_unpin(__pa(init_mm.pgd));
 
 	/* Move NULL segment selector to %ds and %es register. */
diff -Npru kexec-kernel-only/arch/x86_64/kernel/setup-xen.c kexec-kernel-only_20121119/arch/x86_64/kernel/setup-xen.c
--- kexec-kernel-only/arch/x86_64/kernel/setup-xen.c	2012-09-17 11:56:42.000000000 +0200
+++ kexec-kernel-only_20121119/arch/x86_64/kernel/setup-xen.c	2012-11-17 22:33:25.000000000 +0100
@@ -588,8 +588,13 @@ static __init void parse_cmdline_early (
 				size = memparse(from+12, &from);
 				if (*from == '@') {
 					base = memparse(from+1, &from);
-					crashk_res.start = base;
-					crashk_res.end   = base + size - 1;
+					if (base > __pa_symbol(&_end)) {
+						crashk_res.start = base;
+						crashk_res.end   = base + size - 1;
+					} else
+						printk("Crashkernel region overlaps "
+							"with current kernel. Ignoring "
+							"crashkernel command line argument.\n");
 				}
 			}
 		}
@@ -813,9 +818,12 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
-	/* Reserve direct mapping */
-	reserve_bootmem_generic(table_start << PAGE_SHIFT, 
-				(table_end - table_start) << PAGE_SHIFT,
+	/*
+	 * Reserve magic pages (start info, xenstore and console)
+	 * direct mapping and initial page tables.
+	 */
+	reserve_bootmem_generic((table_start - mp_new_count()) << PAGE_SHIFT, 
+				(table_end - table_start + mp_new_count()) << PAGE_SHIFT,
 				BOOTMEM_DEFAULT);
 
 	/* reserve kernel */
@@ -824,9 +832,22 @@ void __init setup_arch(char **cmdline_p)
 				BOOTMEM_DEFAULT);
 
 #ifdef CONFIG_XEN
+#ifdef CONFIG_KEXEC
 	/* reserve physmap, start info and initial page tables */
-	reserve_bootmem(__pa_symbol(&_end), (table_start<<PAGE_SHIFT)-__pa_symbol(&_end),
-			BOOTMEM_DEFAULT);
+	if (!is_initial_xendomain() && crashk_res.start != crashk_res.end) {
+		reserve_bootmem(__pa_symbol(&_end),
+				min(__pa(xen_start_info->pt_base), (unsigned long)crashk_res.start) -
+					__pa_symbol(&_end), BOOTMEM_DEFAULT);
+		if (__pa(xen_start_info->pt_base) > crashk_res.end + 1)
+			reserve_bootmem(crashk_res.end + 1,
+					__pa(xen_start_info->pt_base) -
+						crashk_res.end + 1, BOOTMEM_DEFAULT);
+	} else
+#endif
+	{
+		reserve_bootmem(__pa_symbol(&_end), ((table_start - mp_new_count()) << PAGE_SHIFT) -
+				__pa_symbol(&_end), BOOTMEM_DEFAULT);
+	}
 #else
 	/*
 	 * reserve physical page 0 - it's a special BIOS page on many boxes,
@@ -949,10 +970,25 @@ void __init setup_arch(char **cmdline_p)
 			       (unsigned long *)xen_start_info->mfn_list,
 			       min(xen_start_info->nr_pages, p2m_max_pfn) *
 			       sizeof(unsigned long));
-			free_bootmem(
-				__pa(xen_start_info->mfn_list),
-				PFN_PHYS(PFN_UP(xen_start_info->nr_pages *
-						sizeof(unsigned long))));
+
+#ifdef CONFIG_KEXEC
+			if (!is_initial_xendomain() && crashk_res.start != crashk_res.end) {
+				if (__pa(xen_start_info->mfn_list) < crashk_res.start)
+					free_bootmem(__pa(xen_start_info->mfn_list),
+							min(__pa(xen_start_info->pt_base),
+							(unsigned long)crashk_res.start) -
+							__pa(xen_start_info->mfn_list));
+				if (__pa(xen_start_info->pt_base) > crashk_res.end + 1)
+					free_bootmem(crashk_res.end + 1,
+							__pa(xen_start_info->pt_base) -
+							crashk_res.end + 1);
+			} else
+#endif
+			{
+				free_bootmem(__pa(xen_start_info->mfn_list),
+						__pa(xen_start_info->pt_base) -
+						__pa(xen_start_info->mfn_list));
+			}
 
 			/*
 			 * Initialise the list of the frames that specify the
diff -Npru kexec-kernel-only/arch/x86_64/mm/init-xen.c kexec-kernel-only_20121119/arch/x86_64/mm/init-xen.c
--- kexec-kernel-only/arch/x86_64/mm/init-xen.c	2012-09-17 11:56:27.000000000 +0200
+++ kexec-kernel-only_20121119/arch/x86_64/mm/init-xen.c	2012-11-16 13:36:48.000000000 +0100
@@ -29,6 +29,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
+#include <linux/kexec.h>
+#include <linux/pfn.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -55,10 +57,15 @@ struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static unsigned long dma_reserve __initdata;
+static unsigned long extended_nr_pt_frames __initdata;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 extern unsigned long start_pfn;
 
+#define mp_new_start_info_pfn()	(table_start - 1)
+#define mp_new_console_pfn()	(table_start - 2)
+#define mp_new_xenstore_pfn()	(table_start - 3)
+
 /*
  * Use this until direct mapping is established, i.e. before __va() is 
  * available in init_memory_mapping().
@@ -405,7 +412,8 @@ static inline int make_readonly(unsigned
 	/* Make old page tables read-only. */
 	if (!xen_feature(XENFEAT_writable_page_tables)
 	    && (paddr >= (xen_start_info->pt_base - __START_KERNEL_map))
-	    && (paddr < (start_pfn << PAGE_SHIFT)))
+	    && (paddr < (xen_start_info->pt_base - __START_KERNEL_map +
+			    (extended_nr_pt_frames << PAGE_SHIFT))))
 		readonly = 1;
 
 	/*
@@ -585,9 +593,7 @@ void __init extend_init_mapping(unsigned
 	}
 
 	/* Ensure init mappings cover kernel text/data and initial tables. */
-	while (va < (__START_KERNEL_map
-		     + (start_pfn << PAGE_SHIFT)
-		     + tables_space)) {
+	while (va < (__START_KERNEL_map + PFN_PHYS(table_end))) {
 		pmd = (pmd_t *)&page[pmd_index(va)];
 		if (pmd_none(*pmd)) {
 			pte_page = alloc_static_page(&phys);
@@ -606,17 +612,91 @@ void __init extend_init_mapping(unsigned
 			xen_l1_entry_update(pte, new_pte);
 		}
 		va += PAGE_SIZE;
+		if (table_start < start_pfn + mp_new_count()) {
+			table_start = start_pfn + mp_new_count();
+			table_end = table_start + tables_space;
+		}
+	}
+
+	extended_nr_pt_frames = start_pfn - PFN_DOWN(__pa(xen_start_info->pt_base));
+	
+	start_pfn = table_start;
+}
+
+#ifdef CONFIG_KEXEC
+static void __init rebuild_init_mapping(void)
+{
+	pgd_t *pgd = init_level4_pgt;
+	pmd_t *pmd;
+	pud_t *pud;
+	pte_t *pte, pte_w;
+	unsigned long i, phys, va = round_down((unsigned long)&_text, PMD_SIZE);
+	void *pte_dst, *pte_src;
+
+	if (is_initial_xendomain() || crashk_res.start == crashk_res.end)
+		return;
+
+	pud = __va(pgd_val(pgd[pgd_index(va)]) & PHYSICAL_PAGE_MASK);
+	pmd = __va(pud_val(pud[pud_index(va)]) & PHYSICAL_PAGE_MASK);
+
+	/* Ensure init mappings cover kernel text/data. */
+	while (va < (unsigned long)&_end) {
+		if (pmd_none(pmd[pmd_index(va)]))
+			continue;
+
+		pte_src = __va(pmd_val(pmd[pmd_index(va)]) & PHYSICAL_PAGE_MASK);
+		pte_dst = alloc_static_page(&phys);
+		memcpy(pte_dst, pte_src, PAGE_SIZE);
+
+		early_make_page_readonly(pte_dst, XENFEAT_writable_page_tables);
+		set_pmd(&pmd[pmd_index(va)], __pmd(phys | _KERNPG_TABLE));
+
+		va += PMD_SIZE;
 	}
 
+	va = PAGE_ALIGN((unsigned long)&_end);
+
 	/* Finally, blow away any spurious initial mappings. */
-	while (1) {
-		pmd = (pmd_t *)&page[pmd_index(va)];
-		if (pmd_none(*pmd))
-			break;
+	while (va < round_up((unsigned long)&_end, PMD_SIZE)) {
 		HYPERVISOR_update_va_mapping(va, __pte_ma(0), 0);
 		va += PAGE_SIZE;
 	}
+
+	while (va < round_up((unsigned long)&_end, PUD_SIZE)) {
+		if (pmd_none(pmd[pmd_index(va)]))
+			break;
+
+		pmd_clear(&pmd[pmd_index(va)]);
+
+		va += PMD_SIZE;
+	}
+
+	va = xen_start_info->pt_base;
+
+	/* Unpin initial page table. */
+	xen_pgd_unpin(__pa(va));
+
+	pud = __va(pgd_val(pgd[pgd_index(va)]) & PHYSICAL_PAGE_MASK);
+	pmd = __va(pud_val(pud[pud_index(va)]) & PHYSICAL_PAGE_MASK);
+
+	/* Mark initial page table pages as writable. */
+	for (i = 0; i < extended_nr_pt_frames; ++i) {
+		pte = __va(pmd_val(pmd[pmd_index(va)]) & PHYSICAL_PAGE_MASK);
+		pte = &pte[pte_index(va)];
+
+		pte_w.pte = pte->pte | _PAGE_RW;
+
+		if (HYPERVISOR_update_va_mapping(va, pte_w, 0))
+			BUG();
+
+		va += PAGE_SIZE;
+	}
 }
+#else
+static void __init rebuild_init_mapping(void)
+{
+}
+#endif
 
 static void __init find_early_table_space(unsigned long end)
 {
@@ -626,18 +706,80 @@ static void __init find_early_table_spac
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	ptes = (end + PTE_SIZE - 1) >> PAGE_SHIFT;
 
+#ifdef CONFIG_KEXEC
+	if (!is_initial_xendomain() && crashk_res.start != crashk_res.end)
+		ptes += (PAGE_ALIGN((unsigned long)_end) -
+			round_down((unsigned long)&_text, PMD_SIZE)) >> PAGE_SHIFT;
+#endif
+
 	tables = round_up(puds * 8, PAGE_SIZE) + 
 		round_up(pmds * 8, PAGE_SIZE) + 
 		round_up(ptes * 8, PAGE_SIZE); 
 
-	extend_init_mapping(tables);
+	tables >>= PAGE_SHIFT;
 
 	table_start = start_pfn;
-	table_end = table_start + (tables>>PAGE_SHIFT);
+
+#ifdef CONFIG_KEXEC
+	if (!is_initial_xendomain())
+		table_start = max(table_start, PFN_UP((unsigned long)crashk_res.end));
+#endif
+
+	/* Reserve area for new magic pages (start info, xenstore and console). */
+	table_start += mp_new_count();
+
+	table_end = table_start + tables;
+
+	extend_init_mapping(tables);
 
 	early_printk("kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT,
-		     (table_end << PAGE_SHIFT) + tables);
+		end, table_start << PAGE_SHIFT, table_end << PAGE_SHIFT);
+}
+
+static void __init *map_magic_page(unsigned long pfn_new, unsigned long pfn_old)
+{
+	struct mmu_update m2p_updates[2] = {};
+	unsigned long mfn_new, mfn_old, va;
+
+	mfn_new = pfn_to_mfn(pfn_new);
+	mfn_old = pfn_to_mfn(pfn_old);
+
+	m2p_updates[0].ptr = PFN_PHYS(mfn_old);
+	m2p_updates[0].ptr |= MMU_MACHPHYS_UPDATE;
+	m2p_updates[0].val = pfn_new;
+
+	m2p_updates[1].ptr = PFN_PHYS(mfn_new);
+	m2p_updates[1].ptr |= MMU_MACHPHYS_UPDATE;
+	m2p_updates[1].val = pfn_old;
+
+	if (HYPERVISOR_mmu_update(m2p_updates, 2, NULL, DOMID_SELF))
+		BUG();
+
+	phys_to_machine_mapping[pfn_new] = mfn_old;
+	phys_to_machine_mapping[pfn_old] = mfn_new;
+
+	va = __START_KERNEL_map + PFN_PHYS(pfn_new);
+
+	if (HYPERVISOR_update_va_mapping(va,
+			pfn_pte(pfn_new, PAGE_KERNEL_EXEC),
+				UVMF_INVLPG | UVMF_LOCAL))
+		BUG();
+
+	return (void *)va;
+}
+
+static void __init relocate_magic_pages(void)
+{
+	xen_start_info = map_magic_page(mp_new_start_info_pfn(),
+					PFN_DOWN(__pa(xen_start_info)));
+
+	if (is_initial_xendomain())
+		return;
+
+	map_magic_page(mp_new_xenstore_pfn(),
+				mfn_to_pfn(xen_start_info->store_mfn));
+	map_magic_page(mp_new_console_pfn(),
+				mfn_to_pfn(xen_start_info->console.domU.mfn));
 }
 
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
@@ -657,6 +799,8 @@ void __init init_memory_mapping(unsigned
 	 */
 	find_early_table_space(end);
 
+	relocate_magic_pages();
+
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
 
@@ -675,8 +819,6 @@ void __init init_memory_mapping(unsigned
 		set_pgd(pgd, mk_kernel_pgd(pud_phys));
 	}
 
-	BUG_ON(start_pfn != table_end);
-
 	/* Re-vector virtual addresses pointing into the initial
 	   mapping to the just-established permanent ones. */
 	xen_start_info = __va(__pa(xen_start_info));
@@ -691,14 +833,25 @@ void __init init_memory_mapping(unsigned
 		xen_start_info->mod_start = (unsigned long)
 			__va(__pa(xen_start_info->mod_start));
 
-	/* Destroy the Xen-created mappings beyond the kernel image as
-	 * well as the temporary mappings created above. Prevents
-	 * overlap with modules area (if init mapping is very big).
-	 */
-	start = PAGE_ALIGN((unsigned long)_end);
-	end   = __START_KERNEL_map + (table_end << PAGE_SHIFT);
-	for (; start < end; start += PAGE_SIZE)
-		WARN_ON(HYPERVISOR_update_va_mapping(start, __pte_ma(0), 0));
+	rebuild_init_mapping();
+
+	BUG_ON(start_pfn != table_end);
+
+#ifdef CONFIG_KEXEC
+	if (is_initial_xendomain() || crashk_res.start == crashk_res.end)
+#endif
+	{
+		/*
+		 * Destroy the Xen-created mappings beyond the kernel image as
+		 * well as the temporary mappings created above. Prevents
+		 * overlap with modules area (if init mapping is very big).
+		 */
+
+		start = PAGE_ALIGN((unsigned long)_end);
+		end   = __START_KERNEL_map + (table_end << PAGE_SHIFT);
+		for (; start < end; start += PAGE_SIZE)
+			WARN_ON(HYPERVISOR_update_va_mapping(start, __pte_ma(0), 0));
+	}
 
 	__flush_tlb_all();
 }
diff -Npru kexec-kernel-only/include/asm-x86_64/mach-xen/asm/page.h kexec-kernel-only_20121119/include/asm-x86_64/mach-xen/asm/page.h
--- kexec-kernel-only/include/asm-x86_64/mach-xen/asm/page.h	2012-09-17 11:56:42.000000000 +0200
+++ kexec-kernel-only_20121119/include/asm-x86_64/mach-xen/asm/page.h	2012-11-07 15:36:42.000000000 +0100
@@ -169,7 +169,7 @@ static inline pgd_t __pgd(unsigned long 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
-#define KERNEL_TEXT_SIZE  (_AC(40,UL)*1024*1024)
+#define KERNEL_TEXT_SIZE  (_AC(100,UL)*1024*1024)
 #define KERNEL_TEXT_START _AC(0xffffffff80000000,UL)
 
 #define PAGE_OFFSET		__PAGE_OFFSET
diff -Npru kexec-kernel-only/include/asm-x86_64/page.h kexec-kernel-only_20121119/include/asm-x86_64/page.h
--- kexec-kernel-only/include/asm-x86_64/page.h	2012-09-17 11:56:40.000000000 +0200
+++ kexec-kernel-only_20121119/include/asm-x86_64/page.h	2012-11-07 15:36:58.000000000 +0100
@@ -91,7 +91,7 @@ extern unsigned long phys_base;
 #define __VIRTUAL_MASK_SHIFT	48
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
-#define KERNEL_TEXT_SIZE  (_AC(40,UL)*1024*1024)
+#define KERNEL_TEXT_SIZE  (_AC(100,UL)*1024*1024)
 #define KERNEL_TEXT_START _AC(0xffffffff80000000,UL)
 
 #ifndef __ASSEMBLY__
diff -Npru kexec-kernel-only/include/asm-x86_64/proto.h kexec-kernel-only_20121119/include/asm-x86_64/proto.h
--- kexec-kernel-only/include/asm-x86_64/proto.h	2012-09-17 11:56:40.000000000 +0200
+++ kexec-kernel-only_20121119/include/asm-x86_64/proto.h	2012-11-07 14:25:09.000000000 +0100
@@ -153,6 +153,16 @@ extern int force_mwait;
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
+#ifdef CONFIG_XEN
+static inline int mp_new_count(void)
+{
+	if (is_initial_xendomain())
+		return 1;
+	else
+		return 3;
+}
+#endif
+
 #define round_up(x,y) (((x) + (y) - 1) & ~((y)-1))
 #define round_down(x,y) ((x) & ~((y)-1))
 

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kexec-kernel-only_20121203.patch"

diff -Npru kexec-kernel-only/arch/x86_64/kernel/machine_kexec.c kexec-kernel-only_20121203/arch/x86_64/kernel/machine_kexec.c
--- kexec-kernel-only/arch/x86_64/kernel/machine_kexec.c	2012-11-07 13:09:47.000000000 +0100
+++ kexec-kernel-only_20121203/arch/x86_64/kernel/machine_kexec.c	2012-12-03 10:48:06.000000000 +0100
@@ -813,9 +813,18 @@ NORET_TYPE void xen_pv_machine_kexec(str
 	atomic_inc(&control_page_ready);
 #endif
 
+#if 0
+	/*
+	 * Disabled due to some Amazon EC2 machines are not able
+	 * to restart timer properly in crash kernel. If this happens
+	 * then it hangs in loop in calibrate_delay_direct() because
+	 * jiffies are not incremented.
+	 */
+
 	/* Stop singleshot timer. */
 	if (HYPERVISOR_set_timer_op(0))
 		BUG();
+#endif
 
 #ifdef CONFIG_SMP
 	for_each_present_cpu(i)
diff -Npru kexec-kernel-only/init/calibrate.c kexec-kernel-only_20121203/init/calibrate.c
--- kexec-kernel-only/init/calibrate.c	2012-09-17 11:56:40.000000000 +0200
+++ kexec-kernel-only_20121203/init/calibrate.c	2012-12-03 10:34:02.000000000 +0100
@@ -67,7 +67,7 @@ static unsigned long __devinit calibrate
 		pre_start = 0;
 		read_current_timer(&start);
 		start_jiffies = jiffies;
-		while (jiffies <= (start_jiffies + tick_divider)) {
+		while (time_before_eq(jiffies, start_jiffies + tick_divider)) {
 			pre_start = start;
 			read_current_timer(&start);
 		}
@@ -75,8 +75,8 @@ static unsigned long __devinit calibrate
 
 		pre_end = 0;
 		end = post_start;
-		while (jiffies <=
-		       (start_jiffies + tick_divider * (1 + delay_calibration_ticks))) {
+		while (time_before_eq(jiffies,
+		       start_jiffies + tick_divider * (1 + delay_calibration_ticks))) {
 			pre_end = end;
 			read_current_timer(&end);
 		}

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kexec-tools-2.0.3_20120522.patch"

diff -Npru kexec-tools-2.0.3.orig/configure.ac kexec-tools-2.0.3/configure.ac
--- kexec-tools-2.0.3.orig/configure.ac	2012-01-15 23:17:28.000000000 +0100
+++ kexec-tools-2.0.3/configure.ac	2012-03-02 22:15:00.000000000 +0100
@@ -157,15 +157,23 @@ if test "$with_lzma" = yes ; then
 		AC_MSG_NOTICE([lzma support disabled])))
 fi
 
-dnl find Xen control stack libraries
-if test "$with_xen" = yes ; then
-	AC_CHECK_HEADER(xenctrl.h,
-		AC_CHECK_LIB(xenctrl, xc_version, ,
-		AC_MSG_NOTICE([Xen support disabled])))
-	if test "$ac_cv_lib_xenctrl_xc_version" = yes ; then
-		AC_CHECK_FUNCS(xc_get_machine_memory_map)
-	fi
-fi
+dnl Check for Xen support
+case $ARCH in
+	i386|x86_64 )
+		if test "$with_xen" = yes ; then
+			AC_CHECK_HEADER(xenctrl.h,
+				AC_CHECK_LIB(xenctrl, xc_version, ,
+				AC_MSG_NOTICE([Xen support disabled])))
+			if test "$ac_cv_lib_xenctrl_xc_version" = yes ; then
+				AC_CHECK_FUNCS(xc_get_machine_memory_map)
+				AC_CHECK_FUNCS(xc_get_memory_map)
+			fi
+		fi
+		;;
+	* )
+		AC_MSG_NOTICE([Xen is not supported on this architecture])
+		;;
+esac
 
 dnl ---Sanity checks
 if test "$CC"      = "no"; then AC_MSG_ERROR([cc not found]); fi
diff -Npru kexec-tools-2.0.3.orig/kexec/Makefile kexec-tools-2.0.3/kexec/Makefile
--- kexec-tools-2.0.3.orig/kexec/Makefile	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/Makefile	2012-03-27 09:27:33.000000000 +0200
@@ -20,7 +20,6 @@ KEXEC_SRCS += kexec/kexec-elf-boot.c
 KEXEC_SRCS += kexec/kexec-iomem.c
 KEXEC_SRCS += kexec/firmware_memmap.c
 KEXEC_SRCS += kexec/crashdump.c
-KEXEC_SRCS += kexec/crashdump-xen.c
 KEXEC_SRCS += kexec/phys_arch.c
 KEXEC_SRCS += kexec/kernel_version.c
 KEXEC_SRCS += kexec/lzma.c
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/Makefile kexec-tools-2.0.3/kexec/arch/i386/Makefile
--- kexec-tools-2.0.3.orig/kexec/arch/i386/Makefile	2010-07-29 11:22:16.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/i386/Makefile	2012-05-22 11:12:53.000000000 +0200
@@ -9,8 +9,13 @@ i386_KEXEC_SRCS += kexec/arch/i386/kexec
 i386_KEXEC_SRCS += kexec/arch/i386/kexec-multiboot-x86.c
 i386_KEXEC_SRCS += kexec/arch/i386/kexec-beoboot-x86.c
 i386_KEXEC_SRCS += kexec/arch/i386/kexec-nbi.c
+i386_KEXEC_SRCS += kexec/arch/i386/kexec-x86-xen-common.c
+i386_KEXEC_SRCS += kexec/arch/i386/kexec-xen-pv.c
+i386_KEXEC_SRCS += kexec/arch/i386/i386-xen-pv.c
+i386_KEXEC_SRCS += kexec/arch/i386/i386-xen-pv-kernel-bootstrap.S
 i386_KEXEC_SRCS += kexec/arch/i386/x86-linux-setup.c
 i386_KEXEC_SRCS += kexec/arch/i386/crashdump-x86.c
+i386_KEXEC_SRCS += kexec/arch/i386/crashdump-x86-xen.c
 
 dist += kexec/arch/i386/Makefile $(i386_KEXEC_SRCS)			\
 	kexec/arch/i386/kexec-x86.h kexec/arch/i386/crashdump-x86.h	\
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/crashdump-x86-xen.c kexec-tools-2.0.3/kexec/arch/i386/crashdump-x86-xen.c
--- kexec-tools-2.0.3.orig/kexec/arch/i386/crashdump-x86-xen.c	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/i386/crashdump-x86-xen.c	2012-04-27 15:04:51.000000000 +0200
@@ -0,0 +1,123 @@
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+#include <elf.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <xenctrl.h>
+
+#include "../../kexec.h"
+#include "../../kexec-xen.h"
+#include "../../crashdump.h"
+
+struct crash_note_info {
+	unsigned long base;
+	unsigned long length;
+};
+
+static int xen_phys_cpus;
+static struct crash_note_info *xen_phys_notes;
+
+unsigned long xen_architecture(struct crash_elf_info *elf_info)
+{
+	unsigned long machine = elf_info->machine;
+	int rc;
+	xen_capabilities_info_t capabilities;
+#ifdef XENCTRL_HAS_XC_INTERFACE
+	xc_interface *xc;
+#else
+	int xc;
+#endif
+
+	if (!(xen_detect() & XEN_DOM0))
+		goto out;
+
+	memset(capabilities, '0', XEN_CAPABILITIES_INFO_LEN);
+
+#ifdef XENCTRL_HAS_XC_INTERFACE
+	xc = xc_interface_open(NULL, NULL, 0);
+	if ( !xc ) {
+		fprintf(stderr, "failed to open xen control interface.\n");
+		goto out;
+	}
+#else
+	xc = xc_interface_open();
+	if ( xc == -1 ) {
+		fprintf(stderr, "failed to open xen control interface.\n");
+		goto out;
+	}
+#endif
+
+	rc = xc_version(xc, XENVER_capabilities, &capabilities[0]);
+	if ( rc == -1 ) {
+		fprintf(stderr, "failed to make Xen version hypercall.\n");
+		goto out_close;
+	}
+
+	if (strstr(capabilities, "xen-3.0-x86_64"))
+		machine = EM_X86_64;
+        else if (strstr(capabilities, "xen-3.0-x86_32"))
+		machine = EM_386;
+
+ out_close:
+	xc_interface_close(xc);
+
+ out:
+	return machine;
+}
+
+static int xen_crash_note_callback(void *UNUSED(data), int nr,
+				   char *UNUSED(str),
+				   unsigned long base,
+				   unsigned long length)
+{
+	struct crash_note_info *note = xen_phys_notes + nr;
+
+	note->base = base;
+	note->length = length;
+
+	return 0;
+}
+
+int xen_get_nr_phys_cpus(void)
+{
+	char *match = "Crash note\n";
+	int cpus, n;
+
+	if (xen_phys_cpus)
+		return xen_phys_cpus;
+
+	if ((cpus = kexec_iomem_for_each_line(match, NULL, NULL))) {
+		n = sizeof(struct crash_note_info) * cpus;
+		xen_phys_notes = malloc(n);
+		if (!xen_phys_notes) {
+			fprintf(stderr, "failed to allocate xen_phys_notes.\n");
+			return -1;
+		}
+		memset(xen_phys_notes, 0, n);
+		kexec_iomem_for_each_line(match,
+					  xen_crash_note_callback, NULL);
+		xen_phys_cpus = cpus;
+	}
+
+	return cpus;
+}
+
+int xen_get_note(int cpu, uint64_t *addr, uint64_t *len)
+{
+	struct crash_note_info *note;
+
+	if (xen_phys_cpus <= 0)
+		return -1;
+
+	note = xen_phys_notes + cpu;
+
+	*addr = note->base;
+	*len = note->length;
+
+	return 0;
+}
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/crashdump-x86.c kexec-tools-2.0.3/kexec/arch/i386/crashdump-x86.c
--- kexec-tools-2.0.3.orig/kexec/arch/i386/crashdump-x86.c	2011-11-21 09:48:53.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/i386/crashdump-x86.c	2012-04-27 14:47:04.000000000 +0200
@@ -30,6 +30,7 @@
 #include "../../kexec.h"
 #include "../../kexec-elf.h"
 #include "../../kexec-syscall.h"
+#include "../../kexec-xen.h"
 #include "../../crashdump.h"
 #include "kexec-x86.h"
 #include "crashdump-x86.h"
@@ -71,7 +72,7 @@ static int get_kernel_paddr(struct kexec
 	if (elf_info->machine != EM_X86_64)
 		return 0;
 
-	if (xen_present()) /* Kernel not entity mapped under Xen */
+	if (xen_detect() & XEN_DOM0) /* Kernel not entity mapped under Xen dom0 */
 		return 0;
 
 	if (parse_iomem_single("Kernel code\n", &start, NULL) == 0) {
@@ -108,7 +109,7 @@ static int get_kernel_vaddr_and_size(str
 	if (elf_info->machine != EM_X86_64)
 		return 0;
 
-	if (xen_present()) /* Kernel not entity mapped under Xen */
+	if (xen_detect() & XEN_DOM0) /* Kernel not entity mapped under Xen dom0 */
 		return 0;
 
 	align = getpagesize();
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/i386-xen-pv-kernel-bootstrap.S kexec-tools-2.0.3/kexec/arch/i386/i386-xen-pv-kernel-bootstrap.S
--- kexec-tools-2.0.3.orig/kexec/arch/i386/i386-xen-pv-kernel-bootstrap.S	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/i386/i386-xen-pv-kernel-bootstrap.S	2012-05-22 12:44:37.000000000 +0200
@@ -0,0 +1,111 @@
+/*
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+#define __ASSEMBLY__
+
+#include <xen/xen.h>
+
+#include "kexec-x86-xen.h"
+
+#ifdef UVMF_INVLPG
+#undef UVMF_INVLPG
+#endif
+
+#define DOMID_SELF	0x7ff0
+
+#define UVMF_INVLPG	2
+
+#define VCPUOP_down	2
+#define VCPUOP_is_up	3
+
+#define XPKB_TRANSITION	1
+#define XPKB_BOOTSTRAP	2
+
+	/*
+	 * This code must be in .data section because it is updated
+	 * by xen-pv loader (.text section is read only). However,
+	 * it is never executed in place. It is copied by xen-pv loader
+	 * to its destination and later called after purgatory code.
+	 */
+
+	.data
+	.globl	transition_pgtable_uvm, transition_pgtable_mfn, bootstrap_pgtable_mfn
+	.globl	bootstrap_stack_vaddr, xen_pv_kernel_entry_vaddr, start_info_vaddr
+	.globl	xen_pv_kernel_bootstrap, xen_pv_kernel_bootstrap_size
+
+xen_pv_kernel_bootstrap:
+
+transition_pgtable_uvm:
+	.rept	TRANSITION_PGTABLE_SIZE
+	.quad	__HYPERVISOR_update_va_mapping
+	.fill	3, 8, 0
+	.quad	UVMF_INVLPG
+	.fill	3, 8, 0
+	.endr
+
+transition_pgtable_mfn:
+	.quad	0			/* MFN of transition page table directory. */
+
+bootstrap_pgtable_mfn:
+	.quad	0			/* MFN of bootstrap page table directory. */
+
+bootstrap_stack_vaddr:
+	.quad	0			/* VIRTUAL address of bootstrap stack. */
+
+xen_pv_kernel_entry_vaddr:
+	.quad	0			/* VIRTUAL address of kernel entry point. */
+
+start_info_vaddr:
+	.quad	0			/* VIRTUAL address of start info. */
+
+mmuext_args:
+	.long	MMUEXT_NEW_BASEPTR	/* Operation. */
+	.long	0			/* PAD. */
+
+mmuext_new_baseptr:
+	.quad	0			/* MFN of target page table directory. */
+	.quad	0			/* UNUSED. */
+
+	.long	MMUEXT_NEW_USER_BASEPTR	/* Operation. */
+	.long	0			/* PAD. */
+
+mmuext_new_user_baseptr:
+	.quad	0			/* MFN of user target page table directory. */
+	.quad	0			/* UNUSED. */
+
+	.long	MMUEXT_PIN_L4_TABLE	/* Operation. */
+	.long	0			/* PAD. */
+
+mmuext_pin_l4_table:
+	.quad	0			/* MFN of page table directory to pin. */
+	.quad	0			/* UNUSED. */
+
+xen_pv_kernel_bootstrap_size:
+	.quad	. - xen_pv_kernel_bootstrap	/* Bootstrap size. */
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/i386-xen-pv.c kexec-tools-2.0.3/kexec/arch/i386/i386-xen-pv.c
--- kexec-tools-2.0.3.orig/kexec/arch/i386/i386-xen-pv.c	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/i386/i386-xen-pv.c	2012-05-22 12:44:47.000000000 +0200
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+#include <xenctrl.h>
+
+#include "../../kexec.h"
+#include "../../kexec-elf.h"
+#include "kexec-x86-xen.h"
+
+unsigned long build_bootstrap_pgtable(struct kexec_info *info,
+					struct xen_elf_notes *xen_elf_notes,
+					struct start_info *si_new, int p2m_seg)
+{
+}
+
+void build_transition_pgtable(struct kexec_info *info,
+				struct xen_elf_notes *xen_elf_notes,
+				int p2m_seg, int bs_seg)
+{
+}
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/include/arch/options.h kexec-tools-2.0.3/kexec/arch/i386/include/arch/options.h
--- kexec-tools-2.0.3.orig/kexec/arch/i386/include/arch/options.h	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/i386/include/arch/options.h	2012-05-12 17:04:22.000000000 +0200
@@ -29,6 +29,7 @@
 #define OPT_MOD 		(OPT_ARCH_MAX+7)
 #define OPT_VGA 		(OPT_ARCH_MAX+8)
 #define OPT_REAL_MODE		(OPT_ARCH_MAX+9)
+#define OPT_CONSOLE_XEN_PV	(OPT_ARCH_MAX+10)
 
 /* Options relevant to the architecture (excluding loader-specific ones): */
 #define KEXEC_ARCH_OPTIONS \
@@ -69,7 +70,8 @@
 	{ "args-none",		0, NULL, OPT_ARGS_NONE },	\
 	{ "debug",		0, NULL, OPT_DEBUG },		\
 	{ "module",		1, 0, OPT_MOD },		\
-	{ "real-mode",		0, NULL, OPT_REAL_MODE },
+	{ "real-mode",		0, NULL, OPT_REAL_MODE },	\
+	{ "console-xen-pv",	0, NULL, OPT_CONSOLE_XEN_PV },
 
 #define KEXEC_ALL_OPT_STR KEXEC_ARCH_OPT_STR
 
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86-common.c kexec-tools-2.0.3/kexec/arch/i386/kexec-x86-common.c
--- kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86-common.c	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/i386/kexec-x86-common.c	2012-03-27 10:06:17.000000000 +0200
@@ -17,41 +17,19 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#define _XOPEN_SOURCE	600
-#define _BSD_SOURCE
-
-#include <fcntl.h>
-#include <stddef.h>
-#include <stdio.h>
 #include <errno.h>
 #include <stdint.h>
-#include <string.h>
-#include <limits.h>
-#include <stdlib.h>
 #include <stdio.h>
-#include <sys/ioctl.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <unistd.h>
+#include <string.h>
+
+#include "../../firmware_memmap.h"
 #include "../../kexec.h"
 #include "../../kexec-syscall.h"
-#include "../../firmware_memmap.h"
-#include "../../crashdump.h"
+#include "../../kexec-xen.h"
 #include "kexec-x86.h"
+#include "kexec-x86-xen.h"
 
-#ifdef HAVE_LIBXENCTRL
-#ifdef HAVE_XC_GET_MACHINE_MEMORY_MAP
-#include <xenctrl.h>
-#else
-#define __XEN_TOOLS__	1
-#include <x86/x86-linux.h>
-#include <xen/xen.h>
-#include <xen/memory.h>
-#include <xen/sys/privcmd.h>
-#endif /* HAVE_XC_GET_MACHINE_MEMORY_MAP */
-#endif /* HAVE_LIBXENCTRL */
-
-static struct memory_range memory_range[MAX_MEMORY_RANGES];
+struct memory_range memory_range[MAX_MEMORY_RANGES];
 
 /**
  * The old /proc/iomem parsing code.
@@ -150,172 +128,6 @@ static int get_memory_ranges_sysfs(struc
 	return 0;
 }
 
-#ifdef HAVE_LIBXENCTRL
-static unsigned e820_to_kexec_type(uint32_t type)
-{
-	switch (type) {
-		case E820_RAM:
-			return RANGE_RAM;
-		case E820_ACPI:
-			return RANGE_ACPI;
-		case E820_NVS:
-			return RANGE_ACPI_NVS;
-		case E820_RESERVED:
-		default:
-			return RANGE_RESERVED;
-	}
-}
-
-/**
- * Memory map detection for Xen.
- *
- * @param[out] range pointer that will be set to an array that holds the
- *             memory ranges
- * @param[out] ranges number of ranges valid in @p range
- *
- * @return 0 on success, any other value on failure.
- */
-#ifdef HAVE_XC_GET_MACHINE_MEMORY_MAP
-static int get_memory_ranges_xen(struct memory_range **range, int *ranges)
-{
-	int rc, ret = -1;
-	struct e820entry e820entries[MAX_MEMORY_RANGES];
-	unsigned int i;
-#ifdef XENCTRL_HAS_XC_INTERFACE
-	xc_interface *xc;
-#else
-	int xc;
-#endif
-
-#ifdef XENCTRL_HAS_XC_INTERFACE
-	xc = xc_interface_open(NULL, NULL, 0);
-
-	if (!xc) {
-		fprintf(stderr, "%s: Failed to open Xen control interface\n", __func__);
-		goto err;
-	}
-#else
-	xc = xc_interface_open();
-
-	if (xc == -1) {
-		fprintf(stderr, "%s: Failed to open Xen control interface\n", __func__);
-		goto err;
-	}
-#endif
-
-	rc = xc_get_machine_memory_map(xc, e820entries, MAX_MEMORY_RANGES);
-
-	if (rc < 0) {
-		fprintf(stderr, "%s: xc_get_machine_memory_map: %s\n", __func__, strerror(rc));
-		goto err;
-	}
-
-	for (i = 0; i < rc; ++i) {
-		memory_range[i].start = e820entries[i].addr;
-		memory_range[i].end = e820entries[i].addr + e820entries[i].size;
-		memory_range[i].type = e820_to_kexec_type(e820entries[i].type);
-	}
-
-	qsort(memory_range, rc, sizeof(struct memory_range), compare_ranges);
-
-	*range = memory_range;
-	*ranges = rc;
-
-	ret = 0;
-
-err:
-	xc_interface_close(xc);
-
-	return ret;
-}
-#else
-static int get_memory_ranges_xen(struct memory_range **range, int *ranges)
-{
-	int fd, rc, ret = -1;
-	privcmd_hypercall_t hypercall;
-	struct e820entry *e820entries = NULL;
-	struct xen_memory_map *xen_memory_map = NULL;
-	unsigned int i;
-
-	fd = open("/proc/xen/privcmd", O_RDWR);
-
-	if (fd == -1) {
-		fprintf(stderr, "%s: open(/proc/xen/privcmd): %m\n", __func__);
-		goto err;
-	}
-
-	rc = posix_memalign((void **)&e820entries, sysconf(_SC_PAGESIZE),
-			    sizeof(struct e820entry) * MAX_MEMORY_RANGES);
-
-	if (rc) {
-		fprintf(stderr, "%s: posix_memalign(e820entries): %s\n", __func__, strerror(rc));
-		e820entries = NULL;
-		goto err;
-	}
-
-	rc = posix_memalign((void **)&xen_memory_map, sysconf(_SC_PAGESIZE),
-			    sizeof(struct xen_memory_map));
-
-	if (rc) {
-		fprintf(stderr, "%s: posix_memalign(xen_memory_map): %s\n", __func__, strerror(rc));
-		xen_memory_map = NULL;
-		goto err;
-	}
-
-	if (mlock(e820entries, sizeof(struct e820entry) * MAX_MEMORY_RANGES) == -1) {
-		fprintf(stderr, "%s: mlock(e820entries): %m\n", __func__);
-		goto err;
-	}
-
-	if (mlock(xen_memory_map, sizeof(struct xen_memory_map)) == -1) {
-		fprintf(stderr, "%s: mlock(xen_memory_map): %m\n", __func__);
-		goto err;
-	}
-
-	xen_memory_map->nr_entries = MAX_MEMORY_RANGES;
-	set_xen_guest_handle(xen_memory_map->buffer, e820entries);
-
-	hypercall.op = __HYPERVISOR_memory_op;
-	hypercall.arg[0] = XENMEM_machine_memory_map;
-	hypercall.arg[1] = (__u64)xen_memory_map;
-
-	rc = ioctl(fd, IOCTL_PRIVCMD_HYPERCALL, &hypercall);
-
-	if (rc == -1) {
-		fprintf(stderr, "%s: ioctl(IOCTL_PRIVCMD_HYPERCALL): %m\n", __func__);
-		goto err;
-	}
-
-	for (i = 0; i < xen_memory_map->nr_entries; ++i) {
-		memory_range[i].start = e820entries[i].addr;
-		memory_range[i].end = e820entries[i].addr + e820entries[i].size;
-		memory_range[i].type = e820_to_kexec_type(e820entries[i].type);
-	}
-
-	qsort(memory_range, xen_memory_map->nr_entries, sizeof(struct memory_range), compare_ranges);
-
-	*range = memory_range;
-	*ranges = xen_memory_map->nr_entries;
-
-	ret = 0;
-
-err:
-	munlock(xen_memory_map, sizeof(struct xen_memory_map));
-	munlock(e820entries, sizeof(struct e820entry) * MAX_MEMORY_RANGES);
-	free(xen_memory_map);
-	free(e820entries);
-	close(fd);
-
-	return ret;
-}
-#endif /* HAVE_XC_GET_MACHINE_MEMORY_MAP */
-#else
-static int get_memory_ranges_xen(struct memory_range **range, int *ranges)
-{
-	return 0;
-}
-#endif /* HAVE_LIBXENCTRL */
-
 static void remove_range(struct memory_range *range, int nr_ranges, int index)
 {
 	int i, j;
@@ -429,11 +241,11 @@ int get_memory_ranges(struct memory_rang
 {
 	int ret, i;
 
-	if (!efi_map_added() && !xen_present() && have_sys_firmware_memmap()) {
+	if (!efi_map_added() && !(xen_detect() & XEN_PV) && have_sys_firmware_memmap()) {
 		ret = get_memory_ranges_sysfs(range, ranges);
 		if (!ret)
 			ret = fixup_memory_ranges(range, ranges);
-	} else if (xen_present()) {
+	} else if (xen_detect() & XEN_PV) {
 		ret = get_memory_ranges_xen(range, ranges);
 		if (!ret)
 			ret = fixup_memory_ranges(range, ranges);
@@ -493,5 +305,3 @@ int get_memory_ranges(struct memory_rang
 
 	return ret;
 }
-
-
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86-xen-common.c kexec-tools-2.0.3/kexec/arch/i386/kexec-x86-xen-common.c
--- kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86-xen-common.c	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/i386/kexec-x86-xen-common.c	2012-05-22 12:34:14.000000000 +0200
@@ -0,0 +1,320 @@
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+#define _XOPEN_SOURCE	600
+#define _BSD_SOURCE
+#define _GNU_SOURCE
+
+#include <fcntl.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "../../firmware_memmap.h"
+#include "../../kexec.h"
+#include "../../kexec-xen.h"
+#include "kexec-x86.h"
+
+#if defined(HAVE_XC_GET_MACHINE_MEMORY_MAP) && defined(HAVE_XC_GET_MEMORY_MAP)
+#include <xenctrl.h>
+#else
+#define __XEN_TOOLS__	1
+#include <x86/x86-linux.h>
+#include <xen/xen.h>
+#include <xen/memory.h>
+#include <xen/sys/privcmd.h>
+#endif
+
+#define XEN_CHECK_HVM	0
+#define XEN_CHECK_PV	1
+
+#ifdef __i386__
+#define R(x) "%%e"#x"x"
+#else
+#define R(x) "%%r"#x"x"
+#endif
+
+static jmp_buf xen_sigill_jmp;
+
+/* Based on code from xen-detect.c. */
+
+static void xen_sigill_handler(int sig)
+{
+	longjmp(xen_sigill_jmp, 1);
+}
+
+/* Based on code from xen-detect.c. */
+
+static void xen_cpuid(uint32_t idx, uint32_t *regs, int pv_context)
+{
+	asm volatile (
+	"push "R(a)"; push "R(b)"; push "R(c)"; push "R(d)"\n\t"
+	"test %1,%1 ; jz 1f ; ud2a ; .ascii \"xen\" ; 1: cpuid\n\t"
+	"mov %%eax,(%2); mov %%ebx,4(%2)\n\t"
+	"mov %%ecx,8(%2); mov %%edx,12(%2)\n\t"
+	"pop "R(d)"; pop "R(c)"; pop "R(b)"; pop "R(a)"\n\t"
+	: : "a" (idx), "c" (pv_context), "S" (regs) : "memory" );
+}
+
+/* Based on code from xen-detect.c. */
+
+static int check_for_xen(int pv_context)
+{
+	uint32_t regs[4];
+	char signature[13];
+	uint32_t base;
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100)
+	{
+		xen_cpuid(base, regs, pv_context);
+
+		*(uint32_t *)(signature + 0) = regs[1];
+		*(uint32_t *)(signature + 4) = regs[2];
+		*(uint32_t *)(signature + 8) = regs[3];
+		signature[12] = '\0';
+
+		if (strcmp("XenVMMXenVMM", signature) == 0 && regs[0] >= (base + 2))
+			goto found;
+	}
+
+	return 0;
+
+found:
+	return 1;
+}
+
+/* Based on code from xen-detect.c. */
+
+int xen_detect(void)
+{
+	char buf[32] = {};
+	int fd;
+	sighandler_t sig = sig; /* Do not emit uninitialized warning. */
+	ssize_t rc;
+	static int domain_type = XEN_NOT_YET_DETECTED;
+
+	/* Run this weird code only once. */
+	if (domain_type != XEN_NOT_YET_DETECTED)
+		return domain_type;
+
+	/* Check for execution in HVM context. */
+	if (check_for_xen(XEN_CHECK_HVM))
+		return domain_type = XEN_HVM;
+
+	if (setjmp(xen_sigill_jmp)) {
+		sig = signal(SIGILL, sig);
+		if (sig == SIG_ERR)
+			fprintf(stderr, "%s: signal(SIGILL): Original signal handler not restored\n", __func__);
+		return domain_type = XEN_NONE;
+	}
+
+	sig = signal(SIGILL, xen_sigill_handler);
+
+	if (sig == SIG_ERR) {
+		fprintf(stderr, "%s: signal(SIGILL): New signal handler not installed\n", __func__);
+		return domain_type = XEN_NONE;
+	}
+
+	/*
+	 * Check for execution in PV context.
+	 * If this function returns it means that we are in PV context.
+	 */
+	check_for_xen(XEN_CHECK_PV);
+
+	sig = signal(SIGILL, sig);
+
+	if (sig == SIG_ERR)
+		fprintf(stderr, "%s: signal(SIGILL): Original signal handler not restored\n", __func__);
+
+	fd = open("/proc/xen/capabilities", O_RDONLY);
+
+	if (fd == -1)
+		return domain_type = XEN_PV;
+
+	rc = read(fd, buf, sizeof(buf));
+
+	close(fd);
+
+	if (rc == -1)
+		return domain_type = XEN_PV;
+
+	buf[sizeof(buf) - 1] = '\0';
+
+	if (!strstr(buf, "control_d"))
+		return domain_type = XEN_PV;
+
+	return domain_type = XEN_PV | XEN_DOM0;
+}
+
+static unsigned e820_to_kexec_type(uint32_t type)
+{
+	switch (type) {
+		case E820_RAM:
+			return RANGE_RAM;
+		case E820_ACPI:
+			return RANGE_ACPI;
+		case E820_NVS:
+			return RANGE_ACPI_NVS;
+		case E820_RESERVED:
+		default:
+			return RANGE_RESERVED;
+	}
+}
+
+/**
+ * Memory map detection for Xen.
+ *
+ * @param[out] range pointer that will be set to an array that holds the
+ *             memory ranges
+ * @param[out] ranges number of ranges valid in @p range
+ *
+ * @return 0 on success, any other value on failure.
+ */
+#if defined(HAVE_XC_GET_MACHINE_MEMORY_MAP) && defined(HAVE_XC_GET_MEMORY_MAP)
+int get_memory_ranges_xen(struct memory_range **range, int *ranges)
+{
+	int rc, ret = -1;
+	struct e820entry e820entries[MAX_MEMORY_RANGES];
+	unsigned int i;
+#ifdef XENCTRL_HAS_XC_INTERFACE
+	xc_interface *xc;
+#else
+	int xc;
+#endif
+
+#ifdef XENCTRL_HAS_XC_INTERFACE
+	xc = xc_interface_open(NULL, NULL, 0);
+
+	if (!xc) {
+		fprintf(stderr, "%s: Failed to open Xen control interface\n", __func__);
+		goto err;
+	}
+#else
+	xc = xc_interface_open();
+
+	if (xc == -1) {
+		fprintf(stderr, "%s: Failed to open Xen control interface\n", __func__);
+		goto err;
+	}
+#endif
+
+	if (xen_detect() & XEN_DOM0)
+		rc = xc_get_machine_memory_map(xc, e820entries, MAX_MEMORY_RANGES);
+	else
+		rc = xc_get_memory_map(xc, e820entries, MAX_MEMORY_RANGES);
+
+	if (rc < 0) {
+		fprintf(stderr, "%s: %s: %s\n", __func__,
+			(xen_detect() & XEN_DOM0) ? "xc_get_machine_memory_map" : "xc_get_memory_map",
+			strerror(-rc));
+		goto err;
+	}
+
+	for (i = 0; i < rc; ++i) {
+		memory_range[i].start = e820entries[i].addr;
+		memory_range[i].end = e820entries[i].addr + e820entries[i].size;
+		memory_range[i].type = e820_to_kexec_type(e820entries[i].type);
+	}
+
+	qsort(memory_range, rc, sizeof(struct memory_range), compare_ranges);
+
+	*range = memory_range;
+	*ranges = rc;
+
+	ret = 0;
+
+err:
+	xc_interface_close(xc);
+
+	return ret;
+}
+#else
+int get_memory_ranges_xen(struct memory_range **range, int *ranges)
+{
+	int fd, rc, ret = -1;
+	privcmd_hypercall_t hypercall;
+	struct e820entry *e820entries = NULL;
+	struct xen_memory_map *xen_memory_map = NULL;
+	unsigned int i;
+
+	fd = open("/proc/xen/privcmd", O_RDWR);
+
+	if (fd == -1) {
+		fprintf(stderr, "%s: open(/proc/xen/privcmd): %m\n", __func__);
+		goto err;
+	}
+
+	rc = posix_memalign((void **)&e820entries, getpagesize(),
+			    sizeof(struct e820entry) * MAX_MEMORY_RANGES);
+
+	if (rc) {
+		fprintf(stderr, "%s: posix_memalign(e820entries): %s\n", __func__, strerror(rc));
+		e820entries = NULL;
+		goto err;
+	}
+
+	rc = posix_memalign((void **)&xen_memory_map, getpagesize(),
+			    sizeof(struct xen_memory_map));
+
+	if (rc) {
+		fprintf(stderr, "%s: posix_memalign(xen_memory_map): %s\n", __func__, strerror(rc));
+		xen_memory_map = NULL;
+		goto err;
+	}
+
+	if (mlock(e820entries, sizeof(struct e820entry) * MAX_MEMORY_RANGES) == -1) {
+		fprintf(stderr, "%s: mlock(e820entries): %m\n", __func__);
+		goto err;
+	}
+
+	if (mlock(xen_memory_map, sizeof(struct xen_memory_map)) == -1) {
+		fprintf(stderr, "%s: mlock(xen_memory_map): %m\n", __func__);
+		goto err;
+	}
+
+	xen_memory_map->nr_entries = MAX_MEMORY_RANGES;
+	set_xen_guest_handle(xen_memory_map->buffer, e820entries);
+
+	hypercall.op = __HYPERVISOR_memory_op;
+	hypercall.arg[0] = (xen_detect() & XEN_DOM0) ? XENMEM_machine_memory_map : XENMEM_memory_map;
+	hypercall.arg[1] = (__u64)xen_memory_map;
+
+	rc = ioctl(fd, IOCTL_PRIVCMD_HYPERCALL, &hypercall);
+
+	if (rc == -1) {
+		fprintf(stderr, "%s: ioctl(IOCTL_PRIVCMD_HYPERCALL): %m\n", __func__);
+		goto err;
+	}
+
+	for (i = 0; i < xen_memory_map->nr_entries; ++i) {
+		memory_range[i].start = e820entries[i].addr;
+		memory_range[i].end = e820entries[i].addr + e820entries[i].size;
+		memory_range[i].type = e820_to_kexec_type(e820entries[i].type);
+	}
+
+	qsort(memory_range, xen_memory_map->nr_entries, sizeof(struct memory_range), compare_ranges);
+
+	*range = memory_range;
+	*ranges = xen_memory_map->nr_entries;
+
+	ret = 0;
+
+err:
+	munlock(xen_memory_map, sizeof(struct xen_memory_map));
+	munlock(e820entries, sizeof(struct e820entry) * MAX_MEMORY_RANGES);
+	free(xen_memory_map);
+	free(e820entries);
+	close(fd);
+
+	return ret;
+}
+#endif /* HAVE_XC_GET_MACHINE_MEMORY_MAP && HAVE_XC_GET_MEMORY_MAP */
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86-xen.h kexec-tools-2.0.3/kexec/arch/i386/kexec-x86-xen.h
--- kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86-xen.h	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/i386/kexec-x86-xen.h	2012-05-22 12:45:02.000000000 +0200
@@ -0,0 +1,99 @@
+/*
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef __KEXEC_X86_XEN_H__
+#define __KEXEC_X86_XEN_H__
+
+#include "config.h"
+
+#ifndef __ASSEMBLY__
+#include "../../kexec.h"
+#endif
+
+#ifdef HAVE_LIBXENCTRL
+
+#ifndef __ASSEMBLY__
+#include <xenctrl.h>
+#include "../../kexec-elf.h"
+#endif
+
+#define XP_PAGE_SHIFT	12
+#define XP_PAGE_SIZE	(1 << 12)
+
+#define _PAGE_PRESENT	0x001
+#define _PAGE_RW	0x002
+#define _PAGE_USER	0x004
+#define _PAGE_ACCESSED	0x020
+#define _PAGE_DIRTY	0x040
+
+#ifdef __i386__
+#define TRANSITION_PGTABLE_SIZE	5
+#else
+#define TRANSITION_PGTABLE_SIZE	7
+#endif
+
+#define XP_PFN_DOWN(x)	((x) >> XP_PAGE_SHIFT)
+#define XP_PFN_PHYS(x)	((x) << XP_PAGE_SHIFT)
+
+#ifndef __ASSEMBLY__
+struct xen_elf_notes {
+	unsigned long entry;
+	unsigned long hypercall_page;
+	unsigned long virt_base;
+};
+
+extern struct multicall_entry transition_pgtable_uvm[TRANSITION_PGTABLE_SIZE];
+extern unsigned long transition_pgtable_mfn;
+extern unsigned long bootstrap_pgtable_mfn;
+extern unsigned long bootstrap_stack_vaddr;
+extern unsigned long xen_pv_kernel_entry_vaddr;
+extern unsigned long start_info_vaddr;
+extern const unsigned long xen_pv_kernel_bootstrap_size;
+
+extern void xen_pv_usage(void);
+extern int xen_pv_probe(const char *kernel_buf, off_t kernel_size);
+extern int xen_pv_load(int argc, char **argv, const char *kernel_buf,
+			off_t kernel_size, struct kexec_info *info);
+
+extern int get_memory_ranges_xen(struct memory_range **range, int *ranges);
+
+extern unsigned long get_next_paddr(struct kexec_info *info);
+
+extern unsigned long build_bootstrap_pgtable(struct kexec_info *info,
+						struct xen_elf_notes *xen_elf_notes,
+						struct start_info *si_new, int p2m_seg);
+extern void build_transition_pgtable(struct kexec_info *info,
+					struct xen_elf_notes *xen_elf_notes,
+					int p2m_seg, int bs_seg);
+
+extern void xen_pv_kernel_bootstrap(void);
+#endif /* __ASSEMBLY__ */
+#else
+static inline int get_memory_ranges_xen(struct memory_range **range, int *ranges)
+{
+	return 0;
+}
+#endif /* HAVE_LIBXENCTRL */
+#endif /* __KEXEC_X86_XEN_H__ */
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86.c kexec-tools-2.0.3/kexec/arch/i386/kexec-x86.c
--- kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86.c	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/i386/kexec-x86.c	2012-05-21 20:20:59.000000000 +0200
@@ -30,10 +30,14 @@
 #include "../../kexec-syscall.h"
 #include "../../firmware_memmap.h"
 #include "kexec-x86.h"
+#include "kexec-x86-xen.h"
 #include "crashdump-x86.h"
 #include <arch/options.h>
 
 struct file_type file_type[] = {
+#ifdef HAVE_LIBXENCTRL
+	{ "xen-pv", xen_pv_probe, xen_pv_load, xen_pv_usage },
+#endif
 	{ "multiboot-x86", multiboot_x86_probe, multiboot_x86_load,
 	  multiboot_x86_usage },
 	{ "elf-x86", elf_x86_probe, elf_x86_load, elf_x86_usage },
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86.h kexec-tools-2.0.3/kexec/arch/i386/kexec-x86.h
--- kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-x86.h	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/i386/kexec-x86.h	2012-03-03 22:34:17.000000000 +0100
@@ -11,6 +11,7 @@ enum coretype {
 
 extern unsigned char compat_x86_64[];
 extern uint32_t compat_x86_64_size, compat_x86_64_entry32;
+extern struct memory_range memory_range[MAX_MEMORY_RANGES];
 
 struct entry32_regs {
 	uint32_t eax;
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-xen-pv.c kexec-tools-2.0.3/kexec/arch/i386/kexec-xen-pv.c
--- kexec-tools-2.0.3.orig/kexec/arch/i386/kexec-xen-pv.c	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/i386/kexec-xen-pv.c	2012-05-22 12:46:11.000000000 +0200
@@ -0,0 +1,549 @@
+/*
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+#define _GNU_SOURCE
+
+#include <arch/options.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <limits.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <x86/x86-linux.h>
+#include <xen/elfnote.h>
+#include <xenctrl.h>
+
+#include "../../kexec.h"
+#include "../../kexec-elf.h"
+#include "../../kexec-syscall.h"
+#include "../../kexec-xen.h"
+#include "kexec-x86-xen.h"
+#include "crashdump-x86.h"
+
+#define SYSFS_HYPERCALL_PAGE	"/sys/kernel/hypercall_page"
+#define SYSFS_P2M		"/sys/kernel/p2m"
+#define SYSFS_START_INFO	"/sys/kernel/start_info"
+
+static const char optstring[] = KEXEC_ARCH_OPT_STR "";
+
+static const struct option longopts[] = {
+	KEXEC_ARCH_OPTIONS
+	{"command-line",	1, NULL, OPT_APPEND},
+	{"append",		1, NULL, OPT_APPEND},
+	{"reuse-cmdline",	0, NULL, OPT_REUSE_CMDLINE},
+	{"initrd",		1, NULL, OPT_RAMDISK},
+	{"ramdisk",		1, NULL, OPT_RAMDISK},
+	{"console-xen-pv",	0, NULL, OPT_CONSOLE_XEN_PV},
+	{NULL,			0, NULL, 0}
+};
+
+unsigned long get_next_paddr(struct kexec_info *info)
+{
+	unsigned long next_paddr;
+
+	next_paddr = (unsigned long)info->segment[info->nr_segments - 1].mem;
+	next_paddr += info->segment[info->nr_segments - 1].memsz;
+
+	return next_paddr;
+}
+
+static void xchg_mfns(struct kexec_info *info, int p2m_seg,
+			unsigned long pfn, unsigned long mfn)
+{
+	unsigned long i, nr_pages, *p2m;
+
+	p2m = (unsigned long *)info->segment[p2m_seg].buf;
+	nr_pages = info->segment[p2m_seg].bufsz / sizeof(unsigned long);
+
+	for (i = 0; i < nr_pages && p2m[i] != mfn; ++i);
+
+	if (i == nr_pages)
+		die("xen-pv loader: %s: Invalid MFN: PFN: 0x%lx MFN: 0x%lx\n",
+				__func__, pfn, mfn);
+
+	p2m[i] = p2m[pfn];
+	p2m[pfn] = mfn;
+}
+
+static unsigned long read_note(struct mem_ehdr *ehdr, int idx)
+{
+	if (ehdr->e_note[idx].n_descsz == 4)
+		return elf32_to_cpu(ehdr, *(uint32_t *)ehdr->e_note[idx].n_desc);
+
+	if (ehdr->e_note[idx].n_descsz == 8)
+		return elf64_to_cpu(ehdr, *(uint64_t *)ehdr->e_note[idx].n_desc);
+
+	die("xen-pv loader: %s: Invalid Xen ELF note: Type: 0x%x Data size: 0x%x\n",
+			__func__, ehdr->e_note[idx].n_type, ehdr->e_note[idx].n_descsz);
+
+	/* Do not emit "control reaches end of non-void function" warning. */
+	return 0;
+}
+
+static void read_xen_elf_notes(struct mem_ehdr *ehdr,
+				struct xen_elf_notes *xen_elf_notes)
+{
+	int i;
+
+	for (i = 0; i < ehdr->e_notenum; ++i) {
+		if (strcmp(ehdr->e_note[i].n_name, "Xen"))
+				continue;
+
+		switch (ehdr->e_note[i].n_type) {
+			case XEN_ELFNOTE_ENTRY:
+				xen_elf_notes->entry = read_note(ehdr, i);
+				break;
+
+			case XEN_ELFNOTE_HYPERCALL_PAGE:
+				xen_elf_notes->hypercall_page = read_note(ehdr, i);
+				break;
+
+			case XEN_ELFNOTE_VIRT_BASE:
+				xen_elf_notes->virt_base = read_note(ehdr, i);
+				break;
+
+			default:
+				break;
+		}
+	}
+}
+
+static void load_hypercall_page(struct kexec_info *info,
+				struct xen_elf_notes *xen_elf_notes)
+{
+	int fd, i;
+	unsigned long hp_paddr;
+	void *hp_dst, *hp_src;
+
+	hp_paddr = xen_elf_notes->hypercall_page - xen_elf_notes->virt_base;
+
+	for (i = 0; i < info->nr_segments; ++i)
+		if (hp_paddr >= (unsigned long)info->segment[i].mem &&
+			hp_paddr + XP_PAGE_SIZE <=
+				(unsigned long)info->segment[i].mem + info->segment[i].bufsz)
+			break;
+
+	if (i == info->nr_segments)
+		die("There is no place for hypercall page !!!\n");
+
+	fd = open(SYSFS_HYPERCALL_PAGE, O_RDONLY);
+
+	if (fd == -1)
+		die("xen-pv loader: %s: open(%s): %m\n", __func__, SYSFS_HYPERCALL_PAGE);
+
+	hp_src = mmap(NULL, XP_PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
+
+	if (hp_src == MAP_FAILED)
+		die("xen-pv loader: %s: mmap: %m\n", __func__);
+
+	hp_dst = (void *)info->segment[i].buf;
+	hp_dst += hp_paddr - (unsigned long)info->segment[i].mem;
+
+	memcpy(hp_dst, hp_src, XP_PAGE_SIZE);
+
+	munmap(hp_src, XP_PAGE_SIZE);
+	close(fd);
+}
+
+static void load_ramdisk(struct kexec_info *info,
+				struct xen_elf_notes *xen_elf_notes,
+				const char *ramdisk,
+				struct start_info *si_new)
+{
+	char *ramdisk_buf;
+	off_t ramdisk_size;
+	unsigned long ramdisk_paddr;
+
+	if (!ramdisk)
+		return;
+
+	ramdisk_buf = slurp_file(ramdisk, &ramdisk_size);
+
+	ramdisk_paddr = get_next_paddr(info);
+
+	add_buffer(info, ramdisk_buf, ramdisk_size, ramdisk_size, XP_PAGE_SIZE,
+			ramdisk_paddr, round_up(ramdisk_paddr + ramdisk_size,
+							XP_PAGE_SIZE), 1);
+
+	si_new->mod_start = xen_elf_notes->virt_base + ramdisk_paddr;
+	si_new->mod_len = ramdisk_size;
+}
+
+static int load_p2m(struct kexec_info *info,
+			struct xen_elf_notes *xen_elf_notes,
+			struct start_info *si_new)
+{
+	int fd;
+	struct stat stat;
+	unsigned long p2m_paddr;
+	void *p2m;
+
+	fd = open(SYSFS_P2M, O_RDONLY);
+
+	if (fd == -1)
+		die("xen-pv loader: %s: open(%s): %m\n", __func__, SYSFS_P2M);
+
+	if (fstat(fd, &stat) == -1)
+		die("xen-pv loader: %s: fstat: %m\n", __func__);
+
+	p2m = mmap(NULL, stat.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+
+	if (p2m == MAP_FAILED)
+		die("xen-pv loader: %s: mmap: %m\n", __func__);
+
+	p2m_paddr = get_next_paddr(info);
+
+	add_buffer(info, p2m, stat.st_size, stat.st_size, XP_PAGE_SIZE, p2m_paddr,
+			round_up(p2m_paddr + stat.st_size, XP_PAGE_SIZE), 1);
+
+	si_new->mfn_list = xen_elf_notes->virt_base + p2m_paddr;
+	si_new->nr_pages = stat.st_size / sizeof(unsigned long);
+
+	return info->nr_segments - 1;
+}
+
+static void load_sys_start_info(struct start_info *si_sys)
+{
+	int fd;
+	ssize_t rc;
+
+	fd = open(SYSFS_START_INFO, O_RDONLY);
+
+	if (fd == -1)
+		die("xen-pv loader: %s: open(%s): %m\n", __func__, SYSFS_START_INFO);
+
+	rc = read(fd, si_sys, sizeof(struct start_info));
+
+	if (rc == -1)
+		die("xen-pv loader: %s: read: %m\n", __func__);
+
+	/*
+	 * Warning: Linux Kernel start_info struct may not contain
+	 * first_p2m_pfn and nr_p2m_frames members.
+	 */
+	if (rc < sizeof(struct start_info) - sizeof(unsigned long) * 2)
+		die("xen-pv loader: %s: read: File was truncated\n", __func__);
+
+	close(fd);
+}
+
+static int alloc_start_info(struct kexec_info *info)
+{
+	unsigned long si_dst_paddr;
+	void *si_dst;
+
+	si_dst = xmalloc(XP_PAGE_SIZE);
+	memset(si_dst, 0, XP_PAGE_SIZE);
+
+	si_dst_paddr = get_next_paddr(info);
+
+	add_buffer(info, si_dst, XP_PAGE_SIZE, XP_PAGE_SIZE, XP_PAGE_SIZE,
+				si_dst_paddr, si_dst_paddr + XP_PAGE_SIZE, 1);
+
+	return info->nr_segments - 1;
+}
+
+/*
+ * Reserve xenstore and console pages (in this order).
+ * Magic pages are behind start info.
+ *
+ * WARNING: Do not change xenstore and console pages order nor their location.
+ * Linux Kernel and some code in kexec-tools depend on it.
+ */
+
+static void reserve_magic_pages(struct kexec_info *info,
+				struct start_info *si_sys, int p2m_seg)
+{
+	unsigned long magic_paddr, magic_pfn, magic_size;
+
+	magic_paddr = get_next_paddr(info);
+	magic_pfn = XP_PFN_DOWN(magic_paddr);
+	magic_size = 2 * XP_PAGE_SIZE;
+
+	/* Move xenstore MFN to new place. */
+	xchg_mfns(info, p2m_seg, magic_pfn, si_sys->store_mfn);
+
+	/* Move console MFN to new place. */
+	xchg_mfns(info, p2m_seg, ++magic_pfn, si_sys->console.domU.mfn);
+
+	add_buffer(info, NULL, 0, magic_size, XP_PAGE_SIZE,
+			magic_paddr, magic_paddr + magic_size, 1);
+}
+
+static int alloc_bootstrap_stack(struct kexec_info *info)
+{
+	unsigned long bs_paddr;
+
+	bs_paddr = get_next_paddr(info);
+
+	add_buffer(info, xen_pv_kernel_bootstrap, xen_pv_kernel_bootstrap_size,
+			xen_pv_kernel_bootstrap_size, XP_PAGE_SIZE,
+			bs_paddr, bs_paddr + XP_PAGE_SIZE, 1);
+
+	return info->nr_segments - 1;
+}
+
+static void reserve_padding(struct kexec_info *info, unsigned long end_paddr)
+{
+	unsigned long padding_paddr, padding_size;
+
+	padding_paddr = get_next_paddr(info);
+	padding_size = end_paddr - padding_paddr;
+
+	if (!padding_size)
+		return;
+
+	add_buffer(info, NULL, 0, padding_size, XP_PAGE_SIZE,
+					padding_paddr, end_paddr, 1);
+}
+
+static int load_crashdump(struct kexec_info *info, struct mem_ehdr *ehdr,
+				char **command_line)
+{
+	*command_line = xrealloc(*command_line, COMMAND_LINE_SIZE);
+
+	if (load_crashdump_segments(info, *command_line, elf_max_addr(ehdr),
+			get_next_paddr(info)) < 0)
+		return -1;
+
+	return 0;
+}
+
+static void init_start_info(struct kexec_info *info, struct start_info *si_sys,
+				struct start_info *si_new, int si_seg)
+{
+	struct start_info *si_dst;
+
+	si_dst = (struct start_info *)info->segment[si_seg].buf;
+
+	memcpy(si_dst->magic, si_sys->magic, sizeof(si_dst->magic));
+	si_dst->shared_info = si_sys->shared_info;
+	si_dst->flags = si_sys->flags;
+	si_dst->store_mfn = si_sys->store_mfn;
+	si_dst->store_evtchn = si_sys->store_evtchn;
+	si_dst->console.domU.mfn = si_sys->console.domU.mfn;
+	si_dst->console.domU.evtchn = si_sys->console.domU.evtchn;
+
+	memcpy(si_dst->cmd_line, si_new->cmd_line, sizeof(si_dst->cmd_line));
+	si_dst->pt_base = si_new->pt_base;
+	si_dst->nr_pt_frames = si_new->nr_pt_frames;
+	si_dst->mfn_list = si_new->mfn_list;
+	si_dst->nr_pages = si_new->nr_pages;
+	si_dst->mod_start = si_new->mod_start;
+	si_dst->mod_len = si_new->mod_len;
+}
+
+static void init_bootstrap(struct kexec_info *info,
+				struct xen_elf_notes *xen_elf_notes,
+				int p2m_seg, int si_seg, int bs_seg,
+				unsigned long end_paddr)
+{
+	int i;
+	struct start_info *si;
+	unsigned long *p2m;
+
+	p2m = (unsigned long *)info->segment[p2m_seg].buf;
+	si = (struct start_info *)info->segment[si_seg].buf;
+
+	for (i = 0; i < TRANSITION_PGTABLE_SIZE; ++i)
+		transition_pgtable_uvm[i].args[0] = end_paddr + i * XP_PAGE_SIZE;
+
+	transition_pgtable_mfn = p2m[XP_PFN_DOWN(end_paddr)];
+	bootstrap_pgtable_mfn = p2m[XP_PFN_DOWN(si->pt_base - xen_elf_notes->virt_base)];
+	bootstrap_stack_vaddr = xen_elf_notes->virt_base;
+	bootstrap_stack_vaddr += (unsigned long)info->segment[bs_seg].mem;
+	xen_pv_kernel_entry_vaddr = xen_elf_notes->entry;
+	start_info_vaddr = xen_elf_notes->virt_base;
+	start_info_vaddr += (unsigned long)info->segment[si_seg].mem;
+}
+
+static void load_purgatory(struct kexec_info *info, struct start_info *si_sys,
+				int si_seg, int bs_seg, uint8_t console_xen_pv)
+{
+	const void *console_xen_pv_if;
+
+	elf_rel_build_load(info, &info->rhdr, purgatory, purgatory_size,
+							0, ULONG_MAX, 1, 0);
+
+	info->entry = (void *)elf_rel_get_addr(&info->rhdr, "xen_pv_purgatory_start");
+
+	elf_rel_set_symbol(&info->rhdr, "bootstrap_stack_paddr",
+				&info->segment[bs_seg].mem,
+				sizeof(info->segment[bs_seg].mem));
+
+	if (!console_xen_pv)
+		return;
+
+	/* This depends on assumptions made in reserve_magic_pages(). */
+	console_xen_pv_if = info->segment[si_seg].mem + 2 * XP_PAGE_SIZE;
+
+	elf_rel_set_symbol(&info->rhdr, "console_xen_pv",
+				&console_xen_pv, sizeof(console_xen_pv));
+	elf_rel_set_symbol(&info->rhdr, "console_xen_pv_if",
+				&console_xen_pv_if, sizeof(console_xen_pv_if));
+	elf_rel_set_symbol(&info->rhdr, "console_xen_pv_evtchn",
+				&si_sys->console.domU.evtchn,
+				sizeof(si_sys->console.domU.evtchn));
+}
+
+void xen_pv_usage(void)
+{
+	printf("    --command-line=STRING Set the kernel command line to STRING\n"
+		"    --append=STRING       Set the kernel command line to STRING\n"
+		"    --reuse-cmdline       Use kernel command line from running system.\n"
+		"    --initrd=FILE         Use FILE as the kernel's initial ramdisk.\n"
+		"    --ramdisk=FILE        Use FILE as the kernel's initial ramdisk.\n"
+		"    --console-xen-pv      Enable the Xen PV console.\n");
+}
+
+int xen_pv_probe(const char *kernel_buf, off_t kernel_size)
+{
+	struct mem_ehdr ehdr;
+	int i, rc;
+
+	/* Are we in Xen PV domain ??? */
+	if (!(xen_detect() & XEN_PV) || (xen_detect() & XEN_DOM0))
+		return -ENOSYS;
+
+	rc = build_elf_exec_info(kernel_buf, kernel_size, &ehdr, 0);
+
+	/* It does not look like ELF file... */
+	if (rc < 0)
+		goto err;
+
+	/* Look for Xen notes. */
+	for (i = 0; i < ehdr.e_notenum; ++i)
+		if (!strcmp(ehdr.e_note[i].n_name, "Xen"))
+				break;
+
+	/* This is not Xen compatible kernel. */
+	if (i == ehdr.e_notenum) {
+		rc = -ENOEXEC;
+		goto err;
+	}
+
+err:
+	free_elf_info(&ehdr);
+
+	return rc;
+}
+
+int xen_pv_load(int argc, char **argv, const char *kernel_buf,
+			off_t kernel_size, struct kexec_info *info)
+{
+	char *command_line = NULL;
+	const char *append = NULL, *ramdisk = NULL;
+	int bs_seg, c, p2m_seg, si_seg;
+	struct mem_ehdr ehdr;
+	struct start_info si_new = {}, si_sys;
+	struct xen_elf_notes xen_elf_notes = {};
+	uint8_t console_xen_pv = 0;
+	unsigned long end_paddr;
+
+	while (1) {
+		c = getopt_long(argc, argv, optstring, longopts, NULL);
+
+		if (c == -1)
+			break;
+
+		switch (c) {
+			case OPT_APPEND:
+				append = optarg;
+				break;
+
+			case OPT_CONSOLE_XEN_PV:
+				console_xen_pv = 1;
+				break;
+
+			case OPT_RAMDISK:
+				ramdisk = optarg;
+				break;
+
+			case OPT_REUSE_CMDLINE:
+				command_line = get_command_line();
+				break;
+
+			default:
+				if (c >= OPT_ARCH_MAX)
+					fprintf(stderr, "Unknown option: opt: %d\n", c);
+				break;
+
+			case '?':
+				usage();
+				return -1;
+		}
+	}
+
+	command_line = concat_cmdline(command_line, append);
+
+	if (command_line && strlen(command_line) > COMMAND_LINE_SIZE - 1)
+		die("Command line overflow\n");
+
+	/* Load the ELF executable. */
+	elf_exec_build_load(info, &ehdr, kernel_buf, kernel_size, 0);
+
+	read_xen_elf_notes(&ehdr, &xen_elf_notes);
+
+	sort_segments(info);
+
+	load_hypercall_page(info, &xen_elf_notes);
+	load_ramdisk(info, &xen_elf_notes, ramdisk, &si_new);
+	p2m_seg = load_p2m(info, &xen_elf_notes, &si_new);
+	load_sys_start_info(&si_sys);
+	si_seg = alloc_start_info(info);
+	reserve_magic_pages(info, &si_sys, p2m_seg);
+	end_paddr = build_bootstrap_pgtable(info, &xen_elf_notes, &si_new, p2m_seg);
+	bs_seg = alloc_bootstrap_stack(info);
+	reserve_padding(info, end_paddr);
+	build_transition_pgtable(info, &xen_elf_notes, p2m_seg, bs_seg);
+
+	if (info->kexec_flags & KEXEC_ON_CRASH)
+		if (load_crashdump(info, &ehdr, &command_line) < 0)
+			return -1;
+
+	if (command_line) {
+		if (strlen(command_line) > MAX_GUEST_CMDLINE - 1)
+			die("Command line overflow\n");
+
+		strcpy((char *)si_new.cmd_line, command_line);
+	}
+
+	init_start_info(info, &si_sys, &si_new, si_seg);
+	init_bootstrap(info, &xen_elf_notes, p2m_seg, si_seg, bs_seg, end_paddr);
+
+	load_purgatory(info, &si_sys, si_seg, bs_seg, console_xen_pv);
+
+	return 0;
+}
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/ia64/kexec-iomem.c kexec-tools-2.0.3/kexec/arch/ia64/kexec-iomem.c
--- kexec-tools-2.0.3.orig/kexec/arch/ia64/kexec-iomem.c	2010-07-29 11:22:16.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/ia64/kexec-iomem.c	2012-03-02 13:30:15.000000000 +0100
@@ -4,20 +4,8 @@
 #include "../../crashdump.h"
 
 static const char proc_iomem_str[]= "/proc/iomem";
-static const char proc_iomem_machine_str[]= "/proc/iomem_machine";
 
-/*
- * On IA64 XEN the EFI tables are virtualised.
- * For this reason on such systems /proc/iomem_machine is provided,
- * which is based on the hypervisor's (machine's) EFI tables.
- * If Xen is in use, then /proc/iomem is used for memory regions relating
- * to the currently running dom0 kernel, and /proc/iomem_machine is used
- * for regions relating to the machine itself or the hypervisor.
- * If Xen is not in used, then /proc/iomem used.
- */
 const char *proc_iomem(void)
 {
-	if (xen_present())
-		return proc_iomem_machine_str;
 	return proc_iomem_str;
 }
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/mips/crashdump-mips.c kexec-tools-2.0.3/kexec/arch/mips/crashdump-mips.c
--- kexec-tools-2.0.3.orig/kexec/arch/mips/crashdump-mips.c	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/mips/crashdump-mips.c	2012-04-27 14:48:59.000000000 +0200
@@ -31,6 +31,7 @@
 #include "../../kexec-syscall.h"
 #include "../../crashdump.h"
 #include "kexec-mips.h"
+#include "kexec-xen.h"
 #include "crashdump-mips.h"
 #include "unused.h"
 
@@ -55,7 +56,7 @@ static int get_kernel_paddr(struct crash
 {
 	uint64_t start;
 
-	if (xen_present()) /* Kernel not entity mapped under Xen */
+	if (xen_detect() & XEN_DOM0) /* Kernel not entity mapped under Xen dom0 */
 		return 0;
 
 	if (parse_iomem_single("Kernel code\n", &start, NULL) == 0) {
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/x86_64/Makefile kexec-tools-2.0.3/kexec/arch/x86_64/Makefile
--- kexec-tools-2.0.3.orig/kexec/arch/x86_64/Makefile	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/x86_64/Makefile	2012-05-22 11:13:18.000000000 +0200
@@ -6,12 +6,17 @@ x86_64_KEXEC_SRCS += kexec/arch/i386/kex
 x86_64_KEXEC_SRCS += kexec/arch/i386/kexec-multiboot-x86.c
 x86_64_KEXEC_SRCS += kexec/arch/i386/kexec-beoboot-x86.c
 x86_64_KEXEC_SRCS += kexec/arch/i386/kexec-nbi.c
+x86_64_KEXEC_SRCS += kexec/arch/i386/kexec-x86-xen-common.c
+x86_64_KEXEC_SRCS += kexec/arch/i386/kexec-xen-pv.c
 x86_64_KEXEC_SRCS += kexec/arch/i386/x86-linux-setup.c
 x86_64_KEXEC_SRCS += kexec/arch/i386/kexec-x86-common.c
 x86_64_KEXEC_SRCS += kexec/arch/i386/crashdump-x86.c
+x86_64_KEXEC_SRCS += kexec/arch/i386/crashdump-x86-xen.c
 x86_64_KEXEC_SRCS += kexec/arch/x86_64/kexec-x86_64.c
 x86_64_KEXEC_SRCS += kexec/arch/x86_64/kexec-elf-x86_64.c
 x86_64_KEXEC_SRCS += kexec/arch/x86_64/kexec-elf-rel-x86_64.c
+x86_64_KEXEC_SRCS += kexec/arch/x86_64/x86_64-xen-pv.c
+x86_64_KEXEC_SRCS += kexec/arch/x86_64/x86_64-xen-pv-kernel-bootstrap.S
 
 dist += kexec/arch/x86_64/Makefile $(x86_64_KEXEC_SRCS) \
 	kexec/arch/x86_64/kexec-x86_64.h \
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/x86_64/kexec-x86_64.c kexec-tools-2.0.3/kexec/arch/x86_64/kexec-x86_64.c
--- kexec-tools-2.0.3.orig/kexec/arch/x86_64/kexec-x86_64.c	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/arch/x86_64/kexec-x86_64.c	2012-05-21 20:15:06.000000000 +0200
@@ -29,10 +29,14 @@
 #include "../../kexec-elf.h"
 #include "../../kexec-syscall.h"
 #include "kexec-x86_64.h"
+#include "../i386/kexec-x86-xen.h"
 #include "../i386/crashdump-x86.h"
 #include <arch/options.h>
 
 struct file_type file_type[] = {
+#ifdef HAVE_LIBXENCTRL
+	{ "xen-pv", xen_pv_probe, xen_pv_load, xen_pv_usage },
+#endif
 	{ "elf-x86_64", elf_x86_64_probe, elf_x86_64_load, elf_x86_64_usage },
 	{ "multiboot-x86", multiboot_x86_probe, multiboot_x86_load,
 	  multiboot_x86_usage },
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/x86_64/x86_64-xen-pv-kernel-bootstrap.S kexec-tools-2.0.3/kexec/arch/x86_64/x86_64-xen-pv-kernel-bootstrap.S
--- kexec-tools-2.0.3.orig/kexec/arch/x86_64/x86_64-xen-pv-kernel-bootstrap.S	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/x86_64/x86_64-xen-pv-kernel-bootstrap.S	2012-05-22 12:45:18.000000000 +0200
@@ -0,0 +1,306 @@
+/*
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+#define __ASSEMBLY__
+
+#include <xen/xen.h>
+
+#include "../i386/kexec-x86-xen.h"
+
+#ifdef UVMF_INVLPG
+#undef UVMF_INVLPG
+#endif
+
+#define DOMID_SELF	0x7ff0
+
+#define UVMF_INVLPG	2
+
+#define VCPUOP_down	2
+#define VCPUOP_is_up	3
+
+#define XPKB_TRANSITION	1
+#define XPKB_BOOTSTRAP	2
+
+	/*
+	 * This code must be in .data section because it is updated
+	 * by xen-pv loader (.text section is read only). However,
+	 * it is never executed in place. It is copied by xen-pv loader
+	 * to its destination and later called after purgatory code.
+	 */
+
+	.data
+	.code64
+	.globl	transition_pgtable_uvm, transition_pgtable_mfn, bootstrap_pgtable_mfn
+	.globl	bootstrap_stack_vaddr, xen_pv_kernel_entry_vaddr, start_info_vaddr
+	.globl	xen_pv_kernel_bootstrap, xen_pv_kernel_bootstrap_size
+
+xen_pv_kernel_bootstrap:
+	testq	%rax, %rax
+	jnz	0f
+
+	leaq	xen_pv_kexec_halt(%rip), %rax
+	jmpq	*%rax
+
+0:
+	/* Is everybody at entry stage? */
+	cmpl	%r15d, xpkh_stage_cpus(%rip)
+	jne	0b
+
+	/* Reset stage counter. */
+	movl	$0, xpkh_stage_cpus(%rip)
+
+	/* Unmap transition page table pages. */
+	leaq	transition_pgtable_uvm(%rip), %rdi
+	movq	$TRANSITION_PGTABLE_SIZE, %rsi
+	movq	$__HYPERVISOR_multicall, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	/* Store transition page table MFN. */
+	movq	transition_pgtable_mfn(%rip), %rax
+	movq	%rax, mmuext_new_baseptr(%rip)
+	movq	%rax, mmuext_new_user_baseptr(%rip)
+
+        /* Switch to transition page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$2, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	/* Go to virtual address. */
+	movq	bootstrap_stack_vaddr(%rip), %rax
+	addq	$(0f - xen_pv_kernel_bootstrap), %rax
+	jmpq	*%rax
+
+0:
+	sfence
+
+	/* Signal that we are at transition stage. */
+	lock	incb xpkb_stage(%rip)
+
+0:
+	/* Is everybody at transition stage? */
+	cmpl	%r15d, xpkh_stage_cpus(%rip)
+	jne	0b
+
+	/* Reset stage counter. */
+	movl	$0, xpkh_stage_cpus(%rip)
+
+	/* Setup bootstrap stack. */
+	movq	bootstrap_stack_vaddr(%rip), %rsp
+	addq	$XP_PAGE_SIZE, %rsp
+
+	/* Store bootstrap page table MFN. */
+	movq	bootstrap_pgtable_mfn(%rip), %rax
+	movq	%rax, mmuext_new_baseptr(%rip)
+	movq	%rax, mmuext_new_user_baseptr(%rip)
+	movq	%rax, mmuext_pin_l4_table(%rip)
+
+        /* Switch to bootstrap page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$3, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	sfence
+
+	/* Signal that we are at bootstrap stage. */
+	lock	incb xpkb_stage(%rip)
+
+0:
+	cmpl	%r14d, %r15d
+	je	2f
+
+1:
+        /* CPU is up? */
+	movq	$VCPUOP_is_up, %rdi
+	movq	%r15, %rsi
+	xorq	%rdx, %rdx
+	movq	$__HYPERVISOR_vcpu_op, %rax
+	syscall
+	testq	%rax, %rax
+	jnz	1b
+
+2:
+	testl	%r15d, %r15d
+	jz	3f
+
+	decl	%r15d
+	jmp	0b
+
+3:
+	/* Set unused registers to zero. */
+	xorq	%rax, %rax
+	xorq	%rbx, %rbx
+	xorq	%rcx, %rcx
+	xorq	%rdx, %rdx
+	xorq	%rdi, %rdi
+	xorq	%rbp, %rbp
+	xorq	%r8, %r8
+	xorq	%r9, %r9
+	xorq	%r10, %r10
+	xorq	%r11, %r11
+	xorq	%r12, %r12
+	xorq	%r13, %r13
+	xorq	%r14, %r14
+	xorq	%r15, %r15
+
+	/* Load start info address into %rsi. */
+	movq	start_info_vaddr(%rip), %rsi
+
+	/* Jump into new kernel... */
+	pushq	xen_pv_kernel_entry_vaddr(%rip)
+	retq
+
+xen_pv_kexec_halt:
+	/* Signal that we are at entry stage. */
+	lock	incl xpkh_stage_cpus(%rip)
+
+0:
+	/* Is xen_pv_kernel_bootstrap() at transition stage? */
+	cmpb	$XPKB_TRANSITION, xpkb_stage(%rip)
+	jne	0b
+
+        /* Switch to transition page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$2, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+	/* Go to virtual address. */
+	movq	bootstrap_stack_vaddr(%rip), %rax
+	addq	$(0f - xen_pv_kernel_bootstrap), %rax
+	jmpq	*%rax
+
+0:
+	/* Signal that we are at transition stage. */
+	lock	incl xpkh_stage_cpus(%rip)
+
+0:
+	/* Is xen_pv_kernel_bootstrap() at bootstrap stage? */
+	cmpb	$XPKB_BOOTSTRAP, xpkb_stage(%rip)
+	jne	0b
+
+        /* Switch to bootstrap page table. */
+	leaq	mmuext_args(%rip), %rdi
+	movq	$2, %rsi
+	xorq	%rdx, %rdx
+	movq	$DOMID_SELF, %r10
+	movq	$__HYPERVISOR_mmuext_op, %rax
+	syscall
+	testq	%rax, %rax
+	jz	0f
+	ud2a
+
+0:
+        /* Stop this CPU. */
+	movq	$VCPUOP_down, %rdi
+	movq	%r14, %rsi
+	xorq	%rdx, %rdx
+	movq	$__HYPERVISOR_vcpu_op, %rax
+	syscall
+	ud2a
+
+transition_pgtable_uvm:
+	.rept	TRANSITION_PGTABLE_SIZE
+	.quad	__HYPERVISOR_update_va_mapping
+	.fill	3, 8, 0
+	.quad	UVMF_INVLPG
+	.fill	3, 8, 0
+	.endr
+
+transition_pgtable_mfn:
+	.quad	0			/* MFN of transition page table directory. */
+
+bootstrap_pgtable_mfn:
+	.quad	0			/* MFN of bootstrap page table directory. */
+
+bootstrap_stack_vaddr:
+	.quad	0			/* VIRTUAL address of bootstrap stack. */
+
+xen_pv_kernel_entry_vaddr:
+	.quad	0			/* VIRTUAL address of kernel entry point. */
+
+start_info_vaddr:
+	.quad	0			/* VIRTUAL address of start info. */
+
+mmuext_args:
+	.long	MMUEXT_NEW_BASEPTR	/* Operation. */
+	.long	0			/* PAD. */
+
+mmuext_new_baseptr:
+	.quad	0			/* MFN of target page table directory. */
+	.quad	0			/* UNUSED. */
+
+	.long	MMUEXT_NEW_USER_BASEPTR	/* Operation. */
+	.long	0			/* PAD. */
+
+mmuext_new_user_baseptr:
+	.quad	0			/* MFN of user target page table directory. */
+	.quad	0			/* UNUSED. */
+
+	.long	MMUEXT_PIN_L4_TABLE	/* Operation. */
+	.long	0			/* PAD. */
+
+mmuext_pin_l4_table:
+	.quad	0			/* MFN of page table directory to pin. */
+	.quad	0			/* UNUSED. */
+
+	.align	4
+
+xpkh_stage_cpus:
+	.long	0			/* Number of CPUs at given stage. */
+
+xpkb_stage:
+	.byte	0			/* xen_pv_kernel_bootstrap() stage. */
+
+xen_pv_kernel_bootstrap_size:
+	.quad	. - xen_pv_kernel_bootstrap	/* Bootstrap size. */
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/kexec/arch/x86_64/x86_64-xen-pv.c kexec-tools-2.0.3/kexec/arch/x86_64/x86_64-xen-pv.c
--- kexec-tools-2.0.3.orig/kexec/arch/x86_64/x86_64-xen-pv.c	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/arch/x86_64/x86_64-xen-pv.c	2012-05-22 12:45:25.000000000 +0200
@@ -0,0 +1,291 @@
+/*
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+#include <string.h>
+#include <unistd.h>
+#include <xenctrl.h>
+
+#include "../../kexec.h"
+#include "../../kexec-elf.h"
+#include "../i386/kexec-x86-xen.h"
+
+#define PGDIR_SHIFT	39
+#define PUD_SHIFT	30
+#define PMD_SHIFT	21
+
+#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
+#define PUD_SIZE	(1UL << PUD_SHIFT)
+#define PMD_SIZE	(1UL << PMD_SHIFT)
+
+#define PTRS_PER_PGD	512
+#define PTRS_PER_PUD	512
+#define PTRS_PER_PMD	512
+#define PTRS_PER_PTE	512
+
+#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_rw	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED)
+#define _PAGE_ro	(_PAGE_PRESENT | _PAGE_ACCESSED)
+
+#define pgd_index(vaddr)	(((vaddr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+#define pud_index(vaddr)	(((vaddr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+#define pmd_index(vaddr)	(((vaddr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+#define pte_index(vaddr)	(((vaddr) >> XP_PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+
+static void init_level1_page(struct xen_elf_notes *xen_elf_notes,
+				struct start_info *si_new,
+				unsigned long *ptp,
+				unsigned long *p2m,
+				unsigned long vaddr,
+				unsigned long end_vaddr)
+{
+	unsigned long pfn, pgprot, pt_end, pt_start, *pte;
+
+	pfn = XP_PFN_DOWN(vaddr - xen_elf_notes->virt_base);
+
+	pt_start = si_new->pt_base;
+	pt_end = pt_start + si_new->nr_pt_frames * XP_PAGE_SIZE;
+
+	pte = &ptp[pte_index(vaddr)];
+
+	while (vaddr < end_vaddr) {
+		pgprot = (vaddr >= pt_start && vaddr < pt_end) ? _PAGE_ro : _PAGE_rw;
+		*pte++ = XP_PFN_PHYS(p2m[pfn++]) | pgprot;
+
+		if (pte_index(vaddr) == PTRS_PER_PTE - 1)
+			break;
+
+		vaddr += XP_PAGE_SIZE;
+	}
+}
+
+static void init_level2_page(struct xen_elf_notes *xen_elf_notes,
+				struct start_info *si_new,
+				unsigned long **ptp,
+				unsigned long *ptp_pfn,
+				unsigned long *p2m,
+				unsigned long vaddr,
+				unsigned long end_vaddr)
+{
+	unsigned long *pmd;
+
+	pmd = &(*ptp)[pmd_index(vaddr)];
+
+	while (vaddr < end_vaddr) {
+		*ptp += PTRS_PER_PMD;
+		++*ptp_pfn;
+
+		*pmd++ = XP_PFN_PHYS(p2m[*ptp_pfn]) | _PAGE_TABLE;
+
+		init_level1_page(xen_elf_notes, si_new, *ptp,
+						p2m, vaddr, end_vaddr);
+
+		if (pmd_index(vaddr) == PTRS_PER_PMD - 1)
+			break;
+
+		vaddr += PMD_SIZE;
+	}
+}
+
+static void init_level3_page(struct xen_elf_notes *xen_elf_notes,
+				struct start_info *si_new,
+				unsigned long **ptp,
+				unsigned long *ptp_pfn,
+				unsigned long *p2m,
+				unsigned long vaddr,
+				unsigned long end_vaddr)
+{
+	unsigned long *pud;
+
+	pud = &(*ptp)[pud_index(vaddr)];
+
+	while (vaddr < end_vaddr) {
+		*ptp += PTRS_PER_PUD;
+		++*ptp_pfn;
+
+		*pud++ = XP_PFN_PHYS(p2m[*ptp_pfn]) | _PAGE_TABLE;
+
+		init_level2_page(xen_elf_notes, si_new, ptp,
+					ptp_pfn, p2m, vaddr, end_vaddr);
+
+		if (pud_index(vaddr) == PTRS_PER_PUD - 1)
+			break;
+
+		vaddr += PUD_SIZE;
+	}
+}
+
+static void init_level4_page(struct xen_elf_notes *xen_elf_notes,
+				struct start_info *si_new,
+				unsigned long *ptp,
+				unsigned long *p2m,
+				unsigned long end_vaddr)
+{
+	unsigned long *pgd, ptp_pfn, vaddr;
+
+	vaddr = xen_elf_notes->virt_base;
+
+	ptp_pfn = XP_PFN_DOWN(si_new->pt_base - xen_elf_notes->virt_base);
+	pgd = &ptp[pgd_index(vaddr)];
+
+	while (vaddr < end_vaddr) {
+		ptp += PTRS_PER_PGD;
+		++ptp_pfn;
+
+		*pgd++ = XP_PFN_PHYS(p2m[ptp_pfn]) | _PAGE_TABLE;
+
+		init_level3_page(xen_elf_notes, si_new, &ptp,
+					&ptp_pfn, p2m, vaddr, end_vaddr);
+
+		if (pgd_index(vaddr) == PTRS_PER_PGD - 1)
+			break;
+
+		vaddr += PGDIR_SIZE;
+	}
+}
+
+unsigned long build_bootstrap_pgtable(struct kexec_info *info,
+					struct xen_elf_notes *xen_elf_notes,
+					struct start_info *si_new, int p2m_seg)
+{
+	unsigned long end_vaddr, *p2m, pt_paddr, pt_size, *ptp, try_vaddr = 0;
+
+	pt_paddr = get_next_paddr(info);
+
+	si_new->pt_base = xen_elf_notes->virt_base + pt_paddr;
+
+	/* Minimal number of frames required to establish valid page table for x86_64. */
+	si_new->nr_pt_frames = 4;
+
+	do {
+		end_vaddr = try_vaddr;
+
+		/*
+		 * try_vaddr = round_up(pt_base + nr_pt_frames * XP_PAGE_SIZE +
+		 *                        size_of_bootstrap_stack + 512 KiB, 4 MiB);
+		 */
+		try_vaddr = round_up(si_new->pt_base +
+					si_new->nr_pt_frames * XP_PAGE_SIZE +
+					XP_PAGE_SIZE + 0x80000, 0x400000);
+		try_vaddr -= XP_PAGE_SIZE;
+
+		/* 1 frame for PGD. */
+		si_new->nr_pt_frames = 1;
+
+		/* X frames for PUDs. */
+		si_new->nr_pt_frames +=
+			((try_vaddr - xen_elf_notes->virt_base) >>
+			 				PGDIR_SHIFT) + 1;
+
+		/* Y frames for PMDs. */
+		si_new->nr_pt_frames +=
+			((try_vaddr - xen_elf_notes->virt_base) >>
+			 				PUD_SHIFT) + 1;
+
+		/* Z frames for PTEs. */
+		si_new->nr_pt_frames +=
+			((try_vaddr - xen_elf_notes->virt_base) >>
+			 				PMD_SHIFT) + 1;
+	} while (end_vaddr != try_vaddr);
+
+	end_vaddr += XP_PAGE_SIZE;
+
+	p2m = (unsigned long *)info->segment[p2m_seg].buf;
+
+	pt_size = si_new->nr_pt_frames * XP_PAGE_SIZE;
+	ptp = xmalloc(pt_size);
+	memset(ptp, 0, pt_size);
+
+	init_level4_page(xen_elf_notes, si_new, ptp, p2m, end_vaddr);
+
+	add_buffer(info, ptp, pt_size, pt_size, XP_PAGE_SIZE,
+				pt_paddr, pt_paddr + pt_size, 1);
+
+	return end_vaddr - xen_elf_notes->virt_base;
+}
+
+void build_transition_pgtable(struct kexec_info *info,
+				struct xen_elf_notes *xen_elf_notes,
+				int p2m_seg, int bs_seg)
+{
+	unsigned long bs_addr, bs_maddr, *p2m, *pgd, pt_paddr;
+	unsigned long pt_size, *ptp, ptp_pfn;
+
+	p2m = (unsigned long *)info->segment[p2m_seg].buf;
+
+	bs_addr = (unsigned long)info->segment[bs_seg].mem;
+	bs_maddr = XP_PFN_PHYS(p2m[XP_PFN_DOWN(bs_addr)]);
+
+	pt_paddr = get_next_paddr(info);
+
+	/*
+	 * We need following number of pages to establish
+	 * valid transition page table:
+	 *   - 1 page for 1 PGD,
+	 *   - 2 pages for 2 PUDs,
+	 *   - 2 pages for 2 PMDs,
+	 *   - 2 pages for 2 PTEs.
+	 *
+	 * Sum of above equals 7...
+	 */
+
+	pt_size = TRANSITION_PGTABLE_SIZE * XP_PAGE_SIZE;
+	ptp = xmalloc(pt_size);
+	memset(ptp, 0, pt_size);
+
+	pgd = ptp;
+	ptp_pfn = XP_PFN_DOWN(pt_paddr);
+
+	pgd[pgd_index(bs_addr)] = XP_PFN_PHYS(p2m[++ptp_pfn]) | _PAGE_TABLE;
+	ptp += PTRS_PER_PGD;
+
+	ptp[pud_index(bs_addr)] = XP_PFN_PHYS(p2m[++ptp_pfn]) | _PAGE_TABLE;
+	ptp += PTRS_PER_PUD;
+
+	ptp[pmd_index(bs_addr)] = XP_PFN_PHYS(p2m[++ptp_pfn]) | _PAGE_TABLE;
+	ptp += PTRS_PER_PMD;
+
+	ptp[pte_index(bs_addr)] = bs_maddr | _PAGE_rw;
+	ptp += PTRS_PER_PTE;
+
+	bs_addr += xen_elf_notes->virt_base;
+
+	pgd[pgd_index(bs_addr)] = XP_PFN_PHYS(p2m[++ptp_pfn]) | _PAGE_TABLE;
+
+	ptp[pud_index(bs_addr)] = XP_PFN_PHYS(p2m[++ptp_pfn]) | _PAGE_TABLE;
+	ptp += PTRS_PER_PUD;
+
+	ptp[pmd_index(bs_addr)] = XP_PFN_PHYS(p2m[++ptp_pfn]) | _PAGE_TABLE;
+	ptp += PTRS_PER_PMD;
+
+	ptp[pte_index(bs_addr)] = bs_maddr | _PAGE_rw;
+
+	add_buffer(info, pgd, pt_size, pt_size, XP_PAGE_SIZE,
+				pt_paddr, pt_paddr + pt_size, 1);
+}
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/kexec/crashdump-elf.c kexec-tools-2.0.3/kexec/crashdump-elf.c
--- kexec-tools-2.0.3.orig/kexec/crashdump-elf.c	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/crashdump-elf.c	2012-04-27 14:57:47.000000000 +0200
@@ -44,7 +44,7 @@ int FUNC(struct kexec_info *info,
 	int has_vmcoreinfo_xen = 0;
 	int (*get_note_info)(int cpu, uint64_t *addr, uint64_t *len);
 
-	if (xen_present())
+	if (xen_detect() & XEN_DOM0)
 		nr_cpus = xen_get_nr_phys_cpus();
 	else
 		nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
@@ -57,10 +57,9 @@ int FUNC(struct kexec_info *info,
 		has_vmcoreinfo = 1;
 	}
 
-	if (xen_present() &&
-	    get_xen_vmcoreinfo(&vmcoreinfo_addr_xen, &vmcoreinfo_len_xen) == 0) {
+	if ((xen_detect() & XEN_DOM0) &&
+	    get_xen_vmcoreinfo(&vmcoreinfo_addr_xen, &vmcoreinfo_len_xen) == 0)
 		has_vmcoreinfo_xen = 1;
-	}
 
 	sz = sizeof(EHDR) + (nr_cpus + has_vmcoreinfo + has_vmcoreinfo_xen) * sizeof(PHDR) +
 	     ranges * sizeof(PHDR);
@@ -85,9 +84,8 @@ int FUNC(struct kexec_info *info,
 	 * PT_LOAD program header and in the physical RAM program headers.
 	 */
 
-	if (elf_info->kern_size && !xen_present()) {
+	if (elf_info->kern_size && !(xen_detect() & XEN_DOM0))
 		sz += sizeof(PHDR);
-	}
 
 	/*
 	 * Make sure the ELF core header is aligned to at least 1024.
@@ -138,7 +136,7 @@ int FUNC(struct kexec_info *info,
 	if (!get_note_info)
 		get_note_info = get_crash_notes_per_cpu;
 
-	if (xen_present())
+	if (xen_detect() & XEN_DOM0)
 		get_note_info = xen_get_note;
 
 	/* PT_NOTE program headers. One per cpu */
@@ -198,7 +196,7 @@ int FUNC(struct kexec_info *info,
 	 * Kernel is mapped if elf_info->kern_size is non-zero.
 	 */
 
-	if (elf_info->kern_size && !xen_present()) {
+	if (elf_info->kern_size && !(xen_detect() & XEN_DOM0)) {
 		phdr = (PHDR *) bufp;
 		bufp += sizeof(PHDR);
 		phdr->p_type	= PT_LOAD;
diff -Npru kexec-tools-2.0.3.orig/kexec/crashdump-xen.c kexec-tools-2.0.3/kexec/crashdump-xen.c
--- kexec-tools-2.0.3.orig/kexec/crashdump-xen.c	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/crashdump-xen.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,225 +0,0 @@
-#define _GNU_SOURCE
-#include <stdio.h>
-#include <stdarg.h>
-#include <string.h>
-#include <stdlib.h>
-#include <elf.h>
-#include <errno.h>
-#include <limits.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <setjmp.h>
-#include <signal.h>
-#include "kexec.h"
-#include "crashdump.h"
-#include "kexec-syscall.h"
-
-#include "config.h"
-
-#ifdef HAVE_LIBXENCTRL
-#include <xenctrl.h>
-#endif
-
-struct crash_note_info {
-	unsigned long base;
-	unsigned long length;
-};
-
-static int xen_phys_cpus;
-static struct crash_note_info *xen_phys_notes;
-
-/* based on code from xen-detect.c */
-static int is_dom0;
-#if defined(__i386__) || defined(__x86_64__)
-static jmp_buf xen_sigill_jmp;
-void xen_sigill_handler(int sig)
-{
-	longjmp(xen_sigill_jmp, 1);
-}
-
-static void xen_cpuid(uint32_t idx, uint32_t *regs, int pv_context)
-{
-	asm volatile (
-#ifdef __i386__
-#define R(x) "%%e"#x"x"
-#else
-#define R(x) "%%r"#x"x"
-#endif
-	"push "R(a)"; push "R(b)"; push "R(c)"; push "R(d)"\n\t"
-	"test %1,%1 ; jz 1f ; ud2a ; .ascii \"xen\" ; 1: cpuid\n\t"
-	"mov %%eax,(%2); mov %%ebx,4(%2)\n\t"
-	"mov %%ecx,8(%2); mov %%edx,12(%2)\n\t"
-	"pop "R(d)"; pop "R(c)"; pop "R(b)"; pop "R(a)"\n\t"
-	: : "a" (idx), "c" (pv_context), "S" (regs) : "memory" );
-}
-
-static int check_for_xen(int pv_context)
-{
-	uint32_t regs[4];
-	char signature[13];
-	uint32_t base;
-
-	for (base = 0x40000000; base < 0x40010000; base += 0x100)
-	{
-		xen_cpuid(base, regs, pv_context);
-
-		*(uint32_t *)(signature + 0) = regs[1];
-		*(uint32_t *)(signature + 4) = regs[2];
-		*(uint32_t *)(signature + 8) = regs[3];
-		signature[12] = '\0';
-
-		if (strcmp("XenVMMXenVMM", signature) == 0 && regs[0] >= (base + 2))
-			goto found;
-	}
-
-	return 0;
-
-found:
-	xen_cpuid(base + 1, regs, pv_context);
-	return regs[0];
-}
-
-static int xen_detect_pv_guest(void)
-{
-	struct sigaction act, oldact;
-	int is_pv = -1;
-
-	if (setjmp(xen_sigill_jmp))
-		return is_pv;
-
-	memset(&act, 0, sizeof(act));
-	act.sa_handler = xen_sigill_handler;
-	sigemptyset (&act.sa_mask);
-	if (sigaction(SIGILL, &act, &oldact))
-		return is_pv;
-	if (check_for_xen(1))
-		is_pv = 1;
-	sigaction(SIGILL, &oldact, NULL);
-	return is_pv;
-}
-#else
-static int xen_detect_pv_guest(void)
-{
-	return 1;
-}
-#endif
-
-/*
- * Return 1 if its a PV guest.
- * This includes dom0, which is the only PV guest where kexec/kdump works.
- * HVM guests have to be handled as native hardware.
- */
-int xen_present(void)
-{
-	if (!is_dom0) {
-		if (access("/proc/xen", F_OK) == 0)
-			is_dom0 = xen_detect_pv_guest();
-		else
-			is_dom0 = -1;
-	}
-	return is_dom0 > 0;
-}
-
-unsigned long xen_architecture(struct crash_elf_info *elf_info)
-{
-	unsigned long machine = elf_info->machine;
-#ifdef HAVE_LIBXENCTRL
-	int rc;
-	xen_capabilities_info_t capabilities;
-#ifdef XENCTRL_HAS_XC_INTERFACE
-	xc_interface *xc;
-#else
-	int xc;
-#endif
-
-	if (!xen_present())
-		goto out;
-
-	memset(capabilities, '0', XEN_CAPABILITIES_INFO_LEN);
-
-#ifdef XENCTRL_HAS_XC_INTERFACE
-	xc = xc_interface_open(NULL, NULL, 0);
-	if ( !xc ) {
-		fprintf(stderr, "failed to open xen control interface.\n");
-		goto out;
-	}
-#else
-	xc = xc_interface_open();
-	if ( xc == -1 ) {
-		fprintf(stderr, "failed to open xen control interface.\n");
-		goto out;
-	}
-#endif
-
-	rc = xc_version(xc, XENVER_capabilities, &capabilities[0]);
-	if ( rc == -1 ) {
-		fprintf(stderr, "failed to make Xen version hypercall.\n");
-		goto out_close;
-	}
-
-	if (strstr(capabilities, "xen-3.0-x86_64"))
-		machine = EM_X86_64;
-        else if (strstr(capabilities, "xen-3.0-x86_32"))
-		machine = EM_386;
-
- out_close:
-	xc_interface_close(xc);
-
- out:
-#endif
-	return machine;
-}
-
-static int xen_crash_note_callback(void *UNUSED(data), int nr,
-				   char *UNUSED(str),
-				   unsigned long base,
-				   unsigned long length)
-{
-	struct crash_note_info *note = xen_phys_notes + nr;
-
-	note->base = base;
-	note->length = length;
-
-	return 0;
-}
-
-int xen_get_nr_phys_cpus(void)
-{
-	char *match = "Crash note\n";
-	int cpus, n;
-
-	if (xen_phys_cpus)
-		return xen_phys_cpus;
-
-	if ((cpus = kexec_iomem_for_each_line(match, NULL, NULL))) {
-		n = sizeof(struct crash_note_info) * cpus;
-		xen_phys_notes = malloc(n);
-		if (!xen_phys_notes) {
-			fprintf(stderr, "failed to allocate xen_phys_notes.\n");
-			return -1;
-		}
-		memset(xen_phys_notes, 0, n);
-		kexec_iomem_for_each_line(match,
-					  xen_crash_note_callback, NULL);
-		xen_phys_cpus = cpus;
-	}
-
-	return cpus;
-}
-
-int xen_get_note(int cpu, uint64_t *addr, uint64_t *len)
-{
-	struct crash_note_info *note;
-
-	if (xen_phys_cpus <= 0)
-		return -1;
-
-	note = xen_phys_notes + cpu;
-
-	*addr = note->base;
-	*len = note->length;
-
-	return 0;
-}
diff -Npru kexec-tools-2.0.3.orig/kexec/crashdump.c kexec-tools-2.0.3/kexec/crashdump.c
--- kexec-tools-2.0.3.orig/kexec/crashdump.c	2012-01-09 23:39:39.000000000 +0100
+++ kexec-tools-2.0.3/kexec/crashdump.c	2012-04-27 15:01:53.000000000 +0200
@@ -30,6 +30,7 @@
 #include "kexec.h"
 #include "crashdump.h"
 #include "kexec-syscall.h"
+#include "kexec-xen.h"
 
 /* include "crashdump-elf.c" twice to create two functions from one */
 
@@ -55,7 +56,7 @@
 
 unsigned long crash_architecture(struct crash_elf_info *elf_info)
 {
-	if (xen_present())
+	if (xen_detect() & XEN_DOM0)
 		return xen_architecture(elf_info);
 	else
 		return elf_info->machine;
diff -Npru kexec-tools-2.0.3.orig/kexec/crashdump.h kexec-tools-2.0.3/kexec/crashdump.h
--- kexec-tools-2.0.3.orig/kexec/crashdump.h	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/crashdump.h	2012-03-02 22:49:30.000000000 +0100
@@ -56,9 +56,25 @@ unsigned long crash_architecture(struct 
 unsigned long phys_to_virt(struct crash_elf_info *elf_info,
 			   unsigned long paddr);
 
-int xen_present(void);
-unsigned long xen_architecture(struct crash_elf_info *elf_info);
-int xen_get_nr_phys_cpus(void);
-int xen_get_note(int cpu, uint64_t *addr, uint64_t *len);
+#ifdef HAVE_LIBXENCTRL
+extern unsigned long xen_architecture(struct crash_elf_info *elf_info);
+extern int xen_get_nr_phys_cpus(void);
+extern int xen_get_note(int cpu, uint64_t *addr, uint64_t *len);
+#else
+static inline unsigned long xen_architecture(struct crash_elf_info *elf_info)
+{
+	return 0;
+}
+
+static inline int xen_get_nr_phys_cpus(void)
+{
+	return 0;
+}
+
+static inline int xen_get_note(int cpu, uint64_t *addr, uint64_t *len)
+{
+	return 0;
+}
+#endif /* HAVE_LIBXENCTRL */
 
 #endif /* CRASHDUMP_H */
diff -Npru kexec-tools-2.0.3.orig/kexec/kexec-elf.c kexec-tools-2.0.3/kexec/kexec-elf.c
--- kexec-tools-2.0.3.orig/kexec/kexec-elf.c	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/kexec/kexec-elf.c	2012-03-10 15:28:04.000000000 +0100
@@ -667,50 +667,27 @@ static void read_nhdr(const struct mem_e
 	hdr->n_type   = elf32_to_cpu(ehdr, hdr->n_type);
 
 }
-static int build_mem_notes(struct mem_ehdr *ehdr)
+
+static void read_notes(struct mem_ehdr *ehdr, const unsigned char *note_start,
+			const unsigned char *note_end)
 {
-	const unsigned char *note_start, *note_end, *note;
-	size_t note_size, i;
-	/* First find the note segment or section */
-	note_start = note_end = NULL;
-	for(i = 0; !note_start && (i < ehdr->e_phnum); i++) {
-		struct mem_phdr *phdr = &ehdr->e_phdr[i];
-		/*
-		 * binutils <= 2.17 has a bug where it can create the
-		 * PT_NOTE segment with an offset of 0. Therefore
-		 * check p_offset > 0.
-		 *
-		 * See: http://sourceware.org/bugzilla/show_bug.cgi?id=594
-		 */
-		if (phdr->p_type == PT_NOTE && phdr->p_offset) {
-			note_start = (unsigned char *)phdr->p_data;
-			note_end = note_start + phdr->p_filesz;
-		}
-	}
-	for(i = 0; !note_start && (i < ehdr->e_shnum); i++) {
-		struct mem_shdr *shdr = &ehdr->e_shdr[i];
-		if (shdr->sh_type == SHT_NOTE) {
-			note_start = shdr->sh_data;
-			note_end = note_start + shdr->sh_size;
-		}
-	}
-	if (!note_start) {
-		return 0;
-	}
+	const unsigned char *note;
+	size_t i = ehdr->e_notenum, note_size;
 
 	/* Walk through and count the notes */
-	ehdr->e_notenum = 0;
 	for(note = note_start; note < note_end; note+= note_size) {
 		ElfNN_Nhdr hdr;
 		read_nhdr(ehdr, &hdr, note);
 		note_size  = sizeof(hdr);
 		note_size += (hdr.n_namesz + 3) & ~3;
 		note_size += (hdr.n_descsz + 3) & ~3;
-		ehdr->e_notenum += 1;
+		++ehdr->e_notenum;
 	}
+
+	ehdr->e_note = xrealloc(ehdr->e_note, sizeof(*ehdr->e_note) * ehdr->e_notenum);
+
 	/* Now walk and normalize the notes */
-	ehdr->e_note = xmalloc(sizeof(*ehdr->e_note) * ehdr->e_notenum);
-	for(i = 0, note = note_start; note < note_end; note+= note_size, i++) {
+	for(note = note_start; note < note_end; note+= note_size, i++) {
 		const unsigned char *name, *desc;
 		ElfNN_Nhdr hdr;
 		read_nhdr(ehdr, &hdr, note);
@@ -734,8 +711,46 @@ static int build_mem_notes(struct mem_eh
 		ehdr->e_note[i].n_name = (char *)name;
 		ehdr->e_note[i].n_desc = desc;
 		ehdr->e_note[i].n_descsz = hdr.n_descsz;
+	}
+}
 
+static int build_mem_notes(struct mem_ehdr *ehdr)
+{
+	const unsigned char *note_start = NULL, *note_end;
+	size_t i;
+
+	ehdr->e_note = NULL;
+	ehdr->e_notenum = 0;
+
+	/* Find the note segment or section */
+	for(i = 0; i < ehdr->e_phnum; i++) {
+		struct mem_phdr *phdr = &ehdr->e_phdr[i];
+		/*
+		 * binutils <= 2.17 has a bug where it can create the
+		 * PT_NOTE segment with an offset of 0. Therefore
+		 * check p_offset > 0.
+		 *
+		 * See: http://sourceware.org/bugzilla/show_bug.cgi?id=594
+		 */
+		if (phdr->p_type == PT_NOTE && phdr->p_offset) {
+			note_start = (unsigned char *)phdr->p_data;
+			note_end = note_start + phdr->p_filesz;
+			read_notes(ehdr, note_start, note_end);
+		}
 	}
+
+	if (note_start)
+		return 0;
+
+	for(i = 0; i < ehdr->e_shnum; i++) {
+		struct mem_shdr *shdr = &ehdr->e_shdr[i];
+		if (shdr->sh_type == SHT_NOTE) {
+			note_start = shdr->sh_data;
+			note_end = note_start + shdr->sh_size;
+			read_notes(ehdr, note_start, note_end);
+		}
+	}
+
 	return 0;
 }
 
diff -Npru kexec-tools-2.0.3.orig/kexec/kexec-xen.h kexec-tools-2.0.3/kexec/kexec-xen.h
--- kexec-tools-2.0.3.orig/kexec/kexec-xen.h	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/kexec/kexec-xen.h	2012-05-22 12:43:10.000000000 +0200
@@ -0,0 +1,20 @@
+#ifndef __KEXEC_XEN_H__
+#define __KEXEC_XEN_H__
+
+#include "config.h"
+
+#define XEN_NOT_YET_DETECTED	-1
+#define XEN_NONE		0
+#define XEN_DOM0		(1 << 0)
+#define XEN_PV			(1 << 1)
+#define XEN_HVM			(1 << 2)
+
+#ifdef HAVE_LIBXENCTRL
+extern int xen_detect(void);
+#else
+static inline int xen_detect(void)
+{
+	return XEN_NONE;
+}
+#endif /* HAVE_LIBXENCTRL */
+#endif /* __KEXEC_XEN_H__ */
diff -Npru kexec-tools-2.0.3.orig/kexec/kexec.c kexec-tools-2.0.3/kexec/kexec.c
--- kexec-tools-2.0.3.orig/kexec/kexec.c	2011-11-09 01:34:30.000000000 +0100
+++ kexec-tools-2.0.3/kexec/kexec.c	2012-05-12 18:20:51.000000000 +0200
@@ -614,6 +614,12 @@ static void update_purgatory(struct kexe
 		if (info->segment[i].mem == (void *)info->rhdr.rel_addr) {
 			continue;
 		}
+		/*
+		 * We do not care about contents of reserved
+		 * but not initialized segments.
+		 */
+		if (!info->segment[i].buf)
+			continue;
 		sha256_update(&ctx, info->segment[i].buf,
 			      info->segment[i].bufsz);
 		nullsz = info->segment[i].memsz - info->segment[i].bufsz;
@@ -747,7 +753,7 @@ static int my_load(const char *type, int
 	update_purgatory(&info);
 	if (entry)
 		info.entry = entry;
-#if 0
+#if DEBUG
 	fprintf(stderr, "kexec_load: entry = %p flags = %lx\n", 
 		info.entry, info.kexec_flags);
 	print_segments(stderr, &info);
diff -Npru kexec-tools-2.0.3.orig/kexec/kexec.h kexec-tools-2.0.3/kexec/kexec.h
--- kexec-tools-2.0.3.orig/kexec/kexec.h	2011-10-21 09:46:10.000000000 +0200
+++ kexec-tools-2.0.3/kexec/kexec.h	2012-03-27 20:33:51.000000000 +0200
@@ -94,6 +94,16 @@ do { \
 	} \
 } while(0)
 
+/*
+ * This looks more complex than it should be. But we need to
+ * get the type for the ~ right in round_down (it needs to be
+ * as wide as the result!), and we want to evaluate the macro
+ * arguments just once each.
+ */
+#define __round_mask(x, y) ((__typeof__(x))((y)-1))
+#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y) ((x) & ~__round_mask(x, y))
+
 extern unsigned long long mem_min, mem_max;
 
 struct kexec_segment {
diff -Npru kexec-tools-2.0.3.orig/purgatory/arch/i386/console-x86.c kexec-tools-2.0.3/purgatory/arch/i386/console-x86.c
--- kexec-tools-2.0.3.orig/purgatory/arch/i386/console-x86.c	2010-07-29 11:22:16.000000000 +0200
+++ kexec-tools-2.0.3/purgatory/arch/i386/console-x86.c	2012-05-22 09:42:10.000000000 +0200
@@ -1,7 +1,14 @@
+#include "config.h"
+
 #include <stdint.h>
 #include <arch/io.h>
 #include <purgatory.h>
 
+#ifdef HAVE_LIBXENCTRL
+#include <xenctrl.h>
+#include <xen/io/console.h>
+#endif
+
 /*
  * VGA
  * =============================================================================
@@ -124,12 +131,74 @@ static void putchar_serial(int ch)
 	serial_tx_byte(ch);
 }
 
+#ifdef HAVE_LIBXENCTRL
+
+/* This code is based on Xen Mini-OS console implementation. */
+
+uint8_t console_xen_pv = 0;
+struct xencons_interface *console_xen_pv_if = NULL;
+uint32_t console_xen_pv_evtchn = 0;
+
+#ifdef __i386__
+#define mb()	asm volatile("lock addl $0, 0(%%esp)" : : : "memory")
+#define wmb()	asm volatile("" : : : "memory")
+#else
+#define mb()	asm volatile("mfence" : : : "memory")
+#define wmb()	asm volatile("sfence" : : : "memory")
+#endif
+
+static void xen_pv_send_char(int ch)
+{
+	XENCONS_RING_IDX cons, prod;
+	evtchn_send_t op;
+
+	cons = console_xen_pv_if->out_cons;
+	prod = console_xen_pv_if->out_prod;
+
+	mb();
+
+	/* Hmmm... Something is wrong with Xen PV console... */
+	if ((prod - cons) > sizeof(console_xen_pv_if->out))
+		return;
+
+	console_xen_pv_if->out[MASK_XENCONS_IDX(prod++, console_xen_pv_if->out)] = ch;
+
+	wmb();
+
+	console_xen_pv_if->out_prod = prod;
+
+	op.port = console_xen_pv_evtchn;
+
+#ifdef __i386__
+	asm("int $0x82" : : "a" (__HYPERVISOR_event_channel_op),
+		"b" (EVTCHNOP_send), "c" (&op) : "memory");
+#else
+	asm("syscall" : : "a" (__HYPERVISOR_event_channel_op),
+		"D" (EVTCHNOP_send), "S" (&op) : "rcx", "r11", "memory");
+#endif
+}
+
+static void putchar_xen_pv(int ch)
+{
+	if (!console_xen_pv)
+		return;
+
+	if (ch == '\n')
+		xen_pv_send_char('\r');
+
+	xen_pv_send_char(ch);
+}
+#else
+static void putchar_xen_pv(int ch)
+{
+}
+#endif /* HAVE_LIBXENCTRL */
+
 /* Generic wrapper function */
 
 void putchar(int ch)
 {
 	putchar_vga(ch);
 	putchar_serial(ch);
+	putchar_xen_pv(ch);
 }
-
-
diff -Npru kexec-tools-2.0.3.orig/purgatory/arch/x86_64/Makefile kexec-tools-2.0.3/purgatory/arch/x86_64/Makefile
--- kexec-tools-2.0.3.orig/purgatory/arch/x86_64/Makefile	2010-07-29 11:22:16.000000000 +0200
+++ kexec-tools-2.0.3/purgatory/arch/x86_64/Makefile	2012-05-21 19:59:53.000000000 +0200
@@ -5,6 +5,7 @@
 x86_64_PURGATORY_SRCS_native = purgatory/arch/x86_64/entry64-32.S
 x86_64_PURGATORY_SRCS_native += purgatory/arch/x86_64/entry64.S
 x86_64_PURGATORY_SRCS_native += purgatory/arch/x86_64/setup-x86_64.S
+x86_64_PURGATORY_SRCS_native += purgatory/arch/x86_64/setup-x86_64-xen-pv.S
 x86_64_PURGATORY_SRCS_native += purgatory/arch/x86_64/stack.S
 x86_64_PURGATORY_SRCS_native += purgatory/arch/x86_64/purgatory-x86_64.c
 
diff -Npru kexec-tools-2.0.3.orig/purgatory/arch/x86_64/setup-x86_64-xen-pv.S kexec-tools-2.0.3/purgatory/arch/x86_64/setup-x86_64-xen-pv.S
--- kexec-tools-2.0.3.orig/purgatory/arch/x86_64/setup-x86_64-xen-pv.S	1970-01-01 01:00:00.000000000 +0100
+++ kexec-tools-2.0.3/purgatory/arch/x86_64/setup-x86_64-xen-pv.S	2012-05-22 12:45:38.000000000 +0200
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c) 2011-2012 Acunu Limited
+ *
+ * kexec/kdump implementation for Xen domU guests was written by Daniel Kiper.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "config.h"
+
+#ifdef HAVE_LIBXENCTRL
+
+	.text
+	.code64
+	.globl	xen_pv_purgatory_start, bootstrap_stack_paddr
+
+xen_pv_purgatory_start:
+	testq	%rax, %rax
+	jnz	1f
+
+0:
+	/* Is boot CPU ready? */
+	cmpb	$0, wait_for_boot_cpu
+	jnz	0b
+
+	/* Go to bootstrap. */
+	jmpq	*bootstrap_stack_paddr
+
+1:
+	/* Setup a stack. */
+	movq	$lstack_end, %rsp
+
+	pushq	%r15
+	pushq	%r14
+	pushq	%rax
+
+	call	purgatory
+
+	popq	%rax
+	popq	%r14
+	popq	%r15
+
+	/* Boot CPU is ready. */
+	lock	decb wait_for_boot_cpu
+
+	/* Go to bootstrap. */
+	jmpq	*bootstrap_stack_paddr
+
+bootstrap_stack_paddr:
+	.quad	0			/* PHYSICAL address of bootstrap stack. */
+	.size	bootstrap_stack_paddr, . - bootstrap_stack_paddr
+
+wait_for_boot_cpu:
+	.byte	1			/* Wait for boot CPU. */
+#endif /* HAVE_LIBXENCTRL */
diff -Npru kexec-tools-2.0.3.orig/purgatory/arch/x86_64/setup-x86_64.S kexec-tools-2.0.3/purgatory/arch/x86_64/setup-x86_64.S
--- kexec-tools-2.0.3.orig/purgatory/arch/x86_64/setup-x86_64.S	2011-10-03 00:56:38.000000000 +0200
+++ kexec-tools-2.0.3/purgatory/arch/x86_64/setup-x86_64.S	2012-04-13 17:56:19.000000000 +0200
@@ -23,7 +23,7 @@
 #undef i386
 
 	.text
-	.globl purgatory_start
+	.globl purgatory_start, lstack_end
 	.balign 16
 purgatory_start:
 	.code64

--FCuugMFkClbJLl1L--
