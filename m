Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaJLXYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 19:24:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36169 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaJLXX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 19:23:56 -0400
Date: Mon, 13 Oct 2014 00:23:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git pile 1
Message-ID: <20141012232353.GV7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big thing in this pile is Eric's unmount-on-rmdir series; we finally 
have everything we need for that.  The final piece of prereqs is delayed
mntput() - now filesystem shutdown always happens on shallow stack.
Other than that, we have several new primitives for iov_iter (Matt Wilcox,
culled from his XIP-related series) pushing the conversion to ->read_iter()/
->write_iter() a bit more, a bunch of fs/dcache.c cleanups and fixes
(including the external name refcounting, which gives consistent behaviour
of d_move() wrt procfs symlinks for long and short names alike) and
assorted cleanups and fixes all over the place.

This is just the first pile; there's a lot of stuff from various people that
ought to go in this window.  Starting with unionmount/overlayfs mess... ;-/

Please, pull from the usual place:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (38):
      missing data dependency barrier in prepend_name()
      Allow sharing external names after __d_move()
      delayed mntput
      d_prune_alias(): just lock the parent and call __dentry_kill()
      dcache.c: call ->d_prune() regardless of d_unhashed()
      handle suicide on late failure exits in execve() in search_binary_handler()
      constify file_inode()
      [jffs2] kill wbuf_queued/wbuf_dwork_lock
      cifs: switch to use of %p[dD]
      9p: switch to %p[dD]
      ashmem: use vfs_llseek()
      vme: don't open-code fixed_size_llseek()
      cachefiles_write_page(): switch to __kernel_write()
      carma-fpga: switch to fixed_size_llseek()
      carma-fpga: switch to simple_read_from_buffer()
      rsxx debugfs inanity
      dma-buf: don't open-code atomic_long_read()
      switch /dev/zero and /dev/full to ->read_iter()
      switch hci_vhci to ->write_iter()
      switch logger to ->write_iter()
      switch /dev/kmsg to ->write_iter()
      saner perf_atoll()
      missing annotation in fs/file.c
      nouveau: __iomem misannotations
      android: ->f_op is never NULL
      ecryptfs: ->f_op is never NULL
      [s390] remove pointless assignment of ->f_op in vmlogrdr ->open()
      jfs: don't hash direct inode
      f_fs: saner API for ffs_sb_create_file()
      gadgetfs: saner API for gadgetfs_create_file()
      [infiniband] remove pointless assignments
      gfs2_atomic_open(): skip lookups on hashed dentry
      ncpfs: use list_for_each_entry() for d_subdirs walk
      fix misuses of f_count() in ppp and netlink
      let path_init() failures treated the same way as subsequent link_path_walk()
      take dname_external() into fs/dcache.c
      don't need that forward declaration of struct nameidata in dcache.h anymore
      reiserfs: remove pointless forward declaration of struct nameidata

Daeseok Youn (1):
      dcache: Fix no spaces at the start of a line in dcache.c

Eric Biggers (2):
      vfs: Deduplicate code shared by xattr system calls operating on paths
      fs/file_table.c: Update alloc_file() comment

Eric W. Biederman (12):
      vfs: Document the effect of d_revalidate on d_find_alias
      vfs: More precise tests in d_invalidate
      vfs: Don't allow overwriting mounts in the current mount namespace
      vfs: Keep a list of mounts on a mount point
      vfs: factor out lookup_mountpoint from new_mountpoint
      vfs: Add a function to lazily unmount all mounts from any dentry.
      vfs: Lazily remove mounts on unlinked files and directories.
      vfs: Remove unnecessary calls of check_submounts_and_drop
      vfs: Merge check_submounts_and_drop and d_invalidate
      vfs: Make d_invalidate return void
      vfs: Remove d_drop calls from d_revalidate implementations
      proc: Update proc_flush_task_mnt to use d_invalidate

Ian Kent (1):
      autofs - remove obsolete d_invalidate() from expire

Kirill Smelkov (1):
      vfs: fix typo in s_op->alloc_inode() documentation

Matthew Wilcox (1):
      Add copy_to_iter(), copy_from_iter() and iov_iter_zero()

Mikulas Patocka (1):
      fs: make cont_expand_zero interruptible

Seunghun Lee (1):
      vfs: move getname() from callers to do_mount()

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().

Tim Gardner (1):
      fs: namespace: suppress 'may be used uninitialized' warnings

Diffstat:
 Documentation/filesystems/vfs.txt        |    2 +-
 arch/alpha/kernel/osf_sys.c              |   23 ++-
 arch/x86/ia32/ia32_aout.c                |   21 +--
 drivers/block/rsxx/core.c                |   81 ++--------
 drivers/bluetooth/hci_vhci.c             |   22 +--
 drivers/char/mem.c                       |   56 ++-----
 drivers/dma-buf/dma-buf.c                |    2 +-
 drivers/gpu/drm/nouveau/nouveau_nvif.c   |    4 +-
 drivers/gpu/drm/nouveau/nvif/driver.h    |    4 +-
 drivers/gpu/drm/nouveau/nvif/object.h    |    6 +-
 drivers/infiniband/hw/ipath/ipath_fs.c   |    1 -
 drivers/infiniband/hw/qib/qib_fs.c       |    1 -
 drivers/misc/carma/carma-fpga-program.c  |   30 +---
 drivers/net/ppp/ppp_generic.c            |    2 +-
 drivers/s390/char/vmlogrdr.c             |    1 -
 drivers/staging/android/ashmem.c         |    2 +-
 drivers/staging/android/ion/compat_ion.c |    2 +-
 drivers/staging/android/logger.c         |  103 +++---------
 drivers/staging/vme/devices/vme_user.c   |   28 +---
 drivers/usb/gadget/function/f_fs.c       |   24 ++-
 drivers/usb/gadget/legacy/inode.c        |   26 ++-
 fs/9p/fid.c                              |    4 +-
 fs/9p/vfs_addr.c                         |    4 +-
 fs/9p/vfs_dentry.c                       |    8 +-
 fs/9p/vfs_dir.c                          |    4 +-
 fs/9p/vfs_file.c                         |    8 +-
 fs/9p/vfs_inode.c                        |   32 ++--
 fs/9p/vfs_inode_dotl.c                   |    8 +-
 fs/afs/dir.c                             |    5 -
 fs/autofs4/expire.c                      |    6 -
 fs/binfmt_aout.c                         |   25 +--
 fs/binfmt_elf.c                          |   25 +--
 fs/binfmt_elf_fdpic.c                    |   24 +--
 fs/btrfs/ioctl.c                         |    5 +-
 fs/buffer.c                              |    5 +
 fs/cachefiles/rdwr.c                     |   48 +++---
 fs/ceph/dir.c                            |    1 -
 fs/cifs/dir.c                            |   14 +-
 fs/cifs/file.c                           |   12 +-
 fs/cifs/inode.c                          |   12 +-
 fs/cifs/readdir.c                        |    6 +-
 fs/compat.c                              |   28 ++--
 fs/dcache.c                              |  259 +++++++++++++++---------------
 fs/ecryptfs/file.c                       |    2 +-
 fs/exec.c                                |   17 +-
 fs/file.c                                |    1 +
 fs/file_table.c                          |   12 +-
 fs/fuse/dir.c                            |    7 +-
 fs/gfs2/dentry.c                         |    3 -
 fs/gfs2/inode.c                          |    5 +
 fs/internal.h                            |    2 +-
 fs/jffs2/jffs2_fs_sb.h                   |    2 -
 fs/jffs2/wbuf.c                          |   17 +-
 fs/jfs/super.c                           |    2 +-
 fs/kernfs/dir.c                          |   11 --
 fs/mount.h                               |   25 ++-
 fs/namei.c                               |   27 ++--
 fs/namespace.c                           |  203 ++++++++++++++++-------
 fs/ncpfs/dir.c                           |    6 +-
 fs/ncpfs/ncplib_kernel.h                 |   14 +-
 fs/nfs/dir.c                             |    7 +-
 fs/proc/base.c                           |   10 +-
 fs/proc/fd.c                             |    2 -
 fs/read_write.c                          |    2 +
 fs/reiserfs/xattr.h                      |    1 -
 fs/super.c                               |    2 +
 fs/xattr.c                               |  116 +++++--------
 include/linux/dcache.h                   |    9 +-
 include/linux/fs.h                       |    5 +-
 include/linux/uio.h                      |    3 +
 kernel/printk/printk.c                   |   20 +--
 mm/iov_iter.c                            |  240 +++++++++++++++++++++++++--
 net/netlink/af_netlink.c                 |    2 +-
 tools/perf/util/string.c                 |   90 ++++-------
 74 files changed, 889 insertions(+), 960 deletions(-)
