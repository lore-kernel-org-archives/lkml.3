Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3CUODx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:03:53 -0400
Received: from relay.parallels.com ([195.214.232.42]:38927 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab3CUODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:03:50 -0400
Subject: [PATCH 1/4] fuse: make request allocations for background processing
 explicit
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, xemul@parallels.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, dev@parallels.com
Date: Thu, 21 Mar 2013 18:02:04 +0400
Message-ID: <20130321140158.4051.21360.stgit@maximpc.sw.ru>
In-Reply-To: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
References: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two types of processing requests in FUSE: synchronous (via
fuse_request_send()) and asynchronous (via adding to fc->bg_queue).

Fortunately, the type of processing is always known in advance, at the time
of request allocation. This preparatory patch utilizes this fact making
fuse_get_req() aware about the type. Next patches will use it.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/cuse.c   |    2 +-
 fs/fuse/dev.c    |   24 +++++++++++++++++++++---
 fs/fuse/file.c   |    6 ++++--
 fs/fuse/fuse_i.h |    4 ++++
 fs/fuse/inode.c  |    1 +
 5 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 6f96a8d..b7c7f30 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -422,7 +422,7 @@ static int cuse_send_init(struct cuse_conn *cc)
 
 	BUILD_BUG_ON(CUSE_INIT_INFO_MAX > PAGE_SIZE);
 
-	req = fuse_get_req(fc, 1);
+	req = fuse_get_req_for_background(fc, 1);
 	if (IS_ERR(req)) {
 		rc = PTR_ERR(req);
 		goto err;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index e9bdec0..512626f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -86,7 +86,10 @@ EXPORT_SYMBOL_GPL(fuse_request_alloc);
 
 struct fuse_req *fuse_request_alloc_nofs(unsigned npages)
 {
-	return __fuse_request_alloc(npages, GFP_NOFS);
+	struct fuse_req *req = __fuse_request_alloc(npages, GFP_NOFS);
+	if (req)
+		req->background = 1; /* writeback always goes to bg_queue */
+	return req;
 }
 
 void fuse_request_free(struct fuse_req *req)
@@ -130,7 +133,8 @@ static void fuse_req_init_context(struct fuse_req *req)
 	req->in.h.pid = current->pid;
 }
 
-struct fuse_req *fuse_get_req(struct fuse_conn *fc, unsigned npages)
+struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc, unsigned npages,
+				       bool for_background)
 {
 	struct fuse_req *req;
 	sigset_t oldset;
@@ -156,14 +160,27 @@ struct fuse_req *fuse_get_req(struct fuse_conn *fc, unsigned npages)
 
 	fuse_req_init_context(req);
 	req->waiting = 1;
+	req->background = for_background;
 	return req;
 
  out:
 	atomic_dec(&fc->num_waiting);
 	return ERR_PTR(err);
 }
+
+struct fuse_req *fuse_get_req(struct fuse_conn *fc, unsigned npages)
+{
+	return fuse_get_req_internal(fc, npages, 0);
+}
 EXPORT_SYMBOL_GPL(fuse_get_req);
 
+struct fuse_req *fuse_get_req_for_background(struct fuse_conn *fc,
+					     unsigned npages)
+{
+	return fuse_get_req_internal(fc, npages, 1);
+}
+EXPORT_SYMBOL_GPL(fuse_get_req_for_background);
+
 /*
  * Return request in fuse_file->reserved_req.  However that may
  * currently be in use.  If that is the case, wait for it to become
@@ -442,6 +459,7 @@ __acquires(fc->lock)
 
 static void __fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 {
+	BUG_ON(req->background);
 	spin_lock(&fc->lock);
 	if (!fc->connected)
 		req->out.h.error = -ENOTCONN;
@@ -469,7 +487,7 @@ EXPORT_SYMBOL_GPL(fuse_request_send);
 static void fuse_request_send_nowait_locked(struct fuse_conn *fc,
 					    struct fuse_req *req)
 {
-	req->background = 1;
+	BUG_ON(!req->background);
 	fc->num_background++;
 	if (fc->num_background == fc->max_background)
 		fc->blocked = 1;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c807176..097d48f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -131,6 +131,7 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
 			fuse_put_request(ff->fc, req);
 		} else {
 			req->end = fuse_release_end;
+			req->background = 1;
 			fuse_request_send_background(ff->fc, req);
 		}
 		kfree(ff);
@@ -661,7 +662,8 @@ static int fuse_readpages_fill(void *_data, struct page *page)
 		int nr_alloc = min_t(unsigned, data->nr_pages,
 				     FUSE_MAX_PAGES_PER_REQ);
 		fuse_send_readpages(req, data->file);
-		data->req = req = fuse_get_req(fc, nr_alloc);
+		data->req = req = fuse_get_req_internal(fc, nr_alloc,
+							fc->async_read);
 		if (IS_ERR(req)) {
 			unlock_page(page);
 			return PTR_ERR(req);
@@ -696,7 +698,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 
 	data.file = file;
 	data.inode = inode;
-	data.req = fuse_get_req(fc, nr_alloc);
+	data.req = fuse_get_req_internal(fc, nr_alloc, fc->async_read);
 	data.nr_pages = nr_pages;
 	err = PTR_ERR(data.req);
 	if (IS_ERR(data.req))
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 6aeba86..457f62e 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -708,6 +708,10 @@ void fuse_request_free(struct fuse_req *req);
  * caller should specify # elements in req->pages[] explicitly
  */
 struct fuse_req *fuse_get_req(struct fuse_conn *fc, unsigned npages);
+struct fuse_req *fuse_get_req_for_background(struct fuse_conn *fc,
+					     unsigned npages);
+struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc, unsigned npages,
+				       bool for_background);
 
 /**
  * Get a request, may fail with -ENOMEM,
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 01353ed..de0bee0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1043,6 +1043,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	init_req = fuse_request_alloc(0);
 	if (!init_req)
 		goto err_put_root;
+	init_req->background = 1;
 
 	if (is_bdev) {
 		fc->destroy_req = fuse_request_alloc(0);

