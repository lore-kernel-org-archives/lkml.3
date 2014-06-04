Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaFDLgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:36:10 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58889 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbaFDLgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:04 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 18/21] spi: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:18 +0400
Message-Id: <1401880402-30091-19-git-send-email-nyushchenko@dev.rtsoft.ru>
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
 drivers/spi/spi-bcm2835.c     |    2 +-
 drivers/spi/spi-mpc512x-psc.c |    9 ++++++++-
 drivers/spi/spi.c             |    8 +++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 6916745..93c0aec 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -337,7 +337,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 		goto out_master_put;
 	}
 
-	bs->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	bs->irq = devm_irq_of_parse_and_map(&pdev->dev, pdev->dev.of_node, 0);
 	if (bs->irq <= 0) {
 		dev_err(&pdev->dev, "could not get IRQ: %d\n", bs->irq);
 		err = bs->irq ? bs->irq : -ENODEV;
diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 577d23a..8256317 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -571,6 +571,7 @@ static int mpc512x_psc_spi_of_probe(struct platform_device *op)
 {
 	const u32 *regaddr_p;
 	u64 regaddr64, size64;
+	int irq;
 
 	regaddr_p = of_get_address(op->dev.of_node, 0, &size64, NULL);
 	if (!regaddr_p) {
@@ -579,8 +580,14 @@ static int mpc512x_psc_spi_of_probe(struct platform_device *op)
 	}
 	regaddr64 = of_translate_address(op->dev.of_node, regaddr_p);
 
+	irq = devm_irq_of_parse_and_map(&op->dev, op->dev.of_node, 0);
+	if (irq <= 0) {
+		dev_err(&op->dev, "could not locate irq\n");
+		return irq ? irq : -EINVAL;
+	}
+
 	return mpc512x_psc_spi_do_probe(&op->dev, (u32) regaddr64, (u32) size64,
-				irq_of_parse_and_map(op->dev.of_node, 0));
+				irq);
 }
 
 static int mpc512x_psc_spi_of_remove(struct platform_device *op)
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 939edf4..0baf00e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1306,7 +1306,13 @@ static void of_register_spi_devices(struct spi_master *master)
 		spi->max_speed_hz = value;
 
 		/* IRQ */
-		spi->irq = irq_of_parse_and_map(nc, 0);
+		spi->irq = devm_irq_of_parse_and_map(&master->dev, nc, 0);
+		if (spi->irq < 0) {
+			dev_err(&master->dev, "could not locate irq for %s (%d)\n",
+					nc->full_name, spi->irq);
+			spi_dev_put(spi);
+			continue;
+		}
 
 		/* Store a pointer to the node in the device structure */
 		of_node_get(nc);
-- 
1.7.10.4

