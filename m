Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbbAUQxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:53:23 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41010 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbbAUQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:34 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ac-54bfd8b8f9fc
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH v9 13/17] mm: vmalloc: add flag preventing guard hole allocation
Date: Wed, 21 Jan 2015 19:51:41 +0300
Message-id: <1421859105-25253-14-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xq7o7buwPMTi2Xdxi269HbBa/985k
	tZizfg2bxZFr39ktrn97w2jx6eUDRovnDx+yW0x42MZusbK7mc1i+7O3TBYrOx+wWlzeNYfN
	4t6a/6wWi4/cZrZ492wys8WPDY9ZHQQ85u/8yOixc9Zddo8Fm0o9Fu95yeSxaVUnm8emT5PY
	PbreXmHyODHjN4vHkyvTmTw+Pr3F4tG3ZRWjx+dNcgE8UVw2Kak5mWWpRfp2CVwZ916EF5wX
	qJh99SNTA+NO3i5GTg4JAROJ1T+mMkLYYhIX7q1n62Lk4hASWMoocWXGR0YIp49J4krXH3aQ
	KjYBPYl/s7azgdgiAgoSm3ufsYIUMQusYJH4cm0F2ChhgQCJyZc6WUFsFgFVic2/l4I18Aq4
	S3Qfe8IGsU5OYuOdFWA1nEDxmecnMkFsa2KU+HxkO9sERt4FjAyrGEVTS5MLipPSc430ihNz
	i0vz0vWS83M3MULC/usOxqXHrA4xCnAwKvHwSvjsDxFiTSwrrsw9xCjBwawkwjv/OlCINyWx
	siq1KD++qDQntfgQIxMHp1QD4ywzmfIH24+U11g+vL49dHdT/tXQs3dZ3X6pNi10X9b165eL
	to5R6EXWyd3MvoJnRQ6t+HBQI9J+QfSJnK7LmUrrtFtii3I5cs4ZOtfE/Zio+u+7yCr/32rn
	Q6RbBS2ZXkaUu9r037q40vrPJu/jP59dEUrPj+7O9xQqK65Oe3/IYlZsrJ+XEktxRqKhFnNR
	cSIAlSwlylkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For instrumenting global variables KASan will shadow memory
backing memory for modules. So on module loading we will need
to allocate shadow memory and map it at exact virtual address.
__vmalloc_node_range() seems like the best fit for that purpose,
except it puts a guard hole after allocated area.

Add a new vm_struct flag 'VM_NO_GUARD' indicating that vm area
doesn't have a guard hole.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/vmalloc.h | 9 +++++++--
 mm/vmalloc.c            | 6 ++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index b87696f..1526fe7 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -16,6 +16,7 @@ struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 #define VM_USERMAP		0x00000008	/* suitable for remap_vmalloc_range */
 #define VM_VPAGES		0x00000010	/* buffer for pages was vmalloc'ed */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
+#define VM_NO_GUARD		0x00000040      /* don't add guard page */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
@@ -96,8 +97,12 @@ void vmalloc_sync_all(void);
 
 static inline size_t get_vm_area_size(const struct vm_struct *area)
 {
-	/* return actual size without guard page */
-	return area->size - PAGE_SIZE;
+	if (!(area->flags & VM_NO_GUARD))
+		/* return actual size without guard page */
+		return area->size - PAGE_SIZE;
+	else
+		return area->size;
+
 }
 
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 39c3388..2e74e99 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1324,10 +1324,8 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 	if (unlikely(!area))
 		return NULL;
 
-	/*
-	 * We always allocate a guard page.
-	 */
-	size += PAGE_SIZE;
+	if (!(flags & VM_NO_GUARD))
+		size += PAGE_SIZE;
 
 	va = alloc_vmap_area(size, align, start, end, node, gfp_mask);
 	if (IS_ERR(va)) {
-- 
2.2.1

