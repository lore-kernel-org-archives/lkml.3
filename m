Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3CRVOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:14:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab3CRVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 31/40] l2tp: Restore socket refcount when sendmsg succeeds
Date: Mon, 18 Mar 2013 14:11:09 -0700
Message-Id: <20130318211018.485624552@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -360,6 +360,7 @@ static int pppol2tp_sendmsg(struct kiocb
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
+	sock_put(sk);
 
 	return error;
 


