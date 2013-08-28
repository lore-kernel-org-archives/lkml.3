Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3H1QPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:15:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35292 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3H1QPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:15:10 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-bc-521e220c2b50
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
Subject: [PATCH v3 4/6] media: s5p-tv: Fix mixer driver to work with CCF
Date: Wed, 28 Aug 2013 18:13:02 +0200
Message-id: <1377706384-3697-5-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgC6PklyQwcszJhaT1h1gsph/5Byr
	xZveDhaL3gVX2SzONr1ht9j0+BqrxcK2JSwWl3fNYbPo2bCV1WLG+X1MFrcv81pcXCdvcXrN
	KWaLpdcvMlk8nXCRzWLC9LUsFodXAE1b93I6kPWmndXi1cE2Fot57S9ZLY7NWMJosWrXH0YH
	cY8189YwerQ097B5LPh8hd3j9eQJjB5/V71g9tg56y67x6vVM1k97lzbw+axeUm9x8F3e5g8
	+rasYvT4vEnOY+Pc0ADeKC6blNSczLLUIn27BK6M5ct2sxfcE6r4/b2HrYHxG38XIyeHhICJ
	xIY5Z5khbDGJC/fWs3UxcnEICSxilFjyaRkThNPOJPH90SF2kCo2AXOJic82sYDYIgKyEhMn
	f2EGKWIWuMkiseNOD1hCWMBD4sXJRrCxLAKqEh2/J4DFeQV8JSY1T2SDWKcg8fPyCTCbU8BP
	YsKKO2A1QkA1N9b+Y5rAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAEPZPawbiy
	weIQowAHoxIPb8Rv2SAh1sSy4srcQ4wSHMxKIry/ReSChHhTEiurUovy44tKc1KLDzFKc7Ao
	ifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTCmza9SnDZ7t8rMhtkfF81/dYxbu3Z6t7ZCkdy8
	F4tL3l7xTjnHnHdchUN1cc0jDa7/d/VNy5iN2yqX8vimOVr2a9yPXmzs9LRS9DljrpJ3xhMF
	huO6WwU7jv678/frp2a1Ygk1rueJrQcDeMpUNZp7j0VfcbNpjTlkmOK4ZgNL8TWm4/ufL1Fi
	Kc5INNRiLipOBAAjLMDKnAIAAA==
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
index 8ce7c3e..3b2b305 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -347,19 +347,40 @@ static int mxr_runtime_resume(struct device *dev)
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
-	dev_dbg(mdev->dev, "resume - finished\n");
 
 	mutex_unlock(&mdev->mutex);
+	dev_dbg(mdev->dev, "resume - finished\n");
 	return 0;
+fail_vp:
+	clk_disable_unprepare(res->vp);
+fail_mixer:
+	clk_disable_unprepare(res->mixer);
+fail:
+	mutex_unlock(&mdev->mutex);
+	dev_info(mdev->dev, "resume failed\n");
+	return ret;
 }
 
 static int mxr_runtime_suspend(struct device *dev)
@@ -369,9 +390,9 @@ static int mxr_runtime_suspend(struct device *dev)
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

