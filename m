Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967572AbaLLHC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:02:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51705 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758409AbaLLGQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Ondrej Kozina" <okozina@redhat.com>
Date: Fri, 12 Dec 2014 06:14:26 +0000
Message-ID: <lsq.1418364866.453576473@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 163/164] crypto: algif - avoid excessive use of socket
 buffer in skcipher
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a19c027..83187f4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -49,7 +49,7 @@ struct skcipher_ctx {
 	struct ablkcipher_request req;
 };
 
-#define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) / \
+#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
 static inline int skcipher_sndbuf(struct sock *sk)

