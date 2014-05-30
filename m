Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604AbaE3UKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:10:25 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:65129 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432AbaE3UKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:10:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Subject: [RFC 30/32] fuse: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:54 +0200
Message-Id: <1401480116-1973111-31-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2cybtpbPYSN4uH5er5uurC3ih14wHYKHcUKwaJo7o03
 GbdfMXTcmms0DteFY80LcfEAUiNp7IKwhWxhLXnJVNfCfNxyqb
 Gl190SguEVq09JbvQijtXPG01qxM5EH7+Ke21oNBk++9SW0Km6
 Gf0dN+T+Rv7tYGyOBHbNF2t09pwgLrEeGYMZivp7kxZCOaSSoO
 wG5SkkummiokxHLX9My80EaJdQp2Frg9uAKEBPTg/Q2DYFR5LD
 2gxVmy8HJf7hYPZrUFVvCi3la6B4WwuMG+yMC4kleBjOHOsD5o
 z4VVjRqpjUSPhJOeDycnPwLdmR8OObL/NKGDlqZwJAPV2weuKJ
 6/Azo1rumvseg26/bPeFs7kEburhId/YB80X2Gt1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse uses 64-bit seconds for inode timestamps in the user interface,
which will work basically forever, but the VFS uses struct timespec
for timestamps, which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in fuse.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
---
 fs/fuse/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 754dcf2..58f138e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -203,7 +203,7 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	bool is_wb = fc->writeback_cache;
 	loff_t oldsize;
-	struct timespec old_mtime;
+	struct inode_time old_mtime;
 
 	spin_lock(&fc->lock);
 	if ((attr_version != 0 && fi->attr_version > attr_version) ||
@@ -232,7 +232,7 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 			truncate_pagecache(inode, attr->size);
 			inval = true;
 		} else if (fc->auto_inval_data) {
-			struct timespec new_mtime = {
+			struct inode_time new_mtime = {
 				.tv_sec = attr->mtime,
 				.tv_nsec = attr->mtimensec,
 			};
@@ -241,7 +241,7 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 			 * Auto inval mode also checks and invalidates if mtime
 			 * has changed.
 			 */
-			if (!timespec_equal(&old_mtime, &new_mtime))
+			if (!inode_time_equal(&old_mtime, &new_mtime))
 				inval = true;
 		}
 
-- 
1.8.3.2

