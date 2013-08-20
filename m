Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3HTJbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:31:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35353 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3HTJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:25 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH v4 17/19] cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
Date: Tue, 20 Aug 2013 10:30:19 +0100
Message-Id: <1376991021-12160-18-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:21.0224 (UTC) FILETIME=[E408A280:01CE9D87]
X-MC-Unique: 113082010302311201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9Vfwq012275

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


