Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaKSOl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:41:56 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36202 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaKSOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:41:55 -0500
From: Steven Walter <stevenrwalter@gmail.com>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Steven Walter <stevenrwalter@gmail.com>
Subject: [PATCH v2] l2cap_core: automatically flushable packets aren't allowed on LE links
Date: Wed, 19 Nov 2014 09:41:17 -0500
Message-Id: <1416408077-26514-1-git-send-email-stevenrwalter@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <106789BA-48C0-4428-BE3E-D0737F7A0641@holtmann.org>
References: <106789BA-48C0-4428-BE3E-D0737F7A0641@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bluetooth spec states that automatically flushable packets may not
be sent over a LE-U link.

Signed-off-by: Steven Walter <stevenrwalter@gmail.com>
---
 net/bluetooth/l2cap_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 4af3821..028fcc6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -764,7 +764,7 @@ static void l2cap_send_cmd(struct l2cap_conn *conn, u8 ident, u8 code, u16 len,
 	if (!skb)
 		return;
 
-	if (lmp_no_flush_capable(conn->hcon->hdev))
+	if (lmp_no_flush_capable(conn->hcon->hdev) || (conn->hcon->type == LE_LINK))
 		flags = ACL_START_NO_FLUSH;
 	else
 		flags = ACL_START;
@@ -798,8 +798,9 @@ static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
 		return;
 	}
 
-	if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
-	    lmp_no_flush_capable(hcon->hdev))
+	if ((hcon->type == LE_LINK) ||
+	    (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
+	    lmp_no_flush_capable(hcon->hdev)))
 		flags = ACL_START_NO_FLUSH;
 	else
 		flags = ACL_START;
-- 
1.9.1

