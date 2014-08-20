Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaHTMzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:55:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3966 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbaHTMyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:54:53 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] fault-inject: add ratelimit option
Date: Wed, 20 Aug 2014 16:54:42 +0400
Message-Id: <1408539282-5699-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1408539282-5699-1-git-send-email-dmonakhov@openvz.org>
References: <1408539282-5699-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current debug levels are not optimal. Especially if one want to
provoke big numbers of faults(broken device simulator) then any verbose
level will produce giant numbers of identical logging messages.
Let's add ratelimit parameter for that purpose.

Change-log:
- Dump fault_attr configuration on minimal verbose level.
- Add name to fault_attr
- Add ratelimit parameter


Example:
  # Limit verbosity to one at 5 seconds
  echo 1 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_burst
  echo 5000 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_interval_ms

  # dump only once in a day
  echo 1 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_burst
  echo $((24 * 60 * 60* 1000)) > /sys/kernel/debug/fail_make_request/verbose_ratelimit_interval_ms

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/fault-inject.h |   17 +++++++++++------
 lib/fault-inject.c           |   30 ++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index c6f996f..798fad9 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -5,6 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/debugfs.h>
+#include <linux/ratelimit.h>
 #include <linux/atomic.h>
 
 /*
@@ -25,14 +26,18 @@ struct fault_attr {
 	unsigned long reject_end;
 
 	unsigned long count;
+	struct ratelimit_state ratelimit_state;
+	struct dentry *dname;
 };
 
-#define FAULT_ATTR_INITIALIZER {				\
-		.interval = 1,					\
-		.times = ATOMIC_INIT(1),			\
-		.require_end = ULONG_MAX,			\
-		.stacktrace_depth = 32,				\
-		.verbose = 2,					\
+#define FAULT_ATTR_INITIALIZER {					\
+		.interval = 1,						\
+		.times = ATOMIC_INIT(1),				\
+		.require_end = ULONG_MAX,				\
+		.stacktrace_depth = 32,					\
+		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
+		.verbose = 2,						\
+		.dname = NULL,						\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index d7d501e..ebb3485 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -40,10 +40,25 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
-	if (attr->verbose > 0)
-		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure\n");
-	if (attr->verbose > 1)
-		dump_stack();
+	if (attr->verbose > 0 &&
+	    ___ratelimit(&attr->ratelimit_state, __func__)) {
+		if (attr->dname)
+			printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure."
+			       "name %pd, interval %lu, probability %lu, "
+			       "space %d, times %d\n", attr->dname,
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
+		if (attr->verbose > 1)
+			dump_stack();
+	}
 }
 
 #define atomic_dec_not_zero(v)		atomic_add_unless((v), -1, 0)
@@ -202,6 +217,12 @@ struct dentry *fault_create_debugfs_attr(const char *name,
 		goto fail;
 	if (!debugfs_create_ul("verbose", mode, dir, &attr->verbose))
 		goto fail;
+	if (!debugfs_create_u32("verbose_ratelimit_interval_ms", mode, dir,
+				&attr->ratelimit_state.interval))
+		goto fail;
+	if (!debugfs_create_u32("verbose_ratelimit_burst", mode, dir,
+				&attr->ratelimit_state.burst))
+		goto fail;
 	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
 		goto fail;
 
@@ -222,6 +243,7 @@ struct dentry *fault_create_debugfs_attr(const char *name,
 
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
+	attr->dname = dget(dir);
 	return dir;
 fail:
 	debugfs_remove_recursive(dir);
-- 
1.7.1

