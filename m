Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaLEF65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:58:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51296 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaLEF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:58:55 -0500
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] raw.c: stick msghdr into raw_frag_vec
Date: Fri,  5 Dec 2014 05:58:42 +0000
Message-Id: <1417759133-18370-1-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20141205055623.GQ29748@ZenIV.linux.org.uk>
References: <20141205055623.GQ29748@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

we'll want access to ->msg_iter

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv4/raw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 43385a9..5c901eb 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -82,7 +82,7 @@
 #include <linux/uio.h>
 
 struct raw_frag_vec {
-	struct iovec *iov;
+	struct msghdr *msg;
 	union {
 		struct icmphdr icmph;
 		char c[1];
@@ -440,7 +440,7 @@ static int raw_probe_proto_opt(struct raw_frag_vec *rfv, struct flowi4 *fl4)
 	/* We only need the first two bytes. */
 	rfv->hlen = 2;
 
-	err = memcpy_fromiovec(rfv->hdr.c, rfv->iov, rfv->hlen);
+	err = memcpy_from_msg(rfv->hdr.c, rfv->msg, rfv->hlen);
 	if (err)
 		return err;
 
@@ -478,7 +478,7 @@ static int raw_getfrag(void *from, char *to, int offset, int len, int odd,
 
 	offset -= rfv->hlen;
 
-	return ip_generic_getfrag(rfv->iov, to, offset, len, odd, skb);
+	return ip_generic_getfrag(rfv->msg->msg_iov, to, offset, len, odd, skb);
 }
 
 static int raw_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
@@ -600,7 +600,7 @@ static int raw_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			   daddr, saddr, 0, 0);
 
 	if (!inet->hdrincl) {
-		rfv.iov = msg->msg_iov;
+		rfv.msg = msg;
 		rfv.hlen = 0;
 
 		err = raw_probe_proto_opt(&rfv, &fl4);
-- 
2.1.3

