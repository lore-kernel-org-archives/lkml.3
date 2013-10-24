Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3JXHbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:31:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab3JXHbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:09 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847759"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 18/20] audit: add new message type AUDIT_CREATE_NS
Date: Thu, 24 Oct 2013 15:32:03 +0800
Message-Id: <1382599925-25143-19-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:31,
	Serialize complete at 2013/10/24 15:28:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is no more place for flags of clone system call.
we need to find a way to create audit namespace.

this patch add a new type of message AUDIT_CREATE_NS.
user space can create new audit namespace through
netlink.

Right now, The privileged user in user namespace is allowed
to create audit namespace. it means the unprivileged user can
create an user namespace and then create audit namespace.

Looks like it is not safe, but even the unprivileged user can
create audit namespace, it can do no harm to the host. un-init
audit namespace cann't effect the host.

In the follow patches, the audit_backlog_limit will be per
audit namesapace, but only the privileged user has rights to
modify it. and the default value of audit_backlog_limit for
uninit audit namespace will be set to 0.

And the audit_rate_limit will be limited too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h |  7 +++++++
 include/uapi/linux/audit.h      |  1 +
 kernel/audit.c                  | 22 ++++++++++++++++++++++
 kernel/audit_namespace.c        | 29 +++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
index 79a9b78..b17f052 100644
--- a/include/linux/audit_namespace.h
+++ b/include/linux/audit_namespace.h
@@ -54,6 +54,8 @@ void put_audit_ns(struct audit_namespace *ns)
 		rcu_read_unlock();
 	}
 }
+
+extern int unshare_audit_namespace(void);
 #else
 static inline
 struct audit_namespace *get_audit_ns(struct audit_namespace *ns)
@@ -66,6 +68,11 @@ void put_audit_ns(struct audit_namespace *ns)
 {
 
 }
+
+static inline int unshare_audit_namespace()
+{
+	return -EINVAL;
+}
 #endif
 
 static inline struct
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 75cef3f..877d509 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -68,6 +68,7 @@
 #define AUDIT_MAKE_EQUIV	1015	/* Append to watched tree */
 #define AUDIT_TTY_GET		1016	/* Get TTY auditing status */
 #define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
+#define AUDIT_CREATE_NS		1018	/* Create new audit namespace */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
diff --git a/kernel/audit.c b/kernel/audit.c
index c4d4291..86212d3 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -596,6 +596,12 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 		    !capable(CAP_AUDIT_CONTROL))
 			err = -EPERM;
 		break;
+	case AUDIT_CREATE_NS:
+		/* Allow privileged user in user namespace to
+		 * create audit namespace */
+		if (!ns_capable(current_user_ns(), CAP_AUDIT_CONTROL))
+			err = -EPERM;
+		break;
 	case AUDIT_USER:
 	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
 	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
@@ -735,6 +741,22 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (status_get->mask & AUDIT_STATUS_BACKLOG_LIMIT)
 			err = audit_set_backlog_limit(status_get->backlog_limit);
 		break;
+	case AUDIT_CREATE_NS:
+		err = unshare_audit_namespace();
+
+		if (audit_enabled == AUDIT_OFF)
+			break;
+
+		ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, AUDIT_CREATE_NS);
+		if (ab) {
+			audit_log_format(ab, "Create audit namespace");
+			audit_log_session_info(ab);
+			audit_log_task_context(ab);
+			audit_log_format(ab, "res=%d", err ? 0 : 1);
+			audit_log_end_ns(ns, ab);
+		}
+
+		break;
 	case AUDIT_USER:
 	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
 	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
diff --git a/kernel/audit_namespace.c b/kernel/audit_namespace.c
index 6d9cb8f..28c608e 100644
--- a/kernel/audit_namespace.c
+++ b/kernel/audit_namespace.c
@@ -6,3 +6,32 @@ struct audit_namespace init_audit_ns = {
 	.user_ns = &init_user_ns,
 };
 EXPORT_SYMBOL_GPL(init_audit_ns);
+
+int unshare_audit_namespace(void)
+{
+	struct task_struct *tsk = current;
+	struct audit_namespace *new_audit = NULL;
+	struct nsproxy *new_nsp;
+
+	new_audit = kzalloc(sizeof(struct audit_namespace), GFP_KERNEL);
+	if (!new_audit)
+		return -ENOMEM;
+
+	skb_queue_head_init(&new_audit->queue);
+	skb_queue_head_init(&new_audit->hold_queue);
+	init_waitqueue_head(&new_audit->kauditd_wait);
+	init_waitqueue_head(&new_audit->backlog_wait);
+
+	new_nsp = create_new_namespaces(0, tsk, NULL, NULL);
+	if (IS_ERR(new_nsp)) {
+		kfree(new_audit);
+		return PTR_ERR(new_nsp);
+	}
+
+	new_audit->user_ns = get_user_ns(current_user_ns());
+	new_nsp->audit_ns = get_audit_ns(new_audit);
+
+	switch_task_namespaces(current, new_nsp);
+
+	return 0;
+}
-- 
1.8.3.1

