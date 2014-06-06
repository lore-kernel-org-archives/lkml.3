Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaFFN22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:28:28 -0400
Received: from relay.parallels.com ([195.214.232.42]:43898 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaFFN21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:28:27 -0400
Subject: [PATCH 2/5] fuse: cosmetic rework of fuse_send_readpages
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 06 Jun 2014 17:28:25 +0400
Message-ID: <20140606132745.30321.15056.stgit@localhost.localdomain>
In-Reply-To: <20140606132541.30321.68679.stgit@localhost.localdomain>
References: <20140606132541.30321.68679.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch change arguments of fuse_send_readpages to give it access to inode
(will be used in the next patch of patch-set). The change is cosmetic,
no logic changed.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 96d513e..b81a945 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -827,8 +827,17 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		fuse_file_put(req->ff, false);
 }
 
-static void fuse_send_readpages(struct fuse_req *req, struct file *file)
+struct fuse_fill_data {
+	struct fuse_req *req;
+	struct file *file;
+	struct inode *inode;
+	unsigned nr_pages;
+};
+
+static void fuse_send_readpages(struct fuse_fill_data *data)
 {
+	struct fuse_req *req = data->req;
+	struct file *file = data->file;
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
 	loff_t pos = page_offset(req->pages[0]);
@@ -850,13 +859,6 @@ static void fuse_send_readpages(struct fuse_req *req, struct file *file)
 	}
 }
 
-struct fuse_fill_data {
-	struct fuse_req *req;
-	struct file *file;
-	struct inode *inode;
-	unsigned nr_pages;
-};
-
 static int fuse_readpages_fill(void *_data, struct page *page)
 {
 	struct fuse_fill_data *data = _data;
@@ -872,7 +874,7 @@ static int fuse_readpages_fill(void *_data, struct page *page)
 	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
 		int nr_alloc = min_t(unsigned, data->nr_pages,
 				     FUSE_MAX_PAGES_PER_REQ);
-		fuse_send_readpages(req, data->file);
+		fuse_send_readpages(data);
 		if (fc->async_read)
 			req = fuse_get_req_for_background(fc, nr_alloc);
 		else
@@ -925,7 +927,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
 	if (!err) {
 		if (data.req->num_pages)
-			fuse_send_readpages(data.req, file);
+			fuse_send_readpages(&data);
 		else
 			fuse_put_request(fc, data.req);
 	}

