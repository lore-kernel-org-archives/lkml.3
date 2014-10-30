Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbaJ3Mlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:41:40 -0400
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:31222
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759243AbaJ3Mli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:41:38 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>,
        Cristian Stoica <cristian.stoica@freescale.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] crypto: caam: fix missing dma unmap on error path
Date: Thu, 30 Oct 2014 14:40:22 +0200
Message-ID: <1414672822-5067-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(50986999)(87936001)(87286001)(84676001)(19580405001)(19580395003)(92566001)(120916001)(104016003)(2201001)(89996001)(33646002)(93916002)(6806004)(44976005)(4396001)(68736004)(92726001)(50226001)(88136002)(95666004)(85852003)(99396003)(104166001)(31966008)(20776003)(26826002)(47776003)(107046002)(229853001)(64706001)(50466002)(102836001)(105606002)(62966002)(36756003)(76482002)(106466001)(80022003)(46102003)(21056001)(97736003)(85306004)(48376002)(77156001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dma mapping for dma_addr_out fails, the descriptor memory is freed
but the previous dma mapping for dma_addr_in remains.
This patch resolves the missing dma unmap and groups resource
allocations at function start.

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/key_gen.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 871703c..e1eaf4f 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -48,23 +48,29 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	u32 *desc;
 	struct split_key_result result;
 	dma_addr_t dma_addr_in, dma_addr_out;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
 		dev_err(jrdev, "unable to allocate key input memory\n");
-		return -ENOMEM;
+		return ret;
 	}
 
-	init_job_desc(desc, 0);
-
 	dma_addr_in = dma_map_single(jrdev, (void *)key_in, keylen,
 				     DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, dma_addr_in)) {
 		dev_err(jrdev, "unable to map key input memory\n");
-		kfree(desc);
-		return -ENOMEM;
+		goto out_free;
 	}
+
+	dma_addr_out = dma_map_single(jrdev, key_out, split_key_pad_len,
+				      DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, dma_addr_out)) {
+		dev_err(jrdev, "unable to map key output memory\n");
+		goto out_unmap_in;
+	}
+
+	init_job_desc(desc, 0);
 	append_key(desc, dma_addr_in, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
 
 	/* Sets MDHA up into an HMAC-INIT */
@@ -81,13 +87,6 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	 * FIFO_STORE with the explicit split-key content store
 	 * (0x26 output type)
 	 */
-	dma_addr_out = dma_map_single(jrdev, key_out, split_key_pad_len,
-				      DMA_FROM_DEVICE);
-	if (dma_mapping_error(jrdev, dma_addr_out)) {
-		dev_err(jrdev, "unable to map key output memory\n");
-		kfree(desc);
-		return -ENOMEM;
-	}
 	append_fifo_store(desc, dma_addr_out, split_key_len,
 			  LDST_CLASS_2_CCB | FIFOST_TYPE_SPLIT_KEK);
 
@@ -115,10 +114,10 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 
 	dma_unmap_single(jrdev, dma_addr_out, split_key_pad_len,
 			 DMA_FROM_DEVICE);
+out_unmap_in:
 	dma_unmap_single(jrdev, dma_addr_in, keylen, DMA_TO_DEVICE);
-
+out_free:
 	kfree(desc);
-
 	return ret;
 }
 EXPORT_SYMBOL(gen_split_key);
-- 
1.8.3.1

