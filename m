Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab3HOECY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 00:02:24 -0400
Received: from m199-177.yeah.net ([123.58.177.199]:47777 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3HOECW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 00:02:22 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Aug 2013 00:02:22 EDT
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH v5] Ceph: Punch hole support for kernel client
Date: Thu, 15 Aug 2013 11:51:44 +0800
Message-Id: <1376538704-6659-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUhNVU9JQkJCTU9CS09MQ05KTVdZCQ4XHghZQVkoKz0kKzooKCQyNSQz
	Pjo*PilBTlVJTk1ANiMkIj4oJDI1JDM#Oj8#KUFLVUhPSUArLykkNTQkMjUkMz46Pz4pQUlVQ05D
	QDg0LjUvKSIkODVBS1VJTUNAKT48MjQ1JDooMjpBSFVPT01AKyk0LTI1OD4kMy41OjVBQlVCSk5A
	PyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VMQ0JAPzAyNiQ1NDU#QUtVS0ApPjo3JDIrJDI1JCk5
	NyQyNSQzPjo*PilBTFVLS0NANi43LzIkKTgrLyQ*Mj09Pik#NS8kMjUkMz46Pz4pQU9VS0tJQDIr
	JEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDIrJE4kNjI1
	Li8#JDg1LyRLJEpLQUtVS0AyKyQvND86IiQ4NS8kSyRKS0tBS1VMSk1AMiskSiQzNC4pJDg1LyRL
	JEpLS0FLVUtAKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSExNTkhDTEpOS01DVTMWGhIX
	VRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHgY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements fallocate and punch hole support for Ceph kernel client.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
Against v3:

Passed the fsx test from xfstests.

Truncate rather than delete the first object. Thanks go to Sage and Zheng for the explanation.

Silence the OSD ENOENT complaints.
---
 fs/ceph/file.c        |  196 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c |   11 ++-
 2 files changed, 205 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 2ddf061..e2bcd5c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -8,6 +8,7 @@
 #include <linux/namei.h>
 #include <linux/writeback.h>
 #include <linux/aio.h>
+#include <linux/falloc.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -871,6 +872,200 @@ out:
 	return offset;
 }
 
+static inline void ceph_zero_partial_page(
+	struct inode *inode, loff_t offset, unsigned size)
+{
+	struct page *page;
+	pgoff_t index = offset >> PAGE_CACHE_SHIFT;
+
+	page = find_lock_page(inode->i_mapping, index);
+	if (page) {
+		wait_on_page_writeback(page);
+		zero_user(page, offset & (PAGE_CACHE_SIZE - 1), size);
+		unlock_page(page);
+		page_cache_release(page);
+	}
+}
+
+static void ceph_zero_pagecache_range(struct inode *inode, loff_t offset,
+				      loff_t length)
+{
+	loff_t nearly = round_up(offset, PAGE_CACHE_SIZE);
+	if (offset < nearly) {
+		loff_t size = nearly - offset;
+		if (length < size)
+			size = length;
+		ceph_zero_partial_page(inode, offset, size);
+		offset += size;
+		length -= size;
+	}
+	if (length >= PAGE_CACHE_SIZE) {
+		loff_t size = round_down(length, PAGE_CACHE_SIZE);
+		truncate_pagecache_range(inode, offset, offset + size - 1);
+		offset += size;
+		length -= size;
+	}
+	if (length)
+		ceph_zero_partial_page(inode, offset, length);
+}
+
+static int ceph_zero_partial_object(struct inode *inode,
+				    loff_t offset, loff_t *length)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_osd_request *req;
+	int ret = 0;
+	loff_t zero = 0;
+	int op;
+
+	if (!length) {
+		op = offset ? CEPH_OSD_OP_DELETE : CEPH_OSD_OP_TRUNCATE;
+		length = &zero;
+	} else {
+		op = CEPH_OSD_OP_ZERO;
+	}
+
+	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
+					ceph_vino(inode),
+					offset, length,
+					1, op,
+					CEPH_OSD_FLAG_WRITE |
+					CEPH_OSD_FLAG_ONDISK,
+					NULL, 0, 0, false);
+	if (IS_ERR(req)) {
+		ret = PTR_ERR(req);
+		goto out;
+	}
+
+	ceph_osdc_build_request(req, offset, NULL, ceph_vino(inode).snap,
+				&inode->i_mtime);
+
+	ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
+	if (!ret) {
+		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+		if (ret == -ENOENT)
+			ret = 0;
+	}
+	ceph_osdc_put_request(req);
+
+out:
+	return ret;
+}
+
+static int ceph_zero_objects(struct inode *inode, loff_t offset, loff_t length)
+{
+	int ret = 0;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	__s32 stripe_unit = ceph_file_layout_su(ci->i_layout);
+	__s32 stripe_count = ceph_file_layout_stripe_count(ci->i_layout);
+	__s32 object_size = ceph_file_layout_object_size(ci->i_layout);
+	loff_t object_set_size = (loff_t)object_size * stripe_count;
+
+	loff_t nearly = (offset + object_set_size - 1)
+			/ object_set_size * object_set_size;
+	while (length && offset < nearly) {
+		loff_t size = length;
+		ret = ceph_zero_partial_object(inode, offset, &size);
+		if (ret < 0)
+			return ret;
+		offset += size;
+		length -= size;
+	}
+	while (length >= object_set_size) {
+		int i;
+		loff_t pos = offset;
+		for (i = 0; i < stripe_count; ++i) {
+			ret = ceph_zero_partial_object(inode, pos, NULL);
+			if (ret < 0)
+				return ret;
+			pos += stripe_unit;
+		}
+		offset += object_set_size;
+		length -= object_set_size;
+	}
+	while (length) {
+		loff_t size = length;
+		ret = ceph_zero_partial_object(inode, offset, &size);
+		if (ret < 0)
+			return ret;
+		offset += size;
+		length -= size;
+	}
+	return ret;
+}
+
+static long ceph_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t length)
+{
+	struct ceph_file_info *fi = file->private_data;
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_osd_client *osdc =
+		&ceph_inode_to_client(inode)->client->osdc;
+	int want, got = 0;
+	int dirty;
+	int ret = 0;
+	loff_t endoff = 0;
+	loff_t size;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (IS_SWAPFILE(inode))
+		return -ETXTBSY;
+
+	mutex_lock(&inode->i_mutex);
+
+	if (ceph_snap(inode) != CEPH_NOSNAP) {
+		ret = -EROFS;
+		goto unlock;
+	}
+
+	if (ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_FULL) &&
+		!(mode & FALLOC_FL_PUNCH_HOLE)) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
+
+	size = i_size_read(inode);
+	if (!(mode & FALLOC_FL_KEEP_SIZE))
+		endoff = offset + length;
+
+	if (fi->fmode & CEPH_FILE_MODE_LAZY)
+		want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
+	else
+		want = CEPH_CAP_FILE_BUFFER;
+
+	ret = ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, &got, endoff);
+	if (ret < 0)
+		goto unlock;
+
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		if (offset < size)
+			ceph_zero_pagecache_range(inode, offset, length);
+		ret = ceph_zero_objects(inode, offset, length);
+	} else if (endoff > size) {
+		truncate_pagecache_range(inode, size, -1);
+		if (ceph_inode_set_size(inode, endoff))
+			ceph_check_caps(ceph_inode(inode),
+				CHECK_CAPS_AUTHONLY, NULL);
+	}
+
+	if (!ret) {
+		spin_lock(&ci->i_ceph_lock);
+		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR);
+		spin_unlock(&ci->i_ceph_lock);
+		if (dirty)
+			__mark_inode_dirty(inode, dirty);
+	}
+
+	ceph_put_cap_refs(ci, got);
+unlock:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
 const struct file_operations ceph_file_fops = {
 	.open = ceph_open,
 	.release = ceph_release,
@@ -887,5 +1082,6 @@ const struct file_operations ceph_file_fops = {
 	.splice_write = generic_file_splice_write,
 	.unlocked_ioctl = ceph_ioctl,
 	.compat_ioctl	= ceph_ioctl,
+	.fallocate	= ceph_fallocate,
 };
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index dd47889..c1d15ab 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -503,7 +503,9 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
 	struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which, opcode);
 	size_t payload_len = 0;
 
-	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE);
+	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
+	       opcode != CEPH_OSD_OP_DELETE && opcode != CEPH_OSD_OP_ZERO &&
+	       opcode != CEPH_OSD_OP_TRUNCATE);
 
 	op->extent.offset = offset;
 	op->extent.length = length;
@@ -631,6 +633,9 @@ static u64 osd_req_encode_op(struct ceph_osd_request *req,
 		break;
 	case CEPH_OSD_OP_READ:
 	case CEPH_OSD_OP_WRITE:
+	case CEPH_OSD_OP_ZERO:
+	case CEPH_OSD_OP_DELETE:
+	case CEPH_OSD_OP_TRUNCATE:
 		if (src->op == CEPH_OSD_OP_WRITE)
 			request_data_len = src->extent.length;
 		dst->extent.offset = cpu_to_le64(src->extent.offset);
@@ -715,7 +720,9 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	u64 object_base;
 	int r;
 
-	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE);
+	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
+	       opcode != CEPH_OSD_OP_DELETE && opcode != CEPH_OSD_OP_ZERO &&
+	       opcode != CEPH_OSD_OP_TRUNCATE);
 
 	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
 					GFP_NOFS);
-- 
1.7.9.5

