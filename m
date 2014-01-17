Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaAQQAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:00:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAQQAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:00:38 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 2/9] ahci: Use pci_enable_msi_range()
Date: Fri, 17 Jan 2014 17:02:16 +0100
Message-Id: <761bec2771db60ca5cd86dfbf63ff0f2dbc43031.1389904166.git.agordeev@redhat.com>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/ahci.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index df24eef4..73ffd39 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1098,13 +1098,13 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 			 struct ahci_host_priv *hpriv)
 {
-	int rc, nvec;
+	int nvec;
 
 	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
 		goto intx;
 
-	rc = pci_msi_vec_count(pdev);
-	if (rc < 0)
+	nvec = pci_msi_vec_count(pdev);
+	if (nvec < 0)
 		goto intx;
 
 	/*
@@ -1112,21 +1112,19 @@ int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 	 * Message mode could be enforced. In this case assume that advantage
 	 * of multipe MSIs is negated and use single MSI mode instead.
 	 */
-	if (rc < n_ports)
+	if (nvec < n_ports)
 		goto single_msi;
 
-	nvec = rc;
-	rc = pci_enable_msi_block(pdev, nvec);
-	if (rc < 0)
-		goto intx;
-	else if (rc > 0)
+	nvec = pci_enable_msi_range(pdev, nvec, nvec);
+	if (nvec == -ENOSPC)
 		goto single_msi;
+	else if (nvec < 0)
+		goto intx;
 
 	return nvec;
 
 single_msi:
-	rc = pci_enable_msi(pdev);
-	if (rc)
+	if (pci_enable_msi(pdev))
 		goto intx;
 	return 1;
 
-- 
1.7.7.6

