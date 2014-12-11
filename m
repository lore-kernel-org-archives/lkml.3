Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbaLKBa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:30:28 -0500
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:20448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758449AbaLKBaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:30:24 -0500
From: Scott Wood <scottwood@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Scott Wood <scottwood@freescale.com>
Subject: [PATCH] memory/fsl-corenet-cf: Add t1040 support
Date: Wed, 10 Dec 2014 18:56:22 -0600
Message-ID: <1418259382-21697-1-git-send-email-scottwood@freescale.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BN1PR08CA0042.namprd08.prod.outlook.com (10.242.217.170) To
 BY2PR0301MB0725.namprd03.prod.outlook.com (25.160.63.155)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0725;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0725;
X-Forefront-PRVS: 0422860ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(21056001)(107046002)(50226001)(87976001)(50466002)(106356001)(110136001)(77156002)(48376002)(62966003)(2351001)(229853001)(46102003)(4396001)(33646002)(68736005)(101416001)(19580395003)(230783001)(86362001)(50986999)(19580405001)(42186005)(40100003)(66066001)(64706001)(122386002)(47776003)(20776003)(99396003)(97736003)(120916001)(89996001)(31966008)(36756003)(105586002)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0725;H:snotra.am.freescale.net;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0725;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

T1040 has a different version of corenet-cf, despite being incorrectly
labelled with a fsl,corenet2-cf compatible.  The t1040 version of
corenet-cf has a version register that can be read to distinguish.  The
t4240/b4860 version officially does not, but testing shows that it does
and has a different value, so use that.  If somehow this ends up not
being reliable and we treat a t4240/b4860 as a t1040 (the reverse
should not happen, as t1040's version register is official), currently
the worst that should happen is writing to reserved bits to enable
events that don't exist.

The changes to the t1040 version of corenet-cf that this driver cares
about are the addition of two new error events.  There are also changes
to the format of cecar2, which is printed, but not interpreted, by this
driver.

Signed-off-by: Scott Wood <scottwood@freescale.com>
---
 drivers/memory/fsl-corenet-cf.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/fsl-corenet-cf.c b/drivers/memory/fsl-corenet-cf.c
index c9443fc..94c952e 100644
--- a/drivers/memory/fsl-corenet-cf.c
+++ b/drivers/memory/fsl-corenet-cf.c
@@ -27,18 +27,29 @@ enum ccf_version {
 struct ccf_info {
 	enum ccf_version version;
 	int err_reg_offs;
+	bool has_brr;
 };
 
 static const struct ccf_info ccf1_info = {
 	.version = CCF1,
 	.err_reg_offs = 0xa00,
+	.has_brr = false,
 };
 
 static const struct ccf_info ccf2_info = {
 	.version = CCF2,
 	.err_reg_offs = 0xe40,
+	.has_brr = true,
 };
 
+/*
+ * This register is present but not documented, with different values for
+ * IP_ID, on other chips with fsl,corenet2-cf such as t4240 and b4860.
+ */
+#define CCF_BRR			0xbf8
+#define CCF_BRR_IPID		0xffff0000
+#define CCF_BRR_IPID_T1040	0x09310000
+
 static const struct of_device_id ccf_matches[] = {
 	{
 		.compatible = "fsl,corenet1-cf",
@@ -66,6 +77,8 @@ struct ccf_err_regs {
 /* LAE/CV also valid for errdis and errinten */
 #define ERRDET_LAE		(1 << 0)  /* Local Access Error */
 #define ERRDET_CV		(1 << 1)  /* Coherency Violation */
+#define ERRDET_UTID		(1 << 2)  /* Unavailable Target ID (t1040) */
+#define ERRDET_MCST		(1 << 3)  /* Multicast Stash (t1040) */
 #define ERRDET_CTYPE_SHIFT	26	  /* Capture Type (ccf2 only) */
 #define ERRDET_CTYPE_MASK	(0x1f << ERRDET_CTYPE_SHIFT)
 #define ERRDET_CAP		(1 << 31) /* Capture Valid (ccf2 only) */
@@ -84,6 +97,7 @@ struct ccf_private {
 	struct device *dev;
 	void __iomem *regs;
 	struct ccf_err_regs __iomem *err_regs;
+	bool t1040;
 };
 
 static irqreturn_t ccf_irq(int irq, void *dev_id)
@@ -142,6 +156,12 @@ static irqreturn_t ccf_irq(int irq, void *dev_id)
 	if (errdet & ERRDET_CV)
 		dev_crit(ccf->dev, "Coherency Violation\n");
 
+	if (errdet & ERRDET_UTID)
+		dev_crit(ccf->dev, "Unavailable Target ID\n");
+
+	if (errdet & ERRDET_MCST)
+		dev_crit(ccf->dev, "Multicast Stash\n");
+
 	if (cap_valid) {
 		dev_crit(ccf->dev, "address 0x%09llx, src id 0x%x\n",
 			 addr, src_id);
@@ -157,6 +177,7 @@ static int ccf_probe(struct platform_device *pdev)
 	struct ccf_private *ccf;
 	struct resource *r;
 	const struct of_device_id *match;
+	u32 errinten;
 	int ret, irq;
 
 	match = of_match_device(ccf_matches, &pdev->dev);
@@ -183,6 +204,13 @@ static int ccf_probe(struct platform_device *pdev)
 	ccf->info = match->data;
 	ccf->err_regs = ccf->regs + ccf->info->err_reg_offs;
 
+	if (ccf->info->has_brr) {
+		u32 brr = ioread32be(ccf->regs + CCF_BRR);
+
+		if ((brr & CCF_BRR_IPID) == CCF_BRR_IPID_T1040)
+			ccf->t1040 = true;
+	}
+
 	dev_set_drvdata(&pdev->dev, ccf);
 
 	irq = platform_get_irq(pdev, 0);
@@ -197,15 +225,19 @@ static int ccf_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	errinten = ERRDET_LAE | ERRDET_CV;
+	if (ccf->t1040)
+		errinten |= ERRDET_UTID | ERRDET_MCST;
+
 	switch (ccf->info->version) {
 	case CCF1:
 		/* On CCF1 this register enables rather than disables. */
-		iowrite32be(ERRDET_LAE | ERRDET_CV, &ccf->err_regs->errdis);
+		iowrite32be(errinten, &ccf->err_regs->errdis);
 		break;
 
 	case CCF2:
 		iowrite32be(0, &ccf->err_regs->errdis);
-		iowrite32be(ERRDET_LAE | ERRDET_CV, &ccf->err_regs->errinten);
+		iowrite32be(errinten, &ccf->err_regs->errinten);
 		break;
 	}
 
-- 
2.1.0

