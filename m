Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaLOPUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:20:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38185 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaLOO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Bohac <jbohac@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 009/168] ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg
Date: Mon, 15 Dec 2014 14:24:23 +0000
Message-Id: <1418653622-21105-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

commit 01462405f0c093b2f8dfddafcadcda6c9e4c5cdf upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipx/af_ipx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index 91729b807c7d..1b095ca37aa4 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -1764,6 +1764,7 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct ipxhdr *ipx = NULL;
 	struct sk_buff *skb;
 	int copied, rc;
+	bool locked = true;
 
 	lock_sock(sk);
 	/* put the autobinding in */
@@ -1790,6 +1791,8 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;
 
+	release_sock(sk);
+	locked = false;
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &rc);
 	if (!skb) {
@@ -1826,7 +1829,8 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
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

