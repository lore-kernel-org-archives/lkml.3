Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3A1Dra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab3A1Dq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:46:56 -0500
From: Richard Guy Briggs <rbriggs@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Richard Guy Briggs <rbriggs@redhat.com>
Subject: [PATCH 5/6] audit: add restricted capability read-only netlink multicast socket
Date: Sun, 27 Jan 2013 22:45:17 -0500
Message-Id: <1359344718-3953-6-git-send-email-rbriggs@redhat.com>
In-Reply-To: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
References: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

Add a netlink multicast socket with one group to kaudit for "best-effort"
delivery to read-only userspace clients such as systemd, in addition to the
existing bidirectional unicast auditd userspace client.

Currently, auditd is intended to use the CAP_AUDIT_CONTROL and CAP_AUDIT_WRITE
capabilities, but actually uses CAP_NET_ADMIN.  The CAP_AUDIT_READ capability
is added for use by read-only AUDIT_NLGRP_READLOG netlink multicast group
clients to the kaudit subsystem.

This will safely give access to services such as systemd to consume audit logs
while ensuring write access remains restricted for integrity.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
---

(The seemingly wasteful skb_copy() is necessary because the original kaudit
unicast socket sends up messages with nlmsg_len set to the payload length
rather than the entire message length.  This breaks the convention used by
netlink.  The existing auditd daemon assumes this breakage.  Fixing this would
require co-ordinating a change in the established protocol between kaudit
kernel code and auditd userspace code.  There is no reason for new multicast
clients to continue with this breakage.)

 include/uapi/linux/audit.h          |  8 ++++++++
 include/uapi/linux/capability.h     |  5 ++++-
 kernel/audit.c                      | 40 +++++++++++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 4 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 9f096f1..6296e5d9 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -357,6 +357,14 @@ enum {
 #define AUDIT_PERM_READ		4
 #define AUDIT_PERM_ATTR		8
 
+/* Multicast Netlink socket groups (default up to 32) */
+enum audit_nlgrps {
+	AUDIT_NLGRP_NONE,	/* Group 0 not used */
+	AUDIT_NLGRP_READLOG,	/* "best effort" read only socket */
+	__AUDIT_NLGRP_MAX
+};
+#define AUDIT_NLGRP_MAX                (__AUDIT_NLGRP_MAX - 1)
+
 struct audit_status {
 	__u32		mask;		/* Bit mask for valid entries */
 	__u32		enabled;	/* 1 = enabled, 0 = disabled */
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index ba478fa..f579a06 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -343,7 +343,10 @@ struct vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/* Allowed to read the audit log */
+#define CAP_AUDIT_READ		37
+
+#define CAP_LAST_CAP         CAP_AUDIT_READ
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 02a5d9e..9eef05b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -418,6 +418,37 @@ static void kauditd_send_skb(struct sk_buff *skb)
 }
 
 /*
+ * kauditd_send_multicast_skb - send the skb to multicast userspace listeners
+ *
+ * This function doesn't consume an skb as might be expected since it has to
+ * copy it anyways.
+ */
+static void kauditd_send_multicast_skb(struct sk_buff *skb)
+{
+	struct sk_buff *copy;
+	struct nlmsghdr *nlh;
+
+	/*
+	 * The seemingly wasteful skb_copy() is necessary because the original
+	 * kaudit unicast socket sends up messages with nlmsg_len set to the
+	 * payload length rather than the entire message length.  This breaks
+	 * the standard set by netlink.  The existing auditd daemon assumes
+	 * this breakage.  Fixing this would require co-ordinating a change in
+	 * the established protocol between the kaudit kernel subsystem and
+	 * the auditd userspace code.  There is no reason for new multicast
+	 * clients to continue with this non-compliance.
+	 */
+	copy = skb_copy(skb, GFP_KERNEL);
+	if (!copy)
+		return;
+
+	nlh = nlmsg_hdr(copy);
+	nlh->nlmsg_len = copy->len;
+
+	nlmsg_multicast(audit_sock, copy, 0, AUDIT_NLGRP_READLOG, GFP_KERNEL);
+}
+
+/*
  * flush_hold_queue - empty the hold queue if auditd appears
  *
  * If auditd just started, drain the queue of messages already
@@ -468,6 +499,12 @@ static int kauditd_thread(void *dummy)
 		skb = skb_dequeue(&audit_skb_queue);
 		wake_up(&audit_backlog_wait);
 		if (skb) {
+			/* Don't bump skb refcount for multicast send since
+			 * kauditd_send_multicast_skb() copies the skb anyway
+			 * due to audit unicast netlink protocol
+			 * non-compliance.
+			 */
+			kauditd_send_multicast_skb(skb);
 			if (audit_pid)
 				kauditd_send_skb(skb);
 			else
@@ -951,6 +988,9 @@ static int __init audit_init(void)
 	int i;
 	struct netlink_kernel_cfg cfg = {
 		.input	= audit_receive,
+		.groups	= AUDIT_NLGRP_MAX,
+		.flags = NL_CFG_F_CAPABILITY_RECV,
+		.cap_recv_requires = CAP_AUDIT_READ,
 	};
 
 	if (audit_initialized == AUDIT_DISABLED)
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index df2de54..c0bac6f 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -147,7 +147,7 @@ struct security_class_mapping secclass_map[] = {
 	{ "peer", { "recv", NULL } },
 	{ "capability2",
 	  { "mac_override", "mac_admin", "syslog", "wake_alarm", "block_suspend",
-	    NULL } },
+	    "audit_read", NULL } },
 	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
-- 
1.8.0.2

