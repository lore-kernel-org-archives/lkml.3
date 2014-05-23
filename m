Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaEWMN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:13:26 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40569 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaEWMNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:13:24 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Vladimir Cernov <gg.kaspersky@gmail.com>, linux-mm@kvack.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] mm/madvise: fix WILLNEED on SHM/ANON to actually do something
Date: Fri, 23 May 2014 14:12:15 +0200
Message-Id: <1400847135-22291-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, madvise(MADV_WILLNEED) on shmem with swap enabled is a no-op.
Problem is, we use find_get_page() to lookup shmem pages in the given
range. However, what we're actually interested in is swapped-out pages.
Therefore, our current code is a no-op:
    page = find_get_page(mapping, index);
    if (!radix_tree_exceptional_entry(page))
        bail-out;

find_get_page() never returns exceptional entries. Fix this by using
find_get_entry(). This was probably meant to be used right from the
beginning.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 539eeb9..a402f8f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -195,7 +195,7 @@ static void force_shm_swapin_readahead(struct vm_area_struct *vma,
 	for (; start < end; start += PAGE_SIZE) {
 		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-		page = find_get_page(mapping, index);
+		page = find_get_entry(mapping, index);
 		if (!radix_tree_exceptional_entry(page)) {
 			if (page)
 				page_cache_release(page);
-- 
1.9.3

