Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315Ab3DPS1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:27:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab3DPS1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 25/28] proc: Supply an accessor to get the process ID
 associated with some proc files [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Date: Tue, 16 Apr 2013 19:27:30 +0100
Message-ID: <20130416182730.27773.88726.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply an accessor to get the process ID associated with some proc files and
directories (get_proc_pid()).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tejun Heo <tj@kernel.org>
cc: Li Zefan <lizefan@huawei.com>
cc: containers@lists.linux-foundation.org
cc: cgroups@vger.kernel.org
---

 fs/proc/base.c          |    5 +++++
 include/linux/proc_fs.h |    2 ++
 kernel/cgroup.c         |    3 +--
 kernel/cpuset.c         |    3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f2637c9..9ea16c8 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -157,6 +157,11 @@ static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
 	return count;
 }
 
+struct pid *get_proc_pid(const struct inode *inode)
+{
+	return PROC_I(inode)->pid;
+}
+
 static int get_task_root(struct task_struct *task, struct path *root)
 {
 	int result = -ENOENT;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 718e966..7abc72a 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -88,6 +88,7 @@ extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
 extern void *proc_get_parent_data(const struct inode *);
 extern const char *get_proc_name(const struct proc_dir_entry *);
+extern struct pid *get_proc_pid(const struct inode *);
 #else
 
 static inline void proc_flush_task(struct task_struct *task)
@@ -113,6 +114,7 @@ static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
+static inline struct pid *get_proc_pid(const struct inode *inode) { return NULL; }
 
 #endif /* CONFIG_PROC_FS */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..021548a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4823,8 +4823,7 @@ out:
 
 static int cgroup_open(struct inode *inode, struct file *file)
 {
-	struct pid *pid = PROC_I(inode)->pid;
-	return single_open(file, proc_cgroup_show, pid);
+	return single_open(file, proc_cgroup_show, get_proc_pid(inode));
 }
 
 const struct file_operations proc_cgroup_operations = {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4f9dfe4..0ec6edd 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2703,8 +2703,7 @@ out:
 
 static int cpuset_open(struct inode *inode, struct file *file)
 {
-	struct pid *pid = PROC_I(inode)->pid;
-	return single_open(file, proc_cpuset_show, pid);
+	return single_open(file, proc_cpuset_show, get_proc_pid(inode));
 }
 
 const struct file_operations proc_cpuset_operations = {

