Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaBJKEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:04:32 -0500
Received: from sauhun.de ([89.238.76.85]:38531 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaBJKE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:28 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/17] i2c: add deprecation warning for class based instantiation
Date: Mon, 10 Feb 2014 11:03:56 +0100
Message-Id: <1392026654-5343-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Class based instantiation can cause noticeable delays when booting. This
mechanism is used when it is not possible to describe slaves on I2C
busses. As we do have other mechanisms, most embedded I2C will not need
classes and for embedded it is explicitly not recommended to use them. Add
a deprecation warning for drivers which want to disable class based
instantiation in the near future to gain boot-up time, so users relying
on this technique can switch to something better. They really should.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: linux-arm-kernel@lists.infradead.org
---

 drivers/i2c/i2c-core.c | 7 +++++++
 include/linux/i2c.h    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d74c0b3..42fcc59 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1935,6 +1935,13 @@ static int i2c_detect_address(struct i2c_client *temp_client,
 		struct i2c_client *client;
 
 		/* Detection succeeded, instantiate the device */
+		if (adapter->class & I2C_CLASS_DEPRECATED)
+			dev_warn(&adapter->dev,
+				"This adapter will soon drop class based instantiation of devices. "
+				"Please make sure client 0x%02x gets instantiated by other means. "
+				"Check 'Documentation/i2c/instantiating-devices' for details.\n",
+				info.addr);
+
 		dev_dbg(&adapter->dev, "Creating %s at 0x%02x\n",
 			info.type, info.addr);
 		client = i2c_new_device(adapter, &info);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index d9c8dbd3..b9e1707 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -473,6 +473,7 @@ void i2c_unlock_adapter(struct i2c_adapter *);
 #define I2C_CLASS_HWMON		(1<<0)	/* lm_sensors, ... */
 #define I2C_CLASS_DDC		(1<<3)	/* DDC bus on graphics adapters */
 #define I2C_CLASS_SPD		(1<<7)	/* Memory modules */
+#define I2C_CLASS_DEPRECATED	(1<<8)	/* Warn users that adapter will stop using classes */
 
 /* Internal numbers to terminate lists */
 #define I2C_CLIENT_END		0xfffeU
-- 
1.8.5.1

