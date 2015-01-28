Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbbA1Vli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:41:38 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45520 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668AbbA1UiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:38:14 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH v1 1/7] thermal: let governors have private data for each thermal zone
Date: Wed, 28 Jan 2015 17:00:32 +0000
Message-Id: <1422464438-16761-2-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422464438-16761-1-git-send-email-javi.merino@arm.com>
References: <1422464438-16761-1-git-send-email-javi.merino@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A governor may need to store its current state between calls to
throttle().  That state depends on the thermal zone, so store it as
private data in struct thermal_zone_device.

The governors may have two new ops: bind_to_tz() and unbind_from_tz().
When provided, these functions let governors do some initialization
and teardown when they are bound/unbound to a tz and possibly store that
information in the governor_data field of the struct
thermal_zone_device.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---

Hi Rui,

You said[0] that you had applied it but I can't see it in any of your trees, so I'm sending it again.

[0] http://thread.gmane.org/gmane.linux.kernel/1845418/focus=54163
---
 drivers/thermal/thermal_core.c | 83 ++++++++++++++++++++++++++++++++++++++----
 include/linux/thermal.h        |  9 +++++
 2 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 87e0b0782023..bf230c64e016 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -75,6 +75,58 @@ static struct thermal_governor *__find_governor(const char *name)
 	return NULL;
 }
 
+/**
+ * bind_previous_governor() - bind the previous governor of the thermal zone
+ * @tz:		a valid pointer to a struct thermal_zone_device
+ * @failed_gov_name:	the name of the governor that failed to register
+ *
+ * Register the previous governor of the thermal zone after a new
+ * governor has failed to be bound.
+ */
+static void bind_previous_governor(struct thermal_zone_device *tz,
+				   const char *failed_gov_name)
+{
+	if (tz->governor && tz->governor->bind_to_tz) {
+		if (tz->governor->bind_to_tz(tz)) {
+			dev_err(&tz->device,
+				"governor %s failed to bind and the previous one (%s) failed to bind again, thermal zone %s has no governor\n",
+				failed_gov_name, tz->governor->name, tz->type);
+			tz->governor = NULL;
+		}
+	}
+}
+
+/**
+ * thermal_set_governor() - Switch to another governor
+ * @tz:		a valid pointer to a struct thermal_zone_device
+ * @new_gov:	pointer to the new governor
+ *
+ * Change the governor of thermal zone @tz.
+ *
+ * Return: 0 on success, an error if the new governor's bind_to_tz() failed.
+ */
+static int thermal_set_governor(struct thermal_zone_device *tz,
+				struct thermal_governor *new_gov)
+{
+	int ret = 0;
+
+	if (tz->governor && tz->governor->unbind_from_tz)
+		tz->governor->unbind_from_tz(tz);
+
+	if (new_gov && new_gov->bind_to_tz) {
+		ret = new_gov->bind_to_tz(tz);
+		if (ret) {
+			bind_previous_governor(tz, new_gov->name);
+
+			return ret;
+		}
+	}
+
+	tz->governor = new_gov;
+
+	return ret;
+}
+
 int thermal_register_governor(struct thermal_governor *governor)
 {
 	int err;
@@ -107,8 +159,15 @@ int thermal_register_governor(struct thermal_governor *governor)
 
 		name = pos->tzp->governor_name;
 
-		if (!strncasecmp(name, governor->name, THERMAL_NAME_LENGTH))
-			pos->governor = governor;
+		if (!strncasecmp(name, governor->name, THERMAL_NAME_LENGTH)) {
+			int ret;
+
+			ret = thermal_set_governor(pos, governor);
+			if (ret)
+				dev_err(&pos->device,
+					"Failed to set governor %s for thermal zone %s: %d\n",
+					governor->name, pos->type, ret);
+		}
 	}
 
 	mutex_unlock(&thermal_list_lock);
@@ -134,7 +193,7 @@ void thermal_unregister_governor(struct thermal_governor *governor)
 	list_for_each_entry(pos, &thermal_tz_list, node) {
 		if (!strncasecmp(pos->governor->name, governor->name,
 						THERMAL_NAME_LENGTH))
-			pos->governor = NULL;
+			thermal_set_governor(pos, NULL);
 	}
 
 	mutex_unlock(&thermal_list_lock);
@@ -763,8 +822,9 @@ policy_store(struct device *dev, struct device_attribute *attr,
 	if (!gov)
 		goto exit;
 
-	tz->governor = gov;
-	ret = count;
+	ret = thermal_set_governor(tz, gov);
+	if (!ret)
+		ret = count;
 
 exit:
 	mutex_unlock(&tz->lock);
@@ -1463,6 +1523,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int result;
 	int count;
 	int passive = 0;
+	struct thermal_governor *governor;
 
 	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
 		return ERR_PTR(-EINVAL);
@@ -1553,9 +1614,15 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	mutex_lock(&thermal_governor_lock);
 
 	if (tz->tzp)
-		tz->governor = __find_governor(tz->tzp->governor_name);
+		governor = __find_governor(tz->tzp->governor_name);
 	else
-		tz->governor = def_governor;
+		governor = def_governor;
+
+	result = thermal_set_governor(tz, governor);
+	if (result) {
+		mutex_unlock(&thermal_governor_lock);
+		goto unregister;
+	}
 
 	mutex_unlock(&thermal_governor_lock);
 
@@ -1644,7 +1711,7 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 		device_remove_file(&tz->device, &dev_attr_mode);
 	device_remove_file(&tz->device, &dev_attr_policy);
 	remove_trip_attrs(tz);
-	tz->governor = NULL;
+	thermal_set_governor(tz, NULL);
 
 	thermal_remove_hwmon_sysfs(tz);
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index fc52e307efab..03dec86abc79 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -162,6 +162,7 @@ struct thermal_attr {
  * @ops:	operations this &thermal_zone_device supports
  * @tzp:	thermal zone parameters
  * @governor:	pointer to the governor for this thermal zone
+ * @governor_data:	private pointer for governor data
  * @thermal_instances:	list of &struct thermal_instance of this thermal zone
  * @idr:	&struct idr to generate unique id for this zone's cooling
  *		devices
@@ -188,6 +189,7 @@ struct thermal_zone_device {
 	struct thermal_zone_device_ops *ops;
 	const struct thermal_zone_params *tzp;
 	struct thermal_governor *governor;
+	void *governor_data;
 	struct list_head thermal_instances;
 	struct idr idr;
 	struct mutex lock;
@@ -198,12 +200,19 @@ struct thermal_zone_device {
 /**
  * struct thermal_governor - structure that holds thermal governor information
  * @name:	name of the governor
+ * @bind_to_tz: callback called when binding to a thermal zone.  If it
+ *		returns 0, the governor is bound to the thermal zone,
+ *		otherwise it fails.
+ * @unbind_from_tz:	callback called when a governor is unbound from a
+ *			thermal zone.
  * @throttle:	callback called for every trip point even if temperature is
  *		below the trip point temperature
  * @governor_list:	node in thermal_governor_list (in thermal_core.c)
  */
 struct thermal_governor {
 	char name[THERMAL_NAME_LENGTH];
+	int (*bind_to_tz)(struct thermal_zone_device *tz);
+	void (*unbind_from_tz)(struct thermal_zone_device *tz);
 	int (*throttle)(struct thermal_zone_device *tz, int trip);
 	struct list_head	governor_list;
 };
-- 
1.9.1

