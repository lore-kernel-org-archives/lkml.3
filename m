Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3EJOUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56977 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab3EJOUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Allan Stephens" <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jon Maloy" <jon.maloy@ericsson.com>,
        "Mathias Krause" <minipli@googlemail.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.420759387@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [108/118] tipc: fix info leaks via msg_name in  recv_msg/recv_stream
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/tipc/socket.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -829,6 +829,7 @@ static void set_orig_addr(struct msghdr
 	if (addr) {
 		addr->family = AF_TIPC;
 		addr->addrtype = TIPC_ADDR_ID;
+		memset(&addr->addr, 0, sizeof(addr->addr));
 		addr->addr.id.ref = msg_origport(msg);
 		addr->addr.id.node = msg_orignode(msg);
 		addr->addr.name.domain = 0;	/* could leave uninitialized */
@@ -948,6 +949,9 @@ static int recv_msg(struct kiocb *iocb,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 restart:
 
@@ -1074,6 +1078,9 @@ static int recv_stream(struct kiocb *ioc
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, buf_len);
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 restart:

