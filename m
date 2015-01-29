Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbbA2POa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:14:30 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19495 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbbA2PMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:45 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-39-54ca4d58ef9b
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
Subject: [PATCH v10 13/17] mm: vmalloc: add flag preventing guard hole
 allocation
Date: Thu, 29 Jan 2015 18:11:57 +0300
Message-id: <1422544321-24232-14-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7oRvqdCDB79V7DY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0eL5w4fsFhMetrFbrOxuZrPY/uwtk8XKzgesFpd3zWGz
	uLfmP6vF4iO3mS3ePZvMbPFjw2NWBwGP+Ts/MnrsnHWX3WPBplKPxXteMnlsWtXJ5rHp0yR2
	j663V5g8Tsz4zeLx5Mp0Jo+PT2+xePRtWcXo8XmTXABPFJdNSmpOZllqkb5dAlfGrpt7GQvO
	C1Ss/3SLqYFxJ28XIyeHhICJRPOKvWwQtpjEhXvrgWwuDiGBpYwSex7MZIVw+pgkZlzezgJS
	xSagJ/Fv1nawDhEBBYnNvc/AipgFVrBIfLm2ghEkISwQLHFp8lUwm0VAVaJr1kKwBl4Bd4nX
	e24DNXAArZOTuPAxHiTMCRT+d+8xE8SyJkaJjWfnsU1g5F3AyLCKUTS1NLmgOCk911CvODG3
	uDQvXS85P3cTIyTsv+xgXHzM6hCjAAejEg/vzE0nQ4RYE8uKK3MPMUpwMCuJ8C61PBUixJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgbFLU8/a5sabmLcZdWs8RMyXKOgWhq5eu//u44B7xrHxnbqb
	35R/X5/zL+qfwd0Dh5o+y5puZ5qZf3774wNm6l9Mgz2XxFizdqqp3/4WeeWCaC/XCo5Apd6G
	4u5Lkz8nP9l7uvKopc1/zbWdTWtLjTrmK78RW+i26O5U88atyye1uBblhzV7aCixFGckGmox
	FxUnAgBhpBzGWQIAAA==
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
2.2.2

