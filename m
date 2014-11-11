Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaKKMLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:11:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaKKLJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 017/170] ext4: fix mmap data corruption when blocksize < pagesize
Date: Tue, 11 Nov 2014 11:06:16 +0000
Message-Id: <1415704129-12709-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit d6320cbfc92910a3e5f10c42d98c231c98db4f60 upstream.

Use truncate_isize_extended() when hole is being created in a file so that
->page_mkwrite() will get called for the partial tail page if it is
mmaped (see the first patch in the series for details).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e9c9b5bd906a..14f34b02dde5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4654,8 +4654,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		} else
+		} else {
+			loff_t oldsize = inode->i_size;
+
 			i_size_write(inode, attr->ia_size);
+			pagecache_isize_extended(inode, oldsize, inode->i_size);
+		}
 
 		/*
 		 * Blocks are going to be removed from the inode. Wait
-- 
2.1.0

