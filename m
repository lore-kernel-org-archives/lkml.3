Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaKYBHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:07:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaKYBHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:07:42 -0500
Subject: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Oleg Nesterov <onestero@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 25 Nov 2014 09:07:35 +0800
Message-ID: <20141125010734.4974.85347.stgit@pluto.fritz.box>
In-Reply-To: <20141125005255.4974.54193.stgit@pluto.fritz.box>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call_usermodehelper() function executes all binaries in the
global "init" root context. This doesn't allow a binary to be run
within the callers namespace (aka. a container). So create a new
function call_usermodehelper_ns() to do this.

Both containerized NFS client and NFS server need the ability to
execute a binary within their container. To do this create a new
nsproxy within the callers' context so it can be used for setup
prior to calling do_execve() from the user mode helper thread
runner.

Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/kmod.h |   17 +++++++++++++++++
 kernel/kmod.c        |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 0555cc6..fd5509a 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -69,6 +69,23 @@ struct subprocess_info {
 extern int
 call_usermodehelper(char *path, char **argv, char **envp, int wait);
 
+#if !defined(CONFIG_PROC_FS) || !defined(CONFIG_NAMESPACES)
+inline struct nsproxy *umh_open_ns(void)
+{
+	return NULL;
+}
+
+inline int
+call_usermodehelper_ns(char *path, char **argv, char **envp, int wait)
+{
+	return -ENOTSUP;
+}
+#else
+extern struct nsproxy *umh_open_ns(void);
+extern int
+call_usermodehelper_ns(char *path, char **argv, char **envp, int wait);
+#endif
+
 extern struct subprocess_info *
 call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
 			  int (*init)(struct subprocess_info *info, struct cred *new),
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 80f7a6d..0ddcfbb 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -39,6 +39,7 @@
 #include <linux/rwsem.h>
 #include <linux/ptrace.h>
 #include <linux/async.h>
+#include <linux/mount.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -642,6 +643,44 @@ int call_usermodehelper(char *path, char **argv, char **envp, int wait)
 }
 EXPORT_SYMBOL(call_usermodehelper);
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_NAMESPACES)
+static int umh_set_ns(struct subprocess_info *info, struct cred *new)
+{
+	struct nsproxy *ns = info->data;
+
+	mntns_setfs(ns->mnt_ns);
+	switch_task_namespaces(current, ns);
+	return 0;
+}
+
+struct nsproxy *umh_open_ns(void)
+{
+	return create_new_namespaces(0, current, current_user_ns(), current->fs);
+}
+
+/* Call a usermode helper to execute within current namespace. */
+int call_usermodehelper_ns(char *path, char **argv, char **envp, int wait)
+{
+	struct subprocess_info *info;
+	struct nsproxy *ns;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+
+	ns = umh_open_ns();
+	if (IS_ERR(ns))
+		return PTR_ERR(ns);
+
+	info = call_usermodehelper_setup(path, argv, envp,
+					 gfp_mask, umh_set_ns, NULL, ns);
+	if (!info) {
+		free_nsproxy(ns);
+		return -ENOMEM;
+	}
+
+	return call_usermodehelper_exec(info, wait);
+}
+EXPORT_SYMBOL(call_usermodehelper_ns);
+#endif
+
 static int proc_cap_handler(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {

