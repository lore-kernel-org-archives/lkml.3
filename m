Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaKSR72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:59:28 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:49326 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbaKSR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:59:26 -0500
From: Steven Walter <stevenrwalter@gmail.com>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Steven Walter <stevenrwalter@gmail.com>
Subject: [PATCH v3] Bluetooth: automatically flushable packets aren't allowed on LE links
Date: Wed, 19 Nov 2014 12:59:11 -0500
Message-Id: <1416419951-27659-1-git-send-email-stevenrwalter@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <C7C04F3A-EC21-4E71-9550-68E50901947D@holtmann.org>
References: <C7C04F3A-EC21-4E71-9550-68E50901947D@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bluetooth spec states that automatically flushable packets may not
be sent over a LE-U link.

Signed-off-by: Steven Walter <stevenrwalter@gmail.com>
---
 net/bluetooth/l2cap_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 4af3821..7c4350f 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -764,7 +764,7 @@ static void l2cap_send_cmd(struct l2cap_conn *conn, u8 ident, u8 code, u16 len,
 	if (!skb)
 		return;
 
-	if (lmp_no_flush_capable(conn->hcon->hdev))
+	if (lmp_no_flush_capable(conn->hcon->hdev) || conn->hcon->type == LE_LINK)
 		flags = ACL_START_NO_FLUSH;
 	else
 		flags = ACL_START;
@@ -784,7 +784,7 @@ static bool __chan_is_moving(struct l2cap_chan *chan)
 static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
 {
 	struct hci_conn *hcon = chan->conn->hcon;
-	u16 flags;
+	u16 flags = ACL_START;
 
 	BT_DBG("chan %p, skb %p len %d priority %u", chan, skb, skb->len,
 	       skb->priority);
@@ -798,11 +798,13 @@ static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
 		return;
 	}
 
-	if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
-	    lmp_no_flush_capable(hcon->hdev))
+	if (hcon->type == LE_LINK) {
+		/* LE-U does not support auto-flushing packets */
 		flags = ACL_START_NO_FLUSH;
-	else
-		flags = ACL_START;
+	} else if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
+		    lmp_no_flush_capable(hcon->hdev)) {
+		flags = ACL_START_NO_FLUSH;
+	}
 
 	bt_cb(skb)->force_active = test_bit(FLAG_FORCE_ACTIVE, &chan->flags);
 	hci_send_acl(chan->conn->hchan, skb, flags);
-- 
1.9.1

