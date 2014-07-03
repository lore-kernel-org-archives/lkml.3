Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbaGCJVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083AbaGCJVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: hujianyang <hujianyang@huawei.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 018/198] UBIFS: fix an mmap and fsync race condition
Date: Thu,  3 Jul 2014 10:17:41 +0100
Message-Id: <1404379241-8590-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

