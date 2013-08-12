Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3HLONr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:13:47 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35851 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab3HLONp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:13:45 -0400
From: Yechen Li <lccycc123@gmail.com>
To: xen-devel@lists.xen.org
Cc: linux-kernel@vger.kernel.org, dario.faggioli@citrix.com,
        Yechen Li <lccycc123@gmail.com>
Subject: [PATCH v1][RFC] drivers/xen, balloon driver numa support in kernel
Date: Mon, 12 Aug 2013 22:13:32 +0800
Message-Id: <1376316812-30346-1-git-send-email-lccycc123@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This small patch adds numa support for balloon driver. Kernel version: 3.11-rc5
  It's just a RFC version, since I'm waiting for the interface of numa topology.
  The balloon driver will read arguments from xenstore: /local/domain/(id)/memory
/target_nid, and settle the memory increase/decrease operation on specified
p-nodeID. 
  To achieve this, I expand the page-list: ballooned_pages to an array:
ballooned_pages[MAX_BALLOONNODES], so that balloon can distinguish pages from 
different node.
  For the guest without numa, this MAX_BALLOONNODES = 1 so that the balloon falls
back to a no-numa version.
  The small functions mark //todo: is the interface to numa topology. Now they
looks stupid because I'm still testing this code. The balloon works well (at
least it seems to) with this small debug interface. Please ignore the more stupid
commemts, I'll remove them in some version later...
  the patch of libxl is here: http://lists.xenproject.org/archives/html/xen-devel/2013-08/msg01157.html
  It's my first time submitting a patch, please point out the problems so that
I could work better in future, thanks very much!
  

---
 drivers/xen/balloon.c     | 358 ++++++++++++++++++++++++++++++++++++++++------
 drivers/xen/xen-balloon.c |  21 ++-
 include/xen/balloon.h     |  17 +++
 3 files changed, 345 insertions(+), 51 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 2a2ef97..09ca1eb 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -36,8 +36,6 @@
  * IN THE SOFTWARE.
  */
 
-#define pr_fmt(fmt) "xen:" KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
@@ -53,6 +51,9 @@
 #include <linux/memory.h>
 #include <linux/memory_hotplug.h>
 
+//lcc:
+#include <linux/numa.h>
+
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
@@ -81,18 +82,43 @@ enum bp_state {
 	BP_EAGAIN,
 	BP_ECANCELED
 };
+struct bp_rt{
+    unsigned long donepages;
+    enum bp_state state;
+};
+#define DECLARE_BP_RT(bp_rt)     \
+    struct bp_rt bp_rt = {       \
+        .donepages = 0,          \
+        .state = BP_DONE        \
+    }
 
 
 static DEFINE_MUTEX(balloon_mutex);
 
+//lcc todo: should this balloon_stats change to balloon_stats[MAX_BALLOONNODES]?
 struct balloon_stats balloon_stats;
 EXPORT_SYMBOL_GPL(balloon_stats);
 
 /* We increase/decrease in batches which fit in a page */
 static xen_pfn_t frame_list[PAGE_SIZE / sizeof(unsigned long)];
 
+#ifdef CONFIG_HIGHMEM
+#define inc_totalhigh_pages() (totalhigh_pages++)
+#define dec_totalhigh_pages() (totalhigh_pages--)
+#else
+#define inc_totalhigh_pages() do {} while (0)
+#define dec_totalhigh_pages() do {} while (0)
+#endif
+
 /* List of ballooned pages, threaded through the mem_map array. */
-static LIST_HEAD(ballooned_pages);
+//static LIST_HEAD(ballooned_pages);
+/*
+ * lcc:
+ * this array is index by vnid,
+ * because we need to use alloc_pages_node(xxx)
+ */
+static struct list_head ballooned_pages[MAX_BALLOONNODES];
+long long ballooned_pages_cnt[MAX_BALLOONNODES];
 
 /* Main work function, always executed in process context. */
 static void balloon_process(struct work_struct *work);
@@ -110,60 +136,115 @@ static void scrub_page(struct page *page)
 #endif
 }
 
+void ballooned_pages_init(void)
+{
+    int i;
+    for (i = 0; i<MAX_BALLOONNODES; i++){
+        INIT_LIST_HEAD(&ballooned_pages[i]);
+        ballooned_pages_cnt[i] = 0;
+    }
+}
+EXPORT_SYMBOL_GPL(ballooned_pages_init);
+
+unsigned long long xen_mnid_to_vnidmask(int mnid)
+{
+    //todo:
+    unsigned long long rc = 1;
+    return rc<<mnid;
+}
+
+int xen_vnid_to_mnid(int vnid)
+{
+    //todo:
+    return vnid % MAX_BALLOONNODES;
+}
+
+int balloon_page_to_vnid(struct page *page)
+{
+    //todo:
+    //return page_to_nid(page);
+    return ((unsigned long long)page & (1<<13))?0:1;
+}
+
+struct page* xen_alloc_pages_node(int vnid)
+{
+    //todo: vnid = 0 is for debug:
+    vnid = 0;
+    return alloc_pages_node(vnid, GFP_BALLOON, balloon_order);
+}
+
 /* balloon_append: add the given page to the balloon. */
 static void __balloon_append(struct page *page)
 {
+    //lcc:notice that this nid is of domU, not of Xen!
+    int vnid = balloon_page_to_vnid(page);
 	/* Lowmem is re-populated first, so highmem pages go at list tail. */
 	if (PageHighMem(page)) {
-		list_add_tail(&page->lru, &ballooned_pages);
+		list_add_tail(&page->lru, &ballooned_pages[vnid]);
 		balloon_stats.balloon_high++;
 	} else {
-		list_add(&page->lru, &ballooned_pages);
+		list_add(&page->lru, &ballooned_pages[vnid]);
 		balloon_stats.balloon_low++;
 	}
+    ballooned_pages_cnt[vnid]++;
 }
 
 static void balloon_append(struct page *page)
 {
 	__balloon_append(page);
-	adjust_managed_page_count(page, -1);
+	if (PageHighMem(page))
+		dec_totalhigh_pages();
+	totalram_pages--;
 }
 
-/* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
-static struct page *balloon_retrieve(bool prefer_highmem)
+/* balloon_retrieve_node: rescue a page from virtual node vnid */
+static struct page *balloon_retrieve_node(int vnid, bool prefer_highmem)
 {
 	struct page *page;
 
-	if (list_empty(&ballooned_pages))
+	if (list_empty(&(ballooned_pages[vnid])))
 		return NULL;
 
 	if (prefer_highmem)
-		page = list_entry(ballooned_pages.prev, struct page, lru);
+		page = list_entry(ballooned_pages[vnid].prev, struct page, lru);
 	else
-		page = list_entry(ballooned_pages.next, struct page, lru);
+		page = list_entry(ballooned_pages[vnid].next, struct page, lru);
 	list_del(&page->lru);
+    ballooned_pages_cnt[vnid]--;
 
-	if (PageHighMem(page))
+	if (PageHighMem(page)) {
 		balloon_stats.balloon_high--;
-	else
+		inc_totalhigh_pages();
+	} else
 		balloon_stats.balloon_low--;
 
-	adjust_managed_page_count(page, 1);
+	totalram_pages++;
 
 	return page;
 }
 
-static struct page *balloon_first_page(void)
+/* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
+static struct page *balloon_retrieve(bool prefer_highmem)
 {
-	if (list_empty(&ballooned_pages))
+    int i;
+    struct page *page = NULL;
+    for (i = 0; i<MAX_BALLOONNODES && !page; i++)
+        page = balloon_retrieve_node(i, prefer_highmem);
+
+    return page;
+}
+
+static struct page *balloon_first_page(int vnid)
+{
+	if (list_empty(&ballooned_pages[vnid]))
 		return NULL;
-	return list_entry(ballooned_pages.next, struct page, lru);
+	return list_entry(ballooned_pages[vnid].next, struct page, lru);
 }
 
-static struct page *balloon_next_page(struct page *page)
+static struct page *balloon_next_page(int vnid, struct page *page)
 {
 	struct list_head *next = page->lru.next;
-	if (next == &ballooned_pages)
+	if (next == &ballooned_pages[vnid])
 		return NULL;
 	return list_entry(next, struct page, lru);
 }
@@ -233,7 +314,7 @@ static enum bp_state reserve_additional_memory(long credit)
 	rc = add_memory(nid, hotplug_start_paddr, balloon_hotplug << PAGE_SHIFT);
 
 	if (rc) {
-		pr_info("%s: add_memory() failed: %i\n", __func__, rc);
+		pr_info("xen_balloon: %s: add_memory() failed: %i\n", __func__, rc);
 		return BP_EAGAIN;
 	}
 
@@ -301,47 +382,60 @@ static enum bp_state reserve_additional_memory(long credit)
 }
 #endif /* CONFIG_XEN_BALLOON_MEMORY_HOTPLUG */
 
-static enum bp_state increase_reservation(unsigned long nr_pages)
+//lcc: mnid means machine_node_id, differ from vid:virtual_node_id in guest
+/* lcc: but I think this function never called by xen. xen just change
+ * balloon_stats.target_pages, and balloon will autoly call increase_reservation
+ * and decrease_reservation to do the job.
+ */
+static struct bp_rt __increase_reservation_nodeonly(int vnid, unsigned long nr_pages)
 {
-	int rc;
+	long rc;
 	unsigned long  pfn, i;
 	struct page   *page;
+    //lcc: debug, below 0 should be mnid
+    int mnid = xen_vnid_to_mnid(vnid);
 	struct xen_memory_reservation reservation = {
-		.address_bits = 0,
+		.address_bits = MEMF_node(mnid) | MEMF_exact_node,
 		.extent_order = 0,
 		.domid        = DOMID_SELF
 	};
-
+    DECLARE_BP_RT(bp_rt);
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	if (!balloon_stats.balloon_low && !balloon_stats.balloon_high) {
 		nr_pages = min(nr_pages, balloon_stats.balloon_hotplug);
 		balloon_stats.hotplug_pages += nr_pages;
 		balloon_stats.balloon_hotplug -= nr_pages;
-		return BP_DONE;
+        bp_rt.donepages = nr_pages;
+		return bp_rt;
 	}
 #endif
 
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
-	page = balloon_first_page();
+	page = balloon_first_page(vnid);
 	for (i = 0; i < nr_pages; i++) {
 		if (!page) {
 			nr_pages = i;
 			break;
 		}
 		frame_list[i] = page_to_pfn(page);
-		page = balloon_next_page(page);
+		page = balloon_next_page(vnid, page);
 	}
 
+    if (nr_pages == 0)
+        return bp_rt;
+
 	set_xen_guest_handle(reservation.extent_start, frame_list);
 	reservation.nr_extents = nr_pages;
 	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
-	if (rc <= 0)
-		return BP_EAGAIN;
+	if (rc <= 0){
+        bp_rt.state = BP_EAGAIN;
+        return bp_rt;
+    }
 
 	for (i = 0; i < rc; i++) {
-		page = balloon_retrieve(false);
+		page = balloon_retrieve_node(vnid, false);
 		BUG_ON(page == NULL);
 
 		pfn = page_to_pfn(page);
@@ -363,17 +457,92 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 #endif
 
 		/* Relinquish the page back to the allocator. */
-		__free_reserved_page(page);
+		ClearPageReserved(page);
+		init_page_count(page);
+		__free_page(page);
 	}
 
 	balloon_stats.current_pages += rc;
 
-	return BP_DONE;
+    printk(KERN_ALERT "lcc: __increase rc = %ld\n", rc);
+
+    bp_rt.donepages = rc;
+
+	return bp_rt;
 }
 
-static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
+/*
+ * notice that __increase_reservation_nodeonly is a batcher.
+ * it can only do with length(frame_list[]) pages at a time
+ * so run an loop, while still positive pages return (rc>0)
+ *  go on with another batcher
+ */
+static struct bp_rt increase_reservation_nodeonly(int vnid,
+            unsigned long nr_pages)
 {
-	enum bp_state state = BP_DONE;
+    unsigned long ori_nr_pages = nr_pages;
+    DECLARE_BP_RT(bp_rt);
+    while (nr_pages>0){
+        bp_rt = __increase_reservation_nodeonly(vnid, nr_pages);
+        nr_pages -= bp_rt.donepages;
+        if (bp_rt.donepages == 0 || bp_rt.state != BP_DONE)
+            break;
+    }
+    bp_rt.donepages = ori_nr_pages - nr_pages;
+    printk(KERN_ALERT "lcc: increase nodeonly vnid = %d, donepages = %lu\n",
+                vnid, bp_rt.donepages);
+    return bp_rt;
+}
+
+static struct bp_rt increase_reservation_nodemask(unsigned long long vnidmask,
+            unsigned long nr_pages)
+{
+    int i;
+    int ori_nr_pages = nr_pages;
+    DECLARE_BP_RT(bp_rt);
+
+    if (vnidmask == 0)
+        return bp_rt;
+
+    for (i = 0; i<MAX_BALLOONNODES; i++){
+        if (vnidmask & (1<<i)){
+            bp_rt = increase_reservation_nodeonly(i, nr_pages);
+            nr_pages -= bp_rt.donepages;
+            if (bp_rt.state != BP_DONE){
+                break;
+            }
+        }
+    }
+    bp_rt.donepages = ori_nr_pages - nr_pages;
+    return bp_rt;
+}
+
+static struct bp_rt increase_reservation_numa(unsigned long long vnidmask,
+            bool nodeexact, unsigned long nr_pages)
+{
+    int ori_nr_pages = nr_pages;
+    DECLARE_BP_RT(bp_rt);
+    bp_rt = increase_reservation_nodemask(vnidmask, nr_pages);
+    nr_pages -= bp_rt.donepages;
+    if (nodeexact == false){
+        vnidmask = ((unsigned long long)1<<MAX_BALLOONNODES)-1;
+        bp_rt = increase_reservation_nodemask(vnidmask, nr_pages);
+        nr_pages -= bp_rt.donepages;
+    }
+    bp_rt.donepages  = ori_nr_pages - nr_pages;
+    return bp_rt;
+}
+/*
+static enum bp_state increase_reservation(unsigned long nr_pages){
+    struct bp_rt bp_rt = increase_reservation_numa(0,false,nr_pages);
+    return bp_rt.state;
+}
+*/
+
+static struct bp_rt __decrease_reservation_nodeonly(int vnid,
+            unsigned long nr_pages, gfp_t gfp)
+{
+    DECLARE_BP_RT(bp_rt);
 	unsigned long  pfn, i;
 	struct page   *page;
 	int ret;
@@ -382,13 +551,13 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		.extent_order = 0,
 		.domid        = DOMID_SELF
 	};
-
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	if (balloon_stats.hotplug_pages) {
 		nr_pages = min(nr_pages, balloon_stats.hotplug_pages);
 		balloon_stats.hotplug_pages -= nr_pages;
 		balloon_stats.balloon_hotplug += nr_pages;
-		return BP_DONE;
+        bp_rt.donepages = nr_pages;
+        return bp_rt;
 	}
 #endif
 
@@ -396,10 +565,10 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		nr_pages = ARRAY_SIZE(frame_list);
 
 	for (i = 0; i < nr_pages; i++) {
-		page = alloc_page(gfp);
-		if (page == NULL) {
+        //lcc:
+        if ((page = xen_alloc_pages_node(vnid)) == NULL){
 			nr_pages = i;
-			state = BP_EAGAIN;
+			bp_rt.state = BP_EAGAIN;
 			break;
 		}
 
@@ -436,7 +605,74 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 
 	balloon_stats.current_pages -= nr_pages;
 
-	return state;
+    printk(KERN_ALERT "lcc: __decrease nr_pages = %ld\n", nr_pages);
+
+    bp_rt.donepages = nr_pages;
+    return bp_rt;
+}
+
+/*
+ * the same reason to increase_reservaton_readonly
+ * run a loop for another batcher if rc > 0
+ */
+static struct bp_rt decrease_reservation_nodeonly(int vnid,
+            unsigned long nr_pages, gfp_t gfp)
+{
+    int ori_nr_pages = nr_pages;
+    DECLARE_BP_RT(bp_rt);
+    while (nr_pages>0){
+        bp_rt = __decrease_reservation_nodeonly(vnid, nr_pages, gfp);
+        nr_pages -= bp_rt.donepages;
+        if (bp_rt.donepages == 0 || bp_rt.state != BP_DONE)
+            break;
+    }
+    bp_rt.donepages = ori_nr_pages - nr_pages;
+    printk(KERN_ALERT "lcc: decrease nodeonly vnid = %d, donepages = %lu\n",
+            vnid, bp_rt.donepages);
+    return bp_rt;
+}
+static struct bp_rt decrease_reservation_nodemask(unsigned long long vnidmask,
+            unsigned long nr_pages, gfp_t gfp)
+{
+    int i;
+    int ori_nr_pages = nr_pages;
+    DECLARE_BP_RT(bp_rt);
+
+    if (vnidmask == 0)
+        return bp_rt;
+
+    for (i = 0; i<MAX_BALLOONNODES; i++){
+        if (vnidmask & (1<<i)){
+            bp_rt = decrease_reservation_nodeonly(i, nr_pages, gfp);
+            nr_pages -= bp_rt.donepages;
+            if (bp_rt.state != BP_DONE)
+                break;
+        }
+    }
+    bp_rt.donepages = ori_nr_pages - nr_pages;
+    return bp_rt;
+}
+
+static struct bp_rt decrease_reservation_numa(unsigned long long vnidmask,
+            bool nodeexact, unsigned long nr_pages, gfp_t gfp)
+{
+    unsigned long ori_nr_pages = nr_pages;
+    DECLARE_BP_RT(bp_rt);
+    bp_rt = decrease_reservation_nodemask(vnidmask, nr_pages, gfp);
+    nr_pages -= bp_rt.donepages;
+    if (nodeexact == false){
+        vnidmask = ((unsigned long long)1<<MAX_BALLOONNODES)-1;
+        bp_rt = decrease_reservation_nodemask(vnidmask, nr_pages, gfp);
+        nr_pages -= bp_rt.donepages;
+    }
+    bp_rt.donepages = ori_nr_pages - nr_pages;
+    return bp_rt;
+}
+
+static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
+{
+    struct bp_rt bp_rt = decrease_reservation_numa(0, false, nr_pages, gfp);
+    return bp_rt.state;
 }
 
 /*
@@ -449,6 +685,11 @@ static void balloon_process(struct work_struct *work)
 {
 	enum bp_state state = BP_DONE;
 	long credit;
+    int mnid = balloon_stats.numa_mnid;
+    bool nodeexact = balloon_stats.numa_nodeexact;
+    int counter = 0;
+    int i;
+    unsigned long long vnidmask = xen_mnid_to_vnidmask(mnid);
 
 	mutex_lock(&balloon_mutex);
 
@@ -457,13 +698,25 @@ static void balloon_process(struct work_struct *work)
 
 		if (credit > 0) {
 			if (balloon_is_inflated())
-				state = increase_reservation(credit);
+                state = increase_reservation_numa(vnidmask,
+                            nodeexact, credit).state;
 			else
 				state=reserve_additional_memory(credit);
 		}
 
-		if (credit < 0)
-			state = decrease_reservation(-credit, GFP_BALLOON);
+		if (credit < 0){
+            state = decrease_reservation_numa(vnidmask, nodeexact,
+                        -credit, GFP_BALLOON).state;
+        }
+
+//lcc: debug
+        printk(KERN_ALERT "lcc: balloon nodeexact=%d retry counter = %d\n",
+                nodeexact, counter);
+        for (i = 0; i<MAX_BALLOONNODES; i++){
+            printk(KERN_ALERT "lcc: balloon node %d has %lld pages\n", i, ballooned_pages_cnt[i]);
+        }
+
+//--debug end
 
 		state = update_schedule(state);
 
@@ -471,6 +724,10 @@ static void balloon_process(struct work_struct *work)
 		if (need_resched())
 			schedule();
 #endif
+        counter++;
+        if (nodeexact && counter >= NUMA_BALLOON_RETRY_MAX)
+            break;
+
 	} while (credit && state == BP_DONE);
 
 	/* Schedule more work if there is some still to be done. */
@@ -480,13 +737,22 @@ static void balloon_process(struct work_struct *work)
 	mutex_unlock(&balloon_mutex);
 }
 
-/* Resets the Xen limit, sets new target, and kicks off processing. */
-void balloon_set_new_target(unsigned long target)
+void balloon_set_new_target_numa(unsigned long target, int mnid, bool nodeexact)
 {
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.target_pages = target;
+    balloon_stats.numa_mnid = mnid;
+    balloon_stats.numa_nodeexact = nodeexact;
+    printk(KERN_ALERT "lcc: target = %lu, mnid = %d, nodeexact= %d\n", target, mnid, nodeexact);
 	schedule_delayed_work(&balloon_worker, 0);
 }
+EXPORT_SYMBOL_GPL(balloon_set_new_target_numa);
+
+/* Resets the Xen limit, sets new target, and kicks off processing. */
+void balloon_set_new_target(unsigned long target)
+{
+    balloon_set_new_target_numa(target, -1, false);
+}
 EXPORT_SYMBOL_GPL(balloon_set_new_target);
 
 /**
@@ -580,7 +846,7 @@ static int __init balloon_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	pr_info("Initialising balloon driver\n");
+	pr_info("xen/balloon: Initialising balloon driver.\n");
 
 	balloon_stats.current_pages = xen_pv_domain()
 		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index e555845..28fa728 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -30,8 +30,6 @@
  * IN THE SOFTWARE.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/capability.h>
@@ -56,6 +54,8 @@ static void watch_target(struct xenbus_watch *watch,
 			 const char **vec, unsigned int len)
 {
 	unsigned long long new_target;
+    int mnid;
+    int focus;
 	int err;
 
 	err = xenbus_scanf(XBT_NIL, "memory", "target", "%llu", &new_target);
@@ -63,11 +63,20 @@ static void watch_target(struct xenbus_watch *watch,
 		/* This is ok (for domain0 at least) - so just return */
 		return;
 	}
+	err = xenbus_scanf(XBT_NIL, "memory", "target_nid", "%d %d", &mnid, &focus);
+    if (err != 2){
+        mnid = -1;
+    }
+    /* no numa node specify, set focus = false*/
+    if (mnid == -1){
+        mnid = 0;
+        focus = false;
+    }
 
 	/* The given memory/target value is in KiB, so it needs converting to
 	 * pages. PAGE_SHIFT converts bytes to pages, hence PAGE_SHIFT - 10.
 	 */
-	balloon_set_new_target(new_target >> (PAGE_SHIFT - 10));
+	balloon_set_new_target_numa(new_target >> (PAGE_SHIFT - 10), mnid, focus);
 }
 static struct xenbus_watch target_watch = {
 	.node = "memory/target",
@@ -83,7 +92,7 @@ static int balloon_init_watcher(struct notifier_block *notifier,
 
 	err = register_xenbus_watch(&target_watch);
 	if (err)
-		pr_err("Failed to set balloon watcher\n");
+		printk(KERN_ERR "Failed to set balloon watcher\n");
 
 	return NOTIFY_DONE;
 }
@@ -97,7 +106,9 @@ static int __init balloon_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	pr_info("Initialising balloon driver\n");
+	pr_info("xen-balloon: Initialising balloon driver.\n");
+
+    ballooned_pages_init();
 
 	register_balloon(&balloon_dev);
 
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index cc2e1a7..80dc8d3 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -3,11 +3,23 @@
  */
 
 #define RETRY_UNLIMITED	0
+#define NUMA_BALLOON_RETRY_MAX 20
+
+#define balloon_order 0
+//todo: numa support
+//xensource/xen/include/xen/mm.h
+//#define MEMF_exact_node (1U<<4)
+#define MEMF_exact_node (0U<<4)
+#define  MEMF_node(n)     ((((n)+1)&0xff)<<8)
+#define MAX_BALLOONNODES 2
 
 struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */
 	unsigned long current_pages;
 	unsigned long target_pages;
+    /* numa support */
+    int numa_mnid;
+    bool numa_nodeexact;
 	/* Number of pages in high- and low-memory balloons. */
 	unsigned long balloon_low;
 	unsigned long balloon_high;
@@ -23,6 +35,11 @@ struct balloon_stats {
 
 extern struct balloon_stats balloon_stats;
 
+void ballooned_pages_init(void);
+
+void balloon_set_new_target_numa(unsigned long target, int mnid,
+            bool nodeexact);
+
 void balloon_set_new_target(unsigned long target);
 
 int alloc_xenballooned_pages(int nr_pages, struct page **pages,
-- 
1.8.1.4

