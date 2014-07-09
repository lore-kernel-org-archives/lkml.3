Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbaGIRTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:19:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59043 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbaGIRTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:19:00 -0400
X-AuditID: cbfee61b-f79f86d00000144c-61-53bd7982ef9f
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
Subject: [PATCH v3 2/4] ARM: EXYNOS: add AFTR mode support to firmware do_idle
 method
Date: Wed, 09 Jul 2014 19:17:52 +0200
Message-id: <1404926274-18411-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd2myr3BBns+61hsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyVh68
	yVJwXahiYtsmxgbGs/xdjJwcEgImEvO6vrJA2GISF+6tZ+ti5OIQEljEKPHxwDdmkISQQBeT
	xLWdQiA2m4CVxMT2VYwgtoiAmkTP4q2MIA3MAnuZJZZ2b2IHSQgLhEs0n37ECmKzCKhKXPo5
	D6yBV8BDomdpAzPENkWJ7mcTgLZxcHAKeEo821oMsctD4uyzdqYJjLwLGBlWMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgQH5TPpHYyrGiwOMQpwMCrx8Crw7AkWYk0sK67MPcQowcGsJMJ7
	q2RvsBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGHo3G
	aWVJ92V0zc+WMb7YbjBj1a/56pdmrvn39twXx7sf89Vsvs28ULtaQez99+L4/SrW+7vYrCek
	/+mr/FCsOSPB8OjU9bsc58n/uLKSXX7r1ENnNv1l7RLYfmXNZdUJi83/yCVKiM/YsFitae+C
	0KoNjyI7GF6kTjn6SuZB7i1v9kg51wkXwpVYijMSDbWYi4oTAWZQJc5GAgAA
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
v3:
- convert 'mode' parameter from int to unsigned long
- rename FW_DO_IDLE_NORMAL to FW_DO_IDLE_SLEEP
- move FW_DO_IDLE_* enums to common.h

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
index 152b464..297ac39 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -115,6 +115,11 @@ extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
 void exynos_sysram_init(void);
 
+enum {
+	FW_DO_IDLE_SLEEP,
+	FW_DO_IDLE_AFTR,
+};
+
 void exynos_firmware_init(void);
 
 extern u32 exynos_get_eint_wake_mask(void);
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index e50b5ec..a52dd975 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -27,9 +27,15 @@
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

