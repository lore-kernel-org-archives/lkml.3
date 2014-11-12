Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841AbaKLDX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:23:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbaKLBeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ondrej Kozina <okozina@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.17 278/319] crypto: algif - avoid excessive use of socket buffer in skcipher
Date: Wed, 12 Nov 2014 10:16:56 +0900
Message-Id: <20141112011038.830438736@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Kozina <okozina@redhat.com>

commit e2cffb5f493a8b431dc87124388ea59b79f0bccb upstream.

On archs with PAGE_SIZE >= 64 KiB the function skcipher_alloc_sgl()
fails with -ENOMEM no matter what user space actually requested.
This is caused by the fact sock_kmalloc call inside the function tried
to allocate more memory than allowed by the default kernel socket buffer
size (kernel param net.core.optmem_max).

Signed-off-by: Ondrej Kozina <okozina@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algif_skcipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -49,7 +49,7 @@ struct skcipher_ctx {
 	struct ablkcipher_request req;
 };
 
-#define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) / \
+#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
 static inline int skcipher_sndbuf(struct sock *sk)


