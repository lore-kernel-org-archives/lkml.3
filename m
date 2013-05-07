Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399Ab3EGCcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:32:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760019Ab3EGCT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201756"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 12/48] Audit: make audit_initialized per user namespace
Date: Tue, 7 May 2013 10:20:33 +0800
Message-Id: <1367893269-9308-13-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize complete at 2013/05/07 10:18:27
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
index d5a22b2..c7b5bf7 100644
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
index 9ea5b27..bf8b59c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -66,12 +66,12 @@
 
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
@@ -982,7 +982,7 @@ static int __init audit_init(void)
 {
 	int i;
 
-	if (audit_initialized == AUDIT_DISABLED)
+	if (init_user_ns.audit.initialized == AUDIT_DISABLED)
 		return 0;
 
 	printk(KERN_INFO "audit: initializing netlink socket (%s)\n",
@@ -992,7 +992,6 @@ static int __init audit_init(void)
 		return -1;
 
 	audit_set_user_ns(&init_user_ns);
-	audit_initialized = AUDIT_INITIALIZED;
 
 	audit_log(NULL, GFP_KERNEL, AUDIT_KERNEL, "initialized");
 
@@ -1008,14 +1007,14 @@ static int __init audit_enable(char *str)
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
@@ -1183,7 +1182,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	unsigned long timeout_start = jiffies;
 	struct sk_buff_head	*queue = &init_user_ns.audit.queue;
 
-	if (audit_initialized != AUDIT_INITIALIZED)
+	if (init_user_ns.audit.initialized != AUDIT_INITIALIZED)
 		return NULL;
 
 	if (unlikely(audit_filter_type(type)))
@@ -1586,18 +1585,20 @@ EXPORT_SYMBOL(audit_log_secctx);
 
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

