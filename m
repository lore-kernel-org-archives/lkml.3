Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaKHQUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 11:20:00 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39524 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaKHQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 11:19:59 -0500
From: Tina Johnson <tinajohnson.1234@gmail.com>
To: chas@cmf.nrl.navy.mil
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr,
        Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH] drivers: atm: eni: Add pci_dma_mapping_error() call
Date: Sat,  8 Nov 2014 21:48:02 +0530
Message-Id: <1415463482-8013-1-git-send-email-tinajohnson.1234@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a pci_dma_mapping_error() call to check for mapping errors before
further using the dma handle. Unchecked dma handles were found using
Coccinelle:

@rule1@
expression e1;
identifier x;
@@

*x = pci_map_single(...);
 ... when != pci_dma_mapping_error(e1,x)

Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/atm/eni.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index d65975a..6450a36 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -356,6 +356,8 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 	if (skb) {
 		paddr = pci_map_single(eni_dev->pci_dev,skb->data,skb->len,
 		    PCI_DMA_FROMDEVICE);
+		if (pci_dma_mapping_error(eni_dev->pci_dev, paddr))
+			goto trouble;
 		ENI_PRV_PADDR(skb) = paddr;
 		if (paddr & 3)
 			printk(KERN_CRIT DEV_LABEL "(itf %d): VCI %d has "
-- 
1.7.10.4

