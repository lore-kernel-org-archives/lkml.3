Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaG1HuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:50:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51640 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbaG1HuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:50:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to the 3.12 stable tree] mm: kmemleak: avoid false negatives on vmalloc'ed objects
Date: Mon, 28 Jul 2014 09:50:09 +0200
Message-Id: <1406533809-8369-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

commit 7f88f88f83ed609650a01b18572e605ea50cd163 upstream.

Commit 248ac0e1943a ("mm/vmalloc: remove guard page from between vmap
blocks") had the side effect of making vmap_area.va_end member point to
the next vmap_area.va_start.  This was creating an artificial reference
to vmalloc'ed objects and kmemleak was rarely reporting vmalloc() leaks.

This patch marks the vmap_area containing pointers explicitly and
reduces the min ref_count to 2 as vm_struct still contains a reference
to the vmalloc'ed object.  The kmemleak add_scan_area() function has
been improved to allow a SIZE_MAX argument covering the rest of the
object (for simpler calling sites).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/kmemleak.c |  4 +++-
 mm/vmalloc.c  | 14 ++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index e126b0ef9ad2..31f01c5011e5 100644
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
index 107454312d5e..e2be0f802ccf 100644
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
 
-- 
2.0.1

