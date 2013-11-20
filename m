Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3KTXBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:01:40 -0500
Received: from pavo.uberspace.de ([95.143.172.191]:57136 "HELO
	pavo.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753646Ab3KTXBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:01:17 -0500
From: =?UTF-8?q?Friedrich=20Sch=C3=B6ller?= <linux@schoeller.se>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Friedrich=20Sch=C3=B6ller?= <linux@schoeller.se>
Subject: [PATCH 2/3] Input: Fixed pressure and tool width calculation in BCM5974 multitouch driver
Date: Wed, 20 Nov 2013 23:54:11 +0100
Message-Id: <1384988052-31898-2-git-send-email-linux@schoeller.se>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384988052-31898-1-git-send-email-linux@schoeller.se>
References: <1384988052-31898-1-git-send-email-linux@schoeller.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously ABS_PRESSURE and ABS_TOOL_WIDTH were calculated by looking at the
size of the first touch in the list reported by the trackpad. This is not
necessarily the same touch as the one used to perform pointer emulation in the
input multitouch library (input-mt). By using the sum of the sizes of all
touches as a basis for this calculation we get more coherent values.
---
 drivers/input/mouse/bcm5974.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index af15410..ecbf359 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -539,19 +539,10 @@ static void report_finger_data(struct input_dev *input,
 
 static void report_synaptics_data(struct input_dev *input,
 				  const struct bcm5974_config *cfg,
-				  const struct tp_finger *f, int raw_n)
+				  int p, int w)
 {
-	int abs_p = 0, abs_w = 0;
-
-	if (raw_n) {
-		int p = raw2int(f->touch_major);
-		int w = raw2int(f->tool_major);
-		if (p > 0 && raw2int(f->origin)) {
-			abs_p = clamp_val(256 * p / cfg->p.max, 0, 255);
-			abs_w = clamp_val(16 * w / cfg->w.max, 0, 15);
-		}
-	}
-
+	int abs_p = clamp_val(256 * p / cfg->p.max, 0, 255);
+	int abs_w = clamp_val(16 * w / cfg->w.max, 0, 15);
 	input_report_abs(input, ABS_PRESSURE, abs_p);
 	input_report_abs(input, ABS_TOOL_WIDTH, abs_w);
 }
@@ -562,7 +553,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct bcm5974_config *c = &dev->cfg;
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
-	int raw_n, i, n = 0;
+	int raw_n, i, n = 0, p = 0, w = 0;
 
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
 		return -EIO;
@@ -577,6 +568,8 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		dev->pos[n].x = raw2int(f[i].abs_x);
 		dev->pos[n].y = c->y.min + c->y.max - raw2int(f[i].abs_y);
 		dev->index[n++] = &f[i];
+		p += raw2int(f[i].touch_major);
+		w += raw2int(f[i].tool_major);
 	}
 
 	input_mt_assign_slots(input, dev->slots, dev->pos, n);
@@ -587,7 +580,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 
 	input_mt_sync_frame(input);
 
-	report_synaptics_data(input, c, f, raw_n);
+	report_synaptics_data(input, c, p, w);
 
 	/* type 2 reports button events via ibt only */
 	if (c->tp_type == TYPE2) {
-- 
1.8.4.2

