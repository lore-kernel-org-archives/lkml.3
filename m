Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaKCLDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:03:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaKCLDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:03:15 -0500
Date: Mon, 3 Nov 2014 03:00:01 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-36f3a2a6cec30b332035ccad32d749b2216a2168@git.kernel.org>
Cc: jiang.liu@linux.intel.com, rdunlap@infradead.org, hpa@zytor.com,
        konrad.wilk@oracle.com, yinghai@kernel.org, prarit@redhat.com,
        tglx@linutronix.de, joro@8bytes.org, bhelgaas@google.com,
        mingo@kernel.org, benh@kernel.crashing.org, grant.likely@linaro.org,
        tony.luck@intel.com, linux-kernel@vger.kernel.org, bp@alien8.de,
        rjw@rjwysocki.net, gregkh@linuxfoundation.org
Reply-To: yinghai@kernel.org, prarit@redhat.com, konrad.wilk@oracle.com,
        rdunlap@infradead.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        mingo@kernel.org, bhelgaas@google.com, joro@8bytes.org,
        tglx@linutronix.de, tony.luck@intel.com, grant.likely@linaro.org,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, bp@alien8.de, linux-kernel@vger.kernel.org
In-Reply-To: <1414387308-27148-14-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-14-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Refine mp_register_ioapic()
  to prepare for IOAPIC hotplug
Git-Commit-ID: 36f3a2a6cec30b332035ccad32d749b2216a2168
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

Commit-ID:  36f3a2a6cec30b332035ccad32d749b2216a2168
Gitweb:     http://git.kernel.org/tip/36f3a2a6cec30b332035ccad32d749b2216a2168
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:43 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:08 +0100

x86, irq: Refine mp_register_ioapic() to prepare for IOAPIC hotplug

Refine mp_register_ioapic() to prepare for IOAPIC hotplug by:
1) change return value from void to int.
2) check for gsi range conflicts
3) check for IOAPIC physical address conflicts
4) enhance the way to allocate IOAPIC index

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414387308-27148-14-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  4 +-
 arch/x86/kernel/apic/io_apic.c | 87 +++++++++++++++++++++++++++---------------
 2 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a666dcd..8741c1e 100644
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
index 19501ab..090d3fe 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3840,20 +3840,6 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
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
@@ -3873,29 +3859,51 @@ static int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void mp_register_ioapic(int id, u32 address, u32 gsi_base,
-			struct ioapic_domain_cfg *cfg)
+static int find_free_ioapic_entry(void)
+{
+	return nr_ioapics;
+}
+
+/**
+ * mp_register_ioapic - Register an IOAPIC device
+ * @id:		hardware IOAPIC ID
+ * @address:	physical address of IOAPIC register area
+ * @gsi_base:	base of GSI associated with the IOAPIC
+ * @cfg:	configuration information for the IOAPIC
+ */
+int mp_register_ioapic(int id, u32 address, u32 gsi_base,
+		       struct ioapic_domain_cfg *cfg)
 {
-	int idx = 0;
-	int entries;
 	struct mp_ioapic_gsi *gsi_cfg;
+	int idx, ioapic, entries;
+	u32 gsi_end;
 
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
@@ -3906,24 +3914,41 @@ void mp_register_ioapic(int id, u32 address, u32 gsi_base,
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
