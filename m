Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3HPLvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:51:08 -0400
Received: from relay.parallels.com ([195.214.232.42]:53265 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3HPLvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:51:04 -0400
Subject: [PATCH] fuse: fix race in fuse_writepages()
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org, xemul@parallels.com
Date: Fri, 16 Aug 2013 15:51:41 +0400
Message-ID: <20130816115057.6492.39356.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is for

 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git writepages.v2

The patch fixes a race between ftruncate(2), mmap-ed write and write(2):

1) An user makes a page dirty via mmap-ed write.
2) The user performs shrinking truncate(2) intended to purge the page.
3) Before fuse_do_setattr calls truncate_pagecache, the page goes to
   writeback. fuse_writepages_fill attaches a new page to FUSE_WRITE request,
   then releases the original page by end_page_writeback and unlock it.
4) fuse_do_setattr completes and successfully returns. Since now, i_mutex
   is free.
5) Ordinary write(2) extends i_size back to cover the page. Note that
   fuse_send_write_pages do wait for fuse writeback, but for another
   page->index.
6) fuse_writepages_fill attaches more pages to the request (if any), then
   fuse_writepages_send is eventually called. It is supposed to crop
   inarg->size of the request, but it doesn't because i_size has already been
   extended back.

Moving end_page_writeback behind fuse_writepages_send guarantees that
__fuse_release_nowrite (called from fuse_do_setattr) will crop inarg->size
of the request before write(2) gets the chance to extend i_size.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 568e859..0ebcc79 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1583,6 +1583,7 @@ struct fuse_fill_wb_data {
 	struct fuse_req *req;
 	struct fuse_file *ff;
 	struct inode *inode;
+	struct page **orig_pages;
 };
 
 static void fuse_writepages_send(struct fuse_fill_wb_data *data)
@@ -1591,12 +1592,17 @@ static void fuse_writepages_send(struct fuse_fill_wb_data *data)
 	struct inode *inode = data->inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	int num_pages = req->num_pages;
+	int i;
 
 	req->ff = fuse_file_get(data->ff);
 	spin_lock(&fc->lock);
 	list_add_tail(&req->list, &fi->queued_writes);
 	fuse_flush_writepages(inode);
 	spin_unlock(&fc->lock);
+
+	for (i = 0; i < num_pages; i++)
+		end_page_writeback(data->orig_pages[i]);
 }
 
 static int fuse_writepages_fill(struct page *page,
@@ -1677,7 +1683,7 @@ static int fuse_writepages_fill(struct page *page,
 
 	inc_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	end_page_writeback(page);
+	data->orig_pages[req->num_pages] = page;
 
 	/*
 	 * Protected by fc->lock against concurrent access by
@@ -1709,6 +1715,13 @@ static int fuse_writepages(struct address_space *mapping,
 	data.req = NULL;
 	data.ff = NULL;
 
+	err = -ENOMEM;
+	data.orig_pages = kzalloc(sizeof(struct page *) *
+				  FUSE_MAX_PAGES_PER_REQ,
+				  GFP_NOFS);
+	if (!data.orig_pages)
+		goto out;
+
 	err = write_cache_pages(mapping, wbc, fuse_writepages_fill, &data);
 	if (data.req) {
 		/* Ignore errors if we can write at least one page */
@@ -1718,6 +1731,8 @@ static int fuse_writepages(struct address_space *mapping,
 	}
 	if (data.ff)
 		fuse_file_put(data.ff, false);
+
+	kfree(data.orig_pages);
 out:
 	return err;
 }

