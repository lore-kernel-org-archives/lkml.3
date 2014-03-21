Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbaCUFjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:39:15 -0400
Received: from [216.32.181.183] ([216.32.181.183]:29153 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759220AbaCUFjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:39:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <broonie@kernel.org>, <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 3/3] pwm: ftm-pwm: Add big-endian support
Date: Fri, 21 Mar 2014 12:53:10 +0800
Message-ID: <1395377590-23537-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now for the following scenarios:

     SoC     |  CPU   | FTM-PWM | 'big-endian' property is needed?
-------------|--------|---------|---------------------------------
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


