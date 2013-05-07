Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab3EGEjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:39:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3EGEZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:46 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=u8mnWJH-6qgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Q8kMDazWGucA:10 a=mK_AVkanAAAA:8 a=THCAyMpEAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=9xyTavCNlvEA:10 a=FCIOWvmKq0cA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035857.480809048@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [099/126] caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0099-caif-Fix-missing-msg_namelen-update-in-caif_seqpkt_r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 2d6fbfe733f35c6b355c216644e08e149c61b271 ]

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about caif_seqpkt_recvmsg() not filling the msg_name in case it was
set.

Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/caif/caif_socket.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 095259f..ff2ff3c 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -286,6 +286,8 @@ static int caif_seqpkt_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (m->msg_flags&MSG_OOB)
 		goto read_error;
 
+	m->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, 0 , &ret);
 	if (!skb)
 		goto read_error;
-- 
1.7.10.4


