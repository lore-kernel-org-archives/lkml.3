Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513AbaKSVdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:33:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbaKSVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:33:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 103/122] mm: madvise: fix MADV_WILLNEED on shmem swapouts
Date: Wed, 19 Nov 2014 12:52:33 -0800
Message-Id: <20141119205212.248079633@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 55231e5c898c5c03c14194001e349f40f59bd300 upstream.

MADV_WILLNEED currently does not read swapped out shmem pages back in.

Commit 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page
cache radix trees") made find_get_page() filter exceptional radix tree
entries but failed to convert all find_get_page() callers that WANT
exceptional entries over to find_get_entry().  One of them is shmem swap
readahead in madvise, which now skips over any swap-out records.

Convert it to find_get_entry().

Fixes: 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache radix trees")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -195,7 +195,7 @@ static void force_shm_swapin_readahead(s
 	for (; start < end; start += PAGE_SIZE) {
 		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-		page = find_get_page(mapping, index);
+		page = find_get_entry(mapping, index);
 		if (!radix_tree_exceptional_entry(page)) {
 			if (page)
 				page_cache_release(page);


