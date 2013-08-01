Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab3HARFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:05:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038Ab3HARFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:05:13 -0400
Date: Thu, 1 Aug 2013 18:59:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ahecox@redhat.com, Christopher Williams <cww@redhat.com>,
        dwysocha@redhat.com, gavin@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>, nshi@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hung_task: print more info when reporting the problem
Message-ID: <20130801165941.GA17544@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk(KERN_ERR) from check_hung_task() likely means the bug,
but unlike BUG_ON/WARN_ON it doesn't show the kernel version,
this complicates the bug-reports investigation.

Add the additional pr_err() to print tainted/release/version
like dump_stack_print_info() does, the output becomes:

        INFO: task perl:504 blocked for more than 2 seconds.
	      Not tainted 3.11.0-rc1-10367-g136bb46-dirty #1763
        "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
        ...

While at it, turn the old printk's into pr_err().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/hung_task.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

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
 
-- 
1.5.5.1


