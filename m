Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3ICHCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:02:08 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43718 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab3ICHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:02:05 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 4/4] mm/vmalloc: don't assume vmap_area w/o VM_VM_AREA flag is vm_map_ram allocation 
Date: Tue,  3 Sep 2013 15:01:46 +0800
Message-Id: <1378191706-29696-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1378191706-29696-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1378191706-29696-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090306-2000-0000-0000-00000D906762
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race window between vmap_area free and show vmap_area information.

	A                                                B

remove_vm_area
spin_lock(&vmap_area_lock);
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

The assumption is introduced by commit: d4033afd(mm, vmalloc: iterate vmap_area_list, 
instead of vmlist, in vmallocinfo()). This patch fix it by drop the assumption and 
keep not dump vm_map_ram allocation information as the logic before that commit.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5368b17..62b7932 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2586,13 +2586,6 @@ static int s_show(struct seq_file *m, void *p)
 	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
 		return 0;
 
-	if (!(va->flags & VM_VM_AREA)) {
-		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
-			(void *)va->va_start, (void *)va->va_end,
-					va->va_end - va->va_start);
-		return 0;
-	}
-
 	v = va->vm;
 
 	seq_printf(m, "0x%pK-0x%pK %7ld",
-- 
1.8.1.2

