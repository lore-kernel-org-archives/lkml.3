Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346Ab3EGEkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:40:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab3EGEZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:43 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SzyjfQfUXw4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HyjdHKqW1jgA:10 a=mK_AVkanAAAA:8 a=0FD05c-RAAAA:8 a=t7CeM3EgAAAA:8 a=J1Y8HTJGAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=9xyTavCNlvEA:10 a=f7GxY0FH8QIA:10 a=2e6ZYRoF4I4A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035859.063047793@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [108/126] tipc: fix info leaks via msg_name in recv_msg/recv_stream
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0108-tipc-fix-info-leaks-via-msg_name-in-recv_msg-recv_st.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 60085c3d009b0df252547adb336d1ccca5ce52ec ]

The code in set_orig_addr() does not initialize all of the members of
struct sockaddr_tipc when filling the sockaddr info -- namely the union
is only partly filled. This will make recv_msg() and recv_stream() --
the only users of this function -- leak kernel stack memory as the
msg_name member is a local variable in net/socket.c.

Additionally to that both recv_msg() and recv_stream() fail to update
the msg_namelen member to 0 while otherwise returning with 0, i.e.
"success". This is the case for, e.g., non-blocking sockets. This will
lead to a 128 byte kernel stack leak in net/socket.c.

Fix the first issue by initializing the memory of the union with
memset(0). Fix the second one by setting msg_namelen to 0 early as it
will be updated later if we're going to fill the msg_name member.

Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Allan Stephens <allan.stephens@windriver.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/tipc/socket.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 09dc5b9..149bbae 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -802,6 +802,7 @@ static void set_orig_addr(struct msghdr *m, struct tipc_msg *msg)
 	if (addr) {
 		addr->family = AF_TIPC;
 		addr->addrtype = TIPC_ADDR_ID;
+		memset(&addr->addr, 0, sizeof(addr->addr));
 		addr->addr.id.ref = msg_origport(msg);
 		addr->addr.id.node = msg_orignode(msg);
 		addr->addr.name.domain = 0;	/* could leave uninitialized */
@@ -916,6 +917,9 @@ static int recv_msg(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 restart:
 
@@ -1032,6 +1036,9 @@ static int recv_stream(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, buf_len);
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
-- 
1.7.10.4


