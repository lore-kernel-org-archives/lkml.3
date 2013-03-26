Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab3CZQPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:15:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964901Ab3CZPWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 037/150] l2tp: Restore socket refcount when sendmsg succeeds
Date: Tue, 26 Mar 2013 15:18:56 +0000
Message-Id: <1364311249-14454-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <g.nault@alphalink.fr>

commit 8b82547e33e85fc24d4d172a93c796de1fefa81a upstream.

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

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 8ef6b94..46c7cc7 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -355,6 +355,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
+	sock_put(sk);
 
 	return error;
 
-- 
1.8.1.2

