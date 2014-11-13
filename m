Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaKMRDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50827 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaKMRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:31 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-d6-5464e461fe33
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
Subject: [PATCH 5/8] thermal:cpu cooling:tegra: Provide deferred probing for
 tegra driver
Date: Thu, 13 Nov 2014 18:02:42 +0100
Message-id: <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd3EJykhBlNfWFpsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbfHm4WZGi8u75rBZfO49wmjR+WUWm8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5LFu2ltmjwOTz7F69Da/Y/P4
	dmYii0ffllWMHk9/7GX2+LxJzmPj3NAA7igum5TUnMyy1CJ9uwSujOMbFrMVfOKoeLxtO2MD
	4272LkYODgkBE4kD91K7GDmBTDGJC/fWs4HYQgLTGSU6jtZ3MXIB2V1MEqc/32MHSbAJ6El8
	vvuUCcQWEfCWeL1vOiNIEbPAaxaJQz8awIYKC0RLvGyqBalhEVCVWLPmFyOIzSvgJnHz6VU2
	iGWKEt3PJoDZnALuEkdPfGKHWNbMKPG5bxbrBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1
	kvNzNzGCg/yZ9A7GVQ0WhxgFOBiVeHhfsKSECLEmlhVX5h5ilOBgVhLhrb4PFOJNSaysSi3K
	jy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cAoM1no4P49i+yfVrq1yT1M
	WttrHnNkWq/R7aDmP2WH8uMe+b5eco6pS2Gmx4wQJi/HDbGpqf47nsoFpD/5XsXo+ydk9bNH
	65LOmykdyFjFNC+qfcGDue+zV74QmMWZYzJnwdRTLXKNQoZGNZc99xbLx5x/vNJsy4sUoUSt
	RKfjzh9OBac93ZSsxFKckWioxVxUnAgAEOB7dW4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU freq is used as a thermal zone cooling device, one needs to wait
until cpufreq subsystem is properly initialized.

This code is similar to the one already available in imx_thermal.c file.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/tegra_soctherm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soctherm.c
index 70f7e9e..9c5aaa4 100644
--- a/drivers/thermal/tegra_soctherm.c
+++ b/drivers/thermal/tegra_soctherm.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/thermal.h>
+#include <linux/cpufreq.h>
 
 #include <soc/tegra/fuse.h>
 
@@ -346,6 +347,12 @@ static int tegra_soctherm_probe(struct platform_device *pdev)
 
 	const struct tegra_tsensor *tsensors = t124_tsensors;
 
+#ifdef CONFIG_CPU_THERMAL
+	if (!cpufreq_get_current_driver()) {
+		dev_dbg(&pdev->dev, "no cpufreq driver!");
+		return -EPROBE_DEFER;
+	}
+#endif
 	tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
 	if (!tegra)
 		return -ENOMEM;
-- 
2.0.0.rc2

