Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941Ab3DBKMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:12:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab3DBKMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:12:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,392,1363104000"; 
   d="scan'208";a="6989658"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH] x86: numa: mm: kill double initialization for NODE_DATA
Date: Tue, 2 Apr 2013 18:14:35 +0800
Message-Id: <1364897675-15523-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/02 18:11:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/02 18:11:47,
	Serialize complete at 2013/04/02 18:11:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We initialize node_id, node_start_pfn and node_spanned_pages for NODE_DATA in
initmem_init() while the later two members are kept unused and will be
recaculated soon in paging_init(), so remove the useless assignments.

PS. For clarifying calling chains are showed as follows:
setup_arch()
  ...
  initmem_init()
    x86_numa_init()
      numa_init()
        numa_register_memblks()
          setup_node_data()
            NODE_DATA(nid)->node_id = nid;
            NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
            NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
  ...
  x86_init.paging.pagetable_init()
  paging_init()
    ...
    sparse_init()
      sparse_early_usemaps_alloc_node()
        sparse_early_usemaps_alloc_pgdat_section()
          ___alloc_bootmem_node_nopanic()
            __alloc_memory_core_early(pgdat->node_id,...)
    ...
    zone_sizes_init()
      free_area_init_nodes()
        free_area_init_node()
          pgdat->node_id = nid;
          pgdat->node_start_pfn = node_start_pfn;
          calculate_node_totalpages();
            pgdat->node_spanned_pages = totalpages;


Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 72fe01e..efdd08f 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -230,8 +230,6 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	node_data[nid] = nd;
 	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
 	NODE_DATA(nid)->node_id = nid;
-	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
-	NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
 
 	node_set_online(nid);
 }
-- 
1.7.1

