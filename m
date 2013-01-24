Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3AXDch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:32:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3AXDcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:32:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>,
        Joerg Roedel <joro@8bytes.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 71/74] intel-iommu: Prevent devices with RMRRs from being placed into SI Domain
Date: Thu, 24 Jan 2013 01:27:23 -0200
Message-Id: <1358998046-613-72-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Mingarelli <thomas.mingarelli@hp.com>

commit ea2447f700cab264019b52e2b417d689e052dcfd upstream.

This patch is to prevent non-USB devices that have RMRRs associated with them from
being placed into the SI Domain during init. This fixes the issue where the RMRR info
for devices being placed in and out of the SI Domain gets lost.

Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
Tested-by: Shuah Khan <shuah.khan@hp.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/iommu/intel-iommu.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f3e77a5..92f5912 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2326,8 +2326,39 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 	return 0;
 }
 
+static bool device_has_rmrr(struct pci_dev *dev)
+{
+	struct dmar_rmrr_unit *rmrr;
+	int i;
+
+	for_each_rmrr_units(rmrr) {
+		for (i = 0; i < rmrr->devices_cnt; i++) {
+			/*
+			 * Return TRUE if this RMRR contains the device that
+			 * is passed in.
+			 */
+			if (rmrr->devices[i] == dev)
+				return true;
+		}
+	}
+	return false;
+}
+
 static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
 {
+
+	/*
+	 * We want to prevent any device associated with an RMRR from
+	 * getting placed into the SI Domain. This is done because
+	 * problems exist when devices are moved in and out of domains
+	 * and their respective RMRR info is lost. We exempt USB devices
+	 * from this process due to their usage of RMRRs that are known
+	 * to not be needed after BIOS hand-off to OS.
+	 */
+	if (device_has_rmrr(pdev) &&
+	    (pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
+		return 0;
+
 	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
 		return 1;
 
-- 
1.7.9.5

