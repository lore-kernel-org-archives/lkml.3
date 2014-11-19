Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaKSP6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:58:52 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:44942 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbaKSP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:57:43 -0500
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
Subject: [PATCH 3/7] ARM: shmobile: R-Mobile: Generalize adding/looking up special PM domains
Date: Wed, 19 Nov 2014 16:57:30 +0100
Message-Id: <1416412654-6508-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
References: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make adding special PM domains to an array, and looking them up
later, more generic, so it can be used for all special hardware blocks.
The type of PM domain is also stored, so rmobile_setup_pm_domain() can
use a switch() statement instead of a chain of if/else statements.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/pm-rmobile.c | 107 ++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 3d383d3dcd4ec640..774a8e276049a202 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -226,71 +226,89 @@ static int rmobile_pd_suspend_console(void)
 	return console_suspend_enabled ? 0 : -EBUSY;
 }
 
-#define MAX_NUM_CPU_PDS		8
+enum pd_types {
+	PD_NORMAL,
+	PD_CPU,
+	PD_CONSOLE,
+	PD_DEBUG,
+};
 
-static unsigned int num_cpu_pds __initdata;
-static struct device_node *cpu_pds[MAX_NUM_CPU_PDS] __initdata;
-static struct device_node *console_pd __initdata;
-static struct device_node *debug_pd __initdata;
+#define MAX_NUM_SPECIAL_PDS	16
 
-static void __init get_special_pds(void)
+static struct special_pd {
+	struct device_node *pd;
+	enum pd_types type;
+} special_pds[MAX_NUM_SPECIAL_PDS] __initdata;
+
+static unsigned int num_special_pds __initdata;
+
+static void __init add_special_pd(struct device_node *np, enum pd_types type)
 {
-	struct device_node *np, *pd;
 	unsigned int i;
+	struct device_node *pd;
 
-	/* PM domains containing CPUs */
-	for_each_node_by_type(np, "cpu") {
-		pd = of_parse_phandle(np, "power-domains", 0);
-		if (!pd)
-			continue;
+	pd = of_parse_phandle(np, "power-domains", 0);
+	if (!pd)
+		return;
 
-		for (i = 0; i < num_cpu_pds; i++)
-			if (pd == cpu_pds[i])
-				break;
-
-		if (i < num_cpu_pds) {
-			of_node_put(pd);
-			continue;
-		}
+	for (i = 0; i < num_special_pds; i++)
+		if (pd == special_pds[i].pd && type == special_pds[i].type)
+			break;
 
-		if (num_cpu_pds == MAX_NUM_CPU_PDS) {
-			pr_warn("Too many CPU PM domains\n");
-			of_node_put(pd);
-			continue;
-		}
+	if (i < num_special_pds) {
+		of_node_put(pd);
+		return;
+	}
 
-		cpu_pds[num_cpu_pds++] = pd;
+	if (num_special_pds == ARRAY_SIZE(special_pds)) {
+		pr_warn("Too many special PM domains\n");
+		of_node_put(pd);
+		return;
 	}
 
+	pr_debug("Special PM domain %s type %d for %s\n", pd->name, type,
+		 np->full_name);
+
+	special_pds[num_special_pds].pd = pd;
+	special_pds[num_special_pds].type = type;
+	num_special_pds++;
+}
+
+static void __init get_special_pds(void)
+{
+	struct device_node *np;
+
+	/* PM domains containing CPUs */
+	for_each_node_by_type(np, "cpu")
+		add_special_pd(np, PD_CPU);
+
 	/* PM domain containing console */
 	if (of_stdout)
-		console_pd = of_parse_phandle(of_stdout, "power-domains", 0);
+		add_special_pd(of_stdout, PD_CONSOLE);
 
 	/* PM domain containing Coresight-ETM */
 	np = of_find_compatible_node(NULL, NULL, "arm,coresight-etm3x");
 	if (np)
-		debug_pd = of_parse_phandle(np, "power-domains", 0);
+		add_special_pd(np, PD_DEBUG);
 }
 
 static void __init put_special_pds(void)
 {
 	unsigned int i;
 
-	for (i = 0; i < num_cpu_pds; i++)
-		of_node_put(cpu_pds[i]);
-	of_node_put(console_pd);
-	of_node_put(debug_pd);
+	for (i = 0; i < num_special_pds; i++)
+		of_node_put(special_pds[i].pd);
 }
 
-static bool __init pd_contains_cpu(const struct device_node *pd)
+static enum pd_types __init pd_type(const struct device_node *pd)
 {
 	unsigned int i;
 
-	for (i = 0; i < num_cpu_pds; i++)
-		if (pd == cpu_pds[i])
-			return true;
+	for (i = 0; i < num_special_pds; i++)
+		if (pd == special_pds[i].pd)
+			return special_pds[i].type;
 
-	return false;
+	return PD_NORMAL;
 }
 
 static void __init rmobile_setup_pm_domain(struct device_node *np,
@@ -298,7 +316,8 @@ static void __init rmobile_setup_pm_domain(struct device_node *np,
 {
 	const char *name = pd->genpd.name;
 
-	if (pd_contains_cpu(np)) {
+	switch (pd_type(np)) {
+	case PD_CPU:
 		/*
 		 * This domain contains the CPU core and therefore it should
 		 * only be turned off if the CPU is not in use.
@@ -306,11 +325,15 @@ static void __init rmobile_setup_pm_domain(struct device_node *np,
 		pr_debug("PM domain %s contains CPU\n", name);
 		pd->gov = &pm_domain_always_on_gov;
 		pd->suspend = rmobile_pd_suspend_busy;
-	} else if (np == console_pd) {
+		break;
+
+	case PD_CONSOLE:
 		pr_debug("PM domain %s contains serial console\n", name);
 		pd->gov = &pm_domain_always_on_gov;
 		pd->suspend = rmobile_pd_suspend_console;
-	} else if (np == debug_pd) {
+		break;
+
+	case PD_DEBUG:
 		/*
 		 * This domain contains the Coresight-ETM hardware block and
 		 * therefore it should only be turned off if the debug module is
@@ -319,6 +342,10 @@ static void __init rmobile_setup_pm_domain(struct device_node *np,
 		pr_debug("PM domain %s contains Coresight-ETM\n", name);
 		pd->gov = &pm_domain_always_on_gov;
 		pd->suspend = rmobile_pd_suspend_busy;
+		break;
+
+	case PD_NORMAL:
+		break;
 	}
 
 	rmobile_init_pm_domain(pd);
-- 
1.9.1

