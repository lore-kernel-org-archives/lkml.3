Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3LTSsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:48:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52447 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3LTSr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:47:59 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-90-52b490de3217
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v2 1/9] ARM: EXYNOS: cpuidle: fix AFTR mode check
Date: Fri, 20 Dec 2013 19:47:23 +0100
Message-id: <1387565251-7051-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd17E7YEGTz+xGexccZ6Vot5n2Ut
	ehdcZbM42/SG3WLnw7dsFpd3zWGz+Nx7hNFixvl9TBa/v/9jtThz+hKrA5fHplWdbB53ru1h
	8zg/YyGjx5ar7SwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbFwanHBVr6K9xOnsDcwfuPu
	YuTgkBAwkXjSXtjFyAlkiklcuLeeDcQWEpjOKPHoknkXIxeQ3cUkcebQVFaQBJuAlcTE9lWM
	ILaIgKjE5d0TWECKmAXamSRuzutgBkkICzhKTJu5gRlkAYuAqkTPvkQQk1fAXaKlxQJil6JE
	97MJYLs4BTwkZr9azgSx113iRNdv5gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BAfdM+kdjKsaLA4xCnAwKvHwSkRuCRJiTSwrrsw9xCjBwawkwnuzDSjEm5JYWZValB9fVJqT
	WnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBcdKtA9y3Lsh/NOj64HvovGBre3dm
	pPqdVUmbfyU2RbSYh/k0Rqa7V3mXfFc6zb3r1Tv5yjn+n3csE2W7u7Rh+Y9zqpUOOzLk5cRt
	66WZe1a+8Q24f2Cfae7pqaFTbd3nOAR++HYz4nfzuyOBt0XD5ydzNwjFhpqa3zWdJ8tVfDxy
	3p+sU5+MlViKMxINtZiLihMBl0zlczYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EXYNOS cpuidle driver code assumes that cpuidle core will handle
dev->state_count smaller than drv->state_count but currently this is
untrue (dev->state_count is used only for handling cpuidle state sysfs
entries and drv->state_count is used for all other cases) and will not
be fixed in the future as dev->state_count is planned to be removed.

Fix the issue by checking for the max supported idle state in AFTR
state's ->enter handler (exynos4_enter_lowpower()) and entering AFTR
mode only when cores other than CPU0 are offline.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/cpuidle.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index da65b03..f57cb91 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -172,8 +172,8 @@ static int exynos4_enter_lowpower(struct cpuidle_device *dev,
 {
 	int new_index = index;
 
-	/* This mode only can be entered when other core's are offline */
-	if (num_online_cpus() > 1)
+	/* AFTR can only be entered when cores other than CPU0 are offline */
+	if (num_online_cpus() > 1 || dev->cpu != 0)
 		new_index = drv->safe_state_index;
 
 	if (new_index == 0)
@@ -235,10 +235,6 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
 		device = &per_cpu(exynos4_cpuidle_device, cpu_id);
 		device->cpu = cpu_id;
 
-		/* Support IDLE only */
-		if (cpu_id != 0)
-			device->state_count = 1;
-
 		ret = cpuidle_register_device(device);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to register cpuidle device\n");
-- 
1.8.2.3

