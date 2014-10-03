Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaJCJnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:43:46 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60015 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaJCJnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:43:43 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/3] input: alps: For protocol V3, do not process data when last packet's bit7 is set
Date: Fri,  3 Oct 2014 11:43:11 +0200
Message-Id: <1412329392-5580-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes laptops with closed lid receive invalid ALPS protocol V3 packets with
last bit7 set.

This happens on Dell Latitude laptops and it looks like it is BIOS bug. Probably
EC does not correctly split keyboard and touchpad PS/2 data and when laptop lid
is closed it adds 0xFF packet into touchpad PS/2 data.

When last packet's bit7 is set it is invalid ALPS packet. So Do not process it
and drop it with PSMOUSE_FULL_PACKET.

After testing it looks like this patch fixed problem with reseting mouse (after
series of invalid packets) when laptop lid is closed on Dell Latitude machines.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 1bd5aa1..b1f44d4 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1179,6 +1179,16 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 		return PSMOUSE_BAD_DATA;
 	}
 
+	if (priv->proto_version == ALPS_PROTO_V3 && psmouse->pktcnt == psmouse->pktsize) {
+		// For protocol V3, do not process data when last packet's bit7 is set
+		if (psmouse->packet[psmouse->pktcnt - 1] & 0x80) {
+			psmouse_dbg(psmouse, "v3 discard packet[%i] = %x\n",
+				    psmouse->pktcnt - 1,
+				    psmouse->packet[psmouse->pktcnt - 1]);
+			return PSMOUSE_FULL_PACKET;
+		}
+	}
+
 	/* Bytes 2 - pktsize should have 0 in the highest bit */
 	if ((priv->proto_version < ALPS_PROTO_V5) &&
 	    psmouse->pktcnt >= 2 && psmouse->pktcnt <= psmouse->pktsize &&
-- 
1.7.9.5

