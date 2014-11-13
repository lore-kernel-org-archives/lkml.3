Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbaKMPFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:05:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61717 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaKMPFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:05:24 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-dd-5464c8b2c9f9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 19/33] thermal: exynos: add get_con_reg() helper
Date: Thu, 13 Nov 2014 16:01:14 +0100
Message-id: <1415890888-8881-20-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd1NJ1JCDE4dNrJouBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DK6Jh4g61gj2DFxHkzWBsY3/N1MXJySAiYSKw6d4QRwhaT
	uHBvPVsXIxeHkMB0Ronf58+yQjhdTBI3P01nBaliE7CSmNi+CqxDREBL4sSl7UwgRcwCy5gk
	Ln2bzwSSEBZwllix/CyYzSKgKtH09ggbiM0r4CEx/dVXJoh1ihLdzyaAxTmB4q+m/gUbKiTg
	LnHt0TvmCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB9gz6R2MqxosDjEKcDAq
	8fC+YEkJEWJNLCuuzD3EKMHBrCTC630YKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBA
	emJJanZqakFqEUyWiYNTqoGxqybjU9U5j0Rx1k9sJ9TSWy5xJb18ImUXu6f871OdftnsXf+q
	rfsevsj/smy2AqdgxL/+iYv9fx4zY9Q5s9Jhnvd96awTfj0asdOr3mufqLN1+jKrrDZnz4lC
	8ckdwvLRCp6vwo3q9k4++MohT425+sejh0+Wl/2P2m/Hyu9oZ7r13tJb8ZeUWIozEg21mIuK
	EwFW7NXgLAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for preparing TMU_CONTROL register value from
exynos_tmu_control() into get_con_reg().

This is a preparation for introducing per-SoC type tmu_control
method.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 736ef78..f65e6d8 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -197,17 +197,9 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	return ret;
 }
 
-static void exynos_tmu_control(struct platform_device *pdev, bool on)
+static u32 get_con_reg(struct exynos_tmu_data *data, u32 con)
 {
-	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
-	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int con, interrupt_en;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	con = readl(data->base + reg->tmu_ctrl);
 
 	if (pdata->test_mux)
 		con |= (pdata->test_mux << EXYNOS4412_MUX_ADDR_SHIFT);
@@ -223,6 +215,21 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 		con |= (pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT);
 	}
 
+	return con;
+}
+
+static void exynos_tmu_control(struct platform_device *pdev, bool on)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	const struct exynos_tmu_registers *reg = pdata->registers;
+	unsigned int con, interrupt_en;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	con = get_con_reg(data, readl(data->base + reg->tmu_ctrl));
+
 	if (on) {
 		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en =
-- 
1.8.2.3

