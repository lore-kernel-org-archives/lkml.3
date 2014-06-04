Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaFDLjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:39:55 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58912 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbaFDLgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:07 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 13/21] net/can: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:13 +0400
Message-Id: <1401880402-30091-14-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/net/can/grcan.c                    |   11 ++++-------
 drivers/net/can/mscan/mpc5xxx_can.c        |   11 ++++-------
 drivers/net/can/sja1000/sja1000_platform.c |    2 +-
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 3fd9fd9..695932f 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1687,10 +1687,10 @@ static int grcan_probe(struct platform_device *ofdev)
 		goto exit_error;
 	}
 
-	irq = irq_of_parse_and_map(np, GRCAN_IRQIX_IRQ);
-	if (!irq) {
+	irq = devm_irq_of_parse_and_map(&ofdev->dev, np, GRCAN_IRQIX_IRQ);
+	if (irq <= 0) {
 		dev_err(&ofdev->dev, "no irq found\n");
-		err = -ENODEV;
+		err = irq ? irq : -ENODEV;
 		goto exit_error;
 	}
 
@@ -1698,12 +1698,10 @@ static int grcan_probe(struct platform_device *ofdev)
 
 	err = grcan_setup_netdev(ofdev, base, irq, ambafreq, txbug);
 	if (err)
-		goto exit_dispose_irq;
+		goto exit_error;
 
 	return 0;
 
-exit_dispose_irq:
-	irq_dispose_mapping(irq);
 exit_error:
 	dev_err(&ofdev->dev,
 		"%s socket CAN driver initialization failed with error %d\n",
@@ -1718,7 +1716,6 @@ static int grcan_remove(struct platform_device *ofdev)
 
 	unregister_candev(dev); /* Will in turn call grcan_close */
 
-	irq_dispose_mapping(dev->irq);
 	netif_napi_del(&priv->napi);
 	free_candev(dev);
 
diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 4472529..b59ef67 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -306,16 +306,16 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 		return err;
 	}
 
-	irq = irq_of_parse_and_map(np, 0);
-	if (!irq) {
+	irq = devm_irq_of_parse_and_map(&ofdev->dev, np, 0);
+	if (irq <= 0) {
 		dev_err(&ofdev->dev, "no irq found\n");
-		err = -ENODEV;
+		err = irq ? irq : -ENODEV;
 		goto exit_unmap_mem;
 	}
 
 	dev = alloc_mscandev();
 	if (!dev)
-		goto exit_dispose_irq;
+		goto exit_unmap_mem;
 	platform_set_drvdata(ofdev, dev);
 	SET_NETDEV_DEV(dev, &ofdev->dev);
 
@@ -348,8 +348,6 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 exit_free_mscan:
 	free_candev(dev);
-exit_dispose_irq:
-	irq_dispose_mapping(irq);
 exit_unmap_mem:
 	iounmap(base);
 
@@ -370,7 +368,6 @@ static int mpc5xxx_can_remove(struct platform_device *ofdev)
 	if (data && data->put_clock)
 		data->put_clock(ofdev);
 	iounmap(priv->reg_base);
-	irq_dispose_mapping(dev->irq);
 	free_candev(dev);
 
 	return 0;
diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index 95a844a..36c8525 100644
--- a/drivers/net/can/sja1000/sja1000_platform.c
+++ b/drivers/net/can/sja1000/sja1000_platform.c
@@ -184,7 +184,7 @@ static int sp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	if (of)
-		irq = irq_of_parse_and_map(of, 0);
+		irq = devm_irq_of_parse_and_map(&pdev->dev, of, 0);
 	else
 		res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 
-- 
1.7.10.4

