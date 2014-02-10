Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBJQOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:14:00 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:56931 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbaBJQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:44 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, sonic.zhang@analog.com, chris@printf.net
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net, linux-mmc@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [RFT][PATCH 06/12] mmc: change bfin_sdh platform power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:12:29 -0700
Message-Id: <7ed5de35029d665d8ae1092ac54aa2f23dbfbe01.1392040067.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change bfin_sdh platform driver to register pm ops using dev_pm_ops instead
of legacy pm_ops. .pm hooks call existing legacy suspend and resume interfaces
by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/bfin_sdh.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 2b7f37e..d69f223 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -637,7 +637,7 @@ static int sdh_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int sdh_suspend(struct platform_device *dev, pm_message_t state)
+static int __sdh_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct bfin_sd_host *drv_data = get_sdh_data(dev);
 
@@ -646,7 +646,22 @@ static int sdh_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int sdh_resume(struct platform_device *dev)
+static int sdh_suspend(struct device *dev)
+{
+	return	__sdh_suspend(to_platform_device(dev), PMSG_SUSPEND);
+}
+
+static int sdh_freeze(struct device *dev)
+{
+	return	__sdh_suspend(to_platform_device(dev), PMSG_FREEZE);
+}
+
+static int sdh_poweroff(struct device *dev)
+{
+	return	__sdh_suspend(to_platform_device(dev), PMSG_HIBERNATE);
+}
+
+static int __sdh_resume(struct platform_device *dev)
 {
 	struct bfin_sd_host *drv_data = get_sdh_data(dev);
 	int ret = 0;
@@ -660,9 +675,21 @@ static int sdh_resume(struct platform_device *dev)
 	sdh_reset();
 	return ret;
 }
-#else
-# define sdh_suspend NULL
-# define sdh_resume  NULL
+
+static int sdh_resume(struct device *dev)
+{
+	return __sdh_resume(to_platform_device(dev));
+}
+
+static const struct dev_pm_ops sdh_dev_pm_ops = {
+	.suspend = sdh_suspend,
+	.resume = sdh_resume,
+	/* Hibernate hooks */
+	.freeze = sdh_freeze,
+	.thaw = sdh_resume,
+	.poweroff = sdh_poweroff,
+	.restore = sdh_resume,
+};
 #endif
 
 static struct platform_driver sdh_driver = {
@@ -672,6 +699,9 @@ static struct platform_driver sdh_driver = {
 	.resume  = sdh_resume,
 	.driver  = {
 		.name = DRIVER_NAME,
+#ifdef CONFIG_PM
+		.pm = &sdh_dev_pm_ops,
+#endif
 	},
 };
 
-- 
1.7.10.4

