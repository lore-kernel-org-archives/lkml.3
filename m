Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaEUUhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:37:39 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:54319 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbaEUUhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:37:37 -0400
Message-ID: <1400704654.30334.22.camel@x220>
Subject: [PATCH] PM / devfreq: remove checks for CONFIG_EXYNOS_ASV
From: Paul Bolle <pebolle@tiscali.nl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 22:37:34 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2014 20:37:35.0387 (UTC) FILETIME=[7F709EB0:01CF7534]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks for CONFIG_EXYNOS_ASV were added in v3.3. But the related Kconfig
symbol has never been added to the tree. Remove these checks, as they
always evaluate to false.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) I do not really care much for this patch. Two years is not very long
for dead code to remain in the tree. There is, however, a trivial issue
that makes this patch stand out from the other patches in my current
sweep of the tree for Kconfig related problems.

See, here the use of an unknown Kconfig macro hides an obvious typo: it
should either be "exynos_result_of_asv" or "exynos4_result_of_asv", but
not both. Ie, this almost certainly wouldn't have compiled even if the
Kconfig symbol EXYNOS_ASV would have been part of the tree.

2) So this makes me wonder whether there are any guidelines for using
Kconfig macros before the related Kconfig symbols are merged?

 drivers/devfreq/Kconfig              |  3 +--
 drivers/devfreq/exynos/exynos4_bus.c | 13 -------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 7d2f43550700..fd985630ad7d 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -75,8 +75,7 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 	  and Exynos4212/4412 memory interface and bus (vdd_mif + vdd_int).
 	  It reads PPMU counters of memory controllers and adjusts
 	  the operating frequencies and voltages with OPP support.
-	  To operate with optimal voltages, ASV support is required
-	  (CONFIG_EXYNOS_ASV).
+	  This does net yet operate with optimal voltages.
 
 config ARM_EXYNOS5_BUS_DEVFREQ
 	bool "ARM Exynos5250 Bus DEVFREQ Driver"
diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index e07b0c68c715..c12911a0915d 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -25,11 +25,6 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 
-/* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
-#ifdef CONFIG_EXYNOS_ASV
-extern unsigned int exynos_result_of_asv;
-#endif
-
 #include <mach/map.h>
 
 #include "exynos4_bus.h"
@@ -837,11 +832,7 @@ static int exynos4210_init_tables(struct busfreq_data *data)
 		data->top_divtable[i] = tmp;
 	}
 
-#ifdef CONFIG_EXYNOS_ASV
-	tmp = exynos4_result_of_asv;
-#else
 	tmp = 0; /* Max voltages for the reliability of the unknown */
-#endif
 
 	pr_debug("ASV Group of Exynos4 is %d\n", tmp);
 	/* Use merged grouping for voltage */
@@ -922,11 +913,7 @@ static int exynos4x12_init_tables(struct busfreq_data *data)
 		data->dmc_divtable[i] = tmp;
 	}
 
-#ifdef CONFIG_EXYNOS_ASV
-	tmp = exynos4_result_of_asv;
-#else
 	tmp = 0; /* Max voltages for the reliability of the unknown */
-#endif
 
 	if (tmp > 8)
 		tmp = 0;
-- 
1.9.0

