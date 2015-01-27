Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbbA0MrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:47:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbbA0MR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 024/126] exit: fix race between wait_consider_task() and wait_task_zombie()
Date: Tue, 27 Jan 2015 12:15:29 +0000
Message-Id: <1422361031-19364-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 3245d6acab981a2388ffb877c7ecc97e763c59d4 upstream.

wait_consider_task() checks EXIT_ZOMBIE after EXIT_DEAD/EXIT_TRACE and
both checks can fail if we race with EXIT_ZOMBIE -> EXIT_DEAD/EXIT_TRACE
change in between, gcc needs to reload p->exit_state after
security_task_wait().  In this case ->notask_error will be wrongly
cleared and do_wait() can hang forever if it was the last eligible
child.

Many thanks to Arne who carefully investigated the problem.

Note: this bug is very old but it was pure theoretical until commit
b3ab03160dfa ("wait: completely ignore the EXIT_DEAD tasks").  Before
this commit "-O2" was probably enough to guarantee that compiler won't
read ->exit_state twice.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Arne Goedeke <el@laramies.com>
Tested-by: Arne Goedeke <el@laramies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/exit.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index e5c4668f1799..ab2472332043 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1294,9 +1294,15 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
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
@@ -1317,7 +1323,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (unlikely(p->exit_state == EXIT_TRACE)) {
+	if (unlikely(exit_state == EXIT_TRACE)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
 		 * we should clear notask_error, debugger will notify us.
@@ -1344,7 +1350,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	}
 
 	/* slay zombie? */
-	if (p->exit_state == EXIT_ZOMBIE) {
+	if (exit_state == EXIT_ZOMBIE) {
 		/* we don't reap group leaders with subthreads */
 		if (!delay_group_leader(p)) {
 			/*
-- 
2.1.4

