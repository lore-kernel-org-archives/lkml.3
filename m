Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaD1Bbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42931 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lee Jones" <lee.jones@linaro.org>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.737500401@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 52/94] mfd: max8997: Fix possible NULL pointer
 dereference on i2c_new_dummy error
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mfd/max8997.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -148,10 +148,26 @@ static int max8997_i2c_probe(struct i2c_
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
@@ -178,7 +194,9 @@ static int max8997_i2c_probe(struct i2c_
 err_mfd:
 	mfd_remove_devices(max8997->dev);
 	i2c_unregister_device(max8997->muic);
+err_i2c_muic:
 	i2c_unregister_device(max8997->haptic);
+err_i2c_haptic:
 	i2c_unregister_device(max8997->rtc);
 err:
 	kfree(max8997);

