Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbbASUyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:54:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbbASUyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:54:11 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 5/6] Input: mt: document adjust_dual()
Date: Mon, 19 Jan 2015 15:53:54 -0500
Message-Id: <1421700835-22157-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adjust_dual() is really cryptic right now.
To try to understand what the function does, replace the variable names
with the following:
f -> first
p -> cur
s -> stop
c -> center

Also add a partial doc that needs to be filled by someone who knows
what the function is actually doing.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/input-mt.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index e43c33c..c7b3752 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -293,33 +293,45 @@ void input_mt_sync_frame(struct input_dev *dev)
 }
 EXPORT_SYMBOL(input_mt_sync_frame);
 
+/**
+ * adjust_dual() -
+ * @begin
+ * @step
+ * @end
+ * @eq
+ *
+ * FIXME -- can someone tell what this function does???
+ */
 static int adjust_dual(int *begin, int step, int *end, int eq)
 {
-	int f, *p, s, c;
+	int first, *cur, stop, center;
 
 	if (begin == end)
 		return 0;
 
-	f = *begin;
-	p = begin + step;
-	s = p == end ? f + 1 : *p;
+	first = *begin;
+	cur = begin + step;
+	stop = cur == end ? first + 1 : *cur;
 
-	for (; p != end; p += step)
-		if (*p < f)
-			s = f, f = *p;
-		else if (*p < s)
-			s = *p;
+	for (; cur != end; cur += step) {
+		if (*cur < first) {
+			stop = first;
+			first = *cur;
+		} else if (*cur < stop) {
+			stop = *cur;
+		}
+	}
 
-	c = (f + s + 1) / 2;
-	if (c == 0 || (c > 0 && !eq))
+	center = (first + stop + 1) / 2;
+	if (center == 0 || (center > 0 && !eq))
 		return 0;
-	if (s < 0)
-		c *= 2;
+	if (stop < 0)
+		center *= 2;
 
-	for (p = begin; p != end; p += step)
-		*p -= c;
+	for (cur = begin; cur != end; cur += step)
+		*cur -= center;
 
-	return (c < s && s <= 0) || (f >= 0 && f < c);
+	return (center < stop && stop <= 0) || (first >= 0 && first < center);
 }
 
 /**
-- 
2.1.0

