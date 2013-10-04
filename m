Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3JDKea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:34:30 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37841 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3JDKcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:32:11 -0400
Subject: [PATCH 12/19] Hold the threads using task_work_add
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:02:03 +0530
Message-ID: <20131004103203.1612.49165.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-5816-0000-0000-00000A3577D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Janani Venkataraman <janani@in.ibm.com>

Hold the threads in a killable state, for collection of register set.
This was implemented in the past using the freezer system. The freezer functions in
kernel essentially help start and stop sets of tasks and this approach
exploited the existing freezer subsystem kernel interface effectively to
quiesce all the threads of the application before triggering the core dump.
This approach was not accepted due to the potential Dos attack. Also the
community discussed that "freeze" is a bit dangerous because an application
which is frozen cannot be ended and while it's frozen and there is no
information "its frozen" via usual user commands as 'ps' or 'top'.

In this method we assign work to the threads of the task, which will make
them wait in a killable state until the operation is complete, using
'completion'. Once the dump is complete we release the threads.

The following are yet to be implemented:

1) A check to ensure all the threads have entered the work that was queued
2) Handling of threads blocked in kernel.These will not reach the work
   queued and hence the dump may be delayed. If the process is in a non
   running state we can probably take the dump as it would not lead to
   inconsistency. We would like to community views on the same.

Signed-off-by: Janani Venkataraman <jananive@in.ibm.com >
Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/proc/gencore.c |   42 +++++++++++++++++++++++++++++++++++++++---
 fs/proc/gencore.h |    4 ++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/fs/proc/gencore.c b/fs/proc/gencore.c
index 5f56910..d741f18 100644
--- a/fs/proc/gencore.c
+++ b/fs/proc/gencore.c
@@ -20,8 +20,10 @@
  * Authors:
  *      Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
  *      Suzuki K. Poulose <suzuki@in.ibm.com>
+ *      Janani Venkataraman <jananive@in.ibm.com>
  */
 
+#include <linux/task_work.h>
 #include <linux/elf.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -67,22 +69,45 @@ out:
 	return ret;
 }
 
+static void gencore_work(struct callback_head *open_work)
+{
+	/* TODO A method to know when all the threads have reached here */ 
+	struct core_proc *cp = container_of(open_work, struct core_proc, twork);
+	/* If a thread is exiting we could let it go */
+	if (current->flags & PF_EXITING)
+		return;
+	wait_for_completion_killable(&cp->hold);
+}
+ 
 static int release_gencore(struct inode *inode, struct file *file)
 {
 	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
 	struct core_proc *cp;
+	struct task_struct *t;
 
 	if (!task)
 		return -EIO;
 
 	mutex_lock(&core_mutex);
 	cp = get_core_proc(task);
-	if (cp) {
+	if (cp) 
 		list_del(&cp->list);
-		kfree(cp);
-	}
+	else
+		return -ENOENT;
+	
+	complete_all(&cp->hold);
 	mutex_unlock(&core_mutex);
+	/* Cancelling the work added */
+	t = task;
+	read_lock(&tasklist_lock);
+	do {
+		if (t != current)
+			task_work_cancel(t, gencore_work);
+	} while_each_thread(cp->task, t);
+
+	read_unlock(&tasklist_lock);   
 	put_task_struct(task);
+	kfree(cp);
 	return 0;
 }
 
@@ -117,6 +142,7 @@ static int open_gencore(struct inode *inode, struct file *filp)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct core_proc *cp;
+	struct task_struct *t;
 	int elf_class;
 	int ret = 0;
 	if (!task)
@@ -145,6 +171,16 @@ static int open_gencore(struct inode *inode, struct file *filp)
 	mutex_lock(&core_mutex);
 	list_add(&cp->list, &core_list);
 	mutex_unlock(&core_mutex);
+	init_completion(&cp->hold);
+	/* Adding the work for all the threads except current */
+	t = cp->task;
+	init_task_work(&cp->twork, gencore_work);
+	read_lock(&tasklist_lock);
+	do {
+		if (t != current)
+			task_work_add(t, &cp->twork, true);
+	} while_each_thread(cp->task, t);
+	read_unlock(&tasklist_lock); 
 
 out:
 	put_task_struct(task);
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
index c98fddf..1a88e24 100644
--- a/fs/proc/gencore.h
+++ b/fs/proc/gencore.h
@@ -1,12 +1,16 @@
 #ifndef __GEN_CORE_H
 #define __GEN_CORE_H
 
+#include <linux/types.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/completion.h>
 
 struct core_proc {
 	struct list_head list;
 	struct task_struct *task;
+	struct completion hold;
+	struct callback_head twork;
 };
 
 #endif

