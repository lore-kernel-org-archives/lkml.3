Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3HZLjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:39:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26694 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3HZLjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:39:10 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-66-521b3e5c6e48
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
Subject: [PATCH RFC 2/5] media: s5p-tv: Fix mixer driver to work with CCF
Date: Mon, 26 Aug 2013 13:38:31 +0200
Message-id: <1377517114-20222-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xoG6MnXSQwZevphbzj5xjtXjT28Fi
	0bvgKpvF2aY37BabHl9jtVjYtoTF4vKuOWwWM87vY7K4fZnX4uI6eYvTa04xW7zuO8xisfT6
	RSaLpxMusllMmL6WxeLwigNMFuteTgey3rSzWrw62MZisX7GaxaLee0vWS2OzVjCaLFq1x9G
	B3GPNfPWMHq0NPeweSz4fIXd4/XkCYweO2fdZfd4tXomq8eda3vYPDYvqfc4+G4Pk0ffllWM
	Ht2fbrF6fN4k57FxbmgAbxSXTUpqTmZZapG+XQJXxrfdz1gLJgtVvG2YzNbAuIK/i5GTQ0LA
	RGLx8aWMELaYxIV769m6GLk4hASmM0o09/9iAkkICbQzSSy5HgJiswmYS0x8tokFxBYRkJRo
	avjDDNLALHCDRWLB0b9gk4QFPCXm/zgA1swioCrx9kQfG4jNK+An8X39RFaIbQoSPy+fAItz
	CvhL7GnpY4dY5idxbvk3lgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfPM+kd
	jKsaLA4xCnAwKvHwBrBJBwmxJpYVV+YeYpTgYFYS4TUXBQrxpiRWVqUW5ccXleakFh9ilOZg
	URLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgnDlVuKnMbZ+vVAqT/NXknYaX93gzPfz7XGfn
	57kzDLxnzL01u9F0ttyk7653N+zhT15/X2TjEf2Nc0oDzppcXZ4poVBh/28Z3+29jpItXd17
	vv7nLbTpdC12MT60av4NXeume86Zf8TvlCg9SdvtyvFDqX/xh9/F/2d2xe1O5t/ctiTD/2V0
	gxJLcUaioRZzUXEiAEjtrz6bAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
Without it Common Clock Framework prints a warning.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_drv.c | 33 +++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 51805a5..f889591 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -345,21 +345,42 @@ fail:
 
 static int mxr_runtime_resume(struct device *dev)
 {
+	int ret = 0;
 	struct mxr_device *mdev = to_mdev(dev);
 	struct mxr_resources *res = &mdev->res;
 
 	mxr_dbg(mdev, "resume - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks on */
-	clk_enable(res->mixer);
-	clk_enable(res->vp);
-	clk_enable(res->sclk_mixer);
+	ret = clk_prepare_enable(res->mixer);
+	if (ret < 0) {
+		dev_err(dev, "clk_prepare_enable(mixer) failed\n");
+		goto fail;
+	}
+	ret = clk_prepare_enable(res->vp);
+	if (ret < 0) {
+		dev_err(dev, "clk_prepare_enable(vp) failed\n");
+		goto fail_mixer;
+	}
+	ret = clk_prepare_enable(res->sclk_mixer);
+	if (ret < 0) {
+		dev_err(dev, "clk_prepare_enable(sclk_mixer) failed\n");
+		goto fail_vp;
+	}
 	/* apply default configuration */
 	mxr_reg_reset(mdev);
 	mxr_dbg(mdev, "resume - finished\n");
 
 	mutex_unlock(&mdev->mutex);
 	return 0;
+fail_vp:
+	clk_disable_unprepare(res->vp);
+fail_mixer:
+	clk_disable_unprepare(res->mixer);
+fail:
+	mutex_unlock(&mdev->mutex);
+	dev_info(dev, "resume failed\n");
+	return ret;
 }
 
 static int mxr_runtime_suspend(struct device *dev)
@@ -369,9 +390,9 @@ static int mxr_runtime_suspend(struct device *dev)
 	mxr_dbg(mdev, "suspend - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks off */
-	clk_disable(res->sclk_mixer);
-	clk_disable(res->vp);
-	clk_disable(res->mixer);
+	clk_disable_unprepare(res->sclk_mixer);
+	clk_disable_unprepare(res->vp);
+	clk_disable_unprepare(res->mixer);
 	mutex_unlock(&mdev->mutex);
 	mxr_dbg(mdev, "suspend - finished\n");
 	return 0;
-- 
1.8.1.2

