Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaIPK5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:57:41 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63803 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaIPK5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:57:39 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: rui.zhang@intel.com, edubezval@gmail.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [PATCH] thermal: show supported policies
Date: Tue, 16 Sep 2014 16:27:42 +0530
Message-Id: <1410865062-28995-1-git-send-email-sanjay.rawat@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With knowledge of supported thermal policies from this attribute, it helps in
setting the policy without failure from the available ones.

Signed-off-by: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
---
 drivers/thermal/thermal_core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 71b0ec0..6caefcd 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -772,6 +772,25 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
 	return sprintf(buf, "%s\n", tz->governor->name);
 }
 
+static ssize_t
+available_policy_show(struct device *dev, struct device_attribute *devattr,
+			char *buf)
+{
+	ssize_t i = 0;
+	struct thermal_governor *temp;
+	struct thermal_zone_device *tz = to_thermal_zone(dev);
+
+	mutex_lock(&tz->lock);
+
+	list_for_each_entry(temp, &thermal_governor_list, governor_list)
+		i += sprintf(&buf[i], "%s ", temp->name);
+
+	mutex_unlock(&tz->lock);
+	i += sprintf(&buf[i], "\n");
+
+	return i;
+}
+
 #ifdef CONFIG_THERMAL_EMULATION
 static ssize_t
 emul_temp_store(struct device *dev, struct device_attribute *attr,
@@ -805,6 +824,7 @@ static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
 static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
 static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
+static DEVICE_ATTR(available_policy, S_IRUGO, available_policy_show, NULL);
 
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
@@ -1538,6 +1558,10 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	if (result)
 		goto unregister;
 
+	result = device_create_file(&tz->device, &dev_attr_available_policy);
+	if (result)
+		goto unregister;
+
 	/* Update 'this' zone's governor information */
 	mutex_lock(&thermal_governor_lock);
 
-- 
1.8.3.2

