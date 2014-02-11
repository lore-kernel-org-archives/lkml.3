Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaBKTKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:10:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaBKTIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 25/30] sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled
Date: Tue, 11 Feb 2014 11:06:25 -0800
Message-Id: <20140211184647.863707963@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit e221d028bb08b47e624c5f0a31732c642db9d19a upstream.

Root task group bandwidth replenishment must service all CPUs, regardless of
where the timer was last started, and regardless of the isolation mechanism,
lest 'Quoth the Raven, "Nevermore"' become rt scheduling policy.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344326558.6968.25.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/rt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -782,6 +782,19 @@ static int do_sched_rt_period_timer(stru
 	const struct cpumask *span;
 
 	span = sched_rt_period_mask();
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * FIXME: isolated CPUs should really leave the root task group,
+	 * whether they are isolcpus or were isolated via cpusets, lest
+	 * the timer run on a CPU which does not service all runqueues,
+	 * potentially leaving other CPUs indefinitely throttled.  If
+	 * isolation is really required, the user will turn the throttle
+	 * off to kill the perturbations it causes anyway.  Meanwhile,
+	 * this maintains functionality for boot and/or troubleshooting.
+	 */
+	if (rt_b == &root_task_group.rt_bandwidth)
+		span = cpu_online_mask;
+#endif
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);


