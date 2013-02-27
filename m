Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423Ab3B0Q4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:56:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760192Ab3B0Q4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:56:22 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] HID: input: don't register unmapped input devices
Date: Wed, 27 Feb 2013 17:55:21 +0100
Message-Id: <1361984127-912-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to register an input device containing no events.
This allows drivers using the quirk MULTI_INPUT to register one input
per report effectively used.

For backward compatibility, we need to add a quirk to request
this behavior.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-input.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hid.h     |  1 +
 2 files changed, 78 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 21b196c..7aaf7d3 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1198,6 +1198,67 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
 	return hidinput;
 }
 
+static bool hidinput_has_been_populated(struct hid_input *hidinput)
+{
+	int i;
+	bool r = 0;
+
+	for (i = 0; i < BITS_TO_LONGS(EV_CNT); i++)
+		r = r || hidinput->input->evbit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(KEY_CNT); i++)
+		r = r || hidinput->input->keybit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(REL_CNT); i++)
+		r = r || hidinput->input->relbit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(ABS_CNT); i++)
+		r = r || hidinput->input->absbit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(MSC_CNT); i++)
+		r = r || hidinput->input->mscbit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(LED_CNT); i++)
+		r = r || hidinput->input->ledbit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(SND_CNT); i++)
+		r = r || hidinput->input->sndbit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(FF_CNT); i++)
+		r = r || hidinput->input->ffbit[i];
+
+	for (i = 0; i < BITS_TO_LONGS(SW_CNT); i++)
+		r = r || hidinput->input->swbit[i];
+
+	return !!r;
+}
+
+static void hidinput_cleanup_hidinput(struct hid_device *hid,
+		struct hid_input *hidinput)
+{
+	struct hid_report *report;
+	int i, k;
+
+	list_del(&hidinput->list);
+	input_free_device(hidinput->input);
+
+	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++) {
+		if (k == HID_OUTPUT_REPORT &&
+			hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
+			continue;
+
+		list_for_each_entry(report, &hid->report_enum[k].report_list,
+				    list) {
+
+			for (i = 0; i < report->maxfield; i++)
+				if (report->field[i]->hidinput == hidinput)
+					report->field[i]->hidinput = NULL;
+		}
+	}
+
+	kfree(hidinput);
+}
+
 /*
  * Register the input device; print a message.
  * Configure the input layer interface
@@ -1249,6 +1310,10 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 					hidinput_configure_usage(hidinput, report->field[i],
 								 report->field[i]->usage + j);
 
+			if ((hid->quirks & HID_QUIRK_NO_EMPTY_INPUT) &&
+			    !hidinput_has_been_populated(hidinput))
+				continue;
+
 			if (hid->quirks & HID_QUIRK_MULTI_INPUT) {
 				/* This will leave hidinput NULL, so that it
 				 * allocates another one if we have more inputs on
@@ -1265,6 +1330,18 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 		}
 	}
 
+	if (hidinput && (hid->quirks & HID_QUIRK_NO_EMPTY_INPUT) &&
+	    !hidinput_has_been_populated(hidinput)) {
+		/* no need to register an input device not populated */
+		hidinput_cleanup_hidinput(hid, hidinput);
+		hidinput = NULL;
+	}
+
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "No inputs registered, leaving\n");
+		goto out_unwind;
+	}
+
 	if (hidinput) {
 		if (drv->input_configured)
 			drv->input_configured(hid, hidinput);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7071eb3..15b98a6 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -282,6 +282,7 @@ struct hid_item {
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
+#define HID_QUIRK_NO_EMPTY_INPUT		0x00000100
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
-- 
1.8.1.2

