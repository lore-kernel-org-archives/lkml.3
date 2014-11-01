Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbaKAPpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 11:45:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63584 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbaKAPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 11:45:06 -0400
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Steven Honeyman <stevenhoneyman@gmail.com>
Subject: [PATCH] x86, cpu: trivial printk formatting fixes
Date: Sat,  1 Nov 2014 15:44:56 +0000
Message-Id: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 2 line printk makes dmesg output messy, because the second line does not get a timestamp.
For example:

[    0.012863] CPU0: Thermal monitoring enabled (TM1)
[    0.012869] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.012958] Freeing SMP alternatives memory: 28K (ffffffff81d86000 - ffffffff81d8d000)
[    0.014961] dmar: Host address width 39

Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>
---
 arch/x86/kernel/cpu/common.c | 11 ++++++-----
 arch/x86/kernel/cpu/intel.c  |  6 ++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b4f78c..fbdd7bf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -494,12 +494,13 @@ void cpu_detect_tlb(struct cpuinfo_x86 *c)
 	if (this_cpu->c_detect_tlb)
 		this_cpu->c_detect_tlb(c);
 
-	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n"
-		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n",
+	pr_info("Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
-		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
-		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
-		tlb_lld_1g[ENTRIES]);
+		tlb_lli_4m[ENTRIES]);
+
+	pr_info("Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n",
+		tlb_lld_4k[ENTRIES], tlb_lld_2m[ENTRIES],
+		tlb_lld_4m[ENTRIES], tlb_lld_1g[ENTRIES]);
 }
 
 void detect_ht(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9cc6b6f..dcd08a3 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -487,10 +487,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 
 		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
-			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
-				" Set to 'normal', was 'performance'\n"
-				"ENERGY_PERF_BIAS: View and update with"
-				" x86_energy_perf_policy(8)\n");
+			pr_info_once("ENERGY_PERF_BIAS: Set to 'normal', was 'performance'\n");
+			pr_info_once("ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)\n");
 			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
 			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		}
-- 
2.1.3

