Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaEULKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:10:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57910 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaEULKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:10:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH V2 3/7] driver/core: cpu: initialize opp table
Date: Wed, 21 May 2014 16:40:01 +0530
Message-Id: <b59df199b373191791afcccd627d900ce07afa71.1400670427.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400670427.git.viresh.kumar@linaro.org>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400670427.git.viresh.kumar@linaro.org>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
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
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/base/cpu.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc..853e99e 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -16,6 +16,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/cpufeature.h>
+#include <linux/pm_opp.h>
 
 #include "base.h"
 
@@ -322,6 +323,25 @@ static int cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 #endif
 
+#if defined(CONFIG_PM_OPP) && defined(CONFIG_OF)
+static inline void of_init_cpu_opp_table(struct cpu *cpu)
+{
+	int error;
+
+	/* Initialize CPU's OPP table */
+	error = of_init_opp_table(&cpu->dev);
+	if (!error)
+		dev_info(&cpu->dev, "%s: created OPP table for cpu: %d\n",
+			 __func__, cpu->dev.id);
+	/* Print error only if there is an issue with OPP table */
+	else if (error != -ENOSYS && error != -ENODEV)
+		dev_err(&cpu->dev, "%s: failed to init OPP table for cpu%d, err: %d\n",
+			__func__, cpu->dev.id, error);
+}
+#else
+static inline void of_init_cpu_opp_table(struct cpu *cpu) {}
+#endif
+
 /*
  * register_cpu - Setup a sysfs device for a CPU.
  * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
@@ -349,10 +369,12 @@ int register_cpu(struct cpu *cpu, int num)
 	if (cpu->hotpluggable)
 		cpu->dev.groups = hotplugable_cpu_attr_groups;
 	error = device_register(&cpu->dev);
-	if (!error)
-		per_cpu(cpu_sys_devices, num) = &cpu->dev;
-	if (!error)
-		register_cpu_under_node(num, cpu_to_node(num));
+	if (error)
+		return error;
+
+	per_cpu(cpu_sys_devices, num) = &cpu->dev;
+	register_cpu_under_node(num, cpu_to_node(num));
+	of_init_cpu_opp_table(cpu);
 
 	return error;
 }
-- 
2.0.0.rc2

