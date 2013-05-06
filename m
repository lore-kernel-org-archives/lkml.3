Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3EFT5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:57:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab3EFT5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:57:20 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
Cc: Isaku Yamahata <yamahata@valinux.co.jp>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 3/4] mm: swp_entry_swapcount
Date: Mon,  6 May 2013 21:57:00 +0200
Message-Id: <1367870221-12676-4-git-send-email-aarcange@redhat.com>
In-Reply-To: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new swapfile method for remap_anon_pages to verify the swap
entry is mapped only in one vma before relocating the swap entry in a
different virtual address. Otherwise if the swap entry is mapped
in multiple vmas, when the page is swapped back in, it could get
mapped in a non linear way in some anon_vma.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/swap.h |  6 ++++++
 mm/swapfile.c        | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1701ce4..0ea2a56 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -389,6 +389,7 @@ extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern int swp_entry_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
@@ -489,6 +490,11 @@ static inline int page_swapcount(struct page *page)
 	return 0;
 }
 
+static inline int swp_entry_swapcount(swp_entry_t entry)
+{
+	return 0;
+}
+
 #define reuse_swap_page(page)	(page_mapcount(page) == 1)
 
 static inline int try_to_free_swap(struct page *page)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d417efd..2772382 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -671,6 +671,19 @@ int page_swapcount(struct page *page)
 	return count;
 }
 
+int swp_entry_swapcount(swp_entry_t entry)
+{
+	int count = 0;
+	struct swap_info_struct *p;
+
+	p = swap_info_get(entry);
+	if (p) {
+		count = swap_count(p->swap_map[swp_offset(entry)]);
+		spin_unlock(&p->lock);
+	}
+	return count;
+}
+
 /*
  * We can write to an anon page without COW if there are no other references
  * to it.  And as a side-effect, free up its swap: because the old content
