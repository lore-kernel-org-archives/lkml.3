Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3FYSlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:41:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3FYSjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:39:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/17] l2tp: Fix PPP header erasure and memory leak
Date: Tue, 25 Jun 2013 11:39:30 -0700
Message-Id: <20130625183917.146782648@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183915.443950649@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <g.nault@alphalink.fr>

[ Upstream commit 55b92b7a11690bc377b5d373872a6b650ae88e64 ]

Copy user data after PPP framing header. This prevents erasure of the
added PPP header and avoids leaking two bytes of uninitialised memory
at the end of skb's data buffer.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -350,12 +350,12 @@ static int pppol2tp_sendmsg(struct kiocb
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
 


