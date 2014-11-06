Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaKFIRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:17:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25906 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKFIRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:17:08 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-7d-545b2e81b818
Content-transfer-encoding: 8BIT
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2] mm: slub: fix format mismatches in slab_err() callers
Date: Thu, 06 Nov 2014 11:16:57 +0300
Message-id: <1415261817-5283-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <alpine.DEB.2.10.1411051344490.31575@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1411051344490.31575@chino.kir.corp.google.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xa7qNetEhBs+maVhs+/WIzWLO+jVs
	Fte/vWG0WNndzGZxedccNot7a/6zWrR9/gcklmxkcuDwWLCp1GPTqk42j02fJrF7dL29wuRx
	YsZvFo8nV6YzefRtWcXo8XmTXABHFJdNSmpOZllqkb5dAlfGnN1P2AuuClVsvPiOsYFxFn8X
	IyeHhICJxJx7a5ggbDGJC/fWs3UxcnEICSxllPjXOocZJMErICjxY/I9li5GDg5mAXmJI5ey
	QcLMAuoSk+YtYoao72OSODBxNxtIgk1AT+LfrO1gtoiArMTUv+dZIBq+MkocuSEPYgsLeEoc
	mr0abCaLgKrEn9N2EKtcJfas38wKEpYQkJPYus4bJMwp4CPxrH8OO4gtJOAtMeP2PpYJjAKz
	kBw3C+G4WUiOW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJAq+7GBcfMzqEKMAB6MS
	D+8GzugQIdbEsuLK3EOMEhzMSiK8vdJAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwSD6s+l994
	uU76Qkj+ltAFV9cnX3eUP6Iie6DGxOBg8ysek3/OG59opja9W9257J9+UrHNq0mPY1dkbr4j
	MvHXdrazPTI5/ZWf+k7P+eKR6yIjqmpgmhD4d+b05ib7B9nMq1wPr1/wXzdMwvtS4FRp181x
	07cmRJQeC2R0dXl783COu33VhnwlluKMREMt5qLiRADVBp9tYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding __printf(3, 4) to slab_err exposed following:

mm/slub.c: In function ‘check_slab’:
mm/slub.c:852:4: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘const char *’ [-Wformat=]
    s->name, page->objects, maxobj);
    ^
mm/slub.c:852:4: warning: too many arguments for format [-Wformat-extra-args]
mm/slub.c:857:4: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘const char *’ [-Wformat=]
    s->name, page->inuse, page->objects);
    ^
mm/slub.c:857:4: warning: too many arguments for format [-Wformat-extra-args]

mm/slub.c: In function ‘on_freelist’:
mm/slub.c:905:4: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘long unsigned int’ [-Wformat=]
    "should be %d", page->objects, max_objects);

Fix first two warnings by removing redundant s->name.
Fix the last by changing type of max_object from unsigned long to int.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---

Changes since v1:
  - To fix the last warning change the type of max_objects instead of changing format string (David)
  - Slightly update changelog

 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 80c170e..ed816f8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -849,12 +849,12 @@ static int check_slab(struct kmem_cache *s, struct page *page)
 	maxobj = order_objects(compound_order(page), s->size, s->reserved);
 	if (page->objects > maxobj) {
 		slab_err(s, page, "objects %u > max %u",
-			s->name, page->objects, maxobj);
+			page->objects, maxobj);
 		return 0;
 	}
 	if (page->inuse > page->objects) {
 		slab_err(s, page, "inuse %u > max %u",
-			s->name, page->inuse, page->objects);
+			page->inuse, page->objects);
 		return 0;
 	}
 	/* Slab_pad_check fixes things up after itself */
@@ -871,7 +871,7 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 	int nr = 0;
 	void *fp;
 	void *object = NULL;
-	unsigned long max_objects;
+	int max_objects;
 
 	fp = page->freelist;
 	while (fp && nr <= page->objects) {
-- 
2.1.3

