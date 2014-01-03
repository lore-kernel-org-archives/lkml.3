Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaACAMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:12:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23727 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaACAHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:48 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 08/10] IOMMU: Add intel_enable_irq_remapping_one()
Date: Thu,  2 Jan 2014 16:08:15 -0800
Message-Id: <1388707697-16800-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
References: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need that for hot-added iommu interrupt remapping suppor.

Signed-off-by: Yinghai <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/iommu/intel_irq_remapping.c | 134 ++++++++++++++++++++++++++++++++++--
 1 file changed, 127 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 8471f40..41d03d7 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -218,7 +218,7 @@ static struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	int i;
 
-	for (i = 0; i < MAX_IO_APICS; i++)
+	for (i = 0; i < ir_ioapic_num; i++)
 		if (ir_ioapic[i].id == apic)
 			return ir_ioapic[i].iommu;
 	return NULL;
@@ -324,7 +324,7 @@ static int set_ioapic_sid(struct irte *irte, int apic)
 	if (!irte)
 		return -1;
 
-	for (i = 0; i < MAX_IO_APICS; i++) {
+	for (i = 0; i < ir_ioapic_num; i++) {
 		if (ir_ioapic[i].id == apic) {
 			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
 			break;
@@ -704,6 +704,7 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
 	int count;
+	int i;
 
 	bus = scope->bus;
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
@@ -720,11 +721,16 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 		path++;
 	}
 
-	ir_ioapic[ir_ioapic_num].bus   = bus;
-	ir_ioapic[ir_ioapic_num].devfn = PCI_DEVFN(path->device, path->function);
-	ir_ioapic[ir_ioapic_num].iommu = iommu;
-	ir_ioapic[ir_ioapic_num].id    = scope->enumeration_id;
-	ir_ioapic_num++;
+	for (i = 0; i < ir_ioapic_num; i++)
+		if (!ir_ioapic[i].iommu)
+			break;
+
+	ir_ioapic[i].bus   = bus;
+	ir_ioapic[i].devfn = PCI_DEVFN(path->device, path->function);
+	ir_ioapic[i].iommu = iommu;
+	ir_ioapic[i].id    = scope->enumeration_id;
+	if (i == ir_ioapic_num)
+		ir_ioapic_num++;
 }
 
 static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
@@ -1139,6 +1145,120 @@ static int intel_setup_hpet_msi(unsigned int irq, unsigned int id)
 	return 0;
 }
 
+void disable_irq_remapping_one(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu = drhd->iommu;
+	int i;
+
+	/*
+	 * Disable Interrupt-remapping for the DRHD's now.
+	 */
+	if (!ecap_ir_support(iommu->ecap))
+		return;
+
+	iommu_disable_irq_remapping(iommu);
+
+	/* remove it from ir_ioapic */
+	for (i = 0; i < ir_ioapic_num; i++)
+		if (ir_ioapic[i].iommu == iommu) {
+			ir_ioapic[i].iommu = NULL;
+			ir_ioapic[i].id	= 0xff;
+		}
+}
+
+static int parse_ioapics_under_ir_one(struct dmar_drhd_unit *drhd)
+{
+	int ir_supported = 0;
+
+	struct intel_iommu *iommu = drhd->iommu;
+
+	if (ecap_ir_support(iommu->ecap)) {
+		if (ir_parse_ioapic_hpet_scope(drhd->hdr, iommu))
+			return -1;
+
+		ir_supported = 1;
+	}
+
+	return ir_supported;
+}
+
+int intel_enable_irq_remapping_one(struct dmar_drhd_unit *drhd)
+{
+	int setup = 0;
+	int eim = 1;
+	int ret;
+	struct intel_iommu *iommu = drhd->iommu;
+
+	if (parse_ioapics_under_ir_one(drhd) != 1) {
+		pr_info("Not enable interrupt remapping\n");
+		return -1;
+	}
+
+	/*
+	 * If the queued invalidation is already initialized,
+	 * shouldn't disable it.
+	 */
+	if (!iommu->qi) {
+		/*
+		 * Clear previous faults.
+		 */
+		dmar_fault(-1, iommu);
+
+		/*
+		 * Disable intr remapping and queued invalidation, if already
+		 * enabled prior to OS handover.
+		 */
+		iommu_disable_irq_remapping(iommu);
+
+		dmar_disable_qi(iommu);
+	}
+
+	/*
+	 * check for the Interrupt-remapping support
+	 */
+
+	if (ecap_ir_support(iommu->ecap))
+		if (eim && !ecap_eim_support(iommu->ecap)) {
+			pr_info("DRHD %Lx: EIM not supported by DRHD, ecap %Lx\n",
+				drhd->reg_base_addr, iommu->ecap);
+			return -1;
+		}
+
+	/*
+	 * Enable queued invalidation for the DRHD's.
+	 */
+	ret = dmar_enable_qi(iommu);
+
+	if (ret) {
+		pr_err("DRHD %Lx: failed to enable queued, invalidation, ecap %Lx, ret %d\n",
+		       drhd->reg_base_addr, iommu->ecap, ret);
+		return -1;
+	}
+
+	/*
+	 * Setup Interrupt-remapping for the DRHD's now.
+	 */
+	if (ecap_ir_support(iommu->ecap)) {
+		if (intel_setup_irq_remapping(iommu, eim))
+			goto error;
+
+		setup = 1;
+	}
+
+	if (!setup)
+		goto error;
+
+	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
+
+	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
+
+error:
+	/*
+	 * handle error condition gracefully here!
+	 */
+	return -1;
+}
+
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_irq_remapping_supported,
 	.prepare		= dmar_table_init,
-- 
1.8.4

