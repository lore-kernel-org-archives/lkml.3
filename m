Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbbANJc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:32:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbbANJcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:32:55 -0500
Subject: [RFC PATCH 3/5] kmod - teach call_usermodehelper() to use a
 namespace
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 14 Jan 2015 17:32:43 +0800
Message-ID: <20150114093242.30252.46536.stgit@pluto.fritz.box>
In-Reply-To: <20150114092704.30252.60446.stgit@pluto.fritz.box>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call_usermodehelper() function executes all binaries in the
global "init" root context. This doesn't allow a binary to be run
within a namespace (eg. the namespace of a container).

Both containerized NFS client and NFS server need the ability to
execute a binary in a container's context. To do this use the init
process of the callers environment is used to setup the namespaces
in the same way the root init process is used otherwise.

Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>
---
 include/linux/kmod.h |   17 +++++++
 kernel/kmod.c        |  119 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 133 insertions(+), 3 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 15bdeed..487e68e 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -52,6 +52,7 @@ struct file;
 #define UMH_WAIT_EXEC	1	/* wait for the exec, but not the process */
 #define UMH_WAIT_PROC	2	/* wait for the process to complete */
 #define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
+#define UMH_USE_NS	8	/* exec using caller's init namespace */
 
 struct subprocess_info {
 	struct work_struct work;
@@ -69,6 +70,22 @@ struct subprocess_info {
 extern int
 call_usermodehelper(char *path, char **argv, char **envp, int flags);
 
+#if !defined(CONFIG_PROC_FS) || !defined(CONFIG_NAMESPACES)
+inline int umh_get_init_pid(pid_t *pid)
+{
+	*pid = 0;
+	return 0;
+}
+
+inline int umh_enter_ns(pid_t pid, struct cred *new)
+{
+	return -ENOTSUP;
+}
+#else
+int umh_get_init_pid(pid_t *pid);
+int umh_enter_ns(pid_t pid, struct cred *new);
+#endif
+
 extern struct subprocess_info *
 call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
 			  int (*init)(struct subprocess_info *info, struct cred *new),
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 14c0188..2179e58 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -582,6 +582,97 @@ unlock:
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_NAMESPACES)
+#define NS_PATH_MAX	35
+#define NS_PATH_FMT	"%lu/ns/%s"
+
+/* Note namespace name order is significant */
+static const char *ns_names[] = { "user", "ipc", "uts", "net", "pid", "mnt", NULL };
+
+int umh_get_init_pid(pid_t *pid)
+{
+	struct task_struct *tsk;
+	pid_t init_pid;
+
+	rcu_read_lock();
+	tsk = find_task_by_vpid(1);
+	if (tsk)
+		get_task_struct(tsk);
+	rcu_read_unlock();
+	if (!tsk)
+		return -ESRCH;
+	init_pid = task_pid_nr(tsk);
+	put_task_struct(tsk);
+
+	*pid = init_pid;
+
+	return 0;
+}
+EXPORT_SYMBOL(umh_get_init_pid);
+
+int umh_enter_ns(pid_t pid, struct cred *new)
+{
+	char path[NS_PATH_MAX];
+	struct vfsmount *mnt;
+	const char *name;
+	int err = 0;
+
+	/*
+	 * The user mode thread runner runs in the root init namespace
+	 * so it will see all system pids.
+	 */
+	mnt = task_active_pid_ns(current)->proc_mnt;
+
+	for (name = ns_names[0]; *name; name++) {
+		struct file *this;
+		int len;
+
+		len = snprintf(path,
+			       NS_PATH_MAX, NS_PATH_FMT,
+			       (unsigned long) pid, name);
+		if (len >= NS_PATH_MAX) {
+			err = -ENAMETOOLONG;
+			break;
+		}
+
+		this = file_open_root(mnt->mnt_root, mnt, path, O_RDONLY);
+		if (unlikely(IS_ERR(this))) {
+			err = PTR_ERR(this);
+			break;
+		}
+
+		err = setns_inode(file_inode(this), 0);
+		fput(this);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(umh_enter_ns);
+
+static int umh_set_ns(struct subprocess_info *info, struct cred *new)
+{
+	pid_t *init_pid = (pid_t *) info->data;
+
+	return umh_enter_ns(*init_pid, new);
+}
+
+static void umh_free_ns(struct subprocess_info *info)
+{
+	kfree(info->data);
+}
+#else
+static int umh_set_ns(struct subprocess_info *info, struct cred *new)
+{
+	return 0;
+}
+
+static void umh_free_ns(struct subprocess_info *info)
+{
+}
+#endif
+
 /**
  * call_usermodehelper() - prepare and start a usermode application
  * @path: path to usermode executable
@@ -599,11 +690,33 @@ int call_usermodehelper(char *path, char **argv, char **envp, int flags)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (flags == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+	unsigned int use_ns = flags & UMH_USE_NS;
+	pid_t init_pid = 0;
+	pid_t *pid = NULL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
-					 NULL, NULL, NULL);
-	if (info == NULL)
+	if (use_ns) {
+		int ret = umh_get_init_pid(&init_pid);
+		if (ret)
+			return ret;
+	}
+
+	if (!init_pid)
+		info = call_usermodehelper_setup(path, argv, envp,
+						 gfp_mask, NULL, NULL, NULL);
+	else {
+		pid = kmalloc(sizeof(pid_t), gfp_mask);
+		if (!pid)
+			return -ENOMEM;
+		*pid = init_pid;
+		info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
+						 umh_set_ns, umh_free_ns,
+						 pid);
+	}
+	if (info == NULL) {
+		if (pid)
+			kfree(pid);
 		return -ENOMEM;
+	}
 
 	return call_usermodehelper_exec(info, flags);
 }

