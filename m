Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaKMRDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50854 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395AbaKMRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:42 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-e0-5464e46d7779
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
Subject: [PATCH 7/8] thermal:core:fix: Initialize the max_state variable to 0
Date: Thu, 13 Nov 2014 18:02:44 +0100
Message-id: <1415898165-27406-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jQd3cJykhBqtnCllsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbfHm4WZGi8u75rBZfO49wmjR+WUWm8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5LFu2ltmjwOTz7F69Da/Y/P4
	dmYii0ffllWMHk9/7GX2+LxJzmPj3NAA7igum5TUnMyy1CJ9uwSujNYllxkLlnNXNF7ewt7A
	uJezi5GTQ0LAROLrxL2sELaYxIV769m6GLk4hASmM0ps673PCuF0MUn0H3vFBFLFJqAn8fnu
	UzBbRMBb4vW+6YwgRcwCr1kkDv1oYAdJCAv4SnQvb2cDsVkEVCUerugAs3kF3CQ6mn6zQKxT
	lOh+NgEszingLnH0xCd2iG3NjBKf+2axTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjONSfSe9gXNVgcYhRgINRiYf3BUtKiBBrYllxZe4hRgkOZiUR3ur7QCHelMTKqtSi/Pii
	0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MQqKSX9J1vR7Znvywd2auc6nu
	SfOS4/e7RVu6j/AUW5XdWCftqfnvm2vyxucq91IYGJemu1+UPe6gWW/FnB6hbmm2rjhajNNs
	lbStj6rPvdsKjEdYghqKD/uf2FK79HpQrFPrLZ8/93QNJuSxHJgo9dlmjU3hvUm33kzkue25
	pTY3/+LdNwxKLMUZiYZazEXFiQCbR2xncQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointer to the uninitialized max_state variable is passed to get the
maximal cooling state.
For CPU cooling device (cpu_cooling.c) the cpufreq_get_max_state() is
called, which even when error occurs will return the max_state variable
unchanged.
Since error for ->get_max_state() is not checked, the automatically
allocated value of max_state is used for (upper > max_state) comparison.
For any possible max_state value it is very unlikely that it will be less
than upper.
As a consequence, the cooling device is bind even without the backed
cpufreq table initialized.

This initialization will prevent from accidental binding trip points to
cpu freq cooling frequencies when cpufreq driver itself is not yet fully
initialized.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/thermal_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 43b9070..413daa4 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -927,7 +927,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
-	unsigned long max_state;
+	unsigned long max_state = 0;
 	int result;
 
 	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
-- 
2.0.0.rc2

