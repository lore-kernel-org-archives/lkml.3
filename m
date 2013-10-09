Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab3JIReC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:34:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3JIRd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:33:59 -0400
Date: Wed, 9 Oct 2013 10:33:22 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-3e6a9418cf05638b103e34f5d13be0321872e623@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-58-git-send-email-mgorman@suse.de>
References: <1381141781-10992-58-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Take false sharing into account when adapting scan rate
Git-Commit-ID: 3e6a9418cf05638b103e34f5d13be0321872e623
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:33:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e6a9418cf05638b103e34f5d13be0321872e623
Gitweb:     http://git.kernel.org/tip/3e6a9418cf05638b103e34f5d13be0321872e623
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:14 +0200

sched/numa: Take false sharing into account when adapting scan rate

Scan rate is altered based on whether shared/private faults dominated.
task_numa_group() may detect false sharing but that information is not
taken into account when adapting the scan rate. Take it into account.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-58-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 222c2d0..d26a16e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1381,7 +1381,8 @@ static void double_lock(spinlock_t *l1, spinlock_t *l2)
 	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
 }
 
-static void task_numa_group(struct task_struct *p, int cpupid, int flags)
+static void task_numa_group(struct task_struct *p, int cpupid, int flags,
+			int *priv)
 {
 	struct numa_group *grp, *my_grp;
 	struct task_struct *tsk;
@@ -1447,6 +1448,9 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags)
 	if (flags & TNF_SHARED)
 		join = true;
 
+	/* Update priv based on whether false sharing was detected */
+	*priv = !join;
+
 	if (join && !get_numa_group(grp))
 		join = false;
 
@@ -1545,7 +1549,7 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 	} else {
 		priv = cpupid_match_pid(p, last_cpupid);
 		if (!priv && !(flags & TNF_NO_GROUP))
-			task_numa_group(p, last_cpupid, flags);
+			task_numa_group(p, last_cpupid, flags, &priv);
 	}
 
 	/*
