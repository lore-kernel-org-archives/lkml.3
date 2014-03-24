Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaCXUGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:06:15 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40941 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaCXUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:06:08 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, daniel.lezcano@linaro.org,
        zoran.markovic@linaro.org
Subject: [RFC PATCH 2/2] sched: Add documentation for idlestat scheduler benchmarking tool
Date: Mon, 24 Mar 2014 13:05:22 -0700
Message-Id: <1395691522-3561-3-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395691522-3561-1-git-send-email-zoran.markovic@linaro.org>
References: <1395691522-3561-1-git-send-email-zoran.markovic@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the proposed functionality of idlestat tool and
states its intended use for scheduler benchmarking. The documentation
file describes the design of the tool, what kernel functionality it
relies upon, and what information is contained in the output report.
It also contains a simple linear model for estimating CPU power
consumption during idlestat run.

Idlestat focuses itself on CPU and cluster power states in precise
intervals in time. This is of particular use when the benchmarked
process is a load synthesis tool: idlestat could focus its acquisition
period to a particular sub-period in the load sequence. Output results
from idlestat can be applied to a power model in order to estimate the
power consumption of CPUs and clusters during the benchmark interval.
Initial measurements on ARM Versatile Express TC2 platform show a model
error of ~2.6% for the linear power model described in the documentation.

Cc: Rob Landley <rob@landley.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 Documentation/scheduler/idlestat.txt |   79 ++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/scheduler/idlestat.txt

diff --git a/Documentation/scheduler/idlestat.txt b/Documentation/scheduler/idlestat.txt
new file mode 100644
index 0000000..8e6b695
--- /dev/null
+++ b/Documentation/scheduler/idlestat.txt
@@ -0,0 +1,79 @@
+This document captures the desired operation of the idlestat tool.
+
+With the advent of battery-powered Linux devices, it became important to add
+a power-aware component to the existing CFS scheduler solution. Future
+developments in this field need to be benchmarked using a simple tool that
+monitors power parameters during system runs and provides sufficient info for
+developers to assess how changes to scheduler code affected CPU power
+consumption. The idlestat tool attempts to capture this.
+
+Idlestat uses kernel's FTRACE function to monitor and capture C-state and
+P-state transitions of CPUs over a time interval. It extracts the following
+information from trace file:
+	- Times when CPUs entered and exited a certain C-state
+	- Times when CPUs entered and exited a certain P-state
+	- Raised IRQs
+
+Following a successful run, idlestat calculates and reports the following
+information:
+	- Total, average, minimum and maximum time spent in each C-state,
+	  per-CPU.
+	- Total, average, minimum and maximum time spent in each P-state,
+	  per-CPU.
+	- Total, average, minimum and maximum time during which all CPUs in
+	  a cluster were in the same C-state, per-cluster.
+	- Number of times a certain IRQ caused a CPU to exit idle state,
+	  per-CPU and per-IRQ.
+
+The tool parses sysfs entries to determine the CPU/cluster topology, as well
+as supported C-states and P-states per CPU. It is unaware of CPU/cluster power
+consumption in each C-state and P-state, but if these parameters are
+externally known, a ballpark estimate of the energy consumed during idlestat
+run can be calculated as follows:
+
+energy = sum_per_cpu(PCi*(TCi-TCCi)) + sum_per_cluster(PCCi*TCCi) +
+	 sum_per_cpu(PPi*TPi)
+
+where:
+PCi 	- is the power consumption of CPU in Ci power state
+TCi 	- is the total time the CPU has spent in Ci power state
+PCCi 	- is the power consumption of cluster in Ci power state
+TCCi 	- is the total time the cluster has spent in Ci power state
+PPi 	- is the power consumption of CPU in Pi power state
+TPi 	- is the total time the CPU has spent in Pi power state
+
+Below is an example report of one idlestat run on a dual-core system:
+clusterA@state  hits          total(us)         avg(us) min(us) max(us)
+       C1       10821        5879554.00          543.35 0.00    23163.00
+       C2       0                  0.00            0.00 0.00    0.00
+       C3       78           2929290.00        37555.00 0.00    101441.00
+  cpu0@state    hits          total(us)         avg(us) min(us) max(us)
+       C1       6744         6407808.00          950.15 0.00    23194.00
+       C2       3               8819.00         2939.67 549.00  5310.00
+       C3       75           2960110.00        39468.13 213.00  101441.00
+       350      1047          204490.00          195.31 0.00    4578.00
+       700      5628          396247.00           70.41 0.00    1465.00
+       920      0                  0.00            0.00 0.00    0.00
+  cpu0 wakeups  name            count
+       irq109   ehci_hcd:usb1   1727
+       irq029   twd             4524
+       irq069   gp_timer        60
+       irq115   mmc0            7
+       irq044   DMA             3
+  cpu1@state    hits          total(us)         avg(us) min(us) max(us)
+       C1       6544         6398931.00          977.83 0.00    36255.00
+       C2       1               1129.00         1129.00 1129.00 1129.00
+       C3       77           2955293.00        38380.43 122.00  101471.00
+       350      1124          212428.00          188.99 0.00    18677.00
+       700      5366          408782.00           76.18 0.00    946.00
+       920      0                  0.00            0.00 0.00    0.00
+  cpu1 wakeups  name            count
+       irq029   twd             4737
+
+Idlestat does not perform any processing during the acquisition period. It
+sleeps while traces are captured, making sure it is non-intrusive to C-
+and P-state transitions. During that time, traces are stored in kernel ring
+buffers previously sized by idlestat based on the length of acquisition
+period and estimated frequency of trace events. Traces are parsed and
+analyzed once the acquisition period is complete.
+
-- 
1.7.9.5

