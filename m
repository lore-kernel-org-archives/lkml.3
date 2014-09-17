Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaIQJ0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:26:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22284 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaIQJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:26:51 -0400
X-AuditID: cbfee61a-f79e46d00000134f-7c-541953d8d746
From: Chao Yu <chao2.yu@samsung.com>
To: sage@inktank.com
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: remove redundant code for max file size verification
Date: Wed, 17 Sep 2014 17:26:06 +0800
Message-id: <00fd01cfd259$81ef7530$85ce5f90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/SWVtad6da1ZOOROy5OloXhLLm5Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd2bwZIhBkc3sll8uDmJyeLyrjls
	FrtPdLE6MHscalzB7vF5k1wAUxSXTUpqTmZZapG+XQJXxqGdqxkL5gpW3Jl7kbGB8RVvFyMH
	h4SAicTstcpdjJxAppjEhXvr2boYuTiEBBYxSrT/74dyfjBKNH3dwQhSxSagIrG84z8TiC0i
	ICLxaflBFhCbWcBG4vnhB2A1wgLeEv9PTQWLswioSsw5uoYZxOYVsJR4/fMuE4QtKPFj8j2o
	Xi2J9TuPM0HY8hKb17xlhrhIQWLH2deMIIeKCOhJ/HpTBFEiLrHxyC2WCYwCs5BMmoVk0iwk
	k2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhon0ntYFzZYHGIUYCDUYmHd8Nl
	iRAh1sSy4srcQ4wSHMxKIrw1AZIhQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5ak
	ZqemFqQWwWSZODilGhgDNER9OGWjVRMeR7+1KC2ybi8oc+WKYJIOvOO+tyz08Ib/Sap8wg+v
	bZn5cVnB7WsRJav5zm31fjXjXVJcSNDTiMKQLZpvlzeXmkd/s9uce/5zge7ppVNus0/TXZtx
	667p98kBy9iu3P4uetVn97n57GbBtyJ/Ru6Kf/Aw4KrSMeXsa8ulG/mVWIozEg21mIuKEwFs
	XPSsVgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ceph_update_writeable_page and ceph_setattr will verify file size
with max size ceph supported.
There are two caller for ceph_update_writeable_page, ceph_write_begin and
ceph_page_mkwrite. For ceph_write_begin, we have already verified the size in
generic_write_checks of ceph_write_iter; for ceph_page_mkwrite, we have no
chance to change file size when mmap. Likewise we have already verified the size
in inode_change_ok when we call ceph_setattr.
So let's remove the redundant code for max file size verification.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/ceph/addr.c  | 9 ---------
 fs/ceph/inode.c | 6 ------
 2 files changed, 15 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 90b3954..18c06bb 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1076,12 +1076,6 @@ retry_locked:
 	/* past end of file? */
 	i_size = inode->i_size;   /* caller holds i_mutex */
 
-	if (i_size + len > inode->i_sb->s_maxbytes) {
-		/* file is too big */
-		r = -EINVAL;
-		goto fail;
-	}
-
 	if (page_off >= i_size ||
 	    (pos_in_page == 0 && (pos+len) >= i_size &&
 	     end_in_page - pos_in_page != PAGE_CACHE_SIZE)) {
@@ -1099,9 +1093,6 @@ retry_locked:
 	if (r < 0)
 		goto fail_nosnap;
 	goto retry_locked;
-
-fail:
-	up_read(&mdsc->snap_rwsem);
 fail_nosnap:
 	unlock_page(page);
 	return r;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 04c89c2..25c242e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1813,10 +1813,6 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 	if (ia_valid & ATTR_SIZE) {
 		dout("setattr %p size %lld -> %lld\n", inode,
 		     inode->i_size, attr->ia_size);
-		if (attr->ia_size > inode->i_sb->s_maxbytes) {
-			err = -EINVAL;
-			goto out;
-		}
 		if ((issued & CEPH_CAP_FILE_EXCL) &&
 		    attr->ia_size > inode->i_size) {
 			inode->i_size = attr->ia_size;
@@ -1896,8 +1892,6 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 	if (mask & CEPH_SETATTR_SIZE)
 		__ceph_do_pending_vmtruncate(inode);
 	return err;
-out:
-	spin_unlock(&ci->i_ceph_lock);
 out_put:
 	ceph_mdsc_put_request(req);
 	return err;
-- 
2.0.1.474.g72c7794


