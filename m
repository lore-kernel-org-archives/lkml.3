Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbbANHcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:32:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbbANHc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:32:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.18 128/150] Input: alps - v7: sometimes a single touch is reported in mt[1]
Date: Tue, 13 Jan 2015 23:23:19 -0800
Message-Id: <20150114072101.637934744@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 7091c443dda8c6c6d8e70e33452252f9ad3e7814 upstream.

The v7 proto differentiates between a primary touch (with high precision)
and a secondary touch (with lower precision). Normally when 2 fingers are
down and one is lifted the still present touch becomes the primary touch,
but some traces have shown that this does not happen always.

This commit deals with this by making alps_get_mt_count() not stop at the
first empty mt slot, and if a touch is present in mt[1] and not mt[0]
moving the data to mt[0] (for input_mt_assign_slots).

BugLink: https://bugs.freedesktop.org/show_bug.cgi?id=86338
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/alps.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -919,12 +919,14 @@ static void alps_get_finger_coordinate_v
 
 static int alps_get_mt_count(struct input_mt_pos *mt)
 {
-	int i;
+	int i, fingers = 0;
 
-	for (i = 0; i < MAX_TOUCHES && mt[i].x != 0 && mt[i].y != 0; i++)
-		/* empty */;
+	for (i = 0; i < MAX_TOUCHES; i++) {
+		if (mt[i].x != 0 || mt[i].y != 0)
+			fingers++;
+	}
 
-	return i;
+	return fingers;
 }
 
 static int alps_decode_packet_v7(struct alps_fields *f,
@@ -970,6 +972,14 @@ static int alps_decode_packet_v7(struct
 	else /* pkt_id == V7_PACKET_ID_MULTI */
 		f->fingers = 3 + (p[5] & 0x03);
 
+	/* Sometimes a single touch is reported in mt[1] rather then mt[0] */
+	if (f->fingers == 1 && f->mt[0].x == 0 && f->mt[0].y == 0) {
+		f->mt[0].x = f->mt[1].x;
+		f->mt[0].y = f->mt[1].y;
+		f->mt[1].x = 0;
+		f->mt[1].y = 0;
+	}
+
 	return 0;
 }
 


