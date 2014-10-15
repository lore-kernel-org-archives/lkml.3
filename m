Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaJOMCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:02:03 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33232 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaJOMCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:02:01 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] ARM: EXYNOS: Call regulator core suspend prepare and finish functions
Date: Wed, 15 Oct 2014 14:01:36 +0200
Message-Id: <1413374496-27866-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework has a set of helpers functions to be used when
the system is entering and leaving from suspend but these are not called
on Exynos platforms. This means that the .set_suspend_* function handlers
defined in regulator drivers are never called when the system is suspended.

Suggested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/mach-exynos/suspend.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f5d9773..5b9c551 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
+#include <linux/regulator/machine.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -270,14 +271,29 @@ static int exynos_suspend_enter(suspend_state_t state)
 
 static int exynos_suspend_prepare(void)
 {
+	int ret;
+
 	s3c_pm_check_prepare();
 
+	/*
+	 * REVISIT: It would be better if struct platform_suspend_ops
+	 * .prepare handler get the suspend_state_t as a parameter to
+	 * avoid hard-coding the suspend to mem state. It's safe to do
+	 * it only because the suspend_valid_only_mem function is the
+	 * .valid callback used to check if a given state is supported
+	 * by the platform.
+	 */
+	ret = regulator_suspend_prepare(PM_SUSPEND_MEM);
+	if (ret)
+		pr_info("Failed to prepare regulators for system suspend\n");
+
 	return 0;
 }
 
 static void exynos_suspend_finish(void)
 {
 	s3c_pm_check_cleanup();
+	regulator_suspend_finish();
 }
 
 static const struct platform_suspend_ops exynos_suspend_ops = {
-- 
2.1.0

