Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaHDRqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:46:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36685 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaHDRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:46:08 -0400
X-AuditID: cbfee61a-f79e46d00000134f-40-53dfc6def27e
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
Subject: [PATCH v4 2/5] ARM: EXYNOS: add AFTR mode support to firmware do_idle
 method
Date: Mon, 04 Aug 2014 19:45:42 +0200
Message-id: <1407174345-31213-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd17x+4HG6zYqmGxccZ6Vot5n2Ut
	ehdcZbM42/SG3eL9oWfMFpseX2O1uLxrDpvF594jjBYzzu9jsjhz+hKrxck/vYwW62e8ZrHY
	+NXDgdfjzrU9bB6bl9R73P73mNljy9V2Fo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKaFm7
	n61gj2DF3bY7jA2MZ/m6GDk5JARMJB6dOs8OYYtJXLi3ng3EFhJYxCjxZiKQzQVkdzFJLF05
	nQUkwSZgJTGxfRUjiC0ioCbRs3grI0gRs8BeZoml3ZvAJgkLhEvc+NoGNolFQFXi64cvYDav
	gIfE197rzBDbFCW6n00Ai3MKeEr8OPILarOHRPeh5YwTGHkXMDKsYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAgOy2dSOxhXNlgcYhTgYFTi4RVQux8sxJpYVlyZe4hRgoNZSYS37gBQiDcl
	sbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA2Pehe83Gqb4Gld/
	evx5gvaZRWoPjp/z3fR4/42UHqGVGxe/ZL+sO50tefuNyT06EeJOPj7lyrFbWx8pNcYHiKzb
	eWDv2zxm9jUnXk1dY7HPK17UrevT6/TdKhNP5DPNfW8cvfbqWb1dr3VXJF26+CH59vVU/6PJ
	noVbd0/xZew00ZodvWRXlIeIEktxRqKhFnNRcSIAItMPyEcCAAA=
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

