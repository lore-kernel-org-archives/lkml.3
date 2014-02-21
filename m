Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaBUVNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:13:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaBUVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:13:15 -0500
Date: Fri, 21 Feb 2014 13:12:42 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-411cf180fa00521f9bfb1d022e3ebf059a2d299f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392132015-14521-2-git-send-email-eranian@google.com>
References: <1392132015-14521-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore: fix initialization of cpumask
Git-Commit-ID: 411cf180fa00521f9bfb1d022e3ebf059a2d299f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  411cf180fa00521f9bfb1d022e3ebf059a2d299f
Gitweb:     http://git.kernel.org/tip/411cf180fa00521f9bfb1d022e3ebf059a2d299f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Feb 2014 16:20:07 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:07 +0100

perf/x86/uncore: fix initialization of cpumask

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

Cc: mingo@elte.hu
Cc: acme@redhat.com
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: peterz@infradead.org
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392132015-14521-2-git-send-email-eranian@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 61 ++++++++++++++++-----------
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
