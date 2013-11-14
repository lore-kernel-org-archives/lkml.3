Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3KNQOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:14:34 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43060 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3KNQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:14:22 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/40] staging/lustre/llite: restore ll_fiemap
Date: Fri, 15 Nov 2013 00:13:03 +0800
Message-Id: <1384445622-12346-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

It was removed by coan by mistake when first porting the code.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |   33 ++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index fb85a58..c5b721c 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2628,6 +2628,38 @@ int ll_getattr(struct vfsmount *mnt, struct dentry *de, struct kstat *stat)
 	return ll_getattr_it(mnt, de, &it, stat);
 }
 
+int ll_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		__u64 start, __u64 len)
+{
+	int rc;
+	size_t num_bytes;
+	struct ll_user_fiemap *fiemap;
+	unsigned int extent_count = fieinfo->fi_extents_max;
+
+	num_bytes = sizeof(*fiemap) + (extent_count *
+				       sizeof(struct ll_fiemap_extent));
+	OBD_ALLOC_LARGE(fiemap, num_bytes);
+
+	if (fiemap == NULL)
+		return -ENOMEM;
+
+	fiemap->fm_flags = fieinfo->fi_flags;
+	fiemap->fm_extent_count = fieinfo->fi_extents_max;
+	fiemap->fm_start = start;
+	fiemap->fm_length = len;
+	memcpy(&fiemap->fm_extents[0], fieinfo->fi_extents_start,
+	       sizeof(struct ll_fiemap_extent));
+
+	rc = ll_do_fiemap(inode, fiemap, num_bytes);
+
+	fieinfo->fi_flags = fiemap->fm_flags;
+	fieinfo->fi_extents_mapped = fiemap->fm_mapped_extents;
+	memcpy(fieinfo->fi_extents_start, &fiemap->fm_extents[0],
+	       fiemap->fm_mapped_extents * sizeof(struct ll_fiemap_extent));
+
+	OBD_FREE_LARGE(fiemap, num_bytes);
+	return rc;
+}
 
 struct posix_acl * ll_get_acl(struct inode *inode, int type)
 {
@@ -2740,6 +2772,7 @@ struct inode_operations ll_file_inode_operations = {
 	.getxattr	= ll_getxattr,
 	.listxattr	= ll_listxattr,
 	.removexattr	= ll_removexattr,
+	.fiemap		= ll_fiemap,
 	.get_acl	= ll_get_acl,
 };
 
-- 
1.7.9.5

