Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbaKMPDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:03:46 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61604 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321AbaKMPDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:03:44 -0500
X-AuditID: cbfee61a-f79c06d000004e71-40-5464c84e61ed
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 10/33] thermal: exynos: replace tmu_irqstatus check by
 Exynos5440 one
Date: Thu, 13 Nov 2014 16:01:05 +0100
Message-id: <1415890888-8881-11-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQV2/EykhBnenKls0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBl/HyaUPBZvGLiykMsDYxrRboYOTkkBEwkrr07xwZhi0lc
	uLceyObiEBKYzijR/ayTBSQhJNDFJDHnlySIzSZgJTGxfRUjiC0ioCVx4tJ2JpAGZoFlTBKX
	vs1nAkkIC0RJnH//hx3EZhFQlbhzpQmogYODV8BDYstbM4hlikDzJ4At5gQKv5r6lxFil7vE
	tUfvmCcw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxaz6R2MK5ssDjEKMDBqMTD
	+4IlJUSINbGsuDL3EKMEB7OSCK/3YaAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJ
	JanZqakFqUUwWSYOTqkGxhkFzK+tnt3ZEjGzu7r/bn4eA8PMXA8V5T7TzA0V55ZpTZtz2uWI
	0sJaj5r6kl1atifNfmyYd+cPU+OCh72fi2dr/Mt+oVroKPlC/qbd/dnbnh+ZyeeT9KWm/eyX
	1zJbOWqN9geUrVv7ru7H/Dd3m/rs+Pp27lQzP1UYypKezh34MsPOP2QdtxJLcUaioRZzUXEi
	ACTPLdcpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->tmu_irqstatus is set to non-zero value only for Exynos5440
so replace check for non-zero value of reg->tmu_irqstatus by
explicitly checking for Exynos5440 SoC type.  Then remove no
longer needed reg->tmu_irqstatus register abstraction.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 6 ++----
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 1 -
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index e35c289..839b07b 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -407,15 +407,13 @@ static void exynos_tmu_work(struct work_struct *work)
 {
 	struct exynos_tmu_data *data = container_of(work,
 			struct exynos_tmu_data, irq_work);
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-	const struct exynos_tmu_registers *reg = pdata->registers;
 	unsigned int val_type;
 
 	if (!IS_ERR(data->clk_sec))
 		clk_enable(data->clk_sec);
 	/* Find which sensor generated this interrupt */
-	if (reg->tmu_irqstatus) {
-		val_type = readl(data->base_second + reg->tmu_irqstatus);
+	if (data->soc == SOC_ARCH_EXYNOS5440) {
+		val_type = readl(data->base_second + EXYNOS5440_TMU_IRQ_STATUS);
 		if (!((val_type >> data->id) & 0x1))
 			goto out;
 	}
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 2694298..5c2cef1 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -92,7 +92,6 @@ enum soc_type {
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
  * @emul_con: TMU emulation controller register.
- * @tmu_irqstatus: register to find which TMU generated interrupts.
  * @tmu_pmin: register to get/set the Pmin value.
  */
 struct exynos_tmu_registers {
@@ -118,7 +117,6 @@ struct exynos_tmu_registers {
 
 	u32	emul_con;
 
-	u32	tmu_irqstatus;
 	u32	tmu_pmin;
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index cef0b97..557b4a5 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -401,7 +401,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
-	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
 	.tmu_pmin = EXYNOS5440_TMU_PMIN,
 };
-- 
1.8.2.3

