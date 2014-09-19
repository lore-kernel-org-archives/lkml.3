Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbaISLsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaISLsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:48:52 -0400
Date: Fri, 19 Sep 2014 04:47:54 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-26bc3c50d3b3984564c270da86f1fbbfb774dbcd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Allow all architectures to set '
 capacity_orig'
Git-Commit-ID: 26bc3c50d3b3984564c270da86f1fbbfb774dbcd
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

Commit-ID:  26bc3c50d3b3984564c270da86f1fbbfb774dbcd
Gitweb:     http://git.kernel.org/tip/26bc3c50d3b3984564c270da86f1fbbfb774dbcd
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 26 Aug 2014 13:06:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:27 +0200

sched: Allow all architectures to set 'capacity_orig'

'capacity_orig' is only changed for systems with an SMT sched_domain level in order
to reflect the lower capacity of CPUs. Heterogenous systems also have to reflect an
original capacity that is different from the default value.

Create a more generic function arch_scale_cpu_capacity that can be also used by
non SMT platforms to set capacity_orig.

The __weak implementation of arch_scale_cpu_capacity() is the previous SMT variant,
in order to keep backward compatibility with the use of capacity_orig.

arch_scale_smt_capacity() and default_scale_smt_capacity() have been removed as
they were not used elsewhere than in arch_scale_cpu_capacity().

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
[ Added default_scale_cpu_capacity() back. ]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: riel@redhat.com
Cc: Morten.Rasmussen@arm.com
Cc: efault@gmx.de
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: dietmar.eggemann@arm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409051215-16788-5-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eb87229..be530e4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5705,19 +5705,17 @@ unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
 	return default_scale_capacity(sd, cpu);
 }
 
-static unsigned long default_scale_smt_capacity(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = sd->span_weight;
-	unsigned long smt_gain = sd->smt_gain;
+	if ((sd->flags & SD_SHARE_CPUCAPACITY) && (sd->span_weight > 1))
+		return sd->smt_gain / sd->span_weight;
 
-	smt_gain /= weight;
-
-	return smt_gain;
+	return SCHED_CAPACITY_SCALE;
 }
 
-unsigned long __weak arch_scale_smt_capacity(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	return default_scale_smt_capacity(sd, cpu);
+	return default_scale_cpu_capacity(sd, cpu);
 }
 
 static unsigned long scale_rt_capacity(int cpu)
@@ -5756,18 +5754,15 @@ static unsigned long scale_rt_capacity(int cpu)
 
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = sd->span_weight;
 	unsigned long capacity = SCHED_CAPACITY_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
-		if (sched_feat(ARCH_CAPACITY))
-			capacity *= arch_scale_smt_capacity(sd, cpu);
-		else
-			capacity *= default_scale_smt_capacity(sd, cpu);
+	if (sched_feat(ARCH_CAPACITY))
+		capacity *= arch_scale_cpu_capacity(sd, cpu);
+	else
+		capacity *= default_scale_cpu_capacity(sd, cpu);
 
-		capacity >>= SCHED_CAPACITY_SHIFT;
-	}
+	capacity >>= SCHED_CAPACITY_SHIFT;
 
 	sdg->sgc->capacity_orig = capacity;
 
