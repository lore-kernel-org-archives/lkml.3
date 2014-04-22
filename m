Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaDVUYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:24:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaDVUYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 079/133] mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Tue, 22 Apr 2014 13:13:37 -0700
Message-Id: <1398197671-12786-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 97dc4ed3fa377ec91bb60ba98b70d645c2099384 upstream.

During probe the driver allocates dummy I2C devices for RTC, haptic and
MUIC with i2c_new_dummy() but it does not check the return value of this
calls.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC, haptic or MUIC devices, fail also the
probe for main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/max8997.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 1471405..ea1defbc 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -218,10 +218,26 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	mutex_init(&max8997->iolock);
 
 	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	if (!max8997->rtc) {
+		dev_err(max8997->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max8997->rtc, max8997);
+
 	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
+	if (!max8997->haptic) {
+		dev_err(max8997->dev, "Failed to allocate I2C device for Haptic\n");
+		ret = -ENODEV;
+		goto err_i2c_haptic;
+	}
 	i2c_set_clientdata(max8997->haptic, max8997);
+
 	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
+	if (!max8997->muic) {
+		dev_err(max8997->dev, "Failed to allocate I2C device for MUIC\n");
+		ret = -ENODEV;
+		goto err_i2c_muic;
+	}
 	i2c_set_clientdata(max8997->muic, max8997);
 
 	pm_runtime_set_active(max8997->dev);
@@ -248,7 +264,9 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 err_mfd:
 	mfd_remove_devices(max8997->dev);
 	i2c_unregister_device(max8997->muic);
+err_i2c_muic:
 	i2c_unregister_device(max8997->haptic);
+err_i2c_haptic:
 	i2c_unregister_device(max8997->rtc);
 err:
 	kfree(max8997);
-- 
1.9.1

