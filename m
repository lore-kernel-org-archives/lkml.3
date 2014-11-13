Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaKMRDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50798 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaKMRDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:09 -0500
X-AuditID: cbfee61a-f79c06d000004e71-4d-5464e44b8eb8
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
Subject: [PATCH 1/8] thermal:cpu cooling:armada: Provide deferred probing for
 armada driver
Date: Thu, 13 Nov 2014 18:02:38 +0100
Message-id: <1415898165-27406-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQV3vJykhBuu6hSw2zljPajH/yjVW
	i9OnFrBanHv1iMXibXOxxavDuxgt3jzitnjzcDOjxeVdc9gsPvceYbTo/DKLzeLB1WlsFk8e
	9rFZvDrYxmLxc9c8FotjJ2awOgh4PNl0kdFj56y77B6L97xk8lg37S2zx4HJ51g9epvfsXl8
	OzORxaNvyypGj6c/9jJ7fN4k57FxbmgAdxSXTUpqTmZZapG+XQJXxodVN1kL/nBUvJ26krWB
	8Qh7FyMHh4SAicT149ZdjJxAppjEhXvr2boYuTiEBKYzSvTs/c0C4XQxSfRtXMoIUsUmoCfx
	+e5TJhBbRMBb4vW+6YwgRcwCr1kkDv1oAJsqLBArMX+FAEgNi4CqxKLpr1hAbF4BN4kPj++x
	QWxTlOh+NgHM5hRwlzh64hM7xLJmRonPfbNYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRHObPpHYwrmywOMQowMGoxMP7giUlRIg1say4MvcQowQHs5IIb/V9oBBvSmJlVWpR
	fnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGyu9/Oy63WpcmZq4SeD3h
	8t05bGKXjs1f+oxVcKXbZeEXr0Jqf6kYCmy+YsN+PMTux/QEEeP0+SzB3NZRM+vSW8x1t11m
	07nM/ks9Xh0Y+Rc5VDgWGrjp/uLX2PVlwlIhk3y7m2+qD28/0PdgWdnCwANtcvvPivZMaNt/
	J9bDVbifi1t//V8lluKMREMt5qLiRAAlYYvXbwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU freq is used as a thermal zone cooling device, one needs to wait
until cpufreq subsystem is properly initialized.

This code is similar to the one already available in imx_thermal.c file.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/armada_thermal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thermal/armada_thermal.c b/drivers/thermal/armada_thermal.c
index 9d1420a..1b5d15d 100644
--- a/drivers/thermal/armada_thermal.c
+++ b/drivers/thermal/armada_thermal.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/of_device.h>
 #include <linux/thermal.h>
+#include <linux/cpufreq.h>
 
 #define THERMAL_VALID_MASK		0x1
 
@@ -280,6 +281,12 @@ static int armada_thermal_probe(struct platform_device *pdev)
 	struct armada_thermal_priv *priv;
 	struct resource *res;
 
+#ifdef CONFIG_CPU_THERMAL
+	if (!cpufreq_get_current_driver()) {
+		dev_dbg(&pdev->dev, "no cpufreq driver!");
+		return -EPROBE_DEFER;
+	}
+#endif
 	match = of_match_device(armada_thermal_id_table, &pdev->dev);
 	if (!match)
 		return -ENODEV;
-- 
2.0.0.rc2

