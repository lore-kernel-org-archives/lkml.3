Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaEELAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:00:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45819 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaEELAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:00:37 -0400
X-AuditID: cbfee61b-b7f766d00000646c-10-53676f54f13e
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
Subject: [PATCH 7/7] ARM: EXYNOS: cpuidle: add secure firmware support to AFTR
 mode code
Date: Mon, 05 May 2014 12:57:19 +0200
Message-id: <1399287439-31376-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd2Q/PRgg59PuCw2zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZzcuv
	shdcEKp4/7GDsYHxIH8XIyeHhICJxL93y5ggbDGJC/fWs3UxcnEICSxilFg19xczSEJIoItJ
	oukuJ4jNJmAlMbF9FSOILSKgJtGzeCsjSAOzwF5miaXdm9hBEsICURKHzrezgdgsAqoSbW9P
	gMV5BTwkHjdOgtqmKNH9bAJYDaeAp8TSzY+hlnlIbHjbzjaBkXcBI8MqRtHUguSC4qT0XCO9
	4sTc4tK8dL3k/NxNjOCwfCa9g3FVg8UhRgEORiUe3gTm9GAh1sSy4srcQ4wSHMxKIrzZiUAh
	3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjD65Jzk0zAzj
	81NsTv527Oy9M0+ZZ5pqW0tLyLmKwuoo3td64oUvlZld1q+5cLunb8ZXp5jfKetsmJesu8bZ
	ZqihW+rKnnjImVVRK7JhyoGdiTVx/+oyBZxnHfRlktl6eP0005UlfiJGd/ieTjgzV8B356yX
	q+eyrlHgdnP1K/Y7u1Z7bjCjEktxRqKhFnNRcSIAGcP24UcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use do_idle firmware method instead of cpu_do_idle() on boards
  with secure firmware enabled.

* Use S5P_VA_SYSRAM_NS + 0x24 address for exynos_boot_vector_addr()
  and S5P_VA_SYSRAM_NS + 0x20 one for exynos_boot_vector_flag() on
  boards with secure firmware enabled.

This patch fixes hang on an attempt to enter AFTR mode for TRATS2
board (which uses EXYNOS4412 SoC with secure firmware enabled).

This patch shouldn't cause any functionality changes on boards that
don't use secure firmware.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/mach-exynos/pm.c        | 8 ++++++--
 drivers/cpuidle/cpuidle-exynos.c | 7 ++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 3922968..ba4cd05 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -104,7 +104,9 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 
 static inline void __iomem *exynos_boot_vector_addr(void)
 {
-	if (samsung_rev() == EXYNOS4210_REV_1_1)
+	if (firmware_run())
+		return S5P_VA_SYSRAM_NS + 0x24;
+	else if (samsung_rev() == EXYNOS4210_REV_1_1)
 		return S5P_INFORM7;
 	else if (samsung_rev() == EXYNOS4210_REV_1_0)
 		return S5P_VA_SYSRAM + 0x24;
@@ -113,7 +115,9 @@ static inline void __iomem *exynos_boot_vector_addr(void)
 
 static inline void __iomem *exynos_boot_vector_flag(void)
 {
-	if (samsung_rev() == EXYNOS4210_REV_1_1)
+	if (firmware_run())
+		return S5P_VA_SYSRAM_NS + 0x20;
+	else if (samsung_rev() == EXYNOS4210_REV_1_1)
 		return S5P_INFORM6;
 	else if (samsung_rev() == EXYNOS4210_REV_1_0)
 		return S5P_VA_SYSRAM + 0x20;
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

