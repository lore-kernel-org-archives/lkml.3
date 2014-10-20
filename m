Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaJTVGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:06:50 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40353 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaJTVGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:06:46 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 2/2] ARM: EXYNOS: Call regulator core suspend prepare and finish functions
Date: Mon, 20 Oct 2014 23:05:51 +0200
Message-Id: <1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework has a set of helpers functions to be used when
the system is entering and leaving from suspend but these are not called
on Exynos platforms. This means that the .set_suspend_* function handlers
defined by regulator drivers are not called when the system is suspended.

Suggested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/mach-exynos/suspend.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index cc8d237..f8e7dcd 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
+#include <linux/regulator/machine.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -443,6 +444,22 @@ static int exynos_suspend_enter(suspend_state_t state)
 
 static int exynos_suspend_prepare(void)
 {
+	int ret;
+
+	/*
+	 * REVISIT: It would be better if struct platform_suspend_ops
+	 * .prepare handler get the suspend_state_t as a parameter to
+	 * avoid hard-coding the suspend to mem state. It's safe to do
+	 * it now only because the suspend_valid_only_mem function is
+	 * used as the .valid callback used to check if a given state
+	 * is supported by the platform anyways.
+	 */
+	ret = regulator_suspend_prepare(PM_SUSPEND_MEM);
+	if (ret) {
+		pr_err("Failed to prepare regulators for suspend (%d)\n", ret);
+		return ret;
+	}
+
 	s3c_pm_check_prepare();
 
 	return 0;
@@ -450,7 +467,13 @@ static int exynos_suspend_prepare(void)
 
 static void exynos_suspend_finish(void)
 {
+	int ret;
+
 	s3c_pm_check_cleanup();
+
+	ret = regulator_suspend_finish();
+	if (ret)
+		pr_warn("Failed to resume regulators from suspend (%d)\n", ret);
 }
 
 static const struct platform_suspend_ops exynos_suspend_ops = {
-- 
2.1.0

