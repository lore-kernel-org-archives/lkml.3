Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbaHGQJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:09:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39000 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:09:11 -0400
X-AuditID: cbfee61b-f79f86d00000144c-0f-53e3a4a573fb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: max77686: fix support for devices without irq specified
Date: Thu, 07 Aug 2014 18:09:04 +0200
Message-id: <1457999.lNPdqEWCCR@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAd2lSx4HG/TctrI4u+wgm8XR3wUW
	r18YWpxtesNucf/rUUaLy7vmsFnMOL+PyeJ0N6sDh8fshossHn+fX2fxuHNtD5vHvJOBHn1b
	VjF6fN4kF8AWxWWTkpqTWZZapG+XwJWx6UlJwTn+ig1dz9gbGD/xdDFyckgImEica9rMAmGL
	SVy4t56ti5GLQ0hgEaPEi4P/oJwWJonlu1czg1SxCVhJTGxfxdjFyMEhIuAlcetOEEgNs0AH
	UM3NU2A1wgK+Eq3vtrOC2CwCqhL7d30B28AroClx8dh6dhBbVMBTYsf2lWwQcUGJH5PvgdUw
	C8hL7Ns/lRXC1pJYv/M40wRGvllIymYhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOAAfia9g3FVg8UhRgEORiUeXoHux8FCrIllxZW5hxglOJiVRHh1QUK8KYmVValF+fFF
	pTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoY03W/XXrYfvdL5qRP+paagiql
	ld/+JAY7hPZ62m55Uvb7fbD6gl/tvcKxDX/fyz4P5bGNNs1redv276xCfqni43cL35isuZfk
	6P00XzlBM/S9u2yOXlpyVpTn2cCf8+ZZvlr8tkVxg0PlPKVeDxEb/ZgfQmd8Vxbcd+iWsJ1v
	ss6k0q2jabYSS3FGoqEWc1FxIgDsLEXtXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 6f1c1e71d933 ("mfd: max77686: Convert to use regmap_irq")
max77686_irq_init() return value was never checked so devices without
irq specified (like Hardkernel's Exynos4412 based ODROID-U3 board)
worked fine even though -ENODEV was returned by the function.  Add
handling for no irq specified case in max77686_i2c_probe() restoring
the previous driver's behavior.

The patch fixes boot for Hardkernel's Exynos4412 based ODROID-U3 board.

Error messages before the patch:
...
[    0.163995] max77686 0-0009: Failed to request IRQ 0 for max77686-pmic: -22
[    0.164020] max77686 0-0009: failed to add PMIC irq chip: -22
[    0.164478] max77686: probe of 0-0009 failed with error -22
...

Fixes: 6f1c1e71d933 ("mfd: max77686: Convert to use regmap_irq")
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
patch is against next-20140804 branch of linux-next kernel

 drivers/mfd/max77686.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 86e5523..5fe024c 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -314,6 +314,11 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
+	if (!max77686->irq) {
+		dev_info(max77686->dev, "irq is not specified\n");
+		goto skip_irq_setup;
+	}
+
 	ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
 				  IRQF_SHARED, 0, irq_chip,
@@ -332,6 +337,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		goto err_del_irqc;
 	}
 
+skip_irq_setup:
 	ret = mfd_add_devices(max77686->dev, -1, cells, n_devs, NULL, 0, NULL);
 	if (ret < 0) {
 		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
-- 
1.8.2.3


