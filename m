Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaIWTVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:21:11 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:34094 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaIWTVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:21:09 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: khilman@linaro.org, arm@kernel.org
Cc: agross@codeaurora.org, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2] soc: qcom: do not disable the iface clock in probe
Date: Tue, 23 Sep 2014 20:20:54 +0100
Message-Id: <1411500054-13600-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since commit 31964ffebbb9 ("tty: serial: msm: Remove direct access to GSBI")'
serial hangs if earlyprintk are enabled.

This hang is noticed only when the GSBI driver is probed and all the
earlyprintks before gsbi probe are seen on the console.
The reason why it hangs is because GSBI driver disables hclk in its
probe function without realizing that the serial IP might be in use by
a bootconsole. As gsbi driver disables the clock in probe the
bootconsole locks up.

Turning off hclk's could be dangerous if there are system components
like earlyprintk using the hclk.

This patch fixes the issue by delegating the clock management to
probe and remove functions in gsbi rather than disabling the clock in probe.

More detailed problem description can be found here:
http://www.spinics.net/lists/linux-arm-msm/msg10589.html

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Hi Kevin, 

Am resending this patch with reference to the problem and adding more
details to the log.

Could you pick this fix for the next rc, as this fixes a serial console
hang with earlyprintk on SOCs like APQ8064.

Changes since v1:
	- added more info in the change log as requested by Kumar and Kevin.

thanks,
srini

 drivers/soc/qcom/qcom_gsbi.c | 46 +++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
index 447458e..7e1f120 100644
--- a/drivers/soc/qcom/qcom_gsbi.c
+++ b/drivers/soc/qcom/qcom_gsbi.c
@@ -22,44 +22,63 @@
 #define GSBI_CTRL_REG		0x0000
 #define GSBI_PROTOCOL_SHIFT	4
 
+struct gsbi_info {
+	struct clk *hclk;
+	u32 mode;
+	u32 crci;
+};
+
 static int gsbi_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct resource *res;
 	void __iomem *base;
-	struct clk *hclk;
-	u32 mode, crci = 0;
+	struct gsbi_info *gsbi;
+
+	gsbi = devm_kzalloc(&pdev->dev, sizeof(*gsbi), GFP_KERNEL);
+
+	if (!gsbi)
+		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	if (of_property_read_u32(node, "qcom,mode", &mode)) {
+	if (of_property_read_u32(node, "qcom,mode", &gsbi->mode)) {
 		dev_err(&pdev->dev, "missing mode configuration\n");
 		return -EINVAL;
 	}
 
 	/* not required, so default to 0 if not present */
-	of_property_read_u32(node, "qcom,crci", &crci);
+	of_property_read_u32(node, "qcom,crci", &gsbi->crci);
 
-	dev_info(&pdev->dev, "GSBI port protocol: %d crci: %d\n", mode, crci);
+	dev_info(&pdev->dev, "GSBI port protocol: %d crci: %d\n",
+		 gsbi->mode, gsbi->crci);
+	gsbi->hclk = devm_clk_get(&pdev->dev, "iface");
+	if (IS_ERR(gsbi->hclk))
+		return PTR_ERR(gsbi->hclk);
 
-	hclk = devm_clk_get(&pdev->dev, "iface");
-	if (IS_ERR(hclk))
-		return PTR_ERR(hclk);
+	clk_prepare_enable(gsbi->hclk);
 
-	clk_prepare_enable(hclk);
-
-	writel_relaxed((mode << GSBI_PROTOCOL_SHIFT) | crci,
+	writel_relaxed((gsbi->mode << GSBI_PROTOCOL_SHIFT) | gsbi->crci,
 				base + GSBI_CTRL_REG);
 
 	/* make sure the gsbi control write is not reordered */
 	wmb();
 
-	clk_disable_unprepare(hclk);
+	platform_set_drvdata(pdev, gsbi);
+
+	return of_platform_populate(node, NULL, NULL, &pdev->dev);
+}
+
+static int gsbi_remove(struct platform_device *pdev)
+{
+	struct gsbi_info *gsbi = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(gsbi->hclk);
 
-	return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+	return 0;
 }
 
 static const struct of_device_id gsbi_dt_match[] = {
@@ -76,6 +95,7 @@ static struct platform_driver gsbi_driver = {
 		.of_match_table	= gsbi_dt_match,
 	},
 	.probe = gsbi_probe,
+	.remove	= gsbi_remove,
 };
 
 module_platform_driver(gsbi_driver);
-- 
1.9.1

