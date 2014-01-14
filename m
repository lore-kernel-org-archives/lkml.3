Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaANSd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:33:27 -0500
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:45267 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752027AbaANSdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:33:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2393:2559:2562:2907:3138:3139:3140:3141:3142:3865:3866:3867:3870:3871:3874:4049:4118:4605:5007:6261:7903:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: knee44_3a0e7d0f0ec4c
X-Filterd-Recvd-Size: 7599
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/2] audit: Convert int limit uses to u32
Date: Tue, 14 Jan 2014 10:33:13 -0800
Message-Id: <7122d36ffb0d82a660bdf16f0c344d7611a5c1e1.1389724329.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <f4acac9406b7ec15f859215808e72305e6a3a46a.1389724329.git.joe@perches.com>
References: <f4acac9406b7ec15f859215808e72305e6a3a46a.1389724329.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The equivalent uapi struct uses __u32 so make the kernel
uses u32 too.

This can prevent some oddities where the limit is
logged/emitted as a negative value.

Convert kstrtol to kstrtouint to disallow negative values.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/audit.h |  2 +-
 kernel/audit.c        | 49 +++++++++++++++++++++++++------------------------
 kernel/audit.h        |  2 +-
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 52ee780..4b1669c 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -463,7 +463,7 @@ extern int audit_filter_user(int type);
 extern int audit_filter_type(int type);
 extern int  audit_receive_filter(int type, __u32 portid, int seq,
 				void *data, size_t datasz);
-extern int audit_enabled;
+extern u32 audit_enabled;
 #else /* CONFIG_AUDIT */
 static inline __printf(4, 5)
 void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
diff --git a/kernel/audit.c b/kernel/audit.c
index f397ab2..902c3aa 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -79,16 +79,16 @@ static int	audit_initialized;
 #define AUDIT_OFF	0
 #define AUDIT_ON	1
 #define AUDIT_LOCKED	2
-int		audit_enabled;
-int		audit_ever_enabled;
+u32		audit_enabled;
+u32		audit_ever_enabled;
 
 EXPORT_SYMBOL_GPL(audit_enabled);
 
 /* Default state when kernel boots without any parameters. */
-static int	audit_default;
+u32	audit_default;
 
 /* If auditing cannot proceed, audit_failure selects what happens. */
-static int	audit_failure = AUDIT_FAIL_PRINTK;
+static u32	audit_failure = AUDIT_FAIL_PRINTK;
 
 /*
  * If audit records are to be written to the netlink socket, audit_pid
@@ -101,14 +101,14 @@ static __u32	audit_nlk_portid;
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
  * to that number per second.  This prevents DoS attacks, but results in
  * audit records being dropped. */
-static int	audit_rate_limit;
+static u32	audit_rate_limit;
 
 /* Number of outstanding audit_buffers allowed.
  * When set to zero, this means unlimited. */
-static int	audit_backlog_limit = 64;
+static u32	audit_backlog_limit = 64;
 #define AUDIT_BACKLOG_WAIT_TIME (60 * HZ)
-static int	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
-static int	audit_backlog_wait_overflow = 0;
+static u32	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+static u32	audit_backlog_wait_overflow = 0;
 
 /* The identity of the user shutting down the audit system. */
 kuid_t		audit_sig_uid = INVALID_UID;
@@ -272,7 +272,7 @@ void audit_log_lost(const char *message)
 
 	if (print) {
 		if (printk_ratelimit())
-			pr_warn("audit_lost=%d audit_rate_limit=%d audit_backlog_limit=%d\n",
+			pr_warn("audit_lost=%u audit_rate_limit=%u audit_backlog_limit=%u\n",
 				atomic_read(&audit_lost),
 				audit_rate_limit,
 				audit_backlog_limit);
@@ -280,7 +280,7 @@ void audit_log_lost(const char *message)
 	}
 }
 
-static int audit_log_config_change(char *function_name, int new, int old,
+static int audit_log_config_change(char *function_name, u32 new, u32 old,
 				   int allow_changes)
 {
 	struct audit_buffer *ab;
@@ -289,7 +289,7 @@ static int audit_log_config_change(char *function_name, int new, int old,
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return rc;
-	audit_log_format(ab, "%s=%d old=%d", function_name, new, old);
+	audit_log_format(ab, "%s=%u old=%u", function_name, new, old);
 	audit_log_session_info(ab);
 	rc = audit_log_task_context(ab);
 	if (rc)
@@ -299,9 +299,10 @@ static int audit_log_config_change(char *function_name, int new, int old,
 	return rc;
 }
 
-static int audit_do_config_change(char *function_name, int *to_change, int new)
+static int audit_do_config_change(char *function_name, u32 *to_change, u32 new)
 {
-	int allow_changes, rc = 0, old = *to_change;
+	int allow_changes, rc = 0;
+	u32 old = *to_change;
 
 	/* check if we are locked */
 	if (audit_enabled == AUDIT_LOCKED)
@@ -324,23 +325,23 @@ static int audit_do_config_change(char *function_name, int *to_change, int new)
 	return rc;
 }
 
-static int audit_set_rate_limit(int limit)
+static int audit_set_rate_limit(u32 limit)
 {
 	return audit_do_config_change("audit_rate_limit", &audit_rate_limit, limit);
 }
 
-static int audit_set_backlog_limit(int limit)
+static int audit_set_backlog_limit(u32 limit)
 {
 	return audit_do_config_change("audit_backlog_limit", &audit_backlog_limit, limit);
 }
 
-static int audit_set_backlog_wait_time(int timeout)
+static int audit_set_backlog_wait_time(u32 timeout)
 {
 	return audit_do_config_change("audit_backlog_wait_time",
 				      &audit_backlog_wait_time, timeout);
 }
 
-static int audit_set_enabled(int state)
+static int audit_set_enabled(u32 state)
 {
 	int rc;
 	if (state < AUDIT_OFF || state > AUDIT_LOCKED)
@@ -353,7 +354,7 @@ static int audit_set_enabled(int state)
 	return rc;
 }
 
-static int audit_set_failure(int state)
+static int audit_set_failure(u32 state)
 {
 	if (state != AUDIT_FAIL_SILENT
 	    && state != AUDIT_FAIL_PRINTK
@@ -687,7 +688,7 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 		return;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_FEATURE_CHANGE);
-	audit_log_format(ab, "feature=%s old=%d new=%d old_lock=%d new_lock=%d res=%d",
+	audit_log_format(ab, "feature=%s old=%u new=%u old_lock=%u new_lock=%u res=%d",
 			 audit_feature_names[which], !!old_feature, !!new_feature,
 			 !!old_lock, !!new_lock, res);
 	audit_log_end(ab);
@@ -1133,16 +1134,16 @@ __setup("audit=", audit_enable);
  * audit_backlog_limit=<n> */
 static int __init audit_backlog_limit_set(char *str)
 {
-	long int audit_backlog_limit_arg;
+	u32 audit_backlog_limit_arg;
 
 	pr_info("audit_backlog_limit: ");
-	if (kstrtol(str, 0, &audit_backlog_limit_arg)) {
-		pr_cont("using default of %d, unable to parse %s\n",
+	if (kstrtouint(str, 0, &audit_backlog_limit_arg)) {
+		pr_cont("using default of %u, unable to parse %s\n",
 			audit_backlog_limit, str);
 		return 1;
 	}
-	if (audit_backlog_limit_arg >= 0)
-		audit_backlog_limit = (int)audit_backlog_limit_arg;
+
+	audit_backlog_limit = audit_backlog_limit_arg;
 	pr_cont("%d\n", audit_backlog_limit);
 
 	return 1;
diff --git a/kernel/audit.h b/kernel/audit.h
index 0719b45..57cc64d 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -209,7 +209,7 @@ struct audit_context {
 #endif
 };
 
-extern int audit_ever_enabled;
+extern u32 audit_ever_enabled;
 
 extern void audit_copy_inode(struct audit_names *name,
 			     const struct dentry *dentry,
-- 
1.8.1.2.459.gbcd45b4.dirty

