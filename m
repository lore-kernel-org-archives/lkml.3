Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaEAIq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:46:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbaEAIpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:45:03 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/17] mm: shmem: Avoid atomic operation during shmem_getpage_gfp
Date: Thu,  1 May 2014 09:44:44 +0100
Message-Id: <1398933888-4940-14-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398933888-4940-1-git-send-email-mgorman@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem_getpage_gfp uses an atomic operation to set the SwapBacked field
before it's even added to the LRU or visible. This is unnecessary as what
could it possible race against?  Use an unlocked variant.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/page-flags.h | 1 +
 mm/shmem.c                 | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d1fe1a7..4d4b39a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -208,6 +208,7 @@ PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
+	__SETPAGEFLAG(SwapBacked, swapbacked)
 
 __PAGEFLAG(SlobFree, slob_free)
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 9f70e02..f47fb38 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1132,7 +1132,7 @@ repeat:
 			goto decused;
 		}
 
-		SetPageSwapBacked(page);
+		__SetPageSwapBacked(page);
 		__set_page_locked(page);
 		error = mem_cgroup_charge_file(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
-- 
1.8.4.5

