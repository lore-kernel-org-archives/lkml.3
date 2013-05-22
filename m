Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3EVHah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:30:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7871 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3EVHad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:30:33 -0400
Subject: [RFC PATCH] fs: call_usermodehelper_root helper introduced
To: viro@zeniv.linux.org.uk
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com, bfields@fieldses.org,
        ebiederm@xmission.com, bharrosh@panasas.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
Date: Wed, 22 May 2013 11:29:18 +0400
Message-ID: <20130522072840.27720.85023.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usermode helper executes all binaries in global "init" root context. This
doesn't allow to call a binary from other root context (for example in a
container).
Currently, both containerized NFS client and NFS server requires an ability to
execute a binary in a container's root context. Root swap can be done in
"init" callback, passed by UMH caller.
But since we have 2 callers already (and more of them are expected to appear
in future) and because set_fs_root() in not exported, it looks reasonable to
add one more generic UMH helper to generic fs code.
Root path reference must be hold by the caller, since it will be put on UMH
thread exit.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 fs/fs_struct.c            |   28 ++++++++++++++++++++++++++++
 include/linux/fs_struct.h |    4 ++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index d8ac61d..cd1de8e 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -4,6 +4,7 @@
 #include <linux/path.h>
 #include <linux/slab.h>
 #include <linux/fs_struct.h>
+#include <linux/kmod.h>
 #include "internal.h"
 
 /*
@@ -157,6 +158,33 @@ int current_umask(void)
 }
 EXPORT_SYMBOL(current_umask);
 
+static int umh_set_fs_root(struct subprocess_info *info, struct cred *new)
+{
+	set_fs_root(current->fs, info->data);
+	return 0;
+}
+
+/*
+ * Call a usermode helper with a specific fs root.
+ *
+ * The caller must hold extra reference to it otherwise, because it will be
+ * put on usermodehelper thread exit.
+ */
+int call_usermodehelper_root(char *path, char **argv, char **envp,
+			     struct path *root, int wait)
+{
+	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
+					      umh_set_fs_root, NULL, root);
+	if (info == NULL)
+		return -ENOMEM;
+
+	return call_usermodehelper_exec(info, wait);
+}
+EXPORT_SYMBOL(call_usermodehelper_root);
+
 /* to be mentioned only in INIT_TASK */
 struct fs_struct init_fs = {
 	.users		= 1,
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 2b93a9a..cead51e 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -52,4 +52,8 @@ static inline void get_fs_root_and_pwd(struct fs_struct *fs, struct path *root,
 
 extern bool current_chrooted(void);
 
+extern int
+call_usermodehelper_root(char *path, char **argv, char **envp,
+			 struct path *root, int wait);
+
 #endif /* _LINUX_FS_STRUCT_H */

