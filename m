Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaBKKFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:05:51 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22473 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBKKDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:03:55 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f4-52f9f58858da
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 5/7] mfd: max8925: Fix possible NULL pointer dereference on
 i2c_new_dummy error
Date: Tue, 11 Feb 2014 11:03:33 +0100
Message-id: <1392113015-11180-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7odX38GGVxfaWqxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGGyWLDxEaMDl8eda3vYPOadDPTo
	27KK0ePzJrkAligum5TUnMyy1CJ9uwSujF8bLjIWNHBXfFq6iLWBcTpnFyMnh4SAicSnvhms
	ELaYxIV769m6GLk4hASWMkrc/XyICcLpY5J4u2YnI0gVm4CxxOblS8CqRAQ2M0os/n6VFcRh
	FrjLKNF89z1QFQeHsECixJF7SiANLAKqEiuXnWQHsXkF3CV+dJ9lBymREFCQmDPJBiTMKeAh
	seLDGWYQWwiopLX/LusERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKC7MsOxsXH
	rA4xCnAwKvHwblD8GSTEmlhWXJl7iFGCg1lJhFfpOFCINyWxsiq1KD++qDQntfgQIxMHp1QD
	Y8XSrrmSElYHN91fnHe9ONssbVJ263rL2qir0/Z/nLYm9V7yz7mu+7aVm3W/qymwtuBaH7FO
	7uKD/IeHXmWvOPT56KdzKbqxD1eFTy688zqUz4j5pdghDhev51n37uxL2/g04HKY8ISjklqx
	ApVKj7l/6jZEsYj0GZiJ/WfRnJT0znKdhbPQWyWW4oxEQy3mouJEAPNaDSIQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates dummy I2C devices for RTC and ADC
with i2c_new_dummy() but it does not check the return value of this
calls.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC or ADC devices, fail also the probe
for main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/max8925-i2c.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index 176aa26fc787..a83eed5c15ca 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -181,9 +181,18 @@ static int max8925_probe(struct i2c_client *client,
 	mutex_init(&chip->io_lock);
 
 	chip->rtc = i2c_new_dummy(chip->i2c->adapter, RTC_I2C_ADDR);
+	if (!chip->rtc) {
+		dev_err(chip->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(chip->rtc, chip);
 
 	chip->adc = i2c_new_dummy(chip->i2c->adapter, ADC_I2C_ADDR);
+	if (!chip->adc) {
+		dev_err(chip->dev, "Failed to allocate I2C device for ADC\n");
+		i2c_unregister_device(chip->rtc);
+		return -ENODEV;
+	}
 	i2c_set_clientdata(chip->adc, chip);
 
 	device_init_wakeup(&client->dev, 1);
-- 
1.7.9.5

