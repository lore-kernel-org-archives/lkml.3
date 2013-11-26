Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3KZNu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:50:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62485 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3KZNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:50:41 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-91-5294a72f61cd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/5] rtc: s5m: Fix register updating by adding regmap for RTC
Date: Tue, 26 Nov 2013 14:50:24 +0100
Message-id: <1385473828-31078-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4FV395VOCDKacYbZYcvEqu8WzW3uZ
	LF6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF/s4ORovT3awWF1d8YXLg8tgz8SSbx51re9g8
	Dh3uYPSYdzLQo2/LKkaP6fN+Mnl83iQXwB7FZZOSmpNZllqkb5fAlbFn1zfWgiPCFXM/H2Vp
	YJwo0MXIySEhYCLxcOdDFghbTOLCvfVsXYxcHEICSxkl5jV0M0M4fUwS/ya+ZQKpYhMwlti8
	fAlYlYjAVUaJiUsWs4M4zAK7GCXe/tzFCFIlLOAr8eD6TrC5LAKqEivWbmADsXkF3CWerN4B
	VMMBtE9BYs4kG5Awp4CHxMyeZWDlQkAl5w7uYprAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWle
	ul5yfu4mRkgQft3BuPSY1SFGAQ5GJR5eic7JQUKsiWXFlbmHGCU4mJVEeGOnTwkS4k1JrKxK
	LcqPLyrNSS0+xMjEwSnVwLhWbuaDm80npLaWBq0ovbHw69U3eW9t9jUvyGkPTd7XXNI688vC
	gsy1VwviJ3tXc4Syywuxp+8IW1/cw8/aIHsupGTB4/5vbPKdyjtPnyiNnL9UU+JScb52VfKu
	bdOWr5ap6Fu6UPX9Lf3ZL2fNcZ1zwNYl0/OK4zYWQeO3i+5Uf/M93PznwHMlluKMREMt5qLi
	RADa1fWdIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On S5M8767A registers were not properly updated and read due to usage of
the same regmap as the PMIC. This could be observed in various hangs,
e.g. in infinite loop during waiting for UDR field change.

On this chip family the RTC has different I2C address than PMIC so
additional regmap is needed.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/sec-core.c           |   14 ++++++++++++++
 drivers/rtc/rtc-s5m.c            |    2 +-
 include/linux/mfd/samsung/core.h |    1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 34c18fb..a1a413a 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -166,6 +166,11 @@ static struct regmap_config s5m8767_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
+static struct regmap_config sec_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
 #ifdef CONFIG_OF
 /*
  * Only the common platform data elements for s5m8767 are parsed here from the
@@ -277,6 +282,15 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
+	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc,
+			&sec_rtc_regmap_config);
+	if (IS_ERR(sec_pmic->regmap_rtc)) {
+		ret = PTR_ERR(sec_pmic->regmap_rtc);
+		dev_err(&i2c->dev, "Failed to allocate RTC register map: %d\n",
+			ret);
+		return ret;
+	}
+
 	if (pdata && pdata->cfg_pmic_irq)
 		pdata->cfg_pmic_irq();
 
diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 1dfa488..088cf3a 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -542,7 +542,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->regmap = s5m87xx->regmap;
+	info->regmap = s5m87xx->regmap_rtc;
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 2d0c907..692acad 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -40,6 +40,7 @@ struct sec_pmic_dev {
 	struct device *dev;
 	struct sec_platform_data *pdata;
 	struct regmap *regmap;
+	struct regmap *regmap_rtc;
 	struct i2c_client *i2c;
 	struct i2c_client *rtc;
 
-- 
1.7.9.5

