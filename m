Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaKSP5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:57:45 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:44328 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbaKSP5l (ORCPT
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
Subject: [PATCH 4/7] ARM: shmobile: R-Mobile: Special-case PM domains containing SBSCs
Date: Wed, 19 Nov 2014 16:57:31 +0100
Message-Id: <1416412654-6508-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
References: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a special case for PM domains containing a memory controller like
the SDRAM Bus State Controller (SBSC). Such a PM domain must not be
turned off if SDRAM is in use.

On sh73a0 PM domains A4BC0 and A4BC1 each contain an SDRAM Bus State
Controller (SBSC1 resp. SBSC2). On r8a73a4 PM domain A3BC contains a DDR
Bus Controller (DBSC).  In both cases, there are no other devices in
these PM domains, so they were eligible for power down, crashing the
system.

On r8a7740 the DDR3 Bus State Controller (DBSC3) is located in A4S,
whose child domain A3SM contains the CPU core. Hence A4S is never turned
off, and no crash happened.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/pm-rmobile.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 774a8e276049a202..4bae656a83b4fca3 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -231,6 +231,7 @@ enum pd_types {
 	PD_CPU,
 	PD_CONSOLE,
 	PD_DEBUG,
+	PD_SBSC,
 };
 
 #define MAX_NUM_SPECIAL_PDS	16
@@ -242,6 +243,14 @@ static struct special_pd {
 
 static unsigned int num_special_pds __initdata;
 
+static const struct of_device_id special_ids[] __initconst = {
+	{ .compatible = "arm,coresight-etm3x", .data = (void *)PD_DEBUG },
+	{ .compatible = "renesas,dbsc-r8a73a4", .data = (void *)PD_SBSC, },
+	{ .compatible = "renesas,dbsc3-r8a7740", .data = (void *)PD_SBSC, },
+	{ .compatible = "renesas,sbsc-sh73a0", .data = (void *)PD_SBSC, },
+	{ /* sentinel */ },
+};
+
 static void __init add_special_pd(struct device_node *np, enum pd_types type)
 {
 	unsigned int i;
@@ -277,6 +286,7 @@ static void __init add_special_pd(struct device_node *np, enum pd_types type)
 static void __init get_special_pds(void)
 {
 	struct device_node *np;
+	const struct of_device_id *id;
 
 	/* PM domains containing CPUs */
 	for_each_node_by_type(np, "cpu")
@@ -286,10 +296,9 @@ static void __init get_special_pds(void)
 	if (of_stdout)
 		add_special_pd(of_stdout, PD_CONSOLE);
 
-	/* PM domain containing Coresight-ETM */
-	np = of_find_compatible_node(NULL, NULL, "arm,coresight-etm3x");
-	if (np)
-		add_special_pd(np, PD_DEBUG);
+	/* PM domains containing other special devices */
+	for_each_matching_node_and_match(np, special_ids, &id)
+		add_special_pd(np, (enum pd_types)id->data);
 }
 
 static void __init put_special_pds(void)
@@ -344,6 +353,17 @@ static void __init rmobile_setup_pm_domain(struct device_node *np,
 		pd->suspend = rmobile_pd_suspend_busy;
 		break;
 
+	case PD_SBSC:
+		/*
+		 * This domain contains the SDRAM Bus State Controller and
+		 * therefore it should only be turned off if SDRAM is not in
+		 * use.
+		 */
+		pr_debug("PM domain %s contains SBSC\n", name);
+		pd->gov = &pm_domain_always_on_gov;
+		pd->suspend = rmobile_pd_suspend_busy;
+		break;
+
 	case PD_NORMAL:
 		break;
 	}
-- 
1.9.1

