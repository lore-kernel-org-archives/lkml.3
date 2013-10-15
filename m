Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab3JOPGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:06:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:12620 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab3JOPGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:06:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,499,1378882800"; 
   d="scan'208";a="375026418"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] ACPI/POWER: Rework acpi_power_get_state()
Date: Tue, 15 Oct 2013 23:04:52 +0800
Message-Id: <1381849493-7977-3-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381849493-7977-1-git-send-email-tianyu.lan@intel.com>
References: <1381849493-7977-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make acpi_power_get_state() to accept struct acpi_power_resource as param
instead of acpi_handle and hold state_lock inside of acpi_power_get_state().

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/power.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index fa89d16..3fc2873 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -176,8 +176,10 @@ int acpi_extract_power_resources(union acpi_object *package, unsigned int start,
 	return err;
 }
 
-static int acpi_power_get_state(acpi_handle handle, int *state)
+static int acpi_power_get_state(struct acpi_power_resource *resource,
+				int *state)
 {
+	acpi_handle handle = resource->device.handle;
 	acpi_status status = AE_OK;
 	unsigned long long sta = 0;
 	char node_name[5];
@@ -187,7 +189,10 @@ static int acpi_power_get_state(acpi_handle handle, int *state)
 	if (!handle || !state)
 		return -EINVAL;
 
+	mutex_lock(&resource->state_lock);
 	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+	mutex_unlock(&resource->state_lock);
+
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
@@ -213,13 +218,9 @@ static int acpi_power_get_list_state(struct list_head *list, int *state)
 
 	/* The state of the list is 'on' IFF all resources are 'on'. */
 	list_for_each_entry(entry, list, node) {
-		struct acpi_power_resource *resource = entry->resource;
-		acpi_handle handle = resource->device.handle;
 		int result;
 
-		mutex_lock(&resource->state_lock);
-		result = acpi_power_get_state(handle, &cur_state);
-		mutex_unlock(&resource->state_lock);
+		result = acpi_power_get_state(entry->resource, &cur_state);
 		if (result)
 			return result;
 
@@ -565,15 +566,12 @@ int acpi_power_wakeup_list_init(struct list_head *list, int *system_level_p)
 
 	list_for_each_entry(entry, list, node) {
 		struct acpi_power_resource *resource = entry->resource;
-		acpi_handle handle = resource->device.handle;
 		int result;
 		int state;
 
 		mutex_lock(&resource->resource_lock);
 
-		mutex_lock(&resource->state_lock);
-		result = acpi_power_get_state(handle, &state);
-		mutex_unlock(&resource->state_lock);
+		result = acpi_power_get_state(entry->resource, &state);
 		if (result) {
 			mutex_unlock(&resource->resource_lock);
 			return result;
@@ -907,7 +905,7 @@ int acpi_add_power_resource(acpi_handle handle)
 	resource->system_level = acpi_object.power_resource.system_level;
 	resource->order = acpi_object.power_resource.resource_order;
 
-	result = acpi_power_get_state(handle, &state);
+	result = acpi_power_get_state(resource, &state);
 	if (result)
 		goto err;
 
@@ -945,10 +943,7 @@ void acpi_resume_power_resources(void)
 
 		mutex_lock(&resource->resource_lock);
 
-		mutex_lock(&resource->state_lock);
-		result = acpi_power_get_state(resource->device.handle, &state);
-		mutex_unlock(&resource->state_lock);
-
+		result = acpi_power_get_state(resource, &state);
 		if (result) {
 			mutex_unlock(&resource->resource_lock);
 			continue;
-- 
1.8.2.1

