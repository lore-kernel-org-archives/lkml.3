Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaHKRFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:05:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37256 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaHKRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:05:12 -0400
Date: Mon, 11 Aug 2014 18:05:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git pile 1
Message-ID: <20140811170510.GU18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Stuff in there:
1) acct.c fixes and general rework of mnt_pin mechanism.  That allows to go for
delayed-mntput stuff, which will permit mntput() on deep stack without worrying
about stack overflows - fs shutdown will happen on shallow stack.  IOW, we
can do Eric's umount-on-rmdir series without introducing tons of stack
overflows on new mntput() call chains it introduces.
2) Bruce's d_splice_alias() patches
3) more Miklos' rename() stuff.
4) a couple of regression fixes (stable fodder, in the end of branch)
and a fix for API idiocy in iov_iter.c.

There definitely will be another pile, maybe even two.  I'd like to
get Eric's series in this time, but even if we miss it, it'll go right
in the beginning of for-next in the next cycle - the tricky part of
prereqs is in this pile.

Please, pull from the usual place:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

There are two conflicts - one in fs/namespace.c (hlist_add_after_rcu()
got moved into helper function in this branch and replaced with
hlist_add_behind_rcu() in mainline) and another in kernel/acct.c - there
it's whitespace noise from "kernel/acct.c: fix coding style warnings and errors"
which got rebased into this branch *and* sent in original form by akpm.
Resolution is to pick kernel/acct.c from this branch.  Alternatively, I
can drop that commit from the branch, but that will mean a late rebase
or having even messier conflict in kernel/acct.c, with the same contents
of that file after conflict resolution.  Up to you, but I think it's less
PITA to leave it as is...  See vfs.git#proposed-merge for my take on the
merge.

Shortlog:
Al Viro (20):
      acct: encode_comp_t(0) is 0, fortunately...
      acct: switch to __kernel_write()
      separate namespace-independent parts of filling acct_t
      split the slow path in acct_process() off
      acct() should honour the limits from the very beginning
      acct: serialize acct_on()
      acct: new lifetime rules
      acct: simplify check_free_space()
      acct: get rid of acct_list
      acct: get rid of acct_lock for acct->count
      drop ->s_umount around acct_auto_close()
      make acct_kill() wait for file closing.
      acct: move mnt_pin() upwards.
      start carving bsd_acct_struct up
      take fs_pin stuff to fs/*
      make fs/{namespace,super}.c forget about acct.h
      death to mnt_pinned
      switch iov_iter_get_pages() to passing maximal number of pages
      __generic_file_write_iter(): fix handling of sync error after DIO
      fix copy_tree() regression

Fengguang Wu (1):
      fs: mark __d_obtain_alias static

Ionut Alexa (1):
      kernel/acct.c: fix coding style warnings and errors

J. Bruce Fields (10):
      namei: trivial fix to vfs_rename_dir comment
      dcache: move d_splice_alias
      dcache: close d_move race in d_splice_alias
      dcache: d_splice_alias mustn't create directory aliases
      dcache: d_splice_alias should ignore DCACHE_DISCONNECTED
      dcache: d_obtain_alias callers don't all want DISCONNECTED
      dcache: remove unused d_find_alias parameter
      dcache: d_find_alias needn't recheck IS_ROOT && DCACHE_DISCONNECTED
      exportfs: update Exporting documentation
      dcache: d_splice_alias should detect loops

Miklos Szeredi (7):
      fs: call rename2 if exists
      bad_inode: add ->rename2()
      btrfs: add RENAME_NOREPLACE
      shmem: support RENAME_NOREPLACE
      shmem: support RENAME_EXCHANGE
      hostfs: support rename flags
      cifs: support RENAME_NOREPLACE

NeilBrown (1):
      VFS: allow ->d_manage() to declare -EISDIR in rcu_walk mode.

Diffstat:
 Documentation/filesystems/nfs/Exporting |   38 ++-
 Documentation/filesystems/vfs.txt       |    3 +-
 fs/Makefile                             |    2 +-
 fs/bad_inode.c                          |    7 +-
 fs/btrfs/inode.c                        |   12 +-
 fs/btrfs/super.c                        |    9 +-
 fs/ceph/super.c                         |    2 +-
 fs/cifs/cifsfs.c                        |    2 +-
 fs/cifs/cifsfs.h                        |    4 +-
 fs/cifs/inode.c                         |   14 +-
 fs/dcache.c                             |  196 ++++++++-----
 fs/direct-io.c                          |    2 +-
 fs/ext4/namei.c                         |    1 -
 fs/fs_pin.c                             |   78 +++++
 fs/fuse/dir.c                           |    7 -
 fs/fuse/file.c                          |    4 +-
 fs/hostfs/hostfs.h                      |    1 +
 fs/hostfs/hostfs_kern.c                 |   30 +-
 fs/hostfs/hostfs_user.c                 |   28 ++
 fs/internal.h                           |    7 +-
 fs/mount.h                              |    2 +-
 fs/namei.c                              |   34 ++-
 fs/namespace.c                          |   67 +++--
 fs/nfs/getroot.c                        |    2 +-
 fs/nilfs2/super.c                       |    2 +-
 fs/super.c                              |   19 +-
 include/linux/acct.h                    |    4 -
 include/linux/dcache.h                  |    1 +
 include/linux/fs.h                      |    2 +
 include/linux/fs_pin.h                  |   17 ++
 include/linux/mount.h                   |    4 +-
 include/linux/uio.h                     |    2 +-
 kernel/acct.c                           |  484 ++++++++++++++-----------------
 mm/filemap.c                            |    2 +-
 mm/iov_iter.c                           |   17 +-
 mm/shmem.c                              |   32 +-
 36 files changed, 661 insertions(+), 477 deletions(-)
 create mode 100644 fs/fs_pin.c
 create mode 100644 include/linux/fs_pin.h
