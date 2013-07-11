Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab3GKNlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:41:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab3GKNlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:41:42 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Bluetooth: hidp: implement hidinput_input_event callback
Date: Thu, 11 Jul 2013 15:41:29 +0200
Message-Id: <1373550090-30379-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can re-enable hidinput_input_event to allow the leds of bluetooth
keyboards to be set.
Now the callbacks uses hid core to retrieve the right HID report to
send, so this version is safer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 net/bluetooth/hidp/core.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index f13a8da..9c8b50d 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -238,6 +238,31 @@ static int hidp_send_report(struct hidp_session *session, struct hid_report *rep
 	return hidp_send_intr_message(session, hdr, buf, rsize);
 }
 
+static int hidp_hidinput_event(struct input_dev *dev, unsigned int type,
+			       unsigned int code, int value)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct hidp_session *session = hid->driver_data;
+	struct hid_field *field;
+	int offset;
+
+	BT_DBG("session %p type %d code %d value %d",
+	       session, type, code, value);
+
+	if (type != EV_LED)
+		return -1;
+
+	offset = hidinput_find_field(hid, type, code, &field);
+	if (offset == -1) {
+		hid_warn(dev, "event field not found\n");
+		return -1;
+	}
+
+	hid_set_field(field, offset, value);
+
+	return hidp_send_report(session, field->report);
+}
+
 static int hidp_get_raw_report(struct hid_device *hid,
 		unsigned char report_number,
 		unsigned char *data, size_t count,
@@ -711,6 +736,7 @@ static struct hid_ll_driver hidp_hid_driver = {
 	.stop = hidp_stop,
 	.open  = hidp_open,
 	.close = hidp_close,
+	.hidinput_input_event = hidp_hidinput_event,
 };
 
 /* This function sets up the hid device. It does not add it
-- 
1.8.3.1

