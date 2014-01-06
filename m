Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbaAFWqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:46:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaAFWmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Segall <bsegall@google.com>, Peter Zijlstra <peterz@infradead.org>,
        pjt@google.com, Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH 3.4 39/43] sched: Avoid throttle_cfs_rq() racing with period_timer stopping
Date: Mon,  6 Jan 2014 14:39:56 -0800
Message-Id: <20140106223943.364444378@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/debug.c |    8 ++++++++
 kernel/sched/fair.c  |    2 ++
 2 files changed, 10 insertions(+)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -215,6 +215,14 @@ void print_cfs_rq(struct seq_file *m, in
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
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1655,6 +1655,8 @@ static void throttle_cfs_rq(struct cfs_r
 	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	if (!cfs_b->timer_active)
+		__start_cfs_bandwidth(cfs_b);
 	raw_spin_unlock(&cfs_b->lock);
 }
 


