Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaBKJO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:14:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24793 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBKJOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:14:21 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e0-52f9e9ea265d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] mfd: sec-core: Fix possible NULL pointer dereference when
 i2c_new_dummy error
Date: Tue, 11 Feb 2014 10:12:25 +0100
Message-id: <1392109945-333-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xK7qvXv4MMth/VcRi44z1rBavXxha
	nG16w25x/+tRRovLu+awWcw4v4/JYu2Ru+wWp7tZLS6u+MJksWDjI0YHLo871/awecw7GejR
	t2UVo8fnTXIBLFFcNimpOZllqUX6dglcGU87vjMWPOSoWPV4E1MD4xr2LkZODgkBE4nXP+Yw
	Q9hiEhfurWcDsYUEljJK3J3M2sXIBWT3MUmced/OCJJgEzCW2Lx8CRtIQkRgM6PE4u9XwaqY
	Be4ySjTffQ9WJSyQILH88nVWEJtFQFViyq+bYHFeAVeJHQsvAK3jAFqnIDFnks0ERu4FjAyr
	GEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKC5ssOxsXHrA4xCnAwKvHwblD8GSTEmlhWXJl7
	iFGCg1lJhFfpOFCINyWxsiq1KD++qDQntfgQIxMHp1QD4/yEN9c2hvbtrRWP0V8i2uWklczP
	E6X9pD/0uEhL3ZfXgqd01t33tl9/u+5mo1Cnpe28pmctoYcDmH+HXxAoWeKpu6/BZoaaiVN5
	xwFZBb4bPfdmLih8z314yUEFtzupx/hPh1ox/3+fvePs7FsMobu6vi2pVbvIt8OoTLX/z9O+
	9dMC2R+6KrEUZyQaajEXFScCAOp6bJr4AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the sec-core driver allocates dummy I2C device for RTC with
i2c_new_dummy() but return value is not checked. In case of error
(i2c_new_device(): memory allocation failure or I2C address cannot be
used) this function returns NULL which is later used by
devm_regmap_init_i2c() or i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for main
MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/sec-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index a139798b8065..7c6ce2e4aaa6 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -252,6 +252,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	}
 
 	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	if (!sec_pmic->rtc) {
+		dev_err(&i2c->dev, "Failed to allocate I2C for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
 	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc,
-- 
1.7.9.5

