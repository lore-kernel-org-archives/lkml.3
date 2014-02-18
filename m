Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaBRWqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaBRWqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xishi Qiu <qiuxishi@huawei.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 3.10 26/26] mm: fix process accidentally killed by mce because of huge page migration
Date: Tue, 18 Feb 2014 14:47:22 -0800
Message-Id: <20140218224531.147324861@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xishi Qiu <qiuxishi@huawei.com>

Based on c8721bbbdd36382de51cd6b7a56322e0acca2414 upstream, but only the
bugfix portion pulled out.

Hi Naoya or Greg,

We found a bug in 3.10.x.
The problem is that we accidentally have a hwpoisoned hugepage in free
hugepage list. It could happend in the the following scenario:

        process A                           process B

  migrate_huge_page
  put_page (old hugepage)
    linked to free hugepage list
                                     hugetlb_fault
                                       hugetlb_no_page
                                         alloc_huge_page
                                           dequeue_huge_page_vma
                                             dequeue_huge_page_node
                                               (steal hwpoisoned hugepage)
  set_page_hwpoison_huge_page
  dequeue_hwpoisoned_huge_page
    (fail to dequeue)

I tested this bug, one process keeps allocating huge page, and I 
use sysfs interface to soft offline a huge page, then received:
"MCE: Killing UCP:2717 due to hardware memory corruption fault at 8200034"

Upstream kernel is free from this bug because of these two commits:

f15bdfa802bfa5eb6b4b5a241b97ec9fa1204a35
mm/memory-failure.c: fix memory leak in successful soft offlining

c8721bbbdd36382de51cd6b7a56322e0acca2414
mm: memory-hotplug: enable memory hotplug to handle hugepage

The first one, although the problem is about memory leak, this patch
moves unset_migratetype_isolate(), which is important to avoid the race.
The latter is not a bug fix and it's too big, so I rewrite a small one.

The following patch can fix this bug.(please apply f15bdfa802bf first)

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -21,6 +21,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/page-isolation.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -517,9 +518,15 @@ static struct page *dequeue_huge_page_no
 {
 	struct page *page;
 
-	if (list_empty(&h->hugepage_freelists[nid]))
+	list_for_each_entry(page, &h->hugepage_freelists[nid], lru)
+		if (!is_migrate_isolate_page(page))
+			break;
+	/*
+	 * if 'non-isolated free hugepage' not found on the list,
+	 * the allocation fails.
+	 */
+	if (&h->hugepage_freelists[nid] == &page->lru)
 		return NULL;
-	page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
 	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
 	h->free_huge_pages--;


