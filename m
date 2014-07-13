Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaGMRbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 13:31:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63528 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaGMRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 13:30:58 -0400
Date: Sun, 13 Jul 2014 23:00:51 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: ambakmi - Use managed interfaces
Message-ID: <20140713173051.GA4299@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of managed interfaces like devm_clk_get,
devm_kalloc etc. devm_ioremap_resource is used instead of
amba_request_regions and devm_ioremap. It also does away with the functions
to free the allocated memory in probe and remove functions. Also, some
labels in the probe function are removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/input/serio/ambakmi.c | 44 ++++++++++---------------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index 8b748d9..405a175 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 
 #include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
 
 #define KMI_BASE	(kmi->base)
@@ -112,19 +113,10 @@ static int amba_kmi_probe(struct amba_device *dev,
 {
 	struct amba_kmi_port *kmi;
 	struct serio *io;
-	int ret;
-
-	ret = amba_request_regions(dev, NULL);
-	if (ret)
-		return ret;
-
-	kmi = kzalloc(sizeof(struct amba_kmi_port), GFP_KERNEL);
-	io = kzalloc(sizeof(struct serio), GFP_KERNEL);
-	if (!kmi || !io) {
-		ret = -ENOMEM;
-		goto out;
-	}
 
+	io = devm_kzalloc(&dev->dev, sizeof(struct serio), GFP_KERNEL);
+	if (!io)
+		return -ENOMEM;
 
 	io->id.type	= SERIO_8042;
 	io->write	= amba_kmi_write;
@@ -135,32 +127,20 @@ static int amba_kmi_probe(struct amba_device *dev,
 	io->port_data	= kmi;
 	io->dev.parent	= &dev->dev;
 
+	kmi->base	= devm_ioremap_resource(&dev->dev, &dev->res);
+	if (IS_ERR(kmi->base))
+		return PTR_ERR(kmi->base);
 	kmi->io		= io;
-	kmi->base	= ioremap(dev->res.start, resource_size(&dev->res));
-	if (!kmi->base) {
-		ret = -ENOMEM;
-		goto out;
-	}
 
-	kmi->clk = clk_get(&dev->dev, "KMIREFCLK");
-	if (IS_ERR(kmi->clk)) {
-		ret = PTR_ERR(kmi->clk);
-		goto unmap;
-	}
+	kmi->clk = devm_clk_get(&dev->dev, "KMIREFCLK");
+	if (IS_ERR(kmi->clk))
+		return PTR_ERR(kmi->clk);
 
 	kmi->irq = dev->irq[0];
 	amba_set_drvdata(dev, kmi);
 
 	serio_register_port(kmi->io);
 	return 0;
-
- unmap:
-	iounmap(kmi->base);
- out:
-	kfree(kmi);
-	kfree(io);
-	amba_release_regions(dev);
-	return ret;
 }
 
 static int amba_kmi_remove(struct amba_device *dev)
@@ -168,10 +148,6 @@ static int amba_kmi_remove(struct amba_device *dev)
 	struct amba_kmi_port *kmi = amba_get_drvdata(dev);
 
 	serio_unregister_port(kmi->io);
-	clk_put(kmi->clk);
-	iounmap(kmi->base);
-	kfree(kmi);
-	amba_release_regions(dev);
 	return 0;
 }
 
-- 
1.9.1

