Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3GVLez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:34:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36937 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab3GVLcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:32:51 -0400
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
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH v3 14/16] cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
Date: Mon, 22 Jul 2013 12:32:25 +0100
Message-Id: <1374492747-13879-15-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 22 Jul 2013 11:32:47.0624 (UTC) FILETIME=[30D99080:01CE86CF]
X-MC-Unique: 113072212324900101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6MBZ1nX009669

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/maple-cpufreq.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index cdd6291..f071dc4 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -24,7 +24,7 @@
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
-#include <linux/of.h>
+#include <linux/of_device.h>
 
 #define DBG(fmt...) pr_debug(fmt)
 
@@ -201,7 +201,6 @@ static struct cpufreq_driver maple_cpufreq_driver = {
 
 static int __init maple_cpufreq_init(void)
 {
-	struct device_node *cpus;
 	struct device_node *cpunode;
 	unsigned int psize;
 	unsigned long max_freq;
@@ -217,24 +216,11 @@ static int __init maple_cpufreq_init(void)
 	    !of_machine_is_compatible("Momentum,Apache"))
 		return 0;
 
-	cpus = of_find_node_by_path("/cpus");
-	if (cpus == NULL) {
-		DBG("No /cpus node !\n");
-		return -ENODEV;
-	}
-
 	/* Get first CPU node */
-	for (cpunode = NULL;
-	     (cpunode = of_get_next_child(cpus, cpunode)) != NULL;) {
-		const u32 *reg = of_get_property(cpunode, "reg", NULL);
-		if (reg == NULL || (*reg) != 0)
-			continue;
-		if (!strcmp(cpunode->type, "cpu"))
-			break;
-	}
+	cpunode = of_cpu_device_node_get(0);
 	if (cpunode == NULL) {
 		printk(KERN_ERR "cpufreq: Can't find any CPU 0 node\n");
-		goto bail_cpus;
+		goto bail_noprops;
 	}
 
 	/* Check 970FX for now */
@@ -290,14 +276,11 @@ static int __init maple_cpufreq_init(void)
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


