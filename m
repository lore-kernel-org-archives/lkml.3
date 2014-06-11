Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaFKXQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:16:43 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64085 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752092AbaFKXQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:16:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        =?ISO-8859-1?Q?=C9meric?= Maschino <emeric.maschino@gmail.com>
Subject: [PATCH] ACPI / ia64 / sba_iommu: Restore the working initialization ordering
Date: Thu, 12 Jun 2014 01:34:06 +0200
Message-ID: <1484331.OIWg7ItM60@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 66345d5f79fc (ACPI / ia64 / sba_iommu: Use ACPI scan handler
for device discovery) changed the ordering of SBA (System Bus Adapter)
IOMMU initialization with respect to the PCI host bridge initialization
which broke things inadvertently, because the SBA IOMMU initialization
code has to run after the PCI host bridge has been initialized.

Fix that by reworking the SBA IOMMU ACPI scan handler so that it
claims the discovered matching ACPI device objects without attempting
to initialize anything and move the entire SBA IOMMU initialization
to sba_init() that runs after the PCI bus has been enumerated.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=76691
Fixes: 66345d5f79fc (ACPI / ia64 / sba_iommu: Use ACPI scan handler for device discovery)
Reported-and-tested-by: Émeric Maschino <emeric.maschino@gmail.com>
Cc: 3.11+ <stable@vger.kernel.org> # 3.11+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/ia64/hp/common/sba_iommu.c |   64 +++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 27 deletions(-)

Index: linux-pm/arch/ia64/hp/common/sba_iommu.c
===================================================================
--- linux-pm.orig/arch/ia64/hp/common/sba_iommu.c
+++ linux-pm/arch/ia64/hp/common/sba_iommu.c
@@ -242,7 +242,7 @@ struct ioc {
 	struct pci_dev	*sac_only_dev;
 };
 
-static struct ioc *ioc_list;
+static struct ioc *ioc_list, *ioc_found;
 static int reserve_sba_gart = 1;
 
 static SBA_INLINE void sba_mark_invalid(struct ioc *, dma_addr_t, size_t);
@@ -1809,20 +1809,13 @@ static struct ioc_iommu ioc_iommu_info[]
 	{ SX2000_IOC_ID, "sx2000", NULL },
 };
 
-static struct ioc *
-ioc_init(unsigned long hpa, void *handle)
+static void ioc_init(unsigned long hpa, struct ioc *ioc)
 {
-	struct ioc *ioc;
 	struct ioc_iommu *info;
 
-	ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);
-	if (!ioc)
-		return NULL;
-
 	ioc->next = ioc_list;
 	ioc_list = ioc;
 
-	ioc->handle = handle;
 	ioc->ioc_hpa = ioremap(hpa, 0x1000);
 
 	ioc->func_id = READ_REG(ioc->ioc_hpa + IOC_FUNC_ID);
@@ -1863,8 +1856,6 @@ ioc_init(unsigned long hpa, void *handle
 		"%s %d.%d HPA 0x%lx IOVA space %dMb at 0x%lx\n",
 		ioc->name, (ioc->rev >> 4) & 0xF, ioc->rev & 0xF,
 		hpa, ioc->iov_size >> 20, ioc->ibase);
-
-	return ioc;
 }
 
 
@@ -2031,22 +2022,21 @@ sba_map_ioc_to_node(struct ioc *ioc, acp
 #endif
 }
 
-static int
-acpi_sba_ioc_add(struct acpi_device *device,
-		 const struct acpi_device_id *not_used)
+static void acpi_sba_ioc_add(struct ioc *ioc)
 {
-	struct ioc *ioc;
+	acpi_handle handle = ioc->handle;
 	acpi_status status;
 	u64 hpa, length;
 	struct acpi_device_info *adi;
 
-	status = hp_acpi_csr_space(device->handle, &hpa, &length);
+	ioc_found = ioc->next;
+	status = hp_acpi_csr_space(handle, &hpa, &length);
 	if (ACPI_FAILURE(status))
-		return 1;
+		goto err;
 
-	status = acpi_get_object_info(device->handle, &adi);
+	status = acpi_get_object_info(handle, &adi);
 	if (ACPI_FAILURE(status))
-		return 1;
+		goto err;
 
 	/*
 	 * For HWP0001, only SBA appears in ACPI namespace.  It encloses the PCI
@@ -2067,13 +2057,13 @@ acpi_sba_ioc_add(struct acpi_device *dev
 	if (!iovp_shift)
 		iovp_shift = 12;
 
-	ioc = ioc_init(hpa, device->handle);
-	if (!ioc)
-		return 1;
-
+	ioc_init(hpa, ioc);
 	/* setup NUMA node association */
-	sba_map_ioc_to_node(ioc, device->handle);
-	return 0;
+	sba_map_ioc_to_node(ioc, handle);
+	return;
+
+ err:
+	kfree(ioc);
 }
 
 static const struct acpi_device_id hp_ioc_iommu_device_ids[] = {
@@ -2081,9 +2071,26 @@ static const struct acpi_device_id hp_io
 	{"HWP0004", 0},
 	{"", 0},
 };
+
+static int acpi_sba_ioc_attach(struct acpi_device *device,
+			       const struct acpi_device_id *not_used)
+{
+	struct ioc *ioc;
+
+	ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);
+	if (!ioc)
+		return -ENOMEM;
+
+	ioc->next = ioc_found;
+	ioc_found = ioc;
+	ioc->handle = device->handle;
+	return 1;
+}
+
+
 static struct acpi_scan_handler acpi_sba_ioc_handler = {
 	.ids	= hp_ioc_iommu_device_ids,
-	.attach	= acpi_sba_ioc_add,
+	.attach	= acpi_sba_ioc_attach,
 };
 
 static int __init acpi_sba_ioc_init_acpi(void)
@@ -2118,9 +2125,12 @@ sba_init(void)
 #endif
 
 	/*
-	 * ioc_list should be populated by the acpi_sba_ioc_handler's .attach()
+	 * ioc_found should be populated by the acpi_sba_ioc_handler's .attach()
 	 * routine, but that only happens if acpi_scan_init() has already run.
 	 */
+	while (ioc_found)
+		acpi_sba_ioc_add(ioc_found);
+
 	if (!ioc_list) {
 #ifdef CONFIG_IA64_GENERIC
 		/*

