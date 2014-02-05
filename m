Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaBEUHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:07:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48404 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaBEUGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 133/213] Bluetooth: fix possible info leak in bt_sock_recvmsg()
Date: Wed, 5 Feb 2014 15:01:28 -0500
Message-ID: <1391630568-49251-134-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bluetooth/af_bluetooth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 404a8500fd03..0891857b7ca2 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -240,14 +240,14 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
+	msg->msg_namelen = 0;
+
 	if (!(skb = skb_recv_datagram(sk, flags, noblock, &err))) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
 		return err;
 	}
 
-	msg->msg_namelen = 0;
-
 	copied = skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
-- 
1.8.5.2

