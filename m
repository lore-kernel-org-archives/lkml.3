Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaJ1Ruw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:50:52 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:55531 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaJ1Ruu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:50:50 -0400
Date: Tue, 28 Oct 2014 15:50:45 -0200
From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 8/9] Fixing the limit number of bytes to be processed
Message-ID: <20141028175041.GA18250@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102817-1524-0000-0000-000000E26215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous limits were estimated locally in a single step
basead on bound values, however it was not correct since
when given certain scatterlist the function nx_build_sg_lists
was consuming more sg entries than allocated causing a
memory corruption and crashes.

e.g.: in the worst case we could have one sg entry for a single byte.

This patch fixes it modifying the logic of the bound limit
moving it to nx_sg_build_lists and set a correct sg_max limit,
adding a trim function to ensure the bound in sg_list. Also fixing
nx_build_sg_list  NULL and untreated return in case of overflow.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx.c |  127 ++++++++++++++++++++++++++++++++++++++++-------
 drivers/crypto/nx/nx.h |    8 ++-
 2 files changed, 113 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 5533fe3..aa8c38d 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -90,7 +90,7 @@ int nx_hcall_sync(struct nx_crypto_ctx *nx_ctx,
  */
 struct nx_sg *nx_build_sg_list(struct nx_sg *sg_head,
 			       u8           *start_addr,
-			       unsigned int  len,
+			       unsigned int *len,
 			       u32           sgmax)
 {
 	unsigned int sg_len = 0;
@@ -106,7 +106,7 @@ struct nx_sg *nx_build_sg_list(struct nx_sg *sg_head,
 	else
 		sg_addr = __pa(sg_addr);
 
-	end_addr = sg_addr + len;
+	end_addr = sg_addr + *len;
 
 	/* each iteration will write one struct nx_sg element and add the
 	 * length of data described by that element to sg_len. Once @len bytes
@@ -118,7 +118,7 @@ struct nx_sg *nx_build_sg_list(struct nx_sg *sg_head,
 	 * Also when using vmalloc'ed data, every time that a system page
 	 * boundary is crossed the physical address needs to be re-calculated.
 	 */
-	for (sg = sg_head; sg_len < len; sg++) {
+	for (sg = sg_head; sg_len < *len; sg++) {
 		u64 next_page;
 
 		sg->addr = sg_addr;
@@ -133,15 +133,17 @@ struct nx_sg *nx_build_sg_list(struct nx_sg *sg_head,
 				is_vmalloc_addr(start_addr + sg_len)) {
 			sg_addr = page_to_phys(vmalloc_to_page(
 						start_addr + sg_len));
-			end_addr = sg_addr + len - sg_len;
+			end_addr = sg_addr + *len - sg_len;
 		}
 
 		if ((sg - sg_head) == sgmax) {
 			pr_err("nx: scatter/gather list overflow, pid: %d\n",
 			       current->pid);
-			return NULL;
+			sg++;
+			break;
 		}
 	}
+	*len = sg_len;
 
 	/* return the moved sg_head pointer */
 	return sg;
@@ -160,11 +162,11 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
 				unsigned int        sglen,
 				struct scatterlist *sg_src,
 				unsigned int        start,
-				unsigned int        src_len)
+				unsigned int       *src_len)
 {
 	struct scatter_walk walk;
 	struct nx_sg *nx_sg = nx_dst;
-	unsigned int n, offset = 0, len = src_len;
+	unsigned int n, offset = 0, len = *src_len;
 	char *dst;
 
 	/* we need to fast forward through @start bytes first */
@@ -182,27 +184,101 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
 	 * element we're currently looking at */
 	scatterwalk_advance(&walk, start - offset);
 
-	while (len && nx_sg) {
+	while (len && (nx_sg - nx_dst) < sglen) {
 		n = scatterwalk_clamp(&walk, len);
 		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
+			/* In cases where we have scatterlist chain scatterwalk_sg_next
+ 			 * handles with it properly */
+			scatterwalk_start(&walk, scatterwalk_sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
 		dst = scatterwalk_map(&walk);
 
-		nx_sg = nx_build_sg_list(nx_sg, dst, n, sglen);
+		nx_sg = nx_build_sg_list(nx_sg, dst, &n, sglen - (nx_sg - nx_dst));
 		len -= n;
 
 		scatterwalk_unmap(dst);
 		scatterwalk_advance(&walk, n);
 		scatterwalk_done(&walk, SCATTERWALK_FROM_SG, len);
 	}
+	/* update to_process */
+	*src_len -= len;
 
 	/* return the moved destination pointer */
 	return nx_sg;
 }
 
 /**
+ * trim_sg_list - ensures the bound in sg list.
+ * @sg: sg list head
+ * @end: sg lisg end
+ * @delta:  is the amount we need to crop in order to bound the list.
+ *
+ */
+static long int trim_sg_list(struct nx_sg *sg, struct nx_sg *end, unsigned int delta)
+{
+	while (delta && end > sg) {
+		struct nx_sg *last = end - 1;
+
+		if (last->len > delta) {
+			last->len -= delta;
+			delta = 0;
+		} else {
+			end--;
+			delta -= last->len;
+		}
+	}
+	return (sg - end) * sizeof(struct nx_sg);
+}
+
+/**
+ * nx_sha_build_sg_list - walk and build sg list to sha modes
+ *			  using right bounds and limits.
+ * @nx_ctx: NX crypto context for the lists we're building
+ * @nx_sg: current sg list in or out list
+ * @op_len: current op_len to be used in order to build a sg list
+ * @nbytes:  number or bytes to be processed
+ * @offset: buf offset
+ * @mode: SHA256 or SHA512
+ */
+int nx_sha_build_sg_list(struct nx_crypto_ctx *nx_ctx,
+			  struct nx_sg 	      *nx_in_outsg,
+			  s64		      *op_len,
+			  unsigned int        *nbytes,
+			  u8 		      *offset,
+			  u32		      mode)
+{
+	unsigned int delta = 0;
+	unsigned int total = *nbytes;
+	struct nx_sg *nx_insg = nx_in_outsg;
+	unsigned int max_sg_len;
+
+	max_sg_len = min_t(u64, nx_ctx->ap->sglen,
+			nx_driver.of.max_sg_len/sizeof(struct nx_sg));
+	max_sg_len = min_t(u64, max_sg_len,
+			nx_ctx->ap->databytelen/NX_PAGE_SIZE);
+
+	*nbytes = min_t(u64, *nbytes, nx_ctx->ap->databytelen);
+	nx_insg = nx_build_sg_list(nx_insg, offset, nbytes, max_sg_len);
+
+	switch (mode) {
+	case NX_DS_SHA256:
+		if (*nbytes < total)
+			delta = *nbytes - (*nbytes & ~(SHA256_BLOCK_SIZE - 1));
+		break;
+	case NX_DS_SHA512:
+		if (*nbytes < total)
+			delta = *nbytes - (*nbytes & ~(SHA512_BLOCK_SIZE - 1));
+		break;
+	default:
+		return -EINVAL;
+	}
+	*op_len = trim_sg_list(nx_in_outsg, nx_insg, delta);
+
+	return 0;
+}
+
+/**
  * nx_build_sg_lists - walk the input scatterlists and build arrays of NX
  *                     scatterlists based on them.
  *
@@ -223,26 +299,39 @@ int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
 		      struct blkcipher_desc *desc,
 		      struct scatterlist    *dst,
 		      struct scatterlist    *src,
-		      unsigned int           nbytes,
+		      unsigned int          *nbytes,
 		      unsigned int           offset,
 		      u8                    *iv)
 {
+	unsigned int delta = 0;
+	unsigned int total = *nbytes;
 	struct nx_sg *nx_insg = nx_ctx->in_sg;
 	struct nx_sg *nx_outsg = nx_ctx->out_sg;
+	unsigned int max_sg_len;
+
+	max_sg_len = min_t(u64, nx_ctx->ap->sglen,
+			nx_driver.of.max_sg_len/sizeof(struct nx_sg));
+	max_sg_len = min_t(u64, max_sg_len,
+			nx_ctx->ap->databytelen/NX_PAGE_SIZE);
 
 	if (iv)
 		memcpy(iv, desc->info, AES_BLOCK_SIZE);
 
-	nx_insg = nx_walk_and_build(nx_insg, nx_ctx->ap->sglen, src,
-				    offset, nbytes);
-	nx_outsg = nx_walk_and_build(nx_outsg, nx_ctx->ap->sglen, dst,
-				    offset, nbytes);
+	*nbytes = min_t(u64, *nbytes, nx_ctx->ap->databytelen);
+
+	nx_outsg = nx_walk_and_build(nx_outsg, max_sg_len, dst,
+					offset, nbytes);
+	nx_insg = nx_walk_and_build(nx_insg, max_sg_len, src,
+					offset, nbytes);
+
+	if (*nbytes < total)
+		delta = *nbytes - (*nbytes & ~(AES_BLOCK_SIZE - 1));
 
 	/* these lengths should be negative, which will indicate to phyp that
 	 * the input and output parameters are scatterlists, not linear
 	 * buffers */
-	nx_ctx->op.inlen = (nx_ctx->in_sg - nx_insg) * sizeof(struct nx_sg);
-	nx_ctx->op.outlen = (nx_ctx->out_sg - nx_outsg) * sizeof(struct nx_sg);
+	nx_ctx->op.inlen = trim_sg_list(nx_ctx->in_sg, nx_insg, delta);
+	nx_ctx->op.outlen = trim_sg_list(nx_ctx->out_sg, nx_outsg, delta);
 
 	return 0;
 }
@@ -540,10 +629,10 @@ static int nx_crypto_ctx_init(struct nx_crypto_ctx *nx_ctx, u32 fc, u32 mode)
 
 	/* we need an extra page for csbcpb_aead for these modes */
 	if (mode == NX_MODE_AES_GCM || mode == NX_MODE_AES_CCM)
-		nx_ctx->kmem_len = (4 * NX_PAGE_SIZE) +
+		nx_ctx->kmem_len = (5 * NX_PAGE_SIZE) +
 				   sizeof(struct nx_csbcpb);
 	else
-		nx_ctx->kmem_len = (3 * NX_PAGE_SIZE) +
+		nx_ctx->kmem_len = (4 * NX_PAGE_SIZE) +
 				   sizeof(struct nx_csbcpb);
 
 	nx_ctx->kmem = kmalloc(nx_ctx->kmem_len, GFP_KERNEL);
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index befda07..6c9ecaa 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -153,13 +153,15 @@ void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
 void nx_ctx_init(struct nx_crypto_ctx *nx_ctx, unsigned int function);
 int nx_hcall_sync(struct nx_crypto_ctx *ctx, struct vio_pfo_op *op,
 		  u32 may_sleep);
-struct nx_sg *nx_build_sg_list(struct nx_sg *, u8 *, unsigned int, u32);
+int nx_sha_build_sg_list(struct nx_crypto_ctx *, struct nx_sg *,
+			 s64 *, unsigned int *, u8 *, u32);
+struct nx_sg *nx_build_sg_list(struct nx_sg *, u8 *, unsigned int *, u32);
 int nx_build_sg_lists(struct nx_crypto_ctx *, struct blkcipher_desc *,
-		      struct scatterlist *, struct scatterlist *, unsigned int,
+		      struct scatterlist *, struct scatterlist *, unsigned int *,
 		      unsigned int, u8 *);
 struct nx_sg *nx_walk_and_build(struct nx_sg *, unsigned int,
 				struct scatterlist *, unsigned int,
-				unsigned int);
+				unsigned int *);
 
 #ifdef CONFIG_DEBUG_FS
 #define NX_DEBUGFS_INIT(drv)	nx_debugfs_init(drv)
-- 
1.7.1

