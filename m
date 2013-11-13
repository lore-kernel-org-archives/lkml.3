Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab3KMR00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:26:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab3KMR0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:26:11 -0500
Date: Wed, 13 Nov 2013 09:25:32 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-5eca82a9ac2c961cfbd26a4b6f43e6e3747a71dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, mgorman@suse.de, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mgorman@suse.de, tglx@linutronix.de,
        prarit@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/numa: Cure update_numa_stats()
  vs. hotplug
Git-Commit-ID: 5eca82a9ac2c961cfbd26a4b6f43e6e3747a71dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 09:25:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5eca82a9ac2c961cfbd26a4b6f43e6e3747a71dd
Gitweb:     http://git.kernel.org/tip/5eca82a9ac2c961cfbd26a4b6f43e6e3747a71dd
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 6 Nov 2013 18:47:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Nov 2013 13:33:52 +0100

sched/numa: Cure update_numa_stats() vs. hotplug

Because we're completely unserialized against hotplug its well
possible to try and generate numa stats for an offlined node.

Bail out early (and avoid a /0) in this case. The resulting stats are
all 0 which should result in an undesirable balance target -- not to
mention that actually trying to migrate to an offline CPU will fail.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Link: http://lkml.kernel.org/n/tip-orja0qylcvyhxfsuebcyL5sI@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c11e36f..201be78 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1000,7 +1000,7 @@ struct numa_stats {
  */
 static void update_numa_stats(struct numa_stats *ns, int nid)
 {
-	int cpu;
+	int cpu, cpus = 0;
 
 	memset(ns, 0, sizeof(*ns));
 	for_each_cpu(cpu, cpumask_of_node(nid)) {
@@ -1009,8 +1009,21 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 		ns->nr_running += rq->nr_running;
 		ns->load += weighted_cpuload(cpu);
 		ns->power += power_of(cpu);
+
+		cpus++;
 	}
 
+	/*
+	 * If we raced with hotplug and there are no CPUs left in our mask
+	 * the @ns structure is NULL'ed and task_numa_compare() will
+	 * not find this node attractive.
+	 *
+	 * We'll either bail at !has_capacity, or we'll detect a huge imbalance
+	 * and bail there.
+	 */
+	if (!cpus)
+		return;
+
 	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->power;
 	ns->capacity = DIV_ROUND_CLOSEST(ns->power, SCHED_POWER_SCALE);
 	ns->has_capacity = (ns->nr_running < ns->capacity);
