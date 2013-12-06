Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161558Ab3LFXbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:31:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab3LFXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:52 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 083/152] IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()
Date: Fri,  6 Dec 2013 15:10:07 -0800
Message-Id: <1386371476-2477-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/ipath/ipath_user_sdma.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
index f5cb13b..cc04b7b 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -280,9 +280,7 @@ static int ipath_user_sdma_pin_pages(const struct ipath_devdata *dd,
 	int j;
 	int ret;
 
-	ret = get_user_pages(current, current->mm, addr,
-			     npages, 0, 1, pages, NULL);
-
+	ret = get_user_pages_fast(addr, npages, 0, pages);
 	if (ret != npages) {
 		int i;
 
@@ -811,10 +809,7 @@ int ipath_user_sdma_writev(struct ipath_devdata *dd,
 	while (dim) {
 		const int mxp = 8;
 
-		down_write(&current->mm->mmap_sem);
 		ret = ipath_user_sdma_queue_pkts(dd, pq, &list, iov, dim, mxp);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret <= 0)
 			goto done_unlock;
 		else {
-- 
1.8.3.2

