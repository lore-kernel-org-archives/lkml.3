Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3GQOH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:07:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56227 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3GQOGs (ORCPT
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
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC PATCH v2 14/15] cpufreq: pmac64-cpufreq: remove device tree parsing for cpu nodes
Date: Wed, 17 Jul 2013 15:06:23 +0100
Message-Id: <1374069984-20567-15-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 17 Jul 2013 14:06:45.0524 (UTC) FILETIME=[DF007D40:01CE82F6]
X-MC-Unique: 113071715064619801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6HE7YPI026328

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/pmac64-cpufreq.c | 54 ++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 7ba4234..b60ccea 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
 #include <linux/completion.h>
@@ -383,9 +384,8 @@ static struct cpufreq_driver g5_cpufreq_driver = {
 
 #ifdef CONFIG_PMAC_SMU
 
-static int __init g5_neo2_cpufreq_init(struct device_node *cpus)
+static int __init g5_neo2_cpufreq_init(struct device_node *cpunode)
 {
-	struct device_node *cpunode;
 	unsigned int psize, ssize;
 	unsigned long max_freq;
 	char *freq_method, *volt_method;
@@ -405,20 +405,6 @@ static int __init g5_neo2_cpufreq_init(struct device_node *cpus)
 	else
 		return -ENODEV;
 
-	/* Get first CPU node */
-	for (cpunode = NULL;
-	     (cpunode = of_get_next_child(cpus, cpunode)) != NULL;) {
-		const u32 *reg = of_get_property(cpunode, "reg", NULL);
-		if (reg == NULL || (*reg) != 0)
-			continue;
-		if (!strcmp(cpunode->type, "cpu"))
-			break;
-	}
-	if (cpunode == NULL) {
-		printk(KERN_ERR "cpufreq: Can't find any CPU 0 node\n");
-		return -ENODEV;
-	}
-
 	/* Check 970FX for now */
 	valp = of_get_property(cpunode, "cpu-version", NULL);
 	if (!valp) {
@@ -537,9 +523,9 @@ static int __init g5_neo2_cpufreq_init(struct device_node *cpus)
 #endif /* CONFIG_PMAC_SMU */
 
 
-static int __init g5_pm72_cpufreq_init(struct device_node *cpus)
+static int __init g5_pm72_cpufreq_init(struct device_node *cpunode)
 {
-	struct device_node *cpuid = NULL, *hwclock = NULL, *cpunode = NULL;
+	struct device_node *cpuid = NULL, *hwclock = NULL;
 	const u8 *eeprom = NULL;
 	const u32 *valp;
 	u64 max_freq, min_freq, ih, il;
@@ -548,17 +534,6 @@ static int __init g5_pm72_cpufreq_init(struct device_node *cpus)
 	DBG("cpufreq: Initializing for PowerMac7,2, PowerMac7,3 and"
 	    " RackMac3,1...\n");
 
-	/* Get first CPU node */
-	for (cpunode = NULL;
-	     (cpunode = of_get_next_child(cpus, cpunode)) != NULL;) {
-		if (!strcmp(cpunode->type, "cpu"))
-			break;
-	}
-	if (cpunode == NULL) {
-		printk(KERN_ERR "cpufreq: Can't find any CPU node\n");
-		return -ENODEV;
-	}
-
 	/* Lookup the cpuid eeprom node */
         cpuid = of_find_node_by_path("/u3@0,f8000000/i2c@f8001000/cpuid@a0");
 	if (cpuid != NULL)
@@ -718,25 +693,32 @@ static int __init g5_pm72_cpufreq_init(struct device_node *cpus)
 
 static int __init g5_cpufreq_init(void)
 {
-	struct device_node *cpus;
+	struct device *cpu_dev;
+	struct device_node *cpunode;
 	int rc = 0;
 
-	cpus = of_find_node_by_path("/cpus");
-	if (cpus == NULL) {
-		DBG("No /cpus node !\n");
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev) {
+		pr_err("failed to get cpu device\n");
+		return -ENODEV;
+	}
+
+	/* Get first CPU node */
+	cpunode = of_node_get(cpu_dev->of_node);
+	if (cpunode == NULL) {
+		pr_err("cpufreq: Can't find any CPU node\n");
 		return -ENODEV;
 	}
 
 	if (of_machine_is_compatible("PowerMac7,2") ||
 	    of_machine_is_compatible("PowerMac7,3") ||
 	    of_machine_is_compatible("RackMac3,1"))
-		rc = g5_pm72_cpufreq_init(cpus);
+		rc = g5_pm72_cpufreq_init(cpunode);
 #ifdef CONFIG_PMAC_SMU
 	else
-		rc = g5_neo2_cpufreq_init(cpus);
+		rc = g5_neo2_cpufreq_init(cpunode);
 #endif /* CONFIG_PMAC_SMU */
 
-	of_node_put(cpus);
 	return rc;
 }
 
-- 
1.8.1.2


