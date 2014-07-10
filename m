Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaGJVxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:53:41 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36315 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaGJVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:53:38 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, linux-mm <linux-mm@kvack.org>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: [PATCH 28/83] mm: Change timing of notification to IOMMUs about a page to be invalidated
Date: Fri, 11 Jul 2014 00:53:26 +0300
Message-Id: <1405029208-6703-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky@amd.com>

This patch changes the location of the mmu_notifier_invalidate_page function
call inside try_to_unmap_one. The mmu_notifier_invalidate_page function
call tells the IOMMU that a pgae should be invalidated.

The location is changed from after releasing the physical page to
before releasing the physical page.

This change should prevent the bug that would occur in the
(rare) case where the GPU attempts to access a page while the CPU
attempts to swap out that page (or discard it if it is not dirty).

Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 mm/rmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 196cd0c..73d4c3d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1231,13 +1231,17 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	} else
 		dec_mm_counter(mm, MM_FILEPAGES);
 
+	pte_unmap_unlock(pte, ptl);
+
+	mmu_notifier_invalidate_page(vma, address, event);
+
 	page_remove_rmap(page);
 	page_cache_release(page);
 
+	return ret;
+
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret != SWAP_FAIL && !(flags & TTU_MUNLOCK))
-		mmu_notifier_invalidate_page(vma, address, event);
 out:
 	return ret;
 
-- 
1.9.1

