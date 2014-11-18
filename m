Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbaKRVaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:30:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaKRVaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:30:17 -0500
Date: Tue, 18 Nov 2014 22:30:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] exit: reparent: fix the cross-namespace
	PR_SET_CHILD_SUBREAPER reparenting
Message-ID: <20141118213017.GA5017@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212952.GA4754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_new_reaper() assumes that "has_child_subreaper" logic is safe as
long as we are not the exiting ->child_reaper and this is doubly wrong:

1. In fact it is safe if "pid_ns->child_reaper == father"; there must
   be no children after zap_pid_ns_processes() returns, so it doesn't
   matter what we return in this case and even pid_ns->child_reaper is
   wrong otherwise: we can't reparent to ->child_reaper == current.

   This is not a bug, but this is confusing.

2. It is not safe if we are not pid_ns->child_reaper but from the same
   thread group. We drop tasklist_lock before zap_pid_ns_processes(),
   so another thread can lock it and choose the new reaper from the
   upper namespace if has_child_subreaper == T, and this is obviously
   wrong.

   This is not that bad, zap_pid_ns_processes() won't return until the
   the new reaper reaps all zombies, but this should be fixed anyway.

We could change for_each_thread() loop to use ->exit_state instead of
PF_EXITING which we had to use until 8aac62706ada, or we could change
copy_signal() to check CLONE_NEWPID before setting has_child_subreaper,
but lets change this code so that it is clear we can't look outside of
our namespace, otherwise same_thread_group(reaper, child_reaper) check
will look wrong and confusing anyway.

We can simply start from "father" and fix the problem. We can't wrongly
return a thread from the same thread group if ->is_child_subreaper == T,
we know that all threads have PF_EXITING set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 31da440..9ade2f5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -492,7 +492,9 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
-	} else if (father->signal->has_child_subreaper) {
+	}
+
+	if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
 		/*
@@ -502,7 +504,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 		 * PID namespace. However we still need the check above, see
 		 * http://marc.info/?l=linux-kernel&m=131385460420380
 		 */
-		for (reaper = father->real_parent;
+		for (reaper = father;
 		     reaper != &init_task;
 		     reaper = reaper->real_parent) {
 			if (same_thread_group(reaper, pid_ns->child_reaper))
-- 
1.5.5.1

