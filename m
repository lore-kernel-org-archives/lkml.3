Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3FDXKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:10:15 -0400
Received: from 1wt.eu ([62.212.114.60]:35507 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3FDWmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:33 -0400
Message-Id: <20130604172134.460517157@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 100/184] Bluetooth: RFCOMM - Fix missing msg_namelen update
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 in rfcomm_sock_recvmsg()

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit e11e0455c0d7d3d62276a0c55d9dfbc16779d691 ]

If RFCOMM_DEFER_SETUP is set in the flags, rfcomm_sock_recvmsg() returns
early with 0 without updating the possibly set msg_namelen member. This,
in turn, leads to a 128 byte kernel stack leak in net/socket.c.

Fix this by updating msg_namelen in this case. For all other cases it
will be handled in bt_sock_stream_recvmsg().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bluetooth/rfcomm/sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index c47b7c4..1db0132 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -652,6 +652,7 @@ static int rfcomm_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 		rfcomm_dlc_accept(d);
+		msg->msg_namelen = 0;
 		return 0;
 	}
 
-- 
1.7.12.2.21.g234cd45.dirty



