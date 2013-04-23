Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3DWWAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:00:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab3DWV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 14/23] crypto: algif - suppress sending source address information in recvmsg
Date: Tue, 23 Apr 2013 14:56:21 -0700
Message-Id: <20130423215457.748226340@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215456.307216898@linuxfoundation.org>
References: <20130423215456.307216898@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 72a763d805a48ac8c0bf48fdb510e84c12de51fe upstream.

The current code does not set the msg_namelen member to 0 and therefore
makes net/socket.c leak the local sockaddr_storage variable to userland
-- 128 bytes of kernel stack memory. Fix that.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algif_hash.c     |    2 ++
 crypto/algif_skcipher.c |    1 +
 2 files changed, 3 insertions(+)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -159,6 +159,8 @@ static int hash_recvmsg(struct kiocb *un
 	else if (len < ds)
 		msg->msg_flags |= MSG_TRUNC;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	if (ctx->more) {
 		ctx->more = 0;
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -432,6 +432,7 @@ static int skcipher_recvmsg(struct kiocb
 	long copied = 0;
 
 	lock_sock(sk);
+	msg->msg_namelen = 0;
 	for (iov = msg->msg_iov, iovlen = msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
 		unsigned long seglen = iov->iov_len;


