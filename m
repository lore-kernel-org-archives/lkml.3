Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbaJDAbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:31:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJCVmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Weston Andros Adamson <dros@primarydata.com>,
        Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 171/357] nfs: dont sleep with inode lock in lock_and_join_requests
Date: Fri,  3 Oct 2014 14:29:17 -0700
Message-Id: <20141003212938.615949289@linuxfoundation.org>
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

commit 7c3af975257383ece54b83c0505d3e0656cb7daf upstream.

This handles the 'nonblock=false' case in nfs_lock_and_join_requests.
If the group is already locked and blocking is allowed, drop the inode lock
and wait for the group lock to be cleared before trying it all again.
This should fix warnings found in peterz's tree (sched/wait branch), where
might_sleep() checks are added to wait.[ch].

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Reviewed-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pagelist.c        |   18 ++++++++++++++++++
 fs/nfs/write.c           |   12 +++++++++++-
 include/linux/nfs_page.h |    1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -175,6 +175,24 @@ nfs_page_group_lock(struct nfs_page *req
 }
 
 /*
+ * nfs_page_group_lock_wait - wait for the lock to clear, but don't grab it
+ * @req - a request in the group
+ *
+ * This is a blocking call to wait for the group lock to be cleared.
+ */
+void
+nfs_page_group_lock_wait(struct nfs_page *req)
+{
+	struct nfs_page *head = req->wb_head;
+
+	WARN_ON_ONCE(head != head->wb_head);
+
+	wait_on_bit(&head->wb_flags, PG_HEADLOCK,
+		nfs_wait_bit_uninterruptible,
+		TASK_UNINTERRUPTIBLE);
+}
+
+/*
  * nfs_page_group_unlock - unlock the head of the page group
  * @req - request in group that is to be unlocked
  */
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -453,13 +453,23 @@ try_again:
 		return NULL;
 	}
 
-	/* lock each request in the page group */
+	/* holding inode lock, so always make a non-blocking call to try the
+	 * page group lock */
 	ret = nfs_page_group_lock(head, true);
 	if (ret < 0) {
 		spin_unlock(&inode->i_lock);
+
+		if (!nonblock && ret == -EAGAIN) {
+			nfs_page_group_lock_wait(head);
+			nfs_release_request(head);
+			goto try_again;
+		}
+
 		nfs_release_request(head);
 		return ERR_PTR(ret);
 	}
+
+	/* lock each request in the page group */
 	subreq = head;
 	do {
 		/*
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -121,6 +121,7 @@ extern  int nfs_wait_on_request(struct n
 extern	void nfs_unlock_request(struct nfs_page *req);
 extern	void nfs_unlock_and_release_request(struct nfs_page *);
 extern int nfs_page_group_lock(struct nfs_page *, bool);
+extern void nfs_page_group_lock_wait(struct nfs_page *);
 extern void nfs_page_group_unlock(struct nfs_page *);
 extern bool nfs_page_group_sync_on_bit(struct nfs_page *, unsigned int);
 


