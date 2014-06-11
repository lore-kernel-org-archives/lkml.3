Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbaFKSie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:38:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36119 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbaFKSib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:38:31 -0400
Date: Thu, 12 Jun 2014 00:08:23 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Andersson <jan@gaisler.com>
Cc: Andreas Larsson <andreas@gaisler.com>, julia.lawall@lip6.fr
Subject: [PATCH v3] usb: host: uhci-grlib.c : use devm_ functions
Message-ID: <20140611183823.GA10519@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various devm_ functions allocate memory that is released when a
driver detaches. This patch uses devm_ioremap_resource for data
that is allocated in the probe function of a platform device and
is only freed in the remove function. The corresponding free functions
are removed and two labels are done away with. Also, linux/device.h
is added to make sure the devm_*() routine declarations are
unambiguously available.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
Not compile tested due to incompatible architecture.
v3: pass correct arguments to devm_ioremap_resource

 drivers/usb/host/uhci-grlib.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/host/uhci-grlib.c b/drivers/usb/host/uhci-grlib.c
index ab25dc3..05f57ff 100644
--- a/drivers/usb/host/uhci-grlib.c
+++ b/drivers/usb/host/uhci-grlib.c
@@ -17,6 +17,7 @@
  * (C) Copyright 2004-2007 Alan Stern, stern@rowland.harvard.edu
  */
 
+#include <linux/device.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
@@ -113,24 +114,17 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
 	hcd->rsrc_start = res.start;
 	hcd->rsrc_len = resource_size(&res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
-		rv = -EBUSY;
-		goto err_rmr;
-	}
-
 	irq = irq_of_parse_and_map(dn, 0);
 	if (irq == NO_IRQ) {
 		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
 		rv = -EBUSY;
-		goto err_irq;
+		goto err_usb;
 	}
 
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		printk(KERN_ERR "%s: ioremap failed\n", __FILE__);
-		rv = -ENOMEM;
-		goto err_ioremap;
+	hcd->regs = devm_ioremap_resource(&op->dev, &res);
+	if (IS_ERR(hcd->regs)) {
+		rv = PTR_ERR(hcd->regs);
+		goto err_irq;
 	}
 
 	uhci = hcd_to_uhci(hcd);
@@ -139,18 +133,14 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
 
 	rv = usb_add_hcd(hcd, irq, 0);
 	if (rv)
-		goto err_uhci;
+		goto err_irq;
 
 	device_wakeup_enable(hcd->self.controller);
 	return 0;
 
-err_uhci:
-	iounmap(hcd->regs);
-err_ioremap:
-	irq_dispose_mapping(irq);
 err_irq:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err_rmr:
+	irq_dispose_mapping(irq);
+err_usb:
 	usb_put_hcd(hcd);
 
 	return rv;
@@ -164,10 +154,7 @@ static int uhci_hcd_grlib_remove(struct platform_device *op)
 
 	usb_remove_hcd(hcd);
 
-	iounmap(hcd->regs);
 	irq_dispose_mapping(hcd->irq);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-
 	usb_put_hcd(hcd);
 
 	return 0;
-- 
1.9.1

