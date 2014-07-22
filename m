Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbaGVW4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:56:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44387 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaGVWWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: hujianyang <hujianyang@huawei.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 016/116] UBIFS: fix an mmap and fsync race condition
Date: Tue, 22 Jul 2014 15:20:27 -0700
Message-Id: <1406067727-19683-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: hujianyang <hujianyang@huawei.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ubifs/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5bc7781..bc7798d 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1522,8 +1522,7 @@ static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma,
 			ubifs_release_dirty_inode_budget(c, ui);
 	}
 
-	unlock_page(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 
 out_unlock:
 	unlock_page(page);
-- 
1.9.1

