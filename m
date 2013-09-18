Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3IRAaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:30:12 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:58934 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3IRAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:30:10 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v6 1/2] mm/vmalloc: fix show vmap_area information race with vmap_area tear down 
Date: Wed, 18 Sep 2013 08:30:01 +0800
Message-Id: <1379464202-21104-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091800-8878-0000-0000-000008E1AFE2
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
 mm/vmalloc.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5368b17..9b75028 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2582,16 +2582,13 @@ static int s_show(struct seq_file *m, void *p)
 {
 	struct vmap_area *va = p;
 	struct vm_struct *v;
-
-	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
-		return 0;
-
-	if (!(va->flags & VM_VM_AREA)) {
-		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
-			(void *)va->va_start, (void *)va->va_end,
-					va->va_end - va->va_start);
+
+	/*
+	 * s_show can encounter race with remove_vm_area, !VM_VM_AREA on
+	 * behalf of vmap area is being tear down or vm_map_ram allocation.
+	 */
+	if (!(va->flags & VM_VM_AREA))
 		return 0;
-	}
 
 	v = va->vm;
 
-- 
1.8.1.2

