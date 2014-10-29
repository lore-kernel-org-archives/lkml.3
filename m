Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaJ2DzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:55:22 -0400
Received: from mail-bn1bon0142.outbound.protection.outlook.com ([157.56.111.142]:33152
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751664AbaJ2DzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:55:20 -0400
From: Alison Wang <b18965@freescale.com>
To: <perex@perex.cz>, <tiwai@suse.de>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] audio: sai: Add Power Management support
Date: Wed, 29 Oct 2014 11:21:36 +0800
Message-ID: <1414552896-20797-1-git-send-email-b18965@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(88136002)(2201001)(92566001)(87936001)(84676001)(92726001)(21056001)(93916002)(87286001)(104016003)(97736003)(33646002)(19580395003)(68736004)(19580405001)(4396001)(89996001)(6806004)(85852003)(85306004)(44976005)(50226001)(31966008)(50466002)(48376002)(50986999)(46102003)(26826002)(62966002)(80022003)(102836001)(99396003)(76482002)(104166001)(120916001)(47776003)(106466001)(20776003)(36756003)(95666004)(229853001)(77156001)(64706001)(107046002)(105606002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0631;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=alison.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Power Management support for SAI.
Activate regmap cache with REGCACHE_RBTREE, and use
regmap cache code to save and restore registers in
suspend and resume. The Transmit Control Register
(TCSR) and Receive Control Register(RCSR) should
be volatile registers.

Signed-off-by: Alison Wang <alison.wang@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 7eeb1dd..c7dd953 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -509,9 +509,11 @@ static bool fsl_sai_readable_reg(struct device *dev, unsigned int reg)
 static bool fsl_sai_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case FSL_SAI_TCSR:
 	case FSL_SAI_TFR:
-	case FSL_SAI_RFR:
 	case FSL_SAI_TDR:
+	case FSL_SAI_RCSR:
+	case FSL_SAI_RFR:
 	case FSL_SAI_RDR:
 		return true;
 	default:
@@ -553,6 +555,7 @@ static const struct regmap_config fsl_sai_regmap_config = {
 	.readable_reg = fsl_sai_readable_reg,
 	.volatile_reg = fsl_sai_volatile_reg,
 	.writeable_reg = fsl_sai_writeable_reg,
+	.cache_type = REGCACHE_RBTREE,
 };
 
 static int fsl_sai_probe(struct platform_device *pdev)
@@ -668,6 +671,33 @@ static int fsl_sai_probe(struct platform_device *pdev)
 				SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int fsl_sai_suspend(struct device *dev)
+{
+	struct fsl_sai *sai = dev_get_drvdata(dev);
+
+	regcache_cache_only(sai->regmap, true);
+	regcache_mark_dirty(sai->regmap);
+
+	return 0;
+}
+
+static int fsl_sai_resume(struct device *dev)
+{
+	struct fsl_sai *sai = dev_get_drvdata(dev);
+
+	/* Restore all registers */
+	regcache_cache_only(sai->regmap, false);
+	regcache_sync(sai->regmap);
+
+	return 0;
+};
+#endif /* CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops fsl_sai_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(fsl_sai_suspend, fsl_sai_resume)
+};
+
 static const struct of_device_id fsl_sai_ids[] = {
 	{ .compatible = "fsl,vf610-sai", },
 	{ .compatible = "fsl,imx6sx-sai", },
@@ -680,6 +710,7 @@ static struct platform_driver fsl_sai_driver = {
 		.name = "fsl-sai",
 		.owner = THIS_MODULE,
 		.of_match_table = fsl_sai_ids,
+		.pm = &fsl_sai_pm,
 	},
 };
 module_platform_driver(fsl_sai_driver);
-- 
2.1.0.27.g96db324

