Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaJGXYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:24:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbaJGXUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 05/13] mm, thp: move invariant bug check out of loop in __split_huge_page_map
Date: Tue,  7 Oct 2014 16:20:10 -0700
Message-Id: <20141007231920.083937057@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231919.924479934@linuxfoundation.org>
References: <20141007231919.924479934@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <Waiman.Long@hp.com>

commit f8303c2582b889351e261ff18c4d8eb197a77db2 upstream.

In __split_huge_page_map(), the check for page_mapcount(page) is
invariant within the for loop.  Because of the fact that the macro is
implemented using atomic_read(), the redundant check cannot be optimized
away by the compiler leading to unnecessary read to the page structure.

This patch moves the invariant bug check out of the loop so that it will
be done only once.  On a 3.16-rc1 based kernel, the execution time of a
microbenchmark that broke up 1000 transparent huge pages using munmap()
had an execution time of 38,245us and 38,548us with and without the
patch respectively.  The performance gain is about 1%.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Scott J Norton <scott.norton@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1733,6 +1733,8 @@ static int __split_huge_page_map(struct
 	if (pmd) {
 		pgtable = pgtable_trans_huge_withdraw(mm);
 		pmd_populate(mm, &_pmd, pgtable);
+		if (pmd_write(*pmd))
+			BUG_ON(page_mapcount(page) != 1);
 
 		haddr = address;
 		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1742,8 +1744,6 @@ static int __split_huge_page_map(struct
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 			if (!pmd_write(*pmd))
 				entry = pte_wrprotect(entry);
-			else
-				BUG_ON(page_mapcount(page) != 1);
 			if (!pmd_young(*pmd))
 				entry = pte_mkold(entry);
 			if (pmd_numa(*pmd))


