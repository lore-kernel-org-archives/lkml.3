Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaIRPaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:30:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20450 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994AbaIRPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:12 -0400
X-AuditID: cbfee61a-f79e46d00000134f-b7-541afa826044
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 26/33] thermal: exynos: remove TMU_SUPPORT_EMUL_TIME flag
Date: Thu, 18 Sep 2014 17:27:43 +0200
Message-id: <1411054070-25757-27-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd2mX1IhBqv7JS0aroZYbJyxntXi
	7vPDjBbzr1xjtTjb9Ibd4s3DzYwWl3fNYbP43HuE0WLG+X1MFk8e9rE5cHnsnHWX3WPxnpdM
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWxYfURxoJTShV7nm1jamCcKtvFyMkhIWAi8Xpz
	IxOELSZx4d56ti5GLg4hgUWMEs9mzYNyupgkJqzZygpSxSZgJTGxfRUjiC0ioCVx4tJ2JpAi
	ZoFbTBKvb0wGSwgLeEq8bH7GDmKzCKhKbLnSARTn4OAFij/arg6xTVGi+9kENhCbEyjccGsT
	WLmQgIdE25a7zBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA60Z1I7GFc2WBxi
	FOBgVOLhPcArFSLEmlhWXJl7iFGCg1lJhPfPR6AQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt
	1oFCAumJJanZqakFqUUwWSYOTqkGRo4Xm/4Xdbh8vC8v/uM++9IHL+Smf+0qWxz2vsTZ/+pW
	vi6+osvTik+fr9s47dWZJg9F4Xt7F9zcqNtziSfgxL7XJnLnTj8pNRa/I7p6z7pn+zfvm3jq
	RJajZ8T8e+dfi178V3hplqDp3rOyun1Ss2YlLRTKMMwvnXfHJvPswcPnzpx8dfnMHx8OJZbi
	jERDLeai4kQA2SNp6zACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace TMU_SUPPORT_EMUL_TIME flag check in get_emul_con_reg()
by an explicit check for a SoC type (all SoC types except
Exynos4210 and Exynos5440 have TMU_SUPPORT_EMUL_TIME flag set
in their struct exynos_tmu_init_data instances).

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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
index 121bc5d..890d4fe 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -442,12 +442,10 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
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

