Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaLBOLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:11:46 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39656 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaLBOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:06:58 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [RFC PATCH 04/10] arm: Frequency invariant scheduler load-tracking support
Date: Tue,  2 Dec 2014 14:06:26 +0000
Message-Id: <1417529192-11579-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:56.0213 (UTC) FILETIME=[3B27C050:01D00E39]
X-MC-Unique: 114120214065710301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2EBtXj017036

From: Morten Rasmussen <Morten.Rasmussen@arm.com>

Implements arch-specific function to provide the scheduler with a
frequency scaling correction factor for more accurate load-tracking. The
factor is:

	current_freq(cpu) * SCHED_CAPACITY_SCALE / max_freq(cpu)

This implementation only provides frequency invariance. No
micro-architecture invariance yet.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/kernel/topology.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 89cfdd6..73ef337 100644
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
+unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
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
1.9.1


