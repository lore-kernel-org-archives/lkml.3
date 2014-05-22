Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaEVSDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:03:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:51899 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaEVSC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="516171723"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V7 05/11] ACPI: allow scan handlers without .attach() callback
Date: Fri, 23 May 2014 02:02:27 +0800
Message-Id: <1400781753-2682-6-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices that can be attached to scan handlers, are kind of different from
the others, because they are known that some special actions should be taken.

But we do not mark this difference when the configurable scan handlers
are compiled out. This is harmless currently, but it will be when
we want to take some common actions to the other "non-special" devices,
which will be done in a later patch.

This patch makes .attach() of the acpi scan handler optional.
So that the configurable scan handlers can provide NULL .attach() callback
when not supported.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index c82ab73..e9c2f6f 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL_GPL(acpi_initialize_hp_context);
 
 int acpi_scan_add_handler(struct acpi_scan_handler *handler)
 {
-	if (!handler || !handler->attach)
+	if (!handler)
 		return -EINVAL;
 
 	list_add_tail(&handler->list_node, &acpi_scan_handlers_list);
@@ -2066,6 +2066,12 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 	return AE_OK;
 }
 
+static int acpi_scan_handler_dummy_attach(struct acpi_device *device,
+				const struct acpi_device_id *devid)
+{
+	return 1;
+}
+
 static int acpi_scan_attach_handler(struct acpi_device *device)
 {
 	struct acpi_hardware_id *hwid;
@@ -2078,7 +2084,10 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
 		handler = acpi_scan_match_handler(hwid->id, &devid);
 		if (handler) {
 			device->handler = handler;
-			ret = handler->attach(device, devid);
+			if (handler->attach)
+				ret = handler->attach(device, devid);
+			else
+				ret = acpi_scan_handler_dummy_attach(device, devid);
 			if (ret > 0)
 				break;
 
-- 
1.8.3.2

