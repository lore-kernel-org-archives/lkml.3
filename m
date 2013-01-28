Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3A1DhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:37:01 -0500
Received: from mail-gh0-f180.google.com ([209.85.160.180]:48036 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3A1Dg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:36:57 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2013 22:36:56 EST
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Cc: jonghwa3.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, durgadoss.r@intel.com
Subject: [PATCH V2 1/2] thermal: sysfs: Add a new sysfs node emul_temp for thermal emulation
Date: Sun, 27 Jan 2013 19:28:19 -0800
Message-Id: <1359343700-30190-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to set the emulated temperature method in
thermal zone (sensor). After setting this feature thermal zone may
report this temperature and not the actual temperature. The emulation
implementation may be based on sensor capability through platform
specific handler or pure software emulation if no platform handler defined.

This is useful in debugging different temperature threshold and its
associated cooling action. Critical threshold's cannot be emulated.
Writing 0 on this node should disable emulation.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---

Changes in V2:
* Added config option for enabling emulation support.
* Added s/w emulation if no platform handler registered.
* skip the critical trip point emulation

This patchset is based on thermal maintainer next tree.
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next 

 Documentation/thermal/sysfs-api.txt |   13 ++++++
 drivers/thermal/Kconfig             |    8 +++
 drivers/thermal/thermal_sys.c       |   82 ++++++++++++++++++++++++++++++-----
 include/linux/thermal.h             |    2 +
 4 files changed, 94 insertions(+), 11 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 526d4b9..6859661 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -55,6 +55,8 @@ temperature) and throttle appropriate devices.
 	.get_trip_type: get the type of certain trip point.
 	.get_trip_temp: get the temperature above which the certain trip point
 			will be fired.
+	.set_emul_temp: set the emulation temperature which helps in debugging
+			different threshold temperature points.
 
 1.1.2 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 
@@ -153,6 +155,7 @@ Thermal zone device sys I/F, created once it's registered:
     |---trip_point_[0-*]_temp:	Trip point temperature
     |---trip_point_[0-*]_type:	Trip point type
     |---trip_point_[0-*]_hyst:	Hysteresis value for this trip point
+    |---emul_temp:		Emulated temperature set node
 
 Thermal cooling device sys I/F, created once it's registered:
 /sys/class/thermal/cooling_device[0-*]:
@@ -252,6 +255,16 @@ passive
 	Valid values: 0 (disabled) or greater than 1000
 	RW, Optional
 
+emul_temp
+	Interface to set the emulated temperature method in thermal zone
+	(sensor). After setting this temperature, the thermal zone may pass
+	this temperature to platform emulation function if registered or
+	cache it locally. This is useful in debugging different temperature
+	threshold and its associated cooling action. This is write only node
+	and writing 0 on this node should disable emulation.
+	Unit: millidegree Celsius
+	WO, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index faf38c5..e4cf7fb 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -78,6 +78,14 @@ config CPU_THERMAL
 	  and not the ACPI interface.
 	  If you want this support, you should say Y here.
 
+config THERMAL_EMULATION
+	bool "Thermal emulation mode support"
+	help
+	  Enable this option to make a emul_temp sysfs node in thermal zone
+	  directory to support temperature emulation. With emulation sysfs node,
+	  user can manually input temperature and test the different trip
+	  threshold behaviour for simulation purpose.
+
 config SPEAR_THERMAL
 	bool "SPEAr thermal sensor driver"
 	depends on PLAT_SPEAR
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 0a1bf6b..59ba709 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -378,24 +378,57 @@ static void handle_thermal_trip(struct thermal_zone_device *tz, int trip)
 	monitor_thermal_zone(tz);
 }
 
+static int thermal_zone_get_temp(struct thermal_zone_device *tz,
+				unsigned long *temp)
+{
+	int ret = 0, count;
+	unsigned long crit_temp = -1UL;
+	enum thermal_trip_type type;
+
+	mutex_lock(&tz->lock);
+
+	if (tz->ops->get_temp)
+		ret = tz->ops->get_temp(tz, temp);
+	else
+		ret = -EPERM;
+
+	if (!tz->emul_temperature)
+		goto skip_emul;
+
+	for (count = 0; count < tz->trips; count++) {
+		ret = tz->ops->get_trip_type(tz, count, &type);
+		if (!ret && type == THERMAL_TRIP_CRITICAL) {
+			ret = tz->ops->get_trip_temp(tz, count, &crit_temp);
+			break;
+		}
+	}
+
+	if (ret)
+		goto skip_emul;
+
+	if (*temp < crit_temp)
+		*temp = tz->emul_temperature;
+
+skip_emul:
+	mutex_unlock(&tz->lock);
+	return ret;
+}
+
 static void update_temperature(struct thermal_zone_device *tz)
 {
 	long temp;
 	int ret;
 
-	mutex_lock(&tz->lock);
-
-	ret = tz->ops->get_temp(tz, &temp);
+	ret = thermal_zone_get_temp(tz, &temp);
 	if (ret) {
 		dev_warn(&tz->device, "failed to read out thermal zone %d\n",
 			 tz->id);
-		goto exit;
+		return;
 	}
 
+	mutex_lock(&tz->lock);
 	tz->last_temperature = tz->temperature;
 	tz->temperature = temp;
-
-exit:
 	mutex_unlock(&tz->lock);
 }
 
@@ -438,10 +471,7 @@ temp_show(struct device *dev, struct device_attribute *attr, char *buf)
 	long temperature;
 	int ret;
 
-	if (!tz->ops->get_temp)
-		return -EPERM;
-
-	ret = tz->ops->get_temp(tz, &temperature);
+	ret = thermal_zone_get_temp(tz, &temperature);
 
 	if (ret)
 		return ret;
@@ -701,6 +731,31 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
 	return sprintf(buf, "%s\n", tz->governor->name);
 }
 
+#ifdef CONFIG_THERMAL_EMULATION
+static ssize_t
+emul_temp_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+	int ret = 0;
+	unsigned long temperature;
+
+	if (kstrtoul(buf, 10, &temperature))
+		return -EINVAL;
+
+	if (!tz->ops->set_emul_temp) {
+		mutex_lock(&tz->lock);
+		tz->emul_temperature = temperature;
+		mutex_unlock(&tz->lock);
+	} else {
+		ret = tz->ops->set_emul_temp(tz, temperature);
+	}
+
+	return ret ? ret : count;
+}
+static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
+#endif/*CONFIG_THERMAL_EMULATION*/
+
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
@@ -843,7 +898,7 @@ temp_input_show(struct device *dev, struct device_attribute *attr, char *buf)
 				       temp_input);
 	struct thermal_zone_device *tz = temp->tz;
 
-	ret = tz->ops->get_temp(tz, &temperature);
+	ret = thermal_zone_get_temp(tz, &temperature);
 
 	if (ret)
 		return ret;
@@ -1596,6 +1651,11 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 			goto unregister;
 	}
 
+#ifdef CONFIG_THERMAL_EMULATION
+	result = device_create_file(&tz->device, &dev_attr_emul_temp);
+	if (result)
+		goto unregister;
+#endif
 	/* Create policy attribute */
 	result = device_create_file(&tz->device, &dev_attr_policy);
 	if (result)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 9b78f8c..f0bd7f9 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -123,6 +123,7 @@ struct thermal_zone_device_ops {
 	int (*set_trip_hyst) (struct thermal_zone_device *, int,
 			      unsigned long);
 	int (*get_crit_temp) (struct thermal_zone_device *, unsigned long *);
+	int (*set_emul_temp) (struct thermal_zone_device *, unsigned long);
 	int (*get_trend) (struct thermal_zone_device *, int,
 			  enum thermal_trend *);
 	int (*notify) (struct thermal_zone_device *, int,
@@ -165,6 +166,7 @@ struct thermal_zone_device {
 	int polling_delay;
 	int temperature;
 	int last_temperature;
+	int emul_temperature;
 	int passive;
 	unsigned int forced_passive;
 	const struct thermal_zone_device_ops *ops;
-- 
1.7.5.4

