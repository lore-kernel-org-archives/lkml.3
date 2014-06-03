Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaFCLt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:49:27 -0400
Received: from relay.parallels.com ([195.214.232.42]:52026 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaFCLtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:49:05 -0400
Subject: [PATCH] fuse: do not evict dirty inodes
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 03 Jun 2014 15:49:00 +0400
Message-ID: <20140603114827.3188.35705.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1e18bda8 added .write_inode method to the fuse super_operations. This
allowed fuse to use the kernel infrastructure for writing out dirty metadata
(mtime and ctime for now). However, given that .drop_inode was not redefined
from the legacy generic_delete_inode(), on umount(2) generic_shutdown_super()
led to the eviction of all inodes disregarding their state.

The patch removes .drop_inode definition from the fuse super_operations. This
works because now iput_final() calls generic_drop_inode() and returns w/o
evicting inode. This, in turn, allows generic_shutdown_super() to write dirty
inodes by calling sync_filesystem().

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 754dcf2..ee017be 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -791,7 +791,6 @@ static const struct super_operations fuse_super_operations = {
 	.destroy_inode  = fuse_destroy_inode,
 	.evict_inode	= fuse_evict_inode,
 	.write_inode	= fuse_write_inode,
-	.drop_inode	= generic_delete_inode,
 	.remount_fs	= fuse_remount_fs,
 	.put_super	= fuse_put_super,
 	.umount_begin	= fuse_umount_begin,

