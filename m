Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaHDKkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:40:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaHDKkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:40:01 -0400
Message-Id: <20140804103537.564978189@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 12:30:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 4/7] inotify: Deal with nested sleeps
References: <20140804103025.478913141@infradead.org>
Content-Disposition: inline; filename=peterz-might_sleep-inotify.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify_read is a wait loop with sleeps in. Wait loops rely on
task_struct::state and sleeps do too, since that's the only means of
actually sleeping. Therefore the nested sleeps destroy the wait loop
state and the wait loop breaks the sleep functions that assume
TASK_RUNNING (mutex_lock).

Fix this by using the new woken_wake_function and wait_woken() stuff,
which registers wakeups in wait and thereby allows shrinking the
task_state::state changes to the actual sleep part.

Cc: Eric Paris <eparis@parisplace.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 fs/notify/inotify/inotify_user.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -227,14 +227,13 @@ static ssize_t inotify_read(struct file
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
@@ -264,10 +263,10 @@ static ssize_t inotify_read(struct file
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


