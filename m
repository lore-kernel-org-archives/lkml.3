Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3GOKY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:24:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33823 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab3GOKWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:25 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 05/11] drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
Date: Mon, 15 Jul 2013 11:22:06 +0100
Message-Id: <1373883732-26303-6-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Jul 2013 10:22:22.0190 (UTC) FILETIME=[316740E0:01CE8145]
X-MC-Unique: 113071511222310601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FAPI1a007665

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Since the CPU device nodes can be retrieved using arch_of_get_cpu_node,
we can use it to avoid parsing the cpus node searching the cpu nodes and
mapping to logical index.

This patch removes parsing DT for cpu nodes by using arch_of_get_cpu_node.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/bus/arm-cci.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index 7332889..8de67c2 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -122,17 +122,8 @@ EXPORT_SYMBOL_GPL(cci_ace_get_port);
 
 static void __init cci_ace_init_ports(void)
 {
-	int port, ac, cpu;
-	u64 hwid;
-	const u32 *cell;
-	struct device_node *cpun, *cpus;
-
-	cpus = of_find_node_by_path("/cpus");
-	if (WARN(!cpus, "Missing cpus node, bailing out\n"))
-		return;
-
-	if (WARN_ON(of_property_read_u32(cpus, "#address-cells", &ac)))
-		ac = of_n_addr_cells(cpus);
+	int port, cpu;
+	struct device_node *cpun;
 
 	/*
 	 * Port index look-up speeds up the function disabling ports by CPU,
@@ -141,18 +132,13 @@ static void __init cci_ace_init_ports(void)
 	 * The stashed index array is initialized for all possible CPUs
 	 * at probe time.
 	 */
-	for_each_child_of_node(cpus, cpun) {
-		if (of_node_cmp(cpun->type, "cpu"))
-			continue;
-		cell = of_get_property(cpun, "reg", NULL);
-		if (WARN(!cell, "%s: missing reg property\n", cpun->full_name))
-			continue;
-
-		hwid = of_read_number(cell, ac);
-		cpu = get_logical_index(hwid & MPIDR_HWID_BITMASK);
+	for_each_possible_cpu(cpu) {
+		/* too early to use cpu->of_node */
+		cpun = arch_of_get_cpu_node(cpu);
 
-		if (cpu < 0 || !cpu_possible(cpu))
+		if (WARN(!cpun, "Missing cpu device node\n"))
 			continue;
+
 		port = __cci_ace_get_port(cpun, ACE_PORT);
 		if (port < 0)
 			continue;
-- 
1.8.1.2


