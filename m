Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbaLINjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:39:15 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49956 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaLINjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:39:13 -0500
Date: Tue, 9 Dec 2014 14:39:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform tree changes for v3.19
Message-ID: <20141209133908.GA32268@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   # HEAD: b980dcf25d0ee1f0f8c7b6afc0e715a2f5da5ec4 x86: numachip: APIC driver cleanups

A handful of numachip APIC driver updates/fixes.

 Thanks,

	Ingo

------------------>
Daniel J Blueman (3):
      x86: numachip: Fix 16-bit APIC ID truncation
      x86: numachip: Elide self-IPI ICR polling
      x86: numachip: APIC driver cleanups


 arch/x86/kernel/apic/apic_numachip.c | 26 +++++---------------------
 arch/x86/pci/numachip.c              |  2 +-
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 4128b5fcb559..c2fd21fed002 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -40,7 +40,7 @@ static unsigned int get_apic_id(unsigned long x)
 	unsigned int id;
 
 	rdmsrl(MSR_FAM10H_NODE_ID, value);
-	id = ((x >> 24) & 0xffU) | ((value << 2) & 0x3f00U);
+	id = ((x >> 24) & 0xffU) | ((value << 2) & 0xff00U);
 
 	return id;
 }
@@ -145,7 +145,7 @@ static void numachip_send_IPI_all(int vector)
 
 static void numachip_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+	apic_write(APIC_SELF_IPI, vector);
 }
 
 static int __init numachip_probe(void)
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
index 7307d9d12d15..2e565e65c893 100644
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
