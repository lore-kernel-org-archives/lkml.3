Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaF3V2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:28:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbaF3V0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:54 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 11/15] HID: uhid: add and set HID_TYPE_UHID for uhid devices
Date: Mon, 30 Jun 2014 17:26:22 -0400
Message-Id: <1404163586-29582-12-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some wacom devices checks on the .type field of hid_device. However,
uhid never set it, and as a result, we can not use uhid with some of
the wacom tablets.

Create a HID type HID_TYPE_UHID which is set by uhid and taken into
account by wacom.ko.

With this patch, the wacom.ko driver is completely agnostic of the
USB layer, except for the Wireless Receiver. That means that starting
from now, we can check every changes through uhis and comparing the
resulting kernel device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/uhid.c               | 2 ++
 drivers/input/tablet/wacom_sys.c | 3 ++-
 include/linux/hid.h              | 3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 0cb92e3..6dbe2e0 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -407,6 +407,7 @@ static int uhid_dev_create(struct uhid_device *uhid,
 	hid->country = ev->u.create.country;
 	hid->driver_data = uhid;
 	hid->dev.parent = uhid_misc.this_device;
+	hid->type = HID_TYPE_UHID;
 
 	uhid->hid = hid;
 	uhid->running = true;
@@ -467,6 +468,7 @@ static int uhid_dev_create2(struct uhid_device *uhid,
 	hid->country = ev->u.create2.country;
 	hid->driver_data = uhid;
 	hid->dev.parent = uhid_misc.this_device;
+	hid->type = HID_TYPE_UHID;
 
 	uhid->hid = hid;
 	uhid->running = true;
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 2208b4a..065c6d5 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1261,7 +1261,8 @@ static int wacom_probe(struct hid_device *hdev,
 		goto fail1;
 	}
 
-	if (features->check_for_hid_type && features->hid_type != hdev->type) {
+	if (hdev->type != HID_TYPE_UHID &&
+	    features->check_for_hid_type && features->hid_type != hdev->type) {
 		error = -ENODEV;
 		goto fail1;
 	}
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 9732299..df3c103 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -448,7 +448,8 @@ struct hid_input {
 enum hid_type {
 	HID_TYPE_OTHER = 0,
 	HID_TYPE_USBMOUSE,
-	HID_TYPE_USBNONE
+	HID_TYPE_USBNONE,
+	HID_TYPE_UHID
 };
 
 struct hid_driver;
-- 
2.0.0

