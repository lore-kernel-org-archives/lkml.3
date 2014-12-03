Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaLCL5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:57:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaLCL1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/101] Input: alps - ignore bad data on Dell Latitudes E6440 and E7440
Date: Wed,  3 Dec 2014 12:26:13 +0100
Message-Id: <4d7358976da0be177081dda43759b83582709dbc.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/alps.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 19e070f16e6b..642a42f719b1 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -909,6 +909,21 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
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
2.1.3

