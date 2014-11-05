Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaKEPMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:12:33 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26080 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaKEPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:12:32 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-f0-545a3e5daf43
Content-transfer-encoding: 8BIT
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] mm: slub: fix format mismatches in slab_err() callers
Date: Wed, 05 Nov 2014 18:12:21 +0300
Message-id: <1415200341-9619-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xK7qxdlEhBls2aFls+/WIzWLO+jVs
	Fte/vWG0WNndzGZxedccNot7a/6zWrR9/gcklmxkcuDwWLCp1GPTqk42j02fJrF7dL29wuRx
	YsZvFo8nV6YzefRtWcXo8XmTXABHFJdNSmpOZllqkb5dAlfGj94r7AVbBCte3V7D2MC4lK+L
	kZNDQsBEomtZNxuELSZx4d56IJuLQ0hgKaPEhnmz2UESvAKCEj8m32PpYuTgYBaQlzhyKRsk
	zCygLjFp3iJmiPo+JomXz5+zgCTYBPQk/s3aDjZUREBWYurf8ywQDV8ZJY7ckAexhQXcJNa2
	dTKCzGQRUJVofVgPscpVYueP36wgYQkBOYmt67wnMPLNQnLELIQjZiE5YgEj8ypG0dTS5ILi
	pPRcQ73ixNzi0rx0veT83E2MkKD+soNx8TGrQ4wCHIxKPLweTZEhQqyJZcWVuYcYJTiYlUR4
	r1lGhQjxpiRWVqUW5ccXleakFh9iZOLglGpgdNd37M+/raG0xCtgh09w4Km9Sh+Slu+ROWe+
	LdJF4swcgYbZHefXPW0/cd7dseGJ0uwsvR6L+Lec8TXSOzZ+vuN96ZJShWOc0s/5X/5kbrda
	uqwgzu9y859Pk4I5O4SEvb54VKULCb7dEhtSeT0qsdNYY3nkPW5u37b5p5fufX3o+F7dGL13
	SizFGYmGWsxFxYkA0r+GaUgCAAA=
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

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 80c170e..850a94a 100644
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
@@ -902,7 +902,7 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 
 	if (page->objects != max_objects) {
 		slab_err(s, page, "Wrong number of objects. Found %d but "
-			"should be %d", page->objects, max_objects);
+			"should be %ld", page->objects, max_objects);
 		page->objects = max_objects;
 		slab_fix(s, "Number of objects adjusted.");
 	}
-- 
2.1.3

