Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaBEAzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:55:00 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12392 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaBEAy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:54:58 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@rjwysocki.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI hotplug: Fix panic on eject to ejected device
Date: Tue,  4 Feb 2014 17:48:28 -0700
Message-Id: <1391561308-18893-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an eject request is sent to an ejected ACPI device, the following
panic occurs:

 ACPI: \_SB_.SCK3.CPU3: ACPI_NOTIFY_EJECT_REQUEST event
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
 IP: [<ffffffff813a7cfe>] acpi_device_hotplug+0x10b/0x33b
	:
 Call Trace:
 [<ffffffff813a24da>] acpi_hotplug_work_fn+0x1c/0x27
 [<ffffffff8109cbe5>] process_one_work+0x175/0x430
 [<ffffffff8109d7db>] worker_thread+0x11b/0x3a0

This is becase device->handler is NULL in acpi_device_hotplug().
This case was used to fail in acpi_hotplug_notify_cb() as the target
had no acpi_deivce.  However, acpi_device now exists after ejection.

Added a check to verify if acpi_device->handler is valid for an
eject request in acpi_hotplug_notify_cb().  Note that handler passed
from an argument is still valid while acpi_device->handler is NULL.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7384158..5cf6adf 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -484,7 +484,6 @@ static void acpi_device_hotplug(void *data, u32 src)
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
-	struct acpi_scan_handler *handler = data;
 	struct acpi_device *adev;
 	acpi_status status;
 
@@ -500,7 +499,9 @@ static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		if (!handler->hotplug.enabled) {
+		if (!adev->handler)
+			goto err_out;
+		if (!adev->handler->hotplug.enabled) {
 			acpi_handle_err(handle, "Eject disabled\n");
 			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
 			goto err_out;
