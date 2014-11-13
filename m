Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaKMRDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58434 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaKMRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:25 -0500
X-AuditID: cbfee61a-f79c06d000004e71-5f-5464e45b64b4
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 4/8] thermal:cpu cooling:spear: Provide deferred probing for
 spear driver
Date: Thu, 13 Nov 2014 18:02:41 +0100
Message-id: <1415898165-27406-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQd2YJykhBnOms1tsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbfHm4WZGi8u75rBZfO49wmjR+WUWm8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5LFu2ltmjwOTz7F69Da/Y/P4
	dmYii0ffllWMHk9/7GX2+LxJzmPj3NAA7igum5TUnMyy1CJ9uwSujNbLt5gLujgrPs7dwdTA
	eJK9i5GTQ0LAROLfvJMsELaYxIV769m6GLk4hASmM0os3/OXHcLpYpJY1fmaEaSKTUBP4vPd
	p0wgtoiAt8TrfdMZQYqYBV6zSBz60QA2VlggWuLo/n6gBAcHi4CqxO5z1iBhXgE3ifuTFrFC
	bFOU6H42gQ3E5hRwlzh64hPUsmZGic99s1gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iREc6M+kdjCubLA4xCjAwajEw/uCJSVEiDWxrLgy9xCjBAezkghv9X2gEG9KYmVValF+
	fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsbE5+I18u67J+mG/D68a7NL
	sL886yfri2/LznEt/XNcZY5P1Yo7XU++/4vY8sCu4cz5GROU+9hagpv/bHK9rHy/+8GDn89Y
	rA4aOxg93/7yUn+q0e5tAT9uGHMySRf6d618YHyWZ2Puvwv3uN85C+zlvC0wP//jOZcuLZPN
	x/tdilsmfbzp57pViaU4I9FQi7moOBEA7PnmtnACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU freq is used as a thermal zone cooling device, one needs to wait
until cpufreq subsystem is properly initialized.

This code is similar to the one already available in imx_thermal.c file.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/spear_thermal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index 1e2193f..fd8fadf5 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/thermal.h>
+#include <linux/cpufreq.h>
 
 #define MD_FACTOR	1000
 
@@ -107,6 +108,12 @@ static int spear_thermal_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret = 0, val;
 
+#ifdef CONFIG_CPU_THERMAL
+	if (!cpufreq_get_current_driver()) {
+		dev_dbg(&pdev->dev, "no cpufreq driver!");
+		return -EPROBE_DEFER;
+	}
+#endif
 	if (!np || !of_property_read_u32(np, "st,thermal-flags", &val)) {
 		dev_err(&pdev->dev, "Failed: DT Pdata not passed\n");
 		return -EINVAL;
-- 
2.0.0.rc2

