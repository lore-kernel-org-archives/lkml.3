Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3J2OK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:10:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45885 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab3J2OIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:08:12 -0400
Date: Tue, 29 Oct 2013 07:07:40 -0700
From: tip-bot for Paul Turner <tipbot@zytor.com>
Message-ID: <tip-0ac9b1c21874d2490331233b3242085f8151e166@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131016181627.22647.47543.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181627.22647.47543.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Guarantee new group-entities always have weight
Git-Commit-ID: 0ac9b1c21874d2490331233b3242085f8151e166
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:07:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ac9b1c21874d2490331233b3242085f8151e166
Gitweb:     http://git.kernel.org/tip/0ac9b1c21874d2490331233b3242085f8151e166
Author:     Paul Turner <pjt@google.com>
AuthorDate: Wed, 16 Oct 2013 11:16:27 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:23 +0100

sched: Guarantee new group-entities always have weight

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
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f6308cb..0923ab2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7198,7 +7198,8 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
+	/* guarantee group entities always have weight */
+	update_load_set(&se->load, NICE_0_LOAD);
 	se->parent = parent;
 }
 
