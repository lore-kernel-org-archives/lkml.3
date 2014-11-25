Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaKYLnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:43:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58318 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaKYKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ondrej Kozina <okozina@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 068/254] crypto: algif - avoid excessive use of socket buffer in skcipher
Date: Tue, 25 Nov 2014 10:36:58 +0000
Message-Id: <1416912004-5928-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a19c027b29bd..83187f497c7c 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -49,7 +49,7 @@ struct skcipher_ctx {
 	struct ablkcipher_request req;
 };
 
-#define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) / \
+#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
 static inline int skcipher_sndbuf(struct sock *sk)
-- 
2.1.0

