Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbaKRPXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:23:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbaKROJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergio Gelato <Sergio.Gelato@astro.su.se>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 017/206] nfsd: fix NFS regression
Date: Tue, 18 Nov 2014 15:06:12 +0100
Message-Id: <ba1816b40a87a3f3c4ca9cd54a593a10d87bd391.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergio Gelato <Sergio.Gelato@astro.su.se>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

Fix regression introduced in pre-3.14 kernels by cherry-picking
aa07c713ecfc0522916f3cd57ac628ea6127c0ec (NFSD: Call ->set_acl with a
NULL ACL structure if no entries). This is in v3.12.22 as commit
723ac81c8671b3a095d9eb303974c7bc9964b506.

The affected code was removed in 3.14 by commit
4ac7249ea5a0ceef9f8269f63f33cc873c3fac61 (nfsd: use get_acl
and ->set_acl). The ->set_acl methods are already able to cope with a
NULL argument. So this is not needed for >= 3.14.

Signed-off-by: Sergio Gelato <Sergio.Gelato@astro.su.se>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/vfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e9a80e4553a3..fafac65804d6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -509,6 +509,9 @@ set_nfsv4_acl_one(struct dentry *dentry, struct posix_acl *pacl, char *key)
 	char *buf = NULL;
 	int error = 0;
 
+	if (!pacl)
+		return vfs_setxattr(dentry, key, NULL, 0, 0);
+
 	buflen = posix_acl_xattr_size(pacl->a_count);
 	buf = kmalloc(buflen, GFP_KERNEL);
 	error = -ENOMEM;
-- 
2.1.3

