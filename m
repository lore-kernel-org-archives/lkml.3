Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab3EGNlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42260 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab3EGNlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 041/118] tipc: fix info leaks via msg_name in recv_msg/recv_stream
Date: Tue,  7 May 2013 14:38:07 +0100
Message-Id: <1367933964-1564-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 60085c3d009b0df252547adb336d1ccca5ce52ec upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/tipc/socket.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 5577a44..91fd130 100644
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
1.8.1.2

