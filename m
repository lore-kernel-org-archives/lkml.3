Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaGILk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:40:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63125 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaGILgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:36 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-95-53bd2942480a
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 10/21] mm: slab: share virt_to_cache() between
 slab and slub
Date: Wed, 09 Jul 2014 15:30:04 +0400
Message-id: <1404905415-9046-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xy7pOmnuDDd78FLXY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroxz846xFszmq7gxX7yB8Rx3
	FyMnh4SAicTlxlcsELaYxIV769m6GLk4hASWMko8mPCNHcLpY5K4vr+RGaSKTUBP4t+s7Wwg
	toiAgsTm3mesIEXMAs1sEu0dH1hBEsIC8RLPvyxi7GLk4GARUJXYcy8ExOQVcJPYPN0DYpmC
	xLLlM8GqOYHCE6ZfYwYpERJwlZiwQm0CI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GCFR9HUH49JjVocYBTgYlXh4X+zeEyzEmlhWXJl7iFGCg1lJhNdWdG+wEG9KYmVValF+fFFp
	TmrxIUYmDk6pBkYm7lt5fQaLItSX7o2WyTVmjdcTtdDducqdKd/znPgKsdzP3w3T5t0qnzPn
	jsTvd5yH/7ed+GxyfloCw4EFLT+lIxRqJr0LjU6pippQoPB/gv+UOw4fokvUOfreRsb8DGh5
	sSPQwOHIyeMMmr5OM9mrlyrxCMQaPF+o0rlcI0Y9YJbpPE2hrUosxRmJhlrMRcWJAF6aqSyA	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shares virt_to_cache() between slab and slub and
it used in cache_from_obj() now.
Later virt_to_cache() will be kernel address sanitizer also.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slab.c |  6 ------
 mm/slab.h | 10 +++++++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e7763db..fa4f840 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -433,12 +433,6 @@ static inline void set_obj_status(struct page *page, int idx, int val) {}
 static int slab_max_order = SLAB_MAX_ORDER_LO;
 static bool slab_max_order_set __initdata;
 
-static inline struct kmem_cache *virt_to_cache(const void *obj)
-{
-	struct page *page = virt_to_head_page(obj);
-	return page->slab_cache;
-}
-
 static inline void *index_to_obj(struct kmem_cache *cache, struct page *page,
 				 unsigned int idx)
 {
diff --git a/mm/slab.h b/mm/slab.h
index 84c160a..1257ade 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -260,10 +260,15 @@ static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
 }
 #endif
 
+static inline struct kmem_cache *virt_to_cache(const void *obj)
+{
+	struct page *page = virt_to_head_page(obj);
+	return page->slab_cache;
+}
+
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
 	struct kmem_cache *cachep;
-	struct page *page;
 
 	/*
 	 * When kmemcg is not being used, both assignments should return the
@@ -275,8 +280,7 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 	if (!memcg_kmem_enabled() && !unlikely(s->flags & SLAB_DEBUG_FREE))
 		return s;
 
-	page = virt_to_head_page(x);
-	cachep = page->slab_cache;
+	cachep = virt_to_cache(x);
 	if (slab_equal_or_root(cachep, s))
 		return cachep;
 
-- 
1.8.5.5

