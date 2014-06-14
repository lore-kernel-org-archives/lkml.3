Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaFNPSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:18:37 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44214 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbaFNPSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:18:35 -0400
Date: Sat, 14 Jun 2014 20:48:27 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>,
        GregKroah-Hartman@himangi-Dell, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: gadget: fsl_qe_udc: Introduce use of managed version of
 kzalloc
Message-ID: <20140614151827.GA2910@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, the unnecesary labels are removed and some labels are
renamed to preserve ordering.

The following Coccinelle semantic patch was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

@rem depends on prb@
identifier platform.removefn;
expression e;
@@
removefn(...) {
  <...
- kfree(e);
  ...>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
Not compile tested due to incompatible architecture.

 drivers/usb/gadget/fsl_qe_udc.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index ad54833..7324308 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2539,7 +2539,7 @@ static int qe_udc_probe(struct platform_device *ofdev)
 		goto err2;
 
 	/* create a buf for ZLP send, need to remain zeroed */
-	udc->nullbuf = kzalloc(256, GFP_KERNEL);
+	udc->nullbuf = devm_kzalloc(&ofdev->dev, 256, GFP_KERNEL);
 	if (udc->nullbuf == NULL) {
 		dev_err(udc->dev, "cannot alloc nullbuf\n");
 		ret = -ENOMEM;
@@ -2547,10 +2547,10 @@ static int qe_udc_probe(struct platform_device *ofdev)
 	}
 
 	/* buffer for data of get_status request */
-	udc->statusbuf = kzalloc(2, GFP_KERNEL);
+	udc->statusbuf = devm_kzalloc(&ofdev->dev, 2, GFP_KERNEL);
 	if (udc->statusbuf == NULL) {
 		ret = -ENOMEM;
-		goto err4;
+		goto err3;
 	}
 
 	udc->nullp = virt_to_phys((void *)udc->nullbuf);
@@ -2581,13 +2581,13 @@ static int qe_udc_probe(struct platform_device *ofdev)
 	if (ret) {
 		dev_err(udc->dev, "cannot request irq %d err %d\n",
 				udc->usb_irq, ret);
-		goto err5;
+		goto err4;
 	}
 
 	ret = usb_add_gadget_udc_release(&ofdev->dev, &udc->gadget,
 			qe_udc_release);
 	if (ret)
-		goto err6;
+		goto err5;
 
 	platform_set_drvdata(ofdev, udc);
 	dev_info(udc->dev,
@@ -2595,9 +2595,9 @@ static int qe_udc_probe(struct platform_device *ofdev)
 			(udc->soc_type == PORT_QE) ? "QE" : "CPM");
 	return 0;
 
-err6:
-	free_irq(udc->usb_irq, udc);
 err5:
+	free_irq(udc->usb_irq, udc);
+err4:
 	irq_dispose_mapping(udc->usb_irq);
 err_noirq:
 	if (udc->nullmap) {
@@ -2610,9 +2610,6 @@ err_noirq:
 			udc->nullp, 256,
 				DMA_TO_DEVICE);
 	}
-	kfree(udc->statusbuf);
-err4:
-	kfree(udc->nullbuf);
 err3:
 	ep = &udc->eps[0];
 	cpm_muram_free(cpm_muram_offset(ep->rxbase));
@@ -2660,8 +2657,6 @@ static int qe_udc_remove(struct platform_device *ofdev)
 			udc->nullp, 256,
 				DMA_TO_DEVICE);
 	}
-	kfree(udc->statusbuf);
-	kfree(udc->nullbuf);
 
 	ep = &udc->eps[0];
 	cpm_muram_free(cpm_muram_offset(ep->rxbase));
-- 
1.9.1

