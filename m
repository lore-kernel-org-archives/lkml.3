Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab3AOWxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:53:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:47154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 141/171] ceph: propagate layout error on osd request creation
Date: Tue, 15 Jan 2013 14:45:06 -0800
Message-Id: <20130115224323.523029699@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sage Weil <sage@inktank.com>

If we are creating an osd request and get an invalid layout, return
an EINVAL to the caller.  We switch up the return to have an error
code instead of NULL implying -ENOMEM.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit 6816282dab3a72efe8c0d182c1bc2960d87f4322)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c        |    8 ++++----
 fs/ceph/file.c        |    4 ++--
 net/ceph/osd_client.c |   15 +++++++++------
 3 files changed, 15 insertions(+), 12 deletions(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -308,8 +308,8 @@ static int start_read(struct inode *inod
 				    NULL, 0,
 				    ci->i_truncate_seq, ci->i_truncate_size,
 				    NULL, false, 1, 0);
-	if (!req)
-		return -ENOMEM;
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 
 	/* build page vector */
 	nr_pages = len >> PAGE_CACHE_SHIFT;
@@ -831,8 +831,8 @@ get_more_pages:
 					    ci->i_truncate_size,
 					    &inode->i_mtime, true, 1, 0);
 
-				if (!req) {
-					rc = -ENOMEM;
+				if (IS_ERR(req)) {
+					rc = PTR_ERR(req);
 					unlock_page(page);
 					break;
 				}
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -529,8 +529,8 @@ more:
 				    do_sync,
 				    ci->i_truncate_seq, ci->i_truncate_size,
 				    &mtime, false, 2, page_align);
-	if (!req)
-		return -ENOMEM;
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 
 	if (file->f_flags & O_DIRECT) {
 		pages = ceph_get_direct_page_vector(data, num_pages, false);
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -461,6 +461,7 @@ struct ceph_osd_request *ceph_osdc_new_r
 {
 	struct ceph_osd_req_op ops[3];
 	struct ceph_osd_request *req;
+	int r;
 
 	ops[0].op = opcode;
 	ops[0].extent.truncate_seq = truncate_seq;
@@ -479,10 +480,12 @@ struct ceph_osd_request *ceph_osdc_new_r
 					 use_mempool,
 					 GFP_NOFS, NULL, NULL);
 	if (!req)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/* calculate max write size */
-	calc_layout(osdc, vino, layout, off, plen, req, ops);
+	r = calc_layout(osdc, vino, layout, off, plen, req, ops);
+	if (r < 0)
+		return ERR_PTR(r);
 	req->r_file_layout = *layout;  /* keep a copy */
 
 	/* in case it differs from natural (file) alignment that
@@ -1925,8 +1928,8 @@ int ceph_osdc_readpages(struct ceph_osd_
 				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
 				    NULL, 0, truncate_seq, truncate_size, NULL,
 				    false, 1, page_align);
-	if (!req)
-		return -ENOMEM;
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 
 	/* it may be a short read due to an object boundary */
 	req->r_pages = pages;
@@ -1968,8 +1971,8 @@ int ceph_osdc_writepages(struct ceph_osd
 				    snapc, do_sync,
 				    truncate_seq, truncate_size, mtime,
 				    nofail, 1, page_align);
-	if (!req)
-		return -ENOMEM;
+	if (IS_ERR(req))
+		return PTR_ERR(req);
 
 	/* it may be a short write due to an object boundary */
 	req->r_pages = pages;


