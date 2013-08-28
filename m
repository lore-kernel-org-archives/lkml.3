Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3H1NfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:35:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61239 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3H1NfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:35:13 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-9c-521dfc8fb4ae
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: t.stanislaws@samsung.com, m.chehab@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v2 2/5] media: s5p-tv: Fix sdo driver to work with CCF
Date: Wed, 28 Aug 2013 15:34:29 +0200
Message-id: <1377696872-32069-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgG7/H9kgg8ln5CwmrTvAZDH/yDlW
	ize9HSwWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2bRs2Erq8WM8/uYLG5f5rW4uE7e4vSa
	U8wWS69fZLJ4OuEim8WE6WtZLA6vAJq27uV0IOtNO6vFq4NtLBbz2l+yWhybsYTRYtWuP4wO
	4h5r5q1h9Ghp7mHzWPD5CrvH68kTGD3+rnrB7LFz1l12j1erZ7J63Lm2h81j85J6j4Pv9jB5
	9G1ZxejxeZOcx8a5oQG8UVw2Kak5mWWpRfp2CVwZXVdfMBfsEK34cHU3ewPjV8EuRk4OCQET
	iQurb7JA2GISF+6tZ+ti5OIQEljEKHH/7HxmCKedSeLBnf2sIFVsAuYSE59tAusQEZCVmDj5
	C1gRs8BNFokdd3rAEsICbhJzFz9lArFZBFQlJq7aBhbnFfCTOP9zMRvEOgWJn5dPgNmcAv4S
	bUf+MoLYQkA1D5a8ZprAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAEPZPewbiq
	weIQowAHoxIPb8Rv2SAh1sSy4srcQ4wSHMxKIrz824FCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGCfwT2uMsjOtONTi9vnmE6sOO82UxVUF+5MXMBY+
	+vPdu6zT+YET0JX9leFvj/3MKnqo/aOJaS0nh1O+Yzr79vTfn2JmPjXRjLHZqbmdcXafxvss
	66ePXH6FJPi5FK7YcyZPetHsUL7oJ7/txObo6j1Jve/7rTux7ckT961iN/eeY1n7K+SLEktx
	RqKhFnNRcSIALrs01pwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
Without it Common Clock Framework prints a warning.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index b919008..acdae6b 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -230,7 +230,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	int tries;
 
 	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
-	clk_disable(sdev->dacphy);
+	clk_disable_unprepare(sdev->dacphy);
 	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
 	for (tries = 100; tries; --tries) {
 		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
@@ -274,7 +274,7 @@ static int sdo_runtime_suspend(struct device *dev)
 	dev_info(dev, "suspend\n");
 	regulator_disable(sdev->vdet);
 	regulator_disable(sdev->vdac);
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return 0;
 }
 
@@ -286,7 +286,7 @@ static int sdo_runtime_resume(struct device *dev)
 
 	dev_info(dev, "resume\n");
 
-	ret = clk_enable(sdev->sclk_dac);
+	ret = clk_prepare_enable(sdev->sclk_dac);
 	if (ret < 0)
 		return ret;
 
@@ -319,7 +319,7 @@ static int sdo_runtime_resume(struct device *dev)
 vdac_r_dis:
 	regulator_disable(sdev->vdac);
 dac_clk_dis:
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return ret;
 }
 
@@ -333,7 +333,7 @@ static int sdo_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct sdo_device *sdev;
 	struct resource *res;
-	int ret = 0;
+	int ret;
 	struct clk *sclk_vpll;
 
 	dev_info(dev, "probe start\n");
@@ -425,8 +425,13 @@ static int sdo_probe(struct platform_device *pdev)
 	}
 
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
 
@@ -464,7 +469,7 @@ static int sdo_remove(struct platform_device *pdev)
 	struct sdo_device *sdev = sd_to_sdev(sd);
 
 	pm_runtime_disable(&pdev->dev);
-	clk_disable(sdev->dac);
+	clk_disable_unprepare(sdev->dac);
 	clk_put(sdev->fout_vpll);
 	clk_put(sdev->dacphy);
 	clk_put(sdev->dac);
-- 
1.8.1.2

