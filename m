Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaKMRDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48897 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaKMRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:14 -0500
X-AuditID: cbfee61a-f79c06d000004e71-52-5464e450fabd
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
Subject: [PATCH 2/8] thermal:cpu cooling:kirkwood: Provide deferred probing for
 kirkwood driver
Date: Thu, 13 Nov 2014 18:02:39 +0100
Message-id: <1415898165-27406-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQd2AJykhBqs7jC02zljPajH/yjVW
	i9OnFrBanHv1iMXibXOxxavDuxgt3jzitnjzcDOjxeVdc9gsPvceYbTo/DKLzeLB1WlsFk8e
	9rFZvDrYxmLxc9c8FotjJ2awOgh4PNl0kdFj56y77B6L97xk8lg37S2zx4HJ51g9epvfsXl8
	OzORxaNvyypGj6c/9jJ7fN4k57FxbmgAdxSXTUpqTmZZapG+XQJXxup3q5kLNnJWHNo4k7GB
	8Tt7FyMnh4SAicSkuZNYIWwxiQv31rN1MXJxCAlMZ5T4d7KFEcLpYpL4eOAOWBWbgJ7E57tP
	mUBsEQFvidf7poMVMQu8ZpE49KMBaCwHh7BAosTGOSUgNSwCqhJPVzUwg9i8Am4SXTdXskFs
	U5TofjYBzOYUcJc4euITO8SyZkaJz32zWCcw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERzoz6R2MK5ssDjEKMDBqMTD+4IlJUSINbGsuDL3EKMEB7OSCG/1faAQb0piZVVqUX58
	UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxrkxwqapjDoST1wKb7+ZHBo8
	32N345njmZP/3bKzWhymqmV1cdK6b/feK8SdcBHUM9Zdzp8ivsPmOZO+3Qvh0y9nMfxNe+yu
	fDZyhfB2B4cr/zZ0n5L723rMxvGVUlvmn8gHi99OuWlm17JHWan7O9/nOHt9a+lLi4r2CFrb
	Vi6+ffju/VW5FkosxRmJhlrMRcWJAD2tgtZwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU freq is used as a thermal zone cooling device, one needs to wait
until cpufreq subsystem is properly initialized.

This code is similar to the one already available in imx_thermal.c file.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/kirkwood_thermal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
index 3b034a0..e938291 100644
--- a/drivers/thermal/kirkwood_thermal.c
+++ b/drivers/thermal/kirkwood_thermal.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/thermal.h>
+#include <linux/cpufreq.h>
 
 #define KIRKWOOD_THERMAL_VALID_OFFSET	9
 #define KIRKWOOD_THERMAL_VALID_MASK	0x1
@@ -75,6 +76,12 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
 	struct kirkwood_thermal_priv *priv;
 	struct resource *res;
 
+#ifdef CONFIG_CPU_THERMAL
+	if (!cpufreq_get_current_driver()) {
+		dev_dbg(&pdev->dev, "no cpufreq driver!");
+		return -EPROBE_DEFER;
+	}
+#endif
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-- 
2.0.0.rc2

