Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3FDRhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:37:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42405 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3FDRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:37:33 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Grygorii Strashko <grygorii.strashko@ti.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH] i2c: Let users disable "Probe an I2C bus for certain devices"
Date: Tue, 4 Jun 2013 20:33:42 +0300
Message-ID: <1370367222-19353-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the I2C devices instantiation Method 3 "Probe an I2C bus for
certain devices" (see Documentation/i2c/instantiating-devices) is always
enabled for all platforms (boards) and can't be disabled.
This feature introduces a system boot time delay for boards,
where I2C devices topology is explicitly defined in DT or platform code
(Method 1 and Method 2 are used only) and especially when i2c-gpio is used.

For example:
When CONFIG_SENSORS_LM75 option was enabled for omap4-sdp board -
it introduces 5-6 ms boot delay.

When CONFIG_SENSORS_LM75 option was enabled for omap5-uevm board,
where i2c-gpio is used for HDMI edid reading - it introduces up to 5 sec boot
delay.

Hence, introduce CONFIG_I2C_DISABLE_DEVICE_DETECTION configuration option
to allow disabling of I2C devices instantiation Method 3 "Probe an I2C bus
for certain devices" if it's not needed (usually for embedded systems).

CC: linux-i2c@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-omap@vger.kernel.org
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/Kconfig    |   10 ++++++++++
 drivers/i2c/i2c-core.c |    6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index e380c6e..f7b220b 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -124,4 +124,14 @@ config I2C_DEBUG_BUS
 	  a problem with I2C support and want to see more of what is going
 	  on.
 
+config I2C_DISABLE_DEVICE_DETECTION
+	bool "I2C Disable device detection"
+	default n
+	help
+	  Say Y here, if you have explicitly defined I2C device topology in DT
+	  or platform code and don't need to detect presence of supported I2C
+	  devices automatically (Documentation/i2c/instantiating-devices -
+	  Method 1 and Method 2 are used only). Enabling this option allows to
+	  reduce system boot time, especially in case when i2c-gpio driver is used.
+
 endif # I2C
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 48e31ed..d5ab7a3 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -54,7 +54,9 @@ static DEFINE_MUTEX(core_lock);
 static DEFINE_IDR(i2c_adapter_idr);
 
 static struct device_type i2c_client_type;
+#ifndef CONFIG_I2C_DISABLE_DEVICE_DETECTION
 static int i2c_detect(struct i2c_adapter *adapter, struct i2c_driver *driver);
+#endif
 
 /* ------------------------------------------------------------------------- */
 
@@ -958,7 +960,9 @@ static int i2c_do_add_adapter(struct i2c_driver *driver,
 			      struct i2c_adapter *adap)
 {
 	/* Detect supported devices on that bus, and instantiate them */
+#ifndef CONFIG_I2C_DISABLE_DEVICE_DETECTION
 	i2c_detect(adap, driver);
+#endif
 
 	/* Let legacy drivers scan this bus for matching devices */
 	if (driver->attach_adapter) {
@@ -1672,6 +1676,7 @@ static int i2c_default_probe(struct i2c_adapter *adap, unsigned short addr)
 	return err >= 0;
 }
 
+#ifndef CONFIG_I2C_DISABLE_DEVICE_DETECTION
 static int i2c_detect_address(struct i2c_client *temp_client,
 			      struct i2c_driver *driver)
 {
@@ -1760,6 +1765,7 @@ static int i2c_detect(struct i2c_adapter *adapter, struct i2c_driver *driver)
 	kfree(temp_client);
 	return err;
 }
+#endif
 
 int i2c_probe_func_quick_read(struct i2c_adapter *adap, unsigned short addr)
 {
-- 
1.7.9.5

