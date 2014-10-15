Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaJOFWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:22:50 -0400
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:39719
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbaJOFWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:22:30 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 3/3] pwm: ftm: add Power Management support for FTM pwm.
Date: Wed, 15 Oct 2014 13:21:35 +0800
Message-ID: <1413350495-40980-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
References: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(47776003)(20776003)(84676001)(97736003)(64706001)(62966002)(80022003)(50986999)(76176999)(26826002)(87286001)(46102003)(21056001)(102836001)(68736004)(89996001)(69596002)(88136002)(87936001)(31966008)(92726001)(48376002)(86362001)(44976005)(6806004)(85306004)(19580395003)(19580405001)(85852003)(93916002)(36756003)(120916001)(50466002)(99396003)(104166001)(92566001)(105606002)(77156001)(106466001)(81156004)(76482002)(95666004)(229853001)(104016003)(4396001)(50226001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 0365C0E14B
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PM support for FTM pwm driver using callback function suspend
and resume in .driver.pm of platform_driver.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/pwm/pwm-fsl-ftm.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 9bfbea5..666e1be 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -17,6 +17,7 @@
 #include <linux/mutex.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/pwm.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
@@ -436,7 +437,7 @@ static int fsl_pwm_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	fpc->regmap = devm_regmap_init_mmio_clk(&pdev->dev, NULL, base,
+	fpc->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "ftm_sys", base,
 						&fsl_pwm_regmap_config);
 	if (IS_ERR(fpc->regmap)) {
 		dev_err(&pdev->dev, "regmap init failed\n");
@@ -487,6 +488,51 @@ static int fsl_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&fpc->chip);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int fsl_pwm_suspend(struct device *dev)
+{
+	struct fsl_pwm_chip *fpc = dev_get_drvdata(dev);
+	u32 val;
+
+	regcache_cache_only(fpc->regmap, true);
+	regcache_mark_dirty(fpc->regmap);
+
+	/* read from cache */
+	regmap_read(fpc->regmap, FTM_OUTMASK, &val);
+	if ((val & 0xFF) != 0xFF) {
+		clk_disable_unprepare(fpc->clk[FSL_PWM_CLK_CNTEN]);
+		clk_disable_unprepare(fpc->clk[fpc->cnt_select]);
+		clk_disable_unprepare(fpc->clk[FSL_PWM_CLK_SYS]);
+	}
+
+	return 0;
+}
+
+static int fsl_pwm_resume(struct device *dev)
+{
+	struct fsl_pwm_chip *fpc = dev_get_drvdata(dev);
+	u32 val;
+
+	/* read from cache */
+	regmap_read(fpc->regmap, FTM_OUTMASK, &val);
+	if ((val & 0xFF) != 0xFF) {
+		clk_prepare_enable(fpc->clk[FSL_PWM_CLK_SYS]);
+		clk_prepare_enable(fpc->clk[fpc->cnt_select]);
+		clk_prepare_enable(fpc->clk[FSL_PWM_CLK_CNTEN]);
+	}
+
+	/* restore all registers from cache */
+	regcache_cache_only(fpc->regmap, false);
+	regcache_sync(fpc->regmap);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops fsl_pwm_pm_ops = {
+		SET_SYSTEM_SLEEP_PM_OPS(fsl_pwm_suspend, fsl_pwm_resume)
+};
+
 static const struct of_device_id fsl_pwm_dt_ids[] = {
 	{ .compatible = "fsl,vf610-ftm-pwm", },
 	{ /* sentinel */ }
@@ -497,6 +543,7 @@ static struct platform_driver fsl_pwm_driver = {
 	.driver = {
 		.name = "fsl-ftm-pwm",
 		.of_match_table = fsl_pwm_dt_ids,
+		.pm = &fsl_pwm_pm_ops,
 	},
 	.probe = fsl_pwm_probe,
 	.remove = fsl_pwm_remove,
-- 
2.1.0.27.g96db324

