Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab3APQPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:15:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36916 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab3APQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Weston Andros Adamson <dros@netapp.com>, Tejun Heo <tj@kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 208/222] NFS: Ensure that we free the rpc_task after read and write cleanups are done
Date: Wed, 16 Jan 2013 13:56:48 -0200
Message-Id: <1358351822-7675-209-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 6db6dd7d3fd8f7c765dabc376493d6791ab28bd6 upstream.

This patch ensures that we free the rpc_task after the cleanup callbacks
are done in order to avoid a deadlock problem that can be triggered if
the callback needs to wait for another workqueue item to complete.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Weston Andros Adamson <dros@netapp.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Bruce Fields <bfields@fieldses.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/read.c  |   10 +++++++---
 fs/nfs/write.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 86ced78..b151ad5 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -91,12 +91,16 @@ void nfs_readdata_release(struct nfs_read_data *rdata)
 	put_nfs_open_context(rdata->args.context);
 	if (rdata->pages.pagevec != rdata->pages.page_array)
 		kfree(rdata->pages.pagevec);
-	if (rdata != &read_header->rpc_data)
-		kfree(rdata);
-	else
+	if (rdata == &read_header->rpc_data) {
 		rdata->header = NULL;
+		rdata = NULL;
+	}
 	if (atomic_dec_and_test(&hdr->refcnt))
 		hdr->completion_ops->completion(hdr);
+	/* Note: we only free the rpc_task after callbacks are done.
+	 * See the comment in rpc_free_task() for why
+	 */
+	kfree(rdata);
 }
 
 static
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index bce88ac..a440deb 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -124,12 +124,16 @@ void nfs_writedata_release(struct nfs_write_data *wdata)
 	put_nfs_open_context(wdata->args.context);
 	if (wdata->pages.pagevec != wdata->pages.page_array)
 		kfree(wdata->pages.pagevec);
-	if (wdata != &write_header->rpc_data)
-		kfree(wdata);
-	else
+	if (wdata == &write_header->rpc_data) {
 		wdata->header = NULL;
+		wdata = NULL;
+	}
 	if (atomic_dec_and_test(&hdr->refcnt))
 		hdr->completion_ops->completion(hdr);
+	/* Note: we only free the rpc_task after callbacks are done.
+	 * See the comment in rpc_free_task() for why
+	 */
+	kfree(wdata);
 }
 
 static void nfs_context_set_write_error(struct nfs_open_context *ctx, int error)
-- 
1.7.9.5

