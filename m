Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3FDWsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:48:51 -0400
Received: from 1wt.eu ([62.212.114.60]:35891 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3FDWoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:25 -0400
Message-Id: <20130604172137.684540988@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 178/184] iucv: Fix missing msg_namelen update in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 iucv_sock_recvmsg()

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit a5598bd9c087dc0efc250a5221e5d0e6f584ee88 ]

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about iucv_sock_recvmsg() not filling the msg_name in case it was set.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/iucv/af_iucv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index bada1b9..f605b23 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1160,6 +1160,8 @@ static int iucv_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct sk_buff *skb, *rskb, *cskb;
 	int err = 0;
 
+	msg->msg_namelen = 0;
+
 	if ((sk->sk_state == IUCV_DISCONN || sk->sk_state == IUCV_SEVERED) &&
 	    skb_queue_empty(&iucv->backlog_skb_q) &&
 	    skb_queue_empty(&sk->sk_receive_queue) &&
-- 
1.7.12.2.21.g234cd45.dirty



