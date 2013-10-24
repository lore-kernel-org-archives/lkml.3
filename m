Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3JXHbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:31:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab3JXHbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:02 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847739"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 02/20] audit: introduce configure option CONFIG_AUDIT_NS
Date: Thu, 24 Oct 2013 15:31:47 +0800
Message-Id: <1382599925-25143-3-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:28,
	Serialize complete at 2013/10/24 15:28:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new field audit_ns for struct
nsproxy, so task can access the audit_ns through
task->nsproxy->audit_ns.

Right now, we don't support create new audit_ns,
all tasks's audit_ns will point to the init_audit_ns.
next patches will add the feature creating new
audit namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h | 51 +++++++++++++++++++++++++++++++++++++++++
 include/linux/nsproxy.h         | 11 +++++----
 init/Kconfig                    | 10 ++++++++
 kernel/Makefile                 |  2 +-
 kernel/audit_namespace.c        |  8 +++++++
 kernel/nsproxy.c                | 16 ++++++++++++-
 6 files changed, 91 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/audit_namespace.h
 create mode 100644 kernel/audit_namespace.c

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
new file mode 100644
index 0000000..ac22649
--- /dev/null
+++ b/include/linux/audit_namespace.h
@@ -0,0 +1,51 @@
+#ifndef __LINUX_AUDIT_NAMESPACE_H
+#define __LINUX_AUDIT_NAMESPACE_H
+
+#include <linux/audit.h>
+#include <linux/atomic.h>
+#include <linux/slab.h>
+#include <linux/user_namespace.h>
+
+struct audit_namespace {
+	atomic_t count;
+	struct user_namespace *user_ns;
+};
+
+extern struct audit_namespace init_audit_ns;
+
+#if defined(CONFIG_AUDIT_NS)
+static inline
+struct audit_namespace *get_audit_ns(struct audit_namespace *ns)
+{
+	atomic_inc(&ns->count);
+	return ns;
+}
+
+static inline
+void put_audit_ns(struct audit_namespace *ns)
+{
+	if (atomic_dec_and_test(&ns->count)) {
+		put_user_ns(ns->user_ns);
+		kfree(ns);
+	}
+}
+#else
+static inline
+struct audit_namespace *get_audit_ns(struct audit_namespace *ns)
+{
+	return ns;
+}
+
+static inline
+void put_audit_ns(struct audit_namespace *ns)
+{
+
+}
+#endif
+
+static inline struct
+audit_namespace *copy_audit_ns(struct audit_namespace *audit)
+{
+	return get_audit_ns(audit);
+}
+#endif
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index b4ec59d..dc7af11 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -28,11 +28,12 @@ struct fs_struct;
  */
 struct nsproxy {
 	atomic_t count;
-	struct uts_namespace *uts_ns;
-	struct ipc_namespace *ipc_ns;
-	struct mnt_namespace *mnt_ns;
-	struct pid_namespace *pid_ns_for_children;
-	struct net 	     *net_ns;
+	struct uts_namespace	*uts_ns;
+	struct ipc_namespace	*ipc_ns;
+	struct mnt_namespace	*mnt_ns;
+	struct pid_namespace	*pid_ns_for_children;
+	struct net		*net_ns;
+	struct audit_namespace	*audit_ns;
 };
 extern struct nsproxy init_nsproxy;
 
diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..05e3d2c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1154,6 +1154,16 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+config AUDIT_NS
+	bool "Audit namespace"
+	depends on AUDIT
+	default n
+	help
+	  Support audit namespace.  This allows processes write audit message
+	  to the audit namespace they belong to.
+
+	  If unsure, say N.
+
 endif # NAMESPACES
 
 config UIDGID_STRICT_TYPE_CHECKS
diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce4755..6e64333 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -71,7 +71,7 @@ obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
-obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
+obj-$(CONFIG_AUDIT) += audit.o auditfilter.o audit_namespace.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
diff --git a/kernel/audit_namespace.c b/kernel/audit_namespace.c
new file mode 100644
index 0000000..6d9cb8f
--- /dev/null
+++ b/kernel/audit_namespace.c
@@ -0,0 +1,8 @@
+#include <linux/audit_namespace.h>
+#include <linux/export.h>
+
+struct audit_namespace init_audit_ns = {
+	.count = ATOMIC_INIT(1),
+	.user_ns = &init_user_ns,
+};
+EXPORT_SYMBOL_GPL(init_audit_ns);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e78110..e8374aa 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/ipc_namespace.h>
+#include <linux/audit_namespace.h>
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
@@ -39,6 +40,9 @@ struct nsproxy init_nsproxy = {
 #ifdef CONFIG_NET
 	.net_ns			= &init_net,
 #endif
+#ifdef CONFIG_AUDIT
+	.audit_ns		= &init_audit_ns,
+#endif
 };
 
 static inline struct nsproxy *create_nsproxy(void)
@@ -98,8 +102,16 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_net;
 	}
 
-	return new_nsp;
+	new_nsp->audit_ns = copy_audit_ns(tsk->nsproxy->audit_ns);
+	if (IS_ERR(new_nsp->audit_ns)) {
+		err = PTR_ERR(new_nsp->audit_ns);
+		goto out_audit;
+	}
 
+	return new_nsp;
+out_audit:
+	if (new_nsp->net_ns)
+		put_net(new_nsp->net_ns);
 out_net:
 	if (new_nsp->pid_ns_for_children)
 		put_pid_ns(new_nsp->pid_ns_for_children);
@@ -165,6 +177,8 @@ void free_nsproxy(struct nsproxy *ns)
 		put_ipc_ns(ns->ipc_ns);
 	if (ns->pid_ns_for_children)
 		put_pid_ns(ns->pid_ns_for_children);
+	if (ns->audit_ns)
+		put_audit_ns(ns->audit_ns);
 	put_net(ns->net_ns);
 	kmem_cache_free(nsproxy_cachep, ns);
 }
-- 
1.8.3.1

