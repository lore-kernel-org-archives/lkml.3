Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaDGMRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:17:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42949 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbaDGMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:17:41 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-84-53429763ee08
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] regulator: s5m8767: Remove regulator_dev pointer from
 state container
Date: Mon, 07 Apr 2014 14:15:24 +0200
Message-id: <1396872924-14675-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396872924-14675-1-git-send-email-k.kozlowski@samsung.com>
References: <1396872924-14675-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t/xK7rJ052CDXY/YrTYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eLblQ4mi8u75rBZzDi/j8li7ZG77BYXV3xhslg/4zWLA5fHzll32T02repk
	8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6MK5+usxVcFalo3trB2MB4S6CLkZNDQsBEYvWM
	ZUwQtpjEhXvr2boYuTiEBJYySty81M8I4fQxSSz6cIoFpIpNwFhi8/IlYFUiAhsZJQ7uP8wK
	kmAWeM4o8fR7OIgtLBAjsf3ZQkYQm0VAVWLJgwvsIDavgLvEhyXngQZxAK1TkJgzyQYkzCng
	IXHw0lE2EFsIqGT9kuVsExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICbSvOxiX
	HrM6xCjAwajEwxtwwDFYiDWxrLgy9xCjBAezkgivYZdTsBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQbGyoTgY7xrGqyM2OqPTe5wOx+29tq6tS+WF/RWH1mw9vrEXu51dSu/uh/xa/wQzVGzVkk5
	iee4vxvTtHV18zWTXir47ZebHjOr8Ur9pjdOW773b5/b9f3Zwplu+RPTPpV7PXN/NE2Ig/Xr
	0503JQ1vzN9l1BThtNbsk5aRaHPAs935RQ/LLxd8VWIpzkg01GIuKk4EAEeIfLcSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store pointer to regulator_dev returned by
devm_regulator_register() in state container. It isn't used anywhere
outside of probe.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s5m8767.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 92f19a005dc3..5daa06626f16 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -28,7 +28,6 @@ struct s5m8767_info {
 	struct device *dev;
 	struct sec_pmic_dev *iodev;
 	int num_regulators;
-	struct regulator_dev **rdev;
 	struct sec_opmode_data *opmode;
 
 	int ramp_delay;
@@ -695,7 +694,6 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct sec_platform_data *pdata = iodev->pdata;
 	struct regulator_config config = { };
-	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
 	int i, ret, size, buck_init;
 
@@ -737,11 +735,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	size = sizeof(struct regulator_dev *) * (S5M8767_REG_MAX - 2);
-	s5m8767->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
-	if (!s5m8767->rdev)
-		return -ENOMEM;
 
-	rdev = s5m8767->rdev;
 	s5m8767->dev = &pdev->dev;
 	s5m8767->iodev = iodev;
 	s5m8767->num_regulators = pdata->num_regulators;
@@ -938,6 +932,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		const struct sec_voltage_desc *desc;
 		int id = pdata->regulators[i].id;
 		int enable_reg, enable_val;
+		struct regulator_dev *rdev;
 
 		desc = reg_voltage_map[id];
 		if (desc) {
@@ -969,21 +964,21 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 			s5m8767_regulator_config_ext_control(s5m8767,
 					&pdata->regulators[i], &config);
 
-		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
+		rdev = devm_regulator_register(&pdev->dev, &regulators[id],
 						  &config);
-		if (IS_ERR(rdev[i])) {
-			ret = PTR_ERR(rdev[i]);
+		if (IS_ERR(rdev)) {
+			ret = PTR_ERR(rdev);
 			dev_err(s5m8767->dev, "regulator init failed for %d\n",
 					id);
 			return ret;
 		}
 
 		if (pdata->regulators[i].ext_control_gpio) {
-			ret = s5m8767_enable_ext_control(s5m8767, rdev[i]);
+			ret = s5m8767_enable_ext_control(s5m8767, rdev);
 			if (ret < 0) {
 				dev_err(s5m8767->dev,
 						"failed to enable gpio control over %s: %d\n",
-						rdev[i]->desc->name, ret);
+						rdev->desc->name, ret);
 				return ret;
 			}
 		}
-- 
1.7.9.5

