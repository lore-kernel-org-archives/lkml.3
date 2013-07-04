Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab3GDF7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:59:09 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:47828 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197Ab3GDF7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:59:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linuxppc-dev@linux.freescale.net>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Porosanu <alexandru.porosanu@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Ruchika Gupta <ruchika.gupta@freescale.com>,
        Vakul Garg <vakul@freescale.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: caam - RNG instantiation by directly programming DECO
Date: Thu, 4 Jul 2013 11:26:03 +0530
Message-ID: <1372917363-25422-1-git-send-email-ruchika.gupta@freescale.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the dependency of RNG instantiation on Job Ring. Now
RNG instantiation for devices with RNG version > 4 is done
by directly programming DECO 0.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 74 ++++++++++++++++++++++------------------------
 drivers/crypto/caam/regs.h | 12 +++++++-
 2 files changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index f5d6dec..86c9600 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -75,55 +75,53 @@ static void build_instantiation_desc(u32 *desc)
 			 OP_ALG_RNG4_SK);
 }
 
-struct instantiate_result {
-	struct completion completion;
-	int err;
-};
-
-static void rng4_init_done(struct device *dev, u32 *desc, u32 err,
-			   void *context)
+static int instantiate_rng(struct device *ctrldev)
 {
-	struct instantiate_result *instantiation = context;
-
-	if (err) {
-		char tmp[CAAM_ERROR_STR_MAX];
-
-		dev_err(dev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
-	}
-
-	instantiation->err = err;
-	complete(&instantiation->completion);
-}
-
-static int instantiate_rng(struct device *jrdev)
-{
-	struct instantiate_result instantiation;
-
-	dma_addr_t desc_dma;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+	struct caam_full __iomem *topregs;
+	unsigned int timeout = 100000;
 	u32 *desc;
-	int ret;
+	int i, ret = 0;
 
 	desc = kmalloc(CAAM_CMD_SZ * 6, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
-		dev_err(jrdev, "cannot allocate RNG init descriptor memory\n");
+		dev_err(ctrldev, "can't allocate RNG init descriptor memory\n");
 		return -ENOMEM;
 	}
-
 	build_instantiation_desc(desc);
-	desc_dma = dma_map_single(jrdev, desc, desc_bytes(desc), DMA_TO_DEVICE);
-	init_completion(&instantiation.completion);
-	ret = caam_jr_enqueue(jrdev, desc, rng4_init_done, &instantiation);
-	if (!ret) {
-		wait_for_completion_interruptible(&instantiation.completion);
-		ret = instantiation.err;
-		if (ret)
-			dev_err(jrdev, "unable to instantiate RNG\n");
+
+	/* Set the bit to request direct access to DECO0 */
+	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
+	setbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
+
+	while (!(rd_reg32(&topregs->ctrl.deco_rq) & DECORR_DEN0) &&
+								 --timeout)
+		cpu_relax();
+
+	if (!timeout) {
+		dev_err(ctrldev, "failed to acquire DECO 0\n");
+		ret = -EIO;
+		goto out;
 	}
 
-	dma_unmap_single(jrdev, desc_dma, desc_bytes(desc), DMA_TO_DEVICE);
+	for (i = 0; i < desc_len(desc); i++)
+		topregs->deco.descbuf[i] = *(desc + i);
 
-	kfree(desc);
+	wr_reg32(&topregs->deco.jr_ctl_hi, DECO_JQCR_WHL | DECO_JQCR_FOUR);
+
+	timeout = 10000000;
+	while ((rd_reg32(&topregs->deco.desc_dbg) & DECO_DBG_VALID) &&
+								 --timeout)
+		cpu_relax();
 
+	if (!timeout) {
+		dev_err(ctrldev, "failed to instantiate RNG\n");
+		ret = -EIO;
+	}
+
+	clrbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
+out:
+	kfree(desc);
 	return ret;
 }
 
@@ -303,7 +301,7 @@ static int caam_probe(struct platform_device *pdev)
 	if ((cha_vid & CHA_ID_RNG_MASK) >> CHA_ID_RNG_SHIFT >= 4 &&
 	    !(rd_reg32(&topregs->ctrl.r4tst[0].rdsta) & RDSTA_IF0)) {
 		kick_trng(pdev);
-		ret = instantiate_rng(ctrlpriv->jrdev[0]);
+		ret = instantiate_rng(dev);
 		if (ret) {
 			caam_remove(pdev);
 			return ret;
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index c09142f..4455396 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -341,6 +341,8 @@ struct caam_ctrl {
 #define MCFGR_DMA_RESET		0x10000000
 #define MCFGR_LONG_PTR		0x00010000 /* Use >32-bit desc addressing */
 #define SCFGR_RDBENABLE		0x00000400
+#define DECORR_RQD0ENABLE	0x00000001 /* Enable DECO0 for direct access */
+#define DECORR_DEN0		0x00010000 /* DECO0 available for access*/
 
 /* AXI read cache control */
 #define MCFGR_ARCACHE_SHIFT	12
@@ -703,9 +705,16 @@ struct caam_deco {
 	struct deco_sg_table sctr_tbl[4];	/* DxSTR - Scatter Tables */
 	u32 rsvd29[48];
 	u32 descbuf[64];	/* DxDESB - Descriptor buffer */
-	u32 rsvd30[320];
+	u32 rscvd30[193];
+	u32 desc_dbg;		/* DxDDR - DECO Debug Register */
+	u32 rsvd31[126];
 };
 
+/* DECO DBG Register Valid Bit*/
+#define DECO_DBG_VALID		0x80000000
+#define DECO_JQCR_WHL		0x20000000
+#define DECO_JQCR_FOUR		0x10000000
+
 /*
  * Current top-level view of memory map is:
  *
@@ -733,6 +742,7 @@ struct caam_full {
 	u64 rsvd[512];
 	struct caam_assurance assure;
 	struct caam_queue_if qi;
+	struct caam_deco deco;
 };
 
 #endif /* REGS_H */
-- 
1.8.1.4


