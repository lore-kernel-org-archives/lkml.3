Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3FDXD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:03:57 -0400
Received: from 1wt.eu ([62.212.114.60]:35616 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3FDWm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:57 -0400
Message-Id: <20130604172137.930866926@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 184/184] tipc: fix info leaks via msg_name in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 recv_msg/recv_stream

From: Mathias Krause <minipli@googlemail.com>

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
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/tipc/socket.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 8ebf4975..eccb86b 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -800,6 +800,7 @@ static void set_orig_addr(struct msghdr *m, struct tipc_msg *msg)
 	if (addr) {
 		addr->family = AF_TIPC;
 		addr->addrtype = TIPC_ADDR_ID;
+		memset(&addr->addr, 0, sizeof(addr->addr));
 		addr->addr.id.ref = msg_origport(msg);
 		addr->addr.id.node = msg_orignode(msg);
 		addr->addr.name.domain = 0;   	/* could leave uninitialized */
@@ -916,6 +917,9 @@ static int recv_msg(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 restart:
 
 	/* Look for a message in receive queue; wait if necessary */
@@ -1049,6 +1053,9 @@ static int recv_stream(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 restart:
 
 	/* Look for a message in receive queue; wait if necessary */
-- 
1.7.12.2.21.g234cd45.dirty



