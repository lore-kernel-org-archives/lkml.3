Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3IUPB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:01:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53627 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3IUPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:01:27 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-f0-523db4c6a360
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: t.stanislaws@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v5 3/4] media: s5p-tv: Fix sdo driver to work with CCF
Date: Sat, 21 Sep 2013 17:00:48 +0200
Message-id: <1379775649-6331-4-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jQd1jW2yDDG7c5bbYOGM9q8XZpjfs
	FpseX2O1uLxrDptFz4atrBYX18lbnF5zitni8Jt2Vov1M16zWMxrf8nqwOWxeUm9x8F3e5g8
	+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PnmelsBd/FKtb8f8rYwLhCuIuRk0NCwESirWUy
	M4QtJnHh3nq2LkYuDiGB6YwSl+8sZ4Fw2pkkJjYcYgepYhMwl5j4bBMLiC0iICFxf/UzsA5m
	gelMEls/dLOCJIQF3CRWvekHa2ARUJXYun4CWAOvgK/Es63PGCHWKUj8vHwCqJmDg1PAT+Lb
	nmSQsBBQycITJ1gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcZs+kdjCubLA4
	xCjAwajEw5uRZBskxJpYVlyZe4hRgoNZSYRXPhUoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdA
	q3WgkEB6YklqdmpqQWoRTJaJg1OqgTHD99HJQ+s/9NkYO80S0p7Drz6DizWZob1sw8yaVb5Z
	j6415mdebYvc5/ec9cHVpuVV1t9LSr+1BM1vbTL8yq2dEDMz/Pgytt8RVk8cJ/346KG/RXp3
	rPzRbzteu53d9vjGF4sT1++vdj8TujIkqCt0fenJEM/T99c6Vt08syRBIfbvKvkb3V+VWIoz
	Eg21mIuKEwH9vW3VLwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
Without it Common Clock Framework prints a warning.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index e49ac6c..17272e1 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -208,9 +208,9 @@ static int sdo_streamon(struct sdo_device *sdev)
 	clk_get_rate(sdev->fout_vpll));
 	/* enable clock in SDO */
 	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
-	ret = clk_enable(sdev->dacphy);
+	ret = clk_prepare_enable(sdev->dacphy);
 	if (ret < 0) {
-		dev_err(sdev->dev, "clk_enable(dacphy) failed\n");
+		dev_err(sdev->dev, "clk_prepare_enable(dacphy) failed\n");
 		goto fail;
 	}
 	/* enable DAC */
@@ -229,7 +229,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	int tries;
 
 	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
-	clk_disable(sdev->dacphy);
+	clk_disable_unprepare(sdev->dacphy);
 	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
 	for (tries = 100; tries; --tries) {
 		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
@@ -273,7 +273,7 @@ static int sdo_runtime_suspend(struct device *dev)
 	dev_info(dev, "suspend\n");
 	regulator_disable(sdev->vdet);
 	regulator_disable(sdev->vdac);
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return 0;
 }
 
@@ -285,7 +285,7 @@ static int sdo_runtime_resume(struct device *dev)
 
 	dev_info(dev, "resume\n");
 
-	ret = clk_enable(sdev->sclk_dac);
+	ret = clk_prepare_enable(sdev->sclk_dac);
 	if (ret < 0)
 		return ret;
 
@@ -318,7 +318,7 @@ static int sdo_runtime_resume(struct device *dev)
 vdac_r_dis:
 	regulator_disable(sdev->vdac);
 dac_clk_dis:
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return ret;
 }
 
@@ -424,7 +424,11 @@ static int sdo_probe(struct platform_device *pdev)
 	}
 
 	/* enable gate for dac clock, because mixer uses it */
-	clk_enable(sdev->dac);
+	ret = clk_prepare_enable(sdev->dac);
+	if (ret < 0) {
+		dev_err(dev, "clk_prepare_enable(dac) failed\n");
+		goto fail_fout_vpll;
+	}
 
 	/* configure power management */
 	pm_runtime_enable(dev);
@@ -463,7 +467,7 @@ static int sdo_remove(struct platform_device *pdev)
 	struct sdo_device *sdev = sd_to_sdev(sd);
 
 	pm_runtime_disable(&pdev->dev);
-	clk_disable(sdev->dac);
+	clk_disable_unprepare(sdev->dac);
 	clk_put(sdev->fout_vpll);
 	clk_put(sdev->dacphy);
 	clk_put(sdev->dac);
-- 
1.8.1.2

