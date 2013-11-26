Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3KZIjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:39:37 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:14415 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3KZIjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:39:36 -0500
From: Rui Xiang <rui.xiang@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 1/2] romfs: fix returm err while getting inode in fill_super
Date: Tue, 26 Nov 2013 16:39:08 +0800
Message-ID: <1385455149-20752-1-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting an inode by romfs_iget may lead to an err in fill_super,
and the err value should be return.

And it should return -ENOMEM instead while d_make_root fails,
fix it too.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 fs/romfs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index ff1d3d4..d841878 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -533,16 +533,14 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	root = romfs_iget(sb, pos);
 	if (IS_ERR(root))
-		goto error;
+		return PTR_ERR(root);
 
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root)
-		goto error;
+		return -ENOMEM;
 
 	return 0;
 
-error:
-	return -EINVAL;
 error_rsb_inval:
 	ret = -EINVAL;
 error_rsb:
-- 
1.8.2.2


