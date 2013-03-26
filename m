Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3CZRpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:45:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3CZRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:21 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wx3QdRDtu8sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FBA0G3cyFL0A:10 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173607.320877053@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 46/86] l2tp: Restore socket refcount when sendmsg succeeds
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0046-l2tp-Restore-socket-refcount-when-sendmsg-succeeds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 net/l2tp/l2tp_ppp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 286366e..e966602 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -355,6 +355,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
+	sock_put(sk);
 
 	return error;
 
-- 
1.7.10.4


