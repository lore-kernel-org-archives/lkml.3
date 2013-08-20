Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3HTJdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:33:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34794 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3HTJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:18 -0400
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
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH v4 10/19] drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
Date: Tue, 20 Aug 2013 10:30:12 +0100
Message-Id: <1376991021-12160-11-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:15.0099 (UTC) FILETIME=[E06208B0:01CE9D87]
X-MC-Unique: 113082010301610101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9XlKR012319

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Since the CPU device nodes can be retrieved using arch_of_get_cpu_node,
we can use it to avoid parsing the cpus node searching the cpu nodes and
mapping to logical index.

This patch removes parsing DT for cpu nodes by using of_get_cpu_node.

Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/bus/arm-cci.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index 7332889..2009266 100644
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
+		cpun = of_get_cpu_node(cpu, NULL);
 
-		if (cpu < 0 || !cpu_possible(cpu))
+		if (WARN(!cpun, "Missing cpu device node\n"))
 			continue;
+
 		port = __cci_ace_get_port(cpun, ACE_PORT);
 		if (port < 0)
 			continue;
-- 
1.8.1.2


