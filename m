Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaDVSN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:13:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaDVSNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:13:54 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, arozansk@redhat.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com, eparis@redhat.com,
        sgrubb@redhat.com
Subject: [PATCH 2/2] audit: log namespace serial numbers
Date: Tue, 22 Apr 2014 14:12:53 -0400
Message-Id: <644ef842bae19c55ae11af07e9fd7ac0ec9c74a1.1398176489.git.rgb@redhat.com>
In-Reply-To: <cover.1398176489.git.rgb@redhat.com>
References: <cover.1398176489.git.rgb@redhat.com>
In-Reply-To: <cover.1398176489.git.rgb@redhat.com>
References: <cover.1398176489.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log the namespace details of a task.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    7 +++++++
 kernel/audit.c        |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22cfddb..0ef404a 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -101,6 +101,13 @@ extern int __weak audit_classify_compat_syscall(int abi, unsigned syscall);
 struct filename;
 
 extern void audit_log_session_info(struct audit_buffer *ab);
+#ifdef CONFIG_NAMESPACES
+extern void audit_log_namespace_info(struct audit_buffer *ab, struct task_struct *tsk);
+#else
+void audit_log_namespace_info(struct audit_buffer *ab, struct task_struct *tsk)
+{
+}
+#endif
 
 #ifdef CONFIG_AUDIT_COMPAT_GENERIC
 #define audit_is_compat(arch)  (!((arch) & __AUDIT_ARCH_64BIT))
diff --git a/kernel/audit.c b/kernel/audit.c
index 59c0bbe..9049049 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -64,7 +64,15 @@
 #endif
 #include <linux/freezer.h>
 #include <linux/tty.h>
+#include <linux/nsproxy.h>
+#include <linux/utsname.h>
+#include <linux/ipc_namespace.h>
+#include "../fs/mount.h"
+#include <linux/mount.h>
+#include <linux/mnt_namespace.h>
 #include <linux/pid_namespace.h>
+#include <net/net_namespace.h>
+#include <linux/user_namespace.h>
 #include <net/netns/generic.h>
 
 #include "audit.h"
@@ -1617,6 +1625,35 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, " auid=%u ses=%u", auid, sessionid);
 }
 
+#ifdef CONFIG_NAMESPACES
+void audit_log_namespace_info(struct audit_buffer *ab, struct task_struct *tsk)
+{
+	struct nsproxy *nsproxy;
+
+	rcu_read_lock();
+	nsproxy = task_nsproxy(tsk);
+	if (nsproxy != NULL) {
+		audit_log_format(ab, " mntns=%x", nsproxy->mnt_ns->serial_num);
+#ifdef CONFIG_NET_NS
+		audit_log_format(ab, " netns=%x", nsproxy->net_ns->serial_num);
+#endif
+#ifdef CONFIG_UTS_NS
+		audit_log_format(ab, " utsns=%x", nsproxy->uts_ns->serial_num);
+#endif
+#ifdef CONFIG_IPC_NS
+		audit_log_format(ab, " ipcns=%x", nsproxy->ipc_ns->serial_num);
+#endif
+	}
+#ifdef CONFIG_PID_NS
+	audit_log_format(ab, " pidns=%x", task_active_pid_ns(tsk)->serial_num);
+#endif
+#ifdef CONFIG_USER_NS
+	audit_log_format(ab, " userns=%x", task_cred_xxx(tsk, user_ns)->serial_num);
+#endif
+	rcu_read_unlock();
+}
+#endif /* CONFIG_NAMESPACES */
+
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
 	audit_log_format(ab, " key=");
@@ -1861,6 +1898,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 		up_read(&mm->mmap_sem);
 	} else
 		audit_log_format(ab, " exe=(null)");
+	audit_log_namespace_info(ab, tsk);
 	audit_log_task_context(ab);
 }
 EXPORT_SYMBOL(audit_log_task_info);
-- 
1.7.1

