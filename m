Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3BCO7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:59:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34642 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab3BCO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:29 -0500
Message-Id: <20130203144654.720224592@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tom Mingarelli <thomas.mingarelli@hp.com>,
        Shuah Khan <shuah.khan@hp.com>, Donald Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 121/128] intel-iommu: Prevent devices with RMRRs from being placed into SI
 Domain
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d4a4cd4..ca3ee46 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2320,8 +2320,39 @@ static int domain_add_dev_info(struct dmar_domain *domain,
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
 


