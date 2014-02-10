Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaBJCUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:20:32 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39582 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaBJCUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:19 -0500
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
Subject: [PATCH 24/24] Bluetooth: Fix write_room() calculation
Date: Sun,  9 Feb 2014 20:59:24 -0500
Message-Id: <1391997564-1805-25-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The skb truesize of a 12-byte payload with a 10-byte head/tail
reserve is 768 bytes. Consequently, even with 40 tx_credits, at
most 6 packets could be queued at any one time:

  40 tx_credits * 127-byte mtu < 768-byte truesize * 7

This error could also cause the tx queue to apparently stall if
credit flow control is disabled (where tx_credits is fixed at 5),
or if the receiver only granted a limited number of tx credits
(eg., less than 7).

Instead, track the outstanding number of queued packets not yet sent
in wmem_alloc and allow for a maximum of 40 queued packets. Report
the space avail for a single write() as the mtu * number of packets
left before reaching the maximum.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 3f44195..403ec09 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -352,20 +352,16 @@ static inline unsigned int rfcomm_room(struct rfcomm_dev *dev)
 {
 	struct rfcomm_dlc *dlc = dev->dlc;
 
-	/* The limit is bogus; the number of packets which can
-	 * currently be sent by the krfcommd thread has no relevance
-	 * to the number of packets which can be queued on the dlc's
-	 * tx queue.
-	 */
-	int limit = dlc->mtu * (dlc->tx_credits?:1);
+	/* Limit the outstanding number of packets not yet sent to 40 */
+	int pending = 40 - atomic_read(&dev->wmem_alloc);
 
-	return max(0, limit - atomic_read(&dev->wmem_alloc));
+	return max(0, pending) * dlc->mtu;
 }
 
 static void rfcomm_wfree(struct sk_buff *skb)
 {
 	struct rfcomm_dev *dev = (void *) skb->sk;
-	atomic_sub(skb->truesize, &dev->wmem_alloc);
+	atomic_dec(&dev->wmem_alloc);
 	if (test_bit(RFCOMM_TTY_ATTACHED, &dev->flags))
 		tty_port_tty_wakeup(&dev->port);
 	tty_port_put(&dev->port);
@@ -374,7 +370,7 @@ static void rfcomm_wfree(struct sk_buff *skb)
 static void rfcomm_set_owner_w(struct sk_buff *skb, struct rfcomm_dev *dev)
 {
 	tty_port_get(&dev->port);
-	atomic_add(skb->truesize, &dev->wmem_alloc);
+	atomic_inc(&dev->wmem_alloc);
 	skb->sk = (void *) dev;
 	skb->destructor = rfcomm_wfree;
 }
-- 
1.8.1.2

