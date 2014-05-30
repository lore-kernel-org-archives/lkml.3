Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaE3Gxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:53:45 -0400
Received: from [207.46.163.140] ([207.46.163.140]:13666 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932378AbaE3Gxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:53:43 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] watchdog: imx2_wdt: adds big endianness support.
Date: Fri, 30 May 2014 14:10:17 +0800
Message-ID: <1401430217-29543-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(21056001)(77982001)(84676001)(26826002)(46102001)(48376002)(83322001)(4396001)(76482001)(6806004)(20776003)(64706001)(79102001)(47776003)(80022001)(77096999)(85852003)(74502001)(77156001)(50986999)(99396002)(92726001)(93916002)(104166001)(97736001)(87286001)(89996001)(104016001)(87936001)(74662001)(62966002)(92566001)(88136002)(31966008)(2201001)(86362001)(81542001)(50466002)(50226001)(68736004)(36756003)(44976005)(83072002)(19580405001)(81342001)(19580395003)(102836001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB498;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02272225C5
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This watchdog driver will be working on IMX2+, Vybrid, LS1, LS2+
platforms, and will be in different endianness mode in those SoCs:

SoCs         CPU endian mode      WDT endian mode
------------------------------------------------
IMX2+            LE                    LE
Vybird           LE                    LE
LS1              LE                    BE
LS2              LE                    LE

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/watchdog/imx2_wdt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 9d4874f..68c3d37 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
@@ -190,10 +191,12 @@ static struct regmap_config imx2_wdt_regmap_config = {
 
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct imx2_wdt_device *wdev;
 	struct watchdog_device *wdog;
 	struct resource *res;
 	void __iomem *base;
+	bool big_endian;
 	int ret;
 	u32 val;
 
@@ -201,6 +204,10 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 	if (!wdev)
 		return -ENOMEM;
 
+	big_endian = of_property_read_bool(np, "big-endian");
+	if (big_endian)
+		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
-- 
1.8.4

