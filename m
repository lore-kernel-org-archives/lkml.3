Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaIOT1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:27:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbaIOT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3.16 011/158] iommu/vt-d: Exclude devices using RMRRs from IOMMU API domains
Date: Mon, 15 Sep 2014 12:24:10 -0700
Message-Id: <20140915192543.221375967@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   49 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 10 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2523,22 +2523,46 @@ static bool device_has_rmrr(struct devic
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
+static bool device_is_rmrr_locked(struct device *dev)
+{
+	if (!device_has_rmrr(dev))
+		return false;
+
+	if (dev_is_pci(dev)) {
+		struct pci_dev *pdev = to_pci_dev(dev);
+
+		if ((pdev->class >> 8) == PCI_CLASS_SERIAL_USB)
+			return false;
+	}
+
+	return true;
+}
+
 static int iommu_should_identity_map(struct device *dev, int startup)
 {
 
 	if (dev_is_pci(dev)) {
 		struct pci_dev *pdev = to_pci_dev(dev);
 
-		/*
-		 * We want to prevent any device associated with an RMRR from
-		 * getting placed into the SI Domain. This is done because
-		 * problems exist when devices are moved in and out of domains
-		 * and their respective RMRR info is lost. We exempt USB devices
-		 * from this process due to their usage of RMRRs that are known
-		 * to not be needed after BIOS hand-off to OS.
-		 */
-		if (device_has_rmrr(dev) &&
-		    (pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
+		if (device_is_rmrr_locked(dev))
 			return 0;
 
 		if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
@@ -4202,6 +4226,11 @@ static int intel_iommu_attach_device(str
 	int addr_width;
 	u8 bus, devfn;
 
+	if (device_is_rmrr_locked(dev)) {
+		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platform RMRR requirement.  Contact your platform vendor.\n");
+		return -EPERM;
+	}
+
 	/* normally dev is not mapped */
 	if (unlikely(domain_context_mapped(dev))) {
 		struct dmar_domain *old_domain;


