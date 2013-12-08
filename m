Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab3LHWyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 17:54:45 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44919 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760024Ab3LHWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 17:54:38 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
Date: Mon,  9 Dec 2013 02:53:45 +0400
Message-Id: <1386543229-1542-6-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-dts implementation supply required DMA channel numbers as
IORESOURCE_DMA. However, there is was no way to get them from
device tree.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/devicetree/bindings/mmc/pxa-mmc.txt |  2 +
 arch/arm/boot/dts/pxa27x.dtsi                     |  4 ++
 drivers/mmc/host/pxamci.c                         | 50 ++++++++++++++++++-----
 3 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/pxa-mmc.txt b/Documentation/devicetree/bindings/mmc/pxa-mmc.txt
index b7025de..27447ec 100644
--- a/Documentation/devicetree/bindings/mmc/pxa-mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/pxa-mmc.txt
@@ -5,6 +5,7 @@ Driver bindings for the PXA MCI (MMC/SDIO) interfaces
 Required properties:
 - compatible: Should be "marvell,pxa-mmc".
 - vmmc-supply: A regulator for VMMC
+- marvell,dma-channels: 2 PXA DMA channels [0] for RX, [1] for TX
 
 Optional properties:
 - marvell,detect-delay-ms: sets the detection delay timeout in ms.
@@ -19,6 +20,7 @@ mmc0: mmc@41100000 {
 	compatible = "marvell,pxa-mmc";
 	reg = <0x41100000 0x1000>;
 	interrupts = <23>;
+	marvell,dma-channels = <21 22>;
 	cd-gpios = <&gpio 23 0>;
 	wp-gpios = <&gpio 24 0>;
 };
diff --git a/arch/arm/boot/dts/pxa27x.dtsi b/arch/arm/boot/dts/pxa27x.dtsi
index 44df554..3f97520 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -16,5 +16,9 @@
 			interrupts = <8>, <9>, <10>;
 			interrupt-names = "gpio0", "gpio1", "gpio_mux";
 		};
+
+		mmc@41100000 {
+			marvell,dma-channels = <21 22>;
+		};
 	};
 };
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 32fe113..8c7a110 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -613,11 +613,37 @@ static int pxamci_of_init(struct platform_device *pdev)
 
         return 0;
 }
+
+static int pxamci_of_init_dma(struct platform_device *pdev,
+		struct pxamci_host *host)
+{
+        struct device_node *np = pdev->dev.of_node;
+        u32 tmp;
+	int ret;
+
+	ret = of_property_read_u32_index(np, "marvell,dma-channels", 0, &tmp);
+	if (ret < 0)
+		return ret;
+	host->dma_drcmrrx = tmp;
+
+	ret = of_property_read_u32_index(np, "marvell,dma-channels", 1, &tmp);
+	if (ret < 0)
+		return ret;
+	host->dma_drcmrtx = tmp;
+
+	return 0;
+}
 #else
 static int pxamci_of_init(struct platform_device *pdev)
 {
         return 0;
 }
+
+static int pxamci_of_init_dma(struct platform_device *pdev,
+		struct pxamci_host *host)
+{
+	return -ENODATA;
+}
 #endif
 
 static int pxamci_probe(struct platform_device *pdev)
@@ -741,19 +767,21 @@ static int pxamci_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mmc);
 
-	dmarx = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!dmarx) {
-		ret = -ENXIO;
-		goto out;
-	}
-	host->dma_drcmrrx = dmarx->start;
+	if (pxamci_of_init_dma(pdev, host) < 0) {
+		dmarx = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+		if (!dmarx) {
+			ret = -ENXIO;
+			goto out;
+		}
+		host->dma_drcmrrx = dmarx->start;
 
-	dmatx = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!dmatx) {
-		ret = -ENXIO;
-		goto out;
+		dmatx = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+		if (!dmatx) {
+			ret = -ENXIO;
+			goto out;
+		}
+		host->dma_drcmrtx = dmatx->start;
 	}
-	host->dma_drcmrtx = dmatx->start;
 
 	if (host->pdata) {
 		gpio_cd = host->pdata->gpio_card_detect;
-- 
1.8.4.3

