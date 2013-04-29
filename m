Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab3D2TCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:02:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473Ab3D2TCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/42] tipc: fix info leaks via msg_name in recv_msg/recv_stream
Date: Mon, 29 Apr 2013 12:02:00 -0700
Message-Id: <20130429184754.443665186@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Allan Stephens <allan.stephens@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -806,6 +806,7 @@ static void set_orig_addr(struct msghdr
 	if (addr) {
 		addr->family = AF_TIPC;
 		addr->addrtype = TIPC_ADDR_ID;
+		memset(&addr->addr, 0, sizeof(addr->addr));
 		addr->addr.id.ref = msg_origport(msg);
 		addr->addr.id.node = msg_orignode(msg);
 		addr->addr.name.domain = 0;	/* could leave uninitialized */
@@ -920,6 +921,9 @@ static int recv_msg(struct kiocb *iocb,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 restart:
 
@@ -1029,6 +1033,9 @@ static int recv_stream(struct kiocb *ioc
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, buf_len);
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 


