Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaBLIW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:22:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50269 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbaBLIOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:07 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Mike Galbraith" <efault@gmx.de>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.238807692@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 77/79] sched,rt: fix isolated CPUs leaving
 root_task_group indefinitely throttled
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched_rt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -587,6 +587,19 @@ static int do_sched_rt_period_timer(stru
 		return 1;
 
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

