Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaGaRLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:11:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41808 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaGaRLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:11:42 -0400
X-AuditID: cbfee61b-f79f86d00000144c-2a-53da78cd67a3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v3 4/8] thermal: exynos: remove redundant threshold_code checks
 from exynos_tmu_initialize()
Date: Thu, 31 Jul 2014 19:11:02 +0200
Message-id: <1406826667-2289-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jAd2zFbeCDc5N5LVouBpisXHGelaL
	Nft/MlmcbXrDbnF51xw2i8+9RxgtZpzfx2Rx5vQlVosnD/vYLNbPeM3iwOWxeM9LJo8tV9tZ
	PPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBnbl85nKdgqWrFzl3gDY5tgFyMnh4SA
	icSjO5eZIGwxiQv31rN1MXJxCAksYpS4emc+O4TTxSTRufcRWBWbgJXExPZVjCC2iICexI0X
	T5hAipgFjjNJ/Px9ng0kISyQJ3Fjxj0WEJtFQFViwrHZ7CA2r4C7REP3JUaIdYoS3c8mgNVz
	CnhIHGifAWYLAdX83XSSdQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwSH3THoH
	46oGi0OMAhyMSjy8DqG3goVYE8uKK3MPMUpwMCuJ8LqUA4V4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUw8mzp1bqcMKFySunm/h2tpx/w2Dj+8W54+3S+
	h8wDhntr496xhRfW1ucpMh055LTrG+fjqQsSNV6aLU6WDju54pX3zfIEo4esu6+wrmaTvSxe
	pdpttzfy9BkDZikW87YLnhlTenzFL7H2C1Y/fT+r+rWuboSinIVQaFO9euePWa+jxJ8yHhRT
	YinOSDTUYi4qTgQAAMB/JTUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove runtime checks for negative return values of temp_to_code()
from exynos_tmu_initialize().

The current level temperature data hardcoded in pdata will never
cause a negative temp_to_code() return values and checking itself
is not proper.  The checks in question are done at runtime in
a production code for data that is hardcoded inside driver during
development time and later it doesn't change.  Such data should
be verified during development and review time (i.e. by a script
parsing relevant data from exynos_tmu_data.c, one can also argue
that verification to be done is so simple that the review by
a maintainer should be enough).

Theres should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b9bffad..15574cc 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -215,10 +215,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	if (data->soc == SOC_ARCH_EXYNOS4210) {
 		/* Write temperature code for threshold */
 		threshold_code = temp_to_code(data, pdata->threshold);
-		if (threshold_code < 0) {
-			ret = threshold_code;
-			goto out;
-		}
 		writeb(threshold_code,
 			data->base + reg->threshold_temp);
 		for (i = 0; i < trigger_levs; i++)
@@ -232,19 +228,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
-			if (threshold_code < 0) {
-				ret = threshold_code;
-				goto out;
-			}
 			rising_threshold &= ~(0xff << 8 * i);
 			rising_threshold |= threshold_code << 8 * i;
 			if (pdata->threshold_falling) {
 				threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i] -
 						pdata->threshold_falling);
-				if (threshold_code > 0)
-					falling_threshold |=
-						threshold_code << 8 * i;
+				falling_threshold |= threshold_code << 8 * i;
 			}
 		}
 
@@ -263,10 +253,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 				(pdata->trigger_type[i] == HW_TRIP)) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
-			if (threshold_code < 0) {
-				ret = threshold_code;
-				goto out;
-			}
 			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
 				/* 1-4 level to be assigned in th0 reg */
 				rising_threshold &= ~(0xff << 8 * i);
-- 
1.8.2.3

