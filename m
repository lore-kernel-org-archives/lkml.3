Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaGaRLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:11:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41796 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaGaRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:11:39 -0400
X-AuditID: cbfee61a-f79e46d00000134f-3d-53da78c96c11
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v3 3/8] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_initialize()
Date: Thu, 31 Jul 2014 19:11:01 +0200
Message-id: <1406826667-2289-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jAd2TFbeCDR7OELZouBpisXHGelaL
	Nft/MlmcbXrDbnF51xw2i8+9RxgtZpzfx2Rx5vQlVosnD/vYLNbPeM3iwOWxeM9LJo8tV9tZ
	PPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBk7X81gKzgoVHFy2iqmBsbt/F2MnBwS
	AiYS93e2M0LYYhIX7q1n62Lk4hASWMQosfrZUSini0ni4O2LzCBVbAJWEhPbV4F1iAjoSdx4
	8YQJpIhZ4DiTxM/f54E6ODiEBVIl+g9XgtSwCKhKLF74kw3E5hVwl1iy9DMTxDZFie5nE8Di
	nAIeEgfaZ4DZQkA1fzedZJ3AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDIPZPa
	wbiyweIQowAHoxIP74zwW8FCrIllxZW5hxglOJiVRHhdyoFCvCmJlVWpRfnxRaU5qcWHGKU5
	WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGC2fsNyUWH5L3C/ivxP780jjmP85S6eHX+w/
	zCPT16L8p1FE/KVV2NaeSc2NE/S/BmzcG8xR254R+3IXw+mSp3aeBVO6gk6siU5etjA+/02t
	/kMeZ+79W052n+c/qKWUs0p27ZcydrnJa949dZP0zTtzsFTX+YW1zEW+WZy2OyenL6mSz2m2
	UmIpzkg01GIuKk4EADNYUhc1AgAA
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
index 4a55f11..b9bffad 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -201,23 +201,10 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			(pdata->efuse_value >> reg->triminfo_85_shift) &
 			EXYNOS_TMU_TEMP_MASK;
 
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

