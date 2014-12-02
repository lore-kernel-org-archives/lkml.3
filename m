Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaLBOHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:07:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39608 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaLBOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:06:58 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [RFC PATCH 03/10] cpufreq: Architecture specific callback for frequency changes
Date: Tue,  2 Dec 2014 14:06:25 +0000
Message-Id: <1417529192-11579-4-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:55.0604 (UTC) FILETIME=[3ACAD340:01D00E39]
X-MC-Unique: 114120214065701401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E8gEZ016980

From: Morten Rasmussen <Morten.Rasmussen@arm.com>

Architectures that don't have any other means for tracking cpu frequency
changes need a callback from cpufreq to implement a scaling factor to
enable scale-invariant per-entity load-tracking in the scheduler.

To compute the scale invariance correction factor the architecture would
need to know both the max frequency and the current frequency. This
patch defines weak functions for setting both from cpufreq.

Related architecture specific functions use weak function definitions.
The same approach is followed here.

These callbacks can be used to implement frequency scaling of cpu
capacity later.

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 drivers/cpufreq/cpufreq.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 644b54e..1b17608 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -278,6 +278,10 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 }
 #endif
 
+void __weak arch_scale_set_curr_freq(int cpu, unsigned long freq) {}
+
+void __weak arch_scale_set_max_freq(int cpu, unsigned long freq) {}
+
 static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state)
 {
@@ -315,6 +319,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		pr_debug("FREQ: %lu - CPU: %lu\n",
 			 (unsigned long)freqs->new, (unsigned long)freqs->cpu);
 		trace_cpu_frequency(freqs->new, freqs->cpu);
+		arch_scale_set_curr_freq(freqs->cpu, freqs->new);
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
@@ -2164,7 +2169,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 				struct cpufreq_policy *new_policy)
 {
 	struct cpufreq_governor *old_gov;
-	int ret;
+	int ret, cpu;
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
 		 new_policy->cpu, new_policy->min, new_policy->max);
@@ -2202,6 +2207,9 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	policy->min = new_policy->min;
 	policy->max = new_policy->max;
 
+	for_each_cpu(cpu, policy->cpus)
+		arch_scale_set_max_freq(cpu, policy->max);
+
 	pr_debug("new min and max freqs are %u - %u kHz\n",
 		 policy->min, policy->max);
 
-- 
1.9.1


