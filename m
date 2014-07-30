Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaG3CNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:13:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbaG3BtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 10/10] mm: kmemleak: avoid false negatives on vmalloced objects
Date: Tue, 29 Jul 2014 18:48:41 -0700
Message-Id: <20140730014808.078846511@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014807.477761030@linuxfoundation.org>
References: <20140730014807.477761030@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

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
[hq: Backported to 3.4: Adjust context]
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/kmemleak.c |    4 +++-
 mm/vmalloc.c  |   14 ++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -750,7 +750,9 @@ static void add_scan_area(unsigned long
 	}
 
 	spin_lock_irqsave(&object->lock, flags);
-	if (ptr + size > object->pointer + object->size) {
+	if (size == SIZE_MAX) {
+		size = object->pointer + object->size - ptr;
+	} else if (ptr + size > object->pointer + object->size) {
 		kmemleak_warn("Scan area larger than object 0x%08lx\n", ptr);
 		dump_object_info(object);
 		kmem_cache_free(scan_area_cache, area);
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -349,6 +349,12 @@ static struct vmap_area *alloc_vmap_area
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
@@ -1669,11 +1675,11 @@ void *__vmalloc_node_range(unsigned long
 	insert_vmalloc_vmlist(area);
 
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
 


