Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaFFKm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:42:28 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:59056 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaFFKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:42:23 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, pebolle@tiscali.nl, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, horms@verge.net.au, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.carpenter@oracle.com
Date: Fri, 06 Jun 2014 19:44:26 +0900
Message-Id: <20140606104426.4423.54602.sendpatchset@w520>
In-Reply-To: <20140606104408.4423.36098.sendpatchset@w520>
References: <20140606104408.4423.36098.sendpatchset@w520>
Subject: [PATCH v3 02/05] staging: emxx_udc: I/O memory and IRQ resource support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Adjust the emxx_udc driver to make use of the standard
driver model to pass I/O memory and IRQ as resources
instead of hard coding those things in the driver.

Needs more work - the VBUS signal is yet not handled.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 Changes since V2:
 - None

 Changes since V1:
 - None

 drivers/staging/emxx_udc/emxx_udc.c |   57 +++++++++++------------------------
 drivers/staging/emxx_udc/emxx_udc.h |    9 -----
 2 files changed, 18 insertions(+), 48 deletions(-)

--- 0002/drivers/staging/emxx_udc/emxx_udc.c
+++ work/drivers/staging/emxx_udc/emxx_udc.c	2014-05-22 16:20:02.000000000 +0900
@@ -3356,37 +3356,38 @@ static int nbu2ss_drv_probe(struct platf
 {
 	int	status = -ENODEV;
 	struct nbu2ss_udc	*udc;
+	struct resource *r;
+	int irq;
+	void __iomem *mmio_base;
 
 	udc = &udc_controller;
 	memset(udc, 0, sizeof(struct nbu2ss_udc));
 
 	platform_set_drvdata(pdev, udc);
 
-	/* IO Memory Region */
-	if (!request_mem_region(USB_BASE_ADDRESS, USB_BASE_SIZE
-				, driver_name)) {
+	/* require I/O memory and IRQ to be provided as resources */
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mmio_base = devm_request_and_ioremap(&pdev->dev, r);
+	if (IS_ERR(mmio_base)) {
+		dev_err(&pdev->dev, "failed to map I/O memory\n");
+		return PTR_ERR(mmio_base);
+	}
 
-		ERR("request_mem_region failed\n");
-		return -EBUSY;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get IRQ\n");
+		return irq;
 	}
+	status = devm_request_irq(&pdev->dev, irq, _nbu2ss_udc_irq,
+				  0, driver_name, udc);
 
 	/* IO Memory */
-	udc->p_regs = (PT_FC_REGS)ioremap(USB_BASE_ADDRESS, USB_BASE_SIZE);
-	if (!udc->p_regs) {
-		ERR("request_io_mem failed\n");
-		goto cleanup3;
-	}
+	udc->p_regs = (PT_FC_REGS)mmio_base;
 
 	/* USB Function Controller Interrupt */
-	status = request_irq(USB_UDC_IRQ_1,
-				_nbu2ss_udc_irq,
-				IRQF_DISABLED,
-				driver_name,
-				udc);
-
 	if (status != 0) {
 		ERR("request_irq(USB_UDC_IRQ_1) failed\n");
-		goto cleanup2;
+		goto cleanup1;
 	}
 
 	/* Driver Initialization */
@@ -3412,18 +3413,6 @@ static int nbu2ss_drv_probe(struct platf
 	return status;
 
 cleanup1:
-	/* Interrupt Handler - Release */
-	free_irq(USB_UDC_IRQ_1, udc);
-
-cleanup2:
-	/* IO Memory - Release */
-	if (udc->p_regs)
-		iounmap(udc->p_regs);
-
-cleanup3:
-	/* IO Memory Region - Release */
-	release_mem_region(USB_BASE_ADDRESS, USB_BASE_SIZE);
-
 	return status;
 }
 
@@ -3456,18 +3445,8 @@ static int __exit nbu2ss_drv_remove(stru
 	}
 
 	/* Interrupt Handler - Release */
-	free_irq(USB_UDC_IRQ_1, udc);
-
-	/* Interrupt Handler - Release */
 	free_irq(INT_VBUS, udc);
 
-	/* IO Memory - Release */
-	if (udc->p_regs)
-		iounmap(udc->p_regs);
-
-	/* IO Memory Region - Release */
-	release_mem_region(USB_BASE_ADDRESS, USB_BASE_SIZE);
-
 	return 0;
 }
 
--- 0002/drivers/staging/emxx_udc/emxx_udc.h
+++ work/drivers/staging/emxx_udc/emxx_udc.h	2014-05-22 16:20:02.000000000 +0900
@@ -47,20 +47,11 @@
 
 
 /*------------ Board dependence(Resource) */
-#define USB_BASE_ADDRESS	EMXX_USBS1_BASE
-#define USB_BASE_SIZE		0x2000
-
-#define USB_UDC_IRQ_0		INT_USBF0
-#define USB_UDC_IRQ_1		INT_USBF1
 #define	VBUS_VALUE		GPIO_VBUS
 
 /* below hacked up for staging integration */
 #define GPIO_VBUS 0 /* GPIO_P153 on KZM9D */
 #define INT_VBUS 0 /* IRQ for GPIO_P153 */
-#define INT_USBF0 158
-#define INT_USBF1 159
-#define EMXX_USBS0_BASE 0xe2700000
-#define EMXX_USBS1_BASE 0xe2800000
 
 /*------------ Board dependence(Wait) */
 
