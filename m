Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3KGDPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:15:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63186 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797Ab3KGDNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:13:48 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <baohua@kernel.org>, <dinguyen@altera.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v5 3/3] pinctrl: mvebu: Convert to use devm_ioremap_resource
Date: Thu, 7 Nov 2013 11:08:39 +0800
Message-ID: <1383793720-4643-7-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383793720-4643-1-git-send-email-jszhang@marvell.com>
References: <1383793720-4643-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_01:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060260
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resource mapped by of_iomap() isn't unmapped in error path. This
patch fix the resource leakage by using devm_ioremap_resource() instead
of of_iomap().

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
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

