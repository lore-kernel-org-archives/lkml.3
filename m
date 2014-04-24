Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaDXKpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:45:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaDXIxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 072/182] mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Thu, 24 Apr 2014 09:49:57 +0100
Message-Id: <1398329507-5911-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/max8925-i2c.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index 8042b32..edc9eac 100644
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
1.9.1

