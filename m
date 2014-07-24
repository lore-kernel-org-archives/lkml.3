Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935050AbaGXKCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:02:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934629AbaGXJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Lu <aaron.lu@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 092/128] thermal: hwmon: Make the check for critical temp valid consistent
Date: Thu, 24 Jul 2014 10:45:41 +0100
Message-Id: <1406195177-8656-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit e8db5d6736a712a3e2280c0e31f4b301d85172d8 upstream.

On 05/21/2014 04:22 PM, Aaron Lu wrote:
> On 05/21/2014 01:57 PM, Kui Zhang wrote:
>> Hello,
>>
>> I get following error when rmmod thermal.
>>
>> rmmod  thermal
>> Killed

While dealing with this problem, I found another problem that also
results in a kernel crash on thermal module removal:

From: Aaron Lu <aaron.lu@intel.com>
Date: Wed, 21 May 2014 16:05:38 +0800
Subject: [PATCH] thermal: hwmon: Make the check for critical temp valid consistent

We used the tz->ops->get_crit_temp && !tz->ops->get_crit_temp(tz, temp)
to decide if we need to create the temp_crit attribute file but we just
check if tz->ops->get_crit_temp exists to decide if we need to remove
that attribute file. Some ACPI thermal zone doesn't have a valid critical
trip point and that would result in removing a non-existent device file
on thermal module unload.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
[ luis: backported to 3.11:
  - file rename: thermal_hwmon.c -> thermal_core.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/thermal/thermal_core.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 1f02e8edb45c..3c972c49f2cf 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -971,6 +971,12 @@ thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
 	return NULL;
 }
 
+static bool thermal_zone_crit_temp_valid(struct thermal_zone_device *tz)
+{
+	unsigned long temp;
+	return tz->ops->get_crit_temp && !tz->ops->get_crit_temp(tz, &temp);
+}
+
 static int
 thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 {
@@ -1021,21 +1027,18 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	if (result)
 		goto free_temp_mem;
 
-	if (tz->ops->get_crit_temp) {
-		unsigned long temperature;
-		if (!tz->ops->get_crit_temp(tz, &temperature)) {
-			snprintf(temp->temp_crit.name,
-				 sizeof(temp->temp_crit.name),
+	if (thermal_zone_crit_temp_valid(tz)) {
+		snprintf(temp->temp_crit.name,
+				sizeof(temp->temp_crit.name),
 				"temp%d_crit", hwmon->count);
-			temp->temp_crit.attr.attr.name = temp->temp_crit.name;
-			temp->temp_crit.attr.attr.mode = 0444;
-			temp->temp_crit.attr.show = temp_crit_show;
-			sysfs_attr_init(&temp->temp_crit.attr.attr);
-			result = device_create_file(hwmon->device,
-						    &temp->temp_crit.attr);
-			if (result)
-				goto unregister_input;
-		}
+		temp->temp_crit.attr.attr.name = temp->temp_crit.name;
+		temp->temp_crit.attr.attr.mode = 0444;
+		temp->temp_crit.attr.show = temp_crit_show;
+		sysfs_attr_init(&temp->temp_crit.attr.attr);
+		result = device_create_file(hwmon->device,
+					    &temp->temp_crit.attr);
+		if (result)
+			goto unregister_input;
 	}
 
 	mutex_lock(&thermal_list_lock);
@@ -1083,7 +1086,7 @@ thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (tz->ops->get_crit_temp)
+	if (thermal_zone_crit_temp_valid(tz))
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_list_lock);
-- 
1.9.1

