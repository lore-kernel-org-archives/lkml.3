Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936096Ab3DKD33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:29:29 -0400
Received: from fallback.hitachi.co.jp ([133.145.228.50]:43648 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3DKD32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:29:28 -0400
Message-ID: <51662D93.1050804@hitachi.com>
Date: Thu, 11 Apr 2013 12:27:15 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [RFC Patch 2/2] mm: Add parameters to limit a rate of outputting
 memory error messages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new sysctl interfaces in order to limit
a rate of outputting memory error messages.

- vm.memory_failure_print_ratelimit:
  Specify the minimum length of time between messages.
  By default the rate limiting is disabled.

- vm.memory_failure_print_ratelimit_burst:
  Specify the number of messages we can send before rate limiting.


Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
---

diff --git a/a/Documentation/sysctl/vm.txt b/b/Documentation/sysctl/vm.txt
index 7dad994..eea6f4d 100644
--- a/a/Documentation/sysctl/vm.txt
+++ b/b/Documentation/sysctl/vm.txt
@@ -36,6 +36,8 @@ Currently, these files are in /proc/sys/vm:
 - max_map_count
 - memory_failure_dirty_panic
 - memory_failure_early_kill
+- memory_failure_print_ratelimit
+- memory_failure_print_ratelimit_burst
 - memory_failure_recovery
 - min_free_kbytes
 - min_slab_ratio
@@ -358,6 +360,30 @@ Applications can override this setting individually with the PR_MCE_KILL prctl
 
 ==============================================================
 
+memory_failure_print_ratelimit:
+
+Error messages related data lost which come from truncating
+dirty page cache are rate limited.
+memory_failure_print_ratelimit specifies the minimum length of
+time between these messages (in jiffies), by default the rate
+limiting is disabled.
+
+If a value is set to 5, we allow one error message every 5 seconds.
+
+==============================================================
+
+memory_failure_print_ratelimit_burst:
+
+While long term we enforce one message per
+memory_failure_print_ratelimit seconds, we do allow a burst of
+messages to pass through.
+memory_failure_print_ratelimit_burst specifies the number of
+messages we can send before rate limiting kicks in.
+If memory_failure_print_ratelimit is set to 0, this parameter
+is ineffective.
+
+==============================================================
+
 memory_failure_recovery
 
 Enable memory failure recovery (when supported by the platform)
diff --git a/a/include/linux/mm.h b/b/include/linux/mm.h
index 0025882..ca27bd9 100644
--- a/a/include/linux/mm.h
+++ b/b/include/linux/mm.h
@@ -1721,6 +1721,7 @@ extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_dirty_panic;
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
+extern struct ratelimit_state sysctl_memory_failure_print_ratelimit;
 extern void shake_page(struct page *p, int access);
 extern atomic_long_t mce_bad_pages;
 extern int soft_offline_page(struct page *page, int flags);
diff --git a/a/kernel/sysctl.c b/b/kernel/sysctl.c
index 452dd80..0703c2e 100644
--- a/a/kernel/sysctl.c
+++ b/b/kernel/sysctl.c
@@ -1421,6 +1421,20 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "memory_failure_print_ratelimit",
+		.data		= &sysctl_memory_failure_print_ratelimit.interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "memory_failure_print_ratelimit_burst",
+		.data		= &sysctl_memory_failure_print_ratelimit.burst,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{ }
 };
diff --git a/a/mm/memory-failure.c b/b/mm/memory-failure.c
index 6d3c0ed..ce5bb1a 100644
--- a/a/mm/memory-failure.c
+++ b/b/mm/memory-failure.c
@@ -55,6 +55,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/mm_inline.h>
 #include <linux/kfifo.h>
+#include <linux/ratelimit.h>
 #include "internal.h"
 
 int sysctl_memory_failure_dirty_panic __read_mostly = 0;
@@ -78,6 +79,16 @@ EXPORT_SYMBOL_GPL(hwpoison_filter_dev_minor);
 EXPORT_SYMBOL_GPL(hwpoison_filter_flags_mask);
 EXPORT_SYMBOL_GPL(hwpoison_filter_flags_value);
 
+/*
+ * This enforces a rate limit for outputting error message.
+ * The default interval is set to "0" HZ. This means that
+ * outputting error message is not limited by default.
+ * The default burst is set to "10". This parameter can control
+ * to output number of messages per interval.
+ * If interval is set to "0", the burst is ineffective.
+ */
+DEFINE_RATELIMIT_STATE(sysctl_memory_failure_print_ratelimit, 0 * HZ, 10);
+
 static int hwpoison_filter_dev(struct page *p)
 {
 	struct address_space *mapping;
@@ -622,13 +633,16 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
 	SetPageError(p);
 	if (mapping) {
 		/* Print more information about the file. */
-		if (mapping->host != NULL && S_ISREG(mapping->host->i_mode))
-			pr_info("MCE %#lx: File was corrupted: Dev:%s Inode:%lu Offset:%lu\n",
-				page_to_pfn(p), mapping->host->i_sb->s_id,
-				mapping->host->i_ino, page_index(p));
-		else
-			pr_info("MCE %#lx: A dirty page cache was corrupted.\n",
-				page_to_pfn(p));
+		if (__ratelimit(&sysctl_memory_failure_print_ratelimit)) {
+			if (mapping->host != NULL &&
+			    S_ISREG(mapping->host->i_mode))
+				pr_info("MCE %#lx: File was corrupted: Dev:%s Inode:%lu Offset:%lu\n",
+				   page_to_pfn(p), mapping->host->i_sb->s_id,
+				   mapping->host->i_ino, page_index(p));
+			else
+				pr_info("MCE %#lx: A dirty page cache was corrupted.\n",
+					page_to_pfn(p));
+		}
 
 		/*
 		 * IO error will be reported by write(), fsync(), etc.
