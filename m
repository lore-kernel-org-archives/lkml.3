Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaLCAnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:43:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLCAmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:42:50 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/2] mm: fadvise: Document the fadvise(FADV_DONTNEED) behaviour for partial pages
Date: Wed,  3 Dec 2014 00:42:46 +0000
Message-Id: <1417567367-9298-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417567367-9298-1-git-send-email-mgorman@suse.de>
References: <1417567367-9298-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A random seek IO benchmark appeared to regress because of a change to
readahead but the real problem was the benchmark. To ensure the IO request
accesssed disk, it used fadvise(FADV_DONTNEED) on a block boundary (512K)
but the hint is ignored by the kernel. This is correct but not necessarily
obvious behaviour.  As much as I dislike comment patches, the explanation
for this behaviour predates current git history. Clarify why it behaves
like this in case someone "fixes" fadvise or readahead for the wrong reasons.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/fadvise.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 3bcfd81d..c908c72 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -117,7 +117,11 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 			__filemap_fdatawrite_range(mapping, offset, endbyte,
 						   WB_SYNC_NONE);
 
-		/* First and last FULL page! */
+		/*
+		 * First and last FULL page! Partial pages are deliberately
+		 * preserved on the expectation that it is better to preserve
+		 * needed memory than to discard unneeded memory.
+		 */
 		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
 		end_index = (endbyte >> PAGE_CACHE_SHIFT);
 
-- 
2.1.2

