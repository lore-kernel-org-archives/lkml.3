Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaBSGCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:02:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:36553 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaBSGB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:01:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="483861701"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org
Subject: [Patch v2 1/5] ACPI: rename acpi_evaluate_hotplug_ost to acpi_evaluate_ost for reuse
Date: Wed, 19 Feb 2014 14:02:15 +0800
Message-Id: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename acpi_evaluate_hotplug_ost() to acpi_evaluate_ost() for later resue.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/utils.c    |   14 ++++----------
 include/acpi/acpi_bus.h |   10 +++++++++-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 85e3b61..19d0169 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -433,17 +433,15 @@ EXPORT_SYMBOL(acpi_get_physical_device_location);
  * When the platform does not support _OST, this function has no effect.
  */
 acpi_status
-acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
-		u32 status_code, struct acpi_buffer *status_buf)
+acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
+		  struct acpi_buffer *status_buf)
 {
-#ifdef ACPI_HOTPLUG_OST
 	union acpi_object params[3] = {
 		{.type = ACPI_TYPE_INTEGER,},
 		{.type = ACPI_TYPE_INTEGER,},
 		{.type = ACPI_TYPE_BUFFER,}
 	};
 	struct acpi_object_list arg_list = {3, params};
-	acpi_status status;
 
 	params[0].integer.value = source_event;
 	params[1].integer.value = status_code;
@@ -455,13 +453,9 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
 		params[2].buffer.length = 0;
 	}
 
-	status = acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
-	return status;
-#else
-	return AE_OK;
-#endif
+	return acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
 }
-EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
+EXPORT_SYMBOL(acpi_evaluate_ost);
 
 /**
  * acpi_handle_printk: Print message with ACPI prefix and object path
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 8256eb4..adef502 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -49,8 +49,16 @@ acpi_evaluate_reference(acpi_handle handle,
 			struct acpi_object_list *arguments,
 			struct acpi_handle_list *list);
 acpi_status
+acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
+		  struct acpi_buffer *status_buf);
+#ifdef ACPI_HOTPLUG_OST
+#define	acpi_evaluate_hotplug_ost	acpi_evaluate_ost
+#else
+static inline acpi_status
 acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
-			u32 status_code, struct acpi_buffer *status_buf);
+			u32 status_code, struct acpi_buffer *status_buf)
+{ return AE_OK; }
+#endif
 
 acpi_status
 acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
-- 
1.7.10.4

