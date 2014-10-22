Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaJVIy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:54:59 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64922 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaJVIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:54:56 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192e: from bus specific dma api to dma api
Date: Wed, 22 Oct 2014 14:24:46 +0530
Message-Id: <1413968086-15451-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we should be using DMA API rather than using bus specific DMA API.
converted the occurrence of pci_map_*() to dma_map_*(),
and at the same time used the dma_mapping_error().	  

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c | 12 ++++++------
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c   | 19 ++++++++++---------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index 552d943..d3a3ce2 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -1180,8 +1180,8 @@ void  rtl8192_tx_fill_desc(struct net_device *dev, struct tx_desc *pdesc,
 			   struct cb_desc *cb_desc, struct sk_buff *skb)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
-	dma_addr_t mapping = pci_map_single(priv->pdev, skb->data, skb->len,
-			 PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&priv->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 	struct tx_fwinfo_8190pci *pTxFwInfo = NULL;
 
 	pTxFwInfo = (struct tx_fwinfo_8190pci *)skb->data;
@@ -1193,7 +1193,7 @@ void  rtl8192_tx_fill_desc(struct net_device *dev, struct tx_desc *pdesc,
 						pTxFwInfo->TxRate,
 						cb_desc);
 
-	if (pci_dma_mapping_error(priv->pdev, mapping))
+	if (dma_mapping_error(&priv->pdev->dev, mapping))
 		RT_TRACE(COMP_ERR, "DMA Mapping error\n");
 	if (cb_desc->bAMPDUEnable) {
 		pTxFwInfo->AllowAggregation = 1;
@@ -1290,10 +1290,10 @@ void  rtl8192_tx_fill_cmd_desc(struct net_device *dev,
 			       struct cb_desc *cb_desc, struct sk_buff *skb)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
-	dma_addr_t mapping = pci_map_single(priv->pdev, skb->data, skb->len,
-			 PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&priv->pdev->dev, skb->data,
+					    skb->len, PCI_DMA_TODEVICE);
 
-	if (pci_dma_mapping_error(priv->pdev, mapping))
+	if (dma_mapping_error(&priv->pdev->dev, mapping))
 		RT_TRACE(COMP_ERR, "DMA Mapping error\n");
 	memset(entry, 0, 12);
 	entry->LINIP = cb_desc->bLastIniPkt;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 5615c80..da8fa29 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2097,11 +2097,11 @@ static short rtl8192_alloc_rx_desc_ring(struct net_device *dev)
 			skb->dev = dev;
 			priv->rx_buf[rx_queue_idx][i] = skb;
 			mapping = (dma_addr_t *)skb->cb;
-			*mapping = pci_map_single(priv->pdev,
+			*mapping = dma_map_single(&priv->pdev->dev,
 						  skb_tail_pointer_rsl(skb),
 						  priv->rxbuffersize,
-						  PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(priv->pdev, *mapping)) {
+						  DMA_FROM_DEVICE);
+			if (dma_mapping_error(&priv->pdev->dev, *mapping)) {
 				dev_kfree_skb_any(skb);
 				return -1;
 			}
@@ -2393,12 +2393,13 @@ static void rtl8192_rx_normal(struct net_device *dev)
 
 			priv->rx_buf[rx_queue_idx][priv->rx_idx[rx_queue_idx]] =
 									 skb;
-			*((dma_addr_t *) skb->cb) = pci_map_single(priv->pdev,
-						    skb_tail_pointer_rsl(skb),
-						    priv->rxbuffersize,
-						    PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(priv->pdev,
-						  *((dma_addr_t *)skb->cb))) {
+			*((dma_addr_t *)skb->cb) =
+				dma_map_single(&priv->pdev->dev,
+					       skb_tail_pointer_rsl(skb),
+					       priv->rxbuffersize,
+					       DMA_FROM_DEVICE);
+			if (dma_mapping_error(&priv->pdev->dev,
+					      *((dma_addr_t *)skb->cb))) {
 				dev_kfree_skb_any(skb);
 				return;
 			}
-- 
1.8.1.2

