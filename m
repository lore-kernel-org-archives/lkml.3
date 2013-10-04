Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3JDKcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:32:12 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:41898 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3JDKcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:32:02 -0400
Subject: [PATCH 10/19] Track the core generation requests
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
Date: Fri, 04 Oct 2013 16:01:52 +0530
Message-ID: <20131004103152.1612.64284.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-2674-0000-0000-00000AE8EE43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K.Poulose <suzuki@in.ibm.com>

Keep track of the core generation requests. Concurrent core generation requests
for the same target process are not allowed.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/gencore.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/proc/gencore.h |   12 +++++++
 2 files changed, 96 insertions(+), 2 deletions(-)
 create mode 100644 fs/proc/gencore.h

diff --git a/fs/proc/gencore.c b/fs/proc/gencore.c
index 115f1e4..580a8b5 100644
--- a/fs/proc/gencore.c
+++ b/fs/proc/gencore.c
@@ -23,23 +23,105 @@
  */
 
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include "internal.h"
+#include "gencore.h"
+
+static LIST_HEAD(core_list);
+static DEFINE_MUTEX(core_mutex);
+
+/* Called with core_mutex held */
+static struct core_proc* get_core_proc(struct task_struct *t)
+{
+	struct core_proc *cp;
+
+	list_for_each_entry(cp, &core_list, list) {
+		if (cp->task == t->group_leader)
+			return cp;
+	}
+	return NULL;
+}
 
 static ssize_t read_gencore(struct file *file, char __user *buffer,
 				size_t buflen, loff_t *fpos)
 {
-	return 0;
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct core_proc *cp;
+	ssize_t ret = 0;
+
+	if (!task)
+		return -EIO;
+
+	mutex_lock(&core_mutex);
+	cp = get_core_proc(task);
+	if (!cp) {
+		mutex_unlock(&core_mutex);
+		ret = -EIO;
+		goto out;
+	}
+	mutex_unlock(&core_mutex);
+
+out:
+	put_task_struct(task);
+	return ret;
 }
 
 static int release_gencore(struct inode *inode, struct file *file)
 {
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct core_proc *cp;
+
+	if (!task)
+		return -EIO;
+
+	mutex_lock(&core_mutex);
+	cp = get_core_proc(task);
+	if (cp) {
+		list_del(&cp->list);
+		kfree(cp);
+	}
+	mutex_unlock(&core_mutex);
+	put_task_struct(task);
 	return 0;
 }
 
+/*
+ * Validate if the call is valid. We also need to prevent >1 open
+ * of the same file.
+ */
 static int open_gencore(struct inode *inode, struct file *filp)
 {
-	return 0;
+	struct task_struct *task = get_proc_task(inode);
+	struct core_proc *cp;
+	int ret = 0;
+	if (!task)
+		return -ENOENT;
+
+	mutex_lock(&core_mutex);
+	cp = get_core_proc(task);
+	mutex_unlock(&core_mutex);	
+	if (cp) {
+		ret = -EALREADY;
+		goto out;
+	}
+
+	cp = kzalloc(sizeof (*cp), GFP_KERNEL);
+	if (!cp) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cp->task = task->group_leader;
+	INIT_LIST_HEAD(&cp->list);
+	mutex_lock(&core_mutex);
+	list_add(&cp->list, &core_list);
+	mutex_unlock(&core_mutex);
+
+out:
+	put_task_struct(task);
+	return ret;
 }
+
 const struct file_operations proc_gen_core_operations = {
 	.open           = open_gencore,
 	.read           = read_gencore,
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
new file mode 100644
index 0000000..c98fddf
--- /dev/null
+++ b/fs/proc/gencore.h
@@ -0,0 +1,12 @@
+#ifndef __GEN_CORE_H
+#define __GEN_CORE_H
+
+#include <linux/list.h>
+#include <linux/sched.h>
+
+struct core_proc {
+	struct list_head list;
+	struct task_struct *task;
+};
+
+#endif

