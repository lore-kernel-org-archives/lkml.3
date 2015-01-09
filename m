Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbbAIKkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:16 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44566 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757483AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 59/78] userns: Don't allow setgroups until a gid mapping has been setablished
Date: Fri,  9 Jan 2015 11:32:08 +0100
Message-Id: <ae254fcf53097d6d83502c1a75366c7e4eface8b.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 273d2c67c3e179adb1e74f403d1e9a06e3f841b5 upstream.

setgroups is unique in not needing a valid mapping before it can be called,
in the case of setgroups(0, NULL) which drops all supplemental groups.

The design of the user namespace assumes that CAP_SETGID can not actually
be used until a gid mapping is established.  Therefore add a helper function
to see if the user namespace gid mapping has been established and call
that function in the setgroups permission check.

This is part of the fix for CVE-2014-8989, being able to drop groups
without privilege using user namespaces.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/user_namespace.h |  5 +++++
 kernel/groups.c                |  4 +++-
 kernel/user_namespace.c        | 14 ++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 4db29859464f..736bee2b5664 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -57,6 +57,7 @@ extern struct seq_operations proc_projid_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
+extern bool userns_may_setgroups(const struct user_namespace *ns);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -81,6 +82,10 @@ static inline void put_user_ns(struct user_namespace *ns)
 {
 }
 
+static inline bool userns_may_setgroups(const struct user_namespace *ns)
+{
+	return true;
+}
 #endif
 
 #endif /* _LINUX_USER_H */
diff --git a/kernel/groups.c b/kernel/groups.c
index 984bb629c68c..67b4ba30475f 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
@@ -227,7 +228,8 @@ bool may_setgroups(void)
 {
 	struct user_namespace *user_ns = current_user_ns();
 
-	return ns_capable(user_ns, CAP_SETGID);
+	return ns_capable(user_ns, CAP_SETGID) &&
+		userns_may_setgroups(user_ns);
 }
 
 /*
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index c9aa0e2c07ba..048bb7b641a9 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -830,6 +830,20 @@ static bool new_idmap_permitted(const struct file *file,
 	return false;
 }
 
+bool userns_may_setgroups(const struct user_namespace *ns)
+{
+	bool allowed;
+
+	mutex_lock(&id_map_mutex);
+	/* It is not safe to use setgroups until a gid mapping in
+	 * the user namespace has been established.
+	 */
+	allowed = ns->gid_map.nr_extents != 0;
+	mutex_unlock(&id_map_mutex);
+
+	return allowed;
+}
+
 static void *userns_get(struct task_struct *task)
 {
 	struct user_namespace *user_ns;
-- 
2.2.1

