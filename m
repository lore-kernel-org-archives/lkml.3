Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaIOKDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:03:02 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51180 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaIOKDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:03:00 -0400
X-AuditID: cbfee61a-f79e46d00000134f-b1-5416b9527759
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/5] f2fs: fix to truncate blocks past EOF in
 ->setattr
Date: Mon, 15 Sep 2014 18:02:09 +0800
Message-id: <002e01cfd0cc$3a47bf00$aed73d00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/MEXk+Fw5msuGJSAeVqrwOULolEA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd2gnWIhBpu22Vhc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY+v0GcwF
	rdwV51t72BsY33J0MXJwSAiYSCyZbt3FyAlkiklcuLeerYuRi0NIYDqjxLRF/YwQzg9GiS2P
	17KAVLEJqEgs7/jPBGKLCHhJTNp/AizOLOAh0djxnRXEFhYIlmiZtRHMZhFQlWh9s4YZxOYV
	sJTY3/+GEcIWlPgx+R5Ur5bE+p3HmSBseYnNa94yQ1ykILHj7GtGiF16EgcufmKDqBGX2Hjk
	FssERoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNLPpHYw
	rmywOMQowMGoxMNb0CcWIsSaWFZcmXuIUYKDWUmEd+pWoBBvSmJlVWpRfnxRaU5q8SFGaQ4W
	JXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQZGS6YMic+dDQIBhhFTrvNcNwlL9Re5t3WLvoPh
	vzPKe94WxjozqrlzXX1s0MKlkb12fp3v66i03GChhyWPMgRPTqi/HuTts0Hj2fx3hQ6zvt2o
	5a3prE0vrHJYeyfx5e7I+ru3vt/KYtKY2WF5t+/NpsgTD3blJL2QC0x+dnue5o5ALp1gzvNK
	LMUZiYZazEXFiQBSl41GZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using FALLOC_FL_KEEP_SIZE in ->fallocate of f2fs, we can fallocate block past
EOF without changing i_size of inode. These blocks past EOF will not be
truncated in ->setattr as we truncate them only when change the file size.

We should give a chance to truncate blocks out of filesize in setattr().

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/file.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c9a1295..7b34101 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -547,15 +547,22 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	if (err)
 		return err;
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-			attr->ia_size != i_size_read(inode)) {
+	if (attr->ia_valid & ATTR_SIZE) {
 		err = f2fs_convert_inline_data(inode, attr->ia_size, NULL);
 		if (err)
 			return err;
 
-		truncate_setsize(inode, attr->ia_size);
-		f2fs_truncate(inode);
-		f2fs_balance_fs(F2FS_I_SB(inode));
+		if (attr->ia_size != i_size_read(inode)) {
+			truncate_setsize(inode, attr->ia_size);
+			f2fs_truncate(inode);
+			f2fs_balance_fs(F2FS_I_SB(inode));
+		} else {
+			/*
+			 * giving a chance to truncate blocks past EOF which
+			 * are fallocated with FALLOC_FL_KEEP_SIZE.
+			 */
+			f2fs_truncate(inode);
+		}
 	}
 
 	__setattr_copy(inode, attr);
-- 
2.0.1.474.g72c7794


