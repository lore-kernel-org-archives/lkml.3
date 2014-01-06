Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaAFMNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:13:25 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:51223
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbaAFMNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:13:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <broonie@kernel.org>
CC: <shawn.guo@linaro.org>, <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: anatop-regulator: Remove unneeded kstrdup()
Date: Mon, 6 Jan 2014 10:13:15 -0200
Message-ID: <1389010395-375-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can simply pass the regulator name via of_get_property() instead of making
a copy via kstrdup().

This leads to some code simplification.

Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/anatop-regulator.c | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index a004144..3d4997a 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -122,8 +122,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	if (!sreg)
 		return -ENOMEM;
 	sreg->initdata = initdata;
-	sreg->name = kstrdup(of_get_property(np, "regulator-name", NULL),
-			     GFP_KERNEL);
+	sreg->name = of_get_property(np, "regulator-name", NULL);
 	rdesc = &sreg->rdesc;
 	memset(rdesc, 0, sizeof(*rdesc));
 	rdesc->name = sreg->name;
@@ -143,37 +142,37 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 				   &sreg->control_reg);
 	if (ret) {
 		dev_err(dev, "no anatop-reg-offset property set\n");
-		goto anatop_probe_end;
+		return ret;
 	}
 	ret = of_property_read_u32(np, "anatop-vol-bit-width",
 				   &sreg->vol_bit_width);
 	if (ret) {
 		dev_err(dev, "no anatop-vol-bit-width property set\n");
-		goto anatop_probe_end;
+		return ret;
 	}
 	ret = of_property_read_u32(np, "anatop-vol-bit-shift",
 				   &sreg->vol_bit_shift);
 	if (ret) {
 		dev_err(dev, "no anatop-vol-bit-shift property set\n");
-		goto anatop_probe_end;
+		return ret;
 	}
 	ret = of_property_read_u32(np, "anatop-min-bit-val",
 				   &sreg->min_bit_val);
 	if (ret) {
 		dev_err(dev, "no anatop-min-bit-val property set\n");
-		goto anatop_probe_end;
+		return ret;
 	}
 	ret = of_property_read_u32(np, "anatop-min-voltage",
 				   &sreg->min_voltage);
 	if (ret) {
 		dev_err(dev, "no anatop-min-voltage property set\n");
-		goto anatop_probe_end;
+		return ret;
 	}
 	ret = of_property_read_u32(np, "anatop-max-voltage",
 				   &sreg->max_voltage);
 	if (ret) {
 		dev_err(dev, "no anatop-max-voltage property set\n");
-		goto anatop_probe_end;
+		return ret;
 	}
 
 	/* read LDO ramp up setting, only for core reg */
@@ -204,27 +203,11 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	if (IS_ERR(rdev)) {
 		dev_err(dev, "failed to register %s\n",
 			rdesc->name);
-		ret = PTR_ERR(rdev);
-		goto anatop_probe_end;
+		return PTR_ERR(rdev);
 	}
 
 	platform_set_drvdata(pdev, rdev);
 
-anatop_probe_end:
-	if (ret)
-		kfree(sreg->name);
-
-	return ret;
-}
-
-static int anatop_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-	struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
-	const char *name = sreg->name;
-
-	kfree(name);
-
 	return 0;
 }
 
@@ -240,7 +223,6 @@ static struct platform_driver anatop_regulator_driver = {
 		.of_match_table = of_anatop_regulator_match_tbl,
 	},
 	.probe	= anatop_regulator_probe,
-	.remove	= anatop_regulator_remove,
 };
 
 static int __init anatop_regulator_init(void)
-- 
1.8.1.2


