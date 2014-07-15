Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965438AbaGOXpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:45:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbaGOXN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 3.15 15/84] thermal: hwmon: Make the check for critical temp valid consistent
Date: Tue, 15 Jul 2014 16:17:12 -0700
Message-Id: <20140715231713.656981767@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Subject: [PATCH 3.15 15/84] thermal: hwmon: Make the check for critical temp valid consistent

We used the tz->ops->get_crit_temp && !tz->ops->get_crit_temp(tz, temp)
to decide if we need to create the temp_crit attribute file but we just
check if tz->ops->get_crit_temp exists to decide if we need to remove
that attribute file. Some ACPI thermal zone doesn't have a valid critical
trip point and that would result in removing a non-existent device file
on thermal module unload.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/thermal_hwmon.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -140,6 +140,12 @@ thermal_hwmon_lookup_temp(const struct t
 	return NULL;
 }
 
+static bool thermal_zone_crit_temp_valid(struct thermal_zone_device *tz)
+{
+	unsigned long temp;
+	return tz->ops->get_crit_temp && !tz->ops->get_crit_temp(tz, &temp);
+}
+
 int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 {
 	struct thermal_hwmon_device *hwmon;
@@ -189,21 +195,18 @@ int thermal_add_hwmon_sysfs(struct therm
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
 
 	mutex_lock(&thermal_hwmon_list_lock);
@@ -250,7 +253,7 @@ void thermal_remove_hwmon_sysfs(struct t
 	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (tz->ops->get_crit_temp)
+	if (thermal_zone_crit_temp_valid(tz))
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_hwmon_list_lock);


