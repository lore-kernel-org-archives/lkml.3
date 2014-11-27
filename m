Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaK0IyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:54:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:42770 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbaK0Itx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:53 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergio Gelato <Sergio.Gelato@astro.su.se>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 78/91] NFS: fix stable regression
Date: Thu, 27 Nov 2014 16:43:01 +0800
Message-Id: <1417077794-9299-78-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergio Gelato <Sergio.Gelato@astro.su.se>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


BugLink: http://bugs.launchpad.net/bugs/1348670

Fix regression introduced in pre-3.14 kernels by cherry-picking
aa07c713ecfc0522916f3cd57ac628ea6127c0ec
(NFSD: Call ->set_acl with a NULL ACL structure if no entries).

The affected code was removed in 3.14 by commit
4ac7249ea5a0ceef9f8269f63f33cc873c3fac61
(nfsd: use get_acl and ->set_acl).
The ->set_acl methods are already able to cope with a NULL argument.

Signed-off-by: Sergio Gelato <Sergio.Gelato@astro.su.se>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/nfsd/vfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e3abfde..36620e6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -508,6 +508,9 @@ set_nfsv4_acl_one(struct dentry *dentry, struct posix_acl *pacl, char *key)
 	char *buf = NULL;
 	int error = 0;
 
+	if (!pacl)
+		return vfs_setxattr(dentry, key, NULL, 0, 0);
+
 	buflen = posix_acl_xattr_size(pacl->a_count);
 	buf = kmalloc(buflen, GFP_KERNEL);
 	error = -ENOMEM;
-- 
1.9.1

