Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaIENw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:52:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55139 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaIENwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:52:24 -0400
X-AuditID: cbfee61b-f79f86d00000144c-02-5409c0178d4b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v6 2/5] ARM: EXYNOS: add AFTR mode support to firmware do_idle
 method
Date: Fri, 05 Sep 2014 15:51:25 +0200
Message-id: <1409925088-4705-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
References: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAV3xA5whBnevCFpsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PFxq8eDjwe
	d67tYfPYvKTe4/a/x8weW662s3j0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxvrVM9gLLgpW
	tE1dydzAeIuvi5GTQ0LARGL1mxVMELaYxIV769m6GLk4hAQWMUpsuL8Yyulikth97yM7SBWb
	gJXExPZVjCC2iICaRM/irYwgRcwCs5klXj18wAKSEBYIl9i8cQtYA4uAqsTsdadYQWxeAXeJ
	JcsvMEOsU5TofjaBDcTmFPCQmPLgC1hcCKhmZ/dNlgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBIfjM+kdjKsaLA4xCnAwKvHwLvjMESLEmlhWXJl7iFGCg1lJhNd2N2eIEG9K
	YmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBkbNFc4LFhfs6LCY
	HxIy5/uN+WFq3A8+SwjG3/n8mH3vJx2Wqpif4kV+l0Q2nNFcN6tuTom4Nduh2C+8xyaHJM5K
	MXtivNfAcPeTubm31iY95BLU2vCqN4Utfr1X/eE7Zi4VyWd0ql5uEK3vURZU2BXlt4b3mi9T
	ycyuYvZM643mvaHHs9c0NCuxFGckGmoxFxUnAgCoT+GrQwIAAA==
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
v6:
- no changes

 arch/arm/include/asm/firmware.h |  2 +-
 arch/arm/mach-exynos/common.h   |  5 +++++
 arch/arm/mach-exynos/firmware.c | 10 ++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index 5904f59..89aefe1 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -28,7 +28,7 @@ struct firmware_ops {
 	/*
 	 * Enters CPU idle mode
 	 */
-	int (*do_idle)(void);
+	int (*do_idle)(unsigned long mode);
 	/*
 	 * Sets boot address of specified physical CPU
 	 */
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index c218200..2d830df 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -119,6 +119,11 @@ extern void __iomem *sysram_base_addr;
 extern void __iomem *pmu_base_addr;
 void exynos_sysram_init(void);
 
+enum {
+	FW_DO_IDLE_SLEEP,
+	FW_DO_IDLE_AFTR,
+};
+
 void exynos_firmware_init(void);
 
 extern u32 exynos_get_eint_wake_mask(void);
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index f5e626d..e57b7c3 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -28,9 +28,15 @@
 #define EXYNOS_BOOT_ADDR	0x8
 #define EXYNOS_BOOT_FLAG	0xc
 
-static int exynos_do_idle(void)
+static int exynos_do_idle(unsigned long mode)
 {
-	exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
+	switch (mode) {
+	case FW_DO_IDLE_AFTR:
+		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
+		break;
+	case FW_DO_IDLE_SLEEP:
+		exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
+	}
 	return 0;
 }
 
-- 
1.8.2.3

