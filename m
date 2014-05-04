Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaEDQv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:51:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaEDPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 045/158] mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Sun,  4 May 2014 11:39:14 -0400
Message-Id: <20140504154036.116026867@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/max8925-i2c.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -181,9 +181,18 @@ static int max8925_probe(struct i2c_clie
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


