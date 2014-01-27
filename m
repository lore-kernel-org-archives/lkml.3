Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaA0KIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:08:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59873 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaA0KIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:08:01 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-a1-52e62ffe8538
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 4/8] mm/swap: fix race among frontswap_register_ops,
 swapoff and swapon
Date: Mon, 27 Jan 2014 18:03:04 +0800
Message-id: <000b01cf1b47$a7d31410$f7793c30$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRuoj3nj0pSPMSpm+DuPNK+S4kA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jAd3/+s+CDHY9ZrGYs34Nm0XXqaks
	FgdnL2GyePqpj8Xi8q45bBb31vxntVj29T27xZSHkxgtLhy6z2Tx6egjNosFGx8xWjw58Z/F
	gcdj56y77B4LNpV6bFrVyeax6dMkdo8TM36zeHx8eovF4/2+q2wefVtWMXpc/1bk8XmTXABX
	FJdNSmpOZllqkb5dAlfGzoPH2As61SpmL9nB2MDYLt/FyMkhIWAi0byhhRHCFpO4cG89Wxcj
	F4eQwCJGicev+1ggnD+MEste/GQHqWIT0Ja427+RFcQWERCRWHNnISNIEbPALyaJ/v4DLCAJ
	YYFIia0zjjGD2CwCqhJHD00Ha+YVsJPYuvUAE4QtKPFj8j2geg6gZnWJKVNyQcLMAvISm9e8
	ZQYJSwCFH/3VhVilJzG5+SwLRIm4xMYjt1gmMArMQjJoFsKgWUgGzULSsYCRZRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcGw9k97BuKrB4hCjAAejEg9vxvWnQUKsiWXFlbmHGCU4mJVE
	eCt0ngUJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYNQr
	XtTwInZ+W44p88KaJbf1L7KV/14WfaUy73iNZ4r4uuogbrsZfNeyuVc4qm++d51VOUrr5L3b
	272+ndz1am9zUXud6P7zN/I3+3ozOPM8Oj09tWfhejWLBCNO41UbrIv1WWcrVJne8/Z7+dA4
	da+t8aziwCXHGtZJ/pXYlph7KNzs16x3d5RYijMSDbWYi4oTAWDZPaSpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A potential asynchronous frontswap_register_ops could happen while swapoff
or swapon is happening, there is a need to protect init frontswap type and
prevent NULL point reference to si->frontswap_map.

This patch utilize swapon_mutex to prevent this scenario, see comments of
frontswap_register_ops for detail.

This patch is just for a rare scenario, aim to correct of code.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 include/linux/swapfile.h |    1 +
 mm/frontswap.c           |    7 ++++---
 mm/swapfile.c            |   20 +++++++++++++++-----
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/swapfile.h b/include/linux/swapfile.h
index e282624..1fd5494 100644
--- a/include/linux/swapfile.h
+++ b/include/linux/swapfile.h
@@ -6,6 +6,7 @@
  * want to expose them to the dozens of source files that include swap.h
  */
 extern spinlock_t swap_lock;
+extern struct mutex swapon_mutex;
 extern struct swap_list_t swap_list;
 extern struct swap_info_struct *swap_info[];
 extern int try_to_unuse(unsigned int, bool, unsigned long);
diff --git a/mm/frontswap.c b/mm/frontswap.c
index 1b24bdc..a0c68db 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -88,10 +88,9 @@ static inline void inc_frontswap_invalidates(void) { }
  * bitmap) to create tmem_pools and set the respective poolids. All of that is
  * guarded by us using atomic bit operations on the 'need_init' bitmap.
  *
- * This would not guards us against the user deciding to call swapoff right as
+ * swapon_mutex guards us against the user deciding to call swapoff right as
  * we are calling the backend to initialize (so swapon is in action).
- * Fortunatly for us, the swapon_mutex has been taked by the callee so we are
- * OK. The other scenario where calls to frontswap_store (called via
+ * The other scenario where calls to frontswap_store (called via
  * swap_writepage) is racing with frontswap_invalidate_area (called via
  * swapoff) is again guarded by the swap subsystem.
  *
@@ -120,6 +119,7 @@ struct frontswap_ops *frontswap_register_ops(struct frontswap_ops *ops)
 	struct frontswap_ops *old = frontswap_ops;
 	int i;
 
+	mutex_lock(&swapon_mutex);
 	for (i = 0; i < MAX_SWAPFILES; i++) {
 		if (test_and_clear_bit(i, need_init)) {
 			struct swap_info_struct *sis = swap_info[i];
@@ -129,6 +129,7 @@ struct frontswap_ops *frontswap_register_ops(struct frontswap_ops *ops)
 			ops->init(i);
 		}
 	}
+	mutex_unlock(&swapon_mutex);
 	/*
 	 * We MUST have frontswap_ops set _after_ the frontswap_init's
 	 * have been called. Otherwise __frontswap_store might fail. Hence
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 413c213..5c8a086 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -112,7 +112,7 @@ struct swap_list_t swap_list = {-1, -1};
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
-static DEFINE_MUTEX(swapon_mutex);
+DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
@@ -1954,11 +1954,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
-	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
 	drain_mmlist();
-
 	/* wait for anyone still in scan_swap_map */
 	p->highest_bit = 0;		/* cuts scans short */
 	while (p->flags >= SWP_SCANNING) {
@@ -1968,7 +1966,16 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		spin_lock(&swap_lock);
 		spin_lock(&p->lock);
 	}
+	spin_unlock(&p->lock);
+	spin_unlock(&swap_lock);
 
+	/*
+	 * Now nobody use or allocate swap_entry from this swapfile,
+	 * there is no need to hold swap_lock or p->lock.
+	 * Use swapon_mutex to mutex against swap_start() and a potential
+	 * asynchronous frontswap_register_ops, which will init this swap type
+	 */
+	mutex_lock(&swapon_mutex);
 	swap_file = p->swap_file;
 	old_block_size = p->old_block_size;
 	p->swap_file = NULL;
@@ -1978,11 +1985,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	cluster_info = p->cluster_info;
 	p->cluster_info = NULL;
 	frontswap_map = frontswap_map_get(p);
-	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
 	frontswap_invalidate_area(type);
 	frontswap_map_set(p, NULL);
 	mutex_unlock(&swapon_mutex);
+
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
 	vfree(swap_map);
@@ -2577,6 +2583,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
+	/*
+	 * Use swapon_mutex to mutex against swap_start() and a potential
+	 * asynchronous frontswap_register_ops, which will init this swap type
+	 */
 	mutex_lock(&swapon_mutex);
 	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
-- 
1.7.10.4


