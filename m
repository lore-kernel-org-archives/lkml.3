Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbaIRPf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:35:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14615 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbaIRP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:29:23 -0400
X-AuditID: cbfee61a-f79e46d00000134f-81-541afa510017
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 15/33] thermal: exynos: remove TMU_SUPPORT_TRIM_RELOAD flag
Date: Thu, 18 Sep 2014 17:27:32 +0200
Message-id: <1411054070-25757-16-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd3AX1IhBp1PRSwaroZYbJyxntXi
	7vPDjBbzr1xjtTjb9Ibd4s3DzYwWl3fNYbP43HuE0WLG+X1MFk8e9rE5cHnsnHWX3WPxnpdM
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWxaEMTS8FKtYpfa96xNjBOV+hi5OSQEDCR+LD8
	ODOELSZx4d56ti5GLg4hgUWMEjdm9TJCOF1MEqfnbWUFqWITsJKY2L6KEcQWEdCSOHFpOxNI
	EbPALSaJ1zcmgyWEBbwlXp+9DdbAIqAqsfHHPzYQm1fAU+LOxemMEOsUJbqfTQCLcwLFG25t
	YgexhQQ8JNq23GWewMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwqD2T2sG4ssHi
	EKMAB6MSD+8BXqkQIdbEsuLK3EOMEhzMSiK8fz4ChXhTEiurUovy44tKc1KLDzFKc7AoifMe
	aLUOFBJITyxJzU5NLUgtgskycXBKNTDyL3h7Qnet82GFDddWa9hcnyfbPIHhuahDzoltlUvs
	585pSVbm/u8xs8Tj0Fwus1+vXTa3Ca5IZC+c0HKsk0Pp/fX+kA+s00oF+qK/LxCT6nLfcliO
	deWHwPfpG88cWtDXfuG4NKf93X2mtgafwxkb5Yw55trwa73SnjJhR8yKb+Ldu8MZM1qUWIoz
	Eg21mIuKEwGaftJJMQIAAA==
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

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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
index d9fa49a..4903a6e 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -144,7 +144,9 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 
-	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
+	if (data->soc == SOC_ARCH_EXYNOS3250 ||
+	    data->soc == SOC_ARCH_EXYNOS4412 ||
+	    data->soc == SOC_ARCH_EXYNOS5250) {
 		if (data->soc == SOC_ARCH_EXYNOS3250) {
 			ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON1);
 			ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
@@ -615,6 +617,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	    pdata->type == SOC_ARCH_EXYNOS4412 ||
 	    pdata->type == SOC_ARCH_EXYNOS5250 ||
 	    pdata->type == SOC_ARCH_EXYNOS5260 ||
+	    pdata->type == SOC_ARCH_EXYNOS5420 ||
 	    pdata->type == SOC_ARCH_EXYNOS5420_TRIMINFO ||
 	    pdata->type == SOC_ARCH_EXYNOS5440)
 		data->soc = pdata->type;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 400f10d..02ef3b0 100644
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
index af886e3..27782ac 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -136,8 +136,8 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	}, \
 	.freq_tab_count = 2, \
 	.registers = &exynos3250_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS3250)
@@ -210,8 +210,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	}, \
 	.freq_tab_count = 2, \
 	.registers = &exynos4412_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412)
@@ -376,7 +376,7 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
-	.type = SOC_ARCH_EXYNOS5250, \
+	.type = SOC_ARCH_EXYNOS5420, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
 			TMU_SUPPORT_EMUL_TIME)
 
-- 
1.8.2.3

