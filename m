Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaANIru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:47:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:63516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaANIqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:46:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,657,1384329600"; 
   d="scan'208";a="464783240"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
Cc: wsa@the-dreams.de, broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 2/4] ACPI: add module autoloading support for ACPI enumerated devices
Date: Tue, 14 Jan 2014 16:46:36 +0800
Message-Id: <1389689198-2641-3-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An ACPI enumerated device may have its compatible id strings.

To support the compatible ACPI ids (acpi_device->pnp.ids),
we introduced acpi_driver_match_device() to match
the driver->acpi_match_table and acpi_device->pnp.ids.

For those drivers, MODULE_DEVICE_TABLE(acpi, xxx) is used to
exports the driver module alias in the format of
"acpi:device_compatible_ids".
But in the mean time, the current code does not export the
ACPI compatible strings as part of the module_alias for the
ACPI enumerated devices, which will break the module autoloading.

Take the following piece of code for example,
static const struct acpi_device_id xxx_acpi_match[] = {
        { "INTABCD", 0 },
        { }
};
MODULE_DEVICE_TABLE(acpi, xxx_acpi_match);

If this piece of code is used in a platform driver for
an ACPI enumerated platform device, the platform driver module_alias
is "acpi:INTABCD", but the uevent attribute of its platform device node
is "platform:INTABCD:00" (PREFIX:platform_device->name).
If this piece of code is used in an i2c driver for an ACPI enumerated
i2c device, the i2c driver module_alias is "acpi:INTABCD", but
the uevent of its i2c device node is "i2c:INTABCD:00" (PREFIX:i2c_client->name).
If this piece of code is used in an spi driver for an ACPI enumerated
spi device, the spi driver module_alias is "acpi:INTABCD", but
the uevent of its spi device node is "spi:INTABCD" (PREFIX:spi_device->modalias).

The reason why the module autoloading is not broken for now is that
the uevent file of the ACPI device node is "acpi:INTABCD".
Thus it is the ACPI device node creation that loads the platform/i2c/spi driver.

So this is a problem that will affect us the day when the ACPI bus
is removed from device model.

This patch introduces two new APIs,
one for exporting ACPI ids in uevent MODALIAS field,
and another for exporting ACPI ids in device' modalias sysfs attribute.

For any bus that supports ACPI enumerated devices, it needs to invoke
these two functions for their uevent and modalias attribute.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/scan.c  |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h |   15 +++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index c925321..680bb56 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -116,6 +116,63 @@ static int create_modalias(struct acpi_device *acpi_dev, char *modalias,
 	return len;
 }
 
+/*
+ * Creates uevent modalias field for ACPI enumerated devices.
+ * Because the other buses does not support ACPI HIDs & CIDs.
+ * e.g. for a device with hid:IBM0001 and cid:ACPI0001 you get:
+ * "acpi:IBM0001:ACPI0001"
+ */
+int acpi_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct acpi_device *acpi_dev;
+	int len;
+
+	acpi_dev = ACPI_COMPANION(dev);
+	if (!acpi_dev)
+		return -ENODEV;
+
+	/* Fall back to bus specific way of modalias exporting */
+	if (list_empty(&acpi_dev->pnp.ids))
+		return -ENODEV;
+
+	if (add_uevent_var(env, "MODALIAS="))
+		return -ENOMEM;
+	len = create_modalias(acpi_dev, &env->buf[env->buflen - 1],
+				sizeof(env->buf) - env->buflen);
+	if (len <= 0)
+		return len;
+	env->buflen += len;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_device_uevent_modalias);
+
+/*
+ * Creates modalias sysfs attribute for ACPI enumerated devices.
+ * Because the other buses does not support ACPI HIDs & CIDs.
+ * e.g. for a device with hid:IBM0001 and cid:ACPI0001 you get:
+ * "acpi:IBM0001:ACPI0001"
+ */
+int acpi_device_modalias(struct device *dev, char *buf, int size)
+{
+	struct acpi_device *acpi_dev;
+	int len;
+
+	acpi_dev = ACPI_COMPANION(dev);
+	if (!acpi_dev)
+		return -ENODEV;
+
+	/* Fall back to bus specific way of modalias exporting */
+	if (list_empty(&acpi_dev->pnp.ids))
+		return -ENODEV;
+
+	len = create_modalias(acpi_dev, buf, size -1);
+	if (len <= 0)
+		return len;
+	buf[len++] = '\n';
+	return len;
+}
+EXPORT_SYMBOL_GPL(acpi_device_modalias);
+
 static ssize_t
 acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, char *buf) {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d9099b1..22325ed 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -409,6 +409,9 @@ static inline bool acpi_driver_match_device(struct device *dev,
 	return !!acpi_match_device(drv->acpi_match_table, dev);
 }
 
+int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
+int acpi_device_modalias(struct device *, char *, int);
+
 #define ACPI_PTR(_ptr)	(_ptr)
 
 #else	/* !CONFIG_ACPI */
@@ -488,6 +491,18 @@ static inline bool acpi_driver_match_device(struct device *dev,
 	return false;
 }
 
+static inline int acpi_device_uevent_modalias(struct device *dev,
+				struct kobj_uevent_env *env)
+{
+	return -ENODEV;
+}
+
+static inline int acpi_device_modalias(struct device *dev,
+				char *buf, int size)
+{
+	return -ENODEV;
+}
+
 #define ACPI_PTR(_ptr)	(NULL)
 
 #endif	/* !CONFIG_ACPI */
-- 
1.7.9.5

