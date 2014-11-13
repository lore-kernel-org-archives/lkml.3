Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbaKMPGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:06:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61763 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaKMPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:06:00 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-02-5464c8d74784
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 22/33] thermal: exynos: add get_emul_con_reg() helper
Date: Thu, 13 Nov 2014 16:01:17 +0100
Message-id: <1415890888-8881-23-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQd3rJ1JCDOa38Vs0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlbD/0jrFgvXDF79fPmRsYZwp0MXJySAiYSBzrbGOFsMUk
	LtxbzwZiCwlMZ5S4+UK+i5ELyO5iklja/BGsiE3ASmJi+ypGEFtEQEvixKXtTCBFzALLmCQu
	fZvPBJIQFvCQWH6rjb2LkZ2DRUBV4pcXSJQXKLr51mYmiF2KEt3PJoDt4gSKv5r6lxFir7vE
	tUfvmCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxaz6R3MK5qsDjEKMDBqMTD
	+4IlJUSINbGsuDL3EKMEB7OSCK/3YaAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJ
	JanZqakFqUUwWSYOTqkGxu4/QSzbni1dGa34d1Jd8MKlFXP/9M2tN697ZcJeNHfFJWUZ7lkX
	n04/LsS1S8lxekcRW9X+0s+1y5x2HOCaO4dpS4M/84aA8HPGAQsZNKwUEs4IhXmcXtyzxOV1
	gk7kvL+3418mM17g8l3uHSxqeH/131WyC1g/SztWnzqbzsb2nU1f53b9VCWW4oxEQy3mouJE
	AISwb0kpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for preparing EMUL_CON register value from
exynos_tmu_set_emulation() into get_emul_con_reg().

This is a preparation for introducing per-SoC type
tmu_set_emulation method.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 38 ++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b209593..1b622ce 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -438,6 +438,28 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
 }
 
 #ifdef CONFIG_THERMAL_EMULATION
+static u32 get_emul_con_reg(struct exynos_tmu_data *data, unsigned int val,
+			    unsigned long temp)
+{
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+
+	if (temp) {
+		temp /= MCELSIUS;
+
+		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
+			val &= ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT);
+			val |= (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT);
+		}
+		val &= ~(EXYNOS_EMUL_DATA_MASK << EXYNOS_EMUL_DATA_SHIFT);
+		val |= (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
+			EXYNOS_EMUL_ENABLE;
+	} else {
+		val &= ~EXYNOS_EMUL_ENABLE;
+	}
+
+	return val;
+}
+
 static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 {
 	struct exynos_tmu_data *data = drv_data;
@@ -456,21 +478,7 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	clk_enable(data->clk);
 
 	val = readl(data->base + reg->emul_con);
-
-	if (temp) {
-		temp /= MCELSIUS;
-
-		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
-			val &= ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT);
-			val |= (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT);
-		}
-		val &= ~(EXYNOS_EMUL_DATA_MASK << EXYNOS_EMUL_DATA_SHIFT);
-		val |= (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
-			EXYNOS_EMUL_ENABLE;
-	} else {
-		val &= ~EXYNOS_EMUL_ENABLE;
-	}
-
+	val = get_emul_con_reg(data, val, temp);
 	writel(val, data->base + reg->emul_con);
 
 	clk_disable(data->clk);
-- 
1.8.2.3

