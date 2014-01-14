Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaANBNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:13:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaANA0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH 3.4 27/27] sched: Guarantee new group-entities always have weight
Date: Mon, 13 Jan 2014 16:26:41 -0800
Message-Id: <20140114002624.147367781@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
References: <20140114002623.356220317@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5470,7 +5470,8 @@ void init_tg_cfs_entry(struct task_group
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
+	/* guarantee group entities always have weight */
+	update_load_set(&se->load, NICE_0_LOAD);
 	se->parent = parent;
 }
 


