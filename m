Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaIWQOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbaIWQIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:08:18 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        killertofu@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] HID: wacom: move allocation of inputs earlier
Date: Tue, 23 Sep 2014 12:08:07 -0400
Message-Id: <1411488489-10625-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to have the input devices ready in while parsing the reports
descriptor.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 62f3c89..21ac2ba 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1357,6 +1357,12 @@ static int wacom_probe(struct hid_device *hdev,
 	mutex_init(&wacom->lock);
 	INIT_WORK(&wacom->work, wacom_wireless_work);
 
+	if (!(features->quirks & WACOM_QUIRK_NO_INPUT)) {
+		error = wacom_allocate_inputs(wacom);
+		if (error)
+			goto fail_allocate_inputs;
+	}
+
 	/* set the default size in case we do not get them from hid */
 	wacom_set_default_phy(features);
 
@@ -1429,8 +1435,7 @@ static int wacom_probe(struct hid_device *hdev,
 	}
 
 	if (!(features->quirks & WACOM_QUIRK_NO_INPUT)) {
-		error = wacom_allocate_inputs(wacom) ||
-			wacom_register_inputs(wacom);
+		error = wacom_register_inputs(wacom);
 		if (error)
 			goto fail_register_inputs;
 	}
@@ -1464,7 +1469,6 @@ static int wacom_probe(struct hid_device *hdev,
 	return 0;
 
 fail_hw_start:
-	wacom_clean_inputs(wacom);
 	if (hdev->bus == BUS_BLUETOOTH)
 		device_remove_file(&hdev->dev, &dev_attr_speed);
 fail_register_inputs:
@@ -1473,6 +1477,8 @@ fail_register_inputs:
 fail_battery:
 	wacom_remove_shared_data(wacom_wac);
 fail_shared_data:
+	wacom_clean_inputs(wacom);
+fail_allocate_inputs:
 fail_type:
 fail_pktlen:
 fail_parse:
-- 
2.1.0

