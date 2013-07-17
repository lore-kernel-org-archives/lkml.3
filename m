Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3GQOH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:07:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56111 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3GQOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:06:48 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [RFC PATCH v2 13/15] cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
Date: Wed, 17 Jul 2013 15:06:22 +0100
Message-Id: <1374069984-20567-14-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 17 Jul 2013 14:06:44.0524 (UTC) FILETIME=[DE67E6C0:01CE82F6]
X-MC-Unique: 113071715064511701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6HE85FZ026341

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/maple-cpufreq.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index cdd6291..bc7233b 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
 #include <linux/completion.h>
@@ -201,7 +202,7 @@ static struct cpufreq_driver maple_cpufreq_driver = {
 
 static int __init maple_cpufreq_init(void)
 {
-	struct device_node *cpus;
+	struct device *cpu_dev;
 	struct device_node *cpunode;
 	unsigned int psize;
 	unsigned long max_freq;
@@ -217,24 +218,17 @@ static int __init maple_cpufreq_init(void)
 	    !of_machine_is_compatible("Momentum,Apache"))
 		return 0;
 
-	cpus = of_find_node_by_path("/cpus");
-	if (cpus == NULL) {
-		DBG("No /cpus node !\n");
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev) {
+		pr_err("failed to get cpu device\n");
 		return -ENODEV;
 	}
 
 	/* Get first CPU node */
-	for (cpunode = NULL;
-	     (cpunode = of_get_next_child(cpus, cpunode)) != NULL;) {
-		const u32 *reg = of_get_property(cpunode, "reg", NULL);
-		if (reg == NULL || (*reg) != 0)
-			continue;
-		if (!strcmp(cpunode->type, "cpu"))
-			break;
-	}
+	cpunode = of_node_get(cpu_dev->of_node);
 	if (cpunode == NULL) {
 		printk(KERN_ERR "cpufreq: Can't find any CPU 0 node\n");
-		goto bail_cpus;
+		goto bail_noprops;
 	}
 
 	/* Check 970FX for now */
@@ -290,14 +284,11 @@ static int __init maple_cpufreq_init(void)
 	rc = cpufreq_register_driver(&maple_cpufreq_driver);
 
 	of_node_put(cpunode);
-	of_node_put(cpus);
 
 	return rc;
 
 bail_noprops:
 	of_node_put(cpunode);
-bail_cpus:
-	of_node_put(cpus);
 
 	return rc;
 }
-- 
1.8.1.2


