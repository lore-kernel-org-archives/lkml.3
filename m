Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab3EGEjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:39:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3EGEZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:46 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=T0Vz5Jhtw9IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Cl0xtnUtQDsA:10 a=mK_AVkanAAAA:8 a=VnNF1IyMAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=9xyTavCNlvEA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035857.787163780@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [101/126] iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0101-iucv-Fix-missing-msg_namelen-update-in-iucv_sock_rec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit a5598bd9c087dc0efc250a5221e5d0e6f584ee88 ]

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about iucv_sock_recvmsg() not filling the msg_name in case it was set.

Cc: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/iucv/af_iucv.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index cd6f7a9..625bc50 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1331,6 +1331,8 @@ static int iucv_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct sk_buff *skb, *rskb, *cskb;
 	int err = 0;
 
+	msg->msg_namelen = 0;
+
 	if ((sk->sk_state == IUCV_DISCONN) &&
 	    skb_queue_empty(&iucv->backlog_skb_q) &&
 	    skb_queue_empty(&sk->sk_receive_queue) &&
-- 
1.7.10.4


