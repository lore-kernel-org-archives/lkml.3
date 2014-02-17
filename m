Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaBQFCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:02:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:32560 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaBQFCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:02:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="341479349"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC Patch v1 1/6] acpi_pad: simplify notify handler by using acpi_drv_ops->notify
Date: Mon, 17 Feb 2014 13:02:48 +0800
Message-Id: <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use callback acpi_drv_ops->notify to simplify acpi_pad driver's
notification handling code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/acpi_pad.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index df96a0f..1e3ce76 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -443,14 +443,11 @@ static void acpi_pad_handle_notify(acpi_handle handle)
 	mutex_unlock(&isolated_cpus_lock);
 }
 
-static void acpi_pad_notify(acpi_handle handle, u32 event,
-	void *data)
+static void acpi_pad_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_device *device = data;
-
 	switch (event) {
 	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
-		acpi_pad_handle_notify(handle);
+		acpi_pad_handle_notify(device->handle);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 			dev_name(&device->dev), event, 0);
 		break;
@@ -462,22 +459,10 @@ static void acpi_pad_notify(acpi_handle handle, u32 event,
 
 static int acpi_pad_add(struct acpi_device *device)
 {
-	acpi_status status;
-
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
 
-	if (acpi_pad_add_sysfs(device))
-		return -ENODEV;
-
-	status = acpi_install_notify_handler(device->handle,
-		ACPI_DEVICE_NOTIFY, acpi_pad_notify, device);
-	if (ACPI_FAILURE(status)) {
-		acpi_pad_remove_sysfs(device);
-		return -ENODEV;
-	}
-
-	return 0;
+	return acpi_pad_add_sysfs(device);
 }
 
 static int acpi_pad_remove(struct acpi_device *device)
@@ -486,9 +471,8 @@ static int acpi_pad_remove(struct acpi_device *device)
 	acpi_pad_idle_cpus(0);
 	mutex_unlock(&isolated_cpus_lock);
 
-	acpi_remove_notify_handler(device->handle,
-		ACPI_DEVICE_NOTIFY, acpi_pad_notify);
 	acpi_pad_remove_sysfs(device);
+
 	return 0;
 }
 
@@ -505,6 +489,7 @@ static struct acpi_driver acpi_pad_driver = {
 	.ops = {
 		.add = acpi_pad_add,
 		.remove = acpi_pad_remove,
+		.notify = acpi_pad_notify,
 	},
 };
 
-- 
1.7.10.4

