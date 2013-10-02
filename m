Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3JBLRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:17:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:36655 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3JBLRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:17:42 -0400
Subject: [PATCH 2/5] fuse: writepages: crop secondary requests on send -v2
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 15:17:39 +0400
Message-ID: <20131002111354.27362.70435.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131002110112.26932.68729.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131002110112.26932.68729.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If writeback happens while fuse is in FUSE_NOWRITE condition, the request
will be queued but not processed immediately (see fuse_flush_writepages()).
Until FUSE_NOWRITE becomes relaxed, more writebacks can happen. They will
be queued as "secondary" requests to that first ("primary") request.

When FUSE_NOWRITE is relaxed and fuse_send_writepage() is called, it must
crop both primary and secondary requests according to the actual i_size.
Otherwise, if only primary is cropped, an extending write(2) may increase
i_size soon and then secondary requests won't be cropped properly. The result
would be stale data written to the server to a file offset where zeros must be.

Changed in v2:
 - avoid NULL pointer dereference in fuse_drop_writepage().

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 575e44f..89a2e76 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1435,6 +1435,51 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 	wake_up(&fi->page_waitq);
 }
 
+/* Drop list of secondary writepage requests */
+static void fuse_drop_writepage(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct backing_dev_info *bdi = req ?
+		req->inode->i_mapping->backing_dev_info : NULL;
+
+	while (req) {
+		struct fuse_req *next = req->misc.write.next;
+		dec_bdi_stat(bdi, BDI_WRITEBACK);
+		dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
+		fuse_writepage_free(fc, req);
+		fuse_put_request(fc, req);
+		req = next;
+	}
+}
+
+/* Crop the misc.write.in.size of parent and secondary writepage requests */
+static bool fuse_crop_writepage(struct fuse_conn *fc, struct fuse_req *req,
+				loff_t size, struct fuse_req **drop_list)
+{
+	if (req->misc.write.in.offset >= size)
+		return true;
+
+	while (req) {
+		struct fuse_req *next = req->misc.write.next;
+		struct fuse_write_in *inarg = &req->misc.write.in;
+		__u64 data_size = inarg->size ? :
+			req->num_pages * PAGE_CACHE_SIZE;
+
+		if (inarg->offset + data_size <= size) {
+			inarg->size = data_size;
+		} else if (inarg->offset < size) {
+			inarg->size = size - inarg->offset;
+		} else {
+			/* Got truncated off completely */
+			req->misc.write.next = *drop_list;
+			*drop_list = req;
+		}
+
+		req = next;
+	}
+
+	return false;
+}
+
 /* Called under fc->lock, may release and reacquire it */
 static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req)
 __releases(fc->lock)
@@ -1443,29 +1488,30 @@ __acquires(fc->lock)
 	struct fuse_inode *fi = get_fuse_inode(req->inode);
 	loff_t size = i_size_read(req->inode);
 	struct fuse_write_in *inarg = &req->misc.write.in;
-	__u64 data_size = req->num_pages * PAGE_CACHE_SIZE;
+	struct fuse_req *drop_list = NULL;
 
 	if (!fc->connected)
 		goto out_free;
 
-	if (inarg->offset + data_size <= size) {
-		inarg->size = data_size;
-	} else if (inarg->offset < size) {
-		inarg->size = size - inarg->offset;
-	} else {
-		/* Got truncated off completely */
-		goto out_free;
-	}
+	if (fuse_crop_writepage(fc, req, size, &drop_list))
+		goto out_free; /* drop req and descendants */
 
 	req->in.args[1].size = inarg->size;
 	fi->writectr++;
 	fuse_request_send_background_locked(fc, req);
+
+	if (drop_list) {
+		spin_unlock(&fc->lock);
+		fuse_drop_writepage(fc, drop_list);
+		spin_lock(&fc->lock);
+	}
 	return;
 
  out_free:
 	fuse_writepage_finish(fc, req);
 	spin_unlock(&fc->lock);
 	fuse_writepage_free(fc, req);
+	fuse_drop_writepage(fc, req->misc.write.next);
 	fuse_put_request(fc, req);
 	spin_lock(&fc->lock);
 }

