Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaBKKFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:05:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15526 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaBKKD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:03:56 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-92-52f9f589a7ab
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 6/7] mfd: max8997: Fix possible NULL pointer dereference on
 i2c_new_dummy error
Date: Tue, 11 Feb 2014 11:03:34 +0100
Message-id: <1392113015-11180-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7qdX38GGTyfIGmxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGGyWLDxEaMDl8eda3vYPOadDPTo
	27KK0ePzJrkAligum5TUnMyy1CJ9uwSujKm7f7AXnOKv2NA8lbGBsZu3i5GTQ0LARGLH1buM
	ELaYxIV769m6GLk4hASWMkpsvrqPFSQhJNDHJNHRog9iswkYS2xevgSsSERgM6PE4u9XWUEc
	ZoG7jBLNd9+DjRIWSJT4c3EjE4jNIqAq8eHzDBYQm1fAXeLp9AlAcQ6gdQoScybZgIQ5BTwk
	Vnw4wwyxzF2itf8u6wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQoLs6w7Gpces
	DjEKcDAq8fBqfP0RJMSaWFZcmXuIUYKDWUmEV+n4zyAh3pTEyqrUovz4otKc1OJDjEwcnFIN
	jLwvrfimXTa/2dUU9fWJ/cpvm48z1b1sDufjsCj1Ttsd/d9Zd96dSbmX9EXt/sXKevre2vvV
	cm3kzl1C+jr5Z/UmKkz/N1fYodv+iLN4/9ZXh5ofRd3pLRe6XRIc5XAl+Lvp2UzztxtTxA5N
	mfH1yWbB36Lrzi02VV1zP//uo8NW1acNeY4YnFFiKc5INNRiLipOBACf+q3NEAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates dummy I2C devices for RTC, haptic and
MUIC with i2c_new_dummy() but it does not check the return value of this
calls.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC, haptic or MUIC devices, fail also the
probe for main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/max8997.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index be88a3bf7b85..3ffc11dfc3b6 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -208,10 +208,26 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	mutex_init(&max8997->iolock);
 
 	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	if (!max8997->rtc) {
+		dev_err(max8997->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max8997->rtc, max8997);
+
 	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
+	if (!max8997->haptic) {
+		dev_err(max8997->dev, "Failed to allocate I2C device for Haptic\n");
+		ret = -ENODEV;
+		goto err_i2c_haptic;
+	}
 	i2c_set_clientdata(max8997->haptic, max8997);
+
 	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
+	if (!max8997->muic) {
+		dev_err(max8997->dev, "Failed to allocate I2C device for MUIC\n");
+		ret = -ENODEV;
+		goto err_i2c_muic;
+	}
 	i2c_set_clientdata(max8997->muic, max8997);
 
 	pm_runtime_set_active(max8997->dev);
@@ -239,7 +255,9 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 err_mfd:
 	mfd_remove_devices(max8997->dev);
 	i2c_unregister_device(max8997->muic);
+err_i2c_muic:
 	i2c_unregister_device(max8997->haptic);
+err_i2c_haptic:
 	i2c_unregister_device(max8997->rtc);
 	return ret;
 }
-- 
1.7.9.5

