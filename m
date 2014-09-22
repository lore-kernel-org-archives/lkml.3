Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaIVQZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:25:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60287 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaIVQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:24:08 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 3/7] arm: Frequency invariant scheduler load-tracking support
Date: Mon, 22 Sep 2014 17:24:03 +0100
Message-Id: <1411403047-32010-4-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 22 Sep 2014 16:24:05.0924 (UTC) FILETIME=[A11DBE40:01CFD681]
X-MC-Unique: 114092217240600201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8MGPdpJ029534

Implements arch-specific function to provide the scheduler with a
frequency scaling correction factor for more accurate load-tracking. The
factor is:

	current_freq(cpu) * SCHED_CAPACITY_SCALE / max_freq(cpu)

This implementation only provides frequency invariance. No
micro-architecture invariance yet.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/kernel/topology.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 89cfdd6..3e9a979 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -169,6 +169,39 @@ static void update_cpu_capacity(unsigned int cpu)
 		cpu, arch_scale_cpu_capacity(NULL, cpu));
 }
 
+/*
+ * Scheduler load-tracking scale-invariance
+ *
+ * Provides the scheduler with a scale-invariance correction factor that
+ * compensates for frequency scaling.
+ */
+
+static DEFINE_PER_CPU(atomic_long_t, cpu_curr_freq);
+static DEFINE_PER_CPU(atomic_long_t, cpu_max_freq);
+
+/* cpufreq callback function setting current cpu frequency */
+void arch_scale_set_curr_freq(int cpu, unsigned long freq)
+{
+	atomic_long_set(&per_cpu(cpu_curr_freq, cpu), freq);
+}
+
+/* cpufreq callback function setting max cpu frequency */
+void arch_scale_set_max_freq(int cpu, unsigned long freq)
+{
+	atomic_long_set(&per_cpu(cpu_max_freq, cpu), freq);
+}
+
+unsigned long arch_scale_load_capacity(int cpu)
+{
+	unsigned long curr = atomic_long_read(&per_cpu(cpu_curr_freq, cpu));
+	unsigned long max = atomic_long_read(&per_cpu(cpu_max_freq, cpu));
+
+	if (!max)
+		return SCHED_CAPACITY_SCALE;
+
+	return (curr * SCHED_CAPACITY_SCALE) / max;
+}
+
 #else
 static inline void parse_dt_topology(void) {}
 static inline void update_cpu_capacity(unsigned int cpuid) {}
-- 
1.7.9.5


