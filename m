Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbaDIQMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:12:12 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:44136 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:11:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4/5] procfs: Convert process iteration to use for_each_thread()
Date: Wed,  9 Apr 2014 18:11:21 +0200
Message-Id: <1397059882-23063-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_each_thread/while_each_thread iterators are deprecated by
for_each_thread/for_each_process_thread() APIs.

Lets convert the callers in procfs. The ultimate goal is to remove the
struct task_struct::thread_group field and the corresponding
do_each_thread/while_each_thread iterators that are RCU unsafe.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/proc/array.c | 7 ++++---
 fs/proc/base.c  | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 656e401..b7df5d5 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -439,12 +439,13 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 		/* add up live thread stats at the group level */
 		if (whole) {
-			struct task_struct *t = task;
-			do {
+			struct task_struct *t;
+
+			for_each_thread(task, t) {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
-			} while_each_thread(task, t);
+			}
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b976062..f595d8e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2437,10 +2437,10 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 	}
 
 	if (whole && lock_task_sighand(task, &flags)) {
-		struct task_struct *t = task;
+		struct task_struct *t;
 
 		task_io_accounting_add(&acct, &task->signal->ioac);
-		while_each_thread(task, t)
+		for_each_thread(task, t)
 			task_io_accounting_add(&acct, &t->ioac);
 
 		unlock_task_sighand(task, &flags);
-- 
1.8.3.1

