Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaDCNtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:49:33 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:37759 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaDCNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:49:29 -0400
Date: Thu, 3 Apr 2014 15:49:24 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] renameat2 syscall
Message-ID: <20140403134924.GC10187@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I think I addressed all issues with this series:

 - i_mutex on non-directories being moved needed for NFS
 - split ext4_rename() into cross-rename/plain-rename functions
 - split i_op->rename(), it's certainly easier to maintain pre merge, then we'll
   see
 - xfstests validation added
 - whiteout patch added (but not in this pull)

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename

Thanks,
Miklos
---

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
---

J. Bruce Fields (1):
      vfs: lock_two_nondirectories: allow directory args

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
 Documentation/filesystems/Locking                  |   6 +-
 Documentation/filesystems/vfs.txt                  |  16 +
 arch/x86/syscalls/syscall_64.tbl                   |   1 +
 .../lustre/lustre/include/linux/lustre_compat25.h  |   4 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   2 +-
 fs/cachefiles/namei.c                              |   4 +-
 fs/dcache.c                                        |  50 ++-
 fs/ecryptfs/inode.c                                |   2 +-
 fs/ext4/namei.c                                    | 480 +++++++++++++++------
 fs/inode.c                                         |  25 +-
 fs/namei.c                                         | 315 +++++++-------
 fs/nfsd/vfs.c                                      |   2 +-
 include/linux/dcache.h                             |   8 +-
 include/linux/fs.h                                 |   4 +-
 include/linux/security.h                           |  12 +-
 include/uapi/linux/fs.h                            |   3 +
 security/security.c                                |  22 +-
 17 files changed, 643 insertions(+), 313 deletions(-)
