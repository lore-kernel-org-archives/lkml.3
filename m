Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3HGHhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:37:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45803 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3HGHho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:37:44 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH v3 07/11] syslog_ns: implement function for creating syslog ns
Date: Wed, 7 Aug 2013 15:37:11 +0800
Message-ID: <1375861035-24320-8-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add create_syslog_ns function to create a new ns. We
must create a user_ns before create a new syslog ns.
And then tie the new syslog_ns to current user_ns
instead of original syslog_ns which comes from
parent user_ns.

Add a new syslog flag SYSLOG_ACTION_NEW_NS to implement
a new command(11) of __NR_syslog system call. Through
that command, we can create a new syslog ns in user
space.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 include/linux/syslog.h |  4 ++++
 kernel/printk.c        | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index fbf0cb6..118970c 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -23,6 +23,7 @@
 
 #include <linux/slab.h>
 #include <linux/kref.h>
+#include <linux/user_namespace.h>
 
 /* Close the log.  Currently a NOP. */
 #define SYSLOG_ACTION_CLOSE          0
@@ -46,6 +47,8 @@
 #define SYSLOG_ACTION_SIZE_UNREAD    9
 /* Return size of the log buffer */
 #define SYSLOG_ACTION_SIZE_BUFFER   10
+/* Create a new syslog ns */
+#define SYSLOG_ACTION_NEW_NS        11
 
 #define SYSLOG_FROM_READER           0
 #define SYSLOG_FROM_PROC             1
@@ -110,6 +113,7 @@ static inline void free_syslog_ns(struct kref *kref)
 	struct syslog_namespace *ns;
 	ns = container_of(kref, struct syslog_namespace, kref);
 
+	put_user_ns(ns->owner);
 	kfree(ns->log_buf);
 	kfree(ns);
 }
diff --git a/kernel/printk.c b/kernel/printk.c
index bdb7ed4..a812a88 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -378,6 +378,10 @@ static int check_syslog_permissions(int type, bool from_file,
 		|| type == SYSLOG_ACTION_CONSOLE_LEVEL)
 		ns = &init_syslog_ns;
 
+	/* create a new syslog ns */
+	if (type == SYSLOG_ACTION_NEW_NS)
+		return 0;
+
 	if (syslog_action_restricted(type, ns)) {
 		if (ns_capable(ns->owner, CAP_SYSLOG))
 			return 0;
@@ -1125,6 +1129,51 @@ static int syslog_print_all(char __user *buf, int size, bool clear,
 	return len;
 }
 
+static int create_syslog_ns(void)
+{
+	struct user_namespace *userns = current_user_ns();
+	struct syslog_namespace *oldns, *newns;
+	int err;
+
+	/*
+	 * syslog ns belongs to a user ns.  So you can only unshare your
+	 * user_ns if you share a user_ns with your parent userns
+	 */
+	if (userns == &init_user_ns ||
+		userns->syslog_ns != userns->parent->syslog_ns)
+		return -EINVAL;
+
+	if (!ns_capable(userns, CAP_SYSLOG))
+		return -EPERM;
+
+	err = -ENOMEM;
+	oldns = userns->syslog_ns;
+	newns = kzalloc(sizeof(*newns), GFP_ATOMIC);
+	if (!newns)
+		goto out;
+	newns->log_buf_len = __LOG_BUF_LEN;
+	newns->log_buf = kzalloc(newns->log_buf_len, GFP_ATOMIC);
+	if (!newns->log_buf)
+		goto out;
+
+	newns->owner = get_user_ns(userns);
+	raw_spin_lock_init(&(newns->logbuf_lock));
+	newns->logbuf_cpu = UINT_MAX;
+	newns->dmesg_restrict = oldns->dmesg_restrict;
+	put_syslog_ns(oldns);
+	kref_init(&newns->kref);
+	userns->syslog_ns = newns;
+	newns = NULL;
+
+	err = 0;
+out:
+	if (newns) {
+		kfree(newns->log_buf);
+		kfree(newns);
+	}
+	return err;
+}
+
 int do_syslog(int type, char __user *buf, int len, bool from_file,
 		struct syslog_namespace *ns)
 {
@@ -1248,6 +1297,9 @@ int do_syslog(int type, char __user *buf, int len, bool from_file,
 	case SYSLOG_ACTION_SIZE_BUFFER:
 		error = ns->log_buf_len;
 		break;
+	case SYSLOG_ACTION_NEW_NS:
+		error = create_syslog_ns();
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
1.8.2.2


