Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbaJDAcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:32:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbaJCVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Weston Andros Adamson <dros@primarydata.com>,
        Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 167/357] nfs: change nfs_page_group_lock argument
Date: Fri,  3 Oct 2014 14:29:13 -0700
Message-Id: <20141003212938.489409786@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Weston Andros Adamson <dros@primarydata.com>

commit fd2f3a06d30c85a17cf035ebc60c88c2a13a8ece upstream.

Flip the meaning of the second argument from 'wait' to 'nonblock' to
match related functions. Update all five calls to reflect this change.

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Reviewed-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pagelist.c |   11 ++++++-----
 fs/nfs/write.c    |    4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -145,13 +145,14 @@ static int nfs_wait_bit_uninterruptible(
 /*
  * nfs_page_group_lock - lock the head of the page group
  * @req - request in group that is to be locked
+ * @nonblock - if true don't block waiting for lock
  *
  * this lock must be held if modifying the page group list
  *
  * returns result from wait_on_bit_lock: 0 on success, < 0 on error
  */
 int
-nfs_page_group_lock(struct nfs_page *req, bool wait)
+nfs_page_group_lock(struct nfs_page *req, bool nonblock)
 {
 	struct nfs_page *head = req->wb_head;
 	int ret;
@@ -162,7 +163,7 @@ nfs_page_group_lock(struct nfs_page *req
 		ret = wait_on_bit_lock(&head->wb_flags, PG_HEADLOCK,
 			nfs_wait_bit_uninterruptible,
 			TASK_UNINTERRUPTIBLE);
-	} while (wait && ret != 0);
+	} while (!nonblock && ret != 0);
 
 	WARN_ON_ONCE(ret > 0);
 	return ret;
@@ -226,7 +227,7 @@ bool nfs_page_group_sync_on_bit(struct n
 {
 	bool ret;
 
-	nfs_page_group_lock(req, true);
+	nfs_page_group_lock(req, false);
 	ret = nfs_page_group_sync_on_bit_locked(req, bit);
 	nfs_page_group_unlock(req);
 
@@ -869,7 +870,7 @@ static int __nfs_pageio_add_request(stru
 	unsigned int offset, pgbase;
 	int ret;
 
-	ret = nfs_page_group_lock(req, false);
+	ret = nfs_page_group_lock(req, true);
 	if (ret < 0) {
 		desc->pg_error = ret;
 		return 0;
@@ -895,7 +896,7 @@ static int __nfs_pageio_add_request(stru
 			if (desc->pg_recoalesce)
 				return 0;
 			/* retry add_request for this subreq */
-			ret = nfs_page_group_lock(req, false);
+			ret = nfs_page_group_lock(req, true);
 			if (ret < 0) {
 				desc->pg_error = ret;
 				return 0;
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -216,7 +216,7 @@ static bool nfs_page_group_covers_page(s
 	unsigned int pos = 0;
 	unsigned int len = nfs_page_length(req->wb_page);
 
-	nfs_page_group_lock(req, true);
+	nfs_page_group_lock(req, false);
 
 	do {
 		tmp = nfs_page_group_search_locked(req->wb_head, pos);
@@ -454,7 +454,7 @@ try_again:
 	}
 
 	/* lock each request in the page group */
-	ret = nfs_page_group_lock(head, false);
+	ret = nfs_page_group_lock(head, true);
 	if (ret < 0)
 		return ERR_PTR(ret);
 	subreq = head;


