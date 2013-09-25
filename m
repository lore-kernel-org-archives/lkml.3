Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3IYBDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:03:10 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41694 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab3IYBDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:03:03 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v7 2/4] mm/vmalloc: fix show vmap_area information race with vmap_area tear down
Date: Wed, 25 Sep 2013 09:02:42 +0800
Message-Id: <1380070964-12975-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1380070964-12975-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1380070964-12975-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-9574-0000-0000-000009C9028F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 *v4 -> v5: return directly for !VM_VM_AREA case and remove (VM_LAZY_FREE | VM_LAZY_FREEING) check
 *v5 -> v6: add KOSAKI's ack

There is a race window between vmap_area tear down and show vmap_area information.

	A                                                B

remove_vm_area
spin_lock(&vmap_area_lock);
va->vm = NULL;
va->flags &= ~VM_VM_AREA;
spin_unlock(&vmap_area_lock);
						spin_lock(&vmap_area_lock);
						if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEZING))
							return 0;
						if (!(va->flags & VM_VM_AREA)) {
							seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
								(void *)va->va_start, (void *)va->va_end,
								va->va_end - va->va_start);
							return 0;
						}
free_unmap_vmap_area(va);
	flush_cache_vunmap
	free_unmap_vmap_area_noflush
		unmap_vmap_area
		free_vmap_area_noflush
			va->flags |= VM_LAZY_FREE

The assumption !VM_VM_AREA represents vm_map_ram allocation is introduced by
commit: d4033afd(mm, vmalloc: iterate vmap_area_list, instead of vmlist, in
vmallocinfo()). However, !VM_VM_AREA also represents vmap_area is being tear
down in race window mentioned above. This patch fix it by don't dump any
information for !VM_VM_AREA case and also remove (VM_LAZY_FREE | VM_LAZY_FREEING)
check since they are not possible for !VM_VM_AREA case.

Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f75c2aa..7647e69 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2578,15 +2578,12 @@ static int s_show(struct seq_file *m, void *p)
 	struct vmap_area *va = p;
 	struct vm_struct *v;
 
-	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
-		return 0;
-
-	if (!(va->flags & VM_VM_AREA)) {
-		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
-			(void *)va->va_start, (void *)va->va_end,
-					va->va_end - va->va_start);
+	/*
+	 * s_show can encounter race with remove_vm_area, !VM_VM_AREA on
+	 * behalf of vmap area is being tear down or vm_map_ram allocation.
+	 */
+	if (!(va->flags & VM_VM_AREA))
 		return 0;
-	}
 
 	v = va->vm;
 
-- 
1.7.5.4

