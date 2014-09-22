Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIVINs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:13:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:63435 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750961AbaIVINp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:13:45 -0400
X-IronPort-AV: E=Sophos;i="5.04,570,1406563200"; 
   d="scan'208";a="36267606"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>, Francesco Fusco <ffusco@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Mark Salter <msalter@redhat.com>
Subject: [PATCH] lib: remove prio_heap
Date: Mon, 22 Sep 2014 16:14:35 +0800
Message-ID: <1411373687-11873-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prio_heap was unused since 889ed9ceaa97 ("cgroup: remove css_scan_tasks()"),
it should be compiled-out for shrinking the binary kernel size which can be
done via introducing CONFIG_PRIO_HEAD or via removing the code.

But we can simply recover the code from the git quickly when needed,
so it would be better to remove it IMO.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/prio_heap.h |   58 -------------------------------------
 lib/Makefile              |    2 +-
 lib/prio_heap.c           |   70 ---------------------------------------------
 3 files changed, 1 insertions(+), 129 deletions(-)
 delete mode 100644 include/linux/prio_heap.h
 delete mode 100644 lib/prio_heap.c

diff --git a/include/linux/prio_heap.h b/include/linux/prio_heap.h
deleted file mode 100644
index 0809435..0000000
--- a/include/linux/prio_heap.h
+++ /dev/null
@@ -1,58 +0,0 @@
-#ifndef _LINUX_PRIO_HEAP_H
-#define _LINUX_PRIO_HEAP_H
-
-/*
- * Simple insertion-only static-sized priority heap containing
- * pointers, based on CLR, chapter 7
- */
-
-#include <linux/gfp.h>
-
-/**
- * struct ptr_heap - simple static-sized priority heap
- * @ptrs - pointer to data area
- * @max - max number of elements that can be stored in @ptrs
- * @size - current number of valid elements in @ptrs (in the range 0..@size-1
- * @gt: comparison operator, which should implement "greater than"
- */
-struct ptr_heap {
-	void **ptrs;
-	int max;
-	int size;
-	int (*gt)(void *, void *);
-};
-
-/**
- * heap_init - initialize an empty heap with a given memory size
- * @heap: the heap structure to be initialized
- * @size: amount of memory to use in bytes
- * @gfp_mask: mask to pass to kmalloc()
- * @gt: comparison operator, which should implement "greater than"
- */
-extern int heap_init(struct ptr_heap *heap, size_t size, gfp_t gfp_mask,
-		     int (*gt)(void *, void *));
-
-/**
- * heap_free - release a heap's storage
- * @heap: the heap structure whose data should be released
- */
-void heap_free(struct ptr_heap *heap);
-
-/**
- * heap_insert - insert a value into the heap and return any overflowed value
- * @heap: the heap to be operated on
- * @p: the pointer to be inserted
- *
- * Attempts to insert the given value into the priority heap. If the
- * heap is full prior to the insertion, then the resulting heap will
- * consist of the smallest @max elements of the original heap and the
- * new element; the greatest element will be removed from the heap and
- * returned. Note that the returned element will be the new element
- * (i.e. no change to the heap) if the new element is greater than all
- * elements currently in the heap.
- */
-extern void *heap_insert(struct ptr_heap *heap, void *p);
-
-
-
-#endif /* _LINUX_PRIO_HEAP_H */
diff --git a/lib/Makefile b/lib/Makefile
index d6b4bc4..eb95e0f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -11,7 +11,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
+	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o
 
diff --git a/lib/prio_heap.c b/lib/prio_heap.c
deleted file mode 100644
index a7af6f8..0000000
--- a/lib/prio_heap.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Simple insertion-only static-sized priority heap containing
- * pointers, based on CLR, chapter 7
- */
-
-#include <linux/slab.h>
-#include <linux/prio_heap.h>
-
-int heap_init(struct ptr_heap *heap, size_t size, gfp_t gfp_mask,
-	      int (*gt)(void *, void *))
-{
-	heap->ptrs = kmalloc(size, gfp_mask);
-	if (!heap->ptrs)
-		return -ENOMEM;
-	heap->size = 0;
-	heap->max = size / sizeof(void *);
-	heap->gt = gt;
-	return 0;
-}
-
-void heap_free(struct ptr_heap *heap)
-{
-	kfree(heap->ptrs);
-}
-
-void *heap_insert(struct ptr_heap *heap, void *p)
-{
-	void *res;
-	void **ptrs = heap->ptrs;
-	int pos;
-
-	if (heap->size < heap->max) {
-		/* Heap insertion */
-		pos = heap->size++;
-		while (pos > 0 && heap->gt(p, ptrs[(pos-1)/2])) {
-			ptrs[pos] = ptrs[(pos-1)/2];
-			pos = (pos-1)/2;
-		}
-		ptrs[pos] = p;
-		return NULL;
-	}
-
-	/* The heap is full, so something will have to be dropped */
-
-	/* If the new pointer is greater than the current max, drop it */
-	if (heap->gt(p, ptrs[0]))
-		return p;
-
-	/* Replace the current max and heapify */
-	res = ptrs[0];
-	ptrs[0] = p;
-	pos = 0;
-
-	while (1) {
-		int left = 2 * pos + 1;
-		int right = 2 * pos + 2;
-		int largest = pos;
-		if (left < heap->size && heap->gt(ptrs[left], p))
-			largest = left;
-		if (right < heap->size && heap->gt(ptrs[right], ptrs[largest]))
-			largest = right;
-		if (largest == pos)
-			break;
-		/* Push p down the heap one level and bump one up */
-		ptrs[pos] = ptrs[largest];
-		ptrs[largest] = p;
-		pos = largest;
-	}
-	return res;
-}
-- 
1.7.4.4

