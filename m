Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3JHGj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:39:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:14013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab3JHGjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:39:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1055,1371106800"; 
   d="scan'208";a="415564985"
From: Aaron Lu <aaron.lu@intel.com>
To: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Ben Jencks <ben@bjencks.net>,
        Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        platform-driver-x86@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH v4 4/4] thinkpad-acpi: fix handle locate for video and query of _BCL
Date: Tue,  8 Oct 2013 14:40:01 +0800
Message-Id: <1381214401-24672-5-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.4.12.g2ea3df6
In-Reply-To: <1381214401-24672-1-git-send-email-aaron.lu@intel.com>
References: <1381214401-24672-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tpacpi_acpi_handle_locate function makes use of acpi_get_devices to
locate handle for ACPI video by HID, the problem is, ACPI video node
doesn't really have HID defined(i.e. no _HID control method is defined
for video device), so.. that function would fail. This can be solved by
enhancing the callback function for acpi_get_devices, where we can use
acpi_device_hid function to check if the ACPI node corresponds to a
video controller.

In addition to that, the _BCL control method only exists under a video
output device node, not a video controller device node. So to evaluate
_BCL, we need the handle of a video output device node, which is child
of the located video controller node from tpacpi_acpi_handle_locate.

The two fix are necessary for some Thinkpad models to emit notification
on backlight hotkey press as a result of evaluation of _BCL.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 drivers/platform/x86/thinkpad_acpi.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 03ca6c1..170f278 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -700,6 +700,14 @@ static void __init drv_acpi_handle_init(const char *name,
 static acpi_status __init tpacpi_acpi_handle_locate_callback(acpi_handle handle,
 			u32 level, void *context, void **return_value)
 {
+	struct acpi_device *dev;
+	if (!strcmp(context, "video")) {
+		if (acpi_bus_get_device(handle, &dev))
+			return AE_OK;
+		if (strcmp(ACPI_VIDEO_HID, acpi_device_hid(dev)))
+			return AE_OK;
+	}
+
 	*(acpi_handle *)return_value = handle;
 
 	return AE_CTRL_TERMINATE;
@@ -712,10 +720,10 @@ static void __init tpacpi_acpi_handle_locate(const char *name,
 	acpi_status status;
 	acpi_handle device_found;
 
-	BUG_ON(!name || !hid || !handle);
+	BUG_ON(!name || !handle);
 	vdbg_printk(TPACPI_DBG_INIT,
 			"trying to locate ACPI handle for %s, using HID %s\n",
-			name, hid);
+			name, hid ? hid : "NULL");
 
 	memset(&device_found, 0, sizeof(device_found));
 	status = acpi_get_devices(hid, tpacpi_acpi_handle_locate_callback,
@@ -6090,19 +6098,28 @@ static int __init tpacpi_query_bcl_levels(acpi_handle handle)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
+	struct acpi_device *device, *child;
 	int rc;
 
-	if (ACPI_SUCCESS(acpi_evaluate_object(handle, "_BCL", NULL, &buffer))) {
+	if (acpi_bus_get_device(handle, &device))
+		return 0;
+
+	rc = 0;
+	list_for_each_entry(child, &device->children, node) {
+		acpi_status status = acpi_evaluate_object(child->handle, "_BCL",
+							  NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			continue;
+
 		obj = (union acpi_object *)buffer.pointer;
 		if (!obj || (obj->type != ACPI_TYPE_PACKAGE)) {
 			pr_err("Unknown _BCL data, please report this to %s\n",
-			       TPACPI_MAIL);
+				TPACPI_MAIL);
 			rc = 0;
 		} else {
 			rc = obj->package.count;
 		}
-	} else {
-		return 0;
+		break;
 	}
 
 	kfree(buffer.pointer);
@@ -6118,7 +6135,7 @@ static unsigned int __init tpacpi_check_std_acpi_brightness_support(void)
 	acpi_handle video_device;
 	int bcl_levels = 0;
 
-	tpacpi_acpi_handle_locate("video", ACPI_VIDEO_HID, &video_device);
+	tpacpi_acpi_handle_locate("video", NULL, &video_device);
 	if (video_device)
 		bcl_levels = tpacpi_query_bcl_levels(video_device);
 
-- 
1.8.4.12.g2ea3df6

