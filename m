Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaAWI4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:56:05 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:49411 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaAWI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:56:03 -0500
Date: Thu, 23 Jan 2014 09:56:56 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] rename2 syscall
Message-ID: <20140123085656.GK24171@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please consider pulling the cross-rename patches.  The git tree has a
conflict in arch/x86/syscalls/syscall_64.tbl where the syscall number needs to
be fixed.  The patchset has been reviewed by Jan Kara and the man page and
usperpace API by Michael Kerrisk.

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename

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

Thanks,
Miklos
----

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
 drivers/staging/lustre/lustre/llite/namei.c        |   3 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   2 +-
 fs/9p/v9fs.h                                       |   3 +-
 fs/9p/vfs_inode.c                                  |   4 +-
 fs/affs/affs.h                                     |   3 +-
 fs/affs/namei.c                                    |   3 +-
 fs/afs/dir.c                                       |   6 +-
 fs/bad_inode.c                                     |   3 +-
 fs/bfs/dir.c                                       |   3 +-
 fs/btrfs/inode.c                                   |   3 +-
 fs/cachefiles/namei.c                              |   4 +-
 fs/ceph/dir.c                                      |   3 +-
 fs/cifs/cifsfs.h                                   |   2 +-
 fs/cifs/inode.c                                    |   3 +-
 fs/coda/dir.c                                      |   8 +-
 fs/dcache.c                                        |  46 ++-
 fs/debugfs/inode.c                                 |   2 +-
 fs/ecryptfs/inode.c                                |   5 +-
 fs/exofs/namei.c                                   |   3 +-
 fs/ext2/namei.c                                    |   5 +-
 fs/ext3/namei.c                                    |   5 +-
 fs/ext4/namei.c                                    | 396 ++++++++++++++-------
 fs/ext4/super.c                                    |   6 +-
 fs/f2fs/namei.c                                    |   3 +-
 fs/fat/namei_msdos.c                               |   3 +-
 fs/fat/namei_vfat.c                                |   3 +-
 fs/fuse/dir.c                                      |   3 +-
 fs/gfs2/inode.c                                    |   3 +-
 fs/hfs/dir.c                                       |   3 +-
 fs/hfsplus/dir.c                                   |   3 +-
 fs/hostfs/hostfs_kern.c                            |   5 +-
 fs/hpfs/namei.c                                    |   3 +-
 fs/jffs2/dir.c                                     |   5 +-
 fs/jfs/namei.c                                     |   3 +-
 fs/libfs.c                                         |   3 +-
 fs/logfs/dir.c                                     |   3 +-
 fs/minix/namei.c                                   |   5 +-
 fs/namei.c                                         | 317 +++++++++--------
 fs/ncpfs/dir.c                                     |   5 +-
 fs/nfs/dir.c                                       |   3 +-
 fs/nfs/internal.h                                  |   3 +-
 fs/nfsd/vfs.c                                      |   2 +-
 fs/nilfs2/namei.c                                  |   3 +-
 fs/ocfs2/namei.c                                   |   3 +-
 fs/omfs/dir.c                                      |   3 +-
 fs/reiserfs/namei.c                                |   3 +-
 fs/sysv/namei.c                                    |   5 +-
 fs/ubifs/dir.c                                     |   3 +-
 fs/udf/namei.c                                     |   3 +-
 fs/ufs/namei.c                                     |   3 +-
 fs/xfs/xfs_iops.c                                  |   3 +-
 include/linux/dcache.h                             |   8 +-
 include/linux/fs.h                                 |   7 +-
 include/linux/security.h                           |  12 +-
 include/uapi/linux/fs.h                            |   3 +
 kernel/cgroup.c                                    |   5 +-
 mm/shmem.c                                         |   2 +-
 security/security.c                                |  22 +-
 62 files changed, 631 insertions(+), 367 deletions(-)
