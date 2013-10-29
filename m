Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3J2N0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:26:31 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58581 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab3J2N00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:26:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 1/2] cpufreq: distinguish drivers that do asynchronous notifications
Date: Tue, 29 Oct 2013 18:56:06 +0530
Message-Id: <928878b755f369489479f7a105de175ef16e11b8.1383052613.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383052613.git.viresh.kumar@linaro.org>
References: <cover.1383052613.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383052613.git.viresh.kumar@linaro.org>
References: <cover.1383052613.git.viresh.kumar@linaro.org>
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

This also changes exynos5440-cpufreq.c and powernow-k8 in order to set this
flag.

Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos5440-cpufreq.c | 2 +-
 drivers/cpufreq/powernow-k8.c        | 1 +
 include/linux/cpufreq.h              | 7 +++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 1bf9b06..76bef8b 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -312,7 +312,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver exynos_driver = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= exynos_target,
 	.get		= exynos_getspeed,
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 62a1ce4..0023c7d 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1204,6 +1204,7 @@ out:
 }
 
 static struct cpufreq_driver cpufreq_amd64_driver = {
+	.flags		= CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= powernowk8_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 93a8c34..5bd6ab9 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -237,6 +237,13 @@ struct cpufreq_driver {
  */
 #define CPUFREQ_HAVE_GOVERNOR_PER_POLICY (1 << 3)
 
+/*
+ * Driver will do POSTCHANGE notifications from outside of their ->target()
+ * routine and so must set cpufreq_driver->flags with this flag, so that core
+ * can handle them specially.
+ */
+#define CPUFREQ_ASYNC_NOTIFICATION  (1 << 4)
+
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
-- 
1.7.12.rc2.18.g61b472e

