Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaBJCXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:23:01 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39692 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaBJCWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:22:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 23/24] Bluetooth: Refactor write_room() calculation
Date: Sun,  9 Feb 2014 20:59:23 -0500
Message-Id: <1391997564-1805-24-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compute the amount of space available for a single write()
within rfcomm_room(); clamp to 0 for negative values. Note
this patch does not change the result of the computation.

Report the amount of room returned in the debug printk.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index af775f3..3f44195 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -348,11 +348,18 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 }
 
 /* ---- Send buffer ---- */
-static inline unsigned int rfcomm_room(struct rfcomm_dlc *dlc)
+static inline unsigned int rfcomm_room(struct rfcomm_dev *dev)
 {
-	/* We can't let it be zero, because we don't get a callback
-	   when tx_credits becomes nonzero, hence we'd never wake up */
-	return dlc->mtu * (dlc->tx_credits?:1);
+	struct rfcomm_dlc *dlc = dev->dlc;
+
+	/* The limit is bogus; the number of packets which can
+	 * currently be sent by the krfcommd thread has no relevance
+	 * to the number of packets which can be queued on the dlc's
+	 * tx queue.
+	 */
+	int limit = dlc->mtu * (dlc->tx_credits?:1);
+
+	return max(0, limit - atomic_read(&dev->wmem_alloc));
 }
 
 static void rfcomm_wfree(struct sk_buff *skb)
@@ -809,16 +816,12 @@ static int rfcomm_tty_write(struct tty_struct *tty, const unsigned char *buf, in
 static int rfcomm_tty_write_room(struct tty_struct *tty)
 {
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
-	int room;
+	int room = 0;
 
-	BT_DBG("tty %p", tty);
-
-	if (!dev || !dev->dlc)
-		return 0;
+	if (dev && dev->dlc)
+		room = rfcomm_room(dev);
 
-	room = rfcomm_room(dev->dlc) - atomic_read(&dev->wmem_alloc);
-	if (room < 0)
-		room = 0;
+	BT_DBG("tty %p room %d", tty, room);
 
 	return room;
 }
-- 
1.8.1.2

