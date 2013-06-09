Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3FIREe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3FIREb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:04:31 -0400
Date: Sun, 9 Jun 2013 19:00:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] copy_process: consolidate the lockless CLONE_THREAD
	checks
Message-ID: <20130609170031.GA5246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609170007.GA5215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_process() does a lot of "chaotic" initializations and checks
CLONE_THREAD twice before it takes tasklist. In particular it sets
"p->group_leader = p" and then changes it again under tasklist if
!thread_group_leader(p).

This looks a bit confusing, lets create a single "if (CLONE_THREAD)"
block which initializes ->exit_signal, ->group_leader, and ->tgid.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c836e3c..b6818a8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1360,11 +1360,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			goto bad_fork_cleanup_io;
 	}
 
-	p->pid = pid_nr(pid);
-	p->tgid = p->pid;
-	if (clone_flags & CLONE_THREAD)
-		p->tgid = current->tgid;
-
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
@@ -1400,12 +1395,19 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	clear_all_latency_tracing(p);
 
 	/* ok, now we should be set up.. */
-	if (clone_flags & CLONE_THREAD)
+	p->pid = pid_nr(pid);
+	if (clone_flags & CLONE_THREAD) {
 		p->exit_signal = -1;
-	else if (clone_flags & CLONE_PARENT)
-		p->exit_signal = current->group_leader->exit_signal;
-	else
-		p->exit_signal = (clone_flags & CSIGNAL);
+		p->group_leader = current->group_leader;
+		p->tgid = current->tgid;
+	} else {
+		if (clone_flags & CLONE_PARENT)
+			p->exit_signal = current->group_leader->exit_signal;
+		else
+			p->exit_signal = (clone_flags & CSIGNAL);
+		p->group_leader = p;
+		p->tgid = p->pid;
+	}
 
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
@@ -1414,15 +1416,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
 
-	/*
-	 * Ok, make it visible to the rest of the system.
-	 * We dont wake it up yet.
-	 */
-	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
-	/* Need tasklist lock for parent etc handling! */
+	/*
+	 * Make it visible to the rest of the system, but dont wake it up yet.
+	 * Need tasklist lock for parent etc handling!
+	 */
 	write_lock_irq(&tasklist_lock);
 
 	/* CLONE_PARENT re-uses the old parent */
@@ -1476,7 +1476,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			current->signal->nr_threads++;
 			atomic_inc(&current->signal->live);
 			atomic_inc(&current->signal->sigcnt);
-			p->group_leader = current->group_leader;
 			list_add_tail_rcu(&p->thread_group,
 					  &p->group_leader->thread_group);
 		}
-- 
1.5.5.1

