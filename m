Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaEUIdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:33:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:26839 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaEUIda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="535330149"
Message-ID: <537C64D7.4010900@intel.com>
Date: Wed, 21 May 2014 16:33:27 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Kui Zhang <kuizhang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: [PATCH] thermal: hwmon: Make the check for critical temp valid consistent
References: <CAKx2Y1mzLesGFYz30fH8xCZTkvNGPUNYkHptYLYq_hVExoh_8g@mail.gmail.com> <537C6262.5030500@intel.com>
In-Reply-To: <537C6262.5030500@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/thermal/thermal_hwmon.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
index fdb07199d9c2..1967bee4f076 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -140,6 +140,12 @@ thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
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
@@ -189,21 +195,18 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
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
@@ -250,7 +253,7 @@ void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (tz->ops->get_crit_temp)
+	if (thermal_zone_crit_temp_valid(tz))
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_hwmon_list_lock);
-- 
1.9.0

