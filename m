Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaFFPO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:14:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28770 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaFFPO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:14:27 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5e-5391dad03c9b
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, koct9i@gmail.com,
        Andrey Ryabinin <a.ryabinin@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm: rmap: fix use-after-free in __put_anon_vma
Date: Fri, 06 Jun 2014 19:09:30 +0400
Message-id: <1402067370-5773-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <20140606115620.GS3213@twins.programming.kicks-ass.net>
References: <20140606115620.GS3213@twins.programming.kicks-ass.net>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e/4Fd0LtyYGG7zsUrDY9usRm8Wc9WvY
	LFZ2PmC1uLxrDpvFvTX/WS2O9x5gsliw8RGjxaO+t+wOHB47Z91l99i8Qstj06dJ7B4nZvxm
	8ejbsorR4/MmuQC2KC6blNSczLLUIn27BK6MDT8bWQpWclQcv7iHpYHxI1sXIyeHhICJxNGv
	i5ggbDGJC/fWA8W5OIQEljJKLP60lxnC6WOS+PanBayDTUBP4t+s7WBVIgIdjBJ3V79gB3GY
	BboYJW7e/84IUiUs4CSxfM51FhCbRUBVYsafLcwgNq+Aq8SMzj9Q+xQkli2fyQpicwq4SGx4
	fx8sLiTgLLHh/2zGCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBNuXHYyLj1kd
	YhTgYFTi4V1wdUKwEGtiWXFl7iFGCQ5mJRFetuaJwUK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	5TbvWpL8KUBsruwOrqCnhxYqsE1cvmHq2eIXia/3/r/qZclQ3+7/dMZxprcfLwTc+nWl03u7
	7OK/9102zGgItCh/P9MrLNbAbvOjaUeqL38wvMyh5GWlvGduQKrVY+4lPcl3dj7Ve1CRb3NS
	vn6Z4JbOK9/6yj09g7cdS7f35HdcGNu5W0l6jxJLcUaioRZzUXEiADkxVRUUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working address sanitizer for kernel I've discovered use-after-free
bug in __put_anon_vma.
For the last anon_vma, anon_vma->root freed before child anon_vma.
Later in anon_vma_free(anon_vma) we are referencing to already freed anon_vma->root
to check rwsem.
This patch puts freeing of child anon_vma before freeing of anon_vma->root.

Cc: <stable@vger.kernel.org> # v3.0+
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---

Changes since v1:
 - just made it more simple following Peter's suggestion

 mm/rmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 9c3e773..cb5f70a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1564,10 +1564,10 @@ void __put_anon_vma(struct anon_vma *anon_vma)
 {
 	struct anon_vma *root = anon_vma->root;
 
+	anon_vma_free(anon_vma);
+
 	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
 		anon_vma_free(root);
-
-	anon_vma_free(anon_vma);
 }
 
 static struct anon_vma *rmap_walk_anon_lock(struct page *page,
-- 
1.8.5.5

