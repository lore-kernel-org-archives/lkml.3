Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaD2ES2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:18:28 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:39923
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754486AbaD2ES0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:18:26 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 4/4] pwm: ftm-pwm: Add big-endian support
Date: Tue, 29 Apr 2014 11:33:49 +0800
Message-ID: <1398742429-10399-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398742429-10399-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398742429-10399-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(50226001)(19580395003)(87936001)(81342001)(62966002)(19580405001)(89996001)(50986999)(6806004)(101416001)(36756003)(83072002)(83322001)(93916002)(44976005)(46102001)(85852003)(4396001)(47776003)(99396002)(31966008)(77156001)(81542001)(48376002)(92726001)(87286001)(76482001)(20776003)(88136002)(79102001)(92566001)(74502001)(76176999)(86362001)(77096999)(77982001)(50466002)(80022001)(80976001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB500;H:tx30smr01.am.freescale.net;FPR:3097CB6B.D31D1509.3BF697D0.166622F1.201B2;MLV:sfv;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the big endianness support for the FTM PWM driver, which
will run on LS1 SoC.

Now for the following scenarios:
 SoC     |  CPU   | FTM-PWM | 'big-endian' property is needed?
---------|--------|---------|---------------------------------
Vybird   |  LE    |   LE    |     No
 LS1     |  LE    |   BE    |     Yes
 LS2     |  LE    |   LE    |     No

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/pwm/pwm-fsl-ftm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 5d999c1..9a82741 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -409,6 +409,7 @@ static struct regmap_config fsl_pwm_regmap_config = {
 
 static int fsl_pwm_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct fsl_pwm_chip *fpc;
 	struct resource *res;
 	void __iomem *base;
@@ -422,6 +423,11 @@ static int fsl_pwm_probe(struct platform_device *pdev)
 
 	fpc->chip.dev = &pdev->dev;
 
+	if (of_property_read_bool(np, "big-endian"))
+		fsl_pwm_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
+	else
+		fsl_pwm_regmap_config.val_format_endian = REGMAP_ENDIAN_NATIVE;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
-- 
1.8.4

