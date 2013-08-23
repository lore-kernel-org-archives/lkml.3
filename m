Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3HWUBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:01:39 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:49185 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3HWUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:37 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 01/10] crypto: nx - add offset to nx_build_sg_lists()
Date: Fri, 23 Aug 2013 17:01:05 -0300
Message-Id: <1377288074-18998-2-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082320-2194-0000-0000-0000065717FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes one more parameter to nx_build_sg_lists() to skip
the given number of bytes from beginning of each sg list.

This is needed in order to implement the fixes for the AES modes to make
them able to process larger chunks of data.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-cbc.c | 2 +-
 drivers/crypto/nx/nx-aes-ccm.c | 4 ++--
 drivers/crypto/nx/nx-aes-ctr.c | 2 +-
 drivers/crypto/nx/nx-aes-ecb.c | 2 +-
 drivers/crypto/nx/nx-aes-gcm.c | 2 +-
 drivers/crypto/nx/nx.c         | 9 +++++++--
 drivers/crypto/nx/nx.h         | 2 +-
 7 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index 9310982..f334a60 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -85,7 +85,7 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
 	else
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes,
+	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes, 0,
 			       csbcpb->cpb.aes_cbc.iv);
 	if (rc)
 		goto out;
diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 39d4224..666a35b 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -293,7 +293,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	if (rc)
 		goto out;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src, nbytes,
+	rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src, nbytes, 0,
 			       csbcpb->cpb.aes_ccm.iv_or_ctr);
 	if (rc)
 		goto out;
@@ -339,7 +339,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 	if (rc)
 		goto out;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src, nbytes,
+	rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src, nbytes, 0,
 			       csbcpb->cpb.aes_ccm.iv_or_ctr);
 	if (rc)
 		goto out;
diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index 762611b..80dee8d 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -98,7 +98,7 @@ static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
 		goto out;
 	}
 
-	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes,
+	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes, 0,
 			       csbcpb->cpb.aes_ctr.iv);
 	if (rc)
 		goto out;
diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index 77dbe08..fe0d803 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -85,7 +85,7 @@ static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
 	else
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
-	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes, NULL);
+	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes, 0, NULL);
 	if (rc)
 		goto out;
 
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 74feee1..c2d6f76 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -226,7 +226,7 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 
 	csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
 
-	rc = nx_build_sg_lists(nx_ctx, &desc, req->dst, req->src, nbytes,
+	rc = nx_build_sg_lists(nx_ctx, &desc, req->dst, req->src, nbytes, 0,
 			       csbcpb->cpb.aes_gcm.iv_or_cnt);
 	if (rc)
 		goto out;
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index bdf4990..5533fe3 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -211,6 +211,8 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
  * @dst: destination scatterlist
  * @src: source scatterlist
  * @nbytes: length of data described in the scatterlists
+ * @offset: number of bytes to fast-forward past at the beginning of
+ *          scatterlists.
  * @iv: destination for the iv data, if the algorithm requires it
  *
  * This is common code shared by all the AES algorithms. It uses the block
@@ -222,6 +224,7 @@ int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
 		      struct scatterlist    *dst,
 		      struct scatterlist    *src,
 		      unsigned int           nbytes,
+		      unsigned int           offset,
 		      u8                    *iv)
 {
 	struct nx_sg *nx_insg = nx_ctx->in_sg;
@@ -230,8 +233,10 @@ int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
 	if (iv)
 		memcpy(iv, desc->info, AES_BLOCK_SIZE);
 
-	nx_insg = nx_walk_and_build(nx_insg, nx_ctx->ap->sglen, src, 0, nbytes);
-	nx_outsg = nx_walk_and_build(nx_outsg, nx_ctx->ap->sglen, dst, 0, nbytes);
+	nx_insg = nx_walk_and_build(nx_insg, nx_ctx->ap->sglen, src,
+				    offset, nbytes);
+	nx_outsg = nx_walk_and_build(nx_outsg, nx_ctx->ap->sglen, dst,
+				    offset, nbytes);
 
 	/* these lengths should be negative, which will indicate to phyp that
 	 * the input and output parameters are scatterlists, not linear
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 14bb97f..befda07 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -156,7 +156,7 @@ int nx_hcall_sync(struct nx_crypto_ctx *ctx, struct vio_pfo_op *op,
 struct nx_sg *nx_build_sg_list(struct nx_sg *, u8 *, unsigned int, u32);
 int nx_build_sg_lists(struct nx_crypto_ctx *, struct blkcipher_desc *,
 		      struct scatterlist *, struct scatterlist *, unsigned int,
-		      u8 *);
+		      unsigned int, u8 *);
 struct nx_sg *nx_walk_and_build(struct nx_sg *, unsigned int,
 				struct scatterlist *, unsigned int,
 				unsigned int);
-- 
1.7.12

