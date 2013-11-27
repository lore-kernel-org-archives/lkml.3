Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3K0Pft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:35:49 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:56012 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3K0Pfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:35:45 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, David Airlie <airlied@linux.ie>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5/5] drm/exynos: Convert to suspend_late/resume_early callbacks for fimc
Date: Wed, 27 Nov 2013 16:35:00 +0100
Message-Id: <1385566500-7666-6-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simplify code for system suspend, convert the .suspend|resume
callbacks into .suspend_late|resume_early. In general this could be
convenient for any driver that supports both system PM and runtime PM.

Move the runtime PM callbacks to be implemented within CONFIG_PM, to
make them available for system PM.

Use pm_generic_suspend_late_runtime and pm_generic_resume_early_runtime
as the new callbacks.

Cc: David Airlie <airlied@linux.ie>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c |   33 ++++--------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 8adfc8f..7aa17a3 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1888,33 +1888,7 @@ static int fimc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int fimc_suspend(struct device *dev)
-{
-	struct fimc_context *ctx = get_fimc_context(dev);
-
-	DRM_DEBUG_KMS("id[%d]\n", ctx->id);
-
-	if (pm_runtime_suspended(dev))
-		return 0;
-
-	return fimc_clk_ctrl(ctx, false);
-}
-
-static int fimc_resume(struct device *dev)
-{
-	struct fimc_context *ctx = get_fimc_context(dev);
-
-	DRM_DEBUG_KMS("id[%d]\n", ctx->id);
-
-	if (!pm_runtime_suspended(dev))
-		return fimc_clk_ctrl(ctx, true);
-
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int fimc_runtime_suspend(struct device *dev)
 {
 	struct fimc_context *ctx = get_fimc_context(dev);
@@ -1935,8 +1909,9 @@ static int fimc_runtime_resume(struct device *dev)
 #endif
 
 static const struct dev_pm_ops fimc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(fimc_suspend, fimc_resume)
-	SET_RUNTIME_PM_OPS(fimc_runtime_suspend, fimc_runtime_resume, NULL)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_generic_suspend_late_runtime,
+				pm_generic_resume_early_runtime)
+	SET_PM_RUNTIME_PM_OPS(fimc_runtime_suspend, fimc_runtime_resume, NULL)
 };
 
 static const struct of_device_id fimc_of_match[] = {
-- 
1.7.9.5

