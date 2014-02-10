Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBJQM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:12:58 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:49669 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbaBJQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:45 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, mirq-linux@rere.qmqm.pl, chris@printf.net
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [RFT][PATCH 08/12] mmc: change cb710-mmc platform power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:12:31 -0700
Message-Id: <5393e4bd34e5667b7d00fa09c9d5bee0f68d659f.1392040068.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change cb710-mmc platform driver to register pm ops using dev_pm_ops instead
of legacy pm_ops. .pm hooks call existing legacy suspend and resume interfaces
by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/cb710-mmc.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
index 1087b4c..00fd93f 100644
--- a/drivers/mmc/host/cb710-mmc.c
+++ b/drivers/mmc/host/cb710-mmc.c
@@ -664,7 +664,7 @@ static const struct mmc_host_ops cb710_mmc_host = {
 
 #ifdef CONFIG_PM
 
-static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int __cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
 
@@ -672,7 +672,22 @@ static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int cb710_mmc_resume(struct platform_device *pdev)
+static int cb710_mmc_suspend(struct device *dev)
+{
+	return __cb710_mmc_suspend(to_platform_device(dev), PMSG_SUSPEND);
+}
+
+static int cb710_mmc_freeze(struct device *dev)
+{
+	return __cb710_mmc_suspend(to_platform_device(dev), PMSG_FREEZE);
+}
+
+static int cb710_mmc_poweroff(struct device *dev)
+{
+	return __cb710_mmc_suspend(to_platform_device(dev), PMSG_HIBERNATE);
+}
+
+static int __cb710_mmc_resume(struct platform_device *pdev)
 {
 	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
 
@@ -680,6 +695,10 @@ static int cb710_mmc_resume(struct platform_device *pdev)
 	return 0;
 }
 
+static int cb710_mmc_resume(struct device *dev)
+{
+	return __cb710_mmc_resume(to_platform_device(dev));
+}
 #endif /* CONFIG_PM */
 
 static int cb710_mmc_init(struct platform_device *pdev)
@@ -762,13 +781,23 @@ static int cb710_mmc_exit(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static const struct dev_pm_ops cb710_mmc_dev_pm_ops = {
+	.suspend = cb710_mmc_suspend,
+	.resume = cb710_mmc_resume,
+	/* Hibernate hooks */
+	.freeze = cb710_mmc_freeze,
+	.thaw = cb710_mmc_resume,
+	.poweroff = cb710_mmc_poweroff,
+	.restore = cb710_mmc_resume,
+};
+#endif
 static struct platform_driver cb710_mmc_driver = {
 	.driver.name = "cb710-mmc",
 	.probe = cb710_mmc_init,
 	.remove = cb710_mmc_exit,
 #ifdef CONFIG_PM
-	.suspend = cb710_mmc_suspend,
-	.resume = cb710_mmc_resume,
+	.driver.pm = &cb710_mmc_dev_pm_ops,
 #endif
 };
 
-- 
1.7.10.4

