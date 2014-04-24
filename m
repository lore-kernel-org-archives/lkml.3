Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaDXIxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46599 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaDXIxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/182] mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Thu, 24 Apr 2014 09:50:00 +0100
Message-Id: <1398329507-5911-76-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/max77693.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 9e60fed..299970f 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -149,9 +149,18 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
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
 
-- 
1.9.1

