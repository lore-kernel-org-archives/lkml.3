Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaESG3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:29:23 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:50291 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaESG3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:29:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, pavel@ucw.cz, nm@ti.com,
        chander.kashyap@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH Resend] driver/core: cpu: initialize opp table
Date: Mon, 19 May 2014 11:59:11 +0530
Message-Id: <ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All drivers expecting CPU's OPPs from device tree initialize OPP table using
of_init_opp_table() and there is nothing driver specific in that. They all do it
in the same way adding to code redundancy.

It would be better if we can get rid of code redundancy by initializing CPU OPPs
from core code for all CPUs that have a "operating-points" property defined in
their node.

This patch initializes OPPs as soon as CPU device is registered in
register_cpu().

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1-V2:
A colleague spotted some extra debug prints in my first mail :(

Replace
+ pr_err("****%s: failed to init OPP table for cpu%d, err: %d\n",
with
+ pr_err("%s: failed to init OPP table for cpu%d, err: %d\n",

 drivers/base/cpu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc..74ce944 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -16,6 +16,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/cpufeature.h>
+#include <linux/pm_opp.h>
 
 #include "base.h"
 
@@ -349,11 +350,20 @@ int register_cpu(struct cpu *cpu, int num)
 	if (cpu->hotpluggable)
 		cpu->dev.groups = hotplugable_cpu_attr_groups;
 	error = device_register(&cpu->dev);
-	if (!error)
+	if (!error) {
 		per_cpu(cpu_sys_devices, num) = &cpu->dev;
-	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
+		/* Initialize CPUs OPP table */
+		if (of_node_get(cpu->dev.of_node)) {
+			error = of_init_opp_table(&cpu->dev);
+			if (error && error != -ENODEV)
+				pr_err("%s: failed to init OPP table for cpu%d, err: %d\n",
+					__func__, num, error);
+			of_node_put(cpu->dev.of_node);
+		}
+	}
+
 	return error;
 }
 
-- 
2.0.0.rc2

