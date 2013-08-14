Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab3HNKvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:51:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab3HNKhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matteo Delfino <kendatsuba@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 39/75] Input: elantech - fix for newer hardware versions (v7)
Date: Wed, 14 Aug 2013 11:36:28 +0100
Message-Id: <1376476624-10011-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Delfino <kendatsuba@gmail.com>

commit 9eebed7de660c0b5ab129a9de4f89d20b60de68c upstream.

* Fix version recognition in elantech_set_properties

  The new hardware reports itself as v7 but the packets'
  structure is unaltered.

* Fix packet type recognition in elantech_packet_check_v4

  The bitmask used for v6 is too wide, only the last three bits of
  the third byte in a packet (packet[3] & 0x03) are actually used to
  distinguish between packet types.
  Starting from v7, additional information (to be interpreted) is
  stored in the remaining bits (packets[3] & 0x1c).
  In addition, the value stored in (packet[0] & 0x0c) is no longer
  a constant but contains additional information yet to be deciphered.
  This change should be backwards compatible with v6 hardware.

Additional-author: Giovanni Frigione <gio.frigione@gmail.com>
Signed-off-by: Matteo Delfino <kendatsuba@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/elantech.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 4790110..9e47774 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -694,18 +694,18 @@ static int elantech_packet_check_v3(struct psmouse *psmouse)
 static int elantech_packet_check_v4(struct psmouse *psmouse)
 {
 	unsigned char *packet = psmouse->packet;
+	unsigned char packet_type = packet[3] & 0x03;
 
-	if ((packet[0] & 0x0c) == 0x04 &&
-	    (packet[3] & 0x1f) == 0x11)
+	switch (packet_type) {
+	case 0:
+		return PACKET_V4_STATUS;
+
+	case 1:
 		return PACKET_V4_HEAD;
 
-	if ((packet[0] & 0x0c) == 0x04 &&
-	    (packet[3] & 0x1f) == 0x12)
+	case 2:
 		return PACKET_V4_MOTION;
-
-	if ((packet[0] & 0x0c) == 0x04 &&
-	    (packet[3] & 0x1f) == 0x10)
-		return PACKET_V4_STATUS;
+	}
 
 	return PACKET_UNKNOWN;
 }
@@ -1282,6 +1282,7 @@ static int elantech_set_properties(struct elantech_data *etd)
 			etd->hw_version = 3;
 			break;
 		case 6:
+		case 7:
 			etd->hw_version = 4;
 			break;
 		default:
-- 
1.8.3.2

