Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3CYBja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:39:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33769 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab3CYBPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:02 -0400
Message-Id: <20130325010524.802679721@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 005/104] l2tp: Restore socket refcount when sendmsg succeeds
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <g.nault@alphalink.fr>

[ Upstream commit 8b82547e33e85fc24d4d172a93c796de1fefa81a ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_ppp.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -360,6 +360,7 @@ static int pppol2tp_sendmsg(struct kiocb
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
+	sock_put(sk);
 
 	return error;
 


