Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaKMRDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58417 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaKMRDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:20 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-ca-5464e45601e1
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
Subject: [PATCH 3/8] thermal:cpu cooling:rcar: Provide deferred probing for
 rcar driver
Date: Thu, 13 Nov 2014 18:02:40 +0100
Message-id: <1415898165-27406-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQd2wJykhBs/+S1tsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbfHm4WZGi8u75rBZfO49wmjR+WUWm8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5LFu2ltmjwOTz7F69Da/Y/P4
	dmYii0ffllWMHk9/7GX2+LxJzmPj3NAA7igum5TUnMyy1CJ9uwSujAO7njEWXOCouHPtNFMD
	4zT2LkZODgkBE4mlT2+zQthiEhfurWfrYuTiEBKYzijxZ+YisISQQBeTxIf/piA2m4CexOe7
	T5lAbBEBb4nX+6YzgjQwC7xmkTj0owFsqrBApMTFG+1Akzg4WARUJd5+8wEJ8wq4SUztO8wG
	sUxRovvZBDCbU8Bd4uiJT+wQi5sZJT73zWKdwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpe
	cn7uJkZwmD+T3sG4qsHiEKMAB6MSD+8LlpQQIdbEsuLK3EOMEhzMSiK81feBQrwpiZVVqUX5
	8UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhgTZRO+TjkR+tD4zPSSh/Pc
	vEKPRP73tTwlNXvD4l9mXzRf5r84+Xyu3NF3Eycss9H9Ge7oq9w6rfTmR01r2fNJpj5O9WtK
	HHaIT7S9OM1R4h0Xz+Wg7K2erjVCTmLJmbNn1+5cLv8p5VTl7ANPxRi3dCUaPZC8bf/49zVP
	/oCyry2BE3q3Kp5RYinOSDTUYi4qTgQAhq+Z6W8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU freq is used as a thermal zone cooling device, one needs to wait
until cpufreq subsystem is properly initialized.

This code is similar to the one already available in imx_thermal.c file.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/rcar_thermal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 8803e69..b268b4d 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/thermal.h>
+#include <linux/cpufreq.h>
 
 #define IDLE_INTERVAL	5000
 
@@ -373,6 +374,12 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 	int ret = -ENODEV;
 	int idle = IDLE_INTERVAL;
 
+#ifdef CONFIG_CPU_THERMAL
+	if (!cpufreq_get_current_driver()) {
+		dev_dbg(&pdev->dev, "no cpufreq driver!");
+		return -EPROBE_DEFER;
+	}
+#endif
 	common = devm_kzalloc(dev, sizeof(*common), GFP_KERNEL);
 	if (!common)
 		return -ENOMEM;
-- 
2.0.0.rc2

