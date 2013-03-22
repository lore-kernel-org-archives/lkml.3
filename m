Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422794Ab3CVRyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:54:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422726Ab3CVRys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:54:48 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3.9+] HID: multitouch: fix touchpad buttons
Date: Fri, 22 Mar 2013 18:53:57 +0100
Message-Id: <1363974837-8958-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "HID: multitouch: use the callback "report" instead..." breaks the
buttons of touchpads following the HID multitouch specification.
The buttons were emmitted through hid-input, but as now the events
are generated only in hid-multitouch, the buttons are not emmitted anymore.

The input_event() call is far much simpler than the hid-input one as
many of the different tests do not apply to multitouch touchpads.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi guys,

really sorry for that. I forgot that I had in one of my drawer of my desk one
prototype of a touchpad following the multitouch specification, but with
two physical buttons. And of course, I did not put it in my database, meaning
that the support has been broken in the patches already in 3.9.

I don't think it's a big deal (to my knowledge, no retail product uses this
feature), but it's still a regression in 3.9.

Cheers,
Benjamin

 drivers/hid/hid-multitouch.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1f544a4..7d72379 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -620,6 +620,7 @@ static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
 {
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
+	struct input_dev *input = field->hidinput->input;
 
 	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
@@ -669,13 +670,16 @@ static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
 			break;
 
 		default:
+			if (usage->type)
+				input_event(input, usage->type, usage->code,
+					    value);
 			return;
 		}
 
 		if (usage->usage_index + 1 == field->report_count) {
 			/* we only take into account the last report. */
 			if (usage->hid == td->last_slot_field)
-				mt_complete_slot(td, field->hidinput->input);
+				mt_complete_slot(td, input);
 		}
 
 	}
-- 
1.8.1.4

