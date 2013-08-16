Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3HPRkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:40:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38197 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3HPRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:39:50 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH v2 3/4] powerpc: refactor of_get_cpu_node to support other architectures
Date: Fri, 16 Aug 2013 18:39:50 +0100
Message-Id: <1376674791-28244-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 16 Aug 2013 17:39:46.0126 (UTC) FILETIME=[993A16E0:01CE9AA7]
X-MC-Unique: 113081618394800901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7GHenVW024402

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Currently different drivers requiring to access cpu device node are
parsing the device tree themselves. Since the ordering in the DT need
not match the logical cpu ordering, the parsing logic needs to consider
that. However, this has resulted in lots of code duplication and in some
cases even incorrect logic.

It's better to consolidate them by adding support for getting cpu
device node for a given logical cpu index in DT core library. However
logical to physical index mapping can be architecture specific.

PowerPC has it's own implementation to get the cpu node for a given
logical index.

This patch refactors the current implementation of of_get_cpu_node.
This in preparation to move the implementation to DT core library.
It separates out the logical to physical mapping so that a default
matching of the physical id to the logical cpu index can be added
when moved to common code. Architecture specific code can override it.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/powerpc/kernel/prom.c | 76 ++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index eb23ac9..fb12be6 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -865,45 +865,63 @@ static int __init prom_reconfig_setup(void)
 __initcall(prom_reconfig_setup);
 #endif
 
+bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
+{
+	return (int)phys_id == get_hard_smp_processor_id(cpu);
+}
+
+static bool __of_find_n_match_cpu_property(struct device_node *cpun,
+			const char *prop_name, int cpu, unsigned int *thread)
+{
+	const __be32 *cell;
+	int ac, prop_len, tid;
+	u64 hwid;
+
+	ac = of_n_addr_cells(cpun);
+	cell = of_get_property(cpun, prop_name, &prop_len);
+	if (!cell)
+		return false;
+	prop_len /= sizeof(*cell);
+	for (tid = 0; tid < prop_len; tid++) {
+		hwid = of_read_number(cell, ac);
+		if (arch_match_cpu_phys_id(cpu, hwid)) {
+			if (thread)
+				*thread = tid;
+			return true;
+		}
+		cell += ac;
+	}
+	return false;
+}
+
 /* Find the device node for a given logical cpu number, also returns the cpu
  * local thread number (index in ibm,interrupt-server#s) if relevant and
  * asked for (non NULL)
  */
 struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
 {
-	int hardid;
-	struct device_node *np;
+	struct device_node *cpun, *cpus;
 
-	hardid = get_hard_smp_processor_id(cpu);
+	cpus = of_find_node_by_path("/cpus");
+	if (!cpus) {
+		pr_warn("Missing cpus node, bailing out\n");
+		return NULL;
+	}
 
-	for_each_node_by_type(np, "cpu") {
-		const u32 *intserv;
-		unsigned int plen, t;
+	for_each_child_of_node(cpus, cpun) {
+		if (of_node_cmp(cpun->type, "cpu"))
+			continue;
 
-		/* Check for ibm,ppc-interrupt-server#s. If it doesn't exist
-		 * fallback to "reg" property and assume no threads
+		/* Check for historical "ibm,ppc-interrupt-server#s" property
+		 * for thread ids on PowerPC. If it doesn't exist fallback to
+		 * standard "reg" property.
 		 */
-		intserv = of_get_property(np, "ibm,ppc-interrupt-server#s",
-				&plen);
-		if (intserv == NULL) {
-			const u32 *reg = of_get_property(np, "reg", NULL);
-			if (reg == NULL)
-				continue;
-			if (*reg == hardid) {
-				if (thread)
-					*thread = 0;
-				return np;
-			}
-		} else {
-			plen /= sizeof(u32);
-			for (t = 0; t < plen; t++) {
-				if (hardid == intserv[t]) {
-					if (thread)
-						*thread = t;
-					return np;
-				}
-			}
-		}
+		if (__of_find_n_match_cpu_property(cpun,
+				"ibm,ppc-interrupt-server#s", cpu, thread))
+			return cpun;
+
+		if (__of_find_n_match_cpu_property(cpun, "reg", cpu, thread))
+			return cpun;
 	}
 	return NULL;
 }
-- 
1.8.1.2


