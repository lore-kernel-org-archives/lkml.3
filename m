Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbaEMKF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:05:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60788 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760063AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 039/182] mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Tue, 13 May 2014 11:26:31 +0200
Message-Id: <af8be7f09d086ffb075921614f5c2f2a8d968a22.1399973152.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/max77693.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index c04723efc707..8abfd3f0af5b 100644
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
1.9.3

