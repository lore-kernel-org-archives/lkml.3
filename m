Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaANIrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:47:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:63516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaANIq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:46:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,657,1384329600"; 
   d="scan'208";a="464783306"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
Cc: wsa@the-dreams.de, broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
Date: Tue, 14 Jan 2014 16:46:37 +0800
Message-Id: <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI enumerated devices has ACPI style _HID and _CID strings,
all of these strings can be used for both driver loading and matching.

Currently, in Platform, I2C and SPI bus, the ACPI style driver matching
is supported by invoking acpi_driver_match_device() in bus .match() callback.
But, the module autoloading is still broken.

For example, there is any ACPI device with _HID "INTABCD" that is
enumerated to platform bus, and we have a driver that can probe it.

The driver exports its module_alias as "acpi:INTABCD" use the following code
static const struct acpi_device_id xxx_acpi_match[] = {
        { "INTABCD", 0 },
        { }
};
MODULE_DEVICE_TABLE(acpi, xxx_acpi_match);

But, unfortunately, the device' modalias is shown as "platform:INTABCD:00",
please refer to modalias_show() and platform_uevent() in
drivers/base/platform.c.
This results in that the driver will not be loaded automatically when the
device node is created, because their modalias do not match.

This also applies to I2C and SPI bus.

With this patch, the device' modalias will be shown as "acpi:INTABCD" as well.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/platform.c |   12 +++++++++++-
 drivers/i2c/i2c-core.c  |   11 +++++++++++
 drivers/spi/spi.c       |   10 ++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3a94b79..2f4aea2 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -677,7 +677,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 			     char *buf)
 {
 	struct platform_device	*pdev = to_platform_device(dev);
-	int len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
+	int len;
+
+	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);
+	if (len != -ENODEV)
+		return len;
+
+	len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
 
 	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
 }
@@ -699,6 +705,10 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (rc != -ENODEV)
 		return rc;
 
+	rc = acpi_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
+
 	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
 			pdev->name);
 	return 0;
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d74c0b3..c4c5588 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -104,6 +104,11 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
+	int rc;
+
+	rc = acpi_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
 
 	if (add_uevent_var(env, "MODALIAS=%s%s",
 			   I2C_MODULE_PREFIX, client->name))
@@ -409,6 +414,12 @@ static ssize_t
 show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	int len;
+
+	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);
+	if (len != -ENODEV)
+		return len;
+
 	return sprintf(buf, "%s%s\n", I2C_MODULE_PREFIX, client->name);
 }
 
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 349ebba..ab70eda 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -58,6 +58,11 @@ static ssize_t
 modalias_show(struct device *dev, struct device_attribute *a, char *buf)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
+	int len;
+
+	len = acpi_device_modalias(dev, buf, PAGE_SIZE);
+	if (len != -ENODEV)
+		return len;
 
 	return sprintf(buf, "%s%s\n", SPI_MODULE_PREFIX, spi->modalias);
 }
@@ -114,6 +119,11 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
 static int spi_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	const struct spi_device		*spi = to_spi_device(dev);
+	int rc;
+
+	rc = acpi_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
 
 	add_uevent_var(env, "MODALIAS=%s%s", SPI_MODULE_PREFIX, spi->modalias);
 	return 0;
-- 
1.7.9.5

