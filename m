Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3EJIQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:16:42 -0400
Received: from sauhun.de ([89.238.76.85]:60381 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3EJIQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:38 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 09/42] drivers/i2c/busses: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:54 +0200
Message-Id: <1368173847-5661-10-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-davinci.c            |    6 +-----
 drivers/i2c/busses/i2c-designware-platdrv.c |    6 +-----
 drivers/i2c/busses/i2c-imx.c                |    6 +-----
 drivers/i2c/busses/i2c-omap.c               |    6 +-----
 drivers/i2c/busses/i2c-rcar.c               |    7 +------
 drivers/i2c/busses/i2c-s3c2410.c            |    5 -----
 drivers/i2c/busses/i2c-sirf.c               |    6 ------
 drivers/i2c/busses/i2c-tegra.c              |    5 -----
 8 files changed, 5 insertions(+), 42 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index cf20e06..2ed3e7b 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -647,11 +647,6 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	int r;
 
 	/* NOTE: driver uses the static register mapping */
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "no mem resource?\n");
-		return -ENODEV;
-	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
@@ -697,6 +692,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		return -ENODEV;
 	clk_prepare_enable(dev->clk);
 
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->base = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(dev->base)) {
 		r = PTR_ERR(dev->base);
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 8ec9133..6f3c612 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -87,11 +87,6 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	int irq, r;
 
 	/* NOTE: driver uses the static register mapping */
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "no mem resource?\n");
-		return -EINVAL;
-	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -103,6 +98,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->base = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(dev->base))
 		return PTR_ERR(dev->base);
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 82f20c6..b274ca1 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -500,17 +500,13 @@ static int __init i2c_imx_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "<%s>\n", __func__);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "can't get device resources\n");
-		return -ENOENT;
-	}
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "can't get irq number\n");
 		return -ENOENT;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index e02f9e3..8498ab7 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1085,11 +1085,6 @@ omap_i2c_probe(struct platform_device *pdev)
 	u16 minor, major, scheme;
 
 	/* NOTE: driver uses the static register mapping */
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "no mem resource?\n");
-		return -ENODEV;
-	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -1103,6 +1098,7 @@ omap_i2c_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->base = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(dev->base))
 		return PTR_ERR(dev->base);
diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 4ba4a95..0fc5858 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -623,12 +623,6 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	u32 bus_speed;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "no mmio resources\n");
-		return -ENODEV;
-	}
-
 	priv = devm_kzalloc(dev, sizeof(struct rcar_i2c_priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(dev, "no mem for private data\n");
@@ -642,6 +636,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->io = devm_ioremap_resource(dev, res);
 	if (IS_ERR(priv->io))
 		return PTR_ERR(priv->io);
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 6e8ee92..cab1c91 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1082,11 +1082,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	/* map the registers */
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "cannot find IO resource\n");
-		return -ENOENT;
-	}
-
 	i2c->regs = devm_ioremap_resource(&pdev->dev, res);
 
 	if (IS_ERR(i2c->regs))
diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index 5a7ad24..a63c7d5 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -303,12 +303,6 @@ static int i2c_sirfsoc_probe(struct platform_device *pdev)
 	adap->class = I2C_CLASS_HWMON;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (mem_res == NULL) {
-		dev_err(&pdev->dev, "Unable to get MEM resource\n");
-		err = -EINVAL;
-		goto out;
-	}
-
 	siic->base = devm_ioremap_resource(&pdev->dev, mem_res);
 	if (IS_ERR(siic->base)) {
 		err = PTR_ERR(siic->base);
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index b60ff90..9aa1b60 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -714,11 +714,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no mem resource\n");
-		return -EINVAL;
-	}
-
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
-- 
1.7.10.4

