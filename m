Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaKDRWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:22:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKDRWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:22:34 -0500
Date: Tue, 4 Nov 2014 09:22:13 -0800
From: tip-bot for Daniel J Blueman <tipbot@zytor.com>
Message-ID: <tip-b980dcf25d0ee1f0f8c7b6afc0e715a2f5da5ec4@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, sp@numascale.com,
        daniel@numascale.com, bhelgaas@google.com, tglx@linutronix.de,
        hpa@zytor.com
Reply-To: daniel@numascale.com, tglx@linutronix.de, bhelgaas@google.com,
        hpa@zytor.com, mingo@kernel.org, sp@numascale.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1415089784-28779-3-git-send-email-daniel@numascale.com>
References: <1415089784-28779-3-git-send-email-daniel@numascale.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: numachip: APIC driver cleanups
Git-Commit-ID: b980dcf25d0ee1f0f8c7b6afc0e715a2f5da5ec4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b980dcf25d0ee1f0f8c7b6afc0e715a2f5da5ec4
Gitweb:     http://git.kernel.org/tip/b980dcf25d0ee1f0f8c7b6afc0e715a2f5da5ec4
Author:     Daniel J Blueman <daniel@numascale.com>
AuthorDate: Tue, 4 Nov 2014 16:29:43 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Nov 2014 18:17:27 +0100

x86: numachip: APIC driver cleanups

Drop printing that serves no purpose, as it's printing fixed or known
values, and mark constant structure appropriately.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
Cc: Steffen Persvold <sp@numascale.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/1415089784-28779-3-git-send-email-daniel@numascale.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic_numachip.c | 22 +++-------------------
 arch/x86/pci/numachip.c              |  2 +-
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 7a31912..c2fd21f 100644
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
@@ -175,19 +163,15 @@ static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 
 static int __init numachip_system_init(void)
 {
-	unsigned int val;
-
 	if (!numachip_system)
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
