Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab3ASB0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:26:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:56927 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab3ASBUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:20:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Mingarelli <thomas.mingarelli@hp.com>,
        Shuah Khan <shuah.khan@hp.com>, Donald Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, CAI Qian <caiqian@redhat.com>
Subject: [ 11/21] intel-iommu: Prevent devices with RMRRs from being placed into SI Domain
Date: Fri, 18 Jan 2013 17:19:29 -0800
Message-Id: <20130119010713.310424966@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010710.897187774@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2321,8 +2321,39 @@ static int domain_add_dev_info(struct dm
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
 


