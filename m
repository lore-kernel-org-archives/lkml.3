Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaBSSJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbaBSSJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:28 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: netdev@oss.sgi.com, davem@davemloft.net, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 4/5] audit: add netlink multicast group for log read
Date: Wed, 19 Feb 2014 13:08:22 -0500
Message-Id: <c0e1c177266ab9ee43ce4af7430e908e8b7c2859.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a netlink multicast socket with one group to kaudit for "best-effort"
delivery to read-only userspace clients such as systemd, in addition to the
existing bidirectional unicast auditd userspace client.

Currently, auditd is intended to use the CAP_AUDIT_CONTROL and CAP_AUDIT_WRITE
capabilities, but actually uses CAP_NET_ADMIN.  The CAP_AUDIT_READ capability
is added for use by read-only AUDIT_NLGRP_READLOG netlink multicast group
clients to the kaudit subsystem.

This will safely give access to services such as systemd to consume audit logs
while ensuring write access remains restricted for integrity.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h          |    8 +++++++
 include/uapi/linux/capability.h     |    7 +++++-
 kernel/audit.c                      |   39 +++++++++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |    2 +-
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 2d48fe1..8aba976 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -372,6 +372,14 @@ enum {
  */
 #define AUDIT_MESSAGE_TEXT_MAX	8560
 
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
index 154dd6d..12c37a1 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -347,7 +347,12 @@ struct vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/* Allow reading the audit log via multicast netlink socket */
+
+#define CAP_AUDIT_READ		37
+
+
+#define CAP_LAST_CAP         CAP_AUDIT_READ
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/kernel/audit.c b/kernel/audit.c
index f2d2d61..0da57b6 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -424,6 +424,37 @@ static void kauditd_send_skb(struct sk_buff *skb)
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
@@ -474,6 +505,12 @@ static int kauditd_thread(void *dummy)
 		skb = skb_dequeue(&audit_skb_queue);
 
 		if (skb) {
+			/* Don't bump skb refcount for multicast send since
+			 * kauditd_send_multicast_skb() copies the skb anyway
+			 * due to audit unicast netlink protocol
+			 * non-compliance.
+			 */
+			kauditd_send_multicast_skb(skb);
 			if (skb_queue_len(&audit_skb_queue) <= audit_backlog_limit)
 				wake_up(&audit_backlog_wait);
 			if (audit_pid)
@@ -1064,6 +1101,8 @@ static int __net_init audit_net_init(struct net *net)
 	struct netlink_kernel_cfg cfg = {
 		.input	= audit_receive,
 		.bind	= audit_bind,
+		.flags	= NL_CFG_F_NONROOT_RECV,
+		.groups	= AUDIT_NLGRP_MAX,
 	};
 
 	struct audit_net *aunet = net_generic(net, audit_net_id);
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 14d04e6..be491a7 100644
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
 	  { COMMON_SOCK_PERMS, "attach_queue", NULL } },
-- 
1.7.1

