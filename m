Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbaKSP7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:59:20 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:48213 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaKSP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:57:41 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/7] ARM: shmobile: R-Mobile: Consolidate rmobile_pd_suspend_*()
Date: Wed, 19 Nov 2014 16:57:29 +0100
Message-Id: <1416412654-6508-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
References: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the identical rmobile_pd_suspend_*() routines that just
return -EBUSY to prevent a PM domain from being powered down into a
single rmobile_pd_suspend_busy().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/pm-rmobile.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 5e01a28110e24034..3d383d3dcd4ec640 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -209,11 +209,10 @@ void rmobile_add_devices_to_domains(struct pm_domain_device data[],
 
 #else /* !CONFIG_ARCH_SHMOBILE_LEGACY */
 
-static int rmobile_pd_suspend_cpu(void)
+static int rmobile_pd_suspend_busy(void)
 {
 	/*
-	 * This domain contains the CPU core and therefore it should
-	 * only be turned off if the CPU is not in use.
+	 * This domain should not be turned off.
 	 */
 	return -EBUSY;
 }
@@ -227,16 +226,6 @@ static int rmobile_pd_suspend_console(void)
 	return console_suspend_enabled ? 0 : -EBUSY;
 }
 
-static int rmobile_pd_suspend_debug(void)
-{
-	/*
-	 * This domain contains the Coresight-ETM hardware block and
-	 * therefore it should only be turned off if the debug module is
-	 * not in use.
-	 */
-	return -EBUSY;
-}
-
 #define MAX_NUM_CPU_PDS		8
 
 static unsigned int num_cpu_pds __initdata;
@@ -310,17 +299,26 @@ static void __init rmobile_setup_pm_domain(struct device_node *np,
 	const char *name = pd->genpd.name;
 
 	if (pd_contains_cpu(np)) {
+		/*
+		 * This domain contains the CPU core and therefore it should
+		 * only be turned off if the CPU is not in use.
+		 */
 		pr_debug("PM domain %s contains CPU\n", name);
 		pd->gov = &pm_domain_always_on_gov;
-		pd->suspend = rmobile_pd_suspend_cpu;
+		pd->suspend = rmobile_pd_suspend_busy;
 	} else if (np == console_pd) {
 		pr_debug("PM domain %s contains serial console\n", name);
 		pd->gov = &pm_domain_always_on_gov;
 		pd->suspend = rmobile_pd_suspend_console;
 	} else if (np == debug_pd) {
+		/*
+		 * This domain contains the Coresight-ETM hardware block and
+		 * therefore it should only be turned off if the debug module is
+		 * not in use.
+		 */
 		pr_debug("PM domain %s contains Coresight-ETM\n", name);
 		pd->gov = &pm_domain_always_on_gov;
-		pd->suspend = rmobile_pd_suspend_debug;
+		pd->suspend = rmobile_pd_suspend_busy;
 	}
 
 	rmobile_init_pm_domain(pd);
-- 
1.9.1

