Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3FDWqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:46:36 -0400
Received: from 1wt.eu ([62.212.114.60]:35954 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3FDWqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:46:33 -0400
Message-Id: <20130604172137.889614525@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Samuel Ortiz <samuel@sortiz.org>, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 183/184] irda: Fix missing msg_namelen update in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 irda_recvmsg_dgram()

From: Mathias Krause <minipli@googlemail.com>

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about irda_recvmsg_dgram() not filling the msg_name in case it was
set.

Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[dannf: adjusted to apply to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/irda/af_irda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index 476b24e..bfb325d 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1338,6 +1338,8 @@ static int irda_recvmsg_dgram(struct kiocb *iocb, struct socket *sock,
 	if ((err = sock_error(sk)) < 0)
 		return err;
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
 	if (!skb)
-- 
1.7.12.2.21.g234cd45.dirty



