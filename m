Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab3HGHjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:39:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:44940 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab3HGHiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:38:00 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH v3 03/11] syslog_ns: add init syslog_ns for global syslog
Date: Wed, 7 Aug 2013 15:37:07 +0800
Message-ID: <1375861035-24320-4-git-send-email-rui.xiang@huawei.com>
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

Add init_syslog_ns to manage host log buffer, and
initilize its fileds as the global variables.

Printk by default in kernel will continue to be
targeted at init_syslog_ns. So the buf of init
ns is just the same as the original global buf.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 include/linux/syslog.h         |  1 +
 include/linux/user_namespace.h |  1 +
 kernel/printk.c                | 18 ++++++++++++++++++
 kernel/user.c                  |  3 +++
 kernel/user_namespace.c        |  4 ++++
 5 files changed, 27 insertions(+)

diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 62ce47f..363bc56 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -122,4 +122,5 @@ static inline void put_syslog_ns(struct syslog_namespace *ns)
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
 
+extern struct syslog_namespace init_syslog_ns;
 #endif /* _LINUX_SYSLOG_H */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index ce2de5b..4b5e190 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -32,6 +32,7 @@ struct user_namespace {
 };
 
 extern struct user_namespace init_user_ns;
+extern struct syslog_namespace init_syslog_ns;
 
 #ifdef CONFIG_USER_NS
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 665cfdc..f288934 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -45,6 +45,8 @@
 #include <linux/poll.h>
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
+#include <linux/cred.h>
+#include <linux/user_namespace.h>
 
 #include <asm/uaccess.h>
 
@@ -251,6 +253,22 @@ static u32 log_buf_len = __LOG_BUF_LEN;
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
+struct syslog_namespace init_syslog_ns = {
+	.kref = {
+		.refcount = ATOMIC_INIT(2),
+	},
+	.logbuf_lock = __RAW_SPIN_LOCK_UNLOCKED(init_syslog_ns.logbuf_lock),
+	.logbuf_cpu = UINT_MAX,
+	.log_buf_len = __LOG_BUF_LEN,
+	.log_buf = __log_buf,
+	.owner = &init_user_ns,
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+	.dmesg_restrict = 1,
+#else
+	.dmesg_restrict = 0,
+#endif
+};
+
 /* human readable text of the record */
 static char *log_text(const struct log *msg)
 {
diff --git a/kernel/user.c b/kernel/user.c
index 69b4c3d..0bbd4f7 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -18,6 +18,8 @@
 #include <linux/user_namespace.h>
 #include <linux/proc_ns.h>
 
+struct syslog_namespace;
+
 /*
  * userns count is 1 for root user, 1 for init_uts_ns,
  * and 1 for... ?
@@ -53,6 +55,7 @@ struct user_namespace init_user_ns = {
 	.proc_inum = PROC_USER_INIT_INO,
 	.may_mount_sysfs = true,
 	.may_mount_proc = true,
+	.syslog_ns = &init_syslog_ns,
 };
 EXPORT_SYMBOL_GPL(init_user_ns);
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index d8c30db..20f402f 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -22,6 +22,7 @@
 #include <linux/ctype.h>
 #include <linux/projid.h>
 #include <linux/fs_struct.h>
+#include <linux/syslog.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
 
@@ -95,6 +96,8 @@ int create_user_ns(struct cred *new)
 	ns->owner = owner;
 	ns->group = group;
 
+	ns->syslog_ns = get_syslog_ns(parent_ns->syslog_ns);
+
 	set_cred_user_ns(new, ns);
 
 	update_mnt_policy(ns);
@@ -122,6 +125,7 @@ void free_user_ns(struct user_namespace *ns)
 	struct user_namespace *parent;
 
 	do {
+		put_syslog_ns(ns->syslog_ns);
 		parent = ns->parent;
 		proc_free_inum(ns->proc_inum);
 		kmem_cache_free(user_ns_cachep, ns);
-- 
1.8.2.2


