Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbaGPGZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:25:07 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38267 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaGPGZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:25:05 -0400
From: Jiada Wang <jiada_wang@mentor.com>
To: <marcel@holtmann.org>, <gustavo@padovan.org>, <johan.hedberg@gmail.com>
CC: <linux-bluetooth@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Dean_Jenkins@mentor.com>
Subject: [PATCH v4] Bluetooth: BCSP fails to ACK re-transmitted frames from the peer
Date: Wed, 16 Jul 2014 15:25:01 +0900
Message-ID: <1405491901-31307-1-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 16 Jul 2014 06:25:03.0472 (UTC) FILETIME=[ADA7CF00:01CFA0BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dean Jenkins <djenkins@mvista.com>

Send an ACK frame with the current txack value in response to
every received reliable frame unless a TX reliable frame is being
sent. This modification allows re-transmitted frames from the remote
peer to be acknowledged rather than ignored. It means that the remote
peer knows which frame number to start re-transmitting from.

Without this modification, the recovery time to a missing frame
from the remote peer was unnecessarily being extended because the
headers of the out of order reliable frames were being discarded rather
than being processed. The frame headers of received frames will
indicate whether the local peer's transmissions have been
acknowledged by the remote peer. Therefore, the local peer may
unnecessarily re-transmit despite the remote peer already indicating
that the frame had been acknowledged in out of order reliable frame.

Signed-off-by: Dean Jenkins <djenkins@mvista.com>
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/bluetooth/hci_bcsp.c | 85 ++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 34 deletions(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 21cc45b..a0cbd69 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -478,13 +478,28 @@ static inline void bcsp_unslip_one_byte(struct bcsp_struct *bcsp, unsigned char
 static void bcsp_complete_rx_pkt(struct hci_uart *hu)
 {
 	struct bcsp_struct *bcsp = hu->priv;
-	int pass_up;
+	int pass_up = 0;
 
 	if (bcsp->rx_skb->data[0] & 0x80) {	/* reliable pkt */
 		BT_DBG("Received seqno %u from card", bcsp->rxseq_txack);
-		bcsp->rxseq_txack++;
-		bcsp->rxseq_txack %= 0x8;
-		bcsp->txack_req    = 1;
+
+		/* check the rx sequence number is as expected */
+		if ((bcsp->rx_skb->data[0] & 0x07) == bcsp->rxseq_txack) {
+			bcsp->rxseq_txack++;
+			bcsp->rxseq_txack %= 0x8;
+		} else {
+			/* handle re-transmitted packet or
+			 * when packet was missed
+			 */
+			BT_ERR("Out-of-order packet arrived, got %u expected %u",
+				bcsp->rx_skb->data[0] & 0x07, bcsp->rxseq_txack);
+
+			/* do not process out-of-order packet payload */
+			pass_up = 2;
+		}
+
+		/* send current txack value to all recieved reliable packets */
+		bcsp->txack_req = 1;
 
 		/* If needed, transmit an ack pkt */
 		hci_uart_tx_wakeup(hu);
@@ -493,26 +508,33 @@ static void bcsp_complete_rx_pkt(struct hci_uart *hu)
 	bcsp->rxack = (bcsp->rx_skb->data[0] >> 3) & 0x07;
 	BT_DBG("Request for pkt %u from card", bcsp->rxack);
 
+	/* handle recieved ACK indications,
+	 * including those from out-of-order packets
+	 */
 	bcsp_pkt_cull(bcsp);
-	if ((bcsp->rx_skb->data[1] & 0x0f) == 6 &&
-			bcsp->rx_skb->data[0] & 0x80) {
-		bt_cb(bcsp->rx_skb)->pkt_type = HCI_ACLDATA_PKT;
-		pass_up = 1;
-	} else if ((bcsp->rx_skb->data[1] & 0x0f) == 5 &&
-			bcsp->rx_skb->data[0] & 0x80) {
-		bt_cb(bcsp->rx_skb)->pkt_type = HCI_EVENT_PKT;
-		pass_up = 1;
-	} else if ((bcsp->rx_skb->data[1] & 0x0f) == 7) {
-		bt_cb(bcsp->rx_skb)->pkt_type = HCI_SCODATA_PKT;
-		pass_up = 1;
-	} else if ((bcsp->rx_skb->data[1] & 0x0f) == 1 &&
-			!(bcsp->rx_skb->data[0] & 0x80)) {
-		bcsp_handle_le_pkt(hu);
-		pass_up = 0;
-	} else
-		pass_up = 0;
-
-	if (!pass_up) {
+
+	if (pass_up != 2) {
+		if ((bcsp->rx_skb->data[1] & 0x0f) == 6 &&
+		    (bcsp->rx_skb->data[0] & 0x80)) {
+			bt_cb(bcsp->rx_skb)->pkt_type = HCI_ACLDATA_PKT;
+			pass_up = 1;
+		} else if ((bcsp->rx_skb->data[1] & 0x0f) == 5 &&
+			   (bcsp->rx_skb->data[0] & 0x80)) {
+			bt_cb(bcsp->rx_skb)->pkt_type = HCI_EVENT_PKT;
+			pass_up = 1;
+		} else if ((bcsp->rx_skb->data[1] & 0x0f) == 7) {
+			bt_cb(bcsp->rx_skb)->pkt_type = HCI_SCODATA_PKT;
+			pass_up = 1;
+		} else if ((bcsp->rx_skb->data[1] & 0x0f) == 1 &&
+			   !(bcsp->rx_skb->data[0] & 0x80)) {
+			bcsp_handle_le_pkt(hu);
+			pass_up = 0;
+		} else {
+			pass_up = 0;
+		}
+	}
+
+	if (pass_up == 0) {
 		struct hci_event_hdr hdr;
 		u8 desc = (bcsp->rx_skb->data[1] & 0x0f);
 
@@ -537,11 +559,16 @@ static void bcsp_complete_rx_pkt(struct hci_uart *hu)
 			}
 		} else
 			kfree_skb(bcsp->rx_skb);
-	} else {
+	} else if (pass_up == 1) {
 		/* Pull out BCSP hdr */
 		skb_pull(bcsp->rx_skb, 4);
 
 		hci_recv_frame(hu->hdev, bcsp->rx_skb);
+	} else {
+		/* ignore packet payload of already ACKed re-transmitted
+		 * packets or when a packet was missed in the BCSP window
+		 */
+		kfree_skb(bcsp->rx_skb);
 	}
 
 	bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
@@ -587,16 +614,6 @@ static int bcsp_recv(struct hci_uart *hu, void *data, int count)
 				bcsp->rx_count = 0;
 				continue;
 			}
-			if (bcsp->rx_skb->data[0] & 0x80	/* reliable pkt */
-			    		&& (bcsp->rx_skb->data[0] & 0x07) != bcsp->rxseq_txack) {
-				BT_ERR ("Out-of-order packet arrived, got %u expected %u",
-					bcsp->rx_skb->data[0] & 0x07, bcsp->rxseq_txack);
-
-				kfree_skb(bcsp->rx_skb);
-				bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
-				bcsp->rx_count = 0;
-				continue;
-			}
 			bcsp->rx_state = BCSP_W4_DATA;
 			bcsp->rx_count = (bcsp->rx_skb->data[1] >> 4) + 
 					(bcsp->rx_skb->data[2] << 4);	/* May be 0 */
-- 
1.9.3

