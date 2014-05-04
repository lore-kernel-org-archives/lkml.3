Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaEDQxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:53:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaEDPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 039/158] mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
Date: Sun,  4 May 2014 11:39:08 -0400
Message-Id: <20140504154035.281779226@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 65aba1e04916d72b30c028730a1e31860c225412 upstream.

During probe the sec-core driver allocates dummy I2C device for RTC with
i2c_new_dummy() but return value is not checked. In case of error
(i2c_new_device(): memory allocation failure or I2C address cannot be
used) this function returns NULL which is later used by
devm_regmap_init_i2c() or i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for main
MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/sec-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -252,6 +252,10 @@ static int sec_pmic_probe(struct i2c_cli
 	}
 
 	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	if (!sec_pmic->rtc) {
+		dev_err(&i2c->dev, "Failed to allocate I2C for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
 	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc,


