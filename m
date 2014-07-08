Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbaGHTY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:24:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54192 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755713AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Laurence Withers" <lwithers@guralp.com>,
        "hujianyang" <hujianyang@huawei.com>,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.758430333@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 004/125] UBIFS: fix an mmap and fsync race condition
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1522,8 +1522,7 @@ static int ubifs_vm_page_mkwrite(struct
 			ubifs_release_dirty_inode_budget(c, ui);
 	}
 
-	unlock_page(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 
 out_unlock:
 	unlock_page(page);

