Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaBMKmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:42:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaBMKmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:42:35 -0500
Date: Thu, 13 Feb 2014 10:42:31 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: swap: Use swapfiles in priority order
Message-ID: <20140213104231.GX6732@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the swapon documentation

	Swap  pages  are  allocated  from  areas  in priority order,
	highest priority first.  For areas with different priorities, a
	higher-priority area is exhausted before using a lower-priority area.

A user reported that the reality is different. When multiple swap files
are enabled and a memory consumer started, the swap files are consumed in
pairs after the highest priority file is exhausted. Early in the lifetime
of the test, swapfile consumptions looks like

Filename                                Type            Size    Used    Priority
/testswap1                              file            100004  100004  8
/testswap2                              file            100004  23764   7
/testswap3                              file            100004  23764   6
/testswap4                              file            100004  0       5
/testswap5                              file            100004  0       4
/testswap6                              file            100004  0       3
/testswap7                              file            100004  0       2
/testswap8                              file            100004  0       1

This patch fixes the swap_list search in get_swap_page to use the swap files
in the correct order. When applied the swap file consumptions looks like

Filename				Type		Size	Used	Priority
/testswap1                              file		100004	100004	8
/testswap2                              file		100004	100004	7
/testswap3                              file		100004	29372	6
/testswap4                              file		100004	0	5
/testswap5                              file		100004	0	4
/testswap6                              file		100004	0	3
/testswap7                              file		100004	0	2
/testswap8                              file		100004	0	1

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4a7f7e6..6d0ac2b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -651,7 +651,7 @@ swp_entry_t get_swap_page(void)
 		goto noswap;
 	atomic_long_dec(&nr_swap_pages);
 
-	for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
+	for (type = swap_list.head; type >= 0 && wrapped < 2; type = next) {
 		hp_index = atomic_xchg(&highest_priority_index, -1);
 		/*
 		 * highest_priority_index records current highest priority swap
