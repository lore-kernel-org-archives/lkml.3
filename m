Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3HUQx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:53:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24828 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3HUQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:53:53 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-00-5214f09f8bd6
From: Andrzej Hajda <a.hajda@samsung.com>
To: lee.jones@linaro.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/2] max77693: remove device wakeup from driver
Date: Wed, 21 Aug 2013 18:53:33 +0200
Message-id: <1377104014-21910-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t/xa7rzP4gEGZxZLWdxa905Vov5R4DE
	gT87GC3e9HawWHSefcJscbbpDbvF/a9HGS0u75rDZrH0+kUmiwnT17JYHF5xgMli3cvpQNab
	dlaL092sFq8OtrE48HusmbeG0WPB5yvsHq8nT2D0eLV6JqvHnWt72DzmnQz06NuyitHj8yY5
	j41zQwM4o7hsUlJzMstSi/TtErgyHj+Yy1zwQqji2Ovd7A2Mm/m7GDk5JARMJBb9+sUMYYtJ
	XLi3nq2LkYtDSGApo8TlpuWsEE4fk8SHL8+ZQKrYBDQl/m6+yQZiiwhISGz80ccCUsQscIpF
	Ym7rbbAiYQEniS3fT7CD2CwCqhK7e/exgNi8As4S2yZPZIVYpyDx8/IJsEGcAi4SbX/vgdUL
	AdW0XFjMMoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkFD+uoNx6TGrQ4wCHIxK
	PLwXdooECbEmlhVX5h5ilOBgVhLhLTwJFOJNSaysSi3Kjy8qzUktPsTIxMEp1cBolJp3eLpC
	269Lkg8mHC7uyfEX3jD728r7h3UZLY7k7//3YIWTYya3YminY4Rbd+H0n5OK/I+biM97nNEY
	zP70is4b3d3XUkuuPtwUXmoWsnTjpfyNxxvm6QltSGOcWddv1jN/B1v0iUk+7HVm5TfVuA0q
	XnLG/Zgj/jHE9dXO5yu32S6PZVysxFKckWioxVxUnAgAxJJMLkMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes wakeup related code from
the driver and plaftorm data - it is already
handled by i2c core using I2C_CLIENT_WAKE flag
from struct i2c_board_info. As a result MFD
itself do not requires platform data.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max77693.c               | 10 ----------
 include/linux/mfd/max77693-private.h |  1 -
 include/linux/mfd/max77693.h         |  2 --
 3 files changed, 13 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 9e60fed..27f5da3 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -110,15 +110,9 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct max77693_dev *max77693;
-	struct max77693_platform_data *pdata = i2c->dev.platform_data;
 	u8 reg_data;
 	int ret = 0;
 
-	if (!pdata) {
-		dev_err(&i2c->dev, "No platform data found.\n");
-		return -EINVAL;
-	}
-
 	max77693 = devm_kzalloc(&i2c->dev,
 			sizeof(struct max77693_dev), GFP_KERNEL);
 	if (max77693 == NULL)
@@ -138,8 +132,6 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	max77693->wakeup = pdata->wakeup;
-
 	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_PMIC_ID2,
 				&reg_data);
 	if (ret < 0) {
@@ -179,8 +171,6 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_mfd;
 
-	device_init_wakeup(max77693->dev, pdata->wakeup);
-
 	return ret;
 
 err_mfd:
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 244fb0d..3e050b9 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -323,7 +323,6 @@ struct max77693_dev {
 
 	int irq;
 	int irq_gpio;
-	bool wakeup;
 	struct mutex irqlock;
 	int irq_masks_cur[MAX77693_IRQ_GROUP_NR];
 	int irq_masks_cache[MAX77693_IRQ_GROUP_NR];
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index 676f0f3..3f3dc45 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -64,8 +64,6 @@ struct max77693_muic_platform_data {
 };
 
 struct max77693_platform_data {
-	int wakeup;
-
 	/* regulator data */
 	struct max77693_regulator_data *regulators;
 	int num_regulators;
-- 
1.8.1.2

