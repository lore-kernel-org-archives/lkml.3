Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3GIPzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:55:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46251 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3GIPzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:40 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 8/9] sched: power: Add initial frequency scaling support to power scheduler
Date: Tue,  9 Jul 2013 16:55:37 +0100
Message-Id: <1373385338-12983-9-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:36.0794 (UTC) FILETIME=[C0A333A0:01CE7CBC]
X-MC-Unique: 113070916553800201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FtwaQ011617

Extends the power scheduler capacity management algorithm to handle
frequency scaling and provide basic frequency/P-state selection hints
to the power driver.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/sched/power.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/power.c b/kernel/sched/power.c
index 9e44c0e..5fc32b0 100644
--- a/kernel/sched/power.c
+++ b/kernel/sched/power.c
@@ -21,6 +21,8 @@
 
 #define INTERVAL 5 /* ms */
 #define CPU_FULL 90 /* Busy %-age - TODO: Make tunable */
+#define CPU_TARGET 80 /* Target busy %-age - TODO: Make tunable */
+#define CPU_EMPTY 5 /* Idle noise %-age - TODO: Make tunable */
 
 struct power_domain {
 	/* Domain hierarchy pointers */
@@ -87,7 +89,7 @@ static void update_cpu_load(void)
 		u32 sum = rq->avg.runnable_avg_sum;
 		u32 period = rq->avg.runnable_avg_period;
 
-		load = (sum * power_sched_cpu_power(i)) / (period+1);
+		load = (sum * cpu_pd(i)->curr_power) / (period+1);
 		cpu_pd(i)->load = load;
 		cpu_pd(i)->nr_tasks = rq->nr_running;
 
@@ -160,19 +162,40 @@ static void calculate_cpu_capacities(void)
 
 	for_each_online_cpu(i) {
 		int t_cap = 0;
-		int sched_power = cpu_pd(i)->sched_power;
+		int curr_power = cpu_pd(i)->curr_power;
 
 		stats = cpu_pd(i);
-		t_cap = sched_power - stats->load;
+		t_cap = curr_power - stats->load;
 
-		if (t_cap < (sched_power * (100-CPU_FULL)) / 100) {
+		if (t_cap < (curr_power * (100-CPU_FULL)) / 100) {
 			/* Potential for spreading load */
 			if (stats->nr_tasks > 1)
 				t_cap = -(stats->load / stats->nr_tasks);
+			/*
+			 * Single task and higher p-state available on
+			 * current cpu
+			 */
+			else if (power_driver &&
+					curr_power < cpu_pd(i)->arch_power)
+				power_driver->req_power(i,
+						cpu_pd(i)->arch_power);
+		} else {
+			/* cpu not full - request lower p-state */
+			/*
+			 * TODO global view of spare capacity is needed to do
+			 * proper p-state selection
+			 */
+			if (power_driver)
+				power_driver->req_power(i,
+						(stats->load*100)/CPU_TARGET);
+
+			/* Don't let noise keep the cpu awake */
+			if (t_cap > (curr_power * CPU_EMPTY) / 100)
+				t_cap = curr_power;
 		}
 
 		/* Do we have enough capacity already? */
-		if (spare_cap + t_cap > sched_power) {
+		if (spare_cap + t_cap > curr_power) {
 			cpu_pd(i)->sched_power = 1;
 		} else {
 			cpu_pd(i)->sched_power = cpu_pd(i)->arch_power;
-- 
1.7.9.5


