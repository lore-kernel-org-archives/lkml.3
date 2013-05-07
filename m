Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab3EGEeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:34:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556Ab3EGEZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:52 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=igOWK8tfzcwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AF-GGBz9fJIA:10 a=mK_AVkanAAAA:8 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8 a=sWb2hJHYLsZzdZvheagA:9 a=9xyTavCNlvEA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035854.492831548@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [081/126] crypto: algif - suppress sending source address information in
 recvmsg
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0081-crypto-algif-suppress-sending-source-address-informa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 72a763d805a48ac8c0bf48fdb510e84c12de51fe ]

The current code does not set the msg_namelen member to 0 and therefore
makes net/socket.c leak the local sockaddr_storage variable to userland
-- 128 bytes of kernel stack memory. Fix that.

Cc: <stable@vger.kernel.org> # 2.6.38
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 crypto/algif_hash.c     |    2 ++
 crypto/algif_skcipher.c |    1 +
 2 files changed, 3 insertions(+)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index ef5356c..0262210 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -161,6 +161,8 @@ static int hash_recvmsg(struct kiocb *unused, struct socket *sock,
 	else if (len < ds)
 		msg->msg_flags |= MSG_TRUNC;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	if (ctx->more) {
 		ctx->more = 0;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..a1c4f0a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -432,6 +432,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 	long copied = 0;
 
 	lock_sock(sk);
+	msg->msg_namelen = 0;
 	for (iov = msg->msg_iov, iovlen = msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
 		unsigned long seglen = iov->iov_len;
-- 
1.7.10.4


