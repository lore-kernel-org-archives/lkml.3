Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936029Ab3DKD2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:28:47 -0400
Received: from fallback.hitachi.co.jp ([133.145.228.50]:43642 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935479Ab3DKD2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:28:41 -0400
Message-ID: <51662D64.3000409@hitachi.com>
Date: Thu, 11 Apr 2013 12:26:28 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [RFC Patch 1/2] mm: Add a parameter to force a kernel panic when
 memory error occurs on dirty cache
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a sysctl interface,
vm.memory_failure_dirty_panic, to provide selectable actions
when a memory error is detected on dirty page cache.


Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
---

diff --git a/a/Documentation/sysctl/vm.txt b/b/Documentation/sysctl/vm.txt
index 078701f..7dad994 100644
--- a/a/Documentation/sysctl/vm.txt
+++ b/b/Documentation/sysctl/vm.txt
@@ -34,6 +34,7 @@ Currently, these files are in /proc/sys/vm:
 - legacy_va_layout
 - lowmem_reserve_ratio
 - max_map_count
+- memory_failure_dirty_panic
 - memory_failure_early_kill
 - memory_failure_recovery
 - min_free_kbytes
@@ -306,6 +307,29 @@ The default value is 65536.
 
 =============================================================
 
+memory_failure_dirty_panic:
+
+Control whether a system continues to operate or not when uncorrected
+recoverable memory error (typically a 2bit error in a memory module)
+is detected in the background by hardware and a page type is a dirty
+page cache.
+
+When uncorrected recoverable memory error occurs on a dirty page
+cache, the kernel truncates the page because a system crashes if
+the kernel touches the corrupted page. However, this page truncation
+causes data lost problem because the dirty page cache does not write
+back to a disk. As a result, if the dirty cache belongs a file,
+the file is not renewed and remains old data.
+
+0: Keep a system running. Note a dirty page is truncated and data
+of dirty page is lost.
+
+1: Force the kernel panic.
+
+The default value is 0.
+
+=============================================================
+
 memory_failure_early_kill:
 
 Control how to kill processes when uncorrected memory error (typically
diff --git a/a/include/linux/mm.h b/b/include/linux/mm.h
index 66e2f7c..0025882 100644
--- a/a/include/linux/mm.h
+++ b/b/include/linux/mm.h
@@ -1718,6 +1718,7 @@ enum mf_flags {
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
+extern int sysctl_memory_failure_dirty_panic;
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
diff --git a/a/kernel/sysctl.c b/b/kernel/sysctl.c
index c88878d..452dd80 100644
--- a/a/kernel/sysctl.c
+++ b/b/kernel/sysctl.c
@@ -1412,6 +1412,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "memory_failure_dirty_panic",
+		.data		= &sysctl_memory_failure_dirty_panic,
+		.maxlen		= sizeof(sysctl_memory_failure_dirty_panic),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif
 	{ }
 };
diff --git a/a/mm/memory-failure.c b/b/mm/memory-failure.c
index c6e4dd3..6d3c0ed 100644
--- a/a/mm/memory-failure.c
+++ b/b/mm/memory-failure.c
@@ -57,6 +57,8 @@
 #include <linux/kfifo.h>
 #include "internal.h"
 
+int sysctl_memory_failure_dirty_panic __read_mostly = 0;
+
 int sysctl_memory_failure_early_kill __read_mostly = 0;
 
 int sysctl_memory_failure_recovery __read_mostly = 1;
@@ -618,8 +620,16 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
 	struct address_space *mapping = page_mapping(p);
 
 	SetPageError(p);
-	/* TBD: print more information about the file. */
 	if (mapping) {
+		/* Print more information about the file. */
+		if (mapping->host != NULL && S_ISREG(mapping->host->i_mode))
+			pr_info("MCE %#lx: File was corrupted: Dev:%s Inode:%lu Offset:%lu\n",
+				page_to_pfn(p), mapping->host->i_sb->s_id,
+				mapping->host->i_ino, page_index(p));
+		else
+			pr_info("MCE %#lx: A dirty page cache was corrupted.\n",
+				page_to_pfn(p));
+
 		/*
 		 * IO error will be reported by write(), fsync(), etc.
 		 * who check the mapping.
@@ -657,6 +667,19 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
 		mapping_set_error(mapping, EIO);
 	}
 
+	/* Force a kernel panic instantly because a dirty page cache is
+	   truncated and this leads data corruption problem when
+	   application processes old data.
+	*/
+	if (sysctl_memory_failure_dirty_panic) {
+		if (mapping != NULL && mapping->host != NULL)
+			panic("MCE %#lx: Force a panic because a dirty page cache was corrupted: File type:0x%x\n",
+				page_to_pfn(p), mapping->host->i_mode);
+		else
+			panic("MCE %#lx: Force a panic because a dirty page cache was corrupted.\n",
+				page_to_pfn(p));
+	}
+
 	return me_pagecache_clean(p, pfn);
 }
 

