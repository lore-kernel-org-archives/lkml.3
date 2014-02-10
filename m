Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBJQM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:12:56 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:56936 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbaBJQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:46 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, davidb@codeaurora.org, dwalker@fifo99.com,
        bryanh@codeaurora.org, chris@printf.net
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFT][PATCH 09/12] mmc: change msm_sdcc platform power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:12:32 -0700
Message-Id: <269a4afb048513de75cf39b228e94a4578bbacc7.1392040068.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change msm_sdcc platform driver to register pm ops using dev_pm_ops instead of
legacy pm_ops. .pm hooks call existing legacy suspend and resume interfaces
by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/msm_sdcc.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 9405ecd..311e32a 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1417,7 +1417,7 @@ ioremap_free:
 
 #ifdef CONFIG_PM
 static int
-msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
+__msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct mmc_host *mmc = mmc_get_drvdata(dev);
 
@@ -1434,8 +1434,23 @@ msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
+static int msmsdcc_suspend(struct device *dev)
+{
+	return __msmsdcc_suspend(to_platform_device(dev), PMSG_SUSPEND);
+}
+
+static int msmsdcc_freeze(struct device *dev)
+{
+	return __msmsdcc_suspend(to_platform_device(dev), PMSG_FREEZE);
+}
+
+static int msmsdcc_poweroff(struct device *dev)
+{
+	return __msmsdcc_suspend(to_platform_device(dev), PMSG_HIBERNATE);
+}
+
 static int
-msmsdcc_resume(struct platform_device *dev)
+__msmsdcc_resume(struct platform_device *dev)
 {
 	struct mmc_host *mmc = mmc_get_drvdata(dev);
 
@@ -1454,17 +1469,30 @@ msmsdcc_resume(struct platform_device *dev)
 	}
 	return 0;
 }
-#else
-#define msmsdcc_suspend	0
-#define msmsdcc_resume 0
+
+static int msmsdcc_resume(struct device *dev)
+{
+	return __msmsdcc_resume(to_platform_device(dev));
+}
+
+static const struct dev_pm_ops msmsdcc_dev_pm_ops = {
+	.suspend = msmsdcc_suspend,
+	.resume = msmsdcc_resume,
+	/* Hibernate hooks */
+	.freeze = msmsdcc_freeze,
+	.thaw = msmsdcc_resume,
+	.poweroff = msmsdcc_poweroff,
+	.restore = msmsdcc_resume,
+};
 #endif
 
 static struct platform_driver msmsdcc_driver = {
 	.probe		= msmsdcc_probe,
-	.suspend	= msmsdcc_suspend,
-	.resume		= msmsdcc_resume,
 	.driver		= {
 		.name	= "msm_sdcc",
+#ifdef CONFIG_PM
+		.pm	= &msmsdcc_dev_pm_ops,
+#endif
 	},
 };
 
-- 
1.7.10.4

