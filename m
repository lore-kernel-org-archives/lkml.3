Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3INCsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:48:13 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:28860 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab3INCsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:48:11 -0400
Message-ID: <5233CE5E.7040004@huawei.com>
Date: Sat, 14 Sep 2013 10:47:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hung_task: change sysctl_hung_task_check_count to int
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As sysctl_hung_task_check_count is unsigned long, when this value is
assigned to max_count in check_hung_uninterruptible_tasks(), it's
truncated to int type.

Therefore if we write 2^32 to sysctl.hung_task_check_count, hung task
detection will be effectively disabled.

Not a big deal, but still it's better to fix this inconsistency.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched/sysctl.h | 2 +-
 kernel/hung_task.c           | 2 +-
 kernel/sysctl.c              | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

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
index 6df6149..b5a5d42 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -19,7 +19,7 @@
 /*
  * The number of tasks checked:
  */
-unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
+int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
 
 /*
  * Limit number of tasks checked in a batch.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 07f6fc4..5e5cc21 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -962,9 +962,9 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "hung_task_check_count",
 		.data		= &sysctl_hung_task_check_count,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 	},
 	{
 		.procname	= "hung_task_timeout_secs",
-- 
1.8.0.2
