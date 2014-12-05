Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaLEWxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:53:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaLEWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Bohac <jbohac@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 026/122] ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg
Date: Fri,  5 Dec 2014 14:43:20 -0800
Message-Id: <20141205223309.366183236@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipx/af_ipx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -1764,6 +1764,7 @@ static int ipx_recvmsg(struct kiocb *ioc
 	struct ipxhdr *ipx = NULL;
 	struct sk_buff *skb;
 	int copied, rc;
+	bool locked = true;
 
 	lock_sock(sk);
 	/* put the autobinding in */
@@ -1790,6 +1791,8 @@ static int ipx_recvmsg(struct kiocb *ioc
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;
 
+	release_sock(sk);
+	locked = false;
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &rc);
 	if (!skb) {
@@ -1826,7 +1829,8 @@ static int ipx_recvmsg(struct kiocb *ioc
 out_free:
 	skb_free_datagram(sk, skb);
 out:
-	release_sock(sk);
+	if (locked)
+		release_sock(sk);
 	return rc;
 }
 


