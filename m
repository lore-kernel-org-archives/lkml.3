Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaKMPE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:04:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41052 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaKMPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:04:23 -0500
X-AuditID: cbfee61a-f79c06d000004e71-6e-5464c875505f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 15/33] thermal: exynos: remove TMU_SUPPORT_TRIM_RELOAD flag
Date: Thu, 13 Nov 2014 16:01:10 +0100
Message-id: <1415890888-8881-16-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd3SEykhBnO/aVo0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBl7Doym7Xgs2pF77HZ7A2Mz+W7GDk5JARMJLZ1H2CGsMUk
	Ltxbz9bFyMUhJDCdUWLG44fMEE4Xk0Tf7RfsIFVsAlYSE9tXMYLYIgJaEicubWcCKWIWWMYk
	cenbfCaQhLCAn8TUCT1gDSwCqhK3/mxiBbF5BTwkut/vZoJYpyjR/WwCG4jNCRR/NfUv2FAh
	AXeJa4/eMU9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjAnkntYFzZYHGIUYCD
	UYmH9wVLSogQa2JZcWXuIUYJDmYlEV7vw0Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOF
	BNITS1KzU1MLUotgskwcnFINjIKO8WZ8RgdOvOGskZjOEMeyqnX1DqvFx439nJcYMkjkF6gy
	zVi5J/7NA4P4jjb9s1NWxe/fpD59753w86WZ2aI7Hk3ZeGSG0EINAS3LshcvfT5mSplIL674
	ZlJbksMq0nC71+vnhr3f4mSNjq2SvGnt6J7ML3nc+272VKsfGi9UPy7fo19wWomlOCPRUIu5
	qDgRAAmJkYAsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace TMU_SUPPORT_TRIM_RELOAD flag check in exynos_tmu_initialize()
by an explicit check for a SoC type (only Exynos3250, Exynos4412 and
Exynos5250 have TMU_SUPPORT_READY_STATUS flag set in their struct
exynos_tmu_init_data instances).  Please note that this requires
adding separate SoC type for Exynos5420 so it doesn't get mistaken
with Exynos5250.

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
 drivers/thermal/samsung/exynos_tmu.c      |  5 ++++-
 drivers/thermal/samsung/exynos_tmu.h      | 10 ++++------
 drivers/thermal/samsung/exynos_tmu_data.c | 10 +++++-----
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 33ee527..e4d75a1 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -161,7 +161,9 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 
-	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
+	if (data->soc == SOC_ARCH_EXYNOS3250 ||
+	    data->soc == SOC_ARCH_EXYNOS4412 ||
+	    data->soc == SOC_ARCH_EXYNOS5250) {
 		if (data->soc == SOC_ARCH_EXYNOS3250) {
 			ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON1);
 			ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
@@ -626,6 +628,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	    pdata->type == SOC_ARCH_EXYNOS4412 ||
 	    pdata->type == SOC_ARCH_EXYNOS5250 ||
 	    pdata->type == SOC_ARCH_EXYNOS5260 ||
+	    pdata->type == SOC_ARCH_EXYNOS5420 ||
 	    pdata->type == SOC_ARCH_EXYNOS5420_TRIMINFO ||
 	    pdata->type == SOC_ARCH_EXYNOS5440)
 		data->soc = pdata->type;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index d3d9205..adecc7f 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -40,6 +40,7 @@ enum soc_type {
 	SOC_ARCH_EXYNOS4412,
 	SOC_ARCH_EXYNOS5250,
 	SOC_ARCH_EXYNOS5260,
+	SOC_ARCH_EXYNOS5420,
 	SOC_ARCH_EXYNOS5420_TRIMINFO,
 	SOC_ARCH_EXYNOS5440,
 };
@@ -50,8 +51,6 @@ enum soc_type {
  *			temperature to the TMU controller.
  * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
  *			has many instances of TMU.
- * TMU_SUPPORT_TRIM_RELOAD - This features shows that trimming can
- *			be reloaded.
  * TMU_SUPPORT_FALLING_TRIP - This features shows that interrupt can
  *			be registered for falling trips also.
  * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
@@ -62,10 +61,9 @@ enum soc_type {
  */
 #define TMU_SUPPORT_EMULATION			BIT(0)
 #define TMU_SUPPORT_MULTI_INST			BIT(1)
-#define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
-#define TMU_SUPPORT_FALLING_TRIP		BIT(3)
-#define TMU_SUPPORT_EMUL_TIME			BIT(4)
-#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(5)
+#define TMU_SUPPORT_FALLING_TRIP		BIT(2)
+#define TMU_SUPPORT_EMUL_TIME			BIT(3)
+#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(4)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index c327120..1ed8bdc 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -131,8 +131,8 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	}, \
 	.freq_tab_count = 2, \
 	.registers = &exynos3250_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS3250)
@@ -201,8 +201,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	}, \
 	.freq_tab_count = 2, \
 	.registers = &exynos4412_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412)
@@ -359,7 +359,7 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
-	.type = SOC_ARCH_EXYNOS5250, \
+	.type = SOC_ARCH_EXYNOS5420, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
 			TMU_SUPPORT_EMUL_TIME)
 
-- 
1.8.2.3

