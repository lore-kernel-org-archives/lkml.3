Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaJXIZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:25:47 -0400
Received: from mail-by2on0065.outbound.protection.outlook.com ([207.46.100.65]:36696
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755752AbaJXIZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:35 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 12/29] nios2: TLB handling
Date: Fri, 24 Oct 2014 16:24:14 +0800
Message-ID: <1414139071-3818-13-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(22564002)(189002)(4396001)(50226001)(20776003)(33646002)(88136002)(21056001)(89996001)(86362001)(76482002)(93916002)(36756003)(99396003)(92566001)(92726001)(2201001)(77156001)(87936001)(87286001)(50986999)(76176999)(31966008)(47776003)(68736004)(64706001)(77096002)(44976005)(62966002)(106466001)(97736003)(19580395003)(19580405001)(95666004)(104166001)(229853001)(50466002)(48376002)(42186005)(15202345003)(15975445006)(85852003)(105596002)(46102003)(80022003)(120916001)(85306004)(84676001)(107046002)(102836001)(6806004);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1PR03MB599;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CH1PR03MB599;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the TLB maintenance functions.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/tlb.h      |  34 +++++
 arch/nios2/include/asm/tlbflush.h |  46 +++++++
 arch/nios2/mm/tlb.c               | 274 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 354 insertions(+)
 create mode 100644 arch/nios2/include/asm/tlb.h
 create mode 100644 arch/nios2/include/asm/tlbflush.h
 create mode 100644 arch/nios2/mm/tlb.c

diff --git a/arch/nios2/include/asm/tlb.h b/arch/nios2/include/asm/tlb.h
new file mode 100644
index 0000000..d3bc648
--- /dev/null
+++ b/arch/nios2/include/asm/tlb.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_TLB_H
+#define _ASM_NIOS2_TLB_H
+
+#define tlb_flush(tlb)	flush_tlb_mm((tlb)->mm)
+
+extern void set_mmu_pid(unsigned long pid);
+
+/*
+ * NiosII doesn't need any special per-pte or per-vma handling, except
+ * we need to flush cache for the area to be unmapped.
+ */
+#define tlb_start_vma(tlb, vma)					\
+	do {							\
+		if (!tlb->fullmm)				\
+			flush_cache_range(vma, vma->vm_start, vma->vm_end); \
+	}  while (0)
+
+#define tlb_end_vma(tlb, vma)	do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
+
+#include <linux/pagemap.h>
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_NIOS2_TLB_H */
diff --git a/arch/nios2/include/asm/tlbflush.h b/arch/nios2/include/asm/tlbflush.h
new file mode 100644
index 0000000..e19652f
--- /dev/null
+++ b/arch/nios2/include/asm/tlbflush.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef _ASM_NIOS2_TLBFLUSH_H
+#define _ASM_NIOS2_TLBFLUSH_H
+
+struct mm_struct;
+
+/*
+ * TLB flushing:
+ *
+ *  - flush_tlb_all() flushes all processes TLB entries
+ *  - flush_tlb_mm(mm) flushes the specified mm context TLB entries
+ *  - flush_tlb_page(vma, vmaddr) flushes one page
+ *  - flush_tlb_range(vma, start, end) flushes a range of pages
+ *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
+ */
+extern void flush_tlb_all(void);
+extern void flush_tlb_mm(struct mm_struct *mm);
+extern void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end);
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+extern void flush_tlb_one(unsigned long vaddr);
+
+static inline void flush_tlb_page(struct vm_area_struct *vma,
+				unsigned long addr)
+{
+	flush_tlb_one(addr);
+}
+
+#endif /* _ASM_NIOS2_TLBFLUSH_H */
diff --git a/arch/nios2/mm/tlb.c b/arch/nios2/mm/tlb.c
new file mode 100644
index 0000000..642b6df
--- /dev/null
+++ b/arch/nios2/mm/tlb.c
@@ -0,0 +1,274 @@
+/*
+ * Nios2 TLB handling
+ *
+ * Copyright (C) 2009, Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+
+#include <asm/tlb.h>
+#include <asm/mmu_context.h>
+#include <asm/pgtable.h>
+#include <asm/cpuinfo.h>
+
+#define TLB_INDEX_MASK		\
+	((((1UL << (cpuinfo.tlb_ptr_sz - cpuinfo.tlb_num_ways_log2))) - 1) \
+		<< PAGE_SHIFT)
+
+/* Used as illegal PHYS_ADDR for TLB mappings
+ */
+#define MAX_PHYS_ADDR 0
+
+static void get_misc_and_pid(unsigned long *misc, unsigned long *pid)
+{
+	*misc  = RDCTL(CTL_TLBMISC);
+	*misc &= (TLBMISC_PID | TLBMISC_WAY);
+	*pid  = *misc & TLBMISC_PID;
+}
+
+/*
+ * All entries common to a mm share an asid.  To effectively flush these
+ * entries, we just bump the asid.
+ */
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	if (current->mm == mm)
+		flush_tlb_all();
+	else
+		memset(&mm->context, 0, sizeof(mm_context_t));
+}
+
+/*
+ * This one is only used for pages with the global bit set so we don't care
+ * much about the ASID.
+ */
+void flush_tlb_one_pid(unsigned long addr, unsigned long mmu_pid)
+{
+	unsigned int way;
+	unsigned long org_misc, pid_misc;
+
+	pr_debug("Flush tlb-entry for vaddr=%#lx\n", addr);
+
+	/* remember pid/way until we return. */
+	get_misc_and_pid(&org_misc, &pid_misc);
+
+	WRCTL(CTL_PTEADDR, (addr >> PAGE_SHIFT) << 2);
+
+	for (way = 0; way < cpuinfo.tlb_num_ways; way++) {
+		unsigned long pteaddr;
+		unsigned long tlbmisc;
+		unsigned long pid;
+
+		tlbmisc = pid_misc | TLBMISC_RD | (way << TLBMISC_WAY_SHIFT);
+		WRCTL(CTL_TLBMISC, tlbmisc);
+		pteaddr = RDCTL(CTL_PTEADDR);
+		tlbmisc = RDCTL(CTL_TLBMISC);
+		pid = (tlbmisc >> TLBMISC_PID_SHIFT) & TLBMISC_PID_MASK;
+		if (((((pteaddr >> 2) & 0xfffff)) == (addr >> PAGE_SHIFT)) &&
+				pid == mmu_pid) {
+			unsigned long vaddr = CONFIG_NIOS2_IO_REGION_BASE +
+				((PAGE_SIZE * cpuinfo.tlb_num_lines) * way) +
+				(addr & TLB_INDEX_MASK);
+			pr_debug("Flush entry by writing %#lx way=%dl pid=%ld\n",
+				vaddr, way, (pid_misc >> TLBMISC_PID_SHIFT));
+
+			WRCTL(CTL_PTEADDR, (vaddr >> 12) << 2);
+			tlbmisc = pid_misc | TLBMISC_WE |
+				(way << TLBMISC_WAY_SHIFT);
+			WRCTL(CTL_TLBMISC, tlbmisc);
+			WRCTL(CTL_TLBACC, (MAX_PHYS_ADDR >> PAGE_SHIFT));
+		}
+	}
+
+	WRCTL(CTL_TLBMISC, org_misc);
+}
+
+void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end)
+{
+	unsigned long mmu_pid = get_pid_from_context(&vma->vm_mm->context);
+
+	while (start < end) {
+		flush_tlb_one_pid(start, mmu_pid);
+		start += PAGE_SIZE;
+	}
+}
+
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	while (start < end) {
+		flush_tlb_one(start);
+		start += PAGE_SIZE;
+	}
+}
+
+/*
+ * This one is only used for pages with the global bit set so we don't care
+ * much about the ASID.
+ */
+void flush_tlb_one(unsigned long addr)
+{
+	unsigned int way;
+	unsigned long org_misc, pid_misc;
+
+	pr_debug("Flush tlb-entry for vaddr=%#lx\n", addr);
+
+	/* remember pid/way until we return. */
+	get_misc_and_pid(&org_misc, &pid_misc);
+
+	WRCTL(CTL_PTEADDR, (addr >> PAGE_SHIFT) << 2);
+
+	for (way = 0; way < cpuinfo.tlb_num_ways; way++) {
+		unsigned long pteaddr;
+		unsigned long tlbmisc;
+
+		tlbmisc = pid_misc | TLBMISC_RD | (way << TLBMISC_WAY_SHIFT);
+		WRCTL(CTL_TLBMISC, tlbmisc);
+		pteaddr = RDCTL(CTL_PTEADDR);
+		tlbmisc = RDCTL(CTL_TLBMISC);
+
+		if ((((pteaddr >> 2) & 0xfffff)) == (addr >> PAGE_SHIFT)) {
+			unsigned long vaddr = CONFIG_NIOS2_IO_REGION_BASE +
+				((PAGE_SIZE * cpuinfo.tlb_num_lines) * way) +
+				(addr & TLB_INDEX_MASK);
+
+			pr_debug("Flush entry by writing %#lx way=%dl pid=%ld\n",
+				vaddr, way, (pid_misc >> TLBMISC_PID_SHIFT));
+
+			tlbmisc = pid_misc | TLBMISC_WE |
+				(way << TLBMISC_WAY_SHIFT);
+			WRCTL(CTL_PTEADDR, (vaddr >> 12) << 2);
+			WRCTL(CTL_TLBMISC, tlbmisc);
+			WRCTL(CTL_TLBACC, (MAX_PHYS_ADDR >> PAGE_SHIFT));
+		}
+	}
+
+	WRCTL(CTL_TLBMISC, org_misc);
+}
+
+void dump_tlb_line(unsigned long line)
+{
+	unsigned int way;
+	unsigned long org_misc;
+
+	pr_debug("dump tlb-entries for line=%#lx (addr %08lx)\n", line,
+		line << (PAGE_SHIFT + cpuinfo.tlb_num_ways_log2));
+
+	/* remember pid/way until we return */
+	org_misc = (RDCTL(CTL_TLBMISC) & (TLBMISC_PID | TLBMISC_WAY));
+
+	WRCTL(CTL_PTEADDR, line << 2);
+
+	for (way = 0; way < cpuinfo.tlb_num_ways; way++) {
+		unsigned long pteaddr;
+		unsigned long tlbmisc;
+		unsigned long tlbacc;
+
+		WRCTL(CTL_TLBMISC, TLBMISC_RD | (way << TLBMISC_WAY_SHIFT));
+		pteaddr = RDCTL(CTL_PTEADDR);
+		tlbmisc = RDCTL(CTL_TLBMISC);
+		tlbacc = RDCTL(CTL_TLBACC);
+
+		if ((tlbacc << PAGE_SHIFT) != (MAX_PHYS_ADDR & PAGE_MASK)) {
+			pr_debug("-- way:%02x vpn:0x%08lx phys:0x%08lx pid:0x%02lx flags:%c%c%c%c%c\n",
+				way,
+				(pteaddr << (PAGE_SHIFT-2)),
+				(tlbacc << PAGE_SHIFT),
+				((tlbmisc >> TLBMISC_PID_SHIFT) &
+				TLBMISC_PID_MASK),
+				(tlbacc & _PAGE_READ ? 'r' : '-'),
+				(tlbacc & _PAGE_WRITE ? 'w' : '-'),
+				(tlbacc & _PAGE_EXEC ? 'x' : '-'),
+				(tlbacc & _PAGE_GLOBAL ? 'g' : '-'),
+				(tlbacc & _PAGE_CACHED ? 'c' : '-'));
+		}
+	}
+
+	WRCTL(CTL_TLBMISC, org_misc);
+}
+
+void dump_tlb(void)
+{
+	unsigned int i;
+	for (i = 0; i < cpuinfo.tlb_num_lines; i++)
+		dump_tlb_line(i);
+}
+
+void flush_tlb_pid(unsigned long pid)
+{
+	unsigned int line;
+	unsigned int way;
+	unsigned long org_misc, pid_misc;
+
+	/* remember pid/way until we return */
+	get_misc_and_pid(&org_misc, &pid_misc);
+
+	for (line = 0; line < cpuinfo.tlb_num_lines; line++) {
+		WRCTL(CTL_PTEADDR, line << 2);
+
+		for (way = 0; way < cpuinfo.tlb_num_ways; way++) {
+			unsigned long pteaddr;
+			unsigned long tlbmisc;
+			unsigned long tlbacc;
+
+			tlbmisc = pid_misc | TLBMISC_RD |
+				(way << TLBMISC_WAY_SHIFT);
+			WRCTL(CTL_TLBMISC, tlbmisc);
+			pteaddr = RDCTL(CTL_PTEADDR);
+			tlbmisc = RDCTL(CTL_TLBMISC);
+			tlbacc = RDCTL(CTL_TLBACC);
+
+			if (((tlbmisc>>TLBMISC_PID_SHIFT) & TLBMISC_PID_MASK)
+				== pid) {
+				tlbmisc = pid_misc | TLBMISC_WE |
+					(way << TLBMISC_WAY_SHIFT);
+				WRCTL(CTL_TLBMISC, tlbmisc);
+				WRCTL(CTL_TLBACC,
+					(MAX_PHYS_ADDR >> PAGE_SHIFT));
+			}
+		}
+
+		WRCTL(CTL_TLBMISC, org_misc);
+	}
+}
+
+void flush_tlb_all(void)
+{
+	int i;
+	unsigned long vaddr = CONFIG_NIOS2_IO_REGION_BASE;
+	unsigned int way;
+	unsigned long org_misc, pid_misc, tlbmisc;
+
+	/* remember pid/way until we return */
+	get_misc_and_pid(&org_misc, &pid_misc);
+	pid_misc |= TLBMISC_WE;
+
+	/* Map each TLB entry to physcal address 0 with no-access and a
+	   bad ptbase */
+	for (way = 0; way < cpuinfo.tlb_num_ways; way++) {
+		tlbmisc = pid_misc | (way << TLBMISC_WAY_SHIFT);
+		for (i = 0; i < cpuinfo.tlb_num_lines; i++) {
+			WRCTL(CTL_PTEADDR, ((vaddr) >> PAGE_SHIFT) << 2);
+			WRCTL(CTL_TLBMISC, tlbmisc);
+			WRCTL(CTL_TLBACC, (MAX_PHYS_ADDR >> PAGE_SHIFT));
+			vaddr += 1UL << 12;
+		}
+	}
+
+	/* restore pid/way */
+	WRCTL(CTL_TLBMISC, org_misc);
+}
+
+void set_mmu_pid(unsigned long pid)
+{
+	WRCTL(CTL_TLBMISC, (RDCTL(CTL_TLBMISC) & TLBMISC_WAY) |
+		((pid & TLBMISC_PID_MASK) << TLBMISC_PID_SHIFT));
+}
-- 
1.8.2.1

