Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaKROqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:46:54 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:59788 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbaKROqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:46:25 -0500
From: Steven Walter <stevenrwalter@gmail.com>
To: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com
Cc: Steven Walter <stevenrwalter@gmail.com>
Subject: [PATCH] l2cap_core: automatically flushable packets aren't supported by LE-only devices
Date: Tue, 18 Nov 2014 09:46:03 -0500
Message-Id: <1416321963-17336-1-git-send-email-stevenrwalter@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bluetooth spec states that automatically flushable packets may not
be sent to a LE-only controller.  The code already supports
non-automatically-flushable packets, but uses a bit in the controller
feature field to determine whether to use them.  That bit is always zero
for LE-only devices, so we need to check for the LE-only case explicitly.
---
 net/bluetooth/l2cap_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 4af3821..29d9b9c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -764,7 +764,7 @@ static void l2cap_send_cmd(struct l2cap_conn *conn, u8 ident, u8 code, u16 len,
 	if (!skb)
 		return;
 
-	if (lmp_no_flush_capable(conn->hcon->hdev))
+	if (lmp_no_flush_capable(conn->hcon->hdev) || !lmp_bredr_capable(conn->hcon->hdev))
 		flags = ACL_START_NO_FLUSH;
 	else
 		flags = ACL_START;
@@ -798,8 +798,9 @@ static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
 		return;
 	}
 
-	if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
-	    lmp_no_flush_capable(hcon->hdev))
+	if (!lmp_bredr_capable(hcon->hdev) ||
+	    (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
+	    lmp_no_flush_capable(hcon->hdev)))
 		flags = ACL_START_NO_FLUSH;
 	else
 		flags = ACL_START;
-- 
1.9.1

