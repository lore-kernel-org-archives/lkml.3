Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbaLORwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:52:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaLORwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:52:05 -0500
Date: Mon, 15 Dec 2014 18:51:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arne Goedeke <el@laramies.com>, Michal Schmidt <mschmidt@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] exit: fix race between wait_consider_task() and
	wait_task_zombie()
Message-ID: <20141215175137.GB22413@redhat.com>
References: <20141215175111.GA22413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215175111.GA22413@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_consider_task() checks EXIT_ZOMBIE after EXIT_DEAD/EXIT_TRACE and both
checks can fail if we race with EXIT_ZOMBIE -> EXIT_DEAD/EXIT_TRACE change
in between, gcc needs to reload p->exit_state after security_task_wait().
In this case ->notask_error will be wrongly cleared and do_wait() can hang
forever if it was the last eligible child.

Many thanks to Arne who carefully investigated the problem.

Note: this bug is very old but it was pure theoretical until b3ab03160dfa
"wait: completely ignore the EXIT_DEAD tasks". Before this commit "-O2" was
probably enough to guarantee that compiler won't read ->exit_state twice.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Arne Goedeke <el@laramies.com>
Tested-by: Arne Goedeke <el@laramies.com>
Cc: <stable@vger.kernel.org> # v3.15+
---
 kernel/exit.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 43394f7..37efc8e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1303,9 +1303,15 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 static int wait_consider_task(struct wait_opts *wo, int ptrace,
 				struct task_struct *p)
 {
+	/*
+	 * We can race with wait_task_zombie() from another thread.
+	 * Ensure that EXIT_ZOMBIE -> EXIT_DEAD/EXIT_TRACE transition
+	 * can't confuse the checks below.
+	 */
+	int exit_state = ACCESS_ONCE(p->exit_state);
 	int ret;
 
-	if (unlikely(p->exit_state == EXIT_DEAD))
+	if (unlikely(exit_state == EXIT_DEAD))
 		return 0;
 
 	ret = eligible_child(wo, p);
@@ -1326,7 +1332,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (unlikely(p->exit_state == EXIT_TRACE)) {
+	if (unlikely(exit_state == EXIT_TRACE)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
 		 * we should clear notask_error, debugger will notify us.
@@ -1353,7 +1359,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	}
 
 	/* slay zombie? */
-	if (p->exit_state == EXIT_ZOMBIE) {
+	if (exit_state == EXIT_ZOMBIE) {
 		/* we don't reap group leaders with subthreads */
 		if (!delay_group_leader(p)) {
 			/*
-- 
1.5.5.1


