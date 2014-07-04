Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbaGDWPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:15:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760275AbaGDWPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        hujianyang <hujianyang@huawei.com>,
        Laurence Withers <lwithers@guralp.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 3.15 17/66] UBIFS: fix an mmap and fsync race condition
Date: Fri,  4 Jul 2014 15:14:16 -0700
Message-Id: <20140704221423.615890751@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1525,8 +1525,7 @@ static int ubifs_vm_page_mkwrite(struct
 	}
 
 	wait_for_stable_page(page);
-	unlock_page(page);
-	return 0;
+	return VM_FAULT_LOCKED;
 
 out_unlock:
 	unlock_page(page);


