Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaAHWJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:09:43 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:47866 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbaAHWJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:09:41 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 00/11] cross rename v3
Date: Wed,  8 Jan 2014 23:10:04 +0100
Message-Id: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Only cosmetic changes from v2 based on Jan Kara's review]

This series adds a new syscall, renameat2(), which is the same as renameat() but
with a flags argument.

The purpose of extending rename is to add cross-rename, a symmetric variant of
rename, which exchanges the two files.  This allows interesting things, which
were not possible before, for example atomically replacing a directory tree with
a symlink, etc...  This also allows overlayfs and friends to operate on
whiteouts atomically.

Andy Lutomirski also suggested a "noreplace" flag, which disables the
overwriting behavior of rename.

These two flags, RENAME_EXCHANGE and RENAME_NOREPLACE are only implemented for
ext4 as an example and for testing.

Implementing RENAME_NOREPLACE for other local (disk or ram based) filesystems is
trivial: just don't fail with -EOPNOTSUPP, the rest is done by the VFS.  Network
filesystems need special treatment to avoid creation races.


Please consider for -next (3.14).

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename

Thanks,
Miklos

---
Miklos Szeredi (11):
      vfs: add d_is_dir()
      vfs: rename: move d_move() up
      vfs: rename: use common code for dir and non-dir
      vfs: add renameat2 syscall
      vfs: add RENAME_NOREPLACE flag
      security: add flags to rename hooks
      vfs: add cross-rename
      ext4: rename: create ext4_renament structure for local vars
      ext4: rename: move EMLINK check up
      ext4: rename: split out helper functions
      ext4: add cross rename support

---
 Documentation/filesystems/Locking                  |   2 +-
 Documentation/filesystems/vfs.txt                  |   4 +-
 arch/x86/syscalls/syscall_64.tbl                   |   1 +
 .../lustre/lustre/include/linux/lustre_compat25.h  |   4 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   7 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   2 +-
 fs/9p/v9fs.h                                       |   3 +-
 fs/9p/vfs_inode.c                                  |   7 +-
 fs/affs/affs.h                                     |   3 +-
 fs/affs/namei.c                                    |   6 +-
 fs/afs/dir.c                                       |   9 +-
 fs/bad_inode.c                                     |   3 +-
 fs/bfs/dir.c                                       |   6 +-
 fs/btrfs/inode.c                                   |   6 +-
 fs/cachefiles/namei.c                              |   4 +-
 fs/ceph/dir.c                                      |   6 +-
 fs/cifs/cifsfs.h                                   |   2 +-
 fs/cifs/inode.c                                    |   6 +-
 fs/coda/dir.c                                      |  11 +-
 fs/dcache.c                                        |  46 ++-
 fs/debugfs/inode.c                                 |   2 +-
 fs/ecryptfs/inode.c                                |   8 +-
 fs/exofs/namei.c                                   |   6 +-
 fs/ext2/namei.c                                    |   8 +-
 fs/ext3/namei.c                                    |   8 +-
 fs/ext4/namei.c                                    | 395 ++++++++++++++-------
 fs/f2fs/namei.c                                    |   6 +-
 fs/fat/namei_msdos.c                               |   6 +-
 fs/fat/namei_vfat.c                                |   6 +-
 fs/fuse/dir.c                                      |   9 +-
 fs/gfs2/inode.c                                    |   6 +-
 fs/hfs/dir.c                                       |   6 +-
 fs/hfsplus/dir.c                                   |   6 +-
 fs/hostfs/hostfs_kern.c                            |   8 +-
 fs/hpfs/namei.c                                    |   6 +-
 fs/jffs2/dir.c                                     |   8 +-
 fs/jfs/namei.c                                     |   5 +-
 fs/libfs.c                                         |   6 +-
 fs/logfs/dir.c                                     |   6 +-
 fs/minix/namei.c                                   |   8 +-
 fs/namei.c                                         | 316 +++++++++--------
 fs/ncpfs/dir.c                                     |   8 +-
 fs/nfs/dir.c                                       |   6 +-
 fs/nfs/internal.h                                  |   3 +-
 fs/nfsd/vfs.c                                      |   2 +-
 fs/nilfs2/namei.c                                  |   6 +-
 fs/ocfs2/namei.c                                   |   6 +-
 fs/omfs/dir.c                                      |   6 +-
 fs/reiserfs/namei.c                                |   6 +-
 fs/sysv/namei.c                                    |   8 +-
 fs/ubifs/dir.c                                     |   6 +-
 fs/udf/namei.c                                     |   6 +-
 fs/ufs/namei.c                                     |   6 +-
 fs/xfs/xfs_iops.c                                  |   6 +-
 include/linux/dcache.h                             |   8 +-
 include/linux/fs.h                                 |   6 +-
 include/linux/security.h                           |  12 +-
 include/uapi/linux/fs.h                            |   3 +
 kernel/cgroup.c                                    |   8 +-
 mm/shmem.c                                         |   5 +-
 security/security.c                                |  22 +-
 61 files changed, 746 insertions(+), 366 deletions(-)


