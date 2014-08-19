Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaHSIwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:52:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23686 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaHSIv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:51:58 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] fault-inject: Improve debug flexibility
Date: Tue, 19 Aug 2014 12:51:42 +0400
Message-Id: <1408438302-24123-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current debug levels are not optimal. Especially if one want to
provoke big numbers of faults(broken device simulator) then any verbose
level will produce giant numbers of identical logging messages. For that
reason it is reasonable to have DUMP_ONCE flag, which will be cleared
after first failure. Also the only way to understand which fail_attr
was triggered is by means of investigating stack trace, which is also
sub-optimal. Let's just dump name of this fail_attr.


Change-log:
- Dump fault_attr configuration on minimal verbose level.
- Add name to fault_attr
- Add DUMP_ONE flag(1024)

EXAMPLE:
    echo "Start: forced USB unplug simulator"
    mount $SCRATCH_BDEV $SCRATCH_MNT
    cp -r $FROM $SCRATCH_BDEV &
    echo 100 > /sys/kernel/fail_make_request/probability
    echo 9999999 > /sys/kernel/fail_make_request/times
    echo 1024 >  /sys/kernel/debug/fail_make_request/verbose
    echo "Force SCRATCH_DEV device failure"
    echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
    umount $SCRATCH_MNT
    echo "Makes device operational again"
    echo 0 > /sys/kernel/fail_make_request/probability
    echo 0 > /sys/kernel/fail_make_request/times
    fsck -f $SCRATCH_BDEV

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/fault-inject.h |    7 +++++--
 lib/fault-inject.c           |   28 +++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index c6f996f..af03c8c 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -16,7 +16,7 @@ struct fault_attr {
 	unsigned long interval;
 	atomic_t times;
 	atomic_t space;
-	unsigned long verbose;
+	atomic_t verbose;
 	u32 task_filter;
 	unsigned long stacktrace_depth;
 	unsigned long require_start;
@@ -25,14 +25,17 @@ struct fault_attr {
 	unsigned long reject_end;
 
 	unsigned long count;
+	struct dentry *debugfs_dir;
 };
 
+#define FAULT_ATTR_VERBOSE_ONCE 1024
 #define FAULT_ATTR_INITIALIZER {				\
 		.interval = 1,					\
 		.times = ATOMIC_INIT(1),			\
 		.require_end = ULONG_MAX,			\
 		.stacktrace_depth = 32,				\
-		.verbose = 2,					\
+		.verbose = ATOMIC_INIT(2),			\
+		.debugfs_dir = NULL,				\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index d7d501e..e4d82e7 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -40,10 +40,28 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
-	if (attr->verbose > 0)
-		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure\n");
-	if (attr->verbose > 1)
+	if (atomic_read(&attr->verbose) > 0) {
+		if (attr->debugfs_dir)
+			printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure."
+			       "name %pd, interval %lu, probability %lu, "
+			       "space %d, times %d\n", attr->debugfs_dir,
+			       attr->probability, attr->interval,
+			       atomic_read(&attr->space),
+			       atomic_read(&attr->times));
+		else
+			printk(KERN_NOTICE "FAULT_INJECTION: forcing a "
+			       "failure, interval %lu, probability %lu, "
+			       "space %d, times %d\n", attr->probability,
+			       attr->interval, atomic_read(&attr->space),
+			       atomic_read(&attr->times));
+
+	}
+	if (atomic_read(&attr->verbose) > 1) {
 		dump_stack();
+		if (atomic_read(&attr->verbose) & FAULT_ATTR_VERBOSE_ONCE)
+			atomic_clear_mask(FAULT_ATTR_VERBOSE_ONCE,
+					  &attr->verbose);
+	}
 }
 
 #define atomic_dec_not_zero(v)		atomic_add_unless((v), -1, 0)
@@ -200,7 +218,7 @@ struct dentry *fault_create_debugfs_attr(const char *name,
 		goto fail;
 	if (!debugfs_create_atomic_t("space", mode, dir, &attr->space))
 		goto fail;
-	if (!debugfs_create_ul("verbose", mode, dir, &attr->verbose))
+	if (!debugfs_create_atomic_t("verbose", mode, dir, &attr->verbose))
 		goto fail;
 	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
 		goto fail;
@@ -221,7 +239,7 @@ struct dentry *fault_create_debugfs_attr(const char *name,
 		goto fail;
 
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
-
+	attr->debugfs_dir = dir;
 	return dir;
 fail:
 	debugfs_remove_recursive(dir);
-- 
1.7.1

