Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3H1Nf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:35:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61264 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3H1NfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:35:20 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-bf-521dfc973798
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
Subject: [PATCH v2 3/5] media: s5p-tv: Fix mixer driver to work with CCF
Date: Wed, 28 Aug 2013 15:34:30 +0200
Message-id: <1377696872-32069-4-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xgO70P7JBBgt2SFlMWneAyWL+kXOs
	Fm96O1gsehdcZbM42/SG3WLT42usFgvblrBYXN41h82iZ8NWVosZ5/cxWdy+zGtxcZ28xek1
	p5gtll6/yGTxdMJFNosJ09eyWBxeATRt3cvpQNabdlaLVwfbWCzmtb9ktTg2Ywmjxapdfxgd
	xD3WzFvD6NHS3MPmseDzFXaP15MnMHr8XfWC2WPnrLvsHq9Wz2T1uHNtD5vH5iX1Hgff7WHy
	6NuyitHj8yY5j41zQwN4o7hsUlJzMstSi/TtErgyet9OYSrYI1TRf7+PtYHxHH8XIyeHhICJ
	RNfbJywQtpjEhXvr2UBsIYFFjBJrJpd1MXIB2e1MEg1n1jKCJNgEzCUmPtsE1iAiICsxcfIX
	ZpAiZoGbLBI77vSAJYQFPCS+TLgE1sAioCpx5sMKsDivgJ/E9I9bmCG2KUj8vHwCbBungL9E
	25G/jBCb/SQeLHnNNIGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ph5Jr2DcVWD
	xSFGAQ5GJR7eiN+yQUKsiWXFlbmHGCU4mJVEePm3A4V4UxIrq1KL8uOLSnNSiw8xSnOwKInz
	Hmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwsnnGWQtPXOaUPzHFcOqdTVLyifGJOwM62/ZdX7RN
	Jt6/te/fzujZXQmB5pfUF3/6WD3xeWrjUvnE3Q8LrK8ZyE2qu9P86NiGLEVnrqTuH1kf9Os2
	bnT7ZXqZ3Vi1xtn9VblLjVPcZNa/TqFXrJSeNE+2Of6i4GGC+uPT57gONKgk3HiVfXmZEktx
	RqKhFnNRcSIAR6Qy1psCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
Without it Common Clock Framework prints a warning.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_drv.c | 35 ++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 51805a5..435c8c0 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -345,21 +345,42 @@ fail:
 
 static int mxr_runtime_resume(struct device *dev)
 {
+	int ret;
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
+		mxr_err(mdev, "clk_prepare_enable(mixer) failed\n");
+		goto fail;
+	}
+	ret = clk_prepare_enable(res->vp);
+	if (ret < 0) {
+		mxr_err(mdev, "clk_prepare_enable(vp) failed\n");
+		goto fail_mixer;
+	}
+	ret = clk_prepare_enable(res->sclk_mixer);
+	if (ret < 0) {
+		mxr_err(mdev, "clk_prepare_enable(sclk_mixer) failed\n");
+		goto fail_vp;
+	}
 	/* apply default configuration */
 	mxr_reg_reset(mdev);
-	mxr_dbg(mdev, "resume - finished\n");
 
 	mutex_unlock(&mdev->mutex);
+	mxr_dbg(mdev, "resume - finished\n");
 	return 0;
+fail_vp:
+	clk_disable_unprepare(res->vp);
+fail_mixer:
+	clk_disable_unprepare(res->mixer);
+fail:
+	mutex_unlock(&mdev->mutex);
+	mxr_info(mdev, "resume failed\n");
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

