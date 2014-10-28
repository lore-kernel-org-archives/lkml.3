Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaJ1LLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:11:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbaJ1LLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:11:37 -0400
Date: Tue, 28 Oct 2014 04:10:33 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e23738a7300a7591a57a22f47b813fd1b53ec404@git.kernel.org>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, hpa@zytor.com,
        john@johnmccutchan.com, eparis@parisplace.org, rlove@rlove.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org,
        oleg@redhat.com, viro@zeniv.linux.org.uk
Reply-To: viro@zeniv.linux.org.uk, oleg@redhat.com, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, rlove@rlove.org,
        eparis@parisplace.org, john@johnmccutchan.com, hpa@zytor.com,
        peterz@infradead.org, torvalds@linux-foundation.org
In-Reply-To: <20140924082242.254858080@infradead.org>
References: <20140924082242.254858080@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, inotify: Deal with nested sleeps
Git-Commit-ID: e23738a7300a7591a57a22f47b813fd1b53ec404
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e23738a7300a7591a57a22f47b813fd1b53ec404
Gitweb:     http://git.kernel.org/tip/e23738a7300a7591a57a22f47b813fd1b53ec404
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:55:37 +0100

sched, inotify: Deal with nested sleeps

inotify_read is a wait loop with sleeps in. Wait loops rely on
task_struct::state and sleeps do too, since that's the only means of
actually sleeping. Therefore the nested sleeps destroy the wait loop
state and the wait loop breaks the sleep functions that assume
TASK_RUNNING (mutex_lock).

Fix this by using the new woken_wake_function and wait_woken() stuff,
which registers wakeups in wait and thereby allows shrinking the
task_state::state changes to the actual sleep part.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140924082242.254858080@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/notify/inotify/inotify_user.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index daf7665..283aa31 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -227,14 +227,13 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 	struct fsnotify_event *kevent;
 	char __user *start;
 	int ret;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	start = buf;
 	group = file->private_data;
 
+	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
-
 		mutex_lock(&group->notification_mutex);
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
@@ -264,10 +263,10 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 		if (start != buf)
 			break;
 
-		schedule();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
+	remove_wait_queue(&group->notification_waitq, &wait);
 
-	finish_wait(&group->notification_waitq, &wait);
 	if (start != buf && ret != -EFAULT)
 		ret = buf - start;
 	return ret;
