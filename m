Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3IUPCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:02:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63653 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3IUPBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:01:23 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-19-523db4c2e182
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: t.stanislaws@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v5 2/4] media: s5p-tv: Restore vpll clock rate
Date: Sat, 21 Sep 2013 17:00:47 +0200
Message-id: <1379775649-6331-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jQd1DW2yDDLp/iVtsnLGe1eJs0xt2
	i02Pr7FaXN41h82iZ8NWVouL6+QtTq85xWxx+E07q8X6Ga9ZLOa1v2R14PLYvKTe4+C7PUwe
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXF54zb2gj8CFU8+7GJpYGzk62Lk5JAQMJH4svEt
	C4QtJnHh3nq2LkYuDiGB6YwS06/8ZYVw2pkk7t2+wgZSxSZgLjHx2SawDhEBCYn7q5+BdTAL
	TGeS2PqhmxUkISxgJ/H8+wMwm0VAVeLw6R5GEJtXwFei4+VzqHUKEj8vnwBq5uDgFPCT+LYn
	GSQsBFSy8MQJ1gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfZM+kdjKsaLA4x
	CnAwKvHwCiTYBgmxJpYVV+YeYpTgYFYS4ZVPBQrxpiRWVqUW5ccXleakFh9ilOZgURLnPdhq
	HSgkkJ5YkpqdmlqQWgSTZeLglGpgjBOROFK4um5fwQ7/otM/jB9+dpBSebjnodxhDVvuRA7r
	kBO7FmiwVBopl+55tsFvQdUXkw3PNZp+hCesjZrrt/DF1Fdvb1XOPK0u+LyUV3DniXVrgjh+
	MXXMP20yb87kLQs+TOQ/pBS+MvjujCi9+P4lf4OWTYyw835+sU3pRQjXQvEDat1/5ymxFGck
	GmoxFxUnAgB8jVJcLwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore vpll clock rate if start stream fail or stream is off.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 0afa90f..e49ac6c 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -55,6 +55,8 @@ struct sdo_device {
 	struct clk *dacphy;
 	/** clock for control of VPLL */
 	struct clk *fout_vpll;
+	/** vpll rate before sdo stream was on */
+	unsigned long vpll_rate;
 	/** regulator for SDO IP power */
 	struct regulator *vdac;
 	/** regulator for SDO plug detection */
@@ -193,17 +195,33 @@ static int sdo_s_power(struct v4l2_subdev *sd, int on)
 
 static int sdo_streamon(struct sdo_device *sdev)
 {
+	int ret;
+
 	/* set proper clock for Timing Generator */
-	clk_set_rate(sdev->fout_vpll, 54000000);
+	sdev->vpll_rate = clk_get_rate(sdev->fout_vpll);
+	ret = clk_set_rate(sdev->fout_vpll, 54000000);
+	if (ret < 0) {
+		dev_err(sdev->dev, "Failed to set vpll rate\n");
+		return ret;
+	}
 	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
 	clk_get_rate(sdev->fout_vpll));
 	/* enable clock in SDO */
 	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
-	clk_enable(sdev->dacphy);
+	ret = clk_enable(sdev->dacphy);
+	if (ret < 0) {
+		dev_err(sdev->dev, "clk_enable(dacphy) failed\n");
+		goto fail;
+	}
 	/* enable DAC */
 	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
 	sdo_reg_debug(sdev);
 	return 0;
+	
+fail:
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
+	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
+	return ret;
 }
 
 static int sdo_streamoff(struct sdo_device *sdev)
@@ -220,6 +238,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	}
 	if (tries == 0)
 		dev_err(sdev->dev, "failed to stop streaming\n");
+	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
 	return tries ? 0 : -EIO;
 }
 
-- 
1.8.1.2

