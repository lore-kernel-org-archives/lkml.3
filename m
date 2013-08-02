Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3HBJIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:08:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab3HBJH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:07:56 -0400
Date: Fri, 2 Aug 2013 02:07:35 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-41e85ce8220c6e5fdef706fda6696cd291115b63@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, msb@chromium.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, cww@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, cww@redhat.com, akpm@linux-foundation.org,
        oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20130801165941.GA17544@redhat.com>
References: <20130801165941.GA17544@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hung_task debugging:
  Print more info when reporting the problem
Git-Commit-ID: 41e85ce8220c6e5fdef706fda6696cd291115b63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 02:07:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41e85ce8220c6e5fdef706fda6696cd291115b63
Gitweb:     http://git.kernel.org/tip/41e85ce8220c6e5fdef706fda6696cd291115b63
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 1 Aug 2013 18:59:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 2 Aug 2013 11:02:42 +0200

hung_task debugging: Print more info when reporting the problem

printk(KERN_ERR) from check_hung_task() likely means we have a bug,
but unlike BUG_ON()/WARN_ON ()it doesn't show the kernel version,
this complicates the bug-reports investigation.

Add the additional pr_err() to print tainted/release/version
like dump_stack_print_info() does, the output becomes:

        INFO: task perl:504 blocked for more than 2 seconds.
	      Not tainted 3.11.0-rc1-10367-g136bb46-dirty #1763
        "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
        ...

While at it, turn the old printk's into pr_err().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: ahecox@redhat.com
Cc: Christopher Williams <cww@redhat.com>
Cc: dwysocha@redhat.com
Cc: gavin@redhat.com
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: nshi@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130801165941.GA17544@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/hung_task.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 6df6149..3e97fb1 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -15,6 +15,7 @@
 #include <linux/lockdep.h>
 #include <linux/export.h>
 #include <linux/sysctl.h>
+#include <linux/utsname.h>
 
 /*
  * The number of tasks checked:
@@ -99,10 +100,14 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
-			"%ld seconds.\n", t->comm, t->pid, timeout);
-	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
-			" disables this message.\n");
+	pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
+		t->comm, t->pid, timeout);
+	pr_err("      %s %s %.*s\n",
+		print_tainted(), init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
+		" disables this message.\n");
 	sched_show_task(t);
 	debug_show_held_locks(t);
 
