Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbaGXNrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:47:12 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:52320 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061AbaGXNrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:47:10 -0400
Date: Thu, 24 Jul 2014 10:47:04 -0300
From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
Subject: [PATCH 1/8] Adding nx_copy_ctx and kmemcache to handle with crypto
 context
Message-ID: <20140724134701.GA23910@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072413-2194-0000-0000-00000018174E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- This patch adds kmemcache to nx_driver in replace the use of
spinlocks in nx.
- Adds a copy function that handles with the current
context as a copy of the context in crypto API.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/crypto/nx/nx.h |    8 +++++---
 2 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 5533fe3..15fe87f 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -255,7 +255,6 @@ int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
  */
 void nx_ctx_init(struct nx_crypto_ctx *nx_ctx, unsigned int function)
 {
-	spin_lock_init(&nx_ctx->lock);
 	memset(nx_ctx->kmem, 0, nx_ctx->kmem_len);
 	nx_ctx->csbcpb->csb.valid |= NX_CSB_VALID_BIT;
 
@@ -633,6 +632,7 @@ void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
 
 static int nx_probe(struct vio_dev *viodev, const struct vio_device_id *id)
 {
+	int rc;
 	dev_dbg(&viodev->dev, "driver probed: %s resource id: 0x%x\n",
 		viodev->name, viodev->resource_id);
 
@@ -646,7 +646,17 @@ static int nx_probe(struct vio_dev *viodev, const struct vio_device_id *id)
 
 	nx_of_init(&viodev->dev, &nx_driver.of);
 
-	return nx_register_algs();
+	nx_driver.slab = kmem_cache_create("nx_slab", 5 * NX_PAGE_SIZE,
+			0, 0, NULL);
+	if (!nx_driver.slab) {
+		dev_err(&viodev->dev, "%s: Failed to allocate slab\n", __func__);
+		return -ENOMEM;
+	}
+	
+	rc = nx_register_algs();
+	if (rc)
+		kmem_cache_destroy(nx_driver.slab);
+	return rc;
 }
 
 static int nx_remove(struct vio_dev *viodev)
@@ -668,11 +678,42 @@ static int nx_remove(struct vio_dev *viodev)
 		crypto_unregister_shash(&nx_shash_sha256_alg);
 		crypto_unregister_shash(&nx_shash_sha512_alg);
 		crypto_unregister_shash(&nx_shash_aes_xcbc_alg);
+		kmem_cache_destroy(nx_driver.slab);
 	}
 
 	return 0;
 }
 
+int nx_copy_ctx(struct nx_crypto_ctx *dst, 
+		const struct nx_crypto_ctx *src)
+{
+	memcpy(dst, src, sizeof(*src));
+	dst->kmem = kmem_cache_alloc(nx_driver.slab, GFP_ATOMIC);
+	if (!dst->kmem)
+		return -ENOMEM;
+
+	/* the csbcpb and scatterlist must be 4k aligned pages */
+	dst->csbcpb = (struct nx_csbcpb *)(round_up((u64) dst->kmem,
+							(u64)NX_PAGE_SIZE));
+	dst->in_sg = (struct nx_sg *)((u8 *) dst->csbcpb + NX_PAGE_SIZE);
+	dst->out_sg = (struct nx_sg *)((u8 *) dst->in_sg + NX_PAGE_SIZE);
+	dst->op.csbcpb = __pa(dst->csbcpb);
+	dst->op.in = __pa(dst->in_sg);
+	dst->op.out =__pa(dst->out_sg);
+
+	if (src->csbcpb->cpb.hdr.mode == NX_MODE_AES_GCM || 
+			src->csbcpb->cpb.hdr.mode == NX_MODE_AES_CCM) { 
+		dst->csbcpb_aead = 
+		     (struct nx_csbcpb *)((u8 *)src->out_sg + NX_PAGE_SIZE);
+		dst->op_aead.csbcpb = __pa(dst->csbcpb_aead);
+		dst->op_aead.in = __pa(dst->in_sg);
+		dst->op_aead.out = __pa(dst->out_sg);
+
+		memcpy(dst->csbcpb_aead, src->csbcpb_aead, sizeof(struct nx_csbcpb));
+	}
+	memcpy(dst->csbcpb, src->csbcpb, sizeof(struct nx_csbcpb));
+	return 0;
+} 
 
 /* module wide initialization/cleanup */
 static int __init nx_init(void)
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index befda07..af15510 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -6,14 +6,15 @@
 #define NX_STRING	"IBM Power7+ Nest Accelerator Crypto Driver"
 #define NX_VERSION	"1.0"
 
+#include <linux/slab.h>
+
 static const char nx_driver_string[] = NX_STRING;
 static const char nx_driver_version[] = NX_VERSION;
 
 /* a scatterlist in the format PHYP is expecting */
 struct nx_sg {
 	u64 addr;
-	u32 rsvd;
-	u32 len;
+	u64 len;
 } __attribute((packed));
 
 #define NX_PAGE_SIZE		(4096)
@@ -87,6 +88,7 @@ struct nx_crypto_driver {
 	struct vio_dev    *viodev;
 	struct vio_driver  viodriver;
 	struct nx_debugfs  dfs;
+	struct kmem_cache *slab;
 };
 
 #define NX_GCM4106_NONCE_LEN		(4)
@@ -117,7 +119,6 @@ struct nx_ctr_priv {
 };
 
 struct nx_crypto_ctx {
-	spinlock_t lock;	  /* synchronize access to the context */
 	void *kmem;		  /* unaligned, kmalloc'd buffer */
 	size_t kmem_len;	  /* length of kmem */
 	struct nx_csbcpb *csbcpb; /* aligned page given to phyp @ hcall time */
@@ -160,6 +161,7 @@ int nx_build_sg_lists(struct nx_crypto_ctx *, struct blkcipher_desc *,
 struct nx_sg *nx_walk_and_build(struct nx_sg *, unsigned int,
 				struct scatterlist *, unsigned int,
 				unsigned int);
+int nx_copy_ctx(struct nx_crypto_ctx *, const struct nx_crypto_ctx *);
 
 #ifdef CONFIG_DEBUG_FS
 #define NX_DEBUGFS_INIT(drv)	nx_debugfs_init(drv)
-- 
1.7.1

