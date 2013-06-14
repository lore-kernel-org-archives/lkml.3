Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3FNTNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:13:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab3FNTNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:13:53 -0400
Date: Fri, 14 Jun 2013 21:09:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] fput: task_work_add() can fail if the caller has
	passed exit_task_work()
Message-ID: <20130614190947.GA8259@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614190915.GA8226@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fput() assumes that it can't be called after exit_task_work() but
this is not true, for example free_ipc_ns()->shm_destroy() can do
this. In this case fput() silently leaks the file.

Change it to fallback to delayed_fput_work if task_work_add() fails.
The patch looks complicated but it is not, it changes the code from

	if (PF_KTHREAD) {
		schedule_work(...);
		return;
	}
	task_work_add(...)

to
	if (!PF_KTHREAD) {
		if (!task_work_add(...))
			return;
		/* fallback */
	}
	schedule_work(...);

As for shm_destroy() in particular, we could make another fix but I
think this change makes sense anyway. There could be another similar
user, it is not safe to assume that task_work_add() can't fail.

Reported-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/file_table.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index cd4d87a..485dc0e 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -306,17 +306,18 @@ void fput(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
+		unsigned long flags;
+
 		file_sb_list_del(file);
-		if (unlikely(in_interrupt() || task->flags & PF_KTHREAD)) {
-			unsigned long flags;
-			spin_lock_irqsave(&delayed_fput_lock, flags);
-			list_add(&file->f_u.fu_list, &delayed_fput_list);
-			schedule_work(&delayed_fput_work);
-			spin_unlock_irqrestore(&delayed_fput_lock, flags);
-			return;
+		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
+			init_task_work(&file->f_u.fu_rcuhead, ____fput);
+			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
+				return;
 		}
-		init_task_work(&file->f_u.fu_rcuhead, ____fput);
-		task_work_add(task, &file->f_u.fu_rcuhead, true);
+		spin_lock_irqsave(&delayed_fput_lock, flags);
+		list_add(&file->f_u.fu_list, &delayed_fput_list);
+		schedule_work(&delayed_fput_work);
+		spin_unlock_irqrestore(&delayed_fput_lock, flags);
 	}
 }
 
-- 
1.5.5.1

