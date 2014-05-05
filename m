Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbaEEK7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:59:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58113 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaEEK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:59:09 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-ca-53676efc84c8
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
Subject: [PATCH 3/7] ARM: EXYNOS: add AFTR mode support to firmware do_idle
 method
Date: Mon, 05 May 2014 12:57:15 +0200
Message-id: <1399287439-31376-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd0/eenBBnMuGVhsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyttzo
	Zil4xlfx9cJ21gbGCTxdjJwcEgImEpOWLWSHsMUkLtxbz9bFyMUhJLCIUeLfynXMEE4Xk8T8
	+xPZQKrYBKwkJravYgSxRQTUJHoWb2UEKWIW2MsssbR7E9goYYEQiTXz17KA2CwCqhIvtv1g
	ArF5BTwkVt07ALVOUaL72QSwoZwCnhJLNz9mBrGFgGo2vG1nm8DIu4CRYRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcGA+k9rBuLLB4hCjAAejEg9vAnN6sBBrYllxZe4hRgkOZiUR3uxE
	oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGzSF/XDZZ
	WzM9iLbcdPCxZ/cfz4bp95//3tPFcvzMzE9/3tZW990I+X7x3rSzfh3+Eza8Wc3StSX65Son
	vp3RQvUvnVI0v88LUTk+ZcWZk5JTeFnfPJWtPP6kNmr97vDkDrOPcyO9rA6/kfIzkmxYJvTC
	7kz2hs6/9e925R/92tRgOOl39N5PskosxRmJhlrMRcWJAE873s9IAgAA
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
index 581c7bf..71fe169 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -20,9 +20,15 @@
 
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

