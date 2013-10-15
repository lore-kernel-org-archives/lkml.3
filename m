Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab3JOPFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:05:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:18528 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab3JOPFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,499,1378882800"; 
   d="scan'208";a="419472742"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] ACPI/Power: Add state_lock to mutex power resource's _ON, _OFF and _STA
Date: Tue, 15 Oct 2013 23:04:51 +0800
Message-Id: <1381849493-7977-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381849493-7977-1-git-send-email-tianyu.lan@intel.com>
References: <1381849493-7977-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According commit d0515d9f, power resource's _ON, _OFF and _STA should
be mutexed. This patch is to add state_lock to do this instead of
using resource_lock.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/power.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 0c1c3ec..fa89d16 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -75,6 +75,7 @@ struct acpi_power_resource {
 	unsigned int ref_count;
 	bool wakeup_enabled;
 	struct mutex resource_lock;
+	struct mutex state_lock;
 };
 
 struct acpi_power_resource_entry {
@@ -216,9 +217,9 @@ static int acpi_power_get_list_state(struct list_head *list, int *state)
 		acpi_handle handle = resource->device.handle;
 		int result;
 
-		mutex_lock(&resource->resource_lock);
+		mutex_lock(&resource->state_lock);
 		result = acpi_power_get_state(handle, &cur_state);
-		mutex_unlock(&resource->resource_lock);
+		mutex_unlock(&resource->state_lock);
 		if (result)
 			return result;
 
@@ -263,7 +264,10 @@ static int __acpi_power_on(struct acpi_power_resource *resource)
 {
 	acpi_status status = AE_OK;
 
+	mutex_lock(&resource->state_lock);
 	status = acpi_evaluate_object(resource->device.handle, "_ON", NULL, NULL);
+	mutex_unlock(&resource->state_lock);
+
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
@@ -309,8 +313,11 @@ static int __acpi_power_off(struct acpi_power_resource *resource)
 {
 	acpi_status status;
 
+	mutex_lock(&resource->state_lock);
 	status = acpi_evaluate_object(resource->device.handle, "_OFF",
 				      NULL, NULL);
+	mutex_unlock(&resource->state_lock);
+
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
@@ -564,7 +571,9 @@ int acpi_power_wakeup_list_init(struct list_head *list, int *system_level_p)
 
 		mutex_lock(&resource->resource_lock);
 
+		mutex_lock(&resource->state_lock);
 		result = acpi_power_get_state(handle, &state);
+		mutex_unlock(&resource->state_lock);
 		if (result) {
 			mutex_unlock(&resource->resource_lock);
 			return result;
@@ -881,6 +890,7 @@ int acpi_add_power_resource(acpi_handle handle)
 	device = &resource->device;
 	acpi_init_device_object(device, handle, ACPI_BUS_TYPE_POWER,
 				ACPI_STA_DEFAULT);
+	mutex_init(&resource->state_lock);
 	mutex_init(&resource->resource_lock);
 	INIT_LIST_HEAD(&resource->dependent);
 	INIT_LIST_HEAD(&resource->list_node);
@@ -935,7 +945,10 @@ void acpi_resume_power_resources(void)
 
 		mutex_lock(&resource->resource_lock);
 
+		mutex_lock(&resource->state_lock);
 		result = acpi_power_get_state(resource->device.handle, &state);
+		mutex_unlock(&resource->state_lock);
+
 		if (result) {
 			mutex_unlock(&resource->resource_lock);
 			continue;
-- 
1.8.2.1

