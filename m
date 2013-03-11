Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3CKJNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:13:22 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:11153 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab3CKJNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:13:19 -0400
Message-ID: <513DA024.80404@parallels.com>
Date: Mon, 11 Mar 2013 13:13:08 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] posix-timers: Show sigevent info in proc file
References: <513D9FD9.6020507@parallels.com>
In-Reply-To: <513D9FD9.6020507@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This information is enough to understand how the timer_create() was
called for each particular timer.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
---
 fs/proc/base.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

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
 
-- 
1.7.6.5
