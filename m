Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaKROV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:21:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbaKROKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ondrej Kozina <okozina@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 190/206] crypto: algif - avoid excessive use of socket buffer in skcipher
Date: Tue, 18 Nov 2014 15:09:05 +0100
Message-Id: <d87f96cce9a81981ca3346ff333ad6e9be073a97.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Kozina <okozina@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e2cffb5f493a8b431dc87124388ea59b79f0bccb upstream.

On archs with PAGE_SIZE >= 64 KiB the function skcipher_alloc_sgl()
fails with -ENOMEM no matter what user space actually requested.
This is caused by the fact sock_kmalloc call inside the function tried
to allocate more memory than allowed by the default kernel socket buffer
size (kernel param net.core.optmem_max).

Signed-off-by: Ondrej Kozina <okozina@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

