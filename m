Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaESGSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:18:09 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45963 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaESGSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:18:05 -0400
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
Subject: [PATCH 1/5] driver/core: cpu: initialize opp table
Date: Mon, 19 May 2014 11:47:21 +0530
Message-Id: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
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
 drivers/base/cpu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc..c787b5b 100644
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
+				pr_err("****%s: failed to init OPP table for cpu%d, err: %d\n",
+					__func__, num, error);
+			of_node_put(cpu->dev.of_node);
+		}
+	}
+
 	return error;
 }
 
-- 
2.0.0.rc2

