Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbbA1VmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:42:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45515 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605AbbA1UiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:38:09 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH v1 2/7] thermal: extend the cooling device API to include power information
Date: Wed, 28 Jan 2015 17:00:33 +0000
Message-Id: <1422464438-16761-3-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422464438-16761-1-git-send-email-javi.merino@arm.com>
References: <1422464438-16761-1-git-send-email-javi.merino@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add three optional callbacks to the cooling device interface to allow
them to express power.  In addition to the callbacks, add helpers to
identify cooling devices that implement the power cooling device API.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 drivers/thermal/thermal_core.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h        | 18 +++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index bf230c64e016..a01d4a72bd93 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -868,6 +868,58 @@ emul_temp_store(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
 #endif/*CONFIG_THERMAL_EMULATION*/
 
+/**
+ * power_actor_get_max_power() - get the maximum power that a cdev can consume
+ * @cdev:	pointer to &thermal_cooling_device
+ * @tz:		a valid thermal zone device pointer
+ * @max_power:	pointer in which to store the maximum power
+ *
+ * Calculate the maximum power consumption in milliwats that the
+ * cooling device can currently consume and store it in @max_power.
+ *
+ * Return: 0 on success, -EINVAL if @cdev doesn't support the
+ * power_actor API or -E* on other error.
+ */
+int power_actor_get_max_power(struct thermal_cooling_device *cdev,
+			      struct thermal_zone_device *tz, u32 *max_power)
+{
+	if (!cdev_is_power_actor(cdev))
+		return -EINVAL;
+
+	return cdev->ops->state2power(cdev, tz, 0, max_power);
+}
+
+/**
+ * power_actor_set_power() - limit the maximum power that a cooling device can consume
+ * @cdev:	pointer to &thermal_cooling_device
+ * @instance:	thermal instance to update
+ * @power:	the power in milliwatts
+ *
+ * Set the cooling device to consume at most @power milliwatts.
+ *
+ * Return: 0 on success, -EINVAL if the cooling device does not
+ * implement the power actor API or -E* for other failures.
+ */
+int power_actor_set_power(struct thermal_cooling_device *cdev,
+			  struct thermal_instance *instance, u32 power)
+{
+	unsigned long state;
+	int ret;
+
+	if (!cdev_is_power_actor(cdev))
+		return -EINVAL;
+
+	ret = cdev->ops->power2state(cdev, instance->tz, power, &state);
+	if (ret)
+		return ret;
+
+	instance->target = state;
+	cdev->updated = false;
+	thermal_cdev_update(cdev);
+
+	return 0;
+}
+
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 03dec86abc79..288ac6fd743d 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -60,6 +60,7 @@
 
 struct thermal_zone_device;
 struct thermal_cooling_device;
+struct thermal_instance;
 
 enum thermal_device_mode {
 	THERMAL_DEVICE_DISABLED = 0,
@@ -113,6 +114,12 @@ struct thermal_cooling_device_ops {
 	int (*get_max_state) (struct thermal_cooling_device *, unsigned long *);
 	int (*get_cur_state) (struct thermal_cooling_device *, unsigned long *);
 	int (*set_cur_state) (struct thermal_cooling_device *, unsigned long);
+	int (*get_requested_power)(struct thermal_cooling_device *,
+				   struct thermal_zone_device *, u32 *);
+	int (*state2power)(struct thermal_cooling_device *,
+			   struct thermal_zone_device *, unsigned long, u32 *);
+	int (*power2state)(struct thermal_cooling_device *,
+			   struct thermal_zone_device *, u32, unsigned long *);
 };
 
 struct thermal_cooling_device {
@@ -323,6 +330,17 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
 }
 
 #endif
+
+static inline bool cdev_is_power_actor(struct thermal_cooling_device *cdev)
+{
+	return cdev->ops->get_requested_power && cdev->ops->state2power &&
+		cdev->ops->power2state;
+}
+
+int power_actor_get_max_power(struct thermal_cooling_device *,
+			      struct thermal_zone_device *tz, u32 *max_power);
+int power_actor_set_power(struct thermal_cooling_device *,
+			  struct thermal_instance *, u32);
 struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
 		void *, struct thermal_zone_device_ops *,
 		const struct thermal_zone_params *, int, int);
-- 
1.9.1

