Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaLCLb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:31:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbaLCL1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:46 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 095/101] ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg
Date: Wed,  3 Dec 2014 12:26:57 +0100
Message-Id: <f39a6f3d592372cd369b6a04a8562f3e6f41ee47.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 01462405f0c093b2f8dfddafcadcda6c9e4c5cdf ]

This fixes an old regression introduced by commit
b0d0d915 (ipx: remove the BKL).

When a recvmsg syscall blocks waiting for new data, no data can be sent on the
same socket with sendmsg because ipx_recvmsg() sleeps with the socket locked.

This breaks mars-nwe (NetWare emulator):
- the ncpserv process reads the request using recvmsg
- ncpserv forks and spawns nwconn
- ncpserv calls a (blocking) recvmsg and waits for new requests
- nwconn deadlocks in sendmsg on the same socket

Commit b0d0d915 has simply replaced BKL locking with
lock_sock/release_sock. Unlike now, BKL got unlocked while
sleeping, so a blocking recvmsg did not block a concurrent
sendmsg.

Only keep the socket locked while actually working with the socket data and
release it prior to calling skb_recv_datagram().

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipx/af_ipx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index e096025b477f..6857ae49dc8c 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -1778,6 +1778,7 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct ipxhdr *ipx = NULL;
 	struct sk_buff *skb;
 	int copied, rc;
+	bool locked = true;
 
 	lock_sock(sk);
 	/* put the autobinding in */
@@ -1804,6 +1805,8 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;
 
+	release_sock(sk);
+	locked = false;
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &rc);
 	if (!skb)
@@ -1837,7 +1840,8 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
 out_free:
 	skb_free_datagram(sk, skb);
 out:
-	release_sock(sk);
+	if (locked)
+		release_sock(sk);
 	return rc;
 }
 
-- 
2.1.3

