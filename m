Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbaKMRDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50840 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbaKMRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:37 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-dc-5464e4673151
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
Subject: [PATCH 6/8] thermal:cpu cooling:ti: Provide deferred probing for ti
 drivers
Date: Thu, 13 Nov 2014 18:02:43 +0100
Message-id: <1415898165-27406-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQd30JykhBrcblSw2zljPajH/yjVW
	i9OnFrBanHv1iMXibXOxxavDuxgt3jzitnjzcDOjxeVdc9gsPvceYbTo/DKLzeLB1WlsFk8e
	9rFZvDrYxmLxc9c8FotjJ2awOgh4PNl0kdFj56y77B6L97xk8lg37S2zx4HJ51g9epvfsXl8
	OzORxaNvyypGj6c/9jJ7fN4k57FxbmgAdxSXTUpqTmZZapG+XQJXxs2Za1gKZnNWvF1yl7mB
	8T57FyMnh4SAicSy+bcYIWwxiQv31rN1MXJxCAlMZ5Q42AeREBLoYpL4OcUGxGYT0JP4fPcp
	E4gtIuAt8XrfdEaQBmaB1ywSh340gE0VFgiT2LXjExuIzSKgKvHi9BqgIg4OXgE3iZktGRDL
	FCW6n00AK+EUcJc4euITO8TiZkaJz32zWCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERzmz6R3MK5qsDjEKMDBqMTD+4IlJUSINbGsuDL3EKMEB7OSCG/1faAQb0piZVVqUX58
	UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGxhWLTotsuL11m6f4Sp2YS7r1
	Ua+NjOMlBP1Mt30rqE58nVntadlXFjsnz+pSoriFCsNfWVY2IyWe0v4v3MJ+6+Ms3dalzG5w
	6ly10/iAr9C+N4s3lxjvfz+NjW/vjYMnLiaJNzOG2RtMsujie/107qZV6dk32esqr3ga2+Wp
	J3nX7NA7sF1UiaU4I9FQi7moOBEAnj2VqW8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU freq is used as a thermal zone cooling device, one needs to wait
until cpufreq subsystem is properly initialized.

This code is similar to the one already available in imx_thermal.c file.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 634b6ce..0ac5ead 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -40,6 +40,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 #include <linux/io.h>
+#include <linux/cpufreq.h>
 
 #include "ti-bandgap.h"
 
@@ -1196,6 +1197,12 @@ int ti_bandgap_probe(struct platform_device *pdev)
 	struct ti_bandgap *bgp;
 	int clk_rate, ret = 0, i;
 
+#ifdef CONFIG_CPU_THERMAL
+	if (!cpufreq_get_current_driver()) {
+		dev_dbg(&pdev->dev, "no cpufreq driver!");
+		return -EPROBE_DEFER;
+	}
+#endif
 	bgp = ti_bandgap_build(pdev);
 	if (IS_ERR(bgp)) {
 		dev_err(&pdev->dev, "failed to fetch platform data\n");
-- 
2.0.0.rc2

