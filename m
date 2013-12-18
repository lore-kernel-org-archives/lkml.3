Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3LRVTC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:19:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3LRVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Giuseppe Fierro <giuseppe@fierro.org>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 110/118] Btrfs: fix incorrect inode acl reset
Date: Wed, 18 Dec 2013 13:12:27 -0800
Message-Id: <20131218211222.574541717@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -229,7 +229,7 @@ int btrfs_init_acl(struct btrfs_trans_ha
 		if (ret > 0) {
 			/* we need an acl */
 			ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
-		} else {
+		} else if (ret < 0) {
 			cache_no_acl(inode);
 		}
 	} else {


