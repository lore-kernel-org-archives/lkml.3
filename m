Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbbAOHkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:40:03 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39119 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbbAOHkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:40:01 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 2/2] mm: don't use compound_head() in virt_to_head_page()
Date: Thu, 15 Jan 2015 16:40:33 +0900
Message-Id: <1421307633-24045-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compound_head() is implemented with assumption that there would be
race condition when checking tail flag. This assumption is only true
when we try to access arbitrary positioned struct page.

The situation that virt_to_head_page() is called is different case.
We call virt_to_head_page() only in the range of allocated pages,
so there is no race condition on tail flag. In this case, we don't
need to handle race condition and we can reduce overhead slightly.
This patch implements compound_head_fast() which is similar with
compound_head() except tail flag race handling. And then,
virt_to_head_page() uses this optimized function to improve performance.

I saw 1.8% win in a fast-path loop over kmem_cache_alloc/free,
(14.063 ns -> 13.810 ns) if target object is on tail page.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/mm.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f80d019..0460e2e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -453,6 +453,13 @@ static inline struct page *compound_head(struct page *page)
 	return page;
 }
 
+static inline struct page *compound_head_fast(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		return page->first_page;
+	return page;
+}
+
 /*
  * The atomic page->_mapcount, starts from -1: so that transitions
  * both from it and to it can be tracked, using atomic_inc_and_test
@@ -531,7 +538,8 @@ static inline void get_page(struct page *page)
 static inline struct page *virt_to_head_page(const void *x)
 {
 	struct page *page = virt_to_page(x);
-	return compound_head(page);
+
+	return compound_head_fast(page);
 }
 
 /*
-- 
1.7.9.5

