Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965169AbaH1CVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:21:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:7727 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbaH1CVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:21:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,415,1406617200"; 
   d="scan'208";a="582676913"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch v4 10/16] x86, irq: Refine mp_register_ioapic() to prepare for IOAPIC hotplug
Date: Thu, 28 Aug 2014 10:22:35 +0800
Message-Id: <1409192561-19744-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine mp_register_ioapic() to prepare for IOAPIC hotplug by:
1) change return value from void to int.
2) check for gsi range conflicts
3) check for IOAPIC physical address conflicts
4) enhance the way to allocate IOAPIC index

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 +-
 arch/x86/kernel/apic/io_apic.c |   80 ++++++++++++++++++++++++----------------
 2 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0b31aebd9405..94d05bd6586f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -188,8 +188,8 @@ extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
 extern void mp_unmap_irq(int irq);
-extern void mp_register_ioapic(int id, u32 address, u32 gsi_base,
-			       struct ioapic_domain_cfg *cfg);
+extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			      struct ioapic_domain_cfg *cfg);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1ac868128a61..6e67af0c5f99 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3830,20 +3830,6 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static int bad_ioapic(unsigned long address)
-{
-	if (nr_ioapics >= MAX_IO_APICS) {
-		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
-			MAX_IO_APICS, nr_ioapics);
-		return 1;
-	}
-	if (!address) {
-		pr_warn("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
-		return 1;
-	}
-	return 0;
-}
-
 static int bad_ioapic_register(int idx)
 {
 	union IO_APIC_reg_00 reg_00;
@@ -3863,29 +3849,44 @@ static int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void mp_register_ioapic(int id, u32 address, u32 gsi_base,
-			struct ioapic_domain_cfg *cfg)
+static int find_free_ioapic_entry(void)
 {
-	int idx = 0;
-	int entries;
+	return nr_ioapics;
+}
+
+int mp_register_ioapic(int id, u32 address, u32 gsi_base,
+		       struct ioapic_domain_cfg *cfg)
+{
+	u32 gsi_end;
+	int idx, ioapic, entries;
 	struct mp_ioapic_gsi *gsi_cfg;
 
-	if (bad_ioapic(address))
-		return;
+	if (!address) {
+		pr_warn("Bogus (zero) I/O APIC address found, skipping!\n");
+		return -EINVAL;
+	}
+	for_each_ioapic(ioapic)
+		if (ioapics[ioapic].mp_config.apicaddr == address) {
+			pr_warn("address 0x%x conflicts with IOAPIC%d\n",
+				address, ioapic);
+			return -EEXIST;
+		}
 
-	idx = nr_ioapics;
+	idx = find_free_ioapic_entry();
+	if (idx >= MAX_IO_APICS) {
+		pr_warn("Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
+			MAX_IO_APICS, idx);
+		return -ENOSPC;
+	}
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
-	ioapics[idx].irqdomain = NULL;
-	ioapics[idx].irqdomain_cfg = *cfg;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-
 	if (bad_ioapic_register(idx)) {
 		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
+		return -ENODEV;
 	}
 
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(idx, id);
@@ -3896,24 +3897,41 @@ void mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
+	gsi_end = gsi_base + entries - 1;
+	for_each_ioapic(ioapic) {
+		gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+		if ((gsi_base >= gsi_cfg->gsi_base &&
+		     gsi_base <= gsi_cfg->gsi_end) ||
+		    (gsi_end >= gsi_cfg->gsi_base &&
+		     gsi_end <= gsi_cfg->gsi_end)) {
+			pr_warn("GSI range [%u-%u] for new IOAPIC conflicts with GSI[%u-%u]\n",
+				gsi_base, gsi_end,
+				gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+			return -ENOSPC;
+		}
+	}
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
-	gsi_cfg->gsi_end = gsi_base + entries - 1;
+	gsi_cfg->gsi_end = gsi_end;
 
-	/*
-	 * The number of IO-APIC IRQ registers (== #pins):
-	 */
-	ioapics[idx].nr_registers = entries;
+	ioapics[idx].irqdomain = NULL;
+	ioapics[idx].irqdomain_cfg = *cfg;
 
 	if (gsi_cfg->gsi_end >= gsi_top)
 		gsi_top = gsi_cfg->gsi_end + 1;
+	if (nr_ioapics <= idx)
+		nr_ioapics = idx + 1;
+
+	/* Set nr_registers to mark entry present */
+	ioapics[idx].nr_registers = entries;
 
 	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
 		idx, mpc_ioapic_id(idx),
 		mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
 		gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
-	nr_ioapics++;
+	return 0;
 }
 
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
-- 
1.7.10.4

