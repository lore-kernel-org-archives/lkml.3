Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbaEMKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:09:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60785 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760055AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/182] mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Tue, 13 May 2014 11:26:32 +0200
Message-Id: <85dce77e8704c6cbbab702449a648b225e742795.1399973152.git.jslaby@suse.cz>
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

commit 96cf3dedc491d2f1f66cc26217f2b06b0c7b6797 upstream.

During probe the driver allocates dummy I2C devices for RTC and ADC
with i2c_new_dummy() but it does not check the return value of this
calls.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC or ADC devices, fail also the probe
for main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/max8925-i2c.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index de7fb80a6052..afd07718dcab 100644
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
1.9.3

