Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbbANIJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:09:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbbANHcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:32:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.18 127/150] Input: alps - v7: ignore new packets
Date: Tue, 13 Jan 2015 23:23:18 -0800
Message-Id: <20150114072101.593701883@linuxfoundation.org>
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

commit 8b23811535d2e1dd6abbe4ce6ea1edfd50ce72de upstream.

NEW packets are send to indicate a discontinuity in the finger coordinate
reporting. Specifically a finger may have moved from slot 0 to 1 or vice
versa.  INPUT_MT_TRACK takes care of this for us.

NEW packets have 3 problems:
1) They do not contain middle / right button info (on non clickpads)
   this can be worked around by preserving the old button state
2) They do not contain an accurate fingercount, and they are
   typically send when the number of fingers changes. We cannot use
   the old finger count as that may mismatch with the amount of
   touch coordinates we've available in the NEW packet
3) Their x data for the second touch is inaccurate leading to
   a possible jump of the x coordinate by 16 units when the first
   non NEW packet comes in

Since problems 2 & 3 cannot be worked around, just ignore them.

BugLink: https://bugs.freedesktop.org/show_bug.cgi?id=86338
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/alps.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -938,18 +938,36 @@ static int alps_decode_packet_v7(struct
 		return 0;
 	if (pkt_id == V7_PACKET_ID_UNKNOWN)
 		return -1;
+	/*
+	 * NEW packets are send to indicate a discontinuity in the finger
+	 * coordinate reporting. Specifically a finger may have moved from
+	 * slot 0 to 1 or vice versa. INPUT_MT_TRACK takes care of this for
+	 * us.
+	 *
+	 * NEW packets have 3 problems:
+	 * 1) They do not contain middle / right button info (on non clickpads)
+	 *    this can be worked around by preserving the old button state
+	 * 2) They do not contain an accurate fingercount, and they are
+	 *    typically send when the number of fingers changes. We cannot use
+	 *    the old finger count as that may mismatch with the amount of
+	 *    touch coordinates we've available in the NEW packet
+	 * 3) Their x data for the second touch is inaccurate leading to
+	 *    a possible jump of the x coordinate by 16 units when the first
+	 *    non NEW packet comes in
+	 * Since problems 2 & 3 cannot be worked around, just ignore them.
+	 */
+	if (pkt_id == V7_PACKET_ID_NEW)
+		return 1;
 
 	alps_get_finger_coordinate_v7(f->mt, p, pkt_id);
 
-	if (pkt_id == V7_PACKET_ID_TWO || pkt_id == V7_PACKET_ID_MULTI) {
-		f->left = (p[0] & 0x80) >> 7;
-		f->right = (p[0] & 0x20) >> 5;
-		f->middle = (p[0] & 0x10) >> 4;
-	}
+	f->left = (p[0] & 0x80) >> 7;
+	f->right = (p[0] & 0x20) >> 5;
+	f->middle = (p[0] & 0x10) >> 4;
 
 	if (pkt_id == V7_PACKET_ID_TWO)
 		f->fingers = alps_get_mt_count(f->mt);
-	else if (pkt_id == V7_PACKET_ID_MULTI)
+	else /* pkt_id == V7_PACKET_ID_MULTI */
 		f->fingers = 3 + (p[5] & 0x03);
 
 	return 0;


