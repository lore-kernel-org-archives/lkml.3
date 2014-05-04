Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaEDPmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaEDPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.10 26/86] mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Sun,  4 May 2014 11:41:01 -0400
Message-Id: <20140504154143.947409199@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit ad09dd6a1f5d6244bd89314015af506ba7f9810a upstream.

During probe the driver allocates dummy I2C devices for MUIC and haptic
with i2c_new_dummy() but it does not check the return value of this
calls.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by devm_regmap_init_i2c() and i2c_unregister_device().

If i2c_new_dummy() fails for MUIC or haptic devices, fail also the probe
for main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/max77693.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -149,9 +149,18 @@ static int max77693_i2c_probe(struct i2c
 		dev_info(max77693->dev, "device ID: 0x%x\n", reg_data);
 
 	max77693->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
+	if (!max77693->muic) {
+		dev_err(max77693->dev, "Failed to allocate I2C device for MUIC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max77693->muic, max77693);
 
 	max77693->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
+	if (!max77693->haptic) {
+		dev_err(max77693->dev, "Failed to allocate I2C device for Haptic\n");
+		ret = -ENODEV;
+		goto err_i2c_haptic;
+	}
 	i2c_set_clientdata(max77693->haptic, max77693);
 
 	/*
@@ -187,8 +196,9 @@ err_mfd:
 	max77693_irq_exit(max77693);
 err_irq:
 err_regmap_muic:
-	i2c_unregister_device(max77693->muic);
 	i2c_unregister_device(max77693->haptic);
+err_i2c_haptic:
+	i2c_unregister_device(max77693->muic);
 	return ret;
 }
 


