Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3CVM3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:29:48 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54682 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab3CVM3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:29:45 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v3 5/6] sched: pack the idle load balance
Date: Fri, 22 Mar 2013 13:25:54 +0100
Message-Id: <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look for an idle CPU close to the pack buddy CPU whenever possible.
The goal is to prevent the wake up of a CPU which doesn't share the power
domain of the pack buddy CPU.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b636199..52a7736 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5455,7 +5455,25 @@ static struct {
 
 static inline int find_new_ilb(int call_cpu)
 {
+	struct sched_domain *sd;
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int buddy = per_cpu(sd_pack_buddy, call_cpu);
+
+	/*
+	 * If we have a pack buddy CPU, we try to run load balance on a CPU
+	 * that is close to the buddy.
+	 */
+	if (buddy != -1)
+		for_each_domain(buddy, sd) {
+			if (sd->flags & SD_SHARE_CPUPOWER)
+				continue;
+
+			ilb = cpumask_first_and(sched_domain_span(sd),
+					nohz.idle_cpus_mask);
+
+			if (ilb < nr_cpu_ids)
+				break;
+		}
 
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
-- 
1.7.9.5

