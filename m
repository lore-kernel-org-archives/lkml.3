Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaFWGzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:55:35 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:43694
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751332AbaFWGzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:55:33 -0400
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
        <horia.geanta@freescale.com>, <grant.likely@linaro.org>,
        <NiteshNarayanLal@freescale.com>, <thierry.reding@gmail.com>,
        <rob.herring@calxeda.com>, <kim.phillips@freescale.com>,
        <dan.carpenter@oracle.com>,
        Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH] crypto:caam - Configuration for platforms with virtualization enabled in CAAM
Date: Mon, 23 Jun 2014 17:42:33 +0530
Message-ID: <1403525553-17170-1-git-send-email-ruchika.gupta@freescale.com>
X-Mailer: git-send-email 1.8.1.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(79102001)(31966008)(50986999)(105606002)(20776003)(47776003)(64706001)(80022001)(92566001)(46102001)(92726001)(2201001)(74502001)(106466001)(104166001)(85306003)(33646001)(74662001)(4396001)(95666004)(104016002)(48376002)(77156001)(83322001)(19580405001)(19580395003)(44976005)(6806004)(77982001)(102836001)(50466002)(68736004)(15975445006)(36756003)(93916002)(26826002)(86362001)(83072002)(85852003)(87286001)(81342001)(62966002)(575784001)(84676001)(21056001)(50226001)(99396002)(97736001)(89996001)(88136002)(87936001)(76482001)(81542001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB333;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=ruchika.gupta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms with virtualization enabled

    1. The job ring registers can be written to only is the job ring has been
       started i.e STARTR bit in JRSTART register is 1

    2. For DECO's under direct software control, with virtualization enabled
       PL, BMT, ICID and SDID values need to be provided. These are provided by
       selecting a Job ring in start mode whose parameters would be used for the
       DECO access programming.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
The current patch  used the 32 bit register comp_params_ms defined in another patch.
The link of patch thsi patch is depnedent on is given below:
 crypto: caam - Correct definition of registers in memory map
(https://lkml.org/lkml/2014/6/23/3)	

 drivers/crypto/caam/ctrl.c   | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/intern.h |  1 +
 drivers/crypto/caam/regs.h   | 18 ++++++++++++++++--
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 066a4d4..7acaaa4 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -88,6 +88,14 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 
 	/* Set the bit to request direct access to DECO0 */
 	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
+
+	if (ctrlpriv->virt_en == 1)
+		setbits32(&topregs->ctrl.deco_rsr, DECORSR_JR0);
+
+	while (!(rd_reg32(&topregs->ctrl.deco_rsr) & DECORSR_VALID) &&
+	       --timeout)
+		cpu_relax();
+
 	setbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
 
 	while (!(rd_reg32(&topregs->ctrl.deco_rq) & DECORR_DEN0) &&
@@ -130,6 +138,9 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	*status = rd_reg32(&topregs->deco.op_status_hi) &
 		  DECO_OP_STATUS_HI_ERR_MASK;
 
+	if (ctrlpriv->virt_en == 1)
+		clrbits32(&topregs->ctrl.deco_rsr, DECORSR_JR0);
+
 	/* Mark the DECO as free */
 	clrbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
 
@@ -378,6 +389,7 @@ static int caam_probe(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
+	u32 scfgr, comp_params;
 	u32 cha_vid_ls;
 
 	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(struct caam_drv_private),
@@ -412,6 +424,33 @@ static int caam_probe(struct platform_device *pdev)
 	setbits32(&topregs->ctrl.mcr, MCFGR_WDENABLE |
 		  (sizeof(dma_addr_t) == sizeof(u64) ? MCFGR_LONG_PTR : 0));
 
+	/*
+	 *  Read the Compile Time paramters and SCFGR to determine
+	 * if Virtualization is enabled for this platform
+	 */
+	comp_params = rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms);
+	scfgr = rd_reg32(&topregs->ctrl.scfgr);
+
+	ctrlpriv->virt_en = 0;
+	if (comp_params & CTPR_MS_VIRT_EN_INCL) {
+		/* VIRT_EN_INCL = 1 & VIRT_EN_POR = 1 or
+		 * VIRT_EN_INCL = 1 & VIRT_EN_POR = 0 & SCFGR_VIRT_EN = 1
+		 */
+		if ((comp_params & CTPR_MS_VIRT_EN_POR) ||
+		    (!(comp_params & CTPR_MS_VIRT_EN_POR) &&
+		       (scfgr & SCFGR_VIRT_EN)))
+				ctrlpriv->virt_en = 1;
+	} else {
+		/* VIRT_EN_INCL = 0 && VIRT_EN_POR_VALUE = 1 */
+		if (comp_params & CTPR_MS_VIRT_EN_POR)
+				ctrlpriv->virt_en = 1;
+	}
+
+	if (ctrlpriv->virt_en == 1)
+		setbits32(&topregs->ctrl.jrstart, JRSTART_JR0_START |
+			  JRSTART_JR1_START | JRSTART_JR2_START |
+			  JRSTART_JR3_START);
+
 	if (sizeof(dma_addr_t) == sizeof(u64))
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
 			dma_set_mask(dev, DMA_BIT_MASK(40));
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 6d85fcc..97363db 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -82,6 +82,7 @@ struct caam_drv_private {
 	u8 total_jobrs;		/* Total Job Rings in device */
 	u8 qi_present;		/* Nonzero if QI present in device */
 	int secvio_irq;		/* Security violation interrupt number */
+	int virt_en;		/* Virtualization enabled in CAAM */
 
 #define	RNG4_MAX_HANDLES 2
 	/* RNG4 block */
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 7bb898d..69e3562 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -176,6 +176,8 @@ struct caam_perfmon {
 	u32 cha_rev_ls;		/* CRNR - CHA Rev No. Least significant half*/
 #define CTPR_MS_QI_SHIFT	25
 #define CTPR_MS_QI_MASK		(0x1ull << CTPR_MS_QI_SHIFT)
+#define CTPR_MS_VIRT_EN_INCL	0x00000001
+#define CTPR_MS_VIRT_EN_POR	0x00000002
 	u32 comp_parms_ms;	/* CTPR - Compile Parameters Register	*/
 	u32 comp_parms_ls;	/* CTPR - Compile Parameters Register	*/
 	u64 rsvd1[2];
@@ -309,9 +311,12 @@ struct caam_ctrl {
 	/* Bus Access Configuration Section			010-11f */
 	/* Read/Writable                                                */
 	struct masterid jr_mid[4];	/* JRxLIODNR - JobR LIODN setup */
-	u32 rsvd3[12];
+	u32 rsvd3[11];
+	u32 jrstart;			/* JRSTART - Job Ring Start Register */
 	struct masterid rtic_mid[4];	/* RTICxLIODNR - RTIC LIODN setup */
-	u32 rsvd4[7];
+	u32 rsvd4[5];
+	u32 deco_rsr;			/* DECORSR - Deco Request Source */
+	u32 rsvd11;
 	u32 deco_rq;			/* DECORR - DECO Request */
 	struct partid deco_mid[5];	/* DECOxLIODNR - 1 per DECO */
 	u32 rsvd5[22];
@@ -352,7 +357,10 @@ struct caam_ctrl {
 #define MCFGR_DMA_RESET		0x10000000
 #define MCFGR_LONG_PTR		0x00010000 /* Use >32-bit desc addressing */
 #define SCFGR_RDBENABLE		0x00000400
+#define SCFGR_VIRT_EN		0x00008000
 #define DECORR_RQD0ENABLE	0x00000001 /* Enable DECO0 for direct access */
+#define DECORSR_JR0		0x00000001 /* JR to supply TZ, SDID, ICID */
+#define DECORSR_VALID		0x80000000
 #define DECORR_DEN0		0x00010000 /* DECO0 available for access*/
 
 /* AXI read cache control */
@@ -370,6 +378,12 @@ struct caam_ctrl {
 #define MCFGR_AXIPRI		0x00000008 /* Assert AXI priority sideband */
 #define MCFGR_BURST_64		0x00000001 /* Max burst size */
 
+/* JRSTART register offsets */
+#define JRSTART_JR0_START       0x00000001 /* Start Job ring 0 */
+#define JRSTART_JR1_START       0x00000002 /* Start Job ring 1 */
+#define JRSTART_JR2_START       0x00000004 /* Start Job ring 2 */
+#define JRSTART_JR3_START       0x00000008 /* Start Job ring 3 */
+
 /*
  * caam_job_ring - direct job ring setup
  * 1-4 possible per instantiation, base + 1000/2000/3000/4000
-- 
1.8.1.4

