Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbbA0GRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:17:42 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45023 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbA0GRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:17:40 -0500
From: Omar Sandoval <osandov@osandov.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] posix_acl: fix reference leaks in posix_acl_create
Date: Mon, 26 Jan 2015 22:16:53 -0800
Message-Id: <0d8672e771b8fc1fef94db4b40b418afc8763c2b.1422338890.git.osandov@osandov.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_acl gets a reference which we must release in the error cases.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/posix_acl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 0855f77..f8f3cc2 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -555,28 +555,31 @@ posix_acl_create(struct inode *dir, umode_t *mode,
 	p = get_acl(dir, ACL_TYPE_DEFAULT);
 	if (IS_ERR(p)) {
 		if (p == ERR_PTR(-EOPNOTSUPP))
 			goto apply_umask;
 		return PTR_ERR(p);
 	}
 
 	if (!p)
 		goto apply_umask;
 
 	*acl = posix_acl_clone(p, GFP_NOFS);
-	if (!*acl)
+	if (!*acl) {
+		posix_acl_release(p);
 		return -ENOMEM;
+	}
 
 	ret = posix_acl_create_masq(*acl, mode);
 	if (ret < 0) {
 		posix_acl_release(*acl);
+		posix_acl_release(p);
 		return -ENOMEM;
 	}
 
 	if (ret == 0) {
 		posix_acl_release(*acl);
 		*acl = NULL;
 	}
 
 	if (!S_ISDIR(*mode)) {
 		posix_acl_release(p);
 		*default_acl = NULL;
-- 
2.2.2

