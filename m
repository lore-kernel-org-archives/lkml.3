Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbaKMPER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:04:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61641 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaKMPEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:04:13 -0500
X-AuditID: cbfee61a-f79c06d000004e71-60-5464c86b53c7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 14/33] thermal: exynos: remove TMU_SUPPORT_READY_STATUS flag
Date: Thu, 13 Nov 2014 16:01:09 +0100
Message-id: <1415890888-8881-15-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd3sEykhBvc3S1o0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlPP20nL1grXrF06ZvTA2MixW7GDk5JARMJL61PGOEsMUk
	Ltxbz9bFyMUhJDCdUWLG/+NQTheTxJfza5hBqtgErCQmtq8C6xAR0JI4cWk7E0gRs8AyJolL
	3+YzgSSEBfwlts18AVbEIqAqsbvzAFAzBwevgIfErF+hENsUJbqfTWADsTmBwq+m/gUrFxJw
	l7j26B3zBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCw+uZ1A7GlQ0WhxgFOBiV
	eHhfsKSECLEmlhVX5h5ilOBgVhLh9T4MFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEgg
	PbEkNTs1tSC1CCbLxMEp1cC4x+17i8MFU5c1Nu9K1Mv2+q76J2Hw/LHhs8gu/yOndk6p+HZC
	Jv7nqh8nXRdrRc/69E/vhDvHtIavvcz7zs6Wci1W0Gmt1FbSPqQ+e8L5jMTqV+cPnA4+vrAp
	tfDL5utb/mYea9/t1Rs3i00ulYvnr8xChewplcKspntjI5w0hIQqu25tlxdRYinOSDTUYi4q
	TgQAsxap8isCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace TMU_SUPPORT_READY_STATUS flag check in
exynos_tmu_initialize() by an explicit check for a SoC type
(all SoC types except Exynos5440 have TMU_SUPPORT_READY_STATUS
flag set in their struct exynos_tmu_init_data instances).

This is a preparation for introducing per-SoC type tmu_initialize
method.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |  2 +-
 drivers/thermal/samsung/exynos_tmu.h      |  7 ++-----
 drivers/thermal/samsung/exynos_tmu_data.c | 14 +++++---------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 4f7cad9..33ee527 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -153,7 +153,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	if (!IS_ERR(data->clk_sec))
 		clk_enable(data->clk_sec);
 
-	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
+	if (data->soc != SOC_ARCH_EXYNOS5440) {
 		status = readb(data->base + EXYNOS_TMU_REG_STATUS);
 		if (!status) {
 			ret = -EBUSY;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index ebe39b4..d3d9205 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -54,8 +54,6 @@ enum soc_type {
  *			be reloaded.
  * TMU_SUPPORT_FALLING_TRIP - This features shows that interrupt can
  *			be registered for falling trips also.
- * TMU_SUPPORT_READY_STATUS - This feature tells that the TMU current
- *			state(active/idle) can be checked.
  * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
  *			sample time.
  * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
@@ -66,9 +64,8 @@ enum soc_type {
 #define TMU_SUPPORT_MULTI_INST			BIT(1)
 #define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
 #define TMU_SUPPORT_FALLING_TRIP		BIT(3)
-#define TMU_SUPPORT_READY_STATUS		BIT(4)
-#define TMU_SUPPORT_EMUL_TIME			BIT(5)
-#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(6)
+#define TMU_SUPPORT_EMUL_TIME			BIT(4)
+#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(5)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index f81c940..c327120 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -73,7 +73,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.freq_tab_count = 2,
 		.type = SOC_ARCH_EXYNOS4210,
 		.registers = &exynos4210_tmu_registers,
-		.features = TMU_SUPPORT_READY_STATUS,
 		},
 	},
 	.tmu_count = 1,
@@ -133,8 +132,7 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.freq_tab_count = 2, \
 	.registers = &exynos3250_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME)
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS3250)
@@ -204,8 +202,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.freq_tab_count = 2, \
 	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME)
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412)
@@ -291,7 +288,7 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	__EXYNOS5260_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5260, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
+			TMU_SUPPORT_EMUL_TIME)
 
 struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 	.tmu_data = {
@@ -364,14 +361,13 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5250, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
+			TMU_SUPPORT_EMUL_TIME)
 
 #define EXYNOS5420_TMU_DATA_SHARED \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME | \
-			TMU_SUPPORT_ADDRESS_MULTIPLE)
+			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.2.3

