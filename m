Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaLSWr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:47:29 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:64859 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752724AbaLSWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:47:27 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 19 Dec 2014 15:12:44 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 2/3] HID: rmi: Support touchpads with external buttons
Date: Fri, 19 Dec 2014 14:45:42 -0800
Message-ID: <1419029143-20484-2-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419029143-20484-1-git-send-email-aduggan@synaptics.com>
References: <1419029143-20484-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The external buttons on HID touchpads are connected as pass through devices and
button events are not reported in the rmi registers. As a result on these
devices we need to allow the HID generic desktop button events to be processed
by hid-input.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 018f80f..cdfe165 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -35,6 +35,7 @@
 
 /* device flags */
 #define RMI_DEVICE			BIT(0)
+#define RMI_DEVICE_HAS_PHYS_BUTTONS	BIT(1)
 
 enum rmi_mode_type {
 	RMI_MODE_OFF			= 0,
@@ -472,6 +473,9 @@ static int rmi_event(struct hid_device *hdev, struct hid_field *field,
 	if ((data->device_flags & RMI_DEVICE) &&
 	    (field->application == HID_GD_POINTER ||
 	    field->application == HID_GD_MOUSE)) {
+		if ((usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
+			return 0;
+
 		rmi_schedule_reset(hdev);
 		return 1;
 	}
@@ -942,6 +946,10 @@ static int rmi_input_mapping(struct hid_device *hdev,
 	 * we want to make HID ignore the advertised HID collection
 	 * for RMI deivces
 	 */
+	if ((data->device_flags & RMI_DEVICE_HAS_PHYS_BUTTONS) &&
+	    ((usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON))
+		return 0;
+
 	if (data->device_flags & RMI_DEVICE)
 		return -1;
 
-- 
2.1.0

