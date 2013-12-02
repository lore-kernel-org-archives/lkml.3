Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3LBUNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:13:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3LBTRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>, Jan Kara <jack@suse.cz>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.12 061/212] IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()
Date: Mon,  2 Dec 2013 11:14:12 -0800
Message-Id: <20131202191254.864082211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 603e7729920e42b3c2f4dbfab9eef4878cb6e8fa upstream.

qib_user_sdma_queue_pkts() gets called with mmap_sem held for
writing. Except for get_user_pages() deep down in
qib_user_sdma_pin_pages() we don't seem to need mmap_sem at all.  Even
more interestingly the function qib_user_sdma_queue_pkts() (and also
qib_user_sdma_coalesce() called somewhat later) call copy_from_user()
which can hit a page fault and we deadlock on trying to get mmap_sem
when handling that fault.

So just make qib_user_sdma_pin_pages() use get_user_pages_fast() and
leave mmap_sem locking for mm.

This deadlock has actually been observed in the wild when the node
is under memory pressure.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_user_sdma.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -594,8 +594,7 @@ static int qib_user_sdma_pin_pages(const
 		else
 			j = npages;
 
-		ret = get_user_pages(current, current->mm, addr,
-			     j, 0, 1, pages, NULL);
+		ret = get_user_pages_fast(addr, j, 0, pages);
 		if (ret != j) {
 			i = 0;
 			j = ret;
@@ -1294,11 +1293,8 @@ int qib_user_sdma_writev(struct qib_ctxt
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


