Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbbAIMdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:33:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbbAIMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:33:47 -0500
Date: Fri, 9 Jan 2015 04:33:07 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-536ebe9ca999f6d0903d91698678ccc1742e8dd9@git.kernel.org>
Cc: sedat.dilek@gmail.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, tglx@linutronix.de, peterz@infradead.org,
        tiwai@suse.de, mingo@kernel.org, hpa@zytor.com, eparis@redhat.com,
        yuanhan.liu@linux.intel.com, linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, tiwai@suse.de,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, sedat.dilek@gmail.com,
        linux-kernel@vger.kernel.org, yuanhan.liu@linux.intel.com,
        eparis@redhat.com
In-Reply-To: <20141216152838.GZ3337@twins.programming.kicks-ass.net>
References: <20141216152838.GZ3337@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, fanotify: Deal with nested sleeps
Git-Commit-ID: 536ebe9ca999f6d0903d91698678ccc1742e8dd9
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

Commit-ID:  536ebe9ca999f6d0903d91698678ccc1742e8dd9
Gitweb:     http://git.kernel.org/tip/536ebe9ca999f6d0903d91698678ccc1742e8dd9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 16 Dec 2014 16:28:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:18:12 +0100

sched, fanotify: Deal with nested sleeps

As per e23738a7300a ("sched, inotify: Deal with nested sleeps").

fanotify_read is a wait loop with sleeps in. Wait loops rely on
task_struct::state and sleeps do too, since that's the only means of
actually sleeping. Therefore the nested sleeps destroy the wait loop
state and the wait loop breaks the sleep functions that assume
TASK_RUNNING (mutex_lock).

Fix this by using the new woken_wake_function and wait_woken() stuff,
which registers wakeups in wait and thereby allows shrinking the
task_state::state changes to the actual sleep part.

Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>
Link: http://lkml.kernel.org/r/20141216152838.GZ3337@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c991616..bff8567 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -259,16 +259,15 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 	struct fsnotify_event *kevent;
 	char __user *start;
 	int ret;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	start = buf;
 	group = file->private_data;
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
+	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
-
 		mutex_lock(&group->notification_mutex);
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
@@ -289,7 +288,8 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 
 			if (start != buf)
 				break;
-			schedule();
+
+			wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 			continue;
 		}
 
@@ -318,8 +318,8 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 		buf += ret;
 		count -= ret;
 	}
+	remove_wait_queue(&group->notification_waitq, &wait);
 
-	finish_wait(&group->notification_waitq, &wait);
 	if (start != buf && ret != -EFAULT)
 		ret = buf - start;
 	return ret;
