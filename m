Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaEWJn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:43:59 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34330 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEWJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:43:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 00/13] overlay filesystem v22
Date: Fri, 23 May 2014 11:43:30 +0200
Message-Id: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to propose this for 3.16.

Changes in v22:

 - Whiteout is now a special char device instead of a symlink, this breaks
   compatibility with previous versions.  See attached conversion script (takes
   upperdir as argument).

 - Uses cross-rename to make operations atomic: copy-up, unlink, rename, etc...

 - Added "workdir=" mount option.  Work directory is used to prepare files
   before atomically swithing with destination and needs to be on the same
   filesystem as upperdir.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current

Thanks,
Miklos

---
Andy Whitcroft (1):
      overlayfs: add statfs support

Erez Zadok (1):
      overlayfs: implement show_options

Miklos Szeredi (9):
      vfs: add i_op->dentry_open()
      vfs: export do_splice_direct() to modules
      vfs: export __inode_permission() to modules
      vfs: introduce clone_private_mount()
      vfs: export check_sticky()
      vfs: add whiteout support
      vfs: add RENAME_WHITEOUT
      overlay filesystem
      fs: limit filesystem stacking depth

Neil Brown (1):
      overlay: overlay filesystem documentation

Sedat Dilek (1):
      vfs: dcache: Export d_ancestor to modules

---
 Documentation/filesystems/Locking       |   2 +
 Documentation/filesystems/overlayfs.txt | 198 +++++++
 Documentation/filesystems/vfs.txt       |   7 +
 MAINTAINERS                             |   7 +
 fs/Kconfig                              |   1 +
 fs/Makefile                             |   1 +
 fs/btrfs/ioctl.c                        |  20 +-
 fs/dcache.c                             |   1 +
 fs/ecryptfs/main.c                      |   7 +
 fs/ext4/namei.c                         |  99 +++-
 fs/internal.h                           |   7 -
 fs/namei.c                              |  41 +-
 fs/namespace.c                          |  27 +
 fs/open.c                               |  23 +-
 fs/overlayfs/Kconfig                    |  10 +
 fs/overlayfs/Makefile                   |   7 +
 fs/overlayfs/copy_up.c                  | 427 +++++++++++++++
 fs/overlayfs/dir.c                      | 886 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    | 372 ++++++++++++++
 fs/overlayfs/overlayfs.h                | 185 +++++++
 fs/overlayfs/readdir.c                  | 518 +++++++++++++++++++
 fs/overlayfs/super.c                    | 776 ++++++++++++++++++++++++++++
 fs/splice.c                             |   1 +
 include/linux/fs.h                      |  44 ++
 include/linux/mount.h                   |   3 +
 include/uapi/linux/fs.h                 |   1 +
 26 files changed, 3613 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c


--- overlayfs-fixup.sh ---
#! /bin/bash

upper=$1
tmpdir=`mktemp -d`
tmp=$tmpdir/wh
find "$upper" -type l -print0 | while IFS= read -r -d $'\0' name; do
	iswh=`getfattr -h -ntrusted.overlay.whiteout --only-values "$name" 2> /dev/null`
	if test "$iswh" = y; then
		echo "changing whiteout <$name> from symlink to chardev"
		mknod -m0 $tmp c 0 0
		mv -f $tmp "$name"
	fi
done
rmdir $tmpdir
