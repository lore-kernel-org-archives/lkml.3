Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab3JPSQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:16:34 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:40330 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934666Ab3JPSQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:16:28 -0400
Subject: [PATCH 4/5] sched: Guarantee new group-entities always have weight
To: peterz@infradead.org, mingo@redhat.com
From: Ben Segall <bsegall@google.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 11:16:27 -0700
Message-ID: <20131016181627.22647.47543.stgit@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

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
---
 kernel/sched/fair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fc44cc3..424c294 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7207,7 +7207,8 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
+	/* guarantee group entities always have weight */
+	update_load_set(&se->load, NICE_0_LOAD);
 	se->parent = parent;
 }
 

