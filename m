Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3EJOUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328Ab3EJOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcel Holtmann" <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Mathias Krause" <minipli@googlemail.com>,
        "Gustavo Padovan" <gustavo@padovan.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.914423718@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [100/118] Bluetooth: fix possible info leak in bt_sock_recvmsg()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 4683f42fde3977bdb4e8a09622788cc8b5313778 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/af_bluetooth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -245,6 +245,8 @@ int bt_sock_recvmsg(struct kiocb *iocb,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -252,8 +254,6 @@ int bt_sock_recvmsg(struct kiocb *iocb,
 		return err;
 	}
 
-	msg->msg_namelen = 0;
-
 	copied = skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;

