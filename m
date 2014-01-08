Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaAHWTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:19:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395AbaAHWTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:19:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] HID: logitech-dj: add .request callback
Date: Wed,  8 Jan 2014 17:18:49 -0500
Message-Id: <1389219529-29671-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>

The .request callback allows to send data from the dj device driver to the
device. Because of the DJ protocol, we only authorize HID++ communication
through this request.

The device index has to be overwritten by the receiver. All communication pass
through it, and the receiver is the only one to know which dj device has which
device index.
Furthermore, this allows to use the same calls from the driver point of view:
if a device is connected through a DJ interface, the receiver will overwrite
the device index, if it is connected through another bus (like bluetooth),
then the transport layer will not change the report, and it will be correctly
forwarded to the device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 3444feb..4335d21 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -624,6 +624,22 @@ static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 	return 0;
 }
 
+static void logi_dj_ll_request(struct hid_device *hid, struct hid_report *rep,
+		int reqtype)
+{
+	struct dj_device *djdev = hid->driver_data;
+	struct dj_receiver_dev *djrcv_dev = djdev->dj_receiver_dev;
+
+	if ((rep->id != REPORT_ID_HIDPP_LONG) &&
+	    (rep->id != REPORT_ID_HIDPP_SHORT))
+		/* prevent forwarding of non acceptable reports */
+		return;
+
+	hid_set_field(rep->field[0], 0, djdev->device_index);
+
+	hid_hw_request(djrcv_dev->hdev, rep, reqtype);
+}
+
 static void rdcat(char *rdesc, unsigned int *rsize, const char *data, unsigned int size)
 {
 	memcpy(rdesc + *rsize, data, size);
@@ -759,6 +775,7 @@ static struct hid_ll_driver logi_dj_ll_driver = {
 	.stop = logi_dj_ll_stop,
 	.open = logi_dj_ll_open,
 	.close = logi_dj_ll_close,
+	.request = logi_dj_ll_request,
 	.hidinput_input_event = logi_dj_ll_input_event,
 };
 
-- 
1.8.4.2

