Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaHYH7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:59:07 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:28241
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754490AbaHYH7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:59:05 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <wim@iguana.be>, <linux@roeck-us.net>, <mpa@pengutronix.de>,
        <linux-watchdog@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's endianness method.
Date: Mon, 25 Aug 2014 15:54:37 +0800
Message-ID: <1408953277-2069-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(89996001)(86362001)(77156001)(50986999)(19580405001)(69596002)(87286001)(105606002)(84676001)(79102001)(87936001)(6806004)(85852003)(19580395003)(92726001)(85306004)(99396002)(93916002)(95666004)(81342001)(2201001)(92566001)(104016003)(81156004)(83322001)(44976005)(104166001)(102836001)(74662001)(47776003)(21056001)(46102001)(20776003)(48376002)(76482001)(4396001)(36756003)(31966008)(80022001)(68736004)(229853001)(90102001)(81542001)(50466002)(88136002)(83072002)(74502001)(50226001)(26826002)(107046002)(97736001)(64706001)(77982001)(106466001)(62966002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0613;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regmap framework will contain some patches to handle endianess, and there
does not need any parsing of endianness DT properties of individual driver,
so we can savely remove it here.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v2:
- Remove useless header file.




 Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt | 4 ++--
 drivers/watchdog/imx2_wdt.c                                | 9 +--------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
index e52ba2d..9e1ebe2 100644
--- a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
@@ -6,8 +6,8 @@ Required properties:
 - interrupts : Should contain WDT interrupt
 
 Optional property:
-- big-endian: If present the watchdog device's registers are implemented
-  in big endian mode, otherwise in little mode.
+- big-endian: Boolean property, required if all the i.MX WDT registers
+  are big-endian rather than little-endian.
 
 Examples:
 
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 68c3d37..afc8738 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
@@ -182,7 +181,7 @@ static struct watchdog_ops imx2_wdt_ops = {
 	.set_timeout = imx2_wdt_set_timeout,
 };
 
-static struct regmap_config imx2_wdt_regmap_config = {
+static const struct regmap_config imx2_wdt_regmap_config = {
 	.reg_bits = 16,
 	.reg_stride = 2,
 	.val_bits = 16,
@@ -191,12 +190,10 @@ static struct regmap_config imx2_wdt_regmap_config = {
 
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct imx2_wdt_device *wdev;
 	struct watchdog_device *wdog;
 	struct resource *res;
 	void __iomem *base;
-	bool big_endian;
 	int ret;
 	u32 val;
 
@@ -204,10 +201,6 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 	if (!wdev)
 		return -ENOMEM;
 
-	big_endian = of_property_read_bool(np, "big-endian");
-	if (big_endian)
-		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
-- 
1.8.5

