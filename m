Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaFZKJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:09:20 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44952 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbaFZKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:09:03 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, linux@arm.linux.org.uk,
        daniel.thompson@linaro.org, trblinux@gmail.com
Subject: [PATCH V2 2/2] serial: amba-pl010: Use devres APIs
Date: Thu, 26 Jun 2014 15:35:36 +0530
Message-Id: <1403777136-20202-3-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403777136-20202-1-git-send-email-tushar.b@samsung.com>
References: <1403777136-20202-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrating to use devres managed APIs devm_kzalloc, devm_ioremap and
devm_clk_get.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
---
Changes for V2:
* Added Reviewed-by tag
* Removed redundant asm/io.h

 drivers/tty/serial/amba-pl010.c |   48 +++++++++++++--------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 971af1e..2064d31 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -46,8 +46,7 @@
 #include <linux/amba/serial.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define UART_NR		8
 
@@ -688,28 +687,22 @@ static int pl010_probe(struct amba_device *dev, const struct amba_id *id)
 		if (amba_ports[i] == NULL)
 			break;
 
-	if (i == ARRAY_SIZE(amba_ports)) {
-		ret = -EBUSY;
-		goto out;
-	}
+	if (i == ARRAY_SIZE(amba_ports))
+		return -EBUSY;
 
-	uap = kzalloc(sizeof(struct uart_amba_port), GFP_KERNEL);
-	if (!uap) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	uap = devm_kzalloc(&dev->dev, sizeof(struct uart_amba_port),
+			   GFP_KERNEL);
+	if (!uap)
+		return -ENOMEM;
 
-	base = ioremap(dev->res.start, resource_size(&dev->res));
-	if (!base) {
-		ret = -ENOMEM;
-		goto free;
-	}
+	base = devm_ioremap(&dev->dev, dev->res.start,
+			    resource_size(&dev->res));
+	if (!base)
+		return -ENOMEM;
 
-	uap->clk = clk_get(&dev->dev, NULL);
-	if (IS_ERR(uap->clk)) {
-		ret = PTR_ERR(uap->clk);
-		goto unmap;
-	}
+	uap->clk = devm_clk_get(&dev->dev, NULL);
+	if (IS_ERR(uap->clk))
+		return PTR_ERR(uap->clk);
 
 	uap->port.dev = &dev->dev;
 	uap->port.mapbase = dev->res.start;
@@ -727,15 +720,9 @@ static int pl010_probe(struct amba_device *dev, const struct amba_id *id)
 
 	amba_set_drvdata(dev, uap);
 	ret = uart_add_one_port(&amba_reg, &uap->port);
-	if (ret) {
+	if (ret)
 		amba_ports[i] = NULL;
-		clk_put(uap->clk);
- unmap:
-		iounmap(base);
- free:
-		kfree(uap);
-	}
- out:
+
 	return ret;
 }
 
@@ -750,9 +737,6 @@ static int pl010_remove(struct amba_device *dev)
 		if (amba_ports[i] == uap)
 			amba_ports[i] = NULL;
 
-	iounmap(uap->port.membase);
-	clk_put(uap->clk);
-	kfree(uap);
 	return 0;
 }
 
-- 
1.7.9.5

