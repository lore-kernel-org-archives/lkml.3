Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbaKMPDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:03:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61614 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321AbaKMPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:03:51 -0500
X-AuditID: cbfee61a-f79c06d000004e71-45-5464c855b7c0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 11/33] thermal: exynos: replace tmu_pmin check by Exynos5440
 one
Date: Thu, 13 Nov 2014 16:01:06 +0100
Message-id: <1415890888-8881-12-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd3QEykhBrfemVg0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlbFw9i7ngiEjFqkfTmBsY9wp2MXJySAiYSKx+fYcJwhaT
	uHBvPVsXIxeHkMB0Ron7b08xQjhdTBLPb35jB6liE7CSmNi+ihHEFhHQkjhxaTsTSBGzwDIm
	iUvf5oONEhYIlZh58SILiM0ioCrRu+8bWJxXwENiycbpbBDrFCW6n00AszmB4q+m/gUbKiTg
	LnHt0TvmCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB9gzqR2MKxssDjEKcDAq
	8fC+YEkJEWJNLCuuzD3EKMHBrCTC630YKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBA
	emJJanZqakFqEUyWiYNTqoFx44W+qt2LWzvndW9byrjzcrrAWcEVbK07ngX8+Xexk9nN7vma
	MvlTte06my7M35OzvPDLWwVDjeP/Li/kPmsbkfdk2QLB93Mvc0XcdX+0cMndrQ3fL051ZPD2
	6Hwvy7st2uEA+2uDbouNZaJM1g2bik/v+XnirZNDXPHuc3l/zQLtq1dJ7bnzWImlOCPRUIu5
	qDgRANzsiM0sAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->tmu_pmin is set to non-zero value only for Exynos5440
so replace check for non-zero value of reg->tmu_pmin by
explicitly checking for Exynos5440 SoC type.  Then remove no
longer needed reg->tmu_pmin register abstraction.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 4 ++--
 drivers/thermal/samsung/exynos_tmu.h      | 3 ---
 drivers/thermal/samsung/exynos_tmu_data.c | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 839b07b..411c465 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -271,8 +271,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 	/*Clear the PMIN in the common TMU register*/
-	if (reg->tmu_pmin && !data->id)
-		writel(0, data->base_second + reg->tmu_pmin);
+	if (data->soc == SOC_ARCH_EXYNOS5440 && !data->id)
+		writel(0, data->base_second + EXYNOS5440_TMU_PMIN);
 out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 5c2cef1..e8510aa 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -92,7 +92,6 @@ enum soc_type {
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
  * @emul_con: TMU emulation controller register.
- * @tmu_pmin: register to get/set the Pmin value.
  */
 struct exynos_tmu_registers {
 	u32	tmu_ctrl;
@@ -116,8 +115,6 @@ struct exynos_tmu_registers {
 	u32	tmu_intclear;
 
 	u32	emul_con;
-
-	u32	tmu_pmin;
 };
 
 /**
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 557b4a5..fe063d4 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -402,7 +402,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
-	.tmu_pmin = EXYNOS5440_TMU_PMIN,
 };
 
 #define EXYNOS5440_TMU_DATA \
-- 
1.8.2.3

