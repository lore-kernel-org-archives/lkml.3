Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3LaCHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 21:07:35 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39598 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab3LaCHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 21:07:11 -0500
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: linux-input@vger.kernel.org
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/2] input: mt: Add helper function to send end events
Date: Mon, 30 Dec 2013 18:06:40 -0800
Message-Id: <1388455601-17033-2-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
References: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

This is useful to report for users of devices that don't know anything
about the suspension of the device. So users will receive a touch end event
when the device is about to suspend, making it more user friendly.

One example of users is the X Server with the evdev input driver. This patch
make sure that the X server will propagate a touch end event to its windows.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 drivers/input/input-mt.c | 33 +++++++++++++++++++++++++++++++++
 include/linux/input/mt.h |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index d398f13..6010357 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -157,6 +157,39 @@ void input_mt_report_slot_state(struct input_dev *dev,
 EXPORT_SYMBOL(input_mt_report_slot_state);
 
 /**
+ * input_mt_report_end_state() - report end touch events
+ * @dev: input device with allocated MT slots
+ *
+ * Reports a touch end event for current active slots (with active tracking id).
+ * This is useful when the device might suspend (or sleep) while there were
+ * still active tracking ids.
+ */
+void input_mt_report_end_state(struct input_dev *dev)
+{
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *slot;
+	int id, i;
+
+	if (!mt)
+		return;
+
+	for (i = 0; i < mt->num_slots; ++i) {
+		slot = &mt->slots[i];
+		slot->frame = mt->frame;
+
+		id = input_mt_get_value(slot, ABS_MT_TRACKING_ID);
+
+		/* if id == -1 is 'unused' */
+		if (id >= 0) {
+			input_mt_set_value(slot, ABS_MT_TRACKING_ID, -1);
+			input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
+		}
+	}
+}
+EXPORT_SYMBOL(input_mt_report_end_state);
+
+
+/**
  * input_mt_report_finger_count() - report contact count
  * @dev: input device with allocated MT slots
  * @count: the number of contacts
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index 1b1dfa8..0e6c9f7 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -103,6 +103,8 @@ static inline bool input_is_mt_axis(int axis)
 void input_mt_report_slot_state(struct input_dev *dev,
 				unsigned int tool_type, bool active);
 
+void input_mt_report_end_state(struct input_dev *dev);
+
 void input_mt_report_finger_count(struct input_dev *dev, int count);
 void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count);
 
-- 
1.8.3.1

