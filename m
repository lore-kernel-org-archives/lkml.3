Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3GVLgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:36:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36384 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab3GVLcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:32:43 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH v3 05/16] ARM: mvebu: remove device tree parsing for cpu nodes
Date: Mon, 22 Jul 2013 12:32:16 +0100
Message-Id: <1374492747-13879-6-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 22 Jul 2013 11:32:38.0609 (UTC) FILETIME=[2B79FC10:01CE86CF]
X-MC-Unique: 113072212324107201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6MBah0f009693

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Currently set_secondary_cpus_clock assume the CPU logical ordering
and the MPDIR in DT are same, which is incorrect.

Since the CPU device nodes can be retrieved in the logical ordering
using the DT helper, we can remove the devices tree parsing.

This patch removes DT parsing by making use of of_get_cpu_node.

Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/mach-mvebu/platsmp.c | 52 ++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index ce81d30..001dd42 100644
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
+	struct device_node *np = of_get_cpu_node(cpu);
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


