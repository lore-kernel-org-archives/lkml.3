Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaJ0KI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:08:59 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:41436 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJ0KI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:08:57 -0400
From: Chung-yih Wang <cywang@chromium.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        benjamin.tissoires@gmail.com, Chung-yih Wang <cywang@chromium.org>
Subject: [PATCH v2] input: fix BTN_TOUCH reporting in input_mt_report_pointer_emulation
Date: Mon, 27 Oct 2014 18:08:47 +0800
Message-Id: <1414404527-17526-1-git-send-email-cywang@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1412861506-21732-1-git-send-email-cywang@chromium.org>
References: <1412861506-21732-1-git-send-email-cywang@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  From the definition of BTN_TOUCH, BTN_TOOL_<name> and BTN_TOUCH codes
are orthogonal. BTN_TOUCH should be zero if there is no physical contact
happened on device. With ABS_MT_DISTANCE information, the patch uses
touch_count and finger_count to get the final reporting code for
BTN_TOUCH and BTN_TOOL_<name>, respectively.

Signed-off-by: Chung-yih Wang <cywang@chromium.org>
---
 drivers/input/input-mt.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index fbe29fc..a2ab8e3 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -192,18 +192,21 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
 {
 	struct input_mt *mt = dev->mt;
 	struct input_mt_slot *oldest;
-	int oldid, count, i;
+	int oldid, i;
+	int touch_count, finger_count;
 
 	if (!mt)
 		return;
 
 	oldest = NULL;
 	oldid = mt->trkid;
-	count = 0;
+	touch_count = 0;
+	finger_count = 0;
 
 	for (i = 0; i < mt->num_slots; ++i) {
 		struct input_mt_slot *ps = &mt->slots[i];
 		int id = input_mt_get_value(ps, ABS_MT_TRACKING_ID);
+		int distance = input_mt_get_value(ps, ABS_MT_DISTANCE);
 
 		if (id < 0)
 			continue;
@@ -211,12 +214,14 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
 			oldest = ps;
 			oldid = id;
 		}
-		count++;
+		finger_count++;
+		if (distance == 0)
+			touch_count++;
 	}
 
-	input_event(dev, EV_KEY, BTN_TOUCH, count > 0);
+	input_event(dev, EV_KEY, BTN_TOUCH, touch_count > 0);
 	if (use_count)
-		input_mt_report_finger_count(dev, count);
+		input_mt_report_finger_count(dev, finger_count);
 
 	if (oldest) {
 		int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
-- 
2.1.2

