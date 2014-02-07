Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBGWqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:46:35 -0500
Received: from fieldses.org ([174.143.236.118]:41682 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbaBGWqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:46:33 -0500
Date: Fri, 7 Feb 2014 17:46:30 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140207224630.GD8801@fieldses.org>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:48:58PM +0100, Miklos Szeredi wrote:
> Changes since the last version (based on Al's review):
> 
>  - cross-rename: fix locking of nondirectories for NFSv4
>  - ext4: split cross-rename and plain rename into separate functions
>  - introduce i_op->rename2 with flags, don't touch ->rename
>  - last (optional) patch to merge ->rename2 back into ->rename
> 
> The splitting of the ext4 implemetation was indeed a good idea as it uncovered a
> memory leak and small inconsistencies with the merged implementation.
> 
> Splitting out rename2 will lessen the code churn, but I think is ugly.  However
> this is a question of taste, last patch can be ommitted without loss of
> functionality.
> 
> Bruce, could you please review the locking and delegation thing in patch #8
> "vfs: add cross-rename"?

Yep, done.  I'll also try running this through my nfs tests, for what
it's worth.  (Not today as there's some unrelated regression to sort
out first.)

Feel free to add a

	Reviewed-by: J. Bruce Fields <bfields@redhat.com>

for any but the ext4 patches, which I skipped.

--b.

> 
> Git tree is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename
> 
> Thanks,
> Miklos
> 
> ---
> Miklos Szeredi (13):
>       vfs: add d_is_dir()
>       vfs: rename: move d_move() up
>       vfs: rename: use common code for dir and non-dir
>       vfs: add renameat2 syscall
>       vfs: add RENAME_NOREPLACE flag
>       security: add flags to rename hooks
>       vfs: lock_two_nondirectories: allow directory args
>       vfs: add cross-rename
>       ext4: rename: create ext4_renament structure for local vars
>       ext4: rename: move EMLINK check up
>       ext4: rename: split out helper functions
>       ext4: add cross rename support
>       vfs: merge rename2 into rename
> 
> ---
>  Documentation/filesystems/Locking                  |   2 +-
>  Documentation/filesystems/vfs.txt                  |  14 +-
>  arch/x86/syscalls/syscall_64.tbl                   |   1 +
>  .../lustre/lustre/include/linux/lustre_compat25.h  |   4 +-
>  drivers/staging/lustre/lustre/llite/namei.c        |   3 +-
>  drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   2 +-
>  fs/9p/v9fs.h                                       |   3 +-
>  fs/9p/vfs_inode.c                                  |   4 +-
>  fs/affs/affs.h                                     |   3 +-
>  fs/affs/namei.c                                    |   3 +-
>  fs/afs/dir.c                                       |   6 +-
>  fs/bad_inode.c                                     |   3 +-
>  fs/bfs/dir.c                                       |   3 +-
>  fs/btrfs/inode.c                                   |   3 +-
>  fs/cachefiles/namei.c                              |   4 +-
>  fs/ceph/dir.c                                      |   3 +-
>  fs/cifs/cifsfs.h                                   |   2 +-
>  fs/cifs/inode.c                                    |   3 +-
>  fs/coda/dir.c                                      |   8 +-
>  fs/dcache.c                                        |  45 +-
>  fs/debugfs/inode.c                                 |   2 +-
>  fs/ecryptfs/inode.c                                |   5 +-
>  fs/exofs/namei.c                                   |   3 +-
>  fs/ext2/namei.c                                    |   5 +-
>  fs/ext3/namei.c                                    |   5 +-
>  fs/ext4/namei.c                                    | 483 +++++++++++++++------
>  fs/ext4/super.c                                    |   6 +-
>  fs/f2fs/namei.c                                    |   3 +-
>  fs/fat/namei_msdos.c                               |   3 +-
>  fs/fat/namei_vfat.c                                |   3 +-
>  fs/fuse/dir.c                                      |   3 +-
>  fs/gfs2/inode.c                                    |   3 +-
>  fs/hfs/dir.c                                       |   3 +-
>  fs/hfsplus/dir.c                                   |   3 +-
>  fs/hostfs/hostfs_kern.c                            |   3 +-
>  fs/hpfs/namei.c                                    |   3 +-
>  fs/inode.c                                         |  20 +-
>  fs/jffs2/dir.c                                     |   5 +-
>  fs/jfs/namei.c                                     |   3 +-
>  fs/kernfs/dir.c                                    |   3 +-
>  fs/libfs.c                                         |   3 +-
>  fs/logfs/dir.c                                     |   3 +-
>  fs/minix/namei.c                                   |   5 +-
>  fs/namei.c                                         | 310 +++++++------
>  fs/ncpfs/dir.c                                     |   5 +-
>  fs/nfs/dir.c                                       |   3 +-
>  fs/nfs/internal.h                                  |   3 +-
>  fs/nfsd/vfs.c                                      |   2 +-
>  fs/nilfs2/namei.c                                  |   3 +-
>  fs/ocfs2/namei.c                                   |   3 +-
>  fs/omfs/dir.c                                      |   3 +-
>  fs/reiserfs/namei.c                                |   3 +-
>  fs/sysv/namei.c                                    |   5 +-
>  fs/ubifs/dir.c                                     |   3 +-
>  fs/udf/namei.c                                     |   3 +-
>  fs/ufs/namei.c                                     |   3 +-
>  fs/xfs/xfs_iops.c                                  |   3 +-
>  include/linux/dcache.h                             |   8 +-
>  include/linux/fs.h                                 |   7 +-
>  include/linux/security.h                           |  12 +-
>  include/uapi/linux/fs.h                            |   3 +
>  kernel/cgroup.c                                    |   5 +-
>  mm/shmem.c                                         |   2 +-
>  security/security.c                                |  22 +-
>  64 files changed, 736 insertions(+), 372 deletions(-)
> 
