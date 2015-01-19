Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbbASUyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:54:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbbASUyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:54:16 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/6] Input: mt: Document input_mt_set_slots()
Date: Mon, 19 Jan 2015 15:53:51 -0500
Message-Id: <1421700835-22157-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed "w" into "red_cost_matrix" for readability.

Add docs and comments to detail what the code is expected to do.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/input-mt.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index b6ee42a..b269113 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -359,23 +359,41 @@ static int input_mt_set_matrix(struct input_mt *mt,
 	return w - mt->red;
 }
 
+/**
+ * input_mt_set_slots() - assign slots to the list of pos thanks to the reduced
+ * cost matrix
+ * @mt: the input_mt handle of the current device
+ * @slots: the slot assignment to be filled
+ * @num_pos: number of positions
+ *
+ * For each given touch in pos, try to match the touch to a previous one.
+ * Then, assign new slots to those who were not a match with the previously
+ * sent slots.
+ */
 static void input_mt_set_slots(struct input_mt *mt,
 			       int *slots, int num_pos)
 {
 	struct input_mt_slot *s;
-	int *w = mt->red, *p;
+	int *red_cost_matrix = mt->red;
+	int *p;
 
+	/* first initialise the output values to -1 */
 	for (p = slots; p != slots + num_pos; p++)
 		*p = -1;
 
+	/* for each currently active slot, match it with one of the touch
+	 * in the pos array */
 	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
 		if (!input_mt_is_active(s))
 			continue;
 		for (p = slots; p != slots + num_pos; p++)
-			if (*w++ < 0)
+			if (*red_cost_matrix++ < 0)
+				/* we have a match, store the slot value
+				 * in pos[i] */
 				*p = s - mt->slots;
 	}
 
+	/* for each unassigned touch in pos, assign a new slot for it */
 	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
 		if (input_mt_is_active(s))
 			continue;
-- 
2.1.0

