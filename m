Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab3FSBxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:53:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3343 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934093Ab3FSBxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596298"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 12/22] Audit: make audit_initialized per user namespace
Date: Wed, 19 Jun 2013 09:53:44 +0800
Message-Id: <1371606834-5802-13-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:01,
	Serialize complete at 2013/06/19 09:52:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_initialized is used to identify if the audit
related resources have been initialized. it should
be per user namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h |  1 +
 kernel/audit.c                 | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a2c0a79..c665569 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -21,6 +21,7 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 #ifdef CONFIG_AUDIT
 struct audit_ctrl {
 	struct sock		*sock;
+	int			initialized;
 	int			enabled;
 	int			pid;
 	int			portid;
diff --git a/kernel/audit.c b/kernel/audit.c
index 923fe27..0b9cef2 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -68,12 +68,12 @@
 
 #include "audit.h"
 
-/* No auditing will take place until audit_initialized == AUDIT_INITIALIZED.
+/* No auditing will take place until user namespace's
+ * audit.initialized == AUDIT_INITIALIZED.
  * (Initialization happens after skb_init is called.) */
 #define AUDIT_DISABLED		-1
 #define AUDIT_UNINITIALIZED	0
 #define AUDIT_INITIALIZED	1
-static int	audit_initialized;
 
 #define AUDIT_OFF	0
 #define AUDIT_ON	1
@@ -953,7 +953,7 @@ static int __init audit_init(void)
 {
 	int i;
 
-	if (audit_initialized == AUDIT_DISABLED)
+	if (init_user_ns.audit.initialized == AUDIT_DISABLED)
 		return 0;
 
 	printk(KERN_INFO "audit: initializing netlink socket (%s)\n",
@@ -963,7 +963,6 @@ static int __init audit_init(void)
 		return -1;
 
 	audit_set_user_ns(&init_user_ns);
-	audit_initialized = AUDIT_INITIALIZED;
 
 	audit_log(NULL, GFP_KERNEL, AUDIT_KERNEL, "initialized");
 
@@ -979,14 +978,14 @@ static int __init audit_enable(char *str)
 {
 	audit_default = !!simple_strtol(str, NULL, 0);
 	if (!audit_default)
-		audit_initialized = AUDIT_DISABLED;
+		init_user_ns.audit.initialized = AUDIT_DISABLED;
 
 	printk(KERN_INFO "audit: %s", audit_default ? "enabled" : "disabled");
 
-	if (audit_initialized == AUDIT_INITIALIZED) {
+	if (init_user_ns.audit.initialized == AUDIT_INITIALIZED) {
 		init_user_ns.audit.enabled = audit_default;
 		init_user_ns.audit.ever_enabled |= !!audit_default;
-	} else if (audit_initialized == AUDIT_UNINITIALIZED) {
+	} else if (init_user_ns.audit.initialized == AUDIT_UNINITIALIZED) {
 		printk(" (after initialization)");
 	} else {
 		printk(" (until reboot)");
@@ -1147,7 +1146,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	unsigned long timeout_start = jiffies;
 	struct sk_buff_head	*queue = &init_user_ns.audit.queue;
 
-	if (audit_initialized != AUDIT_INITIALIZED)
+	if (init_user_ns.audit.initialized != AUDIT_INITIALIZED)
 		return NULL;
 
 	if (unlikely(audit_filter_type(type)))
@@ -1784,18 +1783,20 @@ EXPORT_SYMBOL(audit_log_secctx);
 
 void audit_set_user_ns(struct user_namespace *ns)
 {
-	if (audit_initialized == AUDIT_DISABLED)
+	if (init_user_ns.audit.initialized == AUDIT_DISABLED)
 		return;
 
 	skb_queue_head_init(&ns->audit.queue);
 	skb_queue_head_init(&ns->audit.hold_queue);
 	ns->audit.enabled = audit_default;
 	ns->audit.ever_enabled |= !!audit_default;
+
+	ns->audit.initialized = AUDIT_INITIALIZED;
 }
 
 void audit_free_user_ns(struct user_namespace *ns)
 {
-	if (audit_initialized == AUDIT_DISABLED)
+	if (init_user_ns.audit.initialized == AUDIT_DISABLED)
 		return;
 
 	if (ns->audit.sock) {
-- 
1.8.1.4

