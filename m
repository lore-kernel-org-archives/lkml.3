Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaEIPSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:18:35 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50177 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaEIPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:18:33 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, riel@redhat.com,
        mhocko@suse.cz, aarcange@redhat.com, hanpt@linux.vnet.ibm.com,
        mgorman@suse.de, oleg@redhat.com, cldu@marvell.com, fabf@skynet.be,
        sasha.levin@oracle.com, zhangyanfei@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] mm: use a irq-safe __mod_zone_page_state in mlocked_vma_newpage()
Date: Fri,  9 May 2014 23:17:48 +0800
Message-Id: <1399648668-17420-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mlocked_vma_newpage() is only called in fault path by
page_add_new_anon_rmap(), which is called on a *new* page.
And such page is initially only visible via the pagetables, and the
pte is locked while calling page_add_new_anon_rmap(), so we could use
a irq-safe version of __mod_zone_page_state() here.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 07b6736..69079b1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -196,7 +196,7 @@ static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 		return 0;
 
 	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
+		__mod_zone_page_state(page_zone(page), NR_MLOCK,
 				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
-- 
2.0.0-rc1

