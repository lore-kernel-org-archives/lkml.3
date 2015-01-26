Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbbAZMon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:44:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:49210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbbAZMol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:44:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,468,1418112000"; 
   d="scan'208";a="667604763"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] memcg: fix static checker warning
Date: Mon, 26 Jan 2015 14:44:08 +0200
Message-Id: <1422276248-40456-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "mm: remove rest usage of VM_NONLINEAR and pte_file()" from
Jan 17, 2015, leads to the following static checker warning:

        mm/memcontrol.c:4794 mc_handle_file_pte()
        warn: passing uninitialized 'pgoff'

After the patch, the only case when mc_handle_file_pte() called is
pte_none(ptent). The 'if' check is redundant and lead to the warning.
Let's drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cd42f14d138a..a6140c0764f4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4792,8 +4792,7 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 		return NULL;
 
 	mapping = vma->vm_file->f_mapping;
-	if (pte_none(ptent))
-		pgoff = linear_page_index(vma, addr);
+	pgoff = linear_page_index(vma, addr);
 
 	/* page is moved even if it's not RSS of this task(page-faulted). */
 #ifdef CONFIG_SWAP
-- 
2.1.4

