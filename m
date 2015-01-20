Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbbATIVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:21:41 -0500
Received: from mail-bn1on0140.outbound.protection.outlook.com ([157.56.110.140]:47808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751502AbbATIVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:21:40 -0500
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: replace scatterwalk_sg_next with sg_next
Date: Tue, 20 Jan 2015 10:06:16 +0200
Message-ID: <1421741176-2663-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <20131128142130.GC32124@gondor.apana.org.au>
References: <20131128142130.GC32124@gondor.apana.org.au>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B18196@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(81156004)(92566002)(36756003)(104016003)(106466001)(85426001)(2201001)(47776003)(76176999)(50986999)(33646002)(69596002)(19580395003)(19580405001)(105606002)(6806004)(2950100001)(87936001)(77156002)(62966003)(68736005)(77096005)(50466002)(48376002)(575784001)(46102003)(97736003)(50226001)(229853001)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0618;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CY1PR0301MB0618;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0618;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0618;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 08:06:36.2763
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0618
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify crypto drivers to use the generic SG helper since
both of them are equivalent and the one from crypto is redundant.

See also:
  468577abe37ff7b453a9ac613e0ea155349203ae   reverted in
  b2ab4a57b018aafbba35bff088218f5cc3d2142e

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/ablkcipher.c                   |  3 +--
 crypto/ahash.c                        |  2 +-
 crypto/scatterwalk.c                  |  6 +++---
 drivers/crypto/bfin_crc.c             |  2 +-
 drivers/crypto/caam/sg_sw_sec4.h      |  8 ++++----
 drivers/crypto/ixp4xx_crypto.c        |  4 ++--
 drivers/crypto/nx/nx.c                |  6 +++---
 drivers/crypto/omap-aes.c             |  4 ++--
 drivers/crypto/omap-des.c             |  4 ++--
 drivers/crypto/qce/dma.c              |  6 +++---
 drivers/crypto/qce/sha.c              |  2 +-
 drivers/crypto/sahara.c               |  2 +-
 drivers/crypto/talitos.c              |  8 ++++----
 drivers/crypto/ux500/cryp/cryp_core.c |  2 +-
 include/crypto/scatterwalk.h          | 10 +---------
 15 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 7bbc8b4..db201bca 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -87,8 +87,7 @@ static inline unsigned int ablkcipher_done_slow(struct ablkcipher_walk *walk,
 		if (n == len_this_page)
 			break;
 		n -= len_this_page;
-		scatterwalk_start(&walk->out, scatterwalk_sg_next(
-			walk->out.sg));
+		scatterwalk_start(&walk->out, sg_next(walk->out.sg));
 	}
 
 	return bsize;
diff --git a/crypto/ahash.c b/crypto/ahash.c
index dd28906..8acb886 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -121,7 +121,7 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 	if (!walk->total)
 		return 0;
 
-	walk->sg = scatterwalk_sg_next(walk->sg);
+	walk->sg = sg_next(walk->sg);
 
 	return hash_walk_new_entry(walk);
 }
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 79ca227..3bd749c 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -62,7 +62,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		walk->offset += PAGE_SIZE - 1;
 		walk->offset &= PAGE_MASK;
 		if (walk->offset >= walk->sg->offset + walk->sg->length)
-			scatterwalk_start(walk, scatterwalk_sg_next(walk->sg));
+			scatterwalk_start(walk, sg_next(walk->sg));
 	}
 }
 
@@ -116,7 +116,7 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			break;
 
 		offset += sg->length;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	scatterwalk_advance(&walk, start - offset);
@@ -136,7 +136,7 @@ int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes)
 	do {
 		offset += sg->length;
 		n++;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 
 		/* num_bytes is too large */
 		if (unlikely(!sg && (num_bytes < offset)))
diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 33cf9eb..d9af940 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -110,7 +110,7 @@ static int sg_count(struct scatterlist *sg_list)
 
 	while (!sg_is_last(sg)) {
 		sg_nents++;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	return sg_nents;
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index ce28a56..3b91821 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -37,7 +37,7 @@ sg_to_sec4_sg(struct scatterlist *sg, int sg_count,
 		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg),
 				   sg_dma_len(sg), offset);
 		sec4_sg_ptr++;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 		sg_count--;
 	}
 	return sec4_sg_ptr - 1;
@@ -67,7 +67,7 @@ static inline int __sg_count(struct scatterlist *sg_list, int nbytes,
 		nbytes -= sg->length;
 		if (!sg_is_last(sg) && (sg + 1)->length == 0)
 			*chained = true;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	return sg_nents;
@@ -93,7 +93,7 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
 		int i;
 		for (i = 0; i < nents; i++) {
 			dma_map_sg(dev, sg, 1, dir);
-			sg = scatterwalk_sg_next(sg);
+			sg = sg_next(sg);
 		}
 	} else {
 		dma_map_sg(dev, sg, nents, dir);
@@ -109,7 +109,7 @@ static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
 		int i;
 		for (i = 0; i < nents; i++) {
 			dma_unmap_sg(dev, sg, 1, dir);
-			sg = scatterwalk_sg_next(sg);
+			sg = sg_next(sg);
 		}
 	} else {
 		dma_unmap_sg(dev, sg, nents, dir);
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index f757a0f..48f4535 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -784,7 +784,7 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 		struct buffer_desc *buf, gfp_t flags,
 		enum dma_data_direction dir)
 {
-	for (;nbytes > 0; sg = scatterwalk_sg_next(sg)) {
+	for (; nbytes > 0; sg = sg_next(sg)) {
 		unsigned len = min(nbytes, sg->length);
 		struct buffer_desc *next_buf;
 		u32 next_buf_phys;
@@ -982,7 +982,7 @@ static int hmac_inconsistent(struct scatterlist *sg, unsigned start,
 			break;
 
 		offset += sg->length;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 	return (start + nbytes > offset + sg->length);
 }
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index a392465..1da6dc5 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -177,7 +177,7 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
 			break;
 
 		offset += sg_src->length;
-		sg_src = scatterwalk_sg_next(sg_src);
+		sg_src = sg_next(sg_src);
 	}
 
 	/* start - offset is the number of bytes to advance in the scatterlist
@@ -187,9 +187,9 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
 	while (len && (nx_sg - nx_dst) < sglen) {
 		n = scatterwalk_clamp(&walk, len);
 		if (!n) {
-			/* In cases where we have scatterlist chain scatterwalk_sg_next
+			/* In cases where we have scatterlist chain sg_next
 			 * handles with it properly */
-			scatterwalk_start(&walk, scatterwalk_sg_next(walk.sg));
+			scatterwalk_start(&walk, sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
 		dst = scatterwalk_map(&walk);
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index f79dd41..42f95a4 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -994,7 +994,7 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 
 			scatterwalk_advance(&dd->in_walk, 4);
 			if (dd->in_sg->length == _calc_walked(in)) {
-				dd->in_sg = scatterwalk_sg_next(dd->in_sg);
+				dd->in_sg = sg_next(dd->in_sg);
 				if (dd->in_sg) {
 					scatterwalk_start(&dd->in_walk,
 							  dd->in_sg);
@@ -1026,7 +1026,7 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 			*dst = omap_aes_read(dd, AES_REG_DATA_N(dd, i));
 			scatterwalk_advance(&dd->out_walk, 4);
 			if (dd->out_sg->length == _calc_walked(out)) {
-				dd->out_sg = scatterwalk_sg_next(dd->out_sg);
+				dd->out_sg = sg_next(dd->out_sg);
 				if (dd->out_sg) {
 					scatterwalk_start(&dd->out_walk,
 							  dd->out_sg);
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 0b8dcf5..4630709 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -921,7 +921,7 @@ static irqreturn_t omap_des_irq(int irq, void *dev_id)
 
 			scatterwalk_advance(&dd->in_walk, 4);
 			if (dd->in_sg->length == _calc_walked(in)) {
-				dd->in_sg = scatterwalk_sg_next(dd->in_sg);
+				dd->in_sg = sg_next(dd->in_sg);
 				if (dd->in_sg) {
 					scatterwalk_start(&dd->in_walk,
 							  dd->in_sg);
@@ -953,7 +953,7 @@ static irqreturn_t omap_des_irq(int irq, void *dev_id)
 			*dst = omap_des_read(dd, DES_REG_DATA_N(dd, i));
 			scatterwalk_advance(&dd->out_walk, 4);
 			if (dd->out_sg->length == _calc_walked(out)) {
-				dd->out_sg = scatterwalk_sg_next(dd->out_sg);
+				dd->out_sg = sg_next(dd->out_sg);
 				if (dd->out_sg) {
 					scatterwalk_start(&dd->out_walk,
 							  dd->out_sg);
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 0fb21e1..378cb76 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -64,7 +64,7 @@ int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
 			err = dma_map_sg(dev, sg, 1, dir);
 			if (!err)
 				return -EFAULT;
-			sg = scatterwalk_sg_next(sg);
+			sg = sg_next(sg);
 		}
 	} else {
 		err = dma_map_sg(dev, sg, nents, dir);
@@ -81,7 +81,7 @@ void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
 	if (chained)
 		while (sg) {
 			dma_unmap_sg(dev, sg, 1, dir);
-			sg = scatterwalk_sg_next(sg);
+			sg = sg_next(sg);
 		}
 	else
 		dma_unmap_sg(dev, sg, nents, dir);
@@ -100,7 +100,7 @@ int qce_countsg(struct scatterlist *sglist, int nbytes, bool *chained)
 		nbytes -= sg->length;
 		if (!sg_is_last(sg) && (sg + 1)->length == 0 && chained)
 			*chained = true;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	return nents;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index f338593..5c5df1d 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -285,7 +285,7 @@ static int qce_ahash_update(struct ahash_request *req)
 			break;
 		len += sg_dma_len(sg);
 		sg_last = sg;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	if (!sg_last)
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 220b92f..290a7f0 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -940,7 +940,7 @@ static int sahara_walk_and_recalc(struct scatterlist *sg, unsigned int nbytes)
 			break;
 		}
 		nbytes -= sg->length;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	return nbytes;
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 067ec21..ebbae8d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -743,7 +743,7 @@ static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
 	if (unlikely(chained))
 		while (sg) {
 			dma_map_sg(dev, sg, 1, dir);
-			sg = scatterwalk_sg_next(sg);
+			sg = sg_next(sg);
 		}
 	else
 		dma_map_sg(dev, sg, nents, dir);
@@ -755,7 +755,7 @@ static void talitos_unmap_sg_chain(struct device *dev, struct scatterlist *sg,
 {
 	while (sg) {
 		dma_unmap_sg(dev, sg, 1, dir);
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 }
 
@@ -915,7 +915,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 		link_tbl_ptr->j_extent = 0;
 		link_tbl_ptr++;
 		cryptlen -= sg_dma_len(sg);
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	/* adjust (decrease) last one (or two) entry's len to cryptlen */
@@ -1102,7 +1102,7 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
 		nbytes -= sg->length;
 		if (!sg_is_last(sg) && (sg + 1)->length == 0)
 			*chained = true;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	return sg_nents;
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index f087f37..d594ae9 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -814,7 +814,7 @@ static int get_nents(struct scatterlist *sg, int nbytes)
 
 	while (nbytes > 0) {
 		nbytes -= sg->length;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 		nents++;
 	}
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 7ef512f..20e4226 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -33,21 +33,13 @@ static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 	sg1[num - 1].page_link |= 0x01;
 }
 
-static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
-{
-	if (sg_is_last(sg))
-		return NULL;
-
-	return (++sg)->length ? sg : sg_chain_ptr(sg);
-}
-
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 					    struct scatterlist *sg,
 					    int chain, int num)
 {
 	if (chain) {
 		head->length += sg->length;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	if (sg)
-- 
2.2.0

