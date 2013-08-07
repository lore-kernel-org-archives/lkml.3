Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab3HGHki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:40:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45842 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab3HGHhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:37:46 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH v3 01/11] syslog_ns: add syslog_namespace and put/get_syslog_ns
Date: Wed, 7 Aug 2013 15:37:05 +0800
Message-ID: <1375861035-24320-2-git-send-email-rui.xiang@huawei.com>
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

Add a struct syslog_namespace which contains the necessary
members for hanlding syslog and realize get_syslog_ns and
put_syslog_ns API.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 include/linux/syslog.h | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/printk.c        |  7 ------
 2 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 98a3153..425fafe 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -21,6 +21,9 @@
 #ifndef _LINUX_SYSLOG_H
 #define _LINUX_SYSLOG_H
 
+#include <linux/slab.h>
+#include <linux/kref.h>
+
 /* Close the log.  Currently a NOP. */
 #define SYSLOG_ACTION_CLOSE          0
 /* Open the log. Currently a NOP. */
@@ -47,6 +50,71 @@
 #define SYSLOG_FROM_READER           0
 #define SYSLOG_FROM_PROC             1
 
+enum log_flags {
+	LOG_NOCONS      = 1,    /* already flushed, do not print to console */
+	LOG_NEWLINE     = 2,    /* text ended with a newline */
+	LOG_PREFIX      = 4,    /* text started with a prefix */
+	LOG_CONT        = 8,    /* text is a fragment of a continuation line */
+};
+
+struct syslog_namespace {
+	struct kref kref;	/* syslog_ns reference count & control */
+
+	raw_spinlock_t logbuf_lock; /* access conflict locker */
+	/* cpu currently holding logbuf_lock of ns */
+	unsigned int logbuf_cpu;
+
+	/* index and sequence number of the first record stored in the buffer */
+	u64 log_first_seq;
+	u32 log_first_idx;
+
+	/* index and sequence number of the next record stored in the buffer */
+	u64 log_next_seq;
+	u32 log_next_idx;
+
+	/* the next printk record to read after the last 'clear' command */
+	u64 clear_seq;
+	u32 clear_idx;
+
+	char *log_buf;
+	u32 log_buf_len;
+
+	/* the next printk record to write to the console */
+	u64 console_seq;
+	u32 console_idx;
+
+	/* the next printk record to read by syslog(READ) or /proc/kmsg */
+	u64 syslog_seq;
+	u32 syslog_idx;
+	enum log_flags syslog_prev;
+	size_t syslog_partial;
+
+	int dmesg_restrict;
+};
+
+static inline struct syslog_namespace *get_syslog_ns(
+				struct syslog_namespace *ns)
+{
+	if (ns)
+		kref_get(&ns->kref);
+	return ns;
+}
+
+static inline void free_syslog_ns(struct kref *kref)
+{
+	struct syslog_namespace *ns;
+	ns = container_of(kref, struct syslog_namespace, kref);
+
+	kfree(ns->log_buf);
+	kfree(ns);
+}
+
+static inline void put_syslog_ns(struct syslog_namespace *ns)
+{
+	if (ns)
+		kref_put(&ns->kref, free_syslog_ns);
+}
+
 int do_syslog(int type, char __user *buf, int count, bool from_file);
 
 #endif /* _LINUX_SYSLOG_H */
diff --git a/kernel/printk.c b/kernel/printk.c
index 69b0890..665cfdc 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -193,13 +193,6 @@ static int console_may_schedule;
  * separated by ',', and find the message after the ';' character.
  */
 
-enum log_flags {
-	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
-	LOG_NEWLINE	= 2,	/* text ended with a newline */
-	LOG_PREFIX	= 4,	/* text started with a prefix */
-	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
-};
-
 struct log {
 	u64 ts_nsec;		/* timestamp in nanoseconds */
 	u16 len;		/* length of entire record */
-- 
1.8.2.2


