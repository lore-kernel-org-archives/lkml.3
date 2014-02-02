Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaBBEvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:51:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaBBEur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:50:47 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] HID: HIDp: remove hidp_hidinput_event
Date: Sat,  1 Feb 2014 23:50:24 -0500
Message-Id: <1391316630-29541-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hidp uses its own ->hidinput_input_event() instead of the generic binding
in hid-input.
Moving the handling of LEDs towards hidp_hidinput_event() allows two things:
- remove hidinput_input_event definitively from struct hid_device
- hidraw user space programs can also set the LEDs

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 net/bluetooth/hidp/core.c | 46 ----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index b062cee..469e61b 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -223,51 +223,6 @@ static void hidp_input_report(struct hidp_session *session, struct sk_buff *skb)
 	input_sync(dev);
 }
 
-static int hidp_send_report(struct hidp_session *session, struct hid_report *report)
-{
-	unsigned char hdr;
-	u8 *buf;
-	int rsize, ret;
-
-	buf = hid_alloc_report_buf(report, GFP_ATOMIC);
-	if (!buf)
-		return -EIO;
-
-	hid_output_report(report, buf);
-	hdr = HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT;
-
-	rsize = ((report->size - 1) >> 3) + 1 + (report->id > 0);
-	ret = hidp_send_intr_message(session, hdr, buf, rsize);
-
-	kfree(buf);
-	return ret;
-}
-
-static int hidp_hidinput_event(struct input_dev *dev, unsigned int type,
-			       unsigned int code, int value)
-{
-	struct hid_device *hid = input_get_drvdata(dev);
-	struct hidp_session *session = hid->driver_data;
-	struct hid_field *field;
-	int offset;
-
-	BT_DBG("session %p type %d code %d value %d",
-	       session, type, code, value);
-
-	if (type != EV_LED)
-		return -1;
-
-	offset = hidinput_find_field(hid, type, code, &field);
-	if (offset == -1) {
-		hid_warn(dev, "event field not found\n");
-		return -1;
-	}
-
-	hid_set_field(field, offset, value);
-
-	return hidp_send_report(session, field->report);
-}
-
 static int hidp_get_raw_report(struct hid_device *hid,
 		unsigned char report_number,
 		unsigned char *data, size_t count,
@@ -817,7 +772,6 @@ static struct hid_ll_driver hidp_hid_driver = {
 	.close = hidp_close,
 	.raw_request = hidp_raw_request,
 	.output_report = hidp_output_report,
-	.hidinput_input_event = hidp_hidinput_event,
 };
 
 /* This function sets up the hid device. It does not add it
-- 
1.8.3.1

