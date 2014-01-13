Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaAMOmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:42:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51524 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaAMO0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 73/96] sched: Guarantee new group-entities always have weight
Date: Mon, 13 Jan 2014 14:24:36 +0000
Message-Id: <1389623099-18783-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Turner <pjt@google.com>

commit 0ac9b1c21874d2490331233b3242085f8151e166 upstream.

Currently, group entity load-weights are initialized to zero. This
admits some races with respect to the first time they are re-weighted in
earlty use. ( Let g[x] denote the se for "g" on cpu "x". )

Suppose that we have root->a and that a enters a throttled state,
immediately followed by a[0]->t1 (the only task running on cpu[0])
blocking:

  put_prev_task(group_cfs_rq(a[0]), t1)
  put_prev_entity(..., t1)
  check_cfs_rq_runtime(group_cfs_rq(a[0]))
  throttle_cfs_rq(group_cfs_rq(a[0]))

Then, before unthrottling occurs, let a[0]->b[0]->t2 wake for the first
time:

  enqueue_task_fair(rq[0], t2)
  enqueue_entity(group_cfs_rq(b[0]), t2)
  enqueue_entity_load_avg(group_cfs_rq(b[0]), t2)
  account_entity_enqueue(group_cfs_ra(b[0]), t2)
  update_cfs_shares(group_cfs_rq(b[0]))
  < skipped because b is part of a throttled hierarchy >
  enqueue_entity(group_cfs_rq(a[0]), b[0])
  ...

We now have b[0] enqueued, yet group_cfs_rq(a[0])->load.weight == 0
which violates invariants in several code-paths. Eliminate the
possibility of this by initializing group entity weight.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131016181627.22647.47543.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a7450fd..9e2fe1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5209,7 +5209,8 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
+	/* guarantee group entities always have weight */
+	update_load_set(&se->load, NICE_0_LOAD);
 	se->parent = parent;
 }
 
-- 
1.8.3.2

