Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaBTUZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:25:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbaBTUZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:25:00 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: benjamin.tissoires@gmail.com, jkosina@suse.cz, dh.herrmann@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] HID: make .raw_request mandatory
Date: Thu, 20 Feb 2014 15:24:49 -0500
Message-Id: <1392927890-2389-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SET_REPORT and GET_REPORT are mandatory in the HID specification.
Make the corresponding API in hid-core mandatory too, which removes the
need to test against it in some various places.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

new in v2

 Documentation/hid/hid-transport.txt |  3 ++-
 drivers/hid/hid-core.c              | 11 ++++++++---
 drivers/hid/hid-input.c             |  4 +---
 include/linux/hid.h                 |  5 +----
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/hid/hid-transport.txt b/Documentation/hid/hid-transport.txt
index 9dbbcea..3dcba9f 100644
--- a/Documentation/hid/hid-transport.txt
+++ b/Documentation/hid/hid-transport.txt
@@ -283,7 +283,8 @@ The available HID callbacks are:
                        int reqtype)
    Same as ->request() but provides the report as raw buffer. This request shall
    be synchronous. A transport driver must not use ->wait() to complete such
-   requests.
+   requests. This request is mandatory and hid core will reject the device if
+   it is missing.
 
  - int (*output_report) (struct hid_device *hdev, __u8 *buf, size_t len)
    Send raw output report via intr channel. Used by some HID device drivers
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index fdf3247..9190090 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1330,9 +1330,6 @@ void __hid_request(struct hid_device *hid, struct hid_report *report,
 	int ret;
 	int len;
 
-	if (!hid->ll_driver->raw_request)
-		return;
-
 	buf = hid_alloc_report_buf(report, GFP_KERNEL);
 	if (!buf)
 		return;
@@ -2475,6 +2472,14 @@ int hid_add_device(struct hid_device *hdev)
 		return -ENODEV;
 
 	/*
+	 * Check for the mandatory transport channel.
+	 */
+	 if (!hdev->ll_driver->raw_request) {
+		hid_err(hdev, "transport driver missing .raw_request()\n");
+		return -EINVAL;
+	 }
+
+	/*
 	 * Read the device report descriptor once and use as template
 	 * for the driver-specific modifications.
 	 */
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index e3d625a..930382e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1269,9 +1269,7 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
 	}
 
 	input_set_drvdata(input_dev, hid);
-	if (hid->ll_driver->request || hid->ll_driver->output_report ||
-	    hid->ll_driver->raw_request)
-		input_dev->event = hidinput_input_event;
+	input_dev->event = hidinput_input_event;
 	input_dev->open = hidinput_open;
 	input_dev->close = hidinput_close;
 	input_dev->setkeycode = hidinput_setkeycode;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 60f3ff7..5eb282e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -992,11 +992,8 @@ static inline int hid_hw_raw_request(struct hid_device *hdev,
 	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
 		return -EINVAL;
 
-	if (hdev->ll_driver->raw_request)
-		return hdev->ll_driver->raw_request(hdev, reportnum, buf, len,
+	return hdev->ll_driver->raw_request(hdev, reportnum, buf, len,
 						    rtype, reqtype);
-
-	return -ENOSYS;
 }
 
 /**
-- 
1.8.5.3

