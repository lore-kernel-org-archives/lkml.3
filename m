Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbaEIQRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:17:01 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53751 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbaEIQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:16:58 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: cl@linux.com, akpm@linux-foundation.org, mhocko@suse.cz,
        hannes@cmpxchg.org, riel@redhat.com, minchan@kernel.org,
        zhangyanfei@cn.fujitsu.com, hanpt@linux.vnet.ibm.com,
        sasha.levin@oracle.com, oleg@redhat.com, fabf@skynet.be,
        mgorman@suse.de, aarcange@redhat.com, cldu@marvell.com,
        nasa4836@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: use a irq-safe __mod_zone_page_state in mlocked_vma_newpage()
Date: Sat, 10 May 2014 00:16:48 +0800
Message-Id: <1399652208-18987-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>You are changing from the irq safe variant to __mod_zone_page_state which
>is *not* irq safe. Its legit to do so since presumably irqs are disabled
>anyways so you do not have to worry about irq safeness of
>__mod_zone_page_state.

>Please update the description. Its a bit confusing right now.

Hi, Christoph, I'm sorry for the misleading phrasing. 
Would be this one OK? Thanks.

--------<8---------
mm: use a light-weight __mod_zone_page_state in mlocked_vma_newpage()

mlocked_vma_newpage() is only called in fault path by
page_add_new_anon_rmap(), which is called on a *new* page.
And such page is initially only visible via the pagetables, and the
pte is locked while calling page_add_new_anon_rmap(), so we need not
use an irq-safe mod_zone_page_state() here, using a light-weight version
__mod_zone_page_state() would be OK.

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

