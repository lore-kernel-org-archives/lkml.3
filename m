Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3HQAfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:35:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3HPWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matteo Delfino <kendatsuba@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 001/133] Input: elantech - fix for newer hardware versions (v7)
Date: Fri, 16 Aug 2013 15:32:23 -0700
Message-Id: <1376692475-28413-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/elantech.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 1e8e42f..57b2637 100644
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
1.8.1.2

