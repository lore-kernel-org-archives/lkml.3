Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaGYEz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:55:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22462 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGYEz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:55:56 -0400
X-AuditID: cbfee61b-f79f86d00000144c-70-53d1e35af88f
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2] f2fs: fix to put root inode in error path of
 fill_super
Date: Fri, 25 Jul 2014 12:55:09 +0800
Message-id: <003b01cfa7c4$b7408040$25c180c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+nxIwPZzAYdamCTKSNb7+cSAJ/Tg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd2oxxeDDc5PULG4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxssJC1gK
	/rBWPL3ylqmB8RVLFyMnh4SAicS8d/uZIWwxiQv31rN1MXJxCAksYpS4/f8WE4Tzg1Gi9+4N
	sCo2ARWJ5R3/mUBsEQEviUn7T4BNYhbwkGjs+M4KYgsLREhs33oIrIZFQFViw8STYDavgKXE
	uzn72CFsQYkfk+9B9WpJrN95nAnClpfYvOYt1EUKEjvOvmaE2KUn0b5rEjNEjbjExiO3WCYw
	CsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgoH4mvYNxVYPF
	IUYBDkYlHt6O+ovBQqyJZcWVuYcYJTiYlUR4ZR4AhXhTEiurUovy44tKc1KLDzFKc7AoifMe
	bLUOFBJITyxJzU5NLUgtgskycXBKNTD2ZbydKCMUyvd+sfjd3vTFtxSKK1fqSoV1lj8oyLeZ
	tjo6bIJIn0Rc9OoYTae3vksK325at6b8l+V5I4bsBbwlCiXe0pyOpSEvPBmO9b4Otlx+yNbA
	zdJs7sF/sbzn22vv6nwIPZG7NyjllUfdKqfr++L+LU1pNXy5tnR/WvyO4wGz7ZdcOKnEUpyR
	aKjFXFScCACCITObZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should put root inode correctly in error path of fill_super, otherwise we
may encounter a leak case of inode resource.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 870fe19..34649aa 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1033,8 +1033,9 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_node_inode;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
+		iput(root);
 		err = -EINVAL;
-		goto free_root_inode;
+		goto free_node_inode;
 	}
 
 	sb->s_root = d_make_root(root); /* allocate root dentry */
-- 
2.0.1.474.g72c7794


