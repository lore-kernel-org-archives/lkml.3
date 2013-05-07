Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3EGOPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:15:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab3EGNk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/118] Bluetooth: fix possible info leak in bt_sock_recvmsg()
Date: Tue,  7 May 2013 14:37:57 +0100
Message-Id: <1367933964-1564-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 4683f42fde3977bdb4e8a09622788cc8b5313778 upstream.

In case the socket is already shutting down, bt_sock_recvmsg() returns
with 0 without updating msg_namelen leading to net/socket.c leaking the
local, uninitialized sockaddr_storage variable to userland -- 128 bytes
of kernel stack memory.

Fix this by moving the msg_namelen assignment in front of the shutdown
test.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bluetooth/af_bluetooth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 3e18af4..821e9d3 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -240,6 +240,8 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -247,8 +249,6 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 		return err;
 	}
 
-	msg->msg_namelen = 0;
-
 	copied = skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
-- 
1.8.1.2

