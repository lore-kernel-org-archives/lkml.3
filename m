Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3ISQLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:11:40 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45611 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3ISQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:11:38 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: mpatlasov@parallels.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 2/3] fuse: writepages: handle same page rewrites
Date: Thu, 19 Sep 2013 18:11:55 +0200
Message-Id: <1379607116-13382-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
References: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

As Maxim Patlasov pointed out, it's possible to get a dirty page while it's
copy is still under writeback, despite fuse_page_mkwrite() doing its thing
(direct IO).

This could result in two concurrent write request for the same offset, with
data corruption if they get mixed up.

To prevent this, fuse needs to check and delay such writes.  This
implementation does this by:

 1. check if page is still under writeout, if so create a new, single page
    secondary request for it

 2. chain this secondary request onto the in-flight request

 2/a. if a seconday request for the same offset was already chained to the
    in-flight request, then just copy the contents of the page and discard
    the new secondary request.  This makes sure that for each page will
    have at most two requests associated with it

 3. when the in-flight request finished, send off all secondary requests
    chained onto it

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c   | 100 +++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/fuse/fuse_i.h |   1 +
 2 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bf765cf..f8ff019 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1414,7 +1414,9 @@ static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 
 	for (i = 0; i < req->num_pages; i++)
 		__free_page(req->pages[i]);
-	fuse_file_put(req->ff, false);
+
+	if (req->ff)
+		fuse_file_put(req->ff, false);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
@@ -1496,6 +1498,14 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 
 	mapping_set_error(inode->i_mapping, req->out.h.error);
 	spin_lock(&fc->lock);
+	while (req->misc.write.next) {
+		struct fuse_req *next = req->misc.write.next;
+		req->misc.write.next = next->misc.write.next;
+		next->misc.write.next = NULL;
+		list_add(&next->writepages_entry, &fi->writepages);
+		list_add_tail(&next->list, &fi->queued_writes);
+		fuse_flush_writepages(inode);
+	}
 	fi->writectr--;
 	fuse_writepage_finish(fc, req);
 	spin_unlock(&fc->lock);
@@ -1548,6 +1558,7 @@ static int fuse_writepage_locked(struct page *page)
 
 	copy_highpage(tmp_page, page);
 	req->misc.write.in.write_flags |= FUSE_WRITE_CACHE;
+	req->misc.write.next = NULL;
 	req->in.argpages = 1;
 	req->num_pages = 1;
 	req->pages[0] = tmp_page;
@@ -1612,6 +1623,62 @@ static void fuse_writepages_send(struct fuse_fill_wb_data *data)
 		end_page_writeback(data->orig_pages[i]);
 }
 
+static bool fuse_writepage_in_flight(struct fuse_req *new_req,
+				     struct page *page)
+{
+	struct fuse_conn *fc = get_fuse_conn(new_req->inode);
+	struct fuse_inode *fi = get_fuse_inode(new_req->inode);
+	struct fuse_req *tmp;
+	struct fuse_req *old_req;
+	bool found = false;
+	pgoff_t curr_index;
+
+	BUG_ON(new_req->num_pages != 0);
+
+	spin_lock(&fc->lock);
+	list_del(&new_req->writepages_entry);
+	new_req->num_pages = 1;
+	list_for_each_entry(old_req, &fi->writepages, writepages_entry) {
+		BUG_ON(old_req->inode != new_req->inode);
+		curr_index = old_req->misc.write.in.offset >> PAGE_CACHE_SHIFT;
+		if (curr_index <= page->index &&
+		    page->index < curr_index + old_req->num_pages) {
+			found = true;
+			break;
+		}
+	}
+	if (!found)
+		goto out_unlock;
+
+	for (tmp = old_req; tmp != NULL; tmp = tmp->misc.write.next) {
+		BUG_ON(tmp->inode != new_req->inode);
+		curr_index = tmp->misc.write.in.offset >> PAGE_CACHE_SHIFT;
+		if (tmp->num_pages == 1 &&
+		    curr_index == page->index) {
+			old_req = tmp;
+		}
+	}
+
+	if (old_req->num_pages == 1 && (old_req->state == FUSE_REQ_INIT ||
+					old_req->state == FUSE_REQ_PENDING)) {
+		copy_highpage(old_req->pages[0], page);
+		spin_unlock(&fc->lock);
+
+		dec_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
+		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
+		fuse_writepage_free(fc, new_req);
+		fuse_request_free(new_req);
+		goto out;
+	} else {
+		new_req->misc.write.next = old_req->misc.write.next;
+		old_req->misc.write.next = new_req;
+	}
+out_unlock:
+	spin_unlock(&fc->lock);
+out:
+	return found;
+}
+
 static int fuse_writepages_fill(struct page *page,
 		struct writeback_control *wbc, void *_data)
 {
@@ -1620,6 +1687,7 @@ static int fuse_writepages_fill(struct page *page,
 	struct inode *inode = data->inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct page *tmp_page;
+	bool is_writeback;
 	int err;
 
 	if (!data->ff) {
@@ -1629,15 +1697,20 @@ static int fuse_writepages_fill(struct page *page,
 			goto out_unlock;
 	}
 
-	if (req) {
-		BUG_ON(!req->num_pages);
-		if (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
-		    (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_write ||
-		    data->orig_pages[req->num_pages - 1]->index + 1 != page->index) {
+	/*
+	 * Being under writeback is unlikely but possible.  For example direct
+	 * read to an mmaped fuse file will set the page dirty twice; once when
+	 * the pages are faulted with get_user_pages(), and then after the read
+	 * completed.
+	 */
+	is_writeback = fuse_page_is_writeback(inode, page->index);
 
-			fuse_writepages_send(data);
-			data->req = NULL;
-		}
+	if (req && req->num_pages &&
+	    (is_writeback || req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
+	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_write ||
+	     data->orig_pages[req->num_pages - 1]->index + 1 != page->index)) {
+		fuse_writepages_send(data);
+		data->req = NULL;
 	}
 	err = -ENOMEM;
 	tmp_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
@@ -1669,6 +1742,7 @@ static int fuse_writepages_fill(struct page *page,
 
 		fuse_write_fill(req, data->ff, page_offset(page), 0);
 		req->misc.write.in.write_flags |= FUSE_WRITE_CACHE;
+		req->misc.write.next = NULL;
 		req->in.argpages = 1;
 		req->background = 1;
 		req->num_pages = 0;
@@ -1690,6 +1764,13 @@ static int fuse_writepages_fill(struct page *page,
 
 	inc_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
+
+	err = 0;
+	if (is_writeback && fuse_writepage_in_flight(req, page)) {
+		end_page_writeback(page);
+		data->req = NULL;
+		goto out_unlock;
+	}
 	data->orig_pages[req->num_pages] = page;
 
 	/*
@@ -1700,7 +1781,6 @@ static int fuse_writepages_fill(struct page *page,
 	req->num_pages++;
 	spin_unlock(&fc->lock);
 
-	err = 0;
 out_unlock:
 	unlock_page(page);
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 5ced199..a08b355 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -319,6 +319,7 @@ struct fuse_req {
 		struct {
 			struct fuse_write_in in;
 			struct fuse_write_out out;
+			struct fuse_req *next;
 		} write;
 		struct fuse_notify_retrieve_in retrieve_in;
 		struct fuse_lk_in lk_in;
-- 
1.8.1.4

