Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3F1S5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41899 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3F1S5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 088/105] l2tp: Fix PPP header erasure and memory leak
Date: Fri, 28 Jun 2013 11:51:50 -0700
Message-Id: <1372445527-24414-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <g.nault@alphalink.fr>

[ Upstream commit 55b92b7a11690bc377b5d373872a6b650ae88e64 ]

Copy user data after PPP framing header. This prevents erasure of the
added PPP header and avoids leaking two bytes of uninitialised memory
at the end of skb's data buffer.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 044e9e1..88ba2e4 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -345,12 +345,12 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	skb_put(skb, 2);
 
 	/* Copy user data into skb */
-	error = memcpy_fromiovec(skb->data, m->msg_iov, total_len);
+	error = memcpy_fromiovec(skb_put(skb, total_len), m->msg_iov,
+				 total_len);
 	if (error < 0) {
 		kfree_skb(skb);
 		goto error_put_sess_tun;
 	}
-	skb_put(skb, total_len);
 
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
-- 
1.8.1.2

