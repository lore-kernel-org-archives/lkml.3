Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3JKRTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:19:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48687 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3JKRTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:32 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 5/7] sched: power: Increase cpu capacity based on rq tracked load
Date: Fri, 11 Oct 2013 18:19:15 +0100
Message-Id: <1381511957-29776-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 11 Oct 2013 17:19:29.0458 (UTC) FILETIME=[0B2B4920:01CEC6A6]
X-MC-Unique: 113101118193006201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHK8s2031566

weighted_cpuload() gives the sum of priority scaled task loads. One
NICE 0 task is not be enough load to trigger a cpu capacity increase
when cpu_power > 1024. The rq->avg.runnable_avg_sum tracks the actual
busy time of the cpu and is therefore a more accurate indication of
the cpu load. If the rq tracked load is high the cpu is busy even if
the weighted_cpuload() should indicate otherwise.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea8d973..ee87e65 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2861,7 +2861,17 @@ static inline void inc_cpu_capacity(int cpu, struct task_struct *p)
 	if (p && p->flags & PF_WQ_WORKER)
 		return;
 
-	if (weighted_cpuload(cpu) > power_of(cpu))
+	if (weighted_cpuload(cpu) > power_of(cpu)) {
+		go_faster(cpu, 0);
+		return;
+	}
+
+	/*
+	 * Go faster if the cpu is 80% busy. This threshold should
+	 * be set by the power driver later.
+	 */
+	if (cpu_rq(cpu)->avg.runnable_avg_sum * 100 >
+		80 * cpu_rq(cpu)->avg.runnable_avg_period)
 		go_faster(cpu, 0);
 }
 
-- 
1.7.9.5


