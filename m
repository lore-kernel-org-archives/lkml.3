Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbaJDAcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:32:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbaJCVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Weston Andros Adamson <dros@primarydata.com>,
        Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 168/357] nfs: fix nonblocking calls to nfs_page_group_lock
Date: Fri,  3 Oct 2014 14:29:14 -0700
Message-Id: <20141003212938.526421447@linuxfoundation.org>
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

commit bc8a309e88a86205fc3e17f06e42a2e56fc6f807 upstream.

nfs_page_group_lock was calling wait_on_bit_lock even when told not to
block. Fix by first trying test_and_set_bit, followed by wait_on_bit_lock
if and only if blocking is allowed.  Return -EAGAIN if nonblocking and the
test_and_set of the bit was already locked.

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Reviewed-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pagelist.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -149,24 +149,29 @@ static int nfs_wait_bit_uninterruptible(
  *
  * this lock must be held if modifying the page group list
  *
- * returns result from wait_on_bit_lock: 0 on success, < 0 on error
+ * return 0 on success, < 0 on error: -EDELAY if nonblocking or the
+ * result from wait_on_bit_lock
+ *
+ * NOTE: calling with nonblock=false should always have set the
+ *       lock bit (see fs/buffer.c and other uses of wait_on_bit_lock
+ *       with TASK_UNINTERRUPTIBLE), so there is no need to check the result.
  */
 int
 nfs_page_group_lock(struct nfs_page *req, bool nonblock)
 {
 	struct nfs_page *head = req->wb_head;
-	int ret;
 
 	WARN_ON_ONCE(head != head->wb_head);
 
-	do {
-		ret = wait_on_bit_lock(&head->wb_flags, PG_HEADLOCK,
-			nfs_wait_bit_uninterruptible,
-			TASK_UNINTERRUPTIBLE);
-	} while (!nonblock && ret != 0);
+	if (!test_and_set_bit(PG_HEADLOCK, &head->wb_flags))
+		return 0;
+
+	if (!nonblock)
+		return wait_on_bit_lock(&head->wb_flags, PG_HEADLOCK,
+				nfs_wait_bit_uninterruptible,
+				TASK_UNINTERRUPTIBLE);
 
-	WARN_ON_ONCE(ret > 0);
-	return ret;
+	return -EAGAIN;
 }
 
 /*


