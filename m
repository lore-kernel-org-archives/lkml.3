Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaDNIMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:12:02 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49818 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaDNIJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:09:29 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-c1-534b97b4ae7f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/4] regulator: s2mps11: Move DTS parsing code to separate
 function
Date: Mon, 14 Apr 2014 10:09:06 +0200
Message-id: <1397462949-22379-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7pbpnsHG9z8KWaxccZ6VoupD5+w
	Wcw/co7Vov/NQlaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y26x
	9PpFJosJ09eyWLTuPcJucbqb1eLiii9MFutnvGZxEPJYM28No8flvl4mj52z7rJ7rFz+hc1j
	06pONo871/awecw7GejRt2UVo8fnTXIBnFFcNimpOZllqUX6dglcGWtmyBdsFKn4/H41UwPj
	K4EuRk4OCQETiY65a1ggbDGJC/fWs3UxcnEICSxllDh7bR8zhNPHJNE5bRMjSBWbgLHE5uVL
	wKpEBG4wS0xctosJJMEs8JxR4un3cBBbWCBUom3tB7A4i4CqxL4LN9lBbF4Bd4knvxezQ6xT
	kFj2ZS3QBg4OTgEPiTc32UDCQkAlX3/PYprAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5y
	fu4mRkiQf9nBuPiY1SFGAQ5GJR7ehO2ewUKsiWXFlbmHGCU4mJVEeLdleAUL8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYNx479b2rHzViczMP9bel3k7d6mp3tKAsKPXpjCsSJ1TF+CfwudxRPrh
	y4vKz01O1tz79L3t1BXry6yc0/y0YktVLsf08bBcS/FkuTp9Q+CE61O2T2ScNimAt8VkGkPW
	LjHNxqNP3Lt57Zpj/newFs7Z7zbLUeDrNb9XWq5ZS2b9fP/rf/+dPaVKLMUZiYZazEXFiQCn
	ytnjUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor code for parsing DTS to increase a little code readability. The
behaviour should not change.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index e713c162fbd4..3aba0331fb5d 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -565,12 +565,28 @@ static const struct regulator_desc s2mps14_regulators[] = {
 	regulator_desc_s2mps14_buck1235(5),
 };
 
+static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
+		struct of_regulator_match *rdata, struct s2mps11_info *s2mps11)
+{
+	struct device_node *reg_np;
+
+	reg_np = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
+	if (!reg_np) {
+		dev_err(&pdev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
+	of_node_put(reg_np);
+
+	return 0;
+}
+
 static int s2mps11_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct sec_platform_data *pdata = iodev->pdata;
+	struct sec_platform_data *pdata = NULL;
 	struct of_regulator_match *rdata = NULL;
-	struct device_node *reg_np = NULL;
 	struct regulator_config config = { };
 	struct s2mps11_info *s2mps11;
 	int i, ret = 0;
@@ -598,7 +614,8 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	};
 
 	if (!iodev->dev->of_node) {
-		if (pdata) {
+		if (iodev->pdata) {
+			pdata = iodev->pdata;
 			goto common_reg;
 		} else {
 			dev_err(pdev->dev.parent,
@@ -614,15 +631,9 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < s2mps11->rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
-	reg_np = of_get_child_by_name(iodev->dev->of_node, "regulators");
-	if (!reg_np) {
-		dev_err(&pdev->dev, "could not find regulators sub-node\n");
-		ret = -EINVAL;
+	ret = s2mps11_pmic_dt_parse(pdev, rdata, s2mps11);
+	if (ret)
 		goto out;
-	}
-
-	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
-	of_node_put(reg_np);
 
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
@@ -633,7 +644,7 @@ common_reg:
 	for (i = 0; i < s2mps11->rdev_num; i++) {
 		struct regulator_dev *regulator;
 
-		if (!reg_np) {
+		if (pdata) {
 			config.init_data = pdata->regulators[i].initdata;
 			config.of_node = pdata->regulators[i].reg_node;
 		} else {
-- 
1.8.3.2

