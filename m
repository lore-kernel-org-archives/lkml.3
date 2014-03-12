Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaCLPvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:51:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15664 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaCLPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:50:56 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-7b-5320825d2be0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] mfd: tps65910: Fix regmap_irq_chip_data leak on
 mfd_add_devices fail
Date: Wed, 12 Mar 2014 16:50:45 +0100
Message-id: <1394639445-7737-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394639445-7737-1-git-send-email-k.kozlowski@samsung.com>
References: <1394639445-7737-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xy7qxTQrBBr2LeS1evzC0uP/1KKPF
	5V1z2CxOd7M6sHjcubaHzWPeyUCPvi2rGD0+b5ILYInisklJzcksSy3St0vgyvh3YSJjwUz2
	iqXT7RoYn7J2MXJySAiYSCxu2MEGYYtJXLi3Hsjm4hASWMoo8Xv1fWYIp49J4unO88wgVWwC
	xhKbly8B6xARyJL4MW01C4jNLGAo8fPdH3YQW1ggWuLttCmMIDaLgKrE4o2LwbbxCrhJNOzc
	BDSHA2ibgsScSTYgYU4Bd4kPXbvBwkJAJYfu1k9g5F3AyLCKUTS1NLmgOCk910ivODG3uDQv
	XS85P3cTIyREvu5gXHrM6hCjAAejEg/vTCX5YCHWxLLiytxDjBIczEoivE8LFYKFeFMSK6tS
	i/Lji0pzUosPMTJxcEo1MK7mPaZ8PWFl26/6pN12s/tjfkbv2GS3uXJHFrPU19S9vVp665Pe
	Lb/K8+XSir9z/019N2frtDnHzsWFabubrYiTOZu/pGChqnMq0/Fn+/8u3FoY+uPXMqcp91vq
	LgqtURfa6c58Jn7prm63TQItzrvsv8VZ3FkdtTl31vvlVknOeQ7Wqlo/nRYpsRRnJBpqMRcV
	JwIAUeHbeO8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65910_i2c_probe() allocates regmap_irq_chip in
tps65910_irq_init() but it does not clean this up in case of
mfd_add_devices() failure.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/tps65910.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d6573318977f..460a014ca629 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -507,14 +507,15 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(tps65910->dev, -1,
 			      tps65910s, ARRAY_SIZE(tps65910s),
 			      NULL, 0,
 			      regmap_irq_get_domain(tps65910->irq_data));
 	if (ret < 0) {
 		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
+		tps65910_irq_exit(tps65910);
 		return ret;
 	}
 
 	return ret;
 }
 
 static int tps65910_i2c_remove(struct i2c_client *i2c)
-- 
1.7.9.5

