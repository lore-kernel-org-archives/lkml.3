Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971AbaFQRaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:30:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25792 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942AbaFQRaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:30:10 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-1b-53a07b208c97
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 4/9] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_initialize()
Date: Tue, 17 Jun 2014 19:27:20 +0200
Message-id: <1403026045-16024-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jQV3F6gXBBk2vGS0aroZYbJyxntVi
	zf6fTBZnm96wW1zeNYfN4nPvEUaLGef3MVmcOX2J1eLJwz42i/UzXrM4cHks3vOSyWPL1XYW
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8aCJ+3sBU+EKlr/nmJuYLzG38XIySEh
	YCIx8fliJghbTOLCvfVsXYxcHEIC0xkl9n2+xg7hdDFJLJjSxw5SxSZgJTGxfRUjiC0ioCdx
	48UTJpAiZoHjTBI/f59nA0kIC6RK/No9F8xmEVCV2DRlNlAzBwevgIfEjKnuENsUJbqfTQAr
	4RTwlLhxrwXMFgIqmX+xk2kCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEh90x6
	B+OqBotDjAIcjEo8vBy5C4KFWBPLiitzDzFKcDArifCeywIK8aYkVlalFuXHF5XmpBYfYpTm
	YFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYFzYKqL+brqAwaH7k/fzmhluiD91ZU6rshz7
	pk+vpxyWnCiUuPCW9s0UqVVCKnUZQvOXX7E62Hhy3qZCHc5ah2qf2bdm/rq1c3qXqP//dkm3
	rTeqjx5mi21aorhwZ+l1vU2LhadOPacceCn4q8GU34/O3MmYmpJfn7xi196QCInie/tncMke
	d7qhxFKckWioxVxUnAgAulXAPDUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove runtime checks for pdata sanity from exynos_tmu_initialize().

The current values hardcoded in pdata will never trigger the checks
and checking itself is not proper.  The checks in question are done
at runtime in a production code for data that is hardcoded inside
driver during development time and later it doesn't change.  Such
data should be verified during development and review time (i.e. by
a script parsing relevant data from exynos_tmu_data.c, one can also
argue that verification to be done is so simple that the review by
a maintainer should be enough).

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
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
index 1c64508..f061580 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -166,23 +166,10 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
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

