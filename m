Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbaFSJe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:34:58 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:32906
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757500AbaFSJe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:34:57 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 05:34:56 EDT
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
        <horia.geanta@freescale.com>, <grant.likely@linaro.org>,
        <NiteshNarayanLal@freescale.com>, <thierry.reding@gmail.com>,
        <rob.herring@calxeda.com>, <kim.phillips@freescale.com>,
        <dan.carpenter@oracle.com>,
        Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH][v3] crypto: caam - Correct definition of registers in memory map
Date: Thu, 19 Jun 2014 20:05:44 +0530
Message-ID: <1403188544-1088-1-git-send-email-ruchika.gupta@freescale.com>
X-Mailer: git-send-email 1.8.1.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(81342001)(36756003)(21056001)(33646001)(50466002)(105606002)(93916002)(95666004)(83322001)(44976005)(19580405001)(79102001)(19580395003)(50226001)(4396001)(104016002)(74502001)(104166001)(86362001)(74662001)(46102001)(97736001)(80022001)(85306003)(6806004)(92566001)(26826002)(87286001)(102836001)(77982001)(87936001)(88136002)(84676001)(64706001)(92726001)(47776003)(20776003)(76482001)(68736004)(2201001)(62966002)(77156001)(81542001)(50986999)(89996001)(85852003)(99396002)(48376002)(83072002)(31966008);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB326;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02475B2A01
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=ruchika.gupta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some registers like SECVID, CHAVID, CHA Revision Number,
CTPR were defined as 64 bit resgisters.  The IP provides
a DWT bit(Double word Transpose) to transpose the two words when
a double word register is accessed. However setting this bit
would also affect the operation of job descriptors as well as
other registers which are truly double word in nature.
So, for the IP to work correctly on big-endian as well as
little-endian SoC's, change is required to access all 32 bit
registers as 32 bit quantities.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 14 +++++----
 drivers/crypto/caam/regs.h | 71 +++++++++++++++++++++++++---------------------
 2 files changed, 46 insertions(+), 39 deletions(-)
Changes in v3
Fixed caam_id to print complete 64 bit register

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1c38f86..3600c40 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -380,7 +380,7 @@ static int caam_probe(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
-	u64 cha_vid;
+	u32 cha_vid_ls;
 
 	ctrlpriv = kzalloc(sizeof(struct caam_drv_private), GFP_KERNEL);
 	if (!ctrlpriv)
@@ -456,8 +456,9 @@ static int caam_probe(struct platform_device *pdev)
 		}
 
 	/* Check to see if QI present. If so, enable */
-	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
-				  CTPR_QI_MASK);
+	ctrlpriv->qi_present =
+			!!(rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms) &
+			   CTPR_MS_QI_MASK);
 	if (ctrlpriv->qi_present) {
 		ctrlpriv->qi = (struct caam_queue_if __force *)&topregs->qi;
 		/* This is all that's required to physically enable QI */
@@ -471,13 +472,13 @@ static int caam_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	cha_vid = rd_reg64(&topregs->ctrl.perfmon.cha_id);
+	cha_vid_ls = rd_reg32(&topregs->ctrl.perfmon.cha_id_ls);
 
 	/*
 	 * If SEC has RNG version >= 4 and RNG state handle has not been
 	 * already instantiated, do RNG instantiation
 	 */
-	if ((cha_vid & CHA_ID_RNG_MASK) >> CHA_ID_RNG_SHIFT >= 4) {
+	if ((cha_vid_ls & CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT >= 4) {
 		ctrlpriv->rng4_sh_init =
 			rd_reg32(&topregs->ctrl.r4tst[0].rdsta);
 		/*
@@ -531,7 +532,8 @@ static int caam_probe(struct platform_device *pdev)
 
 	/* NOTE: RTIC detection ought to go here, around Si time */
 
-	caam_id = rd_reg64(&topregs->ctrl.perfmon.caam_id);
+	caam_id = (u64)rd_reg32(&topregs->ctrl.perfmon.caam_id_ms) << 32 |
+		  (u64)rd_reg32(&topregs->ctrl.perfmon.caam_id_ls);
 
 	/* Report "alive" for developer to see */
 	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index cbde8b9..7bb898d 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -114,45 +114,45 @@ struct jr_outentry {
  */
 
 /* Number of DECOs */
-#define CHA_NUM_DECONUM_SHIFT	56
-#define CHA_NUM_DECONUM_MASK	(0xfull << CHA_NUM_DECONUM_SHIFT)
+#define CHA_NUM_MS_DECONUM_SHIFT	24
+#define CHA_NUM_MS_DECONUM_MASK	(0xfull << CHA_NUM_MS_DECONUM_SHIFT)
 
 /* CHA Version IDs */
-#define CHA_ID_AES_SHIFT	0
-#define CHA_ID_AES_MASK		(0xfull << CHA_ID_AES_SHIFT)
+#define CHA_ID_LS_AES_SHIFT	0
+#define CHA_ID_LS_AES_MASK		(0xfull << CHA_ID_LS_AES_SHIFT)
 
-#define CHA_ID_DES_SHIFT	4
-#define CHA_ID_DES_MASK		(0xfull << CHA_ID_DES_SHIFT)
+#define CHA_ID_LS_DES_SHIFT	4
+#define CHA_ID_LS_DES_MASK		(0xfull << CHA_ID_LS_DES_SHIFT)
 
-#define CHA_ID_ARC4_SHIFT	8
-#define CHA_ID_ARC4_MASK	(0xfull << CHA_ID_ARC4_SHIFT)
+#define CHA_ID_LS_ARC4_SHIFT	8
+#define CHA_ID_LS_ARC4_MASK	(0xfull << CHA_ID_LS_ARC4_SHIFT)
 
-#define CHA_ID_MD_SHIFT		12
-#define CHA_ID_MD_MASK		(0xfull << CHA_ID_MD_SHIFT)
+#define CHA_ID_LS_MD_SHIFT	12
+#define CHA_ID_LS_MD_MASK	(0xfull << CHA_ID_LS_MD_SHIFT)
 
-#define CHA_ID_RNG_SHIFT	16
-#define CHA_ID_RNG_MASK		(0xfull << CHA_ID_RNG_SHIFT)
+#define CHA_ID_LS_RNG_SHIFT	16
+#define CHA_ID_LS_RNG_MASK	(0xfull << CHA_ID_LS_RNG_SHIFT)
 
-#define CHA_ID_SNW8_SHIFT	20
-#define CHA_ID_SNW8_MASK	(0xfull << CHA_ID_SNW8_SHIFT)
+#define CHA_ID_LS_SNW8_SHIFT	20
+#define CHA_ID_LS_SNW8_MASK	(0xfull << CHA_ID_LS_SNW8_SHIFT)
 
-#define CHA_ID_KAS_SHIFT	24
-#define CHA_ID_KAS_MASK		(0xfull << CHA_ID_KAS_SHIFT)
+#define CHA_ID_LS_KAS_SHIFT	24
+#define CHA_ID_LS_KAS_MASK	(0xfull << CHA_ID_LS_KAS_SHIFT)
 
-#define CHA_ID_PK_SHIFT		28
-#define CHA_ID_PK_MASK		(0xfull << CHA_ID_PK_SHIFT)
+#define CHA_ID_LS_PK_SHIFT	28
+#define CHA_ID_LS_PK_MASK	(0xfull << CHA_ID_LS_PK_SHIFT)
 
-#define CHA_ID_CRC_SHIFT	32
-#define CHA_ID_CRC_MASK		(0xfull << CHA_ID_CRC_SHIFT)
+#define CHA_ID_MS_CRC_SHIFT	0
+#define CHA_ID_MS_CRC_MASK	(0xfull << CHA_ID_MS_CRC_SHIFT)
 
-#define CHA_ID_SNW9_SHIFT	36
-#define CHA_ID_SNW9_MASK	(0xfull << CHA_ID_SNW9_SHIFT)
+#define CHA_ID_MS_SNW9_SHIFT	4
+#define CHA_ID_MS_SNW9_MASK	(0xfull << CHA_ID_MS_SNW9_SHIFT)
 
-#define CHA_ID_DECO_SHIFT	56
-#define CHA_ID_DECO_MASK	(0xfull << CHA_ID_DECO_SHIFT)
+#define CHA_ID_MS_DECO_SHIFT	24
+#define CHA_ID_MS_DECO_MASK	(0xfull << CHA_ID_MS_DECO_SHIFT)
 
-#define CHA_ID_JR_SHIFT		60
-#define CHA_ID_JR_MASK		(0xfull << CHA_ID_JR_SHIFT)
+#define CHA_ID_MS_JR_SHIFT	28
+#define CHA_ID_MS_JR_MASK	(0xfull << CHA_ID_MS_JR_SHIFT)
 
 struct sec_vid {
 	u16 ip_id;
@@ -172,10 +172,12 @@ struct caam_perfmon {
 	u64 rsvd[13];
 
 	/* CAAM Hardware Instantiation Parameters		fa0-fbf */
-	u64 cha_rev;		/* CRNR - CHA Revision Number		*/
-#define CTPR_QI_SHIFT		57
-#define CTPR_QI_MASK		(0x1ull << CTPR_QI_SHIFT)
-	u64 comp_parms;	/* CTPR - Compile Parameters Register	*/
+	u32 cha_rev_ms;		/* CRNR - CHA Rev No. Most significant half*/
+	u32 cha_rev_ls;		/* CRNR - CHA Rev No. Least significant half*/
+#define CTPR_MS_QI_SHIFT	25
+#define CTPR_MS_QI_MASK		(0x1ull << CTPR_MS_QI_SHIFT)
+	u32 comp_parms_ms;	/* CTPR - Compile Parameters Register	*/
+	u32 comp_parms_ls;	/* CTPR - Compile Parameters Register	*/
 	u64 rsvd1[2];
 
 	/* CAAM Global Status					fc0-fdf */
@@ -189,9 +191,12 @@ struct caam_perfmon {
 	/* Component Instantiation Parameters			fe0-fff */
 	u32 rtic_id;		/* RVID - RTIC Version ID	*/
 	u32 ccb_id;		/* CCBVID - CCB Version ID	*/
-	u64 cha_id;		/* CHAVID - CHA Version ID	*/
-	u64 cha_num;		/* CHANUM - CHA Number		*/
-	u64 caam_id;		/* CAAMVID - CAAM Version ID	*/
+	u32 cha_id_ms;		/* CHAVID - CHA Version ID Most Significant*/
+	u32 cha_id_ls;		/* CHAVID - CHA Version ID Least Significant*/
+	u32 cha_num_ms;		/* CHANUM - CHA Number Most Significant	*/
+	u32 cha_num_ls;		/* CHANUM - CHA Number Least Significant*/
+	u32 caam_id_ms;		/* CAAMVID - CAAM Version ID MS	*/
+	u32 caam_id_ls;		/* CAAMVID - CAAM Version ID LS	*/
 };
 
 /* LIODN programming for DMA configuration */
-- 
1.8.1.4

