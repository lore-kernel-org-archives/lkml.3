Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbbANHce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:32:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbbANHca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:32:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.18 129/150] Input: alps - v7: fix finger counting for > 2 fingers on clickpads
Date: Tue, 13 Jan 2015 23:23:20 -0800
Message-Id: <20150114072101.683213003@linuxfoundation.org>
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

commit d27eb7931c98a1ebfc9b2fcc48939846bcbfc804 upstream.

Protocol v7 uses the middle / right button bits on clickpads to communicate
"location" information of a 3th touch (and possible 4th) touch on
clickpads.

Specifically when 3 touches are down, if one of the 3 touches is in the
left / right button area, this will get reported in the middle / right
button bits and the touchpad will still send a TWO type packet rather then
a MULTI type packet, so when this happens we must add the finger reported
in the button area to the finger count.

Likewise we must also add fingers reported this way to the finger count
when we get MULTI packets.

BugLink: https://bugs.freedesktop.org/show_bug.cgi?id=86338
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/alps.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -933,6 +933,7 @@ static int alps_decode_packet_v7(struct
 				  unsigned char *p,
 				  struct psmouse *psmouse)
 {
+	struct alps_data *priv = psmouse->private;
 	unsigned char pkt_id;
 
 	pkt_id = alps_get_packet_id_v7(p);
@@ -963,15 +964,22 @@ static int alps_decode_packet_v7(struct
 
 	alps_get_finger_coordinate_v7(f->mt, p, pkt_id);
 
-	f->left = (p[0] & 0x80) >> 7;
-	f->right = (p[0] & 0x20) >> 5;
-	f->middle = (p[0] & 0x10) >> 4;
-
 	if (pkt_id == V7_PACKET_ID_TWO)
 		f->fingers = alps_get_mt_count(f->mt);
 	else /* pkt_id == V7_PACKET_ID_MULTI */
 		f->fingers = 3 + (p[5] & 0x03);
 
+	f->left = (p[0] & 0x80) >> 7;
+	if (priv->flags & ALPS_BUTTONPAD) {
+		if (p[0] & 0x20)
+			f->fingers++;
+		if (p[0] & 0x10)
+			f->fingers++;
+	} else {
+		f->right = (p[0] & 0x20) >> 5;
+		f->middle = (p[0] & 0x10) >> 4;
+	}
+
 	/* Sometimes a single touch is reported in mt[1] rather then mt[0] */
 	if (f->fingers == 1 && f->mt[0].x == 0 && f->mt[0].y == 0) {
 		f->mt[0].x = f->mt[1].x;


