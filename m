Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3FGCPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:15:20 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:38291 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3FGCPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:15:18 -0400
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 10:15:16 +0800
Message-ID: <CAPgLHd-SNBaS_T=FV3ov6-AtBPExMOOGP7dQ3RHG_FupUCcn0A@mail.gmail.com>
Subject: [PATCH] memstick: fix error return code in r592_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: maximlevitsky@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/memstick/host/r592.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 1b6e913..aa1dd24 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -761,8 +761,10 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto error3;
 
 	dev->mmio = pci_ioremap_bar(pdev, 0);
-	if (!dev->mmio)
+	if (!dev->mmio) {
+		error = -ENOMEM;
 		goto error4;
+	}
 
 	dev->irq = pdev->irq;
 	spin_lock_init(&dev->irq_lock);
@@ -789,12 +791,13 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		&dev->dummy_dma_page_physical_address);
 	r592_stop_dma(dev , 0);
 
-	if (request_irq(dev->irq, &r592_irq, IRQF_SHARED,
-			  DRV_NAME, dev))
+	error = request_irq(dev->irq, &r592_irq, IRQF_SHARED, DRV_NAME, dev);
+	if (error)
 		goto error6;
 
 	r592_update_card_detect(dev);
-	if (memstick_add_host(host))
+	error = memstick_add_host(host);
+	if (error)
 		goto error7;
 
 	message("driver successfully loaded");

