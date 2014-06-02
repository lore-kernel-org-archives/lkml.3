Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaFBMiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:38:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44712 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaFBMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:38:13 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-1f-538c70337ca2
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
Subject: [PATCH v2 7/7] ARM: EXYNOS: cpuidle: add secure firmware support to
 AFTR mode code
Date: Mon, 02 Jun 2014 14:35:43 +0200
Message-id: <1401712543-14281-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQV3jgp5gg0/njSw2zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZC5ZN
	ZC/4KVTxsmcRcwPjK/4uRk4OCQETiblNC9ghbDGJC/fWs3UxcnEICUxnlLhz5wcjhNPFJDHj
	7llWkCo2ASuJie2rGEFsEQE1iZ7FW8GKmAX2Mkss7d4ENkpYIFZizZ8nLCA2i4CqxO3568Hi
	vAIeEtMWfGKCWKco0f1sAhuIzSngKbHy3kOwBUJANfte7WKawMi7gJFhFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwYD6T3sG4qsHiEKMAB6MSD+8P9Z5gIdbEsuLK3EOMEhzMSiK8Sy2A
	QrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhjVW5Qus0o7
	r8556Juz7tynD/yP1OfO/NWx/PHF/awqzB+OPNuU7fXGW2/nU6+8hZoH0iWalRcZBfIFz/y7
	9cRa3qIvFuVZjxbs+Tqx9ujGCaHfJZcZ2tfZTJy4uEYzXO5r5+7TayqEps3XZn3/V2LuA7eP
	XRM39W1p2P9+StHLQr34swLiT9aeV2Ipzkg01GIuKk4EAD3uT29IAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use do_idle firmware method instead of cpu_do_idle() on boards with
  secure firmware enabled.

* Use sysram_ns_base_addr + 0x24 address for exynos_boot_vector_addr()
  and sysram_ns_base_addr + 0x20 one for exynos_boot_vector_flag() on
  boards with secure firmware enabled.

This patch fixes hang on an attempt to enter AFTR mode for TRATS2
board (which uses EXYNOS4412 SoC with secure firmware enabled).

This patch shouldn't cause any functionality changes on boards that
don't use secure firmware.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/pm.c        | 8 ++++++--
 drivers/cpuidle/cpuidle-exynos.c | 7 ++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 0fb9a5a..62a0a5e 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -169,7 +169,9 @@ int exynos_cluster_power_state(int cluster)
 
 static inline void __iomem *exynos_boot_vector_addr(void)
 {
-	if (samsung_rev() == EXYNOS4210_REV_1_1)
+	if (firmware_run())
+		return sysram_ns_base_addr + 0x24;
+	else if (samsung_rev() == EXYNOS4210_REV_1_1)
 		return S5P_INFORM7;
 	else if (samsung_rev() == EXYNOS4210_REV_1_0)
 		return sysram_base_addr + 0x24;
@@ -178,7 +180,9 @@ static inline void __iomem *exynos_boot_vector_addr(void)
 
 static inline void __iomem *exynos_boot_vector_flag(void)
 {
-	if (samsung_rev() == EXYNOS4210_REV_1_1)
+	if (firmware_run())
+		return sysram_ns_base_addr + 0x20;
+	else if (samsung_rev() == EXYNOS4210_REV_1_1)
 		return S5P_INFORM6;
 	else if (samsung_rev() == EXYNOS4210_REV_1_0)
 		return sysram_base_addr + 0x20;
diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
index 7c01512..f90a4a0 100644
--- a/drivers/cpuidle/cpuidle-exynos.c
+++ b/drivers/cpuidle/cpuidle-exynos.c
@@ -17,13 +17,18 @@
 #include <asm/proc-fns.h>
 #include <asm/suspend.h>
 #include <asm/cpuidle.h>
+#include <asm/firmware.h>
 
 static void (*exynos_enter_aftr)(void);
 
 static int idle_finisher(unsigned long flags)
 {
 	exynos_enter_aftr();
-	cpu_do_idle();
+	if (firmware_run())
+		/* no need to check the return value on EXYNOS SoCs */
+		call_firmware_op(do_idle, FW_DO_IDLE_AFTR);
+	else
+		cpu_do_idle();
 
 	return 1;
 }
-- 
1.8.2.3

