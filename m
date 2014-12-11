Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126AbaLKIjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:39:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:19270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbaLKIjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:39:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="427692409"
Message-ID: <54895821.3050902@intel.com>
Date: Thu, 11 Dec 2014 16:38:57 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Olof Johansson <olof@lixom.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v6] Thermal: introduce INT3406 thermal driver
References: <54868CF6.6020505@intel.com>		 <CAOesGMirF-_H2ZzFR-VpwkEErZE2uQJSYx5EuePArQsEh=r_Kw@mail.gmail.com>		 <20141211010226.GA26253@aaronlu.sh.intel.com>		 <CAOesGMj_uObbxLdpobEhP=nRPsFUJNCtq01RH7ZSECd5=1Ti6Q@mail.gmail.com>	 <1418265472.12435.68.camel@rzhang1-toshiba> <548934D0.8000502@intel.com> <1418286781.12435.73.camel@rzhang1-toshiba>
In-Reply-To: <1418286781.12435.73.camel@rzhang1-toshiba>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INT3406 ACPI device object resembles an ACPI video output device, but its
_BCM is said to be deprecated and should not be used. So we will make
use of the raw interface to do the actual cooling. Due to this, the
backlight core has some modifications. Also, to re-use some of the ACPI
video module's code, one function has been exported.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
v6: Fix an issue that wrongly set error path return value as reported
by Olof Johansson.

 drivers/acpi/video.c                              |  77 ++++----
 drivers/thermal/Kconfig                           |  26 +--
 drivers/thermal/int340x_thermal/Kconfig           |  41 ++++
 drivers/thermal/int340x_thermal/Makefile          |   1 +
 drivers/thermal/int340x_thermal/int3406_thermal.c | 229 ++++++++++++++++++++++
 drivers/video/backlight/backlight.c               |  44 +++--
 include/acpi/video.h                              |  20 ++
 include/linux/backlight.h                         |   2 +
 8 files changed, 366 insertions(+), 74 deletions(-)
 create mode 100644 drivers/thermal/int340x_thermal/Kconfig
 create mode 100644 drivers/thermal/int340x_thermal/int3406_thermal.c

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 807a88a0f394..32880e6c8da4 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -186,19 +186,6 @@ struct acpi_video_device_cap {
 	u8 _DDC:1;		/* Return the EDID for this device */
 };
 
-struct acpi_video_brightness_flags {
-	u8 _BCL_no_ac_battery_levels:1;	/* no AC/Battery levels in _BCL */
-	u8 _BCL_reversed:1;		/* _BCL package is in a reversed order */
-	u8 _BQC_use_index:1;		/* _BQC returns an index value */
-};
-
-struct acpi_video_device_brightness {
-	int curr;
-	int count;
-	int *levels;
-	struct acpi_video_brightness_flags flags;
-};
-
 struct acpi_video_device {
 	unsigned long device_id;
 	struct acpi_video_device_flags flags;
@@ -344,7 +331,7 @@ static const struct thermal_cooling_device_ops video_cooling_ops = {
  */
 
 static int
-acpi_video_device_lcd_query_levels(struct acpi_video_device *device,
+acpi_video_device_lcd_query_levels(acpi_handle handle,
 				   union acpi_object **levels)
 {
 	int status;
@@ -354,7 +341,7 @@ acpi_video_device_lcd_query_levels(struct acpi_video_device *device,
 
 	*levels = NULL;
 
-	status = acpi_evaluate_object(device->dev->handle, "_BCL", NULL, &buffer);
+	status = acpi_evaluate_object(handle, "_BCL", NULL, &buffer);
 	if (!ACPI_SUCCESS(status))
 		return status;
 	obj = (union acpi_object *)buffer.pointer;
@@ -727,29 +714,18 @@ static int acpi_video_bqc_quirk(struct acpi_video_device *device,
 	return 0;
 }
 
-
-/*
- *  Arg:
- *	device	: video output device (LCD, CRT, ..)
- *
- *  Return Value:
- *	Maximum brightness level
- *
- *  Allocate and initialize device->brightness.
- */
-
-static int
-acpi_video_init_brightness(struct acpi_video_device *device)
+int acpi_video_get_levels(struct acpi_device *device,
+			  struct acpi_video_device_brightness **dev_br)
 {
 	union acpi_object *obj = NULL;
 	int i, max_level = 0, count = 0, level_ac_battery = 0;
-	unsigned long long level, level_old;
 	union acpi_object *o;
 	struct acpi_video_device_brightness *br = NULL;
 	int result = -EINVAL;
 	u32 value;
 
-	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
+	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device->handle,
+								&obj))) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available "
 						"LCD brightness level\n"));
 		goto out;
@@ -822,6 +798,39 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 			    "Found unordered _BCL package"));
 
 	br->count = count;
+	*dev_br = br;
+	result = 0;
+
+out:
+	kfree(obj);
+	return result;
+out_free:
+	kfree(br);
+	goto out;
+}
+EXPORT_SYMBOL(acpi_video_get_levels);
+
+/*
+ *  Arg:
+ *	device	: video output device (LCD, CRT, ..)
+ *
+ *  Return Value:
+ *	Maximum brightness level
+ *
+ *  Allocate and initialize device->brightness.
+ */
+
+static int
+acpi_video_init_brightness(struct acpi_video_device *device)
+{
+	int i, max_level = 0;
+	unsigned long long level, level_old;
+	struct acpi_video_device_brightness *br = NULL;
+	int result = -EINVAL;
+
+	result = acpi_video_get_levels(device->dev, &br);
+	if (result)
+		return result;
 	device->brightness = br;
 
 	/* _BQC uses INDEX while _BCL uses VALUE in some laptops */
@@ -864,17 +873,13 @@ set_level:
 		goto out_free_levels;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-			  "found %d brightness levels\n", count - 2));
-	kfree(obj);
-	return result;
+			  "found %d brightness levels\n", br->count - 2));
+	return 0;
 
 out_free_levels:
 	kfree(br->levels);
-out_free:
 	kfree(br);
-out:
 	device->brightness = NULL;
-	kfree(obj);
 	return result;
 }
 
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index f554d25b4399..ac391d8d76b4 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -229,29 +229,9 @@ config INTEL_SOC_DTS_THERMAL
 	  notification methods.The other trip is a critical trip point, which
 	  was set by the driver based on the TJ MAX temperature.
 
-config INT340X_THERMAL
-	tristate "ACPI INT340X thermal drivers"
-	depends on X86 && ACPI
-	select THERMAL_GOV_USER_SPACE
-	select ACPI_THERMAL_REL
-	select ACPI_FAN
-	help
-	  Newer laptops and tablets that use ACPI may have thermal sensors and
-	  other devices with thermal control capabilities outside the core
-	  CPU/SOC, for thermal safety reasons.
-	  They are exposed for the OS to use via the INT3400 ACPI device object
-	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
-	  Enable this to expose the temperature information and cooling ability
-	  from these objects to userspace via the normal thermal framework.
-	  This means that a wide range of applications and GUI widgets can show
-	  the information to the user or use this information for making
-	  decisions. For example, the Intel Thermal Daemon can use this
-	  information to allow the user to select his laptop to run without
-	  turning on the fans.
-
-config ACPI_THERMAL_REL
-	tristate
-	depends on ACPI
+menu "ACPI INT340X thermal drivers"
+source drivers/thermal/int340x_thermal/Kconfig
+endmenu
 
 menu "Texas Instruments thermal drivers"
 source "drivers/thermal/ti-soc-thermal/Kconfig"
diff --git a/drivers/thermal/int340x_thermal/Kconfig b/drivers/thermal/int340x_thermal/Kconfig
new file mode 100644
index 000000000000..b92892a6afe0
--- /dev/null
+++ b/drivers/thermal/int340x_thermal/Kconfig
@@ -0,0 +1,41 @@
+#
+# ACPI INT340x thermal drivers configuration
+#
+
+config INT340X_THERMAL
+	tristate "ACPI INT340X thermal drivers"
+	depends on X86 && ACPI
+	select THERMAL_GOV_USER_SPACE
+	select ACPI_THERMAL_REL
+	select ACPI_FAN
+	help
+	  Newer laptops and tablets that use ACPI may have thermal sensors and
+	  other devices with thermal control capabilities outside the core
+	  CPU/SOC, for thermal safety reasons.
+	  They are exposed for the OS to use via the INT3400 ACPI device object
+	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
+	  Enable this to expose the temperature information and cooling ability
+	  from these objects to userspace via the normal thermal framework.
+	  This means that a wide range of applications and GUI widgets can show
+	  the information to the user or use this information for making
+	  decisions. For example, the Intel Thermal Daemon can use this
+	  information to allow the user to select his laptop to run without
+	  turning on the fans.
+
+if INT340X_THERMAL
+
+config ACPI_THERMAL_REL
+	tristate
+	depends on ACPI
+
+config INT3406_THERMAL
+	tristate "ACPI INT3406 display thermal driver"
+	depends on ACPI_VIDEO
+	help
+	  The display thermal device represents the LED/LCD display panel
+	  that may or may not include touch support. The main function of
+	  the display thermal device is to allow control of the display
+	  brightness in order to address a thermal condition or to reduce
+	  power consumed by display device.
+
+endif
diff --git a/drivers/thermal/int340x_thermal/Makefile b/drivers/thermal/int340x_thermal/Makefile
index ffe40bffaf1a..a9d0429be412 100644
--- a/drivers/thermal/int340x_thermal/Makefile
+++ b/drivers/thermal/int340x_thermal/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_INT340X_THERMAL)	+= int3400_thermal.o
 obj-$(CONFIG_INT340X_THERMAL)	+= int3402_thermal.o
 obj-$(CONFIG_INT340X_THERMAL)	+= int3403_thermal.o
+obj-$(CONFIG_INT3406_THERMAL)	+= int3406_thermal.o
 obj-$(CONFIG_ACPI_THERMAL_REL)	+= acpi_thermal_rel.o
diff --git a/drivers/thermal/int340x_thermal/int3406_thermal.c b/drivers/thermal/int340x_thermal/int3406_thermal.c
new file mode 100644
index 000000000000..2719e49a0af9
--- /dev/null
+++ b/drivers/thermal/int340x_thermal/int3406_thermal.c
@@ -0,0 +1,229 @@
+/*
+ * INT3406 thermal driver for display participant device
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * Authors: Aaron Lu <aaron.lu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/acpi.h>
+#include <linux/backlight.h>
+#include <linux/thermal.h>
+#include <acpi/video.h>
+
+#define INT3406_BRIGHTNESS_LIMITS_CHANGED	0x80
+
+struct int3406_thermal_data {
+	int upper_limit;
+	int upper_limit_index;
+	int lower_limit;
+	int lower_limit_index;
+	acpi_handle handle;
+	struct acpi_video_device_brightness *br;
+	struct backlight_device *raw_bd;
+	struct thermal_cooling_device *cooling_dev;
+};
+
+static int int3406_thermal_to_raw(int level, struct int3406_thermal_data *d)
+{
+	int max_level = d->br->levels[d->br->count - 1];
+	int raw_max = d->raw_bd->props.max_brightness;
+
+	return level * raw_max / max_level;
+}
+
+static int int3406_thermal_to_acpi(int level, struct int3406_thermal_data *d)
+{
+	int raw_max = d->raw_bd->props.max_brightness;
+	int max_level = d->br->levels[d->br->count - 1];
+
+	return level * max_level / raw_max;
+}
+
+static int
+int3406_thermal_get_max_state(struct thermal_cooling_device *cooling_dev,
+			      unsigned long *state)
+{
+	struct int3406_thermal_data *d = cooling_dev->devdata;
+	int index = d->lower_limit_index ? d->lower_limit_index : 2;
+
+	*state = d->br->count - 1 - index;
+	return 0;
+}
+
+static int
+int3406_thermal_set_cur_state(struct thermal_cooling_device *cooling_dev,
+			      unsigned long state)
+{
+	struct int3406_thermal_data *d = cooling_dev->devdata;
+	int level, raw_level;
+
+	if (state > d->br->count - 3)
+		return -EINVAL;
+
+	state = d->br->count - 1 - state;
+	level = d->br->levels[state];
+
+	if ((d->upper_limit && level > d->upper_limit) ||
+	    (d->lower_limit && level < d->lower_limit))
+		return -EINVAL;
+
+	raw_level = int3406_thermal_to_raw(level, d);
+	return backlight_device_set_brightness(d->raw_bd, raw_level);
+}
+
+static int
+int3406_thermal_get_cur_state(struct thermal_cooling_device *cooling_dev,
+			      unsigned long *state)
+{
+	struct int3406_thermal_data *d = cooling_dev->devdata;
+	int raw_level, level, i;
+
+	raw_level = d->raw_bd->props.brightness;
+	level = int3406_thermal_to_acpi(raw_level, d);
+
+	/*
+	 * There is no 1:1 mapping between the firmware interface level with the
+	 * raw interface level, we will have to find one that is close enough.
+	 */
+	for (i = 2; i < d->br->count - 1; i++) {
+		if (level >= d->br->levels[i] && level <= d->br->levels[i + 1])
+			break;
+	}
+
+	*state = i;
+	return 0;
+}
+
+static const struct thermal_cooling_device_ops video_cooling_ops = {
+	.get_max_state = int3406_thermal_get_max_state,
+	.get_cur_state = int3406_thermal_get_cur_state,
+	.set_cur_state = int3406_thermal_set_cur_state,
+};
+
+static int int3406_thermal_get_index(int *array, int nr, int value)
+{
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		if (array[i] == value)
+			break;
+	}
+	return i == nr ? -ENOENT : i;
+}
+
+static void int3406_thermal_get_limit(struct int3406_thermal_data *d)
+{
+	acpi_status status;
+	unsigned long long lower_limit, upper_limit;
+	int index;
+
+	status = acpi_evaluate_integer(d->handle, "DDDL", NULL, &lower_limit);
+	if (ACPI_SUCCESS(status)) {
+		index = int3406_thermal_get_index(d->br->levels, d->br->count,
+						  lower_limit);
+		if (index > 0) {
+			d->lower_limit = (int)lower_limit;
+			d->lower_limit_index = index;
+		}
+	}
+
+	status = acpi_evaluate_integer(d->handle, "DDPC", NULL, &upper_limit);
+	if (ACPI_SUCCESS(status)) {
+		index = int3406_thermal_get_index(d->br->levels, d->br->count,
+						  upper_limit);
+		if (index > 0) {
+			d->upper_limit = (int)upper_limit;
+			d->upper_limit_index = index;
+		}
+	}
+}
+
+static void int3406_notify(acpi_handle handle, u32 event, void *data)
+{
+	if (event == INT3406_BRIGHTNESS_LIMITS_CHANGED)
+		int3406_thermal_get_limit(data);
+}
+
+static int int3406_thermal_probe(struct platform_device *pdev)
+{
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+	struct int3406_thermal_data *d;
+	struct backlight_device *bd;
+	int ret;
+
+	if (!ACPI_HANDLE(&pdev->dev))
+		return -ENODEV;
+
+	d = devm_kzalloc(&pdev->dev, sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return -ENOMEM;
+	d->handle = ACPI_HANDLE(&pdev->dev);
+
+	bd = backlight_device_get_by_type(BACKLIGHT_RAW);
+	if (!bd)
+		return -ENODEV;
+	d->raw_bd = bd;
+
+	ret = acpi_video_get_levels(ACPI_COMPANION(&pdev->dev), &d->br);
+	if (ret)
+		return ret;
+
+	int3406_thermal_get_limit(d);
+
+	d->cooling_dev = thermal_cooling_device_register(acpi_device_bid(adev),
+							 d, &video_cooling_ops);
+	if (IS_ERR(d->cooling_dev))
+		goto err;
+
+	ret = acpi_install_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+					  int3406_notify, d);
+	if (ret)
+		goto err_cdev;
+
+	platform_set_drvdata(pdev, d);
+
+	return 0;
+
+err_cdev:
+	thermal_cooling_device_unregister(d->cooling_dev);
+err:
+	kfree(d->br);
+	return -ENODEV;
+}
+
+static int int3406_thermal_remove(struct platform_device *pdev)
+{
+	struct int3406_thermal_data *d = platform_get_drvdata(pdev);
+
+	thermal_cooling_device_unregister(platform_get_drvdata(pdev));
+	kfree(d->br);
+	return 0;
+}
+
+static const struct acpi_device_id int3406_thermal_match[] = {
+	{"INT3406", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(acpi, int3406_thermal_match);
+
+static struct platform_driver int3406_thermal_driver = {
+	.probe = int3406_thermal_probe,
+	.remove = int3406_thermal_remove,
+	.driver = {
+		   .name = "int3406 thermal",
+		   .acpi_match_table = int3406_thermal_match,
+		   },
+};
+
+module_platform_driver(int3406_thermal_driver);
+
+MODULE_DESCRIPTION("INT3406 Thermal driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index bddc8b17a4d8..bea749329236 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -164,28 +164,19 @@ static ssize_t brightness_show(struct device *dev,
 	return sprintf(buf, "%d\n", bd->props.brightness);
 }
 
-static ssize_t brightness_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+int backlight_device_set_brightness(struct backlight_device *bd, int brightness)
 {
-	int rc;
-	struct backlight_device *bd = to_backlight_device(dev);
-	unsigned long brightness;
-
-	rc = kstrtoul(buf, 0, &brightness);
-	if (rc)
-		return rc;
-
-	rc = -ENXIO;
+	int rc = -ENXIO;
 
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops) {
 		if (brightness > bd->props.max_brightness)
 			rc = -EINVAL;
 		else {
-			pr_debug("set brightness to %lu\n", brightness);
+			pr_debug("set brightness to %u\n", brightness);
 			bd->props.brightness = brightness;
 			backlight_update_status(bd);
-			rc = count;
+			rc = 0;
 		}
 	}
 	mutex_unlock(&bd->ops_lock);
@@ -194,6 +185,23 @@ static ssize_t brightness_store(struct device *dev,
 
 	return rc;
 }
+EXPORT_SYMBOL(backlight_device_set_brightness);
+
+static ssize_t brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int rc;
+	struct backlight_device *bd = to_backlight_device(dev);
+	unsigned long brightness;
+
+	rc = kstrtoul(buf, 0, &brightness);
+	if (rc)
+		return rc;
+
+	rc = backlight_device_set_brightness(bd, brightness);
+
+	return rc ? rc : count;
+}
 static DEVICE_ATTR_RW(brightness);
 
 static ssize_t type_show(struct device *dev, struct device_attribute *attr,
@@ -380,7 +388,7 @@ struct backlight_device *backlight_device_register(const char *name,
 }
 EXPORT_SYMBOL(backlight_device_register);
 
-bool backlight_device_registered(enum backlight_type type)
+struct backlight_device *backlight_device_get_by_type(enum backlight_type type)
 {
 	bool found = false;
 	struct backlight_device *bd;
@@ -394,7 +402,13 @@ bool backlight_device_registered(enum backlight_type type)
 	}
 	mutex_unlock(&backlight_dev_list_mutex);
 
-	return found;
+	return found ? bd : NULL;
+}
+EXPORT_SYMBOL(backlight_device_get_by_type);
+
+bool backlight_device_registered(enum backlight_type type)
+{
+	return backlight_device_get_by_type(type) ? true : false;
 }
 EXPORT_SYMBOL(backlight_device_registered);
 
diff --git a/include/acpi/video.h b/include/acpi/video.h
index 843ef1adfbfa..956300d2f214 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -3,6 +3,19 @@
 
 #include <linux/errno.h> /* for ENODEV */
 
+struct acpi_video_brightness_flags {
+	u8 _BCL_no_ac_battery_levels:1;	/* no AC/Battery levels in _BCL */
+	u8 _BCL_reversed:1;		/* _BCL package is in a reversed order */
+	u8 _BQC_use_index:1;		/* _BQC returns an index value */
+};
+
+struct acpi_video_device_brightness {
+	int curr;
+	int count;
+	int *levels;
+	struct acpi_video_brightness_flags flags;
+};
+
 struct acpi_device;
 
 #define ACPI_VIDEO_CLASS	"video"
@@ -22,6 +35,8 @@ extern void acpi_video_unregister(void);
 extern void acpi_video_unregister_backlight(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
+extern int acpi_video_get_levels(struct acpi_device *device,
+				struct acpi_video_device_brightness **dev_br);
 extern bool acpi_video_verify_backlight_support(void);
 #else
 static inline int acpi_video_register(void) { return 0; }
@@ -32,6 +47,11 @@ static inline int acpi_video_get_edid(struct acpi_device *device, int type,
 {
 	return -ENODEV;
 }
+static int acpi_video_get_levels(struct acpi_device *device,
+			struct acpi_video_device_brightness **dev_br)
+{
+	return -ENODEV;
+}
 static inline bool acpi_video_verify_backlight_support(void) { return false; }
 #endif
 
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index adb14a8616df..c59a020df3f8 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -140,6 +140,8 @@ extern void backlight_force_update(struct backlight_device *bd,
 extern bool backlight_device_registered(enum backlight_type type);
 extern int backlight_register_notifier(struct notifier_block *nb);
 extern int backlight_unregister_notifier(struct notifier_block *nb);
+extern struct backlight_device *backlight_device_get_by_type(enum backlight_type type);
+extern int backlight_device_set_brightness(struct backlight_device *bd, int brightness);
 
 #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
 
-- 
2.1.0

