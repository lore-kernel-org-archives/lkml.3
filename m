Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbaKMPGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:06:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61817 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbaKMPGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:06:38 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-26-5464c8fcca47
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 26/33] thermal: exynos: remove TMU_SUPPORT_EMUL_TIME flag
Date: Thu, 13 Nov 2014 16:01:21 +0100
Message-id: <1415890888-8881-27-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd0/J1JCDPa857VouBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKuLLrFnPBFKWKrV2H2RsYn8p0MXJySAiYSCz72skCYYtJ
	XLi3nq2LkYtDSGA6o8SlR2+gnC4mid1LH7GDVLEJWElMbF/FCGKLCGhJnLi0nQmkiFlgGZPE
	pW/zmUASwgI+Er+2LGcDsVkEVCV2rG0BW8Er4CFxZu9VNoh1ihLdzyaA2ZxA8VdT/4INFRJw
	l7j26B3zBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCA+yZ9A7GVQ0WhxgFOBiV
	eHhfsKSECLEmlhVX5h5ilOBgVhLh9T4MFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEgg
	PbEkNTs1tSC1CCbLxMEp1cA4q2Vta9Rxh7Tyb15XbzoLddUrcX34HTVT7ha7XW+Zxq0bN/a2
	HMz7IvDjZUBiypIjyyqvb7h4ir9/4U6RC5qzPfn43lhy7D9kJCXEv+12qtDGN9GBp3Y+Ubgy
	2+jKtF9/+s0dMriP/7z41rNn4wUPJ7cpvae3M3TP2bJ77cv41OSj1+edeWm6UYmlOCPRUIu5
	qDgRAMMPZcEsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace TMU_SUPPORT_EMUL_TIME flag check in get_emul_con_reg()
by an explicit check for a SoC type (all SoC types except
Exynos4210 and Exynos5440 have TMU_SUPPORT_EMUL_TIME flag set
in their struct exynos_tmu_init_data instances).

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |  4 +---
 drivers/thermal/samsung/exynos_tmu.h      |  5 +----
 drivers/thermal/samsung/exynos_tmu_data.c | 11 +++++------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 6795ddc..209221f 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -427,12 +427,10 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
 static u32 get_emul_con_reg(struct exynos_tmu_data *data, unsigned int val,
 			    unsigned long temp)
 {
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-
 	if (temp) {
 		temp /= MCELSIUS;
 
-		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
+		if (data->soc != SOC_ARCH_EXYNOS5440) {
 			val &= ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT);
 			val |= (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT);
 		}
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index ed83d3d..d90852a 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -51,16 +51,13 @@ enum soc_type {
  *			temperature to the TMU controller.
  * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
  *			has many instances of TMU.
- * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
- *			sample time.
  * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
  *			sensors shares some common registers.
  * TMU_SUPPORT - macro to compare the above features with the supplied.
  */
 #define TMU_SUPPORT_EMULATION			BIT(0)
 #define TMU_SUPPORT_MULTI_INST			BIT(1)
-#define TMU_SUPPORT_EMUL_TIME			BIT(2)
-#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(3)
+#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(2)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 39b9651..82f1cba 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -101,7 +101,7 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
+	.features = TMU_SUPPORT_EMULATION
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS3250)
@@ -153,7 +153,7 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
+	.features = TMU_SUPPORT_EMULATION
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412)
@@ -221,7 +221,7 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 #define EXYNOS5260_TMU_DATA \
 	__EXYNOS5260_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5260, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
+	.features = TMU_SUPPORT_EMULATION
 
 struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 	.tmu_data = {
@@ -275,13 +275,12 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME)
+	.features = TMU_SUPPORT_EMULATION
 
 #define EXYNOS5420_TMU_DATA_SHARED \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_EMUL_TIME | \
-			TMU_SUPPORT_ADDRESS_MULTIPLE)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_ADDRESS_MULTIPLE)
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.2.3

