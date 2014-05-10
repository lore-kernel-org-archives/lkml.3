Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbaEJA2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561AbaEJA2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:28:16 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, arozansk@redhat.com, serge@hallyn.com,
        ebiederm@xmission.com, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH V2 6/6] audit: convert namespace serial number logging to use proc ns_entries
Date: Fri,  9 May 2014 20:27:27 -0400
Message-Id: <d7f26c13de9ad02b10a9e334c6b13848c2dc8435.1399681022.git.rgb@redhat.com>
In-Reply-To: <cover.1399681022.git.rgb@redhat.com>
References: <cover.1399681022.git.rgb@redhat.com>
In-Reply-To: <cover.1399681022.git.rgb@redhat.com>
References: <cover.1399681022.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert audit direct access to namespace serial numbers to insead use the proc
namespace operations structure which lists all namespace types with a
consistent api.

This should eventually squash down to: [audit: log namespace serial numbers]
(which in turn will need to follow [namespaces: expose ns_entries])

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   43 ++++++++++++-------------------------------
 1 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index fe783ad..6452278 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -64,15 +64,7 @@
 #endif
 #include <linux/freezer.h>
 #include <linux/tty.h>
-#include <linux/nsproxy.h>
-#include <linux/utsname.h>
-#include <linux/ipc_namespace.h>
-#include "../fs/mount.h"
-#include <linux/mount.h>
-#include <linux/mnt_namespace.h>
-#include <linux/pid_namespace.h>
-#include <net/net_namespace.h>
-#include <linux/user_namespace.h>
+#include <linux/proc_ns.h>
 #include <net/netns/generic.h>
 
 #include "audit.h"
@@ -1628,29 +1620,18 @@ void audit_log_session_info(struct audit_buffer *ab)
 #ifdef CONFIG_NAMESPACES
 void audit_log_namespace_info(struct audit_buffer *ab, struct task_struct *tsk)
 {
-	struct nsproxy *nsproxy;
-
-	rcu_read_lock();
-	nsproxy = task_nsproxy(tsk);
-	if (nsproxy != NULL) {
-		audit_log_format(ab, " mntns=%llx", nsproxy->mnt_ns->serial_num);
-#ifdef CONFIG_NET_NS
-		audit_log_format(ab, " netns=%llx", nsproxy->net_ns->serial_num);
-#endif
-#ifdef CONFIG_UTS_NS
-		audit_log_format(ab, " utsns=%llx", nsproxy->uts_ns->serial_num);
-#endif
-#ifdef CONFIG_IPC_NS
-		audit_log_format(ab, " ipcns=%llx", nsproxy->ipc_ns->serial_num);
-#endif
+	const struct proc_ns_operations **entry;
+	bool end = false;
+
+	if (!tsk)
+		return;
+	for (entry = ns_entries; !end; entry++) {
+		void *ns = (*entry)->get(tsk);
+		audit_log_format(ab, " %sns=%llx", (*entry)->name,
+				 (*entry)->snum(ns));
+		(*entry)->put(ns);
+		end = (*entry)->type == CLONE_NEWNS;
 	}
-#ifdef CONFIG_PID_NS
-	audit_log_format(ab, " pidns=%llx", task_active_pid_ns(tsk)->serial_num);
-#endif
-#ifdef CONFIG_USER_NS
-	audit_log_format(ab, " userns=%llx", task_cred_xxx(tsk, user_ns)->serial_num);
-#endif
-	rcu_read_unlock();
 }
 #endif /* CONFIG_NAMESPACES */
 
-- 
1.7.1

