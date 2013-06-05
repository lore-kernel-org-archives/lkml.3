Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3FEJgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:36:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3FEJgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:36:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [ 020/184] ptrace: ensure arch_ptrace/ptrace_request can never
References: <20130604172131.136042108@1wt.eu>
Date: Wed, 05 Jun 2013 10:36:06 +0100
Message-ID: <87sj0wucft.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
>  race with SIGKILL
>
> From: Oleg Nesterov <oleg@redhat.com>
>
> ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
>

This patch actually introduce a regression in the Ubuntu kernel.  You
may want to include the fix below.

http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-lucid.git;a=commit;h=d06bbd59e5c7a0e0525af764a897028d6d352c36

Cheers,
-- 
Luis

>From d06bbd59e5c7a0e0525af764a897028d6d352c36 Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Thu, 21 Mar 2013 13:57:18 -0700
Subject: [PATCH] Fix ptrace when task is in task_is_stopped(), state

>From d6a1da349c76ac2ebe4774d1da9fb7e660df01d3 Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Thu, 21 Mar 2013 05:04:13 -0700
Subject: [PATCH] UBUNTU: SAUCE: Fix ptrace when task is in task_is_stopped()
 state

This patch fixes a regression in ptrace, introduced by commit 9e74eb39
(backport of 9899d11f) which makes assumptions about ptrace behavior
which are not true in the 2.6.32 kernel.

BugLink: http://bugs.launchpad.net/bugs/1145234

9899d11f makes the assumption that task_is_stopped() is not a valid state
in ptrace because it is built on top of a series of patches which change
how the TASK_STOPPED state is tracked (321fb561 which requires d79fdd6d
and several other patches).

Because Lucid does not have the set of patches that make task_is_stopped()
an invalid state in ptrace_check_attach, partially revert 9e74eb39 so
that ptrace_check_attach() correctly handles task_is_stopped(). However
we must replace the assignment of TASK_TRACED with __TASK_TRACED to
ensure TASK_WAKEKILL is cleared.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Colin King <colin.king@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 kernel/ptrace.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d0036f0..d9c8c47 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -81,14 +81,18 @@ void __ptrace_unlink(struct task_struct *child)
 }
 
 /* Ensure that nothing can wake it up, even SIGKILL */
-static bool ptrace_freeze_traced(struct task_struct *task)
+static bool ptrace_freeze_traced(struct task_struct *task, int kill)
 {
-	bool ret = false;
+	bool ret = true;
 
 	spin_lock_irq(&task->sighand->siglock);
-	if (task_is_traced(task) && !__fatal_signal_pending(task)) {
+	if (task_is_stopped(task) && !__fatal_signal_pending(task))
 		task->state = __TASK_TRACED;
-		ret = true;
+	else if (!kill) {
+		if (task_is_traced(task) && !__fatal_signal_pending(task))
+			task->state = __TASK_TRACED;
+		else
+			ret = false;
 	}
 	spin_unlock_irq(&task->sighand->siglock);
 
@@ -131,7 +135,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 		 * child->sighand can't be NULL, release_task()
 		 * does ptrace_unlink() before __exit_signal().
 		 */
-		if (kill || ptrace_freeze_traced(child))
+		if (ptrace_freeze_traced(child, kill))
 			ret = 0;
 	}
 	read_unlock(&tasklist_lock);
-- 
1.8.1.2

