Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3GQOGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:06:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55823 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3GQOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:06:44 -0400
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
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [RFC PATCH v2 09/15] cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
Date: Wed, 17 Jul 2013 15:06:18 +0100
Message-Id: <1374069984-20567-10-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 17 Jul 2013 14:06:40.0711 (UTC) FILETIME=[DC221570:01CE82F6]
X-MC-Unique: 113071715064205201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6HE8bnC026349

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/highbank-cpufreq.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index b61b5a3..794123f 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -69,23 +69,17 @@ static int hb_cpufreq_driver_init(void)
 	if (!of_machine_is_compatible("calxeda,highbank"))
 		return -ENODEV;
 
-	for_each_child_of_node(of_find_node_by_path("/cpus"), np)
-		if (of_get_property(np, "operating-points", NULL))
-			break;
-
-	if (!np) {
-		pr_err("failed to find highbank cpufreq node\n");
-		return -ENOENT;
-	}
-
 	cpu_dev = get_cpu_device(0);
 	if (!cpu_dev) {
 		pr_err("failed to get highbank cpufreq device\n");
-		ret = -ENODEV;
-		goto out_put_node;
+		return -ENODEV;
 	}
 
-	cpu_dev->of_node = np;
+	np = of_node_get(cpu_dev->of_node);
+	if (!np) {
+		pr_err("failed to find highbank cpufreq node\n");
+		return -ENOENT;
+	}
 
 	cpu_clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(cpu_clk)) {
-- 
1.8.1.2


