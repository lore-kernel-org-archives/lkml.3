Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab3DQT4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:56:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873Ab3DQT4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:56:17 -0400
Date: Wed, 17 Apr 2013 12:56:04 -0700
From: tip-bot for Pavel Emelyanov <tipbot@zytor.com>
Message-ID: <tip-57b8015e07a70301e9ec9f324db1a8b73b5a1e2b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matt.helsley@gmail.com, peterz@infradead.org, xemul@parallels.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, peterz@infradead.org, xemul@parallels.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <513DA024.80404@parallels.com>
References: <513DA024.80404@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Show sigevent info in proc file
Git-Commit-ID: 57b8015e07a70301e9ec9f324db1a8b73b5a1e2b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 12:56:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57b8015e07a70301e9ec9f324db1a8b73b5a1e2b
Gitweb:     http://git.kernel.org/tip/57b8015e07a70301e9ec9f324db1a8b73b5a1e2b
Author:     Pavel Emelyanov <xemul@parallels.com>
AuthorDate: Mon, 11 Mar 2013 13:13:08 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Apr 2013 20:51:01 +0200

posix-timers: Show sigevent info in proc file

Previous patch added proc file to list posix timers created by task.
Expand the information provided in this file by adding info about
notification method, with which timers were created. I.e. after
the "ID:" line there go

1. "signal:" line, that shows signal number and sigval bits;
2. "notify:" line, that shows the timer notification method.

Thus the timer entry would looke like this:

ID: 123
signal: 14/0000000000b005d0
notify: signal/pid.732

This information is enough to understand how timer_create() was called
for each particular timer.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Link: http://lkml.kernel.org/r/513DA024.80404@parallels.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/base.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01def9f..a193086 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2018,6 +2018,7 @@ struct timers_private {
 	struct pid *pid;
 	struct task_struct *task;
 	struct sighand_struct *sighand;
+	struct pid_namespace *ns;
 	unsigned long flags;
 };
 
@@ -2060,9 +2061,24 @@ static void timers_stop(struct seq_file *m, void *v)
 static int show_timer(struct seq_file *m, void *v)
 {
 	struct k_itimer *timer;
+	struct timers_private *tp = m->private;
+	int notify;
+	static char *nstr[] = {
+		[SIGEV_SIGNAL] = "signal",
+		[SIGEV_NONE] = "none",
+		[SIGEV_THREAD] = "thread",
+	};
 
 	timer = list_entry((struct list_head *)v, struct k_itimer, list);
+	notify = timer->it_sigev_notify;
+
 	seq_printf(m, "ID: %d\n", timer->it_id);
+	seq_printf(m, "signal: %d/%p\n", timer->sigq->info.si_signo,
+			timer->sigq->info.si_value.sival_ptr);
+	seq_printf(m, "notify: %s/%s.%d\n",
+		nstr[notify & ~SIGEV_THREAD_ID],
+		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
+		pid_nr_ns(timer->it_pid, tp->ns));
 
 	return 0;
 }
@@ -2084,6 +2100,7 @@ static int proc_timers_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	tp->pid = proc_pid(inode);
+	tp->ns = inode->i_sb->s_fs_info;
 	return 0;
 }
 
