Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3H1NfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:35:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63119 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3H1NfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:35:05 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-58-521dfc8769fc
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
Subject: [PATCH v2 1/5] media: s5p-tv: Restore vpll clock rate
Date: Wed, 28 Aug 2013 15:34:28 +0200
Message-id: <1377696872-32069-2-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgG77H9kggw1ThS0mrTvAZDH/yDlW
	ize9HSwWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2bRs2Erq8WM8/uYLG5f5rW4uE7e4vSa
	U8wWS69fZLJ4OuEim8WE6WtZLA6vAJq27uV0IOtNO6vFq4NtLBbz2l+yWhybsYTRYtWuP4wO
	4h5r5q1h9Ghp7mHzWPD5CrvH68kTGD3+rnrB7LFz1l12j1erZ7J63Lm2h81j85J6j4Pv9jB5
	9G1ZxejxeZOcx8a5oQG8UVw2Kak5mWWpRfp2CVwZe/csZix4L1Bx8N9NxgbGN7xdjJwcEgIm
	EvOvrGCCsMUkLtxbz9bFyMUhJLCIUaLj4VV2CKedSWLjtB/MIFVsAuYSE59tYgGxRQRkJSZO
	/sIMUsQscJNFYsedHrCEsICdxOnJS1hBbBYBVYn7TT/YQGxeAT+JfQ3r2CHWKUj8vHwCLM4p
	4C/RduQvI4gtBFTzYMlrpgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfQM6kd
	jCsbLA4xCnAwKvHwRvyWDRJiTSwrrsw9xCjBwawkwsu/HSjEm5JYWZValB9fVJqTWnyIUZqD
	RUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qB8ez6tjfWPPueL3TXXeH8rSGBtz5HzXXVbcf4
	Qwk6livtOKes/5zUnxKvNO9h/oezyaqduxtOvMlrMNZhT3++abVgkt1K87Trs55IdXB/Ygsx
	kzm4c31XggbrKcaLjzytN5v9MViTI///t7FCfIfPjEmWnofj3pVbysnG3p34K3DnhvDXs4oX
	KrEUZyQaajEXFScCAGKUYVGcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore vpll clock rate if start stream fail or stream is off.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 0afa90f..b919008 100644
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
+	int ret;
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
@@ -220,6 +239,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	}
 	if (tries == 0)
 		dev_err(sdev->dev, "failed to stop streaming\n");
+	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
 	return tries ? 0 : -EIO;
 }
 
-- 
1.8.1.2

