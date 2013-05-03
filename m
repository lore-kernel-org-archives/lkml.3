Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228Ab3ECACK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:02:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55059 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762115Ab3ECABg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:36 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 19/31] mm: memory,memlayout: add refresh_memory_blocks() for Dynamic NUMA.
Date: Thu,  2 May 2013 17:00:51 -0700
Message-Id: <1367539263-19999-20-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684B96E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly update the sysfs info when memory blocks move between nodes
due to a Dynamic NUMA reconfiguration.
---
 drivers/base/memory.c  | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/memory.h |  5 +++++
 mm/memlayout.c         |  3 +++
 3 files changed, 47 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 90e387c..db1b034 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/kobject.h>
+#include <linux/memlayout.h>
 #include <linux/memory.h>
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
@@ -700,6 +701,44 @@ bool is_memblock_offlined(struct memory_block *mem)
 	return mem->state == MEM_OFFLINE;
 }
 
+#if defined(CONFIG_DYNAMIC_NUMA)
+int refresh_memory_blocks(struct memlayout *ml)
+{
+	struct subsys_dev_iter iter;
+	struct device *dev;
+	/* XXX: 4th arg is (struct device_type *), can we spec one? */
+	mutex_lock(&mem_sysfs_mutex);
+	subsys_dev_iter_init(&iter, &memory_subsys, NULL, NULL);
+
+	while ((dev = subsys_dev_iter_next(&iter))) {
+		struct memory_block *mem_blk = container_of(dev, struct memory_block, dev);
+		unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
+		unsigned long end_pfn   = section_nr_to_pfn(mem_blk->end_section_nr + 1);
+		struct rangemap_entry *rme = memlayout_pfn_to_rme_higher(ml, start_pfn);
+		unsigned long pfn = start_pfn;
+
+		if (!rme || !rme_bounds_pfn(rme, pfn)) {
+			pr_warn("memory block %s {sec %lx-%lx}, {pfn %05lx-%05lx} is not bounded by the memlayout %pK\n",
+					dev_name(dev),
+					mem_blk->start_section_nr, mem_blk->end_section_nr,
+					start_pfn, end_pfn, ml);
+			continue;
+		}
+
+		unregister_mem_block_under_nodes(mem_blk);
+
+		for (; pfn < end_pfn && rme; rme = rme_next(rme)) {
+			register_mem_block_under_node(mem_blk, rme->nid);
+			pfn = rme->pfn_end + 1;
+		}
+	}
+
+	subsys_dev_iter_exit(&iter);
+	mutex_unlock(&mem_sysfs_mutex);
+	return 0;
+}
+#endif
+
 /*
  * Initialize the sysfs support for memory devices...
  */
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 85c31a8..8f1dc43 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -143,6 +143,11 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
 #endif
 
+#ifdef CONFIG_DYNAMIC_NUMA
+struct memlayout;
+extern int refresh_memory_blocks(struct memlayout *ml);
+#endif
+
 /*
  * 'struct memory_accessor' is a generic interface to provide
  * in-kernel access to persistent memory such as i2c or SPI EEPROMs
diff --git a/mm/memlayout.c b/mm/memlayout.c
index 0a1a602..8b9ba9a 100644
--- a/mm/memlayout.c
+++ b/mm/memlayout.c
@@ -9,6 +9,7 @@
 #include <linux/dnuma.h>
 #include <linux/export.h>
 #include <linux/memblock.h>
+#include <linux/memory.h>
 #include <linux/printk.h>
 #include <linux/rbtree.h>
 #include <linux/rcupdate.h>
@@ -300,6 +301,8 @@ void memlayout_commit(struct memlayout *ml)
 	drain_all_pages();
 	/* All new page allocations now match the memlayout */
 
+	refresh_memory_blocks(ml);
+
 	mutex_unlock(&memlayout_lock);
 }
 
-- 
1.8.2.2

