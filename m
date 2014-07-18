Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965978AbaGRNcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:32:11 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17811 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161054AbaGRNPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hujianyang <hujianyang@huawei.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/170] UBIFS: fix an mmap and fsync race condition
Date: Fri, 18 Jul 2014 14:10:26 +0200
Message-Id: <9724ace0cc02e44fa5247a5924aefd24f7c1a72c.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hujianyang <hujianyang@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 691a7c6f28ac90cccd0dbcf81348ea90b211bdd0 upstream.

There is a race condition in UBIFS:

Thread A (mmap)                        Thread B (fsync)

->__do_fault                           ->write_cache_pages
   -> ubifs_vm_page_mkwrite
       -> budget_space
       -> lock_page
       -> release/convert_page_budget
       -> SetPagePrivate
       -> TestSetPageDirty
       -> unlock_page
                                       -> lock_page
                                           -> TestClearPageDirty
                                           -> ubifs_writepage
                                               -> do_writepage
                                                   -> release_budget
                                                   -> ClearPagePrivate
                                                   -> unlock_page
   -> !(ret & VM_FAULT_LOCKED)
   -> lock_page
   -> set_page_dirty
       -> ubifs_set_page_dirty
           -> TestSetPageDirty (set page dirty without budgeting)
   -> unlock_page

This leads to situation where we have a diry page but no budget allocated for
this page, so further write-back may fail with -ENOSPC.

In this fix we return from page_mkwrite without performing unlock_page. We
return VM_FAULT_LOCKED instead. After doing this, the race above will not
happen.

Signed-off-by: hujianyang <hujianyang@huawei.com>
Tested-by: Laurence Withers <lwithers@guralp.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ubifs/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 123c79b7261e..b56eb6275744 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1525,8 +1525,7 @@ static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma,
 	}
 
 	wait_for_stable_page(page);
-	unlock_page(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 
 out_unlock:
 	unlock_page(page);
-- 
2.0.0

