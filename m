Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaEELSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:18:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47374 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaEELSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:18:53 -0400
X-AuditID: cbfee61b-b7f766d00000646c-3b-5367739b0d67
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 05/10] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_initialize()
Date: Mon, 05 May 2014 13:15:34 +0200
Message-id: <1399288539-1793-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jAd3ZxenBBlMbLSwaroZYbJyxntVi
	zf6fTBZnm96wW1zeNYfN4nPvEUaLGef3MVmcOX2J1eLJwz42i/UzXrM4cHks3vOSyWPL1XYW
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV0bDU5GCC/wVZ4+dYG1g7OHtYuTkkBAw
	kdj05zUbhC0mceHeeiCbi0NIYBGjxIRpC5khnC4miUWP+1lBqtgErCQmtq9iBLFFBPQkbrx4
	wgRSxCxwnEni5+/zYKOEBVIk7h77wt7FyMHBIqAqcWGbB0iYV8Bd4tesS4wQ2xQlup9NACvn
	FPCQ2P/yMTOILQRUc/DxZOYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH3DPp
	HYyrGiwOMQpwMCrx8CYwpwcLsSaWFVfmHmKU4GBWEuHNTgQK8aYkVlalFuXHF5XmpBYfYpTm
	YFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYEznPbSd+2HFowhO3VklydN/p++JeiRx7O19
	KY68lMK/rzXvXXm7JE7tgiD/osbA3xP26riunt+v4f6C48Zjp9D/N0vMo3cfydz8Wn5dVd3F
	oyHuV9q8lzV8vXenX8vtrMHdHw7sGawvlJi1F3rPj+q80HDiX2sAy/2tq3MvnyvV6z9RMXHy
	yWYlluKMREMt5qLiRACfMonpNAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove runtime checks for pdata sanity from exynos_tmu_initialize().
The current values hardcoded in pdata will never trigger the checks
and for the new code potential mistakes should be caught during
development/review phases.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.h |  1 -
 drivers/thermal/samsung/exynos_tmu.c            | 13 -------------
 2 files changed, 14 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 3eb2ed9..cd44719 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -27,7 +27,6 @@
 #define SENSOR_NAME_LEN	16
 #define MAX_TRIP_COUNT	8
 #define MAX_COOLING_DEVICE 4
-#define MAX_THRESHOLD_LEVS 5
 
 #define ACTIVE_INTERVAL 500
 #define IDLE_INTERVAL 10000
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 903566f..789d745 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -158,23 +158,10 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	    data->temp_error > pdata->max_efuse_value)
 		data->temp_error = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
 
-	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
-		dev_err(&pdev->dev, "Invalid max trigger level\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	for (i = 0; i < pdata->max_trigger_level; i++) {
 		if (!pdata->trigger_levels[i])
 			continue;
 
-		if ((pdata->trigger_type[i] == HW_TRIP) &&
-		(!pdata->trigger_levels[pdata->max_trigger_level - 1])) {
-			dev_err(&pdev->dev, "Invalid hw trigger level\n");
-			ret = -EINVAL;
-			goto out;
-		}
-
 		/* Count trigger levels except the HW trip*/
 		if (!(pdata->trigger_type[i] == HW_TRIP))
 			trigger_levs++;
-- 
1.8.2.3

