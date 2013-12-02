Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab3LBVfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:35:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3LBTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:06:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.4 20/60] IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()
Date: Mon,  2 Dec 2013 11:06:01 -0800
Message-Id: <20131202190334.689769891@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 4adcf7fb6783e354aab38824d803fa8c4f8e8a27 upstream.

ipath_user_sdma_queue_pkts() gets called with mmap_sem held for
writing.  Except for get_user_pages() deep down in
ipath_user_sdma_pin_pages() we don't seem to need mmap_sem at all.

Even more interestingly the function ipath_user_sdma_queue_pkts() (and
also ipath_user_sdma_coalesce() called somewhat later) call
copy_from_user() which can hit a page fault and we deadlock on trying
to get mmap_sem when handling that fault.  So just make
ipath_user_sdma_pin_pages() use get_user_pages_fast() and leave
mmap_sem locking for mm.

This deadlock has actually been observed in the wild when the node
is under memory pressure.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
[ Merged in fix for call to get_user_pages_fast from Tetsuo Handa
  <penguin-kernel@I-love.SAKURA.ne.jp>.  - Roland ]
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -280,9 +280,7 @@ static int ipath_user_sdma_pin_pages(con
 	int j;
 	int ret;
 
-	ret = get_user_pages(current, current->mm, addr,
-			     npages, 0, 1, pages, NULL);
-
+	ret = get_user_pages_fast(addr, npages, 0, pages);
 	if (ret != npages) {
 		int i;
 
@@ -811,10 +809,7 @@ int ipath_user_sdma_writev(struct ipath_
 	while (dim) {
 		const int mxp = 8;
 
-		down_write(&current->mm->mmap_sem);
 		ret = ipath_user_sdma_queue_pkts(dd, pq, &list, iov, dim, mxp);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret <= 0)
 			goto done_unlock;
 		else {


