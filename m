Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3EGEZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:25:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab3EGEZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:45 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=91ZxE9VgbrEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=076Q6VXC_-AA:10 a=mK_AVkanAAAA:8 a=h3sCQ_blAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=9xyTavCNlvEA:10 a=fNChW5oJl9MA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035858.102229582@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [103/126] llc: Fix missing msg_namelen update in llc_ui_recvmsg()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0103-llc-Fix-missing-msg_namelen-update-in-llc_ui_recvmsg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit c77a4b9cffb6215a15196ec499490d116dfad181 ]

For stream sockets the code misses to update the msg_namelen member
to 0 and therefore makes net/socket.c leak the local, uninitialized
sockaddr_storage variable to userland -- 128 bytes of kernel stack
memory. The msg_namelen update is also missing for datagram sockets
in case the socket is shutting down during receive.

Fix both issues by setting msg_namelen to 0 early. It will be
updated later if we're going to fill the msg_name member.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/llc/af_llc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index c219000..c9d0431 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -720,6 +720,8 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	int target;	/* Read at least this many bytes */
 	long timeo;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	copied = -ENOTCONN;
 	if (unlikely(sk->sk_type == SOCK_STREAM && sk->sk_state == TCP_LISTEN))
-- 
1.7.10.4


