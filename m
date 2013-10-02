Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3JBLCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:02:37 -0400
Received: from relay.parallels.com ([195.214.232.42]:34639 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3JBLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:02:35 -0400
Subject: [PATCH 3/5] fuse: writepages: crop secondary requests on attach
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 15:02:34 +0400
Message-ID: <20131002110137.26932.31109.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131002105815.26932.46041.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131002105815.26932.46041.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a request was already cropped according to i_size (i.e. went through
fuse_send_writepage()) and then another writeback happens and we decided
to attach it the request, we must crop it according to misc.write.in.size
of the request. Otherwise the following scenario could lead to writing
stale data (where zeros are expected):

1. Shrinking ftruncate(2) is handled by fuse_do_setattr() which eventually
calls fuse_release_nowrite() which properly crops requests sitting in
fi->queued_writes. Since now some range in a page-cache page is invalid
(i.e. contains stale data which shouldn't come to the server). This properly
reflected by misc.write.in.size of a request.
2. The page is re-dirtied, new writeback happens, fuse_writepage_in_flight()
attaches new request to the request (because it's already in-flight).
3. Extending ftruncate(2) increases i_size, so by the time that attached
request comes to fuse_send_writepage(), i_size is already extended
and that stale range of a page will come to the server. The result is that
the user will see stale data where zeros are expected.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a5d1f87..036fcf3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1680,6 +1680,14 @@ static void fuse_writepages_send(struct fuse_fill_wb_data *data)
 		end_page_writeback(data->orig_pages[i]);
 }
 
+static inline loff_t fuse_req_end_pos(struct fuse_req *req)
+{
+	__u64 data_size = req->misc.write.in.size ? :
+		req->num_pages * PAGE_CACHE_SIZE;
+
+	return req->misc.write.in.offset + data_size;
+}
+
 static bool fuse_writepage_in_flight(struct fuse_req *new_req,
 				     struct page *page)
 {
@@ -1689,6 +1697,7 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
 	struct fuse_req *old_req;
 	bool found = false;
 	pgoff_t curr_index;
+	bool page_copied = false;
 
 	BUG_ON(new_req->num_pages != 0);
 
@@ -1722,8 +1731,12 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
 	if (old_req->num_pages == 1 && (old_req->state == FUSE_REQ_INIT ||
 					old_req->state == FUSE_REQ_PENDING)) {
 		copy_highpage(old_req->pages[0], page);
-		spin_unlock(&fc->lock);
+		page_copied = true;
+	}
 
+	if (page_copied ||
+	    new_req->misc.write.in.offset >= fuse_req_end_pos(old_req)) {
+		spin_unlock(&fc->lock);
 		dec_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
 		fuse_writepage_free(fc, new_req);
@@ -1732,6 +1745,11 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
 	} else {
 		new_req->misc.write.next = old_req->misc.write.next;
 		old_req->misc.write.next = new_req;
+
+		if (fuse_req_end_pos(new_req) > fuse_req_end_pos(old_req))
+			new_req->misc.write.in.size =
+				fuse_req_end_pos(old_req) -
+				new_req->misc.write.in.offset;
 	}
 out_unlock:
 	spin_unlock(&fc->lock);

