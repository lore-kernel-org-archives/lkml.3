Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3GQOG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:06:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56290 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3GQOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:06:49 -0400
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
Subject: [RFC PATCH v2 15/15] cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes
Date: Wed, 17 Jul 2013 15:06:24 +0100
Message-Id: <1374069984-20567-16-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 17 Jul 2013 14:06:46.0383 (UTC) FILETIME=[DF838FF0:01CE82F6]
X-MC-Unique: 113071715064800501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6HE79OU026324

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes DT parsing and uses cpu->of_node instead.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/pmac32-cpufreq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 3104fad..b6822ee 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/adb.h>
 #include <linux/pmu.h>
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -643,6 +644,7 @@ static int pmac_cpufreq_init_750FX(struct device_node *cpunode)
  */
 static int __init pmac_cpufreq_setup(void)
 {
+	struct device *cpu_dev;
 	struct device_node	*cpunode;
 	const u32		*value;
 
@@ -650,7 +652,14 @@ static int __init pmac_cpufreq_setup(void)
 		return 0;
 
 	/* Assume only one CPU */
-	cpunode = of_find_node_by_type(NULL, "cpu");
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev) {
+		pr_err("failed to get cpu device\n");
+		return -ENODEV;
+	}
+
+	/* Get first CPU node */
+	cpunode = of_node_get(cpu_dev->of_node);
 	if (!cpunode)
 		goto out;
 
-- 
1.8.1.2


