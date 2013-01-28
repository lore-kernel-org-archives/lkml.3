Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3A1Ru7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:50:59 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:37428 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab3A1Ruv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:50:51 -0500
Message-ID: <5106BA71.6050007@gmail.com>
Date: Mon, 28 Jan 2013 18:50:41 +0100
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/25] HID: multitouch: add support for Nexio 42" panel
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com> <1359120190-18281-3-git-send-email-benjamin.tissoires@gmail.com> <20130128150129.GA3460@polaris.bitmath.org> <D19C60C9-2701-4229-845A-20E0312F842F@enac.fr>
In-Reply-To: <D19C60C9-2701-4229-845A-20E0312F842F@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/28/2013 05:56 PM, Stéphane Chatty wrote:
> 
> Le 28 janv. 2013 à 16:01, Henrik Rydberg a écrit :
> 
>> Hi Benjamin,
>>
>>> This device is the worst device I saw. It keeps TipSwitch and InRange
>>> at 1 for fingers that are not touching the panel.
>>> The solution is to rely on the field ContactCount, which is accurate
>>> as the correct information are packed at the begining of the frame.
>>>
>>> Unfortunately, CountactCount is most of the time at the end of the report.
>>> The solution is to pick it when we have the whole report in raw_event.
>>>
>>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>>> ---
>>> drivers/hid/hid-ids.h        |  3 ++
>>> drivers/hid/hid-multitouch.c | 91 ++++++++++++++++++++++++++++++++++++--------
>>> 2 files changed, 78 insertions(+), 16 deletions(-)
>>
>> I think it would make more sense to introduce a method where the
>> driver sees all report values at once. We have had reasonable cause to
>> add it in the past, but never did.
> 
> 
> I dreamed of this more than once in the early days of hid-multitouch, yes. But then it requires quite a few changes in hid-core.c, doesn't it?
> 

Surprisingly, the hid-core part is very small. The difficulties come in hid-multitouch. But the good is that it's working :)
I'll send an updated series soon.

Cheers,
Benjamin


>From 2ea45e1f42fdf1991a457b36ad9e4e729d9febc6 Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Date: Mon, 28 Jan 2013 18:30:32 +0100
Subject: [PATCH 1/4] HID: add "report" callback

This callback is called when the parsing of the report has been done
by hid core. The driver can now rely on the values stored in the
different fields.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-core.c | 4 ++++
 include/linux/hid.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eb2ee11..754098a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1195,6 +1195,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 {
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
+	struct hid_driver *hdrv;
 	unsigned int a;
 	int rsize, csize = size;
 	u8 *cdata = data;
@@ -1231,6 +1232,9 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 	if (hid->claimed != HID_CLAIMED_HIDRAW) {
 		for (a = 0; a < report->maxfield; a++)
 			hid_input_field(hid, report->field[a], cdata, interrupt);
+		hdrv = hid->driver;
+		if (hdrv && hdrv->report)
+			hdrv->report(hid, report);
 	}
 
 	if (hid->claimed & HID_CLAIMED_INPUT)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7330a0f..09dbd09 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -627,6 +627,7 @@ struct hid_driver {
 	const struct hid_usage_id *usage_table;
 	int (*event)(struct hid_device *hdev, struct hid_field *field,
 			struct hid_usage *usage, __s32 value);
+	void (*report)(struct hid_device *hdev, struct hid_report *report);
 
 	__u8 *(*report_fixup)(struct hid_device *hdev, __u8 *buf,
 			unsigned int *size);
-- 
1.8.1


>From fecc6efa1900611ef601837734f278bc06610aa8 Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Date: Mon, 28 Jan 2013 18:39:51 +0100
Subject: [PATCH 2/4] HID: multitouch: use the callback "report" instead of
 sequential events

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 48 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 61543c0..c692305 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -85,6 +85,7 @@ struct mt_device {
 					   multitouch fields */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
+	unsigned mt_report_id;	/* the report ID of the multitouch device */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__s8 inputmode_index;	/* InputMode HID feature index in the report */
 	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
@@ -428,6 +429,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
+			td->mt_report_id = field->report->id;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -579,6 +581,22 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
+
+	if (field->report->id != td->mt_report_id)
+		/* fallback to the generic hidinput handling */
+		return 0;
+
+	/* we will handle the hidinput part, now remains hiddev */
+	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
+		hid->hiddev_hid_event(hid, field, usage, value);
+
+	return 1;
+}
+
+static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
+				struct hid_usage *usage, __s32 value)
+{
+	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
 
 	if (hid->claimed & HID_CLAIMED_INPUT) {
@@ -635,8 +653,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			break;
 
 		default:
-			/* fallback to the generic hidinput handling */
-			return 0;
+			return;
 		}
 
 		if (usage->usage_index + 1 == field->report_count) {
@@ -650,12 +667,30 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		}
 
 	}
+}
 
-	/* we have handled the hidinput part, now remains hiddev */
-	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
-		hid->hiddev_hid_event(hid, field, usage, value);
+static void mt_report(struct hid_device *hid, struct hid_report *report)
+{
+	struct mt_device *td = hid_get_drvdata(hid);
+	struct hid_field *field;
+	struct hid_field *field_cc = td->contactcount;
+	unsigned count;
+	int r, n;
 
-	return 1;
+	if (report->id != td->mt_report_id)
+		return;
+
+	for (r = 0; r < report->maxfield; r++) {
+		field = report->field[r];
+		count = field->report_count;
+
+		if (!(HID_MAIN_ITEM_VARIABLE & field->flags))
+			continue;
+
+		for (n = 0; n < count; n++)
+			mt_process_mt_event(hid, field, &field->usage[n],
+					field->value[n]);
+	}
 }
 
 static void mt_set_input_mode(struct hid_device *hdev)
@@ -1193,6 +1228,7 @@ static struct hid_driver mt_driver = {
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
+	.report = mt_report,
 #ifdef CONFIG_PM
 	.reset_resume = mt_reset_resume,
 	.resume = mt_resume,
-- 
1.8.1



>From 02f3c2f43fa31838dc8faef65690439c85a66086 Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Date: Mon, 28 Jan 2013 18:37:59 +0100
Subject: [PATCH 4/4] HID: multitouch: pick the contact count field in advance

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6ce232e..3d7db96 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -698,6 +698,13 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 	if (report->id != td->mt_report_id)
 		return;
 
+	/*
+	 * Includes multi-packet support where subsequent
+	 * packets are sent with zero contactcount.
+	 */
+	if (field_cc->value[td->contactcount_index])
+		td->num_expected = field_cc->value[td->contactcount_index];
+
 	for (r = 0; r < report->maxfield; r++) {
 		field = report->field[r];
 		count = field->report_count;
-- 
1.8.1


