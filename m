Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaHTG1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:27:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23344 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaHTG1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:27:11 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-29-53f43fbcd749
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Drake <drake@endlessm.com>, Tobias Jakobi <Liquid.Acid@gmx.net>,
        Olof Johansson <olof@lixom.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: max77686: make interrupts support optional
Date: Wed, 20 Aug 2014 08:26:49 +0200
Message-id: <1408516009-22106-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e/4Fd099l+CDSZ95rXYOGM9q8Wj+Y+Z
	LY7+LrB4/cLQ4v7Xo4wWmx5fY7W4vGsOm0XXz59sFmuP3GW3OHX9M5vF6W5WB26Pv8+vs3gs
	+p7lsXjTfjaPO9f2sHnMOxnosXlJvceVE02sHn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJVx
	9txRtoLpUhWfVm5jbWA8K9rFyMkhIWAisXb5WlYIW0ziwr31bF2MXBxCAksZJX6962OCcPqY
	JJoW32UEqWITMJToetvFBmKLCChIbO59xgpSxCywmVliWtcfFpCEsICDxOmZm8DGsgioSjzY
	MxsszivgIfG66RkjxDo5if8vVzBNYORewMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMk
	2L7sYFx8zOoQowAHoxIPr0L252Ah1sSy4srcQ4wSHMxKIrz1Zl+ChXhTEiurUovy44tKc1KL
	DzEycXBKNTAyRzlI7DgVInzhYJriokSZGENp/r3L7v45NTl6yXwVyfqJ/3+k5Mvw3PHp3dT6
	T7xiww/uFKOrF0SiL1++verghX/F5k7qzP/8XNY0ilziO9XAY5C9TyLOSOBmaGJh4q1zFtpr
	l6/oPh7mwqSuqW24le37U+nMq9cydlxkPLnyp5OUzY+n4nFKLMUZiYZazEXFiQCrYgw0FAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6f1c1e71d93 ("mfd: max77686: Convert to use regmap_irq") broke
support for boards, which provide no irq for MAX 77686 PMIC. In such
case, not all functions of PMIC are available, but the driver still
should at least handle voltage regulators instead of failing to init.
This patch restores previous behavior.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
Hello,

This patch fixes booting issues with recently merged support for
Exynos4412 based Odroid X2/U3 boards. See
http://www.spinics.net/lists/linux-samsung-soc/msg35773.html
thread for more details.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
---
 drivers/mfd/max77686.c | 46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 86e552348db4..525718c448c8 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -314,22 +314,26 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
-	ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
-				  IRQF_SHARED, 0, irq_chip,
-				  &max77686->irq_data);
-	if (ret) {
-		dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
-		goto err_unregister_i2c;
-	}
+	if (max77686->irq) {
+		ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
+					  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
+					  IRQF_SHARED, 0, irq_chip,
+					  &max77686->irq_data);
+		if (ret) {
+			dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n",
+				 ret);
+			goto err_unregister_i2c;
+		}
 
-	ret = regmap_add_irq_chip(*rtc_regmap, max77686->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
-				  IRQF_SHARED, 0, rtc_irq_chip,
-				  &max77686->rtc_irq_data);
-	if (ret) {
-		dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n", ret);
-		goto err_del_irqc;
+		ret = regmap_add_irq_chip(*rtc_regmap, max77686->irq,
+					  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
+					  IRQF_SHARED, 0, rtc_irq_chip,
+					  &max77686->rtc_irq_data);
+		if (ret) {
+			dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n",
+				ret);
+			goto err_del_irqc;
+		}
 	}
 
 	ret = mfd_add_devices(max77686->dev, -1, cells, n_devs, NULL, 0, NULL);
@@ -341,9 +345,11 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_del_rtc_irqc:
-	regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
+	if (max77686->irq)
+		regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
 err_del_irqc:
-	regmap_del_irq_chip(max77686->irq, max77686->irq_data);
+	if (max77686->irq)
+		regmap_del_irq_chip(max77686->irq, max77686->irq_data);
 err_unregister_i2c:
 	if (max77686->type == TYPE_MAX77686)
 		i2c_unregister_device(max77686->rtc);
@@ -357,8 +363,10 @@ static int max77686_i2c_remove(struct i2c_client *i2c)
 
 	mfd_remove_devices(max77686->dev);
 
-	regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
-	regmap_del_irq_chip(max77686->irq, max77686->irq_data);
+	if (max77686->irq)
+		regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
+	if (max77686->irq)
+		regmap_del_irq_chip(max77686->irq, max77686->irq_data);
 
 	if (max77686->type == TYPE_MAX77686)
 		i2c_unregister_device(max77686->rtc);
-- 
1.9.2

