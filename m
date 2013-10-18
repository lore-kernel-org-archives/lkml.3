Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3JSGth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:49:37 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:14142 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251Ab3JSGtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:49:36 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 14/29] ipr: Make use of pcim_enable_msi/msix() interfaces
Date: Fri, 18 Oct 2013 19:12:14 +0200
Message-Id: <1d960601fcd3c0a6366ad84bbba507583a80027d.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/ipr.c |   47 ++++++++++++++++++-----------------------------
 1 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fb57e21..d7c94d5 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9245,47 +9245,36 @@ ipr_get_chip_info(const struct pci_device_id *dev_id)
 static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct msix_entry entries[IPR_MAX_MSIX_VECTORS];
-	int i, err, vectors;
+	int i, vectors;
 
-	for (i = 0; i < ARRAY_SIZE(entries); ++i)
+	vectors = min_t(int, ARRAY_SIZE(entries), ipr_number_of_msix);
+	for (i = 0; i < vectors; ++i)
 		entries[i].entry = i;
 
-	vectors = ipr_number_of_msix;
+	vectors = pcim_enable_msix(ioa_cfg->pdev, entries, vectors);
+	if (vectors < 0)
+		return vectors;
 
-	while ((err = pci_enable_msix(ioa_cfg->pdev, entries, vectors)) > 0)
-			vectors = err;
+	for (i = 0; i < vectors; i++)
+		ioa_cfg->vectors_info[i].vec = entries[i].vector;
+	ioa_cfg->nvectors = vectors;
 
-	if (err < 0)
-		return err;
-
-	if (!err) {
-		for (i = 0; i < vectors; i++)
-			ioa_cfg->vectors_info[i].vec = entries[i].vector;
-		ioa_cfg->nvectors = vectors;
-	}
-
-	return err;
+	return 0;
 }
 
 static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 {
-	int i, err, vectors;
+	int i, vectors;
 
-	vectors = ipr_number_of_msix;
+	vectors = pcim_enable_msi(ioa_cfg->pdev, ipr_number_of_msix);
+	if (vectors < 0)
+		return vectors;
 
-	while ((err = pci_enable_msi_block(ioa_cfg->pdev, vectors)) > 0)
-			vectors = err;
+	for (i = 0; i < vectors; i++)
+		ioa_cfg->vectors_info[i].vec = ioa_cfg->pdev->irq + i;
+	ioa_cfg->nvectors = vectors;
 
-	if (err < 0)
-		return err;
-
-	if (!err) {
-		for (i = 0; i < vectors; i++)
-			ioa_cfg->vectors_info[i].vec = ioa_cfg->pdev->irq + i;
-		ioa_cfg->nvectors = vectors;
-	}
-
-	return err;
+	return 0;
 }
 
 static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
-- 
1.7.7.6

