Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030557AbaGCJZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52552 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030468AbaGCJY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 173/198] ACPI / ia64 / sba_iommu: Restore the working initialization ordering
Date: Thu,  3 Jul 2014 10:20:16 +0100
Message-Id: <1404379241-8590-174-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 12e27b115472ad0f3b142ddf59d3998305984408 upstream.

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
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/ia64/hp/common/sba_iommu.c | 64 ++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 7dd4889458d7..c4ba77c44772 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -242,7 +242,7 @@ struct ioc {
 	struct pci_dev	*sac_only_dev;
 };
 
-static struct ioc *ioc_list;
+static struct ioc *ioc_list, *ioc_found;
 static int reserve_sba_gart = 1;
 
 static SBA_INLINE void sba_mark_invalid(struct ioc *, dma_addr_t, size_t);
@@ -1807,20 +1807,13 @@ static struct ioc_iommu ioc_iommu_info[] __initdata = {
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
@@ -1861,8 +1854,6 @@ ioc_init(unsigned long hpa, void *handle)
 		"%s %d.%d HPA 0x%lx IOVA space %dMb at 0x%lx\n",
 		ioc->name, (ioc->rev >> 4) & 0xF, ioc->rev & 0xF,
 		hpa, ioc->iov_size >> 20, ioc->ibase);
-
-	return ioc;
 }
 
 
@@ -2041,22 +2032,21 @@ sba_map_ioc_to_node(struct ioc *ioc, acpi_handle handle)
 #define sba_map_ioc_to_node(ioc, handle)
 #endif
 
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
@@ -2077,13 +2067,13 @@ acpi_sba_ioc_add(struct acpi_device *device,
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
@@ -2091,9 +2081,26 @@ static const struct acpi_device_id hp_ioc_iommu_device_ids[] = {
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
@@ -2128,9 +2135,12 @@ sba_init(void)
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
-- 
1.9.1

