Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3IUPBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:01:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53628 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3IUPBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:01:31 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-f1-523db4c9fd34
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: t.stanislaws@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v5 4/4] media: s5p-tv: Fix mixer driver to work with CCF
Date: Sat, 21 Sep 2013 17:00:49 +0200
Message-id: <1379775649-6331-5-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jQd1TW2yDDM7PY7PYOGM9q8XZpjfs
	FpseX2O1uLxrDptFz4atrBYX18lbnF5zitni8Jt2Vov1M16zWMxrf8nqwOWxeUm9x8F3e5g8
	+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+Pcq83MBW+EKm4ccmlgbBLoYuTkkBAwkbh/4Cgr
	hC0mceHeerYuRi4OIYHpjBJnp1xlhXDamSS2nNzFDFLFJmAuMfHZJhYQW0RAQuL+6mdgHcwC
	05kktn7oBhslLOAh8aLtG1gDi4CqxOLdr9hAbF4BX4ljrQcYIdYpSPy8fAIozsHBKeAn8W1P
	MkhYCKhk4YkTrBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA6yZ1I7GFc2WBxi
	FOBgVOLhzUiyDRJiTSwrrsw9xCjBwawkwiufChTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DV
	OlBIID2xJDU7NbUgtQgmy8TBKdXAeP63XJv/Xek3Z2OWJOgalLuzTvY9fqThxs3F1wrOFlut
	0Kr/yr1G7Kvj4ZlT1svNOVLSOO/G9sqYQ+eitFd3bdw5M2iS/px5M/+9W+stnumr/E7wUNHu
	t5H+BXEVnMULV8/onWvB1nxuDd+vGWmbDFgmbHr15tiBsqjPCy4uPr4l7133xvIsSRklluKM
	REMt5qLiRAAtos3lLgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
Without it Common Clock Framework prints a warning.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_drv.c | 34 +++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 8ce7c3e..7eea286 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -347,19 +347,41 @@ static int mxr_runtime_resume(struct device *dev)
 {
 	struct mxr_device *mdev = to_mdev(dev);
 	struct mxr_resources *res = &mdev->res;
+	int ret;
 
 	dev_dbg(mdev->dev, "resume - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks on */
-	clk_enable(res->mixer);
-	clk_enable(res->vp);
-	clk_enable(res->sclk_mixer);
+	ret = clk_prepare_enable(res->mixer);
+	if (ret < 0) {
+		dev_err(mdev->dev, "clk_prepare_enable(mixer) failed\n");
+		goto fail;
+	}
+	ret = clk_prepare_enable(res->vp);
+	if (ret < 0) {
+		dev_err(mdev->dev, "clk_prepare_enable(vp) failed\n");
+		goto fail_mixer;
+	}
+	ret = clk_prepare_enable(res->sclk_mixer);
+	if (ret < 0) {
+		dev_err(mdev->dev, "clk_prepare_enable(sclk_mixer) failed\n");
+		goto fail_vp;
+	}
 	/* apply default configuration */
 	mxr_reg_reset(mdev);
 	dev_dbg(mdev->dev, "resume - finished\n");
 
 	mutex_unlock(&mdev->mutex);
 	return 0;
+
+fail_vp:
+	clk_disable_unprepare(res->vp);
+fail_mixer:
+	clk_disable_unprepare(res->mixer);
+fail:
+	mutex_unlock(&mdev->mutex);
+	dev_err(mdev->dev, "resume failed\n");
+	return ret;
 }
 
 static int mxr_runtime_suspend(struct device *dev)
@@ -369,9 +391,9 @@ static int mxr_runtime_suspend(struct device *dev)
 	dev_dbg(mdev->dev, "suspend - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks off */
-	clk_disable(res->sclk_mixer);
-	clk_disable(res->vp);
-	clk_disable(res->mixer);
+	clk_disable_unprepare(res->sclk_mixer);
+	clk_disable_unprepare(res->vp);
+	clk_disable_unprepare(res->mixer);
 	mutex_unlock(&mdev->mutex);
 	dev_dbg(mdev->dev, "suspend - finished\n");
 	return 0;
-- 
1.8.1.2

