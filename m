Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbaJ1ICB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:02:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaJ1Dgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.17 027/146] HID: wacom: fix timeout on probe for some wacoms
Date: Tue, 28 Oct 2014 11:32:49 +0800
Message-Id: <20141028033344.620039882@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 8ffffd5212846b72f116f7a9572e83d580e25802 upstream.

Some Wacom tablets (at least the ISDv4 found in the Lenovo X230) timeout
during probe while retrieving the input reports.
The only time this information is valuable is during the feature_mapping
stage, so we can ask for it there and discard the generic input reports
retrieval.

This gives a code path closer to the wacom.ko driver when it was in the
input subtree (not HID).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_sys.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -106,12 +106,24 @@ static void wacom_feature_mapping(struct
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
@@ -1245,6 +1257,8 @@ static int wacom_probe(struct hid_device
 	if (!id->driver_data)
 		return -EINVAL;
 
+	hdev->quirks |= HID_QUIRK_NO_INIT_REPORTS;
+
 	wacom = kzalloc(sizeof(struct wacom), GFP_KERNEL);
 	if (!wacom)
 		return -ENOMEM;


