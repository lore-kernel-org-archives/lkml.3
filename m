Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaAONuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:50:24 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57742 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaAONuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:50:21 -0500
Date: Wed, 15 Jan 2014 14:50:58 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 04/11] vfs: add renameat2 syscall
Message-ID: <20140115135058.GE24171@tucsk.piliscsaba.szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-5-git-send-email-miklos@szeredi.hu>
 <201401150711.AHB52169.VMSFFLtHQFOOOJ@I-love.SAKURA.ne.jp>
 <20140115103032.GD24171@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115103032.GD24171@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 11:30:32AM +0100, Miklos Szeredi wrote:
> On Wed, Jan 15, 2014 at 07:11:16AM +0900, Tetsuo Handa wrote:

> > 
> > 	if (!(old_dir->i_op->supported_features & flags))
> > 		return -EOPNOTSUPP;
> 
> Or rather old_dir->i_sb->s_type->fs_flags.  We access it due to
> FS_RENAME_DOES_D_MOVE anyway.
> 
> I like this variant, because now filesystems need to explicitly add a flag to
> *enable* the functionality and not a check to disable it.

Since there were a few changes to the series since posting, I pushed the updated
patchset to

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename

Thanks for the reviews.

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

