Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3L2DCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:02:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55006 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab3L2CJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ben Segall" <bsegall@google.com>, pjt@google.com
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.974768125@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 147/185] sched: Avoid throttle_cfs_rq() racing with
 period_timer stopping
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Segall <bsegall@google.com>

commit f9f9ffc237dd924f048204e8799da74f9ecf40cf upstream.

throttle_cfs_rq() doesn't check to make sure that period_timer is running,
and while update_curr/assign_cfs_runtime does, a concurrently running
period_timer on another cpu could cancel itself between this cpu's
update_curr and throttle_cfs_rq(). If there are no other cfs_rqs running
in the tg to restart the timer, this causes the cfs_rq to be stranded
forever.

Fix this by calling __start_cfs_bandwidth() in throttle if the timer is
inactive.

(Also add some sched_debug lines for cfs_bandwidth.)

Tested: make a run/sleep task in a cgroup, loop switching the cgroup
between 1ms/100ms quota and unlimited, checking for timer_active=0 and
throttled=1 as a failure. With the throttle_cfs_rq() change commented out
this fails, with the full patch it passes.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/20131016181632.22647.84174.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: adjust filenames]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched_debug.c |    8 ++++++++
 kernel/sched_fair.c  |    2 ++
 2 files changed, 10 insertions(+)

--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -213,6 +213,14 @@ void print_cfs_rq(struct seq_file *m, in
 	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
 			atomic_read(&cfs_rq->tg->load_weight));
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->cfs_bandwidth.timer_active",
+			cfs_rq->tg->cfs_bandwidth.timer_active);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttled",
+			cfs_rq->throttled);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttle_count",
+			cfs_rq->throttle_count);
+#endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1527,6 +1527,8 @@ static void throttle_cfs_rq(struct cfs_r
 	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	if (!cfs_b->timer_active)
+		__start_cfs_bandwidth(cfs_b);
 	raw_spin_unlock(&cfs_b->lock);
 }
 

