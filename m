Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbbANOGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:06:19 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41883 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbbANOGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:06:16 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: mjg59@srcf.ucam.org, dvhart@infradead.org
Cc: pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, A.Sloman@cs.bham.ac.uk,
        computersforpeace@gmail.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH] dell-laptop: use dedicated sysfs file for ALS
Date: Wed, 14 Jan 2015 15:05:57 +0100
Message-Id: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ambient light sensor doesn't act like an input trigger, so it has
to be kept separate. The sensor readings are used to determine whether
the conditions to change the keyboard illumination are satisfied or
not the moment an input trigger is used. Ambient light changes alone
can't change the keyboard backlight illumination and don't restart the
timer.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 .../ABI/testing/sysfs-platform-dell-laptop         |  11 +-
 drivers/platform/x86/dell-laptop.c                 | 152 ++++++++++++---------
 2 files changed, 97 insertions(+), 66 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Documentation/ABI/testing/sysfs-platform-dell-laptop
index 7969443..8c6a0b8 100644
--- a/Documentation/ABI/testing/sysfs-platform-dell-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
@@ -1,4 +1,4 @@
-What:		/sys/class/leds/dell::kbd_backlight/als_setting
+What:		/sys/class/leds/dell::kbd_backlight/als_enabled
 Date:		December 2014
 KernelVersion:	3.19
 Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
@@ -9,6 +9,15 @@ Description:
 		light sensor. Write 1 to this file to enable the auto
 		mode, 0 to disable it.
 
+What:		/sys/class/leds/dell::kbd_backlight/als_setting
+Date:		December 2014
+KernelVersion:	3.19
+Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
+		Pali Rohár <pali.rohar@gmail.com>
+Description:
+		This file allows to specifiy the on/off threshold value,
+		as reported by the ambient light sensor.
+
 What:		/sys/class/leds/dell::kbd_backlight/start_triggers
 Date:		December 2014
 KernelVersion:	3.19
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 9411eae..e5334ab 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -1514,9 +1514,6 @@ static ssize_t kbd_led_triggers_store(struct device *dev,
 	struct kbd_state new_state;
 	struct kbd_state state;
 	bool triggers_enabled = false;
-	bool als_enabled = false;
-	bool disable_als = false;
-	bool enable_als = false;
 	int trigger_bit = -1;
 	char trigger[21];
 	int i, ret;
@@ -1532,48 +1529,9 @@ static ssize_t kbd_led_triggers_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	if (kbd_als_supported)
-		als_enabled = kbd_is_als_mode_bit(state.mode_bit);
-
 	if (kbd_triggers_supported)
 		triggers_enabled = kbd_is_trigger_mode_bit(state.mode_bit);
 
-	if (kbd_als_supported) {
-		if (strcmp(trigger, "+als") == 0) {
-			if (als_enabled)
-				return count;
-			enable_als = true;
-		} else if (strcmp(trigger, "-als") == 0) {
-			if (!als_enabled)
-				return count;
-			disable_als = true;
-		}
-	}
-
-	if (enable_als || disable_als) {
-		new_state = state;
-		if (enable_als) {
-			if (triggers_enabled)
-				new_state.mode_bit = KBD_MODE_BIT_TRIGGER_ALS;
-			else
-				new_state.mode_bit = KBD_MODE_BIT_ALS;
-		} else {
-			if (triggers_enabled) {
-				new_state.mode_bit = KBD_MODE_BIT_TRIGGER;
-				kbd_set_level(&new_state, kbd_previous_level);
-			} else {
-				new_state.mode_bit = KBD_MODE_BIT_ON;
-			}
-		}
-		if (!(kbd_info.modes & BIT(new_state.mode_bit)))
-			return -EINVAL;
-		ret = kbd_set_state_safe(&new_state, &state);
-		if (ret)
-			return ret;
-		kbd_previous_mode_bit = new_state.mode_bit;
-		return count;
-	}
-
 	if (kbd_triggers_supported) {
 		for (i = 0; i < ARRAY_SIZE(kbd_led_triggers); ++i) {
 			if (!(kbd_info.triggers & BIT(i)))
@@ -1609,17 +1567,10 @@ static ssize_t kbd_led_triggers_store(struct device *dev,
 		    new_state.triggers)
 			return -EINVAL;
 		if (new_state.triggers && !triggers_enabled) {
-			if (als_enabled)
-				new_state.mode_bit = KBD_MODE_BIT_TRIGGER_ALS;
-			else {
-				new_state.mode_bit = KBD_MODE_BIT_TRIGGER;
-				kbd_set_level(&new_state, kbd_previous_level);
-			}
+			new_state.mode_bit = KBD_MODE_BIT_TRIGGER;
+			kbd_set_level(&new_state, kbd_previous_level);
 		} else if (new_state.triggers == 0) {
-			if (als_enabled)
-				new_state.mode_bit = KBD_MODE_BIT_ALS;
-			else
-				kbd_set_level(&new_state, 0);
+			kbd_set_level(&new_state, 0);
 		}
 		if (!(kbd_info.modes & BIT(new_state.mode_bit)))
 			return -EINVAL;
@@ -1665,13 +1616,6 @@ static ssize_t kbd_led_triggers_show(struct device *dev,
 		}
 	}
 
-	if (kbd_als_supported) {
-		if (kbd_is_als_mode_bit(state.mode_bit))
-			len += sprintf(buf+len, "+als ");
-		else
-			len += sprintf(buf+len, "-als ");
-	}
-
 	if (len)
 		buf[len - 1] = '\n';
 
@@ -1681,9 +1625,85 @@ static ssize_t kbd_led_triggers_show(struct device *dev,
 static DEVICE_ATTR(start_triggers, S_IRUGO | S_IWUSR,
 		   kbd_led_triggers_show, kbd_led_triggers_store);
 
-static ssize_t kbd_led_als_store(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
+static ssize_t kbd_led_als_enabled_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct kbd_state new_state;
+	struct kbd_state state;
+	bool triggers_enabled = false;
+	int enable;
+	int ret;
+
+	if (!kbd_als_supported) {
+		pr_warn("ALS mode is not supported\n");
+		return -ENODEV;
+	}
+
+	ret = kstrtoint(buf, 0, &enable);
+	if (ret)
+		return ret;
+
+	ret = kbd_get_state(&state);
+	if (ret)
+		return ret;
+
+	if (enable == kbd_is_als_mode_bit(state.mode_bit))
+		return count;
+
+	new_state = state;
+
+	if (kbd_triggers_supported)
+		triggers_enabled = kbd_is_trigger_mode_bit(state.mode_bit);
+
+	if (enable) {
+		if (triggers_enabled)
+			new_state.mode_bit = KBD_MODE_BIT_TRIGGER_ALS;
+		else
+			new_state.mode_bit = KBD_MODE_BIT_ALS;
+	} else {
+		if (triggers_enabled) {
+			new_state.mode_bit = KBD_MODE_BIT_TRIGGER;
+			kbd_set_level(&new_state, kbd_previous_level);
+		} else {
+			new_state.mode_bit = KBD_MODE_BIT_ON;
+		}
+	}
+	if (!(kbd_info.modes & BIT(new_state.mode_bit)))
+		return -EINVAL;
+
+	ret = kbd_set_state_safe(&new_state, &state);
+	if (ret)
+		return ret;
+	kbd_previous_mode_bit = new_state.mode_bit;
+
+	return count;
+}
+
+static ssize_t kbd_led_als_enabled_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct kbd_state state;
+	bool enabled = false;
+	int ret;
+
+	if (kbd_als_supported) {
+		ret = kbd_get_state(&state);
+		if (ret)
+			return ret;
+		enabled = kbd_is_als_mode_bit(state.mode_bit);
+	}
+
+	return sprintf(buf, "%d\n", enabled ? 1 : 0);
+}
+
+static DEVICE_ATTR(als_enabled, S_IRUGO | S_IWUSR,
+		   kbd_led_als_enabled_show, kbd_led_als_enabled_store);
+
+static ssize_t kbd_led_als_setting_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
 {
 	struct kbd_state state;
 	struct kbd_state new_state;
@@ -1708,8 +1728,9 @@ static ssize_t kbd_led_als_store(struct device *dev,
 	return count;
 }
 
-static ssize_t kbd_led_als_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t kbd_led_als_setting_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
 {
 	struct kbd_state state;
 	int ret;
@@ -1722,11 +1743,12 @@ static ssize_t kbd_led_als_show(struct device *dev,
 }
 
 static DEVICE_ATTR(als_setting, S_IRUGO | S_IWUSR,
-		   kbd_led_als_show, kbd_led_als_store);
+		   kbd_led_als_setting_show, kbd_led_als_setting_store);
 
 static struct attribute *kbd_led_attrs[] = {
 	&dev_attr_stop_timeout.attr,
 	&dev_attr_start_triggers.attr,
+	&dev_attr_als_enabled.attr,
 	&dev_attr_als_setting.attr,
 	NULL,
 };
-- 
2.1.4

