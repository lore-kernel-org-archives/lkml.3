Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab3HMJxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:53:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60106 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab3HMJw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:52:58 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>
CC: <kishon@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH 2/2] usb: musb: pass on all the required resources from glue to musb core
Date: Tue, 13 Aug 2013 15:22:48 +0530
Message-ID: <1376387568-21253-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376387568-21253-1-git-send-email-kishon@ti.com>
References: <1376387568-21253-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

musb glue have to pass either 2 resources or 3 resources to the musb
core (musb core irq number, dma irq number and a memory
resource). So allocated *resource* for musb core in glue (based on the number
of resources in glue), copy all the resources from glue to core before creating
the musb core device. This prevents the need to know the number of resources
beforehand.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Tested omap4 panda and omap3 beagle for enumeration .
All other platforms compile tested only.

 drivers/usb/musb/am35x.c    |   16 +++++++++++++++-
 drivers/usb/musb/blackfin.c |   28 ++++++++++++++--------------
 drivers/usb/musb/da8xx.c    |   28 ++++++++++++++--------------
 drivers/usb/musb/davinci.c  |   28 ++++++++++++++--------------
 drivers/usb/musb/omap2430.c |   33 ++++++++++++++-------------------
 drivers/usb/musb/tusb6010.c |   33 ++++++++++++++-------------------
 drivers/usb/musb/ux500.c    |   28 ++++++++++++++--------------
 7 files changed, 99 insertions(+), 95 deletions(-)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 50ba013..6ea907d 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -457,8 +457,10 @@ static u64 am35x_dmamask = DMA_BIT_MASK(32);
 static int am35x_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = dev_get_platdata(&pdev->dev);
+	struct resource			*musb_resources;
 	struct platform_device		*musb;
 	struct am35x_glue		*glue;
+	int				i;
 
 	struct clk			*phy_clk;
 	struct clk			*clk;
@@ -477,6 +479,11 @@ static int am35x_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	musb_resources = devm_kzalloc(&pdev->dev, pdev->num_resources *
+		sizeof(*musb_resources), GFP_KERNEL);
+	if (!musb_resources)
+		goto err1;
+
 	phy_clk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(phy_clk)) {
 		dev_err(&pdev->dev, "failed to get PHY clock\n");
@@ -516,7 +523,14 @@ static int am35x_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
-	ret = platform_device_add_resources(musb, pdev->resource,
+	for (i = 0; i < pdev->num_resources; i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
+
+	ret = platform_device_add_resources(musb, musb_resources,
 			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 70f4c5d..9331ca9 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -450,10 +450,11 @@ static u64 bfin_dmamask = DMA_BIT_MASK(32);
 
 static int bfin_probe(struct platform_device *pdev)
 {
-	struct resource musb_resources[2];
+	struct resource *musb_resources;
 	struct musb_hdrc_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct platform_device		*musb;
 	struct bfin_glue		*glue;
+	int				i;
 
 	int				ret = -ENOMEM;
 
@@ -469,6 +470,11 @@ static int bfin_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	musb_resources = devm_kzalloc(&pdev->dev, pdev->num_resources *
+		sizeof(*musb_resources), GFP_KERNEL);
+	if (!musb_resources)
+		goto err3;
+
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &bfin_dmamask;
 	musb->dev.coherent_dma_mask	= bfin_dmamask;
@@ -480,21 +486,15 @@ static int bfin_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
-	memset(musb_resources, 0x00, sizeof(*musb_resources) *
-			ARRAY_SIZE(musb_resources));
-
-	musb_resources[0].name = pdev->resource[0].name;
-	musb_resources[0].start = pdev->resource[0].start;
-	musb_resources[0].end = pdev->resource[0].end;
-	musb_resources[0].flags = pdev->resource[0].flags;
-
-	musb_resources[1].name = pdev->resource[1].name;
-	musb_resources[1].start = pdev->resource[1].start;
-	musb_resources[1].end = pdev->resource[1].end;
-	musb_resources[1].flags = pdev->resource[1].flags;
+	for (i = 0; i < pdev->num_resources; i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
 
 	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
+			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
 		goto err3;
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 89b2c65..5f99522 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -476,10 +476,11 @@ static u64 da8xx_dmamask = DMA_BIT_MASK(32);
 
 static int da8xx_probe(struct platform_device *pdev)
 {
-	struct resource musb_resources[2];
+	struct resource *musb_resources;
 	struct musb_hdrc_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct platform_device		*musb;
 	struct da8xx_glue		*glue;
+	int				i;
 
 	struct clk			*clk;
 
@@ -497,6 +498,11 @@ static int da8xx_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	musb_resources = devm_kzalloc(&pdev->dev, pdev->num_resources *
+		sizeof(*musb_resources), GFP_KERNEL);
+	if (!musb_resources)
+		goto err1;
+
 	clk = devm_clk_get(&pdev->dev, "usb20");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
@@ -522,21 +528,15 @@ static int da8xx_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
-	memset(musb_resources, 0x00, sizeof(*musb_resources) *
-			ARRAY_SIZE(musb_resources));
-
-	musb_resources[0].name = pdev->resource[0].name;
-	musb_resources[0].start = pdev->resource[0].start;
-	musb_resources[0].end = pdev->resource[0].end;
-	musb_resources[0].flags = pdev->resource[0].flags;
-
-	musb_resources[1].name = pdev->resource[1].name;
-	musb_resources[1].start = pdev->resource[1].start;
-	musb_resources[1].end = pdev->resource[1].end;
-	musb_resources[1].flags = pdev->resource[1].flags;
+	for (i = 0; i < pdev->num_resources; i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
 
 	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
+			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
 		goto err2;
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index 9bb121d..bc3a725 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -509,11 +509,12 @@ static u64 davinci_dmamask = DMA_BIT_MASK(32);
 
 static int davinci_probe(struct platform_device *pdev)
 {
-	struct resource musb_resources[2];
+	struct resource *musb_resources;
 	struct musb_hdrc_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct platform_device		*musb;
 	struct davinci_glue		*glue;
 	struct clk			*clk;
+	int				i;
 
 	int				ret = -ENOMEM;
 
@@ -536,6 +537,11 @@ static int davinci_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
+	musb_resources = devm_kzalloc(&pdev->dev, pdev->num_resources *
+		sizeof(*musb_resources), GFP_KERNEL);
+	if (!musb_resources)
+		goto err1;
+
 	ret = clk_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
@@ -554,21 +560,15 @@ static int davinci_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
-	memset(musb_resources, 0x00, sizeof(*musb_resources) *
-			ARRAY_SIZE(musb_resources));
-
-	musb_resources[0].name = pdev->resource[0].name;
-	musb_resources[0].start = pdev->resource[0].start;
-	musb_resources[0].end = pdev->resource[0].end;
-	musb_resources[0].flags = pdev->resource[0].flags;
-
-	musb_resources[1].name = pdev->resource[1].name;
-	musb_resources[1].start = pdev->resource[1].start;
-	musb_resources[1].end = pdev->resource[1].end;
-	musb_resources[1].flags = pdev->resource[1].flags;
+	for (i = 0; i < pdev->num_resources; i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
 
 	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
+			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
 		goto err2;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 5d5e5e5..c54063f 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -481,7 +481,7 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
 
 static int omap2430_probe(struct platform_device *pdev)
 {
-	struct resource			musb_resources[3];
+	struct resource			*musb_resources;
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct omap_musb_board_data	*data;
 	struct platform_device		*musb;
@@ -489,6 +489,7 @@ static int omap2430_probe(struct platform_device *pdev)
 	struct device_node		*np = pdev->dev.of_node;
 	struct musb_hdrc_config		*config;
 	int				ret = -ENOMEM;
+	int				i;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
@@ -502,6 +503,11 @@ static int omap2430_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	musb_resources = devm_kzalloc(&pdev->dev, pdev->num_resources *
+		sizeof(*musb_resources), GFP_KERNEL);
+	if (!musb_resources)
+		goto err2;
+
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &omap2430_dmamask;
 	musb->dev.coherent_dma_mask	= omap2430_dmamask;
@@ -568,26 +574,15 @@ static int omap2430_probe(struct platform_device *pdev)
 
 	INIT_WORK(&glue->omap_musb_mailbox_work, omap_musb_mailbox_work);
 
-	memset(musb_resources, 0x00, sizeof(*musb_resources) *
-			ARRAY_SIZE(musb_resources));
-
-	musb_resources[0].name = pdev->resource[0].name;
-	musb_resources[0].start = pdev->resource[0].start;
-	musb_resources[0].end = pdev->resource[0].end;
-	musb_resources[0].flags = pdev->resource[0].flags;
-
-	musb_resources[1].name = pdev->resource[1].name;
-	musb_resources[1].start = pdev->resource[1].start;
-	musb_resources[1].end = pdev->resource[1].end;
-	musb_resources[1].flags = pdev->resource[1].flags;
-
-	musb_resources[2].name = pdev->resource[2].name;
-	musb_resources[2].start = pdev->resource[2].start;
-	musb_resources[2].end = pdev->resource[2].end;
-	musb_resources[2].flags = pdev->resource[2].flags;
+	for (i = 0; i < pdev->num_resources; i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
 
 	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
+			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
 		goto err2;
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 6d93fe8..b9a3de0 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1156,10 +1156,11 @@ static u64 tusb_dmamask = DMA_BIT_MASK(32);
 
 static int tusb_probe(struct platform_device *pdev)
 {
-	struct resource musb_resources[3];
+	struct resource *musb_resources;
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
 	struct tusb6010_glue		*glue;
+	int				i;
 
 	int				ret = -ENOMEM;
 
@@ -1175,6 +1176,11 @@ static int tusb_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	musb_resources = devm_kzalloc(&pdev->dev, pdev->num_resources *
+		sizeof(*musb_resources), GFP_KERNEL);
+	if (!musb_resources)
+		goto err1;
+
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &tusb_dmamask;
 	musb->dev.coherent_dma_mask	= tusb_dmamask;
@@ -1186,26 +1192,15 @@ static int tusb_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
-	memset(musb_resources, 0x00, sizeof(*musb_resources) *
-			ARRAY_SIZE(musb_resources));
-
-	musb_resources[0].name = pdev->resource[0].name;
-	musb_resources[0].start = pdev->resource[0].start;
-	musb_resources[0].end = pdev->resource[0].end;
-	musb_resources[0].flags = pdev->resource[0].flags;
-
-	musb_resources[1].name = pdev->resource[1].name;
-	musb_resources[1].start = pdev->resource[1].start;
-	musb_resources[1].end = pdev->resource[1].end;
-	musb_resources[1].flags = pdev->resource[1].flags;
-
-	musb_resources[2].name = pdev->resource[2].name;
-	musb_resources[2].start = pdev->resource[2].start;
-	musb_resources[2].end = pdev->resource[2].end;
-	musb_resources[2].flags = pdev->resource[2].flags;
+	for (i = 0; i < pdev->num_resources; i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
 
 	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
+			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
 		goto err1;
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 14a1d62..059f7a7 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -226,12 +226,13 @@ ux500_of_probe(struct platform_device *pdev, struct device_node *np)
 
 static int ux500_probe(struct platform_device *pdev)
 {
-	struct resource musb_resources[2];
+	struct resource *musb_resources;
 	struct musb_hdrc_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct device_node		*np = pdev->dev.of_node;
 	struct platform_device		*musb;
 	struct ux500_glue		*glue;
 	struct clk			*clk;
+	int				i;
 	int				ret = -ENOMEM;
 
 	if (!pdata) {
@@ -259,6 +260,11 @@ static int ux500_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	musb_resources = devm_kzalloc(&pdev->dev, pdev->num_resources *
+		sizeof(*musb_resources), GFP_KERNEL);
+	if (!musb_resources)
+		goto err1;
+
 	clk = devm_clk_get(&pdev->dev, "usb");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
@@ -286,21 +292,15 @@ static int ux500_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
-	memset(musb_resources, 0x00, sizeof(*musb_resources) *
-			ARRAY_SIZE(musb_resources));
-
-	musb_resources[0].name = pdev->resource[0].name;
-	musb_resources[0].start = pdev->resource[0].start;
-	musb_resources[0].end = pdev->resource[0].end;
-	musb_resources[0].flags = pdev->resource[0].flags;
-
-	musb_resources[1].name = pdev->resource[1].name;
-	musb_resources[1].start = pdev->resource[1].start;
-	musb_resources[1].end = pdev->resource[1].end;
-	musb_resources[1].flags = pdev->resource[1].flags;
+	for (i = 0; i < pdev->num_resources; i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
 
 	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
+			pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
 		goto err2;
-- 
1.7.10.4

