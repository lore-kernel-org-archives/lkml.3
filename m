Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3LLQyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:54:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24743 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3LLQyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:39 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 2/9] exploit: report to audit subsystem when available
Date: Thu, 12 Dec 2013 17:52:25 +0100
Message-Id: <1386867152-24072-2-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/uapi/linux/audit.h |    1 +
 security/exploit.c         |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 75cef3f..65811d4 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -131,6 +131,7 @@
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
 #define AUDIT_ANOM_ABEND            1701 /* Process ended abnormally */
 #define AUDIT_ANOM_LINK		    1702 /* Suspicious use of file links */
+#define AUDIT_ANOM_EXPLOIT          1703 /* Known exploit attempt */
 #define AUDIT_INTEGRITY_DATA	    1800 /* Data integrity verification */
 #define AUDIT_INTEGRITY_METADATA    1801 /* Metadata integrity verification */
 #define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
diff --git a/security/exploit.c b/security/exploit.c
index a732613..3d8ee5b 100644
--- a/security/exploit.c
+++ b/security/exploit.c
@@ -1,3 +1,4 @@
+#include <linux/audit.h>
 #include <linux/cred.h>
 #include <linux/exploit.h>
 #include <linux/printk.h>
@@ -19,9 +20,24 @@ void _exploit(const char *id)
 	pid_t pid = task_pid_nr(task);
 	uid_t uid = from_kuid(&init_user_ns, current_uid());
 	char comm[sizeof(task->comm)];
+#ifdef CONFIG_AUDIT
+	struct audit_buffer *ab;
+#endif
 
 	get_task_comm(comm, task);
 
+#ifdef CONFIG_AUDIT
+	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_ANOM_EXPLOIT);
+	if (ab) {
+		audit_log_format(ab, "exploit id=%s pid=%u uid=%u auid=%u ses=%u comm=",
+			id, pid, uid,
+			from_kuid(&init_user_ns, audit_get_loginuid(task)),
+			audit_get_sessionid(task));
+		audit_log_untrustedstring(ab, comm);
+		audit_log_end(ab);
+	}
+#endif
+
 	pr_warn_ratelimited("warning: possible %s exploit attempt by pid=%u uid=%u comm=%s\n",
 		id, pid, uid, comm);
 }
-- 
1.7.10.4

