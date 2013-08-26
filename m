Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3HZLlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:41:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19960 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab3HZLjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:39:12 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-6e-521b3e5449ef
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, t.figa@samsung.com, tomasz.figa@gmail.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH RFC 1/5] media: s5p-tv: Fix sdo driver to work with CCF
Date: Mon, 26 Aug 2013 13:38:30 +0200
Message-id: <1377517114-20222-2-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoG6onXSQwbF2dov5R86xWrzp7WCx
	6F1wlc3ibNMbdotNj6+xWixsW8JicXnXHDaLGef3MVncvsxrcXGdvMXpNaeYLV73HWaxWHr9
	IpPF0wkX2SwmTF/LYnF4xQEmi3UvpwNZb9pZLV4dbGOxWD/jNYvFvPaXrBbHZixhtFi16w+j
	g7jHmnlrGD1amnvYPBZ8vsLu8XryBEaPnbPusnu8Wj2T1ePOtT1sHpuX1HscfLeHyaNvyypG
	j+5Pt1g9Pm+S89g4NzSAN4rLJiU1J7MstUjfLoEr4+7/RtaCRsWKW1OPsTcwLpTuYuTkkBAw
	kWg/dIYFwhaTuHBvPVsXIxeHkMB0Rom1i+YzQjjtTBJfPmxlBqliEzCXmPhsE1iHiICkRFPD
	H2aQImaBGywSC47+ZQRJCAu4S6yef5IVxGYRUJWYtfQpE4jNK+An8e/yX2aIdQoSPy+fYAOx
	OQX8Jfa09LGD2EJANeeWf2OZwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwBD2T
	2sG4ssHiEKMAB6MSD29ggVSQEGtiWXFl7iFGCQ5mJRFec1HpICHelMTKqtSi/Pii0pzU4kOM
	0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2Mu9salp0RFwuImdRS0euum58uzvs0YtZt
	mcC7h934elftWpKU0CDktj7Ypuvs1L3sZkE7P4bdfC+bdvv7yUehR/c5eGgZl10unp4X9nyy
	qv9J0bcfq00Euh83yb474HN9XvaF2x0X+y72FS5a9LztLU/nPLc8j5jF06/9ObRIfZv2hqXP
	t7eFKrEUZyQaajEXFScCAKn1jjScAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
Without it Common Clock Framework prints a warning.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 44 +++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 0afa90f..77eac6d 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -55,6 +55,8 @@ struct sdo_device {
 	struct clk *dacphy;
 	/** clock for control of VPLL */
 	struct clk *fout_vpll;
+	/** vpll rate before sdo stream was on */
+	int vpll_rate;
 	/** regulator for SDO IP power */
 	struct regulator *vdac;
 	/** regulator for SDO plug detection */
@@ -193,17 +195,34 @@ static int sdo_s_power(struct v4l2_subdev *sd, int on)
 
 static int sdo_streamon(struct sdo_device *sdev)
 {
+	int ret = 0;
+
 	/* set proper clock for Timing Generator */
-	clk_set_rate(sdev->fout_vpll, 54000000);
+	sdev->vpll_rate = clk_get_rate(sdev->fout_vpll);
+	ret = clk_set_rate(sdev->fout_vpll, 54000000);
+	if (ret < 0) {
+		dev_err(sdev->dev,
+			"%s: Failed to set vpll rate!\n", __func__);
+		return ret;
+	}
 	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
 	clk_get_rate(sdev->fout_vpll));
 	/* enable clock in SDO */
 	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
-	clk_enable(sdev->dacphy);
+	ret = clk_prepare_enable(sdev->dacphy);
+	if (ret < 0) {
+		dev_err(sdev->dev,
+			"%s: Failed to prepare and enable clock !\n", __func__);
+		goto fail;
+	}
 	/* enable DAC */
 	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
 	sdo_reg_debug(sdev);
 	return 0;
+fail:
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
+	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
+	return ret;
 }
 
 static int sdo_streamoff(struct sdo_device *sdev)
@@ -211,7 +230,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	int tries;
 
 	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
-	clk_disable(sdev->dacphy);
+	clk_disable_unprepare(sdev->dacphy);
 	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
 	for (tries = 100; tries; --tries) {
 		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
@@ -220,6 +239,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	}
 	if (tries == 0)
 		dev_err(sdev->dev, "failed to stop streaming\n");
+	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
 	return tries ? 0 : -EIO;
 }
 
@@ -254,7 +274,7 @@ static int sdo_runtime_suspend(struct device *dev)
 	dev_info(dev, "suspend\n");
 	regulator_disable(sdev->vdet);
 	regulator_disable(sdev->vdac);
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return 0;
 }
 
@@ -266,7 +286,7 @@ static int sdo_runtime_resume(struct device *dev)
 
 	dev_info(dev, "resume\n");
 
-	ret = clk_enable(sdev->sclk_dac);
+	ret = clk_prepare_enable(sdev->sclk_dac);
 	if (ret < 0)
 		return ret;
 
@@ -299,7 +319,7 @@ static int sdo_runtime_resume(struct device *dev)
 vdac_r_dis:
 	regulator_disable(sdev->vdac);
 dac_clk_dis:
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return ret;
 }
 
@@ -403,10 +423,14 @@ static int sdo_probe(struct platform_device *pdev)
 		ret = PTR_ERR(sdev->vdet);
 		goto fail_fout_vpll;
 	}
-
 	/* enable gate for dac clock, because mixer uses it */
-	clk_enable(sdev->dac);
-
+	clk_prepare_enable(sdev->dac);
+	if (IS_ERR(sdev->dac)) {
+		dev_err(dev,
+			"%s: Failed to prepare and enable clock !\n", __func__);
+		ret = PTR_ERR(sdev->dac);
+		goto fail_fout_vpll;
+	}
 	/* configure power management */
 	pm_runtime_enable(dev);
 
@@ -444,7 +468,7 @@ static int sdo_remove(struct platform_device *pdev)
 	struct sdo_device *sdev = sd_to_sdev(sd);
 
 	pm_runtime_disable(&pdev->dev);
-	clk_disable(sdev->dac);
+	clk_disable_unprepare(sdev->dac);
 	clk_put(sdev->fout_vpll);
 	clk_put(sdev->dacphy);
 	clk_put(sdev->dac);
-- 
1.8.1.2

