Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3ILKLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:11:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44777 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3ILKLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:11:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: distinguish drivers that do asynchronous notifications
Date: Thu, 12 Sep 2013 15:40:45 +0530
Message-Id: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are few special cases like exynos5440 which doesn't send POSTCHANGE
notification from their ->target() routine and call some kind of bottom halves
for doing this work, work/tasklet/etc.. From which they finally send POSTCHANGE
notification.

Its better if we distinguish them from other cpufreq drivers in some way so that
core can handle them specially. So this patch introduces another flag:
CPUFREQ_ASYNC_NOTIFICATION, which will be set by such drivers.

This also changes exynos5440-cpufreq.c in order to set this flag.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos5440-cpufreq.c | 2 +-
 include/linux/cpufreq.h              | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index d514c15..f44664a 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -342,7 +342,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver exynos_driver = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= exynos_verify_speed,
 	.target		= exynos_target,
 	.get		= exynos_getspeed,
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index fcabc42..3cefb7b 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -218,6 +218,12 @@ struct cpufreq_driver {
 					 * frequency transitions */
 #define CPUFREQ_PM_NO_WARN	0x04	/* don't warn on suspend/resume speed
 					 * mismatches */
+/*
+ * Driver will do POSTCHANGE notifications from outside of their ->target()
+ * routine and so must set cpufreq_driver->flags with this flag, so that core
+ * can handle them specially.
+ */
+#define CPUFREQ_ASYNC_NOTIFICATION 0x08
 
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
-- 
1.7.12.rc2.18.g61b472e

