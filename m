Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaJCRJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 13:09:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaJCRIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 13:08:55 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: [PATCH 11/17] mm: swp_entry_swapcount
Date: Fri,  3 Oct 2014 19:08:01 +0200
Message-Id: <1412356087-16115-12-git-send-email-aarcange@redhat.com>
In-Reply-To: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
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
index 8197452..af9977c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -458,6 +458,7 @@ extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern int swp_entry_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
@@ -559,6 +560,11 @@ static inline int page_swapcount(struct page *page)
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
index 8798b2e..4cc9af6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -874,6 +874,19 @@ int page_swapcount(struct page *page)
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
