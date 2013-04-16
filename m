Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965278Ab3DPSbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025Ab3DPS0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 14/28] proc: Supply an accessor for getting the data from a
 PDE's parent [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-scsi@vger.kernel.org, Jerry Chuang <jerry-chuang@realtek.com>,
        linux-wireless@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date: Tue, 16 Apr 2013 19:26:46 +0100
Message-ID: <20130416182646.27773.40149.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply an accessor function for getting the private data from the parent
proc_dir_entry struct of the proc_dir_entry struct associated with an inode.

ReiserFS, for instance, stores the super_block pointer in the proc directory
it makes for that super_block, and a pointer to the respective seq_file show
function in each of the proc files in that directory.

This allows a reduction in the number of file_operations structs, open
functions and seq_operations structs required.  The problem otherwise is that
each show function requires two pieces of data but only has storage for one
per PDE (and this has no release function).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jerry Chuang <jerry-chuang@realtek.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Maxim Mikityanskiy <maxtram95@gmail.com>
cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
cc: linux-wireless@vger.kernel.org
cc: linux-scsi@vger.kernel.org
cc: devel@driverdev.osuosl.org
---

 drivers/scsi/megaraid.c                |    2 +-
 drivers/staging/rtl8187se/r8180_core.c |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c |    2 +-
 fs/proc/generic.c                      |    7 +++++++
 include/linux/proc_fs.h                |    1 +
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index ef3384d..7373255 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2760,7 +2760,7 @@ proc_show_rdrv_40(struct seq_file *m, void *v)
  */
 static int mega_proc_open(struct inode *inode, struct file *file)
 {
-	adapter_t *adapter = PDE(inode)->parent->data;
+	adapter_t *adapter = proc_get_parent_data(inode);
 	int (*show)(struct seq_file *, void *) = PDE_DATA(inode);
 
 	return single_open(file, show, adapter);
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index ab469ce..f7c1d99 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -296,7 +296,7 @@ void rtl8180_proc_remove_one(struct net_device *dev)
  */
 static int rtl8180_proc_open(struct inode *inode, struct file *file)
 {
-	struct net_device *dev = PDE(inode)->parent->data;
+	struct net_device *dev = proc_get_parent_data(inode);
 	int (*show)(struct seq_file *, void *) = PDE_DATA(inode);
 
 	return single_open(file, show, dev);
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 27ba2a3..1459233 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -637,7 +637,7 @@ void rtl8192_proc_module_remove(void)
  */
 static int rtl8192_proc_open(struct inode *inode, struct file *file)
 {
-	struct net_device *dev = PDE(inode)->parent->data;
+	struct net_device *dev = proc_get_parent_data(inode);
 	int (*show)(struct seq_file *, void *) = PDE_DATA(inode);
 
 	return single_open(file, show, dev);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4074da5..75e08d3 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -617,3 +617,10 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
 	return 0;
 }
 EXPORT_SYMBOL(remove_proc_subtree);
+
+void *proc_get_parent_data(const struct inode *inode)
+{
+	struct proc_dir_entry *de = PDE(inode);
+	return de->parent->data;
+}
+EXPORT_SYMBOL_GPL(proc_get_parent_data);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index e5d8f69..12694ef 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -86,6 +86,7 @@ static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
  
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
+extern void *proc_get_parent_data(const struct inode *);
 #else
 
 static inline void proc_flush_task(struct task_struct *task)

