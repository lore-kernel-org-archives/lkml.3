Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab3HPEFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 00:05:13 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38490 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3HPEFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 00:05:10 -0400
From: Yechen Li <lccycc123@gmail.com>
To: xen-devel@lists.xen.org
Cc: Ian.Campbell@eu.citrix.com, Ian.Jackson@eu.citrix.com,
        konrad.wilk@oracle.com, ufimtseva@gmail.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, dario.faggioli@citrix.com,
        Yechen Li <lccycc123@gmail.com>
Subject: [PATCH] [RFC v2] drivers: xen NUMA-aware balloon driver
Date: Fri, 16 Aug 2013 12:03:46 +0800
Message-Id: <1376625826-11036-1-git-send-email-lccycc123@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,
	This small patch introduce NUMA awaness to xen balloon driver.
	It could be apply to 
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
	as far as I send this email.

	And it's version 2, since the first version is too urgly.

	Full docs could be found under
	xensource/docs/misc/numa-aware-ballooning.markdown
	which belongs to another patch, which contains the patches to
	libxl, and, which is sent together with this one
	in xen-devel. This patch is only for Linux. 

	Please forgive me for the stupid version 1. I have tried to make
	this one a readable patch, so that it could be possible for you
	to review my code, and give me more suggestions :-)

	Also, guest virtual NUMA topology is required for this work.
	it's not something that we have now, but I know that it's been
	working on. I declare some interfaces in this code (which we
	have some kind of a deal on it). Anyway, this code is almost
	working, so I publish it here as an RFC to get some early
	feedback.

	about the code architechure:
	Modification is mainly on linux-kernel/drivers/xen/balloon.c .
	There are several interface functions:
		unsigned long long xen_mnid_to_vnidmask(int mnid);
		int xen_vnid_to_mnid(int vnid);
		int balloon_page_to_vnid(struct page *page);
		struct page* xen_alloc_pages_node(int vnid);
	Now they are marked "todo" for debuging and interface waiting.

	The original increase/decrease reservation function:
		increase_reservation(unsigned long nr_pages),
		decrease_reservation(unsigned long nr_pages, gfp_t gfp)
	now come to :
		__increase_reservation(int vnid, unsigned long nr_pages),
		__decrease_reservation(int vnid, unsigned long nr_pages, gfp_t gfp),
	These two functions used to be designed as a batcher. Since we have
	a best-effort request, add another layer on top of them:
		static struct bp_rt
			increase_reservatin_nodeonly(...)
			decrease_reservatin_nodeonly(...)
	They will use a while loop to call __increase_reservation_node(..)/
				__decrease_reservation_node(..) until it
	couldn't get more pages from this v-node.

	Also, we have to know how many pages are settled in
	__increase_reservation_node() and __decrease_reservation_node(),
	a new return struct type is required.

	The struct bp_rt includes the new return message of balloon, so that
	when comes to uppest level:
		increase_reservation_numa(vnidmask, nodeexact, nr_pages)
		decrease_reservation_numa(vnidmask, nodeexact, nr_pages, gfp)
	balloon	can decide whether it should go on to the next node or not.
	These two function loops the node according to vnidmask. If pages on
	the first v-node does not meet the requirement, go on to the second,
	etc..
	/* XXX:there is still some code dumplicate here. It could be
	   optimized in a later version */

	In the old balloon, when current does not meet target, the balloon
	process runs an infinited loop, reschedule the task until requirement
	meets. But now we may have a danger that we might not get enough pages
	FOREVER if node specified and nodeexact=true. In this case,
		Define NUMA_BALLOON_RETRY_MAX: the maximun balloon_process()
				   reschedule time when nodeexact=true.
	Balloon will exit if nodeexact=true and the retry counter exceed this
	NUMA_BALLOON_RETRY_MAX limitation.

Signed-off-by: Yechen Li <lccycc123@gmail.com>
---
 drivers/xen/balloon.c     | 355 ++++++++++++++++++++++++++++++++++++++++------
 drivers/xen/xen-balloon.c |  20 ++-
 include/xen/balloon.h     |  19 +++
 3 files changed, 351 insertions(+), 43 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 2a2ef97..92f5cd9 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -53,6 +53,8 @@
 #include <linux/memory.h>
 #include <linux/memory_hotplug.h>
 
+#include <linux/numa.h>
+
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
@@ -81,10 +83,26 @@ enum bp_state {
 	BP_EAGAIN,
 	BP_ECANCELED
 };
+/*
+ * balloon increase/decerase return message
+ * donepages: increase/decrease page number the function does
+ *			always initial to 0
+ * state:  bp_state that return to balloon_process()
+ */
+struct bp_rt {
+	unsigned long donepages;
+	enum bp_state state;
+};
+#define DECLARE_BP_RT(bp_rt)			\
+		struct bp_rt bp_rt = {		\
+		.donepages = 0,			\
+		.state = BP_DONE		\
+	}
 
 
 static DEFINE_MUTEX(balloon_mutex);
 
+/*todo: should this balloon_stats change to balloon_stats[MAX_BALLOONNODES]?*/
 struct balloon_stats balloon_stats;
 EXPORT_SYMBOL_GPL(balloon_stats);
 
@@ -92,7 +110,13 @@ EXPORT_SYMBOL_GPL(balloon_stats);
 static xen_pfn_t frame_list[PAGE_SIZE / sizeof(unsigned long)];
 
 /* List of ballooned pages, threaded through the mem_map array. */
-static LIST_HEAD(ballooned_pages);
+/*
+ * this array is index by vnid,
+ * because we need to use alloc_pages_node(xxx)
+ */
+static struct list_head ballooned_pages[MAX_BALLOONNODES];
+/*ballooned_pages_cnt is for debug only*/
+long long ballooned_pages_cnt[MAX_BALLOONNODES];
 
 /* Main work function, always executed in process context. */
 static void balloon_process(struct work_struct *work);
@@ -110,17 +134,87 @@ static void scrub_page(struct page *page)
 #endif
 }
 
+void ballooned_pages_init(void)
+{
+	int i;
+	for (i = 0; i < MAX_BALLOONNODES; i++) {
+		INIT_LIST_HEAD(&ballooned_pages[i]);
+		ballooned_pages_cnt[i] = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(ballooned_pages_init);
+
+/*
+ * XXX:
+ * The four function:
+ *   unsigned long long xen_pnid_to_vnidmask(int pnid)
+ *   int xen_vnid_to_pnid(int vnid)
+ *   int balloon_page_to_vnid(struct page *page)
+ *   struct page *xen_alloc_pages_node(int vnid)
+ * looks strange here, because they are waiting for guest numa topology's
+ * interface and for debuging.
+ */
+/*
+ * XXX: this function returns the vnid mask of pnid
+ * for example: if pnid -> vnid[1], vnid[2]
+ * it should return 2|4 = 6
+ * now it looks like this because of interface waiting
+ */
+unsigned long long xen_pnid_to_vnidmask(int pnid)
+{
+	/*todo:*/
+	unsigned long long rc = 1;
+	return rc<<pnid;
+}
+
+/*
+ * XXX: this function should actually be
+ *   xen_vnid_to_pnidmask(int vnid)
+ *  return the mask of pnid
+ *  nit it's here because of interface waiting and for debug convinent
+ */
+int xen_vnid_to_pnid(int vnid)
+{
+	/*todo:*/
+	return vnid % MAX_BALLOONNODES;
+}
+
+/*
+ * XXX: this function convert page to virtual nodeid
+ * should return page_to_nid(page);
+ * it return the strange value below now for debug before it get the interface.
+ */
+int balloon_page_to_vnid(struct page *page)
+{
+	/*todo:for debug here. should be
+	return page_to_nid(page);*/
+	return ((unsigned long long)page & (1<<13)) ? 0 : 1;
+}
+
+/*
+ * XXX: this function allocate a free page from guest OS's v-node[vnid]
+ * now return some weird value because of interface waiting and for debug
+ */
+struct page *xen_alloc_pages_node(int vnid)
+{
+	/*todo: vnid = 0 for debug:*/
+	vnid = 0;
+	return alloc_pages_node(vnid, GFP_BALLOON, balloon_order);
+}
+
 /* balloon_append: add the given page to the balloon. */
 static void __balloon_append(struct page *page)
 {
+	int vnid = balloon_page_to_vnid(page);
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
+	ballooned_pages_cnt[vnid]++;
 }
 
 static void balloon_append(struct page *page)
@@ -129,19 +223,20 @@ static void balloon_append(struct page *page)
 	adjust_managed_page_count(page, -1);
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
+	ballooned_pages_cnt[vnid]--;
 
 	if (PageHighMem(page))
 		balloon_stats.balloon_high--;
@@ -153,17 +248,27 @@ static struct page *balloon_retrieve(bool prefer_highmem)
 	return page;
 }
 
-static struct page *balloon_first_page(void)
+/* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
+static struct page *balloon_retrieve(bool prefer_highmem)
+{
+	int i;
+	struct page *page = NULL;
+	for (i = 0; i < MAX_BALLOONNODES && !page; i++)
+		page = balloon_retrieve_node(i, prefer_highmem);
+	return page;
+}
+
+static struct page *balloon_first_page(int vnid)
 {
-	if (list_empty(&ballooned_pages))
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
@@ -230,7 +335,8 @@ static enum bp_state reserve_additional_memory(long credit)
 	balloon_hotplug = round_up(balloon_hotplug, PAGES_PER_SECTION);
 	nid = memory_add_physaddr_to_nid(hotplug_start_paddr);
 
-	rc = add_memory(nid, hotplug_start_paddr, balloon_hotplug << PAGE_SHIFT);
+	rc = add_memory(nid, hotplug_start_paddr,
+			balloon_hotplug << PAGE_SHIFT);
 
 	if (rc) {
 		pr_info("%s: add_memory() failed: %i\n", __func__, rc);
@@ -261,7 +367,8 @@ static void xen_online_page(struct page *page)
 	mutex_unlock(&balloon_mutex);
 }
 
-static int xen_memory_notifier(struct notifier_block *nb, unsigned long val, void *v)
+static int xen_memory_notifier(struct notifier_block *nb,
+				unsigned long val, void *v)
 {
 	if (val == MEM_ONLINE)
 		schedule_delayed_work(&balloon_worker, 0);
@@ -301,52 +408,61 @@ static enum bp_state reserve_additional_memory(long credit)
 }
 #endif /* CONFIG_XEN_BALLOON_MEMORY_HOTPLUG */
 
-static enum bp_state increase_reservation(unsigned long nr_pages)
+static struct bp_rt __increase_reservation_nodeonly(int vnid,
+						     unsigned long nr_pages)
 {
-	int rc;
+	long rc;
 	unsigned long  pfn, i;
 	struct page   *page;
+	int pnid = xen_vnid_to_pnid(vnid);
 	struct xen_memory_reservation reservation = {
-		.address_bits = 0,
+		.address_bits = MEMF_node(pnid) | MEMF_exact_node,
 		.extent_order = 0,
-		.domid        = DOMID_SELF
+		.domid	      = DOMID_SELF
 	};
+	DECLARE_BP_RT(bp_rt);
 
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	if (!balloon_stats.balloon_low && !balloon_stats.balloon_high) {
 		nr_pages = min(nr_pages, balloon_stats.balloon_hotplug);
 		balloon_stats.hotplug_pages += nr_pages;
 		balloon_stats.balloon_hotplug -= nr_pages;
-		return BP_DONE;
+		bp_rt.donepages = nr_pages;
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
 
+	if (nr_pages == 0)
+		return bp_rt;
+
 	set_xen_guest_handle(reservation.extent_start, frame_list);
 	reservation.nr_extents = nr_pages;
 	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
-	if (rc <= 0)
-		return BP_EAGAIN;
+	if (rc <= 0) {
+		bp_rt.state = BP_EAGAIN;
+		return bp_rt;
+	}
 
 	for (i = 0; i < rc; i++) {
-		page = balloon_retrieve(false);
+		page = balloon_retrieve_node(vnid, false);
 		BUG_ON(page == NULL);
 
 		pfn = page_to_pfn(page);
 		BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
-		       phys_to_machine_mapping_valid(pfn));
+			   phys_to_machine_mapping_valid(pfn));
 
 		set_phys_to_machine(pfn, frame_list[i]);
 
@@ -368,19 +484,89 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 
 	balloon_stats.current_pages += rc;
 
-	return BP_DONE;
+	bp_rt.donepages = rc;
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
+						  unsigned long nr_pages)
 {
-	enum bp_state state = BP_DONE;
+	unsigned long ori_nr_pages = nr_pages;
+	DECLARE_BP_RT(bp_rt);
+	while (nr_pages > 0) {
+		bp_rt = __increase_reservation_nodeonly(vnid, nr_pages);
+		nr_pages -= bp_rt.donepages;
+		if (bp_rt.donepages == 0 || bp_rt.state != BP_DONE)
+			break;
+	}
+	bp_rt.donepages = ori_nr_pages - nr_pages;
+	return bp_rt;
+}
+
+static struct bp_rt increase_reservation_nodemask(unsigned long long vnidmask,
+						  unsigned long nr_pages)
+{
+	int i;
+	int ori_nr_pages = nr_pages;
+	DECLARE_BP_RT(bp_rt);
+
+	if (vnidmask == 0)
+		return bp_rt;
+
+	for (i = 0; i < MAX_BALLOONNODES; i++) {
+		if (vnidmask & (1<<i)) {
+			bp_rt = increase_reservation_nodeonly(i, nr_pages);
+			nr_pages -= bp_rt.donepages;
+			if (bp_rt.state != BP_DONE)
+				break;
+		}
+	}
+	bp_rt.donepages = ori_nr_pages - nr_pages;
+	return bp_rt;
+}
+
+static struct bp_rt increase_reservation_numa(unsigned long long vnidmask,
+					      bool nodeexact,
+					      unsigned long nr_pages)
+{
+	int ori_nr_pages = nr_pages;
+	DECLARE_BP_RT(bp_rt);
+	bp_rt = increase_reservation_nodemask(vnidmask, nr_pages);
+	nr_pages -= bp_rt.donepages;
+	if (nodeexact == false) {
+		vnidmask = ((unsigned long long)1<<MAX_BALLOONNODES)-1;
+		bp_rt = increase_reservation_nodemask(vnidmask, nr_pages);
+		nr_pages -= bp_rt.donepages;
+	}
+	bp_rt.donepages  = ori_nr_pages - nr_pages;
+	return bp_rt;
+}
+/*
+static enum bp_state increase_reservation(unsigned long nr_pages) {
+	struct bp_rt bp_rt = increase_reservation_numa(0,false,nr_pages);
+	return bp_rt.state;
+}
+*/
+
+static struct bp_rt __decrease_reservation_nodeonly(int vnid,
+						    unsigned long nr_pages,
+						    gfp_t gfp)
+{
+	DECLARE_BP_RT(bp_rt);
 	unsigned long  pfn, i;
 	struct page   *page;
 	int ret;
 	struct xen_memory_reservation reservation = {
 		.address_bits = 0,
 		.extent_order = 0,
-		.domid        = DOMID_SELF
+		.domid	      = DOMID_SELF
 	};
 
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
@@ -388,7 +574,8 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		nr_pages = min(nr_pages, balloon_stats.hotplug_pages);
 		balloon_stats.hotplug_pages -= nr_pages;
 		balloon_stats.balloon_hotplug += nr_pages;
-		return BP_DONE;
+		bp_rt.donepages = nr_pages;
+		return bp_rt;
 	}
 #endif
 
@@ -396,10 +583,10 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		nr_pages = ARRAY_SIZE(frame_list);
 
 	for (i = 0; i < nr_pages; i++) {
-		page = alloc_page(gfp);
+		page = xen_alloc_pages_node(vnid);
 		if (page == NULL) {
 			nr_pages = i;
-			state = BP_EAGAIN;
+			bp_rt.state = BP_EAGAIN;
 			break;
 		}
 
@@ -436,7 +623,73 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 
 	balloon_stats.current_pages -= nr_pages;
 
-	return state;
+	bp_rt.donepages = nr_pages;
+	return bp_rt;
+}
+
+/*
+ * the same reason to increase_reservaton_readonly
+ * run a loop for another batcher if rc > 0
+ */
+static struct bp_rt decrease_reservation_nodeonly(int vnid,
+						  unsigned long nr_pages,
+						  gfp_t gfp)
+{
+	int ori_nr_pages = nr_pages;
+	DECLARE_BP_RT(bp_rt);
+	while (nr_pages > 0) {
+		bp_rt = __decrease_reservation_nodeonly(vnid, nr_pages, gfp);
+		nr_pages -= bp_rt.donepages;
+		if (bp_rt.donepages == 0 || bp_rt.state != BP_DONE)
+			break;
+	}
+	bp_rt.donepages = ori_nr_pages - nr_pages;
+	return bp_rt;
+}
+static struct bp_rt decrease_reservation_nodemask(unsigned long long vnidmask,
+						  unsigned long nr_pages,
+						  gfp_t gfp)
+{
+	int i;
+	int ori_nr_pages = nr_pages;
+	DECLARE_BP_RT(bp_rt);
+
+	if (vnidmask == 0)
+		return bp_rt;
+
+	for (i = 0; i < MAX_BALLOONNODES; i++) {
+		if (vnidmask & (1<<i)) {
+			bp_rt = decrease_reservation_nodeonly(i, nr_pages, gfp);
+			nr_pages -= bp_rt.donepages;
+			if (bp_rt.state != BP_DONE)
+				break;
+		}
+	}
+	bp_rt.donepages = ori_nr_pages - nr_pages;
+	return bp_rt;
+}
+
+static struct bp_rt decrease_reservation_numa(unsigned long long vnidmask,
+					      bool nodeexact,
+					      unsigned long nr_pages, gfp_t gfp)
+{
+	unsigned long ori_nr_pages = nr_pages;
+	DECLARE_BP_RT(bp_rt);
+	bp_rt = decrease_reservation_nodemask(vnidmask, nr_pages, gfp);
+	nr_pages -= bp_rt.donepages;
+	if (nodeexact == false) {
+		vnidmask = ((unsigned long long)1<<MAX_BALLOONNODES)-1;
+		bp_rt = decrease_reservation_nodemask(vnidmask, nr_pages, gfp);
+		nr_pages -= bp_rt.donepages;
+	}
+	bp_rt.donepages = ori_nr_pages - nr_pages;
+	return bp_rt;
+}
+
+static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
+{
+	struct bp_rt bp_rt = decrease_reservation_numa(0, false, nr_pages, gfp);
+	return bp_rt.state;
 }
 
 /*
@@ -449,6 +702,11 @@ static void balloon_process(struct work_struct *work)
 {
 	enum bp_state state = BP_DONE;
 	long credit;
+	int pnid = balloon_stats.numa_pnid;
+	bool nodeexact = balloon_stats.numa_nodeexact;
+	int counter = 0;
+	int i;
+	unsigned long long vnidmask = xen_pnid_to_vnidmask(pnid);
 
 	mutex_lock(&balloon_mutex);
 
@@ -457,13 +715,16 @@ static void balloon_process(struct work_struct *work)
 
 		if (credit > 0) {
 			if (balloon_is_inflated())
-				state = increase_reservation(credit);
+				state = increase_reservation_numa(vnidmask,
+						nodeexact, credit).state;
 			else
 				state = reserve_additional_memory(credit);
 		}
 
-		if (credit < 0)
-			state = decrease_reservation(-credit, GFP_BALLOON);
+		if (credit < 0) {
+			state = decrease_reservation_numa(vnidmask, nodeexact,
+						-credit, GFP_BALLOON).state;
+		}
 
 		state = update_schedule(state);
 
@@ -471,22 +732,36 @@ static void balloon_process(struct work_struct *work)
 		if (need_resched())
 			schedule();
 #endif
+		counter++;
+		if (nodeexact && counter >= NUMA_BALLOON_RETRY_MAX)
+			break;
+
 	} while (credit && state == BP_DONE);
 
 	/* Schedule more work if there is some still to be done. */
 	if (state == BP_EAGAIN)
-		schedule_delayed_work(&balloon_worker, balloon_stats.schedule_delay * HZ);
+		schedule_delayed_work(&balloon_worker,
+				       balloon_stats.schedule_delay * HZ);
 
 	mutex_unlock(&balloon_mutex);
 }
 
-/* Resets the Xen limit, sets new target, and kicks off processing. */
-void balloon_set_new_target(unsigned long target)
+void balloon_set_new_target_numa(unsigned long target, int pnid, bool nodeexact)
 {
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.target_pages = target;
+	balloon_stats.numa_pnid = pnid;
+	balloon_stats.numa_nodeexact = nodeexact;
+
 	schedule_delayed_work(&balloon_worker, 0);
 }
+EXPORT_SYMBOL_GPL(balloon_set_new_target_numa);
+
+/* Resets the Xen limit, sets new target, and kicks off processing. */
+void balloon_set_new_target(unsigned long target)
+{
+	balloon_set_new_target_numa(target, -1, false);
+}
 EXPORT_SYMBOL_GPL(balloon_set_new_target);
 
 /**
diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index e555845..831cc0f 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -56,6 +56,8 @@ static void watch_target(struct xenbus_watch *watch,
 			 const char **vec, unsigned int len)
 {
 	unsigned long long new_target;
+	int mnid;
+	int focus;
 	int err;
 
 	err = xenbus_scanf(XBT_NIL, "memory", "target", "%llu", &new_target);
@@ -63,11 +65,21 @@ static void watch_target(struct xenbus_watch *watch,
 		/* This is ok (for domain0 at least) - so just return */
 		return;
 	}
+	err = xenbus_scanf(XBT_NIL, "memory", "target_nid", "%d %d",
+				&mnid, &focus);
+	if (err != 2)
+		mnid = -1;
+	/* no numa node specify, set focus = false*/
+	if (mnid == -1) {
+		mnid = 0;
+		focus = false;
+	}
 
 	/* The given memory/target value is in KiB, so it needs converting to
 	 * pages. PAGE_SHIFT converts bytes to pages, hence PAGE_SHIFT - 10.
 	 */
-	balloon_set_new_target(new_target >> (PAGE_SHIFT - 10));
+	balloon_set_new_target_numa(new_target >> (PAGE_SHIFT - 10),
+					mnid, focus);
 }
 static struct xenbus_watch target_watch = {
 	.node = "memory/target",
@@ -99,6 +111,8 @@ static int __init balloon_init(void)
 
 	pr_info("Initialising balloon driver\n");
 
+	ballooned_pages_init();
+
 	register_balloon(&balloon_dev);
 
 	register_xen_selfballooning(&balloon_dev);
@@ -111,8 +125,8 @@ subsys_initcall(balloon_init);
 
 static void balloon_exit(void)
 {
-    /* XXX - release balloon here */
-    return;
+	/* XXX - release balloon here */
+	return;
 }
 
 module_exit(balloon_exit);
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index cc2e1a7..06feb5f 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -3,11 +3,25 @@
  */
 
 #define RETRY_UNLIMITED	0
+#define NUMA_BALLOON_RETRY_MAX 20
+
+#define balloon_order 0
+/*todo: numa support
+xensource/xen/include/xen/mm.h
+#define MEMF_exact_node (1U<<4)
+*/
+/* below is for debug. (0U<<4) should be (1U<<4)*/
+#define MEMF_exact_node (0U<<4)
+#define MEMF_node(n)     ((((n)+1)&0xff)<<8)
+#define MAX_BALLOONNODES 2
 
 struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */
 	unsigned long current_pages;
 	unsigned long target_pages;
+	/* numa support */
+	int numa_pnid;
+	bool numa_nodeexact;
 	/* Number of pages in high- and low-memory balloons. */
 	unsigned long balloon_low;
 	unsigned long balloon_high;
@@ -23,6 +37,11 @@ struct balloon_stats {
 
 extern struct balloon_stats balloon_stats;
 
+void ballooned_pages_init(void);
+
+void balloon_set_new_target_numa(unsigned long target, int mnid,
+					bool nodeexact);
+
 void balloon_set_new_target(unsigned long target);
 
 int alloc_xenballooned_pages(int nr_pages, struct page **pages,
-- 
1.8.1.4

