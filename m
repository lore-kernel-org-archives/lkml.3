Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3IWNiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:38:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3IWNiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:38:11 -0400
Date: Mon, 23 Sep 2013 06:37:51 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-cd64647f043e3fd3569bcf068f47f030198ff93a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <523FFF4E.9050401@huawei.com>
References: <523FFF4E.9050401@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hung_task:
  Change sysctl_hung_task_check_count to 'int'
Git-Commit-ID: cd64647f043e3fd3569bcf068f47f030198ff93a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 23 Sep 2013 06:37:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd64647f043e3fd3569bcf068f47f030198ff93a
Gitweb:     http://git.kernel.org/tip/cd64647f043e3fd3569bcf068f47f030198ff93a
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Mon, 23 Sep 2013 16:43:58 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 23 Sep 2013 11:10:49 +0200

hung_task: Change sysctl_hung_task_check_count to 'int'

As 'sysctl_hung_task_check_count' is 'unsigned long' when this
value is assigned to max_count in check_hung_uninterruptible_tasks(),
it's truncated to 'int' type.

This causes a minor artifact: if we write 2^32 to sysctl.hung_task_check_count,
hung task detection will be effectively disabled.

With this fix, it will still truncate the user input to 32 bits, but
reading sysctl.hung_task_check_count reflects the actual truncated value.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/523FFF4E.9050401@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/sysctl.h | 2 +-
 kernel/hung_task.c           | 2 +-
 kernel/sysctl.c              | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bf8086b..9552afa 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -2,8 +2,8 @@
 #define _SCHED_SYSCTL_H
 
 #ifdef CONFIG_DETECT_HUNG_TASK
+extern int	     sysctl_hung_task_check_count;
 extern unsigned int  sysctl_hung_task_panic;
-extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
 extern unsigned long sysctl_hung_task_warnings;
 extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 3e97fb1..0422523 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -20,7 +20,7 @@
 /*
  * The number of tasks checked:
  */
-unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
+int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
 
 /*
  * Limit number of tasks checked in a batch.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2f06f3..b24ed7f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -962,9 +962,10 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "hung_task_check_count",
 		.data		= &sysctl_hung_task_check_count,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
 	},
 	{
 		.procname	= "hung_task_timeout_secs",
