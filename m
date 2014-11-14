Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076AbaKNBiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:38:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934808AbaKNBiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:38:13 -0500
Date: Fri, 14 Nov 2014 02:38:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rik van Riel <riel@redhat.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] exit: wait: drop tasklist_lock before psig->c*
	accounting
Message-ID: <20141114013820.GA5126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114013750.GA4697@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_zombie() no longer needs tasklist_lock to accumulate the
psig->c* counters, we can drop it right after cmpxchg(exit_state).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 40d53de..e0914eb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1003,6 +1003,10 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
+	/*
+	 * We own this thread, nobody else can reap it.
+	 */
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * Check thread_group_leader() to exclude the traced sub-threads.
@@ -1062,12 +1066,6 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-	/*
-	 * Now we are sure this task is interesting, and no other
-	 * thread can reap it because we its state == DEAD/TRACE.
-	 */
-	read_unlock(&tasklist_lock);
-
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
-- 
1.5.5.1

