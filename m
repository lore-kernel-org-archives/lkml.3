Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbaGRMHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:07:22 -0400
Received: from 8bytes.org ([81.169.241.247]:47499 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761281AbaGRMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:07:15 -0400
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/6] PM / Hibernate: Add memory_rtree_find_bit function
Date: Fri, 18 Jul 2014 13:57:19 +0200
Message-Id: <1405684643-30234-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405684643-30234-1-git-send-email-joro@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add a function to find a bit in the radix tree for a given
pfn. Also add code to the memory bitmap wrapper functions to
use the radix tree together with the existing memory bitmap
implementation.

On read accesses compare the results of both bitmaps to make
sure the radix tree behaves the same way.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 kernel/power/snapshot.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 3 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d0f11ec..9a3b723 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -721,6 +721,56 @@ static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
 	return 0;
 }
 
+/*
+ *	memory_rtree_find_bit - Find the bit for pfn in the memory
+ *				bitmap
+ *
+ *	Walks the radix tree to find the page which contains the bit for
+ *	pfn and returns the bit position in **addr and *bit_nr.
+ */
+static int memory_rtree_find_bit(struct memory_bitmap *bm, unsigned long pfn,
+				 void **addr, unsigned int *bit_nr)
+{
+	struct mem_zone_bm_rtree *curr, *zone;
+	struct rtree_node *node;
+	int i, block_nr;
+
+	zone = NULL;
+
+	/* Find the right zone */
+	list_for_each_entry(curr, &bm->zones, list) {
+		if (pfn >= curr->start_pfn && pfn < curr->end_pfn) {
+			zone = curr;
+			break;
+		}
+	}
+
+	if (!zone)
+		return -EFAULT;
+
+	/*
+	 * We have a zone. Now walk the radix tree to find the leave
+	 * node for our pfn.
+	 */
+	node      = zone->rtree;
+	block_nr  = (pfn - zone->start_pfn) >> BM_BLOCK_SHIFT;
+
+	for (i = zone->levels; i > 0; i--) {
+		int index;
+
+		index  = block_nr >> ((i - 1) * BM_RTREE_LEVEL_SHIFT);
+		index &= BM_RTREE_LEVEL_MASK;
+		BUG_ON(node->data[index] == 0);
+		node = (struct rtree_node *)node->data[index];
+	}
+
+	/* Set return values */
+	*addr   = node->data;
+	*bit_nr = (pfn - zone->start_pfn) & BM_BLOCK_MASK;
+
+	return 0;
+}
+
 static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
@@ -730,6 +780,10 @@ static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	BUG_ON(error);
 	set_bit(bit, addr);
+
+	error = memory_rtree_find_bit(bm, pfn, &addr, &bit);
+	BUG_ON(error);
+	set_bit(bit, addr);
 }
 
 static int mem_bm_set_bit_check(struct memory_bitmap *bm, unsigned long pfn)
@@ -741,6 +795,13 @@ static int mem_bm_set_bit_check(struct memory_bitmap *bm, unsigned long pfn)
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	if (!error)
 		set_bit(bit, addr);
+	else
+		return error;
+
+	error = memory_rtree_find_bit(bm, pfn, &addr, &bit);
+	if (!error)
+		set_bit(bit, addr);
+
 	return error;
 }
 
@@ -753,25 +814,42 @@ static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	BUG_ON(error);
 	clear_bit(bit, addr);
+
+	error = memory_rtree_find_bit(bm, pfn, &addr, &bit);
+	BUG_ON(error);
+	clear_bit(bit, addr);
 }
 
 static int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
-	int error;
+	int error, error2;
+	int v;
 
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	BUG_ON(error);
-	return test_bit(bit, addr);
+	v = test_bit(bit, addr);
+
+	error2 = memory_rtree_find_bit(bm, pfn, &addr, &bit);
+	BUG_ON(error2);
+
+	WARN_ON_ONCE(v != test_bit(bit, addr));
+
+	return v;
 }
 
 static bool memory_bm_pfn_present(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
+	int present;
+
+	present = !memory_bm_find_bit(bm, pfn, &addr, &bit);
+
+	WARN_ON_ONCE(present != !memory_rtree_find_bit(bm, pfn, &addr, &bit));
 
-	return !memory_bm_find_bit(bm, pfn, &addr, &bit);
+	return present;
 }
 
 /**
-- 
1.9.1

