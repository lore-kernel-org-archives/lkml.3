Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3FNPio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:38:44 -0400
Received: from m59-178.qiye.163.com ([123.58.178.59]:36626 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3FNPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:38:41 -0400
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 1/2] Punch hole support against 3.8-rc3
Date: Fri, 14 Jun 2013 23:38:03 +0800
Message-Id: <1371224283-4886-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com>
References: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU5VQ0hLS0tLT0tLTk9ISUpIV1kJDhceCFlBWSgrPSQoND0vPToyNyQy
	NSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNSQzPjo*PilBSVVLQDg0
	LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQzLjU6NUFLVUtAPyI1OjYyOCQy
	KyQ1NCQyNSQzPjo*PilBS1VLQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJDI1JDM#Oj8#KUFJVUtAMisk
	LzQ*OiIkODUvJEskSktLQUtVS0AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRKJDYyNS4vPiQ4
	NS8kSyRKS0FLVUtAMiskSEskNjI1Li8#JDg1LyRLJE5LQUtVS0AyKyROJDYyNS4vPiQ4NS8kSyRK
	S0FLVUtAKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSExKSUlPSEpDTUNNVTMWGhIX
	VRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHgY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements punch hole (fallocate) support against
Linux kernel 3.8-rc3.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 fs/ceph/file.c        |  248 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c |   17 +++-
 2 files changed, 260 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e51558f..7fb9c6d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -7,6 +7,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/writeback.h>
+#include <linux/falloc.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -848,6 +849,252 @@ out:
 	return offset;
 }
 
+static inline void ceph_zero_partial_page(struct inode *inode, pgoff_t index, unsigned start, unsigned size)
+{
+	struct page *page;
+
+	page = find_lock_page(inode->i_mapping, index);
+	if (page) {
+		zero_user(page, start, size);
+		unlock_page(page);
+		page_cache_release(page);
+	}	
+}
+
+static void ceph_truncate_and_zero_page_cache(struct inode *inode, loff_t offset, loff_t length)
+{
+	loff_t first_page;
+	loff_t last_page;
+	loff_t zero_len;
+
+	first_page =((offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
+	last_page = ((offset + length) >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
+	if (last_page > first_page) {
+		truncate_pagecache_range(inode, first_page, last_page - 1);
+	}
+	if (first_page > last_page) {
+		ceph_zero_partial_page(inode, offset >> PAGE_CACHE_SHIFT, offset & (PAGE_CACHE_SIZE - 1), length);
+		return;
+	}
+	/*
+	 * zero out the partial page that contains
+	 * the start of the hole
+	 */	
+	zero_len  = first_page - offset;
+	if (zero_len > 0) {
+		ceph_zero_partial_page(inode, offset >> PAGE_CACHE_SHIFT, offset & (PAGE_CACHE_SIZE -1), zero_len);
+	}
+	/*
+	 * zero out the partial page that contains
+	 * the end of the hole
+	 */
+	zero_len = offset + length - last_page;
+	if (zero_len > 0) {
+		ceph_zero_partial_page(inode, (offset + length) >> PAGE_CACHE_SHIFT, 0, zero_len);
+	}
+	/*
+	 * If i_size is contained in the last page, we need to
+	 * zero the partial page after i_size
+	 */
+	if (inode->i_size >> PAGE_CACHE_SHIFT == (offset + length) >> PAGE_CACHE_SHIFT && inode->i_size % PAGE_CACHE_SIZE != 0) {
+		zero_len = PAGE_CACHE_SIZE -
+			(inode->i_size & (PAGE_CACHE_SIZE - 1));
+		if (zero_len > 0) {
+			ceph_zero_partial_page(inode, inode->i_size >> PAGE_CACHE_SHIFT, inode->i_size & (PAGE_CACHE_SIZE -1), zero_len);
+		}
+	}
+}
+
+static int ceph_delete_object_range(struct inode *inode, loff_t lstart, loff_t lend)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+    struct ceph_fs_client *fsc = ceph_inode_to_client(inode);	
+	struct ceph_osd_request *req;
+	u64 length = ceph_file_layout_object_size(ci->i_layout);
+	loff_t offset;
+	int ret = 0;
+
+	if (lstart > lend || length <= 0)
+		goto out;
+	for (offset = lstart; offset <= lend; offset += length) {		
+		req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
+                                    ceph_vino(inode), offset, &length,
+                                    CEPH_OSD_OP_DELETE, CEPH_OSD_FLAG_ONDISK,
+                                    NULL,
+                                    0,
+                                    ci->i_truncate_seq, ci->i_truncate_size,
+                                    NULL, false, 1, 0);
+		if (IS_ERR(req)) {
+        	ret = PTR_ERR(req);
+			goto out;
+		}
+
+    	ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
+    	if (!ret) {
+        	ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+    	}
+		ceph_osdc_put_request(req); 
+		/* object deleted */
+		if (ret == -ENOENT)
+			ret = 0;
+	}
+
+	out:
+	return ret;
+}
+
+static int ceph_zero_partial_object(struct file *file, loff_t offset, loff_t length)
+{
+	struct ceph_file_info *fi = file->private_data;	
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);	
+	struct ceph_osd_request *req;
+	struct timespec mtime = CURRENT_TIME;
+	int want, got = 0, ret = 0;
+	
+	if (length <= 0)
+		goto out;
+
+	
+	if (fi->fmode & CEPH_FILE_MODE_LAZY)
+			want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
+		else
+			want = CEPH_CAP_FILE_BUFFER;
+	
+	ret = ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, &got, offset+length);
+	if (ret < 0)
+		goto out;
+	if (!(got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO))) {
+		ceph_put_cap_refs(ci, got);
+		ret = -EAGAIN;
+		goto out;
+	}
+	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
+                                    ceph_vino(inode), offset, &length,
+                                    CEPH_OSD_OP_ZERO, CEPH_OSD_FLAG_WRITE | CEPH_OSD_FLAG_ONDISK,
+                                    NULL,
+                                    0,
+                                    ci->i_truncate_seq, ci->i_truncate_size,
+                                    &mtime, false, 1, 0);
+	if (IS_ERR(req)) {
+    	ret = PTR_ERR(req);
+		goto out;
+	}
+
+    ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
+    if (!ret) {
+        ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+    }
+	ceph_osdc_put_request(req); 	
+	ceph_put_cap_refs(ci, got);
+
+	out:
+	return ret;
+}
+
+static int ceph_delete_and_zero_objects(struct file *file, loff_t offset, loff_t length)
+{
+	unsigned long first_object;
+	unsigned long last_object;
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	__s32 object_size;
+	__u32 object_shift;	
+	loff_t zero_len;
+	int ret = 0;
+	
+	if (!(object_size = ceph_file_layout_object_size(ci->i_layout)))
+		goto out;
+	if (object_size == 1) {
+		object_shift = 0;
+	} else {
+		for (object_shift = 0; ;object_shift++) {
+			if (2 << object_shift == object_size)
+				break;
+		}
+		object_shift++;
+	}
+	
+	first_object =((offset + object_size - 1) >> object_shift) << object_shift;
+	last_object = ((offset + length) >> object_shift) << object_shift;
+	if (last_object > first_object) {
+		ret = ceph_delete_object_range(inode, first_object, last_object - 1);
+		if (ret)
+			goto out;
+	}
+	if (first_object > last_object) {
+		ret = ceph_zero_partial_object(file, offset, length);
+		goto out;
+	}
+	/*
+	 * zero out the partial object that contains
+	 * the start of the hole
+	 */	
+	zero_len  = first_object - offset;
+	if (zero_len > 0) {
+		ret = ceph_zero_partial_object(file, offset, zero_len);
+		if (ret)
+			goto out;
+	}
+	/*
+	 * zero out the partial object that contains
+	 * the end of the hole
+	 */
+	zero_len = offset + length - last_object;
+	if (zero_len > 0) {
+		ret = ceph_zero_partial_object(file, last_object, zero_len);
+	}
+
+	out:
+	return ret;
+}
+
+static int ceph_punch_hole(struct file *file, loff_t offset, loff_t length)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	int ret = 0;
+
+    if (!S_ISREG(inode->i_mode)) {
+        return -EOPNOTSUPP;
+	}
+	if (IS_SWAPFILE(inode)) {
+		return -ETXTBSY;
+	}
+	mutex_lock(&inode->i_mutex);
+
+	/* No need to punch hole beyond i_size */
+	if (offset >= inode->i_size)
+		goto out_unlock;
+
+	/*
+	 * If the hole extends beyond i_size, set the hole
+	 * to end after the page that contains i_size
+	 */
+	if (offset + length > inode->i_size) {
+		length = inode->i_size +
+		   PAGE_CACHE_SIZE - (inode->i_size & (PAGE_CACHE_SIZE - 1)) -
+		   offset;
+	}
+
+	ceph_truncate_and_zero_page_cache(inode, offset, length);
+	ret = ceph_delete_and_zero_objects(file, offset, length);
+	
+	out_unlock:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
+static long ceph_fallocate(struct file *file, int mode, loff_t offset, loff_t length)
+{
+	/* FALLOC_FL_PUNCH_HOLE must be used with FALLOC_FL_KEEP_SIZE */
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		return ceph_punch_hole(file, offset, length);
+	return -EOPNOTSUPP;
+}
+
 const struct file_operations ceph_file_fops = {
 	.open = ceph_open,
 	.release = ceph_release,
@@ -864,5 +1111,6 @@ const struct file_operations ceph_file_fops = {
 	.splice_write = generic_file_splice_write,
 	.unlocked_ioctl = ceph_ioctl,
 	.compat_ioctl	= ceph_ioctl,
+	.fallocate = ceph_fallocate,
 };
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index eb9a444..da69cfd 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -230,7 +230,7 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 
 	req->r_flags = flags;
 
-	WARN_ON((flags & (CEPH_OSD_FLAG_READ|CEPH_OSD_FLAG_WRITE)) == 0);
+	WARN_ON((flags & (CEPH_OSD_FLAG_READ|CEPH_OSD_FLAG_WRITE|CEPH_OSD_FLAG_ONDISK)) == 0);
 
 	/* create reply message */
 	if (use_mempool)
@@ -291,14 +291,16 @@ static void osd_req_encode_op(struct ceph_osd_request *req,
 	switch (src->op) {
 	case CEPH_OSD_OP_READ:
 	case CEPH_OSD_OP_WRITE:
-		dst->extent.offset =
-			cpu_to_le64(src->extent.offset);
-		dst->extent.length =
-			cpu_to_le64(src->extent.length);
 		dst->extent.truncate_size =
 			cpu_to_le64(src->extent.truncate_size);
 		dst->extent.truncate_seq =
 			cpu_to_le32(src->extent.truncate_seq);
+	case CEPH_OSD_OP_DELETE:
+	case CEPH_OSD_OP_ZERO:
+		dst->extent.length =
+			cpu_to_le64(src->extent.length);
+		dst->extent.offset =
+			cpu_to_le64(src->extent.offset);		
 		break;
 
 	case CEPH_OSD_OP_GETXATTR:
@@ -471,6 +473,10 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	ops[0].extent.truncate_size = truncate_size;
 	ops[0].payload_len = 0;
 
+	if (opcode == CEPH_OSD_OP_ZERO || opcode == CEPH_OSD_OP_DELETE) {
+		ops[0].extent.offset = off;
+		ops[0].extent.length = *plen;
+	}
 	if (do_sync) {
 		ops[1].op = CEPH_OSD_OP_STARTSYNC;
 		ops[1].payload_len = 0;
@@ -1181,6 +1187,7 @@ static void handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg,
 	if (req == NULL) {
 		dout("handle_reply tid %llu dne\n", tid);
 		mutex_unlock(&osdc->request_mutex);
+		printk(KERN_INFO"handle pm\n");
 		return;
 	}
 	ceph_osdc_get_request(req);
-- 
1.7.9.5


