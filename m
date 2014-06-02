Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaFBMgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:36:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24336 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaFBMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:36:40 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-69-538c6fd5c7da
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 3/7] ARM: EXYNOS: add AFTR mode support to firmware do_idle
 method
Date: Mon, 02 Jun 2014 14:35:39 +0200
Message-id: <1401712543-14281-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd1r+T3BBof62Sw2zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZZ1eu
	YS5Yx1+xbe5b9gbGSzxdjJwcEgImEhu6r7JA2GISF+6tZ+ti5OIQEpjOKLGg9xU7hNPFJPH8
	33t2kCo2ASuJie2rGEFsEQE1iZ7FWxlBipgF9jJLLO3eBFTEwSEsEC5xf3EBSA2LgKrE/uXr
	mEBsXgEPiQXnF0JtU5TofjaBDcTmFPCUWHnvISuILQRUs+/VLqYJjLwLGBlWMYqmFiQXFCel
	5xrqFSfmFpfmpesl5+duYgSH5TOpHYwrGywOMQpwMCrx8P5U7wkWYk0sK67MPcQowcGsJMK7
	1AIoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgVHjRib/
	PZ9Gi2xVc8780nXfJ/9u+GdwR+zv82dfTbMu7V4quTrr6/3ybSd4p8QenqL11o2F/2D666MC
	Nh/9TWL2abgnKuZ4dSzMvPxh+7xyidQoPrWtqYrFmksvxd0/foxfeOlM/Txtq2nHZfUiUwtO
	Z7in7bQ3PF/4kOfa5dlMzQc9Ent/TFBiKc5INNRiLipOBAAOMZcFRwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms (i.e. EXYNOS ones) more than one idle mode is
available and we need to distinguish them in firmware do_idle method.

Add mode parameter to do_idle firmware method and AFTR mode support
to EXYNOS do_idle implementation.

This change is a preparation for adding secure firmware support to
EXYNOS cpuidle driver.

This patch shouldn't cause any functionality changes (please note
that do_idle firmware method is unused currently).

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/include/asm/firmware.h |  7 ++++++-
 arch/arm/mach-exynos/firmware.c | 10 ++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index 70883c7..63989c3 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -28,7 +28,7 @@ struct firmware_ops {
 	/*
 	 * Enters CPU idle mode
 	 */
-	int (*do_idle)(void);
+	int (*do_idle)(int mode);
 	/*
 	 * Sets boot address of specified physical CPU
 	 */
@@ -47,6 +47,11 @@ struct firmware_ops {
 	int (*c15resume)(u32 *regs);
 };
 
+enum {
+	FW_DO_IDLE_NORMAL,
+	FW_DO_IDLE_AFTR,
+};
+
 /* Global pointer for current firmware_ops structure, can't be NULL. */
 extern const struct firmware_ops *firmware_ops;
 
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 195b65c..3a34132 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -21,9 +21,15 @@
 #include "common.h"
 #include "smc.h"
 
-static int exynos_do_idle(void)
+static int exynos_do_idle(int mode)
 {
-	exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
+	switch (mode) {
+	case FW_DO_IDLE_AFTR:
+		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
+		break;
+	case FW_DO_IDLE_NORMAL:
+		exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
+	}
 	return 0;
 }
 
-- 
1.8.2.3

