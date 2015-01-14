Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbbANHcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:32:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbbANHcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:32:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Arne Goedeke <el@laramies.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.18 146/150] exit: fix race between wait_consider_task() and wait_task_zombie()
Date: Tue, 13 Jan 2015 23:23:37 -0800
Message-Id: <20150114072102.456318034@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1302,9 +1302,15 @@ static int wait_task_continued(struct wa
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
@@ -1325,7 +1331,7 @@ static int wait_consider_task(struct wai
 		return 0;
 	}
 
-	if (unlikely(p->exit_state == EXIT_TRACE)) {
+	if (unlikely(exit_state == EXIT_TRACE)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
 		 * we should clear notask_error, debugger will notify us.
@@ -1352,7 +1358,7 @@ static int wait_consider_task(struct wai
 	}
 
 	/* slay zombie? */
-	if (p->exit_state == EXIT_ZOMBIE) {
+	if (exit_state == EXIT_ZOMBIE) {
 		/* we don't reap group leaders with subthreads */
 		if (!delay_group_leader(p)) {
 			/*


