Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaIVQZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:25:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60324 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaIVQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:24:09 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 4/7] arm: Micro-architecture invariant load tracking support
Date: Mon, 22 Sep 2014 17:24:04 +0100
Message-Id: <1411403047-32010-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 22 Sep 2014 16:24:06.0549 (UTC) FILETIME=[A17D1C50:01CFD681]
X-MC-Unique: 114092217240706701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8MGP9hV029530

Adds micro-architecture difference into scheduler load-tracking
scale-invariance correction factor for big.LITTLE systems. The factor is
now:
	(current_freq(cpu) * uarch_factor(cpu) * SCHED_CAPACITY_SCALE) /
		(max_freq(cpu) * max_uarch_factor)

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/kernel/topology.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 3e9a979..9f499e2 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -79,6 +79,9 @@ static unsigned long *__cpu_capacity;
 
 static unsigned long middle_capacity = 1;
 
+static unsigned long max_raw_capacity = 1;
+static DEFINE_PER_CPU(unsigned long, cpu_raw_capacity);
+
 /*
  * Iterate all CPUs' descriptor in DT and compute the efficiency
  * (as per table_efficiency). Also calculate a middle efficiency
@@ -117,6 +120,9 @@ static void __init parse_dt_topology(void)
 		if (cpu_eff->compatible == NULL)
 			continue;
 
+		per_cpu(cpu_raw_capacity, cpu) = cpu_eff->efficiency;
+		max_raw_capacity = max(max_raw_capacity, cpu_eff->efficiency);
+
 		rate = of_get_property(cn, "clock-frequency", &len);
 		if (!rate || len != 4) {
 			pr_err("%s missing clock-frequency property\n",
@@ -173,7 +179,8 @@ static void update_cpu_capacity(unsigned int cpu)
  * Scheduler load-tracking scale-invariance
  *
  * Provides the scheduler with a scale-invariance correction factor that
- * compensates for frequency scaling.
+ * compensates for frequency scaling and micro-architecture differences between
+ * cpus.
  */
 
 static DEFINE_PER_CPU(atomic_long_t, cpu_curr_freq);
@@ -195,11 +202,15 @@ unsigned long arch_scale_load_capacity(int cpu)
 {
 	unsigned long curr = atomic_long_read(&per_cpu(cpu_curr_freq, cpu));
 	unsigned long max = atomic_long_read(&per_cpu(cpu_max_freq, cpu));
+	unsigned long ret;
 
-	if (!max)
+	if (!max || !per_cpu(cpu_raw_capacity, cpu))
 		return SCHED_CAPACITY_SCALE;
 
-	return (curr * SCHED_CAPACITY_SCALE) / max;
+	ret = (curr * SCHED_CAPACITY_SCALE) / max;
+	ret = (ret * per_cpu(cpu_raw_capacity, cpu)) / max_raw_capacity;
+
+	return ret;
 }
 
 #else
-- 
1.7.9.5


