Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3JRM5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3JRM5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:57:06 -0400
From: Jerome Marchand <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, dave.hansen@intel.com
Subject: [PATCH v4 1/2] mm: factor commit limit calculation
Date: Fri, 18 Oct 2013 14:56:58 +0200
Message-Id: <1382101019-23563-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change since v3:
 - rebase on 3.12-rc5

The same calculation is currently done in three differents places.
Factor that code so future changes has to be made at only one place.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 fs/proc/meminfo.c    |    5 +----
 include/linux/mman.h |   12 ++++++++++++
 mm/mmap.c            |    4 +---
 mm/nommu.c           |    3 +--
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 59d85d6..c805d5b 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -24,7 +24,6 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 {
 	struct sysinfo i;
 	unsigned long committed;
-	unsigned long allowed;
 	struct vmalloc_info vmi;
 	long cached;
 	unsigned long pages[NR_LRU_LISTS];
@@ -37,8 +36,6 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	si_meminfo(&i);
 	si_swapinfo(&i);
 	committed = percpu_counter_read_positive(&vm_committed_as);
-	allowed = ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
 	cached = global_page_state(NR_FILE_PAGES) -
 			total_swapcache_pages() - i.bufferram;
@@ -147,7 +144,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		K(global_page_state(NR_UNSTABLE_NFS)),
 		K(global_page_state(NR_BOUNCE)),
 		K(global_page_state(NR_WRITEBACK_TEMP)),
-		K(allowed),
+		K(vm_commit_limit()),
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
diff --git a/include/linux/mman.h b/include/linux/mman.h
index 92dc257..d622d34 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -7,6 +7,9 @@
 #include <linux/atomic.h>
 #include <uapi/linux/mman.h>
 
+#include <linux/hugetlb.h>
+#include <linux/swap.h>
+
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern struct percpu_counter vm_committed_as;
@@ -87,4 +90,13 @@ calc_vm_flag_bits(unsigned long flags)
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
 }
+
+/*
+ * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
+ */
+static inline unsigned long vm_commit_limit()
+{
+	return ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+}
 #endif /* _LINUX_MMAN_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index 9d54851..7755953 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -179,14 +179,12 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		goto error;
 	}
 
-	allowed = (totalram_pages - hugetlb_total_pages())
-	       	* sysctl_overcommit_ratio / 100;
+	allowed = vm_commit_limit();
 	/*
 	 * Reserve some for root
 	 */
 	if (!cap_sys_admin)
 		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-	allowed += total_swap_pages;
 
 	/*
 	 * Don't let a single process grow so big a user can't recover
diff --git a/mm/nommu.c b/mm/nommu.c
index ecd1f15..d8a957b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1948,13 +1948,12 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		goto error;
 	}
 
-	allowed = totalram_pages * sysctl_overcommit_ratio / 100;
+	allowed = vm_commit_limit();
 	/*
 	 * Reserve some 3% for root
 	 */
 	if (!cap_sys_admin)
 		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-	allowed += total_swap_pages;
 
 	/*
 	 * Don't let a single process grow so big a user can't recover
-- 
1.7.7.6

