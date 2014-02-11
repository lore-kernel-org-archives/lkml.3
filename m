Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaBKKEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:04:06 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28147 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaBKKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:03:54 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ee-52f9f587eabc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 3/7] mfd: max77686: Fix possible NULL pointer dereference on
 i2c_new_dummy error
Date: Tue, 11 Feb 2014 11:03:31 +0100
Message-id: <1392113015-11180-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7rtX38GGfxYYW6xccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGGyWLDxEaMDl8eda3vYPOadDPTo
	27KK0ePzJrkAligum5TUnMyy1CJ9uwSujNvt99gL3nNUTJvyhamBcQt7FyMnh4SAicSpFQ/Z
	IGwxiQv31gPZXBxCAksZJdq6FzFDOH1MEv/m3GAGqWITMJbYvHwJWJWIwGZGicXfr7KCOMwC
	dxklmu++Z+xi5OAQFkiSaJpQAtLAIqAqsfDUTVYQm1fAXWLH5wOsICUSAgoScybZgIQ5BTwk
	Vnw4AzZfCKiktf8u6wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoLsyw7Gxces
	DjEKcDAq8fBuUPwZJMSaWFZcmXuIUYKDWUmEV+k4UIg3JbGyKrUoP76oNCe1+BAjEwenVAPj
	nM8mC/48+b6kLrvrw49Nq7bOvnsndsvD92un/JdreFX6vcXU8Mu59idbkzy4itxDWxsLdqid
	FVmbXy4qPl1gu99B29/Nt9Jnrtv3LJH3+4tu7XWnXhXKqRVLb8hK7nq3z3rH7o8XBW8U8x0/
	v/K8xY7LBeeP7NyxTWZBU9/+DRYF3QY7/2qUrFFiKc5INNRiLipOBADfDmI3EAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates dummy I2C device for RTC with
i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for main
MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/max77686.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index f53d5823a3f7..e5fce765accb 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -121,6 +121,10 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		dev_info(max77686->dev, "device found\n");
 
 	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	if (!max77686->rtc) {
+		dev_err(max77686->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max77686->rtc, max77686);
 
 	max77686_irq_init(max77686);
-- 
1.7.9.5

