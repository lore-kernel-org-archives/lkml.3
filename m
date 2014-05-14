Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaENHJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:09:34 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35246 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaENHJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:09:33 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        n-horiguchi@ah.jp.nec.com, aneesh.kumar@linux.vnet.ibm.com,
        mhocko@suse.cz, aarcange@redhat.com, steve.capper@linaro.org,
        davidlohr@hp.com, kirill.shutemov@linux.intel.com,
        dave.hansen@linux.intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] mm, hugetlb: use list_for_each_entry in region_xxx
Date: Wed, 14 May 2014 15:09:19 +0800
Message-Id: <1400051359-19942-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7b24d8616be3 ("mm, hugetlb: fix race in region tracking") has
changed to use a per resv_map spinlock to serialize against any
concurrent write operations to the resv_map, thus we don't need
list_for_each_entry_safe to interate over file_region's any more.
Use list_for_each_entry is enough.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/hugetlb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c82290b..26b1464 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -156,7 +156,7 @@ struct file_region {
 static long region_add(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
-	struct file_region *rg, *nrg, *trg;
+	struct file_region *rg, *nrg;
 
 	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
@@ -170,7 +170,7 @@ static long region_add(struct resv_map *resv, long f, long t)
 
 	/* Check for and consume any regions we now overlap with. */
 	nrg = rg;
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
+	list_for_each_entry(rg, rg->link.prev, link) {
 		if (&rg->link == head)
 			break;
 		if (rg->from > t)
@@ -261,7 +261,7 @@ out_nrg:
 static long region_truncate(struct resv_map *resv, long end)
 {
 	struct list_head *head = &resv->regions;
-	struct file_region *rg, *trg;
+	struct file_region *rg;
 	long chg = 0;
 
 	spin_lock(&resv->lock);
@@ -280,7 +280,7 @@ static long region_truncate(struct resv_map *resv, long end)
 	}
 
 	/* Drop any remaining regions. */
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
+	list_for_each_entry(rg, rg->link.prev, link) {
 		if (&rg->link == head)
 			break;
 		chg += rg->to - rg->from;
-- 
2.0.0-rc3

