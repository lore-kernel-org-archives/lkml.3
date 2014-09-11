Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaIKNKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:10:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbaIKNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Woodhouse" <dwmw2@infradead.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "Joerg Roedel" <jroedel@suse.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.365698224@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 025/131] iommu/vt-d: Exclude devices using RMRRs from
 IOMMU API domains
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit c875d2c1b8083cd627ea0463e20bf22c2d7421ee upstream.

The user of the IOMMU API domain expects to have full control of
the IOVA space for the domain.  RMRRs are fundamentally incompatible
with that idea.  We can neither map the RMRR into the IOMMU API
domain, nor can we guarantee that the device won't continue DMA with
the area described by the RMRR as part of the new domain.  Therefore
we must prevent such devices from being used by the IOMMU API.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
[bwh: Backported to 3.2: driver only operates on PCI devices]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2318,19 +2318,34 @@ static bool device_has_rmrr(struct pci_d
 	return false;
 }
 
+/*
+ * There are a couple cases where we need to restrict the functionality of
+ * devices associated with RMRRs.  The first is when evaluating a device for
+ * identity mapping because problems exist when devices are moved in and out
+ * of domains and their respective RMRR information is lost.  This means that
+ * a device with associated RMRRs will never be in a "passthrough" domain.
+ * The second is use of the device through the IOMMU API.  This interface
+ * expects to have full control of the IOVA space for the device.  We cannot
+ * satisfy both the requirement that RMRR access is maintained and have an
+ * unencumbered IOVA space.  We also have no ability to quiesce the device's
+ * use of the RMRR space or even inform the IOMMU API user of the restriction.
+ * We therefore prevent devices associated with an RMRR from participating in
+ * the IOMMU API, which eliminates them from device assignment.
+ *
+ * In both cases we assume that PCI USB devices with RMRRs have them largely
+ * for historical reasons and that the RMRR space is not actively used post
+ * boot.  This exclusion may change if vendors begin to abuse it.
+ */
+static bool device_is_rmrr_locked(struct pci_dev *pdev)
+{
+	return device_has_rmrr(pdev) &&
+		(pdev->class >> 8) != PCI_CLASS_SERIAL_USB;
+}
+
 static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
 {
 
-	/*
-	 * We want to prevent any device associated with an RMRR from
-	 * getting placed into the SI Domain. This is done because
-	 * problems exist when devices are moved in and out of domains
-	 * and their respective RMRR info is lost. We exempt USB devices
-	 * from this process due to their usage of RMRRs that are known
-	 * to not be needed after BIOS hand-off to OS.
-	 */
-	if (device_has_rmrr(pdev) &&
-	    (pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
+	if (device_is_rmrr_locked(pdev))
 		return 0;
 
 	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
@@ -3981,6 +3996,11 @@ static int intel_iommu_attach_device(str
 	struct intel_iommu *iommu;
 	int addr_width;
 
+	if (device_is_rmrr_locked(pdev)) {
+		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platform RMRR requirement.  Contact your platform vendor.\n");
+		return -EPERM;
+	}
+
 	/* normally pdev is not mapped */
 	if (unlikely(domain_context_mapped(pdev))) {
 		struct dmar_domain *old_domain;

