Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaAMRLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:11:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaAMQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Filipe David Borba Manana <fdmanana@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/208] Btrfs: fix incorrect inode acl reset
Date: Mon, 13 Jan 2014 15:57:32 +0000
Message-Id: <1389628849-1614-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe David Borba Manana <fdmanana@gmail.com>

commit 8185554d3eb09d23a805456b6fa98dcbb34aa518 upstream.

When a directory has a default ACL and a subdirectory is created
under that directory, btrfs_init_acl() is called when the
subdirectory's inode is created to initialize the inode's ACL
(inherited from the parent directory) but it was clearing the ACL
from the inode after setting it if posix_acl_create() returned
success, instead of clearing it only if it returned an error.

To reproduce this issue:

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt
$ mkdir /mnt/acl
$ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
$ getfacl /mnt/acl
user::rwx
group::rwx
other::r-x
default:user::rwx
default:group::rwx
default:other::---

$ mkdir /mnt/acl/dir1
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---

After unmounting and mounting again the filesystem, fgetacl returned the
expected ACL:

$ umount /mnt/acl
$ mount /dev/loop0 /mnt
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---
default:user::rwx
default:group::rwx
default:other::---

Meaning that the underlying xattr was persisted.

Reported-by: Giuseppe Fierro <giuseppe@fierro.org>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index e15d2b0..0890c83 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -229,7 +229,7 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		if (ret > 0) {
 			/* we need an acl */
 			ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
-		} else {
+		} else if (ret < 0) {
 			cache_no_acl(inode);
 		}
 	} else {
-- 
1.8.3.2

