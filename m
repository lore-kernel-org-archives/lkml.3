Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaBKNEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:04:21 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39608 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaBKNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:15 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-1f-52fa1fcc76c7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 02/14] mfd: sec: Select different RTC regmaps for devices
Date: Tue, 11 Feb 2014 14:03:45 +0100
Message-id: <1392123837-5517-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xK7pn5H8FGby+qmOxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGFy4PS4c20Pm8e8k4EefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlfH94ULmgrf8FUfWvGJtYPzN08XIySEhYCJx7uBHdghbTOLC
	vfVsXYxcHEICSxkljpy5zwrh9DFJ/Dx9CayKTcBYYvPyJWBVIgKbGSUWf78KVsUscJRRYnrv
	WyaQKmEBT4ktv2+xgdgsAqoSB+/NAYvzCrhJNO3dxtjFyAG0T0FiziQbkDCngLtE36f/bCBh
	IaCS5f2xExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICa2vOxiXHrM6xCjAwajE
	w6vx9UeQEGtiWXFl7iFGCQ5mJRHeL8K/goR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwNn4yUIzw
	zKsojXbl46i5L7RAU+bPkQ2CcjK12y6tXNmaz6ZkFv7r9IFf7Py7+P/tm/ROL2pb1cRVBWkO
	ibstTpecsr8cstjGsHaZjajHeoatcTNUzm9mORGbenXpr+n/r20QbXlaku8x9aPOxp7P8Ysn
	ivqesm9NCis/vVNA4NBRD6+FW3mdlViKMxINtZiLihMBtlXsvAsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for adding support for S2MPS14 RTC driver by
selecting different regmaps for S2MPS1X/S5M876X RTC devices.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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

