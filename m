Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaJXIZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:25:30 -0400
Received: from mail-bn1bon0057.outbound.protection.outlook.com ([157.56.111.57]:51174
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755511AbaJXIZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:18 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 08/29] nios2: MMU Fault handling
Date: Fri, 24 Oct 2014 16:24:10 +0800
Message-ID: <1414139071-3818-9-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(22564002)(189002)(199003)(50986999)(36756003)(4396001)(50226001)(21056001)(87936001)(106466001)(76176999)(87286001)(88136002)(575784001)(85852003)(86362001)(95666004)(77096002)(20776003)(85306004)(47776003)(89996001)(92566001)(92726001)(62966002)(64706001)(93916002)(2201001)(77156001)(42186005)(105596002)(48376002)(31966008)(102836001)(50466002)(6806004)(229853001)(97736003)(19580395003)(19580405001)(44976005)(68736004)(107046002)(120916001)(104166001)(80022003)(46102003)(76482002)(33646002)(84676001)(99396003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB214;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB134;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the handling of the MMU faults (exception
entry code introduced by a previous patch, kernel/entry.S).

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/mm/extable.c |  25 +++++
 arch/nios2/mm/fault.c   | 251 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 276 insertions(+)
 create mode 100644 arch/nios2/mm/extable.c
 create mode 100644 arch/nios2/mm/fault.c

diff --git a/arch/nios2/mm/extable.c b/arch/nios2/mm/extable.c
new file mode 100644
index 0000000..4d2fc5a
--- /dev/null
+++ b/arch/nios2/mm/extable.c
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2010, Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009, Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	fixup = search_exception_tables(regs->ea);
+	if (fixup) {
+		regs->ea = fixup->fixup;
+		return 1;
+	}
+
+	return 0;
+}
diff --git a/arch/nios2/mm/fault.c b/arch/nios2/mm/fault.c
new file mode 100644
index 0000000..15a0bb5
--- /dev/null
+++ b/arch/nios2/mm/fault.c
@@ -0,0 +1,251 @@
+/*
+ * Copyright (C) 2009 Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * based on arch/mips/mm/fault.c which is:
+ *
+ * Copyright (C) 1995-2000 Ralf Baechle
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/ptrace.h>
+
+#include <asm/mmu_context.h>
+#include <asm/traps.h>
+
+#define EXC_SUPERV_INSN_ACCESS	9  /* Supervisor only instruction address */
+#define EXC_SUPERV_DATA_ACCESS	11 /* Supervisor only data address */
+#define EXC_X_PROTECTION_FAULT	13 /* TLB permission violation (x) */
+#define EXC_R_PROTECTION_FAULT	14 /* TLB permission violation (r) */
+#define EXC_W_PROTECTION_FAULT	15 /* TLB permission violation (w) */
+
+/*
+ * This routine handles page faults.  It determines the address,
+ * and the problem, and then passes it off to one of the appropriate
+ * routines.
+ */
+asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long cause,
+				unsigned long address)
+{
+	struct vm_area_struct *vma = NULL;
+	struct task_struct *tsk = current;
+	struct mm_struct *mm = tsk->mm;
+	int code = SEGV_MAPERR;
+	int fault;
+	unsigned int flags = 0;
+
+	cause >>= 2;
+
+	/* Restart the instruction */
+	regs->ea -= 4;
+
+	/*
+	 * We fault-in kernel-space virtual memory on-demand. The
+	 * 'reference' page table is init_mm.pgd.
+	 *
+	 * NOTE! We MUST NOT take any locks for this case. We may
+	 * be in an interrupt or a critical region, and should
+	 * only copy the information from the master page table,
+	 * nothing more.
+	 */
+	if (unlikely(address >= VMALLOC_START && address <= VMALLOC_END)) {
+		if (user_mode(regs))
+			goto bad_area_nosemaphore;
+		else
+			goto vmalloc_fault;
+	}
+
+	if (unlikely(address >= TASK_SIZE))
+		goto bad_area_nosemaphore;
+
+	/*
+	 * If we're in an interrupt or have no user
+	 * context, we must not take the fault..
+	 */
+	if (in_atomic() || !mm)
+		goto bad_area_nosemaphore;
+
+	if (user_mode(regs))
+		flags |= FAULT_FLAG_USER;
+
+	if (!down_read_trylock(&mm->mmap_sem)) {
+		if (!user_mode(regs) && !search_exception_tables(regs->ea))
+			goto bad_area_nosemaphore;
+		down_read(&mm->mmap_sem);
+	}
+
+	vma = find_vma(mm, address);
+	if (!vma)
+		goto bad_area;
+	if (vma->vm_start <= address)
+		goto good_area;
+	if (!(vma->vm_flags & VM_GROWSDOWN))
+		goto bad_area;
+	if (expand_stack(vma, address))
+		goto bad_area;
+/*
+ * Ok, we have a good vm_area for this memory access, so
+ * we can handle it..
+ */
+good_area:
+	code = SEGV_ACCERR;
+
+	switch (cause) {
+	case EXC_SUPERV_INSN_ACCESS:
+		goto bad_area;
+	case EXC_SUPERV_DATA_ACCESS:
+		goto bad_area;
+	case EXC_X_PROTECTION_FAULT:
+		if (!(vma->vm_flags & VM_EXEC))
+			goto bad_area;
+		break;
+	case EXC_R_PROTECTION_FAULT:
+		if (!(vma->vm_flags & VM_READ))
+			goto bad_area;
+		break;
+	case EXC_W_PROTECTION_FAULT:
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+		flags = FAULT_FLAG_WRITE;
+		break;
+	}
+
+survive:
+	/*
+	 * If for any reason at all we couldn't handle the fault,
+	 * make sure we exit gracefully rather than endlessly redo
+	 * the fault.
+	 */
+	fault = handle_mm_fault(mm, vma, address, flags);
+	if (unlikely(fault & VM_FAULT_ERROR)) {
+		if (fault & VM_FAULT_OOM)
+			goto out_of_memory;
+		else if (fault & VM_FAULT_SIGBUS)
+			goto do_sigbus;
+		BUG();
+	}
+	if (fault & VM_FAULT_MAJOR)
+		tsk->maj_flt++;
+	else
+		tsk->min_flt++;
+
+	up_read(&mm->mmap_sem);
+	return;
+
+/*
+ * Something tried to access memory that isn't in our memory map..
+ * Fix it, but check if it's kernel or user first..
+ */
+bad_area:
+	up_read(&mm->mmap_sem);
+
+bad_area_nosemaphore:
+	/* User mode accesses just cause a SIGSEGV */
+	if (user_mode(regs)) {
+		pr_alert("%s: unhandled page fault (%d) at 0x%08lx, "
+			"cause %ld\n", current->comm, SIGSEGV, address, cause);
+		show_regs(regs);
+		_exception(SIGSEGV, regs, code, address);
+		return;
+	}
+
+no_context:
+	/* Are we prepared to handle this kernel fault? */
+	if (fixup_exception(regs))
+		return;
+
+	/*
+	 * Oops. The kernel tried to access some bad page. We'll have to
+	 * terminate things with extreme prejudice.
+	 */
+	bust_spinlocks(1);
+
+	pr_alert("Unable to handle kernel %s at virtual address %08lx",
+		address < PAGE_SIZE ? "NULL pointer dereference" :
+		"paging request", address);
+	pr_alert("ea = %08lx, ra = %08lx, cause = %ld\n", regs->ea, regs->ra,
+		cause);
+	panic("Oops");
+	return;
+
+/*
+ * We ran out of memory, or some other thing happened to us that made
+ * us unable to handle the page fault gracefully.
+ */
+out_of_memory:
+	up_read(&mm->mmap_sem);
+	if (is_global_init(tsk)) {
+		yield();
+		down_read(&mm->mmap_sem);
+		goto survive;
+	}
+	if (!user_mode(regs))
+		goto no_context;
+	pagefault_out_of_memory();
+	return;
+
+do_sigbus:
+	up_read(&mm->mmap_sem);
+
+	/* Kernel mode? Handle exceptions or die */
+	if (!user_mode(regs))
+		goto no_context;
+
+	_exception(SIGBUS, regs, BUS_ADRERR, address);
+	return;
+
+vmalloc_fault:
+	{
+		/*
+		 * Synchronize this task's top level page-table
+		 * with the 'reference' page table.
+		 *
+		 * Do _not_ use "tsk" here. We might be inside
+		 * an interrupt in the middle of a task switch..
+		 */
+		int offset = pgd_index(address);
+		pgd_t *pgd, *pgd_k;
+		pud_t *pud, *pud_k;
+		pmd_t *pmd, *pmd_k;
+		pte_t *pte_k;
+
+		pgd = pgd_current + offset;
+		pgd_k = init_mm.pgd + offset;
+
+		if (!pgd_present(*pgd_k))
+			goto no_context;
+		set_pgd(pgd, *pgd_k);
+
+		pud = pud_offset(pgd, address);
+		pud_k = pud_offset(pgd_k, address);
+		if (!pud_present(*pud_k))
+			goto no_context;
+		pmd = pmd_offset(pud, address);
+		pmd_k = pmd_offset(pud_k, address);
+		if (!pmd_present(*pmd_k))
+			goto no_context;
+		set_pmd(pmd, *pmd_k);
+
+		pte_k = pte_offset_kernel(pmd_k, address);
+		if (!pte_present(*pte_k))
+			goto no_context;
+
+		flush_tlb_one(address);
+		return;
+	}
+}
-- 
1.8.2.1

