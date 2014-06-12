Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbaFLQfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaFLQfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:35:51 -0400
Subject: [RESEND PATCH] iommu/intel: Exclude devices using RMRRs from IOMMU
 API domains
From: Alex Williamson <alex.williamson@redhat.com>
To: iommu@lists.linux-foundation.org, dwmw2@infradead.org
Cc: chegu_vinod@hp.com, linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 10:35:23 -0600
Message-ID: <20140612163402.9108.50209.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user of the IOMMU API domain expects to have full control of
the IOVA space for the domain.  RMRRs are fundamentally incompatible
with that idea.  We can neither map the RMRR into the IOMMU API
domain, nor can we guarantee that the device won't continue DMA with
the area described by the RMRR as part of the new domain.  Therefore
we must prevent such devices from being used by the IOMMU API.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

I didn't see any actionable items from the last posting of this, so
re-posting unchanged.

 drivers/iommu/intel-iommu.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c4f11c0..41db805 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4171,6 +4171,21 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	int addr_width;
 	u8 bus, devfn;
 
+	/*
+	 * With IOMMU API domains we don't have the freedom to insert RMRR
+	 * entries into the domain mapping, the IOMMU API user expects full
+	 * control of the IOVA space of the device.  We also have no ability
+	 * to shutdown whatever back channel operations occur through the
+	 * RMRR.  Therefore our only option is to prevent devices making use
+	 * of RMRRs from being used by the IOMMU API.  As usual we exempt
+	 * USB devices since their RMRR support is largely historical.
+	 */
+	if (device_has_rmrr(dev) && (!dev_is_pci(dev) ||
+	    (to_pci_dev(dev)->class >> 8) != PCI_CLASS_SERIAL_USB)) {
+		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platform RMRR requirement.  Contact your platform vendor.\n");
+		return -EPERM;
+	}
+
 	/* normally dev is not mapped */
 	if (unlikely(domain_context_mapped(dev))) {
 		struct dmar_domain *old_domain;

