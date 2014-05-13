Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaEMKJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:09:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60782 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760054AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/182] mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
Date: Tue, 13 May 2014 11:26:26 +0200
Message-Id: <9464b64b90d64f38fe7874b9a61d340af2df9567.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/sec-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index f530e4b73f19..d02546b0a8cc 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -274,6 +274,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	}
 
 	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	if (!sec_pmic->rtc) {
+		dev_err(&i2c->dev, "Failed to allocate I2C for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
 	if (pdata && pdata->cfg_pmic_irq)
-- 
1.9.3

