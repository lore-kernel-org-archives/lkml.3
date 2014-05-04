Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaEDQwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:52:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaEDPlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 043/158] mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Sun,  4 May 2014 11:39:12 -0400
Message-Id: <20140504154035.842457255@linuxfoundation.org>
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

commit b9e183a1d495cd65412abe0f9df19b151716bfe7 upstream.

During probe the driver allocates dummy I2C device for RTC with
i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for main
MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/max77686.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -121,6 +121,10 @@ static int max77686_i2c_probe(struct i2c
 		dev_info(max77686->dev, "device found\n");
 
 	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	if (!max77686->rtc) {
+		dev_err(max77686->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max77686->rtc, max77686);
 
 	max77686_irq_init(max77686);


