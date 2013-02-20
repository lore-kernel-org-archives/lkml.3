Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3BTFNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:13:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:14217 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3BTFNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:13:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="259142084"
Message-ID: <51245B77.6000509@intel.com>
Date: Wed, 20 Feb 2013 13:13:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, namhyung@kernel.org,
        efault@gmx.de, vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 07/18] sched: set initial load avg of new forked task
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <1358996820-23036-8-git-send-email-alex.shi@intel.com> <1360664784.4485.17.camel@laptop> <511BADE3.4050009@intel.com> <CAPM31RJw7a-+QNRwwukg3h3bHCQs++cnT3DgCyHaJTZY7qDsXA@mail.gmail.com> <511CE1AB.5020503@intel.com> <CAPM31RKf6Gint-fPxfuFkXxxbpJfkk=5=5v3W0uxvTnnvOoM-A@mail.gmail.com>
In-Reply-To: <CAPM31RKf6Gint-fPxfuFkXxxbpJfkk=5=5v3W0uxvTnnvOoM-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is my concern about making this a special case with the
> introduction ENQUEUE_NEWTASK flag; enqueue jumps through enough hoops
> as it is.
> 
> I still don't see why we can't resolve this at init time in
> __sched_fork(); your patch above just moves an explicit initialization
> of load_avg_contrib into the enqueue path.  Adding a call to
> __update_task_entity_contrib() to the previous alternate suggestion
> would similarly seem to resolve this?
> 

Without ENQUEUE_NEWTASK flag, we can use the following patch. That embeds
 the new fork with a implicate way.

but since the newtask flag just follows existing enqueue path, it also
looks natural and is a explicit way.

I am ok for alternate of solutions.

=======
>From 0f5dd6babe899e27cfb78ea49d337e4f0918591b Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Wed, 20 Feb 2013 12:51:28 +0800
Subject: [PATCH 02/15] sched: set initial load avg of new forked task

New task has no runnable sum at its first runnable time, so its
runnable load is zero. That makes burst forking balancing just select
few idle cpus to assign tasks if we engage runnable load in balancing.

Set initial load avg of new forked task as its load weight to resolve
this issue.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 2 ++
 kernel/sched/fair.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1743746..93a7590 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1648,6 +1648,8 @@ void sched_fork(struct task_struct *p)
 		p->sched_reset_on_fork = 0;
 	}
 
+	p->se.avg.load_avg_contrib = p->se.load.weight;
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81fa536..cae5134 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1509,6 +1509,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
 	 * accumulated while sleeping.
+	 *
+	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
+	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib initial
+	 * value: se->load.weight.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
 		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
-- 
1.7.12

