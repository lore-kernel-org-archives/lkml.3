Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3JARn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:43:56 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52377 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752436Ab3JARny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:43:54 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: kmemleak: Avoid false negatives on vmalloc'ed objects
Date: Tue,  1 Oct 2013 18:43:27 +0100
Message-Id: <1380649407-27101-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 248ac0e1 (mm/vmalloc: remove guard page from between vmap blocks)
had the side effect of making vmap_area.va_end member point to the next
vmap_area.va_start. This was creating an artificial reference to
vmalloc'ed objects and kmemleak was rarely reporting vmalloc() leaks.

This patch marks the vmap_area containing pointers explicitly and
reduces the min ref_count to 2 as vm_struct still contains a reference
to the vmalloc'ed object. The kmemleak add_scan_area() function has been
improved to allow a SIZE_MAX argument covering the rest of the object
(for simpler calling sites).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

It looks like it's been a while since kmemleak's effectiveness on
catching vmalloc leaks was reduced. Let's see if the reports increase
now.

 mm/kmemleak.c |  4 +++-
 mm/vmalloc.c  | 14 ++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8d84859..ecf1f83 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -753,7 +753,9 @@ static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
 	}
 
 	spin_lock_irqsave(&object->lock, flags);
-	if (ptr + size > object->pointer + object->size) {
+	if (size == SIZE_MAX) {
+		size = object->pointer + object->size - ptr;
+	} else if (ptr + size > object->pointer + object->size) {
 		kmemleak_warn("Scan area larger than object 0x%08lx\n", ptr);
 		dump_object_info(object);
 		kmem_cache_free(scan_area_cache, area);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1074543..e2be0f8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -359,6 +359,12 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	if (unlikely(!va))
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * Only scan the relevant parts containing pointers to other objects
+	 * to avoid false negatives.
+	 */
+	kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask & GFP_RECLAIM_MASK);
+
 retry:
 	spin_lock(&vmap_area_lock);
 	/*
@@ -1646,11 +1652,11 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	clear_vm_uninitialized_flag(area);
 
 	/*
-	 * A ref_count = 3 is needed because the vm_struct and vmap_area
-	 * structures allocated in the __get_vm_area_node() function contain
-	 * references to the virtual address of the vmalloc'ed block.
+	 * A ref_count = 2 is needed because vm_struct allocated in
+	 * __get_vm_area_node() contains a reference to the virtual address of
+	 * the vmalloc'ed block.
 	 */
-	kmemleak_alloc(addr, real_size, 3, gfp_mask);
+	kmemleak_alloc(addr, real_size, 2, gfp_mask);
 
 	return addr;
 
