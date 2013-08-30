Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3H3MCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:02:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34619 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3H3MCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:02:20 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-71-522089cb688f
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v4 2/2] media: s5p-tv: Restore vpll clock rate
Date: Fri, 30 Aug 2013 14:02:01 +0200
Message-id: <1377864121-19587-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377864121-19587-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377864121-19587-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xgO7pToUgg6vHbSzONr1ht9j0+Bqr
	xeVdc9gsejZsZbW4uE7e4vSaU8wW89pfsjqwe2xeUu9x8N0eJo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DK2P70EXvBOYGK26enMTcwXuDtYuTkkBAwkVj0aBcrhC0mceHeerYuRi4OIYFF
	jBLbf5+DctqZJF7fucMOUsUmYC4x8dkmFhBbREBC4v7qZ2wgNrPAeUaJc5fiuxg5OIQF7CR+
	bYkBCbMIqEq07ljBBGLzCvhJ9F6bywaxTEHi5+UTYDangL/Ekd8QRwgB1axd/JVtAiPvAkaG
	VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBYfRMegfjqgaLQ4wCHIxKPLwNU+WDhFgTy4or
	cw8xSnAwK4nwVqQqBAnxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgST
	ZeLglGpgLE6e+7F+p1rB/8mLrx2KYTkV39ncbiS2KDc+cf+WVocjBTaZOZyTeiYeWrVcby5H
	MPPjtlbZK6KP7NYVhnI76X+7WrXl+46+s3OWat4MXfCx9LGOmFCVW+rdzo89Sn+/TuUs/W0o
	m/lv7b6tyWwuR4wz+3ew2sZ15B4rXSKhN2+G+P1u1cJFSizFGYmGWsxFxYkAfZiPHx8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore vpll clock rate if start stream fail or stream is off.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 0afa90f..73a0ca6 100644
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
@@ -193,17 +195,35 @@ static int sdo_s_power(struct v4l2_subdev *sd, int on)
 
 static int sdo_streamon(struct sdo_device *sdev)
 {
+	int ret;
+
 	/* set proper clock for Timing Generator */
-	clk_set_rate(sdev->fout_vpll, 54000000);
+	sdev->vpll_rate = clk_get_rate(sdev->fout_vpll);
+	ret = clk_set_rate(sdev->fout_vpll, 54000000);
+	if (ret < 0) {
+		dev_err(sdev->dev,
+			"Failed to set vpll rate\n");
+		return ret;
+	}
 	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
 	clk_get_rate(sdev->fout_vpll));
 	/* enable clock in SDO */
 	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
-	clk_enable(sdev->dacphy);
+	ret = clk_enable(sdev->dacphy);
+	if (ret < 0) {
+		dev_err(sdev->dev,
+			"clk_enable(dacphy) failed\n");
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
@@ -220,6 +240,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	}
 	if (tries == 0)
 		dev_err(sdev->dev, "failed to stop streaming\n");
+	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
 	return tries ? 0 : -EIO;
 }
 
-- 
1.8.1.2

