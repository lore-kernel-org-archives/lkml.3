Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaDDRN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:13:29 -0400
Received: from smtp03.udag.de ([62.146.106.29]:41277 "EHLO smtp03.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbaDDRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:13:25 -0400
From: Tolga Cakir <tolga@cevel.net>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Derya <derya.kiran@yahoo.de>, Jiri Kosina <jkosina@suse.cz>,
        Reyad Attiyat <reyad.attiyat@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tolga Cakir <tolga@cevel.net>
Subject: [PATCH 1/4] HID: microsoft: moving quirks to struct
Date: Fri,  4 Apr 2014 19:06:13 +0200
Message-Id: <1396631173-11668-1-git-send-email-tolga@cevel.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will give us the opportunity to easily implement extra features
for new devices.

Signed-off-by: Tolga Cakir <tolga@cevel.net>
---
 drivers/hid/hid-microsoft.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 6fd5817..0a61403 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -30,23 +30,28 @@
 #define MS_DUPLICATE_USAGES	0x20
 #define MS_RDESC_3K		0x40
 
+struct ms_data {
+	unsigned long quirks;
+	void *extra;
+};
+
 static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 
 	/*
 	 * Microsoft Wireless Desktop Receiver (Model 1028) has
 	 * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
 	 */
-	if ((quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
+	if ((sc->quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
 			rdesc[559] == 0x29) {
 		hid_info(hdev, "fixing up Microsoft Wireless Receiver Model 1028 report descriptor\n");
 		rdesc[557] = 0x35;
 		rdesc[559] = 0x45;
 	}
 	/* the same as above (s/usage/physical/) */
-	if ((quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
+	if ((sc->quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
 			rdesc[95] == 0x00 && rdesc[96] == 0x29 &&
 			rdesc[97] == 0xff) {
 		rdesc[94] = 0x35;
@@ -142,15 +147,15 @@ static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 
-	if (quirks & MS_ERGONOMY) {
+	if (sc->quirks & MS_ERGONOMY) {
 		int ret = ms_ergonomy_kb_quirk(hi, usage, bit, max);
 		if (ret)
 			return ret;
 	}
 
-	if ((quirks & MS_PRESENTER) &&
+	if ((sc->quirks & MS_PRESENTER) &&
 			ms_presenter_8k_quirk(hi, usage, bit, max))
 		return 1;
 
@@ -161,9 +166,9 @@ static int ms_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 
-	if (quirks & MS_DUPLICATE_USAGES)
+	if (sc->quirks & MS_DUPLICATE_USAGES)
 		clear_bit(usage->code, *bit);
 
 	return 0;
@@ -172,7 +177,7 @@ static int ms_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 static int ms_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 	struct input_dev *input;
 
 	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput ||
@@ -182,7 +187,7 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
 	input = field->hidinput->input;
 
 	/* Handling MS keyboards special buttons */
-	if (quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff00)) {
+	if (sc->quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff00)) {
 		/* Special keypad keys */
 		input_report_key(input, KEY_KPEQUAL, value & 0x01);
 		input_report_key(input, KEY_KPLEFTPAREN, value & 0x02);
@@ -190,7 +195,7 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
 		return 1;
 	}
 
-	if (quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff01)) {
+	if (sc->quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff01)) {
 		/* Scroll wheel */
 		int step = ((value & 0x60) >> 5) + 1;
 
@@ -205,7 +210,7 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
 		return 1;
 	}
 
-	if (quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
+	if (sc->quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
 		static unsigned int last_key = 0;
 		unsigned int key = 0;
 		switch (value) {
@@ -229,12 +234,19 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
 
 static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
-	unsigned long quirks = id->driver_data;
+	struct ms_data *sc;
 	int ret;
 
-	hid_set_drvdata(hdev, (void *)quirks);
+	sc = devm_kzalloc(&hdev->dev, sizeof(struct ms_data), GFP_KERNEL);
+	if (!sc) {
+		hid_err(hdev, "can't alloc microsoft descriptor\n");
+		return -ENOMEM;
+	}
+
+	sc->quirks = id->driver_data;
+	hid_set_drvdata(hdev, sc);
 
-	if (quirks & MS_NOGET)
+	if (sc->quirks & MS_NOGET)
 		hdev->quirks |= HID_QUIRK_NOGET;
 
 	ret = hid_parse(hdev);
@@ -243,7 +255,7 @@ static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_free;
 	}
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | ((quirks & MS_HIDINPUT) ?
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | ((sc->quirks & MS_HIDINPUT) ?
 				HID_CONNECT_HIDINPUT_FORCE : 0));
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
-- 
1.9.1

