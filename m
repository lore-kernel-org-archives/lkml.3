Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbaJXI0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:26:35 -0400
Received: from mail-bn1bon0053.outbound.protection.outlook.com ([157.56.111.53]:5871
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932845AbaJXI0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:26:19 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 22/29] nios2: Cpuinfo handling
Date: Fri, 24 Oct 2014 16:24:24 +0800
Message-ID: <1414139071-3818-23-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(50466002)(48376002)(76176999)(50986999)(92726001)(86362001)(93916002)(2201001)(92566001)(97736003)(120916001)(99396003)(106466001)(102836001)(62966002)(77156001)(36756003)(50226001)(15202345003)(42186005)(85306004)(21056001)(4396001)(77096002)(104166001)(31966008)(87936001)(15975445006)(87286001)(88136002)(85852003)(89996001)(107046002)(64706001)(20776003)(46102003)(95666004)(229853001)(105596002)(47776003)(19580395003)(84676001)(44976005)(6806004)(68736004)(33646002)(19580405001)(76482002)(80022003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB222;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB222;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/cpuinfo.h |  57 +++++++++++
 arch/nios2/kernel/cpuinfo.c      | 201 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 258 insertions(+)
 create mode 100644 arch/nios2/include/asm/cpuinfo.h
 create mode 100644 arch/nios2/kernel/cpuinfo.c

diff --git a/arch/nios2/include/asm/cpuinfo.h b/arch/nios2/include/asm/cpuinfo.h
new file mode 100644
index 0000000..e88fcae
--- /dev/null
+++ b/arch/nios2/include/asm/cpuinfo.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
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
+#ifndef _ASM_NIOS2_CPUINFO_H
+#define _ASM_NIOS2_CPUINFO_H
+
+#include <linux/types.h>
+
+struct cpuinfo {
+	/* Core CPU configuration */
+	char cpu_impl[12];
+	u32 cpu_clock_freq;
+	u32 mmu;
+	u32 has_div;
+	u32 has_mul;
+	u32 has_mulx;
+
+	/* CPU caches */
+	u32 icache_line_size;
+	u32 icache_size;
+	u32 dcache_line_size;
+	u32 dcache_size;
+
+	/* TLB */
+	u32 tlb_pid_num_bits;	/* number of bits used for the PID in TLBMISC */
+	u32 tlb_num_ways;
+	u32 tlb_num_ways_log2;
+	u32 tlb_num_entries;
+	u32 tlb_num_lines;
+	u32 tlb_ptr_sz;
+
+	/* Addresses */
+	u32 reset_addr;
+	u32 exception_addr;
+	u32 fast_tlb_miss_exc_addr;
+};
+
+extern struct cpuinfo cpuinfo;
+
+extern void setup_cpuinfo(void);
+
+#endif /* _ASM_NIOS2_CPUINFO_H */
diff --git a/arch/nios2/kernel/cpuinfo.c b/arch/nios2/kernel/cpuinfo.c
new file mode 100644
index 0000000..fa57a2d
--- /dev/null
+++ b/arch/nios2/kernel/cpuinfo.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * Based on cpuinfo.c from microblaze
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/of.h>
+#include <asm/cpuinfo.h>
+
+struct cpuinfo cpuinfo;
+
+#define err_cpu(x) \
+	pr_err("ERROR: Nios II " x " different for kernel and DTS\n");
+
+static inline u32 fcpu(struct device_node *cpu, const char *n)
+{
+	u32 val = 0;
+
+	of_property_read_u32(cpu, n, &val);
+
+	return val;
+}
+
+static inline u32 fcpu_has(struct device_node *cpu, const char *n)
+{
+	return of_get_property(cpu, n, NULL) ? 1 : 0;
+}
+
+void __init setup_cpuinfo(void)
+{
+	struct device_node *cpu;
+	const char *str;
+	int len;
+
+	cpu = of_find_node_by_type(NULL, "cpu");
+	if (!cpu)
+		panic("%s: No CPU found in devicetree!\n", __func__);
+
+	if (!fcpu_has(cpu, "altr,has-initda"))
+		panic("initda instruction is unimplemented. Please update your "
+			"hardware system to have more than 4-byte line data "
+			"cache\n");
+
+	cpuinfo.cpu_clock_freq = fcpu(cpu, "clock-frequency");
+
+	str = of_get_property(cpu, "altr,implementation", &len);
+	if (str)
+		strlcpy(cpuinfo.cpu_impl, str, sizeof(cpuinfo.cpu_impl));
+	else
+		strcpy(cpuinfo.cpu_impl, "<unknown>");
+
+	cpuinfo.has_div = fcpu_has(cpu, "altr,has-div");
+	cpuinfo.has_mul = fcpu_has(cpu, "altr,has-mul");
+	cpuinfo.has_mulx = fcpu_has(cpu, "altr,has-mulx");
+
+#ifdef CONFIG_NIOS2_HW_DIV_SUPPORT
+	if (!cpuinfo.has_div)
+		err_cpu("DIV");
+#endif
+#ifdef CONFIG_NIOS2_HW_MUL_SUPPORT
+	if (!cpuinfo.has_mul)
+		err_cpu("MUL");
+#endif
+#ifdef CONFIG_NIOS2_HW_MULX_SUPPORT
+	if (!cpuinfo.has_mulx)
+		err_cpu("MULX");
+#endif
+
+	cpuinfo.tlb_num_ways = fcpu(cpu, "altr,tlb-num-ways");
+	if (!cpuinfo.tlb_num_ways)
+		panic("altr,tlb-num-ways can't be 0. Please check your hardware "
+			"system\n");
+	cpuinfo.icache_line_size = fcpu(cpu, "icache-line-size");
+	cpuinfo.icache_size = fcpu(cpu, "icache-size");
+	if (CONFIG_NIOS2_ICACHE_SIZE != cpuinfo.icache_size)
+	pr_warn("Warning: icache size configuration mismatch "
+		"(0x%x vs 0x%x) of CONFIG_NIOS2_ICACHE_SIZE vs "
+		"device tree icache-size\n",
+		CONFIG_NIOS2_ICACHE_SIZE, cpuinfo.icache_size);
+
+	cpuinfo.dcache_line_size = fcpu(cpu, "dcache-line-size");
+	if (CONFIG_NIOS2_DCACHE_LINE_SIZE != cpuinfo.dcache_line_size)
+		pr_warn("Warning: dcache line size configuration mismatch "
+		"(0x%x vs 0x%x) of CONFIG_NIOS2_DCACHE_LINE_SIZE vs "
+		"device tree dcache-line-size\n",
+		CONFIG_NIOS2_DCACHE_LINE_SIZE, cpuinfo.dcache_line_size);
+	cpuinfo.dcache_size = fcpu(cpu, "dcache-size");
+	if (CONFIG_NIOS2_DCACHE_SIZE != cpuinfo.dcache_size)
+		pr_warn("Warning: dcache size configuration mismatch "
+			"(0x%x vs 0x%x) of CONFIG_NIOS2_DCACHE_SIZE vs "
+			"device tree dcache-size\n",
+			CONFIG_NIOS2_DCACHE_SIZE, cpuinfo.dcache_size);
+
+	cpuinfo.tlb_pid_num_bits = fcpu(cpu, "altr,pid-num-bits");
+	cpuinfo.tlb_num_ways_log2 = ilog2(cpuinfo.tlb_num_ways);
+	cpuinfo.tlb_num_entries = fcpu(cpu, "altr,tlb-num-entries");
+	cpuinfo.tlb_num_lines = cpuinfo.tlb_num_entries / cpuinfo.tlb_num_ways;
+	cpuinfo.tlb_ptr_sz = fcpu(cpu, "altr,tlb-ptr-sz");
+
+	cpuinfo.reset_addr = fcpu(cpu, "altr,reset-addr");
+	cpuinfo.exception_addr = fcpu(cpu, "altr,exception-addr");
+	cpuinfo.fast_tlb_miss_exc_addr = fcpu(cpu, "altr,fast-tlb-miss-addr");
+}
+
+#ifdef CONFIG_PROC_FS
+
+/*
+ * Get CPU information for use by the procfs.
+ */
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	int count = 0;
+	const u32 clockfreq = cpuinfo.cpu_clock_freq;
+
+	count = seq_printf(m,
+			"CPU:\t\tNios II/%s\n"
+			"MMU:\t\t%s\n"
+			"FPU:\t\tnone\n"
+			"Clocking:\t%u.%02u MHz\n"
+			"BogoMips:\t%lu.%02lu\n"
+			"Calibration:\t%lu loops\n",
+			cpuinfo.cpu_impl,
+			cpuinfo.mmu ? "present" : "none",
+			clockfreq / 1000000, (clockfreq / 100000) % 10,
+			(loops_per_jiffy * HZ) / 500000,
+			((loops_per_jiffy * HZ) / 5000) % 100,
+			(loops_per_jiffy * HZ));
+
+	count += seq_printf(m,
+			"HW:\n"
+			" MUL:\t\t%s\n"
+			" MULX:\t\t%s\n"
+			" DIV:\t\t%s\n",
+			cpuinfo.has_mul ? "yes" : "no",
+			cpuinfo.has_mulx ? "yes" : "no",
+			cpuinfo.has_div ? "yes" : "no");
+
+	count += seq_printf(m,
+			"Icache:\t\t%ukB, line length: %u\n",
+			cpuinfo.icache_size >> 10,
+			cpuinfo.icache_line_size);
+
+	count += seq_printf(m,
+			"Dcache:\t\t%ukB, line length: %u\n",
+			cpuinfo.dcache_size >> 10,
+			cpuinfo.dcache_line_size);
+
+	count += seq_printf(m,
+			"TLB:\t\t%u ways, %u entries, %u PID bits\n",
+			cpuinfo.tlb_num_ways,
+			cpuinfo.tlb_num_entries,
+			cpuinfo.tlb_pid_num_bits);
+
+	return 0;
+}
+
+static void *cpuinfo_start(struct seq_file *m, loff_t *pos)
+{
+	unsigned long i = *pos;
+
+	return i < num_possible_cpus() ? (void *) (i + 1) : NULL;
+}
+
+static void *cpuinfo_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return cpuinfo_start(m, pos);
+}
+
+static void cpuinfo_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations cpuinfo_op = {
+	.start	= cpuinfo_start,
+	.next	= cpuinfo_next,
+	.stop	= cpuinfo_stop,
+	.show	= show_cpuinfo
+};
+
+#endif /* CONFIG_PROC_FS */
-- 
1.8.2.1

