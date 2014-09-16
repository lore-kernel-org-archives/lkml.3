Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbaIPU4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaIPU4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:56:46 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        killertofu@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: wacom: fix timeout on probe for some wacoms
Date: Tue, 16 Sep 2014 16:56:39 -0400
Message-Id: <1410900999-24692-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Wacom tablets (at least the ISDv4 found in the Lenovo X230) timeout
during probe while retrieving the input reports.
The only time this information is valuable is during the feature_mapping
stage, so we can ask for it there and discard the generic input reports
retrieval.

This gives a code path closer to the wacom.ko driver when it was in the
input subtree (not HID).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

I run into this today while trying to improve the generic support of the ISDv4
sensors (those found on laptops not sold by Wacom).
This is a regression from 3.16, in a sense that it can add up to 10 seconds to
the boot of the laptop. So IMO, this should go as a fix for 3.17-rc6.

Unfortunately, c64d883476 changed the ABI and wacom_get_report() takes now one
less argument. I based my patch on top of the for-3.18/wacom branch, so in 3.17,
it will not compile.
I would personally be in favor of having c64d883476 and this one in 3.17, but
c64d883476 will also require some manual conflict resolution (cherry-pick is
complaining).
I can also resend it based on the v3.17-rc5 tag, but then we will have to update
the for-3.18/wacom when you will merge with Linus' tree.

Let me know me what you prefer.

Hi Jason,

I managed to make the wacom driver capable of dealing with the sensor on the
Lenovo X230 without having to add any quirks in the kernel (both pen and touch).
:)
Patches will come soon.

Cheers,
Benjamin

 drivers/hid/wacom_sys.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index a8b7f16..2508628 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -110,12 +110,24 @@ static void wacom_feature_mapping(struct hid_device *hdev,
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct wacom_features *features = &wacom->wacom_wac.features;
+	u8 *data;
+	int ret;
 
 	switch (usage->hid) {
 	case HID_DG_CONTACTMAX:
 		/* leave touch_max as is if predefined */
-		if (!features->touch_max)
-			features->touch_max = field->value[0];
+		if (!features->touch_max) {
+			/* read manually */
+			data = kzalloc(2, GFP_KERNEL);
+			if (!data)
+				break;
+			data[0] = field->report->id;
+			ret = wacom_get_report(hdev, HID_FEATURE_REPORT,
+						data, 2, 0);
+			if (ret == 2)
+				features->touch_max = data[1];
+			kfree(data);
+		}
 		break;
 	}
 }
@@ -1280,6 +1292,8 @@ static int wacom_probe(struct hid_device *hdev,
 	if (!id->driver_data)
 		return -EINVAL;
 
+	hdev->quirks |= HID_QUIRK_NO_INIT_REPORTS;
+
 	wacom = kzalloc(sizeof(struct wacom), GFP_KERNEL);
 	if (!wacom)
 		return -ENOMEM;
-- 
2.1.0

