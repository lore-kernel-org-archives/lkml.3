Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbaLBToQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:44:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485AbaLBTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:25:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 085/121] Input: alps - ignore bad data on Dell Latitudes E6440 and E7440
Date: Tue,  2 Dec 2014 11:19:24 -0800
Message-Id: <1417548000-1794-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>

commit a7ef82aee91f26da79b981b9f5bca43b8817d3e4 upstream.

Sometimes on Dell Latitude laptops psmouse/alps driver receive invalid ALPS
protocol V3 packets with bit7 set in last byte. More often it can be
reproduced on Dell Latitude E6440 or E7440 with closed lid and pushing
cover above touchpad.

If bit7 in last packet byte is set then it is not valid ALPS packet. I was
told that ALPS devices never send these packets. It is not know yet who
send those packets, it could be Dell EC, bug in BIOS and also bug in
touchpad firmware...

With this patch alps driver does not process those invalid packets, but
instead of reporting PSMOUSE_BAD_DATA, getting into out of sync state,
getting back in sync with the next byte and spam dmesg we return
PSMOUSE_FULL_PACKET. If driver is truly out of sync we'll fail the checks
on the next byte and report PSMOUSE_BAD_DATA then.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/alps.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 00544a6..b1385f0 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -993,12 +993,27 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 	}
 
 	/* Bytes 2 - pktsize should have 0 in the highest bit */
-	if ((priv->proto_version < ALPS_PROTO_V5) &&
+	if (priv->proto_version < ALPS_PROTO_V5 &&
 	    psmouse->pktcnt >= 2 && psmouse->pktcnt <= psmouse->pktsize &&
 	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80)) {
 		psmouse_dbg(psmouse, "refusing packet[%i] = %x\n",
 			    psmouse->pktcnt - 1,
 			    psmouse->packet[psmouse->pktcnt - 1]);
+
+		if (priv->proto_version == ALPS_PROTO_V3 &&
+		    psmouse->pktcnt == psmouse->pktsize) {
+			/*
+			 * Some Dell boxes, such as Latitude E6440 or E7440
+			 * with closed lid, quite often smash last byte of
+			 * otherwise valid packet with 0xff. Given that the
+			 * next packet is very likely to be valid let's
+			 * report PSMOUSE_FULL_PACKET but not process data,
+			 * rather than reporting PSMOUSE_BAD_DATA and
+			 * filling the logs.
+			 */
+			return PSMOUSE_FULL_PACKET;
+		}
+
 		return PSMOUSE_BAD_DATA;
 	}
 
-- 
1.9.1

