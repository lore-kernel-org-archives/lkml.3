Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3EMGFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:05:00 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:54730 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3EMGE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:04:59 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 14:04:58 +0800
Message-ID: <CAPgLHd_PuG1en-C_55U5ogBdmPi4KNmwWn+jLLwxh1+tr=aiFQ@mail.gmail.com>
Subject: [PATCH] staging: slicoss: fix error return code in slic_entry_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, devendra.aaru@gmail.com, peterhuewe@gmx.de,
        cruzjbishop@gmail.com, wfp5p@virginia.edu
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/slicoss/slicoss.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index e4b8277..869dcd3 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3651,17 +3651,20 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 
 	if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
-		if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+		err = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64));
+		if (err) {
 			dev_err(&pcidev->dev, "unable to obtain 64-bit DMA for "
 					"consistent allocations\n");
 			goto err_out_disable_pci;
 		}
-	} else if (pci_set_dma_mask(pcidev, DMA_BIT_MASK(32))) {
+	} else {
+		err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pcidev->dev, "no usable DMA configuration\n");
+			goto err_out_disable_pci;
+		}
 		pci_using_dac = 0;
 		pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
-	} else {
-		dev_err(&pcidev->dev, "no usable DMA configuration\n");
-		goto err_out_disable_pci;
 	}
 
 	err = pci_request_regions(pcidev, DRV_NAME);
@@ -3696,6 +3699,7 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 	if (!memmapped_ioaddr) {
 		dev_err(&pcidev->dev, "cannot remap MMIO region %lx @ %lx\n",
 			mmio_len, mmio_start);
+		err = -ENOMEM;
 		goto err_out_free_netdev;
 	}
 
@@ -3706,8 +3710,8 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 	slic_init_adapter(netdev,
 			  pcidev, pci_tbl_entry, memmapped_ioaddr, cards_found);
 
-	status = slic_card_locate(adapter);
-	if (status) {
+	err = slic_card_locate(adapter);
+	if (err) {
 		dev_err(&pcidev->dev, "cannot locate card\n");
 		goto err_out_free_mmio_region;
 	}

