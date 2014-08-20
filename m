Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaHTLxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:53:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58993 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/104] DMA-API: net: intel/igb: fix 32-bit DMA mask handling
Date: Wed, 20 Aug 2014 13:43:45 +0200
Message-Id: <28c6b6f51a04bda3b4d8c9e144dcaf8a0275e737.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dc4ff9bb7534ebd153f8441ec0e9190964ad8944 upstream.

The fallback to 32-bit DMA mask is rather odd:
	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
	if (!err) {
		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
		if (!err)
			pci_using_dac = 1;
	} else {
		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
		if (err) {
			err = dma_set_coherent_mask(&pdev->dev,
						    DMA_BIT_MASK(32));
			if (err) {
				dev_err(&pdev->dev,
					"No usable DMA configuration, aborting\n");
				goto err_dma;
			}
		}
	}
This means we only set the coherent DMA mask in the fallback path if
the DMA mask set failed, which is silly.  This fixes it to set the
coherent DMA mask only if dma_set_mask() succeeded, and to error out
if either fails.

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 76e43c417a31..318017d7dada 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2034,21 +2034,15 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return err;
 
 	pci_using_dac = 0;
-	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (!err) {
-		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-		if (!err)
-			pci_using_dac = 1;
+		pci_using_dac = 1;
 	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
-			err = dma_set_coherent_mask(&pdev->dev,
-						    DMA_BIT_MASK(32));
-			if (err) {
-				dev_err(&pdev->dev,
-					"No usable DMA configuration, aborting\n");
-				goto err_dma;
-			}
+			dev_err(&pdev->dev,
+				"No usable DMA configuration, aborting\n");
+			goto err_dma;
 		}
 	}
 
-- 
2.0.4

