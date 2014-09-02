Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaIBQdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:33:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56556 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaIBQdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:33:32 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH] mm: fix dump_vma() compilation
Date: Tue,  2 Sep 2014 10:33:16 -0600
Message-Id: <1409675596-19860-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

dump_vma() was written to access fields within vma->vm_page_prot. However,
pgprot_t is sometimes a scalar and sometimes a struct (At least on ARM;
see arch/arm/include/asm/pgtable-2level-types.h). use macro pgprot_val()
to get the value, so the code is immune to these differences.

This fixes:
mm/page_alloc.c: In function ‘dump_vma’:
mm/page_alloc.c:6742:46: error: request for member ‘pgprot’ in something not a structure or union

The cast is required to avoid:

mm/page_alloc.c: In function ‘dump_vma’:
mm/page_alloc.c:6745:3: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 8 has type ‘pgprot_t’ [-Wformat]

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 658f7da49d34 ("mm: introduce dump_vma")
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb510c08073b..1578bc98eb29 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6739,7 +6739,8 @@ void dump_vma(const struct vm_area_struct *vma)
 		"prot %lx anon_vma %p vm_ops %p\n"
 		"pgoff %lx file %p private_data %p\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
-		vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
+		vma->vm_prev, vma->vm_mm,
+		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data);
 	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
-- 
1.9.1

