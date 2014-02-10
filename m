Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaBJQOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:14:11 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:45820 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbaBJQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:44 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: rjw@rjwysocki.net, benh@kernel.crashing.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        shuahkhan@gmail.com
Subject: [RFT][PATCH 04/12] drivers/macintosh/adb: change platform power management to use dev_pm_ops
Date: Mon, 10 Feb 2014 09:12:27 -0700
Message-Id: <9637dc390002d58de22b21c8ae4aeaf60dfb72df.1392040067.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392040064.git.shuah.kh@samsung.com>
References: <cover.1392040064.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change adb platform driver to register pm ops using dev_pm_ops instead of
legacy pm_ops. .pm hooks call existing legacy suspend and resume interfaces
by passing in the right pm state.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/macintosh/adb.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 04a5049..df6b201 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -263,7 +263,7 @@ adb_reset_bus(void)
 /*
  * notify clients before sleep
  */
-static int adb_suspend(struct platform_device *dev, pm_message_t state)
+static int __adb_suspend(struct platform_device *dev, pm_message_t state)
 {
 	adb_got_sleep = 1;
 	/* We need to get a lock on the probe thread */
@@ -276,10 +276,25 @@ static int adb_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
+static int adb_suspend(struct device *dev)
+{
+	return __adb_suspend(to_platform_device(dev), PMSG_SUSPEND);
+}
+
+static int adb_freeze(struct device *dev)
+{
+	return __adb_suspend(to_platform_device(dev), PMSG_FREEZE);
+}
+
+static int adb_poweroff(struct device *dev)
+{
+	return __adb_suspend(to_platform_device(dev), PMSG_HIBERNATE);
+}
+
 /*
  * reset bus after sleep
  */
-static int adb_resume(struct platform_device *dev)
+static int __adb_resume(struct platform_device *dev)
 {
 	adb_got_sleep = 0;
 	up(&adb_probe_mutex);
@@ -287,6 +302,11 @@ static int adb_resume(struct platform_device *dev)
 
 	return 0;
 }
+
+static int adb_resume(struct device *dev)
+{
+	return __adb_resume(to_platform_device(dev));
+}
 #endif /* CONFIG_PM */
 
 static int __init adb_init(void)
@@ -831,14 +851,25 @@ static const struct file_operations adb_fops = {
 	.release	= adb_release,
 };
 
+#ifdef CONFIG_PM
+static const struct dev_pm_ops adb_dev_pm_ops = {
+	.suspend = adb_suspend,
+	.resume = adb_resume,
+	/* Hibernate hooks */
+	.freeze = adb_freeze,
+	.thaw = adb_resume,
+	.poweroff = adb_poweroff,
+	.restore = adb_resume,
+};
+#endif
+
 static struct platform_driver adb_pfdrv = {
 	.driver = {
 		.name = "adb",
-	},
 #ifdef CONFIG_PM
-	.suspend = adb_suspend,
-	.resume = adb_resume,
+		.pm = &adb_dev_pm_ops,
 #endif
+	},
 };
 
 static struct platform_device adb_pfdev = {
-- 
1.7.10.4

