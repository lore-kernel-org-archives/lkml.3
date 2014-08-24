Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaHXVga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 17:36:30 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59436 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaHXVg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 17:36:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm: remove noisy remainder of the scan_unevictable interface
Date: Sun, 24 Aug 2014 17:36:22 -0400
Message-Id: <1408916182-20880-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The deprecation warnings for the scan_unevictable interface triggers
by scripts doing `sysctl -a | grep something else'.  This is annoying
and not helpful.

The interface has been defunct since 264e56d8247e ("mm: disable user
interface to manually rescue unevictable pages"), which was in 2011,
and there haven't been any reports of usecases for it, only reports
that the deprecation warnings are annying.  It's unlikely that anybody
is using this interface specifically at this point, so remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/ABI/stable/sysfs-devices-node |  8 ----
 drivers/base/node.c                         |  3 --
 include/linux/swap.h                        | 16 --------
 kernel/sysctl.c                             |  7 ----
 mm/vmscan.c                                 | 63 -----------------------------
 5 files changed, 97 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index ce259c13c36a..5b2d0f08867c 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -85,14 +85,6 @@ Description:
 		will be compacted. When it completes, memory will be freed
 		into blocks which have as many contiguous pages as possible
 
-What:		/sys/devices/system/node/nodeX/scan_unevictable_pages
-Date:		October 2008
-Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
-Description:
-		When set, it triggers scanning the node's unevictable lists
-		and move any pages that have become evictable onto the respective
-		zone's inactive list. See mm/vmscan.c
-
 What:		/sys/devices/system/node/nodeX/hugepages/hugepages-<size>/
 Date:		December 2009
 Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
diff --git a/drivers/base/node.c b/drivers/base/node.c
index c6d3ae05f1ca..52ed9f64bf9c 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -289,8 +289,6 @@ static int register_node(struct node *node, int num, struct node *parent)
 		device_create_file(&node->dev, &dev_attr_distance);
 		device_create_file(&node->dev, &dev_attr_vmstat);
 
-		scan_unevictable_register_node(node);
-
 		hugetlb_register_node(node);
 
 		compaction_register_node(node);
@@ -314,7 +312,6 @@ void unregister_node(struct node *node)
 	device_remove_file(&node->dev, &dev_attr_distance);
 	device_remove_file(&node->dev, &dev_attr_vmstat);
 
-	scan_unevictable_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
 	device_unregister(&node->dev);
diff --git a/include/linux/swap.h b/include/linux/swap.h
index f94614a2668a..37a585beef5c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -356,22 +356,6 @@ static inline int zone_reclaim(struct zone *z, gfp_t mask, unsigned int order)
 extern int page_evictable(struct page *page);
 extern void check_move_unevictable_pages(struct page **, int nr_pages);
 
-extern unsigned long scan_unevictable_pages;
-extern int scan_unevictable_handler(struct ctl_table *, int,
-					void __user *, size_t *, loff_t *);
-#ifdef CONFIG_NUMA
-extern int scan_unevictable_register_node(struct node *node);
-extern void scan_unevictable_unregister_node(struct node *node);
-#else
-static inline int scan_unevictable_register_node(struct node *node)
-{
-	return 0;
-}
-static inline void scan_unevictable_unregister_node(struct node *node)
-{
-}
-#endif
-
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
 #ifdef CONFIG_MEMCG
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 75875a741b5e..91180987e40e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1460,13 +1460,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
-	{
-		.procname	= "scan_unevictable_pages",
-		.data		= &scan_unevictable_pages,
-		.maxlen		= sizeof(scan_unevictable_pages),
-		.mode		= 0644,
-		.proc_handler	= scan_unevictable_handler,
-	},
 #ifdef CONFIG_MEMORY_FAILURE
 	{
 		.procname	= "memory_failure_early_kill",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f1609423821b..d40b8ce3fb0b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3792,66 +3792,3 @@ void check_move_unevictable_pages(struct page **pages, int nr_pages)
 	}
 }
 #endif /* CONFIG_SHMEM */
-
-static void warn_scan_unevictable_pages(void)
-{
-	printk_once(KERN_WARNING
-		    "%s: The scan_unevictable_pages sysctl/node-interface has been "
-		    "disabled for lack of a legitimate use case.  If you have "
-		    "one, please send an email to linux-mm@kvack.org.\n",
-		    current->comm);
-}
-
-/*
- * scan_unevictable_pages [vm] sysctl handler.  On demand re-scan of
- * all nodes' unevictable lists for evictable pages
- */
-unsigned long scan_unevictable_pages;
-
-int scan_unevictable_handler(struct ctl_table *table, int write,
-			   void __user *buffer,
-			   size_t *length, loff_t *ppos)
-{
-	warn_scan_unevictable_pages();
-	proc_doulongvec_minmax(table, write, buffer, length, ppos);
-	scan_unevictable_pages = 0;
-	return 0;
-}
-
-#ifdef CONFIG_NUMA
-/*
- * per node 'scan_unevictable_pages' attribute.  On demand re-scan of
- * a specified node's per zone unevictable lists for evictable pages.
- */
-
-static ssize_t read_scan_unevictable_node(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	warn_scan_unevictable_pages();
-	return sprintf(buf, "0\n");	/* always zero; should fit... */
-}
-
-static ssize_t write_scan_unevictable_node(struct device *dev,
-					   struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	warn_scan_unevictable_pages();
-	return 1;
-}
-
-
-static DEVICE_ATTR(scan_unevictable_pages, S_IRUGO | S_IWUSR,
-			read_scan_unevictable_node,
-			write_scan_unevictable_node);
-
-int scan_unevictable_register_node(struct node *node)
-{
-	return device_create_file(&node->dev, &dev_attr_scan_unevictable_pages);
-}
-
-void scan_unevictable_unregister_node(struct node *node)
-{
-	device_remove_file(&node->dev, &dev_attr_scan_unevictable_pages);
-}
-#endif
-- 
2.0.4

