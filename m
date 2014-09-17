Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbaIQWcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:32:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbaIQWcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:32:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] CacheFiles: Handle rename2
From: David Howells <dhowells@redhat.com>
To: milosz@adfin.com
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Sep 2014 23:31:55 +0100
Message-ID: <20140917223155.1196.63881.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all filesystems now provide the rename i_op - ext4 for one - but rather
provide the rename2 i_op.  CacheFiles checks that the filesystem has rename
and so will reject ext4 now with EPERM:

	CacheFiles: Failed to register: -1

Fix this by checking for rename2 as an alternative.  The call to vfs_rename()
actually handles selection of the appropriate function, so we needn't worry
about that.

Turning on debugging shows:

	[cachef] ==> cachefiles_get_directory(,,cache)
	[cachef] subdir -> ffff88000b22b778 positive
	[cachef] <== cachefiles_get_directory() = -1 [check]

where -1 is EPERM.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 5bf2b41e66d3..83e9c94ca2cf 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -779,7 +779,8 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	    !subdir->d_inode->i_op->lookup ||
 	    !subdir->d_inode->i_op->mkdir ||
 	    !subdir->d_inode->i_op->create ||
-	    !subdir->d_inode->i_op->rename ||
+	    (!subdir->d_inode->i_op->rename &&
+	     !subdir->d_inode->i_op->rename2) ||
 	    !subdir->d_inode->i_op->rmdir ||
 	    !subdir->d_inode->i_op->unlink)
 		goto check_error;

