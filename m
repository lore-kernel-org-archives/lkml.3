Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab3DYR1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:27:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57497 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981Ab3DYRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:24:58 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net,
        l.majewski@samsung.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 04/14] sched: pack the idle load balance
Date: Thu, 25 Apr 2013 19:23:20 +0200
Message-Id: <1366910611-20048-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look for an idle CPU close to the pack buddy CPU whenever possible.
The goal is to prevent the wake up of a CPU which doesn't share the power
domain of the pack buddy CPU.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6adc57c..a985c98 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5469,7 +5469,26 @@ static struct {
 
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
+	if (buddy != -1) {
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
+	}
 
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
-- 
1.7.9.5

