Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaBQIkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:40:47 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37660 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBQIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:40:40 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-b5-5301cb066f16
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 02/13] mfd: sec: Select different RTC regmaps for devices
Date: Mon, 17 Feb 2014 09:40:16 +0100
Message-id: <1392626427-4518-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
References: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e/4FV2204zBBu+OSltsnLGe1eL1C0OL
	s01v2C3ufz3KaHF51xw2ixnn9zFZrD1yl93idDerxcUVX5gs1s94zWIxZ/o7JgdujzvX9rB5
	zDsZ6NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZk/t3shbMFKiYt+s+UwPjIt4uRk4OCQET
	icVNfcwQtpjEhXvr2UBsIYGljBIHjgp0MXIB2X1MEh93bGIESbAJGEtsXr6EDSQhIrCZUWLx
	96usIA6zwEwmiT83HzCBVAkL+Eh0nDsDZrMIqEpc7b/HDmLzCrhJzF/9GaibA2idgsScSTYg
	YU4Bd4mnfVNZQcJCQCX7N4ZNYORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk2L7u
	YFx6zOoQowAHoxIPr0E1Y7AQa2JZcWXuIUYJDmYlEV7bdUAh3pTEyqrUovz4otKc1OJDjEwc
	nFINjHFsfQoea2b33Hf++yLMu4i7mvHUl4fn58ysPeKWxXj/6oSnWzzOnps6hSct/XK8wPOE
	ydkndL80SIuzXmmdKr/0u+3HC3Lay2Zs/nrymcqNgJISlpXVRz38e41PfjA8cd3Qfpfguk2M
	hbK6fUeCjT9wMrTNUzzBp8RmtMI2IPyUrbhdmtj8Q0osxRmJhlrMRcWJAD+YZXIUAgAA
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

