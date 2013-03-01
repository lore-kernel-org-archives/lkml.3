Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3CAPJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:09:16 -0500
Received: from zimbra.alphalink.fr ([217.15.80.77]:55839 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab3CAPJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:09:14 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 10:09:14 EST
Date: Fri, 1 Mar 2013 16:02:02 +0100
From: Guillaume Nault <g.nault@alphalink.fr>
To: James Chapman <jchapman@katalix.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] l2tp: Restore socket refcount when sendmsg succeeds
Message-ID: <20130301150202.GA3649@alphalink.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sendmsg() syscall handler for PPPoL2TP doesn't decrease the socket
reference counter after successful transmissions. Any successful
sendmsg() call from userspace will then increase the reference counter
forever, thus preventing the kernel's session and tunnel data from
being freed later on.

The problem only happens when writing directly on L2TP sockets.
PPP sockets attached to L2TP are unaffected as the PPP subsystem
uses pppol2tp_xmit() which symmetrically increase/decrease reference
counters.

This patch adds the missing call to sock_put() before returning from
pppol2tp_sendmsg().

Cc: <stable@vger.kernel.org>
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
---
 net/l2tp/l2tp_ppp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 3f4e3af..6a53371 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -355,6 +355,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
+	sock_put(sk);
 
 	return error;
 
-- 
1.7.10.4

