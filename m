Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaGCTit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:38:49 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54137 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaGCTis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:38:48 -0400
Date: Fri, 4 Jul 2014 01:08:40 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: lirc: Introduce the use of managed interfaces
Message-ID: <20140703193840.GA4358@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of managed interfaces like
devm_request_mem_region and devm_request_irq and does away with the
calls to free the allocated memory in the probe and remove functions.
The remove function is no longer required and is removed completely.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/media/lirc/lirc_serial.c | 37 ++++++--------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index efe561c..bae0d46 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -782,7 +782,7 @@ static int lirc_serial_probe(struct platform_device *dev)
 {
 	int i, nlow, nhigh, result;
 
-	result = request_irq(irq, lirc_irq_handler,
+	result = devm_request_irq(&dev->dev, irq, lirc_irq_handler,
 			     (share_irq ? IRQF_SHARED : 0),
 			     LIRC_DRIVER_NAME, (void *)&hardware);
 	if (result < 0) {
@@ -800,22 +800,22 @@ static int lirc_serial_probe(struct platform_device *dev)
 	 * for the NSLU2 it's done in boot code.
 	 */
 	if (((iommap != 0)
-	     && (request_mem_region(iommap, 8 << ioshift,
-				    LIRC_DRIVER_NAME) == NULL))
+	     && (devm_request_mem_region(&dev->dev, iommap, 8 << ioshift,
+					 LIRC_DRIVER_NAME) == NULL))
 	   || ((iommap == 0)
-	       && (request_region(io, 8, LIRC_DRIVER_NAME) == NULL))) {
+	       && (devm_request_region(&dev->dev, io, 8,
+				       LIRC_DRIVER_NAME) == NULL))) {
 		dev_err(&dev->dev, "port %04x already in use\n", io);
 		dev_warn(&dev->dev, "use 'setserial /dev/ttySX uart none'\n");
 		dev_warn(&dev->dev,
 			 "or compile the serial port driver as module and\n");
 		dev_warn(&dev->dev, "make sure this module is loaded first\n");
-		result = -EBUSY;
-		goto exit_free_irq;
+		return -EBUSY;
 	}
 
 	result = hardware_init_port();
 	if (result < 0)
-		goto exit_release_region;
+		return result;
 
 	/* Initialize pulse/space widths */
 	init_timing_params(duty_cycle, freq);
@@ -847,28 +847,6 @@ static int lirc_serial_probe(struct platform_device *dev)
 
 	dprintk("Interrupt %d, port %04x obtained\n", irq, io);
 	return 0;
-
-exit_release_region:
-	if (iommap != 0)
-		release_mem_region(iommap, 8 << ioshift);
-	else
-		release_region(io, 8);
-exit_free_irq:
-	free_irq(irq, (void *)&hardware);
-
-	return result;
-}
-
-static int lirc_serial_remove(struct platform_device *dev)
-{
-	free_irq(irq, (void *)&hardware);
-
-	if (iommap != 0)
-		release_mem_region(iommap, 8 << ioshift);
-	else
-		release_region(io, 8);
-
-	return 0;
 }
 
 static int set_use_inc(void *data)
@@ -1081,7 +1059,6 @@ static int lirc_serial_resume(struct platform_device *dev)
 
 static struct platform_driver lirc_serial_driver = {
 	.probe		= lirc_serial_probe,
-	.remove		= lirc_serial_remove,
 	.suspend	= lirc_serial_suspend,
 	.resume		= lirc_serial_resume,
 	.driver		= {
-- 
1.9.1

