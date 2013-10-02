Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3JBObf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:31:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab3JBO3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:29:00 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH 24/26] ib: Convert qib_user_sdma_pin_pages() to use get_user_pages_unlocked()
Date: Wed,  2 Oct 2013 16:28:05 +0200
Message-Id: <1380724087-13927-25-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function qib_user_sdma_queue_pkts() gets called with mmap_sem held for
writing. Except for get_user_pages() deep down in
qib_user_sdma_pin_pages() we don't seem to need mmap_sem at all.  Even
more interestingly the function qib_user_sdma_queue_pkts() (and also
qib_user_sdma_coalesce() called somewhat later) call copy_from_user()
which can hit a page fault and we deadlock on trying to get mmap_sem
when handling that fault. So just make qib_user_sdma_pin_pages() use
get_user_pages_unlocked() and leave mmap_sem locking for mm.

CC: Mike Marciniszyn <infinipath@intel.com>
CC: Roland Dreier <roland@kernel.org>
CC: linux-rdma@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index d0a0ea0c14d6..c1b6463acd59 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -594,8 +594,8 @@ static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 		else
 			j = npages;
 
-		ret = get_user_pages(current, current->mm, addr,
-			     j, 0, 1, pages, NULL);
+		ret = get_user_pages_unlocked(current, current->mm, addr,
+			 		      j, 0, 1, pages);
 		if (ret != j) {
 			i = 0;
 			j = ret;
@@ -1294,11 +1294,8 @@ int qib_user_sdma_writev(struct qib_ctxtdata *rcd,
 		int mxp = 8;
 		int ndesc = 0;
 
-		down_write(&current->mm->mmap_sem);
 		ret = qib_user_sdma_queue_pkts(dd, ppd, pq,
 				iov, dim, &list, &mxp, &ndesc);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret < 0)
 			goto done_unlock;
 		else {
-- 
1.8.1.4

