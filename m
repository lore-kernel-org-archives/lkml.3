Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750727AbaBRXWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:22:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaBRWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>, Jan Kara <jack@suse.cz>,
        Roland Dreier <roland@purestorage.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.10 24/26] IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()
Date: Tue, 18 Feb 2014 14:47:20 -0800
Message-Id: <20140218224531.091301078@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
[Backported to 3.10: (Thanks to Ben Huthings)
 - Adjust context
 - Adjust indentation and nr_pages argument in qib_user_sdma_pin_pages()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_user_sdma.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -284,8 +284,7 @@ static int qib_user_sdma_pin_pages(const
 	int j;
 	int ret;
 
-	ret = get_user_pages(current, current->mm, addr,
-			     npages, 0, 1, pages, NULL);
+	ret = get_user_pages_fast(addr, npages, 0, pages);
 
 	if (ret != npages) {
 		int i;
@@ -830,10 +829,7 @@ int qib_user_sdma_writev(struct qib_ctxt
 	while (dim) {
 		const int mxp = 8;
 
-		down_write(&current->mm->mmap_sem);
 		ret = qib_user_sdma_queue_pkts(dd, pq, &list, iov, dim, mxp);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret <= 0)
 			goto done_unlock;
 		else {


