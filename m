Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaE1IAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:00:08 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51698 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE1IAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:00:05 -0400
Subject: [PATCH] mm: dont call mmu_notifier_invalidate_page during munlock
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 11:59:55 +0400
Message-ID: <20140528075955.20300.22758.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_munlock() searches other mlocked vmas, it never unmaps pages.
There is no reason for invalidation because ptes are left unchanged.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 9c3e773..75d9d5c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1225,7 +1225,7 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret != SWAP_FAIL)
+	if (ret != SWAP_FAIL && TTU_ACTION(flags) != TTU_MUNLOCK)
 		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;

