Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3HXRNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 13:13:44 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:3416 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab3HXRN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 13:13:27 -0400
X-IronPort-AV: E=Sophos;i="4.89,947,1367964000"; 
   d="scan'208";a="24669913"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: kernel-janitors@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] rtc: simplify devm_request_mem_region/devm_ioremap
Date: Sat, 24 Aug 2013 19:13:16 +0200
Message-Id: <1377364396-27861-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1377364396-27861-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1377364396-27861-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert the composition of devm_request_mem_region and devm_ioremap to a
single call to devm_ioremap_resource.  The associated call to
platform_get_resource is also simplified and moved next to the new call to
devm_ioremap_resource.

This was done using a combination of the semantic patches
devm_ioremap_resource.cocci and devm_request_and_ioremap.cocci, found in
the scripts/coccinelle/api directory.

In rtc-lpc32xx.c and rtc-mv.c, the local variable size is no longer needed.

In rtc-ds1511.c and rtc-ds1742.c, the size field of the local structure is
not useful any more, and is deleted.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/rtc/rtc-ds1553.c   |   13 ++++---------
 drivers/rtc/rtc-ep93xx.c   |   14 +++-----------
 drivers/rtc/rtc-imxdi.c    |   16 ++++------------
 drivers/rtc/rtc-lpc32xx.c  |   24 ++++--------------------
 drivers/rtc/rtc-mv.c       |   17 ++++-------------
 drivers/rtc/rtc-mxc.c      |   14 ++++----------
 drivers/rtc/rtc-stk17ta8.c |   15 +++++----------
 drivers/rtc/rtc-tx4939.c   |   14 ++++----------
 drivers/rtc/rtc-ds1511.c   |   17 +++++------------
 drivers/rtc/rtc-ds1742.c   |   18 ++++++------------
 10 files changed, 43 insertions(+), 119 deletions(-)

diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 8c6c952..fd31571 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -285,19 +285,14 @@ static int ds1553_rtc_probe(struct platform_device *pdev)
 	void __iomem *ioaddr;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	if (!devm_request_mem_region(&pdev->dev, res->start, RTC_REG_SIZE,
-			pdev->name))
-		return -EBUSY;
 
-	ioaddr = devm_ioremap(&pdev->dev, res->start, RTC_REG_SIZE);
-	if (!ioaddr)
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ioaddr))
+		return PTR_ERR(ioaddr);
 	pdata->ioaddr = ioaddr;
 	pdata->irq = platform_get_irq(pdev, 0);
 
diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 549b3c3..580e7b5 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -138,17 +138,9 @@ static int ep93xx_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-
-	ep93xx_rtc->mmio_base = devm_ioremap(&pdev->dev, res->start,
-					     resource_size(res));
-	if (!ep93xx_rtc->mmio_base)
-		return -ENXIO;
+	ep93xx_rtc->mmio_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ep93xx_rtc->mmio_base))
+		return PTR_ERR(ep93xx_rtc->mmio_base);
 
 	pdev->dev.platform_data = ep93xx_rtc;
 	platform_set_drvdata(pdev, ep93xx_rtc);
diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index d3a8c8e..abd7f90 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -375,24 +375,16 @@ static int __init dryice_rtc_probe(struct platform_device *pdev)
 	struct imxdi_dev *imxdi;
 	int rc;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	imxdi = devm_kzalloc(&pdev->dev, sizeof(*imxdi), GFP_KERNEL);
 	if (!imxdi)
 		return -ENOMEM;
 
 	imxdi->pdev = pdev;
 
-	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
-				pdev->name))
-		return -EBUSY;
-
-	imxdi->ioaddr = devm_ioremap(&pdev->dev, res->start,
-			resource_size(res));
-	if (imxdi->ioaddr == NULL)
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	imxdi->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(imxdi->ioaddr))
+		return PTR_ERR(imxdi->ioaddr);
 
 	spin_lock_init(&imxdi->irq_lock);
 
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index 8276ae9..bfdbcb8 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -201,16 +201,9 @@ static int lpc32xx_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct lpc32xx_rtc *rtc;
-	resource_size_t size;
 	int rtcirq;
 	u32 tmp;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Can't get memory resource\n");
-		return -ENOENT;
-	}
-
 	rtcirq = platform_get_irq(pdev, 0);
 	if (rtcirq < 0 || rtcirq >= NR_IRQS) {
 		dev_warn(&pdev->dev, "Can't get interrupt resource\n");
@@ -224,19 +217,10 @@ static int lpc32xx_rtc_probe(struct platform_device *pdev)
 	}
 	rtc->irq = rtcirq;
 
-	size = resource_size(res);
-
-	if (!devm_request_mem_region(&pdev->dev, res->start, size,
-				     pdev->name)) {
-		dev_err(&pdev->dev, "RTC registers are not free\n");
-		return -EBUSY;
-	}
-
-	rtc->rtc_base = devm_ioremap(&pdev->dev, res->start, size);
-	if (!rtc->rtc_base) {
-		dev_err(&pdev->dev, "Can't map memory\n");
-		return -ENOMEM;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rtc->rtc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc->rtc_base))
+		return PTR_ERR(rtc->rtc_base);
 
 	spin_lock_init(&rtc->lock);
 
diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index baab802..d536c59 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -221,26 +221,17 @@ static int __init mv_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct rtc_plat_data *pdata;
-	resource_size_t size;
 	u32 rtc_time;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, size,
-				     pdev->name))
-		return -EBUSY;
-
-	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start, size);
-	if (!pdata->ioaddr)
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->ioaddr))
+		return PTR_ERR(pdata->ioaddr);
 
 	pdata->clk = devm_clk_get(&pdev->dev, NULL);
 	/* Not all SoCs require a clock.*/
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index ab87bac..50c5726 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -377,22 +377,16 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 	unsigned long rate;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
 	pdata->devtype = pdev->id_entry->driver_data;
 
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-
-	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start,
-				     resource_size(res));
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->ioaddr))
+		return PTR_ERR(pdata->ioaddr);
 
 	pdata->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pdata->clk)) {
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index af5e97e..a176ba6 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -294,19 +294,14 @@ static int stk17ta8_rtc_probe(struct platform_device *pdev)
 	void __iomem *ioaddr;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	if (!devm_request_mem_region(&pdev->dev, res->start, RTC_REG_SIZE,
-			pdev->name))
-		return -EBUSY;
-	ioaddr = devm_ioremap(&pdev->dev, res->start, RTC_REG_SIZE);
-	if (!ioaddr)
-		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ioaddr))
+		return PTR_ERR(ioaddr);
 	pdata->ioaddr = ioaddr;
 	pdata->irq = platform_get_irq(pdev, 0);
 
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index f9a0677..4f87234 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -244,9 +244,6 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 	struct resource *res;
 	int irq, ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return -ENODEV;
@@ -255,13 +252,10 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, pdata);
 
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-	pdata->rtcreg = devm_ioremap(&pdev->dev, res->start,
-				     resource_size(res));
-	if (!pdata->rtcreg)
-		return -EBUSY;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->rtcreg = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->rtcreg))
+		return PTR_ERR(pdata->rtcreg);
 
 	spin_lock_init(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);

diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 308a8fe..bc7b4fc 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -89,7 +89,6 @@ enum ds1511reg {
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;		/* virtual base address */
-	int size;				/* amount of memory mapped */
 	int irq;
 	unsigned int irqen;
 	int alrm_sec;
@@ -479,20 +478,14 @@ static int ds1511_rtc_probe(struct platform_device *pdev)
 	struct rtc_plat_data *pdata;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
-			pdev->name))
-		return -EBUSY;
-	ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
-	if (!ds1511_base)
-		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ds1511_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ds1511_base))
+		return PTR_ERR(ds1511_base);
 	pdata->ioaddr = ds1511_base;
 	pdata->irq = platform_get_irq(pdev, 0);
 
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index eccdc62..9fba0ae 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -56,7 +56,6 @@ struct rtc_plat_data {
 	void __iomem *ioaddr_nvram;
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
-	size_t size;
 	unsigned long last_jiffies;
 	struct bin_attribute nvram_attr;
 };
@@ -168,22 +167,17 @@ static int ds1742_rtc_probe(struct platform_device *pdev)
 	void __iomem *ioaddr;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
-		pdev->name))
-		return -EBUSY;
-	ioaddr = devm_ioremap(&pdev->dev, res->start, pdata->size);
-	if (!ioaddr)
-		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ioaddr))
+		return PTR_ERR(ioaddr);
 
 	pdata->ioaddr_nvram = ioaddr;
-	pdata->size_nvram = pdata->size - RTC_SIZE;
+	pdata->size_nvram = resource_size(res) - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
 
 	sysfs_bin_attr_init(&pdata->nvram_attr);
