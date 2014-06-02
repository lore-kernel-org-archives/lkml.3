Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaFBMh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:37:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24419 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaFBMhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:37:23 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-d1-538c7001838c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 5/7] ARM: EXYNOS: PM: use c15resume firmware method if
 secure firmware is enabled
Date: Mon, 02 Jun 2014 14:35:41 +0200
Message-id: <1401712543-14281-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQV3Ggp5gg6ff2C02zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZU853
	MRU84aiYeKaRuYFxHXsXIyeHhICJRNOEK6wQtpjEhXvr2boYuTiEBKYzSpyevBnK6WKSaLv/
	nwWkik3ASmJi+ypGEFtEQE2iZ/FWRpAiZoG9zBJLuzeBjRUWSJNobDnH1MXIwcEioCoxdX0N
	SJhXwENiYXcPI8Q2RYnuZxPYQGxOAU+Jlfcegl0hBFSz79UupgmMvAsYGVYxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBIflM6kdjCsbLA4xCnAwKvHw/lTvCRZiTSwrrsw9xCjBwawkwrvU
	AijEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBMWLvNevp
	Sz/q/GXZa/H4ZNTUsL+Fat5sn/YkXa7gY/r13/FiQlP4Xpsrrw/+f+xxac0mC0bWqz7T7oUd
	nfez9+JGwVNreQsZuVO0ky8JLmVf22Muob/F9a7DItNZhYHPsuxv6HbmvS/466bxIlxlS6mC
	4c7fvB1ZDgtCmjxzyqqzLT6o5rDwK7EUZyQaajEXFScCAM5JirVHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use c15resume firmware method instead of accessing the registers
directly in exynos_cpu_restore_register() if secure firmware is
enabled.  This affects both PM resume method and cpuidle AFTR mode.

This patch shouldn't cause any functionality changes on boards that
don't use secure firmware.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/pm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index cf09383..aeff99e 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -26,6 +26,7 @@
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/smp_scu.h>
 #include <asm/suspend.h>
+#include <asm/firmware.h>
 
 #include <plat/pm-common.h>
 #include <plat/pll.h>
@@ -232,6 +233,9 @@ static void exynos_cpu_restore_register(void)
 {
 	unsigned long tmp;
 
+	if (call_firmware_op(c15resume, save_arm_register) == 0)
+		return;
+
 	/* Restore Power control register */
 	tmp = save_arm_register[0];
 
-- 
1.8.2.3

