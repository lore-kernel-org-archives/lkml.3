Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaFDMKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:10:32 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35696 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaFDMK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:10:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/7] OF/ACPI/I2C: Add generic match function for the aforementioned systems
Date: Wed,  4 Jun 2014 13:09:56 +0100
Message-Id: <1401883796-17841-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this is a helper function for the I2C subsystem to aid the
matching of non-standard compatible strings and devices which use DT
and/or ACPI, but do not supply any nodes (see: [1] Method 4).  However,
it has been made more generic as it can be used to only make one call
for drivers which support any mixture of OF, ACPI and/or I2C matching.

The initial aim is for of_match_device() to be replaced by this call
in all I2C device drivers.

[1] Documentation/i2c/instantiating-devices

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/match.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 include/linux/match.h

diff --git a/include/linux/match.h b/include/linux/match.h
new file mode 100644
index 0000000..20a08e2
--- /dev/null
+++ b/include/linux/match.h
@@ -0,0 +1,40 @@
+#include <linux/of.h>
+#include <linux/acpi.h>
+#include <linux/i2c.h>
+
+static void *device_match(struct device *dev)
+{
+	struct device_driver *driver = dev->driver;
+
+	if (!driver)
+		return NULL;
+
+	/* Attempt an OF style match */
+	if (IS_ENABLED(CONFIG_OF)) {
+		const struct of_device_id *of_match =
+			i2c_of_match_device(driver->of_match_table, dev);
+		if (of_match)
+			return (void *)of_match;
+	}
+
+	/* Then ACPI style match */
+	if (IS_ENABLED(CONFIG_ACPI)) {
+		const struct acpi_device_id *acpi_match	=
+			acpi_match_device(driver->acpi_match_table, dev);
+		if (acpi_match)
+			return (void *)acpi_match;
+	}
+
+	/* Finally an I2C match */
+	if (IS_ENABLED(CONFIG_I2C)) {
+		struct i2c_client *client = i2c_verify_client(dev);
+		struct i2c_driver *i2c_drv = to_i2c_driver(driver);
+		struct i2c_device_id *i2c_match;
+
+		i2c_match = i2c_match_id(i2c_drv->id_table, client);
+		if (i2c_match)
+			return (void *)i2c_match;
+	}
+
+	return NULL;
+}
-- 
1.8.3.2

