Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaA0KDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:03:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57422 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaA0KDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:03:02 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-7f-52e62ed4b33c
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mguzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/8] mm/swap: add some comments for swap flag/lock usage
Date: Mon, 27 Jan 2014 18:01:31 +0800
Message-id: <000601cf1b46$f5c65430$e152fc90$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRsDv99ROpdB4RjCut/nmCGy0+g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAd0res+CDKbeEreYs34Nm0XXqaks
	FgdnL2GyePqpj8Xi8q45bBb31vxnteh4dprRYtnX9+wWFw7dZ7L4dPQRm8WCjY8YLZ6c+M/i
	wOOxc9Zddo8Fm0o9Nq3qZPPY9GkSu8eJGb9ZPD4+vcXi8X7fVTaPvi2rGD2ufyvy+LxJLoAr
	issmJTUnsyy1SN8ugSvj2a3/zAVrzSrar85ibmB8qdXFyMkhIWAiMXnzCVYIW0ziwr31bCC2
	kMAiRokN23O7GLmA7D+MEvv6NzKCJNgEtCXu9m8EaxAREJFYc2chI0gRs8AvJokL89aygySE
	BTwktm7uBrNZBFQlnn99zAJi8wrYSTztP8gGYQtK/Jh8DyjOAdSsLjFlSi5ImFlAXmLzmrfM
	IGEJoPCjv7oQq/Qk7tx/xghRIi6x8cgtlgmMArOQDJqFMGgWkkGzkHQsYGRZxSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iREcWc+kdzCuarA4xCjAwajEw5tx/WmQEGtiWXFl7iFGCQ5mJRHe
	Cp1nQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYq50v
	LFKYc9b2ZuuaX2dn/9uxKfLH3/UbhSRaPPuc1Y69mdBoI7Rxh8tFjp22nZwehm/nd8RsM/De
	/uXBb5YfJ8KL7/377d/iZH5zjumhe+fK3F63RJ7N6bIO+fi64rWA3PXDx3JehgfLX9e7c9n3
	U+Vk9X0R5TlzmHad47xrvFC1dtpSSS7GLiWW4oxEQy3mouJEAFpsuvOoAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The swap flag/lock usage in swapfile.c is lack of clarity
and readability, some comments are not correct in other files.

Add some comments to try to make it more clear and readable.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 include/linux/blkdev.h |    4 ++-
 mm/rmap.c              |    2 +-
 mm/swapfile.c          |   66 +++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b135d4..fa11ef6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1575,7 +1575,9 @@ struct block_device_operations {
 	void (*unlock_native_capacity) (struct gendisk *);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
-	/* this callback is with swap_lock and sometimes page table lock held */
+	/* this callback is with swap_info_struct.lock
+	 * and sometimes page table lock held
+	 */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
diff --git a/mm/rmap.c b/mm/rmap.c
index d9d4231..1d31ba7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -27,7 +27,7 @@
  *         anon_vma->rwsem
  *           mm->page_table_lock or pte_lock
  *             zone->lru_lock (in mark_page_accessed, isolate_lru_page)
- *             swap_lock (in swap_duplicate, swap_info_get)
+ *             swap_info_struct.lock (in swap_duplicate, swap_info_get)
  *               mmlist_lock (in mmput, drain_mmlist and others)
  *               mapping->private_lock (in __set_page_dirty_buffers)
  *               inode->i_lock (in set_page_dirty's __mark_inode_dirty)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c6c13b05..0a623a9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -45,6 +45,56 @@ static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 static void free_swap_count_continuations(struct swap_info_struct *);
 static sector_t map_swap_entry(swp_entry_t, struct block_device**);
 
+
+/*
+ * swap_info_struct is allocated into swap_info[MAX_SWAPFILES] free slot
+ * and never freed, so we can access it without NULL point reference worry.
+ * swap_list strings all *live* swap_info_structs according to their descending
+ * priority.
+ * To indicate the states of swap_info_struct, we use two of
+ * swap_info_struct.flags bits:
+ *
+ * SWP_USED, !SWP_WRITEOK
+ *        It is used for a swapfile while cann't write to it. Just a momentary
+ *        state. swapon or swapoff call is now happening on it. It will turn to
+ *        one of the following two states after swapon or swapoff call.
+ * SWP_USED, SWP_WRITEOK
+ *        It is ok to write to this swapfile. This is the conventional state
+ *        after a successful swapon.
+ * !SWP_USED, !SWP_WRITEOK
+ *        It is an idle swap_info_struct without a corresponding swapfile.
+ *        This is the state after a successful swapoff
+ * !SWP_USED, SWP_WRITEOK
+ *        It is an impossible state, should never happen
+ *
+ * swapon set SWP_USED firstly to mark swap_info[] slot in-used, then
+ * prepare the swapfile recources, set SWP_WRITEOK until all work finished.
+ * swapoff clear SWP_WRITEOK firstly to prevent new swap_entry allocation
+ * from this swapfile, clear SWP_USED at last when all recources freed.
+ *
+ * There are 3 locks to protect race condition when accessing swap_info_struct
+ * swap_lock
+ *        A global lock which protects the global swap_info[] and swap_list.
+ *        It should be hold firstly when change or iterative access these data,
+ *        such as swapon, swapoff and get_swap_page
+ * swap_info_struct.lock
+ *        Each swap_info_struct has its own lock to protect its data which are
+ *        used when allocate or free swap_entry, such as swap_map, cluster_info
+ *        lowest_bit, highest_bit etc.
+ * swapon_mutex
+ *        A global mutex which protects the race condition among swapon,
+ *        swapoff, swap_start, and frontswap_register_ops.
+ *
+ * What calls for special attention is that to change swap_info_struct.flags
+ * (SWP_USED, SWP_WRITEOK), we should hold swap_lock because we
+ * need to iterate access swap_info[] to locate the target swap_info_struct.
+ * Other bits of swap_info_struct.flags is set once before swapfile enabled,
+ * or is set/clear under swap_info_struct.lock
+ *
+ * Consider of performance, we can read data fields without lock as we never
+ * free swap_info_struct, see individual function comments.
+ *
+ */
 DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
@@ -1053,6 +1103,8 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 /*
  * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
  * corresponding to given index in swap_info (swap type).
+ *
+ * TODO: protect race condition with swapoff
  */
 sector_t swapdev_block(int type, pgoff_t offset)
 {
@@ -1308,10 +1360,10 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	unsigned char count;
 
 	/*
-	 * No need for swap_lock here: we're just looking
+	 * No need for si->lock here: we're just looking
 	 * for whether an entry is in use, not modifying it; false
 	 * hits are okay, and sys_swapoff() has already prevented new
-	 * allocations from this area (while holding swap_lock).
+	 * allocations from this area (while holding si->lock).
 	 */
 	for (;;) {
 		if (++i >= max) {
@@ -1627,6 +1679,8 @@ static sector_t map_swap_entry(swp_entry_t entry, struct block_device **bdev)
 
 /*
  * Returns the page offset into bdev for the specified page's swap entry.
+ * protected by page_lock against try_to_unuse(), don't worry about race
+ * condition with swapoff
  */
 sector_t map_swap_page(struct page *page, struct block_device **bdev)
 {
@@ -1982,6 +2036,12 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 	int type;
 	loff_t l = *pos;
 
+	/*
+	 * Consider of performance and reschedule, don't hold swap_lock
+	 * or swap_info_struct.lock, we only read data fields not write them.
+	 * The only rare race condition is with swapon/swapoff which change
+	 * global swap_info[], use swapon_mutex to mutex this situation.
+	 */
 	mutex_lock(&swapon_mutex);
 
 	if (!l)
@@ -2842,7 +2902,7 @@ outer:
  * into, carry if so, or else fail until a new continuation page is allocated;
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
- * Called while __swap_duplicate() or swap_entry_free() holds swap_lock.
+ * Called while __swap_duplicate() or swap_entry_free() holds si->lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,
 				 pgoff_t offset, unsigned char count)
-- 
1.7.10.4


