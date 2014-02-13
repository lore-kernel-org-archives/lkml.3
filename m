Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaBMJTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:19:00 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59567 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaBMJO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:27 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c2-52fc8ceef2b2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 02/14] mfd: sec: Select different RTC regmaps for devices
Date: Thu, 13 Feb 2014 10:13:55 +0100
Message-id: <1392282847-25444-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t/xy7rvev4EGTS/UbTYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF6W5Wi4srvjA5cHrcubaHzWPeyUCPvi2rGD0+
	b5ILYInisklJzcksSy3St0vgypjcv5O1YKZAxbxd95kaGBfxdjFyckgImEhcWLmAGcIWk7hw
	bz1bFyMXh5DAUkaJ130rmSCcPiaJze1fmUCq2ASMJTYvXwJWJSKwmVFi8ferrCAOs8BRRonp
	vW/BqoQFfCROz7kDNpdFQFVi77/9bCA2r4C7xKk9q4DiHED7FCTmTLIBCXMKeEj8+/EbrFwI
	qKRn8Sz2CYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBNfXHYxLj1kdYhTgYFTi
	4X2w+HeQEGtiWXFl7iFGCQ5mJRFeGYk/QUK8KYmVValF+fFFpTmpxYcYmTg4pRoYN905KrFH
	+33jsp0Hmcsfpl5xe2sjM29hq1V/+rQJ/ZpLuC4/mB61zXuL+sGj+5KM1+2br2G49d3m40dn
	l7AZaX2yjhBbU5QQVlsi8+TWpVaGGT3qPJZKxx/Nrp782C3TYs5mV9bNRq2uWyd35zc2zvpX
	uf7Vy31ZK3Y1bXY7cIs/VVv0vYSdiBJLcUaioRZzUXEiAEuQBUEMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for adding support for S2MPS14 RTC driver by
selecting different regmaps for S2MPS1X/S5M876X RTC devices.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sec-core.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 6021c54f74cf..0efa69e123ee 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -199,7 +199,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
-	const struct regmap_config *regmap;
+	const struct regmap_config *regmap, *regmap_rtc;
 	struct sec_pmic_dev *sec_pmic;
 	int ret;
 
@@ -233,15 +233,25 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	switch (sec_pmic->device_type) {
 	case S2MPS11X:
 		regmap = &s2mps11_regmap_config;
+		/*
+		 * The rtc-s5m driver does not support S2MPS11 and there
+		 * is no mfd_cell for S2MPS11 RTC device.
+		 * However we must pass something to devm_regmap_init_i2c()
+		 * so use S5M-like regmap config even though it wouldn't work.
+		 */
+		regmap_rtc = &sec_rtc_regmap_config;
 		break;
 	case S5M8763X:
 		regmap = &s5m8763_regmap_config;
+		regmap_rtc = &sec_rtc_regmap_config;
 		break;
 	case S5M8767X:
 		regmap = &s5m8767_regmap_config;
+		regmap_rtc = &sec_rtc_regmap_config;
 		break;
 	default:
 		regmap = &sec_regmap_config;
+		regmap_rtc = &sec_rtc_regmap_config;
 		break;
 	}
 
@@ -260,8 +270,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	}
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
-	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc,
-			&sec_rtc_regmap_config);
+	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc, regmap_rtc);
 	if (IS_ERR(sec_pmic->regmap_rtc)) {
 		ret = PTR_ERR(sec_pmic->regmap_rtc);
 		dev_err(&i2c->dev, "Failed to allocate RTC register map: %d\n",
-- 
1.7.9.5

