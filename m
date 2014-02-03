Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaBCM4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:56:09 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:34124 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaBCM4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:06 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v1 01/10] perf/x86/uncore: fix initialization of cpumask
Date: Mon,  3 Feb 2014 13:55:33 +0100
Message-Id: <1391432142-18723-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391432142-18723-1-git-send-email-eranian@google.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On certain processors, the uncore PMU boxes may only be
msr-bsed or PCI-based. But in both cases, the cpumask,
suggesting on which CPUs to monitor to get full coverage
of the particular PMU, must be created.

However with the current code base, the cpumask was only
created on processor which had at least one MSR-based
uncore PMU. This patch removes that restriction and
ensures the cpumask is created even when there is no
msr-based PMU. For instance, on SNB client where only
a PCI-based memory controller PMU is supported.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   61 +++++++++++++++----------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 29c2487..fe4255b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3764,7 +3764,7 @@ static void __init uncore_cpu_setup(void *dummy)
 
 static int __init uncore_cpu_init(void)
 {
-	int ret, cpu, max_cores;
+	int ret, max_cores;
 
 	max_cores = boot_cpu_data.x86_max_cores;
 	switch (boot_cpu_data.x86_model) {
@@ -3808,29 +3808,6 @@ static int __init uncore_cpu_init(void)
 	if (ret)
 		return ret;
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu) {
-		int i, phys_id = topology_physical_package_id(cpu);
-
-		for_each_cpu(i, &uncore_cpu_mask) {
-			if (phys_id == topology_physical_package_id(i)) {
-				phys_id = -1;
-				break;
-			}
-		}
-		if (phys_id < 0)
-			continue;
-
-		uncore_cpu_prepare(cpu, phys_id);
-		uncore_event_init_cpu(cpu);
-	}
-	on_each_cpu(uncore_cpu_setup, NULL, 1);
-
-	register_cpu_notifier(&uncore_cpu_nb);
-
-	put_online_cpus();
-
 	return 0;
 }
 
@@ -3859,6 +3836,41 @@ static int __init uncore_pmus_register(void)
 	return 0;
 }
 
+static void uncore_cpumask_init(void)
+{
+	int cpu;
+
+	/*
+	 * ony invoke once from msr or pci init code
+	 */
+	if (!cpumask_empty(&uncore_cpu_mask))
+		return;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		int i, phys_id = topology_physical_package_id(cpu);
+
+		for_each_cpu(i, &uncore_cpu_mask) {
+			if (phys_id == topology_physical_package_id(i)) {
+				phys_id = -1;
+				break;
+			}
+		}
+		if (phys_id < 0)
+			continue;
+
+		uncore_cpu_prepare(cpu, phys_id);
+		uncore_event_init_cpu(cpu);
+	}
+	on_each_cpu(uncore_cpu_setup, NULL, 1);
+
+	register_cpu_notifier(&uncore_cpu_nb);
+
+	put_online_cpus();
+}
+
+
 static int __init intel_uncore_init(void)
 {
 	int ret;
@@ -3877,6 +3889,7 @@ static int __init intel_uncore_init(void)
 		uncore_pci_exit();
 		goto fail;
 	}
+	uncore_cpumask_init();
 
 	uncore_pmus_register();
 	return 0;
-- 
1.7.9.5

