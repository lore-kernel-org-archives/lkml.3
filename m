Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaLBOID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:08:03 -0500
Received: from service88.mimecast.com ([195.130.217.12]:54078 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaLBOIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:08:01 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 06/10] arm: Cpu invariant scheduler load-tracking support
Date: Tue,  2 Dec 2014 14:06:28 +0000
Message-Id: <1417529192-11579-7-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:57.0791 (UTC) FILETIME=[3C1888F0:01D00E39]
X-MC-Unique: 114120214065812501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E8CSa016976

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Reuses the existing infrastructure for cpu_scale to provide the scheduler
with a cpu scaling correction factor for more accurate load-tracking.
This factor comprises a micro-architectural part, which is based on the
cpu efficiency value of a cpu as well as a platform-wide max frequency
part, which relates to the dtb property clock-frequency of a cpu node.

The calculation of cpu_scale, return value of arch_scale_cpu_capacity,
changes from:

    capacity / middle_capacity

    with capacity = (clock_frequency >> 20) * cpu_efficiency

to:

    SCHED_CAPACITY_SCALE * cpu_perf / max_cpu_perf

The range of the cpu_scale value changes from
[0..3*SCHED_CAPACITY_SCALE/2] to [0..SCHED_CAPACITY_SCALE].

The functionality to calculate the middle_capacity which corresponds to an
'average' cpu has been taken out since the scaling is now done
differently.

In the case that either the cpu efficiency or the clock-frequency value
for a cpu is missing, no cpu scaling is done for any cpu.

The platform-wide max frequency part of the factor should not be confused
with the frequency invariant scheduler load-tracking support which deals
with frequency related scaling due to DFVS functionality on a cpu.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/arm/kernel/topology.c | 64 +++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 73ef337..e4c59fa 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -62,9 +62,7 @@ struct cpu_efficiency {
  * Table of relative efficiency of each processors
  * The efficiency value must fit in 20bit and the final
  * cpu_scale value must be in the range
- *   0 < cpu_scale < 3*SCHED_CAPACITY_SCALE/2
- * in order to return at most 1 when DIV_ROUND_CLOSEST
- * is used to compute the capacity of a CPU.
+ *   0 < cpu_scale < SCHED_CAPACITY_SCALE.
  * Processors that are not defined in the table,
  * use the default SCHED_CAPACITY_SCALE value for cpu_scale.
  */
@@ -77,24 +75,18 @@ static const struct cpu_efficiency table_efficiency[] = {
 static unsigned long *__cpu_capacity;
 #define cpu_capacity(cpu)	__cpu_capacity[cpu]
 
-static unsigned long middle_capacity = 1;
+static unsigned long max_cpu_perf;
 
 /*
  * Iterate all CPUs' descriptor in DT and compute the efficiency
- * (as per table_efficiency). Also calculate a middle efficiency
- * as close as possible to  (max{eff_i} - min{eff_i}) / 2
- * This is later used to scale the cpu_capacity field such that an
- * 'average' CPU is of middle capacity. Also see the comments near
- * table_efficiency[] and update_cpu_capacity().
+ * (as per table_efficiency). Calculate the max cpu performance too.
  */
+
 static void __init parse_dt_topology(void)
 {
 	const struct cpu_efficiency *cpu_eff;
 	struct device_node *cn = NULL;
-	unsigned long min_capacity = ULONG_MAX;
-	unsigned long max_capacity = 0;
-	unsigned long capacity = 0;
-	int cpu = 0;
+	int cpu = 0, i = 0;
 
 	__cpu_capacity = kcalloc(nr_cpu_ids, sizeof(*__cpu_capacity),
 				 GFP_NOWAIT);
@@ -102,6 +94,7 @@ static void __init parse_dt_topology(void)
 	for_each_possible_cpu(cpu) {
 		const u32 *rate;
 		int len;
+		unsigned long cpu_perf;
 
 		/* too early to use cpu->of_node */
 		cn = of_get_cpu_node(cpu, NULL);
@@ -124,46 +117,35 @@ static void __init parse_dt_topology(void)
 			continue;
 		}
 
-		capacity = ((be32_to_cpup(rate)) >> 20) * cpu_eff->efficiency;
-
-		/* Save min capacity of the system */
-		if (capacity < min_capacity)
-			min_capacity = capacity;
-
-		/* Save max capacity of the system */
-		if (capacity > max_capacity)
-			max_capacity = capacity;
-
-		cpu_capacity(cpu) = capacity;
+		cpu_perf = ((be32_to_cpup(rate)) >> 20) * cpu_eff->efficiency;
+		cpu_capacity(cpu) = cpu_perf;
+		max_cpu_perf = max(max_cpu_perf, cpu_perf);
+		i++;
 	}
 
-	/* If min and max capacities are equals, we bypass the update of the
-	 * cpu_scale because all CPUs have the same capacity. Otherwise, we
-	 * compute a middle_capacity factor that will ensure that the capacity
-	 * of an 'average' CPU of the system will be as close as possible to
-	 * SCHED_CAPACITY_SCALE, which is the default value, but with the
-	 * constraint explained near table_efficiency[].
-	 */
-	if (4*max_capacity < (3*(max_capacity + min_capacity)))
-		middle_capacity = (min_capacity + max_capacity)
-				>> (SCHED_CAPACITY_SHIFT+1);
-	else
-		middle_capacity = ((max_capacity / 3)
-				>> (SCHED_CAPACITY_SHIFT-1)) + 1;
-
+	if (i < num_possible_cpus())
+		max_cpu_perf = 0;
 }
 
 /*
  * Look for a customed capacity of a CPU in the cpu_capacity table during the
  * boot. The update of all CPUs is in O(n^2) for heteregeneous system but the
- * function returns directly for SMP system.
+ * function returns directly for SMP systems or if there is no complete set
+ * of cpu efficiency, clock frequency data for each cpu.
  */
 static void update_cpu_capacity(unsigned int cpu)
 {
-	if (!cpu_capacity(cpu))
+	unsigned long capacity = cpu_capacity(cpu);
+
+	if (!capacity || !max_cpu_perf) {
+		cpu_capacity(cpu) = 0;
 		return;
+	}
+
+	capacity *= SCHED_CAPACITY_SCALE;
+	capacity /= max_cpu_perf;
 
-	set_capacity_scale(cpu, cpu_capacity(cpu) / middle_capacity);
+	set_capacity_scale(cpu, capacity);
 
 	printk(KERN_INFO "CPU%u: update cpu_capacity %lu\n",
 		cpu, arch_scale_cpu_capacity(NULL, cpu));
-- 
1.9.1


