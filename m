Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3CMGdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:33:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52149 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3CMGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:33:11 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-03-51401da3e521
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Anderson <anderson@redhat.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        Vivek Goyal <vgoyal@redhat.com>, Bob Liu <lliubbo@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, kexec@lists.infradead.org,
        Joonsoo Kim <js1304@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 5/8] mm, vmalloc: iterate vmap_area_list in get_vmalloc_info()
Date: Wed, 13 Mar 2013 15:32:57 +0900
Message-Id: <1363156381-2881-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363156381-2881-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1363156381-2881-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <js1304@gmail.com>

This patch is preparing step for removing vmlist entirely.
For above purpose, we change iterating a vmap_list codes to iterating a
vmap_area_list. It is somewhat trivial change, but just one thing
should be noticed.

vmlist is lack of information about some areas in vmalloc address space.
For example, vm_map_ram() allocate area in vmalloc address space,
but it doesn't make a link with vmlist. To provide full information about
vmalloc address space is better idea, so we don't use va->vm and use
vmap_area directly.
This makes get_vmalloc_info() more precise.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 59aa328..aee1f61 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2671,46 +2671,50 @@ module_init(proc_vmalloc_init);
 
 void get_vmalloc_info(struct vmalloc_info *vmi)
 {
-	struct vm_struct *vma;
+	struct vmap_area *va;
 	unsigned long free_area_size;
 	unsigned long prev_end;
 
 	vmi->used = 0;
+	vmi->largest_chunk = 0;
 
-	if (!vmlist) {
-		vmi->largest_chunk = VMALLOC_TOTAL;
-	} else {
-		vmi->largest_chunk = 0;
+	prev_end = VMALLOC_START;
 
-		prev_end = VMALLOC_START;
-
-		read_lock(&vmlist_lock);
+	spin_lock(&vmap_area_lock);
 
-		for (vma = vmlist; vma; vma = vma->next) {
-			unsigned long addr = (unsigned long) vma->addr;
+	if (list_empty(&vmap_area_list)) {
+		vmi->largest_chunk = VMALLOC_TOTAL;
+		goto out;
+	}
 
-			/*
-			 * Some archs keep another range for modules in vmlist
-			 */
-			if (addr < VMALLOC_START)
-				continue;
-			if (addr >= VMALLOC_END)
-				break;
+	list_for_each_entry(va, &vmap_area_list, list) {
+		unsigned long addr = va->va_start;
 
-			vmi->used += vma->size;
+		/*
+		 * Some archs keep another range for modules in vmalloc space
+		 */
+		if (addr < VMALLOC_START)
+			continue;
+		if (addr >= VMALLOC_END)
+			break;
 
-			free_area_size = addr - prev_end;
-			if (vmi->largest_chunk < free_area_size)
-				vmi->largest_chunk = free_area_size;
+		if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
+			continue;
 
-			prev_end = vma->size + addr;
-		}
+		vmi->used += (va->va_end - va->va_start);
 
-		if (VMALLOC_END - prev_end > vmi->largest_chunk)
-			vmi->largest_chunk = VMALLOC_END - prev_end;
+		free_area_size = addr - prev_end;
+		if (vmi->largest_chunk < free_area_size)
+			vmi->largest_chunk = free_area_size;
 
-		read_unlock(&vmlist_lock);
+		prev_end = va->va_end;
 	}
+
+	if (VMALLOC_END - prev_end > vmi->largest_chunk)
+		vmi->largest_chunk = VMALLOC_END - prev_end;
+
+out:
+	spin_unlock(&vmap_area_lock);
 }
 #endif
 
-- 
1.7.9.5

