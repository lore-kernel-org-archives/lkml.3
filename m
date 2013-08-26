Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3HZKBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:01:24 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33110 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab3HZKBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:01:22 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/3] pinctrl: mvebu: Convert to use devm_ioremap_resource
Date: Mon, 26 Aug 2013 17:56:21 +0800
Message-ID: <1377510981-1793-4-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377510981-1793-1-git-send-email-jszhang@marvell.com>
References: <1377510981-1793-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resource mapped by of_iomap() isn't unmapped in error path. This
patch fixes the resource leakage by using devm_ioremap_resource() instead
of of_iomap().

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index bb7ddb1..1caa45f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -579,7 +579,7 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
 int mvebu_pinctrl_probe(struct platform_device *pdev)
 {
 	struct mvebu_pinctrl_soc_info *soc = dev_get_platdata(&pdev->dev);
-	struct device_node *np = pdev->dev.of_node;
+	struct resource *res;
 	struct mvebu_pinctrl *pctl;
 	void __iomem *base;
 	struct pinctrl_pin_desc *pdesc;
@@ -591,11 +591,10 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	base = of_iomap(np, 0);
-	if (!base) {
-		dev_err(&pdev->dev, "unable to get base address\n");
-		return -ENODEV;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	pctl = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_pinctrl),
 			GFP_KERNEL);
-- 
1.8.4.rc3

