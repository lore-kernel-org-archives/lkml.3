Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaFFLgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:36:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64467 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaFFLgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:36:20 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-06-5391a7b1f693
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dvyukov@google.com,
        koct9i@gmail.com, Andrey Ryabinin <a.ryabinin@samsung.com>,
        v3.0+@samsung.com
Subject: [PATCH] mm: rmap: fix use-after-free in __put_anon_vma
Date: Fri, 06 Jun 2014 15:30:55 +0400
Message-id: <1402054255-4930-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xa7obl08MNnj71tTiYttFNottvx6x
	WcxZv4bNYsLDNnaLlZ0PWC0u75rDZnFvzX9WiwUbHzFaPOp7y+7A6XHlKYfHzll32T0WbCr1
	2PRpErvHiRm/WTz6tqxi9Pi8SS6APYrLJiU1J7MstUjfLoErY969f0wFhzgqPr9dy97A2Mfe
	xcjJISFgIvHm8j8mCFtM4sK99WxdjFwcQgJLGSXOPn4O5fQxSeyfdYMFpIpNQE/i36ztYAkR
	gS5GiR2vF7ODOMwCMxklzny5xdzFyMEhLGAvcfmKIEgDi4CqxO8JW8DW8Qq4Sqx5O4MFYp2C
	xLLlM1knMHIvYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESTF93MC49ZnWIUYCDUYmH
	N+P9hGAh1sSy4srcQ4wSHMxKIrxszRODhXhTEiurUovy44tKc1KLDzEycXBKNTCWsv0wXdvp
	u3Hl4ye3Pnw57ac8f9NU0+hVVpelpmW3LxJKfTJp17o7jxY2Hpklp7mQ8bkGe/J+G4/r5aan
	HD99zOWuzP6UOD2btT7T6vLrF45m/xac+F/rdXaGbecPCcP/rNx3H9lq5q59/CY75OGLxVzX
	/dRta17PSJgm073lfuefur03D7RdUGIpzkg01GIuKk4EAMeWcqYEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working address sanitizer for kernel I've discovered use-after-free
bug in __put_anon_vma.
For the last anon_vma, anon_vma->root freed before child anon_vma.
Later in anon_vma_free(anon_vma) we are referencing to already freed anon_vma->root
to check rwsem.
This patch puts freeing of child anon_vma before freeing of anon_vma->root.

Cc: stable@vger.kernel.org # v3.0+
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/rmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 9c3e773..161bffc7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1564,10 +1564,11 @@ void __put_anon_vma(struct anon_vma *anon_vma)
 {
 	struct anon_vma *root = anon_vma->root;
 
-	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
+	if (root != anon_vma && atomic_dec_and_test(&root->refcount)) {
+		anon_vma_free(anon_vma);
 		anon_vma_free(root);
-
-	anon_vma_free(anon_vma);
+	} else
+		anon_vma_free(anon_vma);
 }
 
 static struct anon_vma *rmap_walk_anon_lock(struct page *page,
-- 
1.8.5.5

