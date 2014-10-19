Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaJSBrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 21:47:21 -0400
Received: from numascale.com ([213.162.240.84]:46041 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbaJSBrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 21:47:01 -0400
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v2 4/5] Numachip: APIC driver cleanups
Date: Sun, 19 Oct 2014 09:45:51 +0800
Message-Id: <1413683152-31302-4-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413683152-31302-1-git-send-email-daniel@numascale.com>
References: <1413683152-31302-1-git-send-email-daniel@numascale.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop printing that serves no purpose, as it's printing fixed or known
values, and mark constant structure appropriately.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 22 +++-------------------
 arch/x86/pci/numachip.c              |  2 +-
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index c965b69..6374d94 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -153,20 +153,8 @@ static int __init numachip_probe(void)
 	return apic == &apic_numachip;
 }
 
-static void __init map_csrs(void)
-{
-	printk(KERN_INFO "NumaChip: Mapping local CSR space (%016llx - %016llx)\n",
-		NUMACHIP_LCSR_BASE, NUMACHIP_LCSR_BASE + NUMACHIP_LCSR_SIZE - 1);
-	init_extra_mapping_uc(NUMACHIP_LCSR_BASE, NUMACHIP_LCSR_SIZE);
-
-	printk(KERN_INFO "NumaChip: Mapping global CSR space (%016llx - %016llx)\n",
-		NUMACHIP_GCSR_BASE, NUMACHIP_GCSR_BASE + NUMACHIP_GCSR_SIZE - 1);
-	init_extra_mapping_uc(NUMACHIP_GCSR_BASE, NUMACHIP_GCSR_SIZE);
-}
-
 static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
-
 	if (c->phys_proc_id != node) {
 		c->phys_proc_id = node;
 		per_cpu(cpu_llc_id, smp_processor_id()) = node;
@@ -180,19 +168,15 @@ bool is_numachip_system(void)
 
 static int __init numachip_system_init(void)
 {
-	unsigned int val;
-
 	if (!is_numachip_system())
 		return 0;
 
+	init_extra_mapping_uc(NUMACHIP_LCSR_BASE, NUMACHIP_LCSR_SIZE);
+	init_extra_mapping_uc(NUMACHIP_GCSR_BASE, NUMACHIP_GCSR_SIZE);
+
 	x86_cpuinit.fixup_cpu_id = fixup_cpu_id;
 	x86_init.pci.arch_init = pci_numachip_init;
 
-	map_csrs();
-
-	val = read_lcsr(CSR_G0_NODE_IDS);
-	printk(KERN_INFO "NumaChip: Local NodeID = %08x\n", val);
-
 	return 0;
 }
 early_initcall(numachip_system_init);
diff --git a/arch/x86/pci/numachip.c b/arch/x86/pci/numachip.c
index 7307d9d..2e565e6 100644
--- a/arch/x86/pci/numachip.c
+++ b/arch/x86/pci/numachip.c
@@ -103,7 +103,7 @@ static int pci_mmcfg_write_numachip(unsigned int seg, unsigned int bus,
 	return 0;
 }
 
-const struct pci_raw_ops pci_mmcfg_numachip = {
+static const struct pci_raw_ops pci_mmcfg_numachip = {
 	.read = pci_mmcfg_read_numachip,
 	.write = pci_mmcfg_write_numachip,
 };
-- 
1.9.1

