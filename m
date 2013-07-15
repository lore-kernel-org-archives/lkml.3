Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3GOKY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:24:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33743 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3GOKWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:24 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 04/11] ARM: mvebu: remove device tree parsing for cpu nodes
Date: Mon, 15 Jul 2013 11:22:05 +0100
Message-Id: <1373883732-26303-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Jul 2013 10:22:21.0175 (UTC) FILETIME=[30CC6070:01CE8145]
X-MC-Unique: 113071511222214701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FAOdIA007653

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Currently set_secondary_cpus_clock assume the CPU logical ordering
and the MPDIR in DT are same, which is incorrect.

Since the CPU device nodes can be retrieved in the logical ordering
using the helper, we can remove the devices tree parsing.

This patch removes DT parsing by making use of arch_of_get_cpu_node.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/mach-mvebu/platsmp.c | 52 ++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index 93f2f3a..b57af6c 100644
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@ -23,51 +23,47 @@
 #include <linux/of.h>
 #include <linux/mbus.h>
 #include <asm/cacheflush.h>
+#include <asm/prom.h>
 #include <asm/smp_plat.h>
 #include "common.h"
 #include "armada-370-xp.h"
 #include "pmsu.h"
 #include "coherency.h"
 
+static struct clk *__init get_cpu_clk(int cpu)
+{
+	struct clk *cpu_clk;
+	struct device_node *np = arch_of_get_cpu_node(cpu);
+
+	if (WARN(!np, "missing cpu node\n"))
+		return NULL;
+	cpu_clk = of_clk_get(np, 0);
+	if (WARN_ON(IS_ERR(cpu_clk)))
+		return NULL;
+	return cpu_clk;
+}
+
 void __init set_secondary_cpus_clock(void)
 {
-	int thiscpu;
+	int thiscpu, cpu;
 	unsigned long rate;
-	struct clk *cpu_clk = NULL;
-	struct device_node *np = NULL;
+	struct clk *cpu_clk;
 
 	thiscpu = smp_processor_id();
-	for_each_node_by_type(np, "cpu") {
-		int err;
-		int cpu;
-
-		err = of_property_read_u32(np, "reg", &cpu);
-		if (WARN_ON(err))
-			return;
-
-		if (cpu == thiscpu) {
-			cpu_clk = of_clk_get(np, 0);
-			break;
-		}
-	}
-	if (WARN_ON(IS_ERR(cpu_clk)))
+	cpu_clk = get_cpu_clk(thiscpu);
+	if (!cpu_clk)
 		return;
 	clk_prepare_enable(cpu_clk);
 	rate = clk_get_rate(cpu_clk);
 
 	/* set all the other CPU clk to the same rate than the boot CPU */
-	for_each_node_by_type(np, "cpu") {
-		int err;
-		int cpu;
-
-		err = of_property_read_u32(np, "reg", &cpu);
-		if (WARN_ON(err))
+	for_each_possible_cpu(cpu) {
+		if (cpu == thiscpu)
+			continue;
+		cpu_clk = get_cpu_clk(cpu);
+		if (!cpu_clk)
 			return;
-
-		if (cpu != thiscpu) {
-			cpu_clk = of_clk_get(np, 0);
-			clk_set_rate(cpu_clk, rate);
-		}
+		clk_set_rate(cpu_clk, rate);
 	}
 }
 
-- 
1.8.1.2


