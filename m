Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaDLMkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 08:40:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38289 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaDLMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 08:40:45 -0400
Date: Sat, 12 Apr 2014 13:40:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20140412124042.GL18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first vfs pile, with deep apologies for being very late in this window.
Assorted cleanups and fixes, plus a large preparatory part of iov_iter work.
There's a lot more of that, but it'll probably go into the next merge window
- it *does* shape up nicely, removes a lot of boilerplate, gets rid of
locking inconsistencie between aio_write and splice_write and I hope to get
Kent's direct-io rewrite merged into the same queue, but some of the stuff
after this point is having (mostly trivial) conflicts with the things already
merged into mainline and with some I want more testing.

This one passes LTP and xfstests without regressions, in addition to usual
beating.  BTW, readahead02 in ltp syscalls testsuite has started giving
failures since "mm/readahead.c: fix readahead failure for memoryless NUMA
nodes and limit readahead pages" - might be a false positive, might be
a real regression...

The conflicts are trivial (variable added in mainline next to one removed
in this series, a function removed in mainline next to several removed in
this, new object added in mm/Makefile, a function call in fs/ceph/file.c
replaced with several lines equivalent to it next to an if that was added
after that call in mainline).  I've pushed a resolved variant into
vfs.git#proposed-merge, but that's mostly for verification purposes.

There will be another pile, with bits and pieces from other folks; I want
to deal with the bulk of that mess first...

The branch itself is in the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (61):
      smarter propagate_mnt()
      reduce m_start() cost...
      usbip: don't open-code sockfd_lookup/sockfd_put
      vhost: don't open-code sockfd_put()
      switch nbd to sockfd_lookup/sockfd_put
      ncpfs: switch to sockfd_lookup()/sockfd_put()
      don't bother with {get,put}_write_access() on non-regular files
      get rid of DEBUG_WRITECOUNT
      fold __get_file_write_access() into its only caller
      mark struct file that had write access grabbed by open()
      tidy do_dentry_open() up a bit
      get_write_access() is inlined, exporting it is pointless
      namei.c: move EXPORT_SYMBOL to corresponding definitions
      get rid of files_defer_init()
      lustre: generic_readlink() is just fine there, TYVM...
      new helper: readlink_copy()
      ntfs: don't put NULL into ->i_op/->i_fop
      get rid of pointless checks for NULL ->i_op
      cifs: ->rename() without ->lookup() makes no sense
      mn10300: kmap_atomic() returns void *, not unsigned long...
      fuse/dev: use atomic maps
      pipe: kill ->map() and ->unmap()
      switch ->is_partially_uptodate() to saner arguments
      callers of iov_copy_from_user_atomic() don't need pagecache_disable()
      do_shmem_file_read(): call file_read_actor() directly
      introduce copy_page_to_iter, kill loop over iovec in generic_file_aio_read()
      cifs_iovec_read(): resubmit shouldn't restart the loop
      switch pipe_read() to copy_page_to_iter()
      switch vmsplice_to_user() to copy_page_to_iter()
      cifs_iovec_read: keep iov_iter between the calls of cifs_readdata_to_iov()
      fold cifs_iovec_read() into its (only) caller
      read_code(): go through vfs_read() instead of calling the method directly
      untangling process_vm_..., part 1
      untangling process_vm_..., part 2
      untangling process_vm_..., part 3
      untangling process_vm_..., part 4
      process_vm_access: switch to iov_iter
      process_vm_access: switch to copy_page_to_iter/iov_iter_copy_from_user
      process_vm_access: take get_user_pages/put_pages one level up
      process_vm_rw_pages(): pass accurate amount of bytes
      process_vm_access: don't bother with returning the amounts of bytes copied
      process_vm_access: tidy up a bit
      take iov_iter stuff to mm/iov_iter.c
      ocfs2: don't open-code kernel_sendmsg()
      lustre: switch to kernel_sendmsg()
      constify blk_rq_map_user_iov() and friends
      drbd: don't open-code kernel_recvmsg()
      ocfs2: don't open-code kernel_recvmsg()
      lustre: don't open-code kernel_recvmsg()
      kill the 4th argument of __generic_file_aio_write()
      kill the 5th argument of generic_file_buffered_write()
      btrfs_file_aio_write(): get rid of ppos
      generic_file_direct_write(): get rid of ppos argument
      export generic_perform_write(), start getting rid of generic_file_buffer_write()
      xfs_file_buffered_aio_write(): switch to generic_perform_write()
      ceph_aio_write(): switch to generic_perform_write()
      ocfs2_file_aio_write(): switch to generic_perform_write()
      kill generic_file_buffered_write()
      ceph_sync_{,direct_}write: fix an oops on ceph_osdc_new_request() failure
      cifs: fix the race in cifs_writev()
      missing bits of "splice: fix racy pipe->buffers uses"

David Howells (1):
      VFS: Make delayed_free() call free_vfsmnt()

Kent Overstreet (1):
      iov_iter: Move iov_iter to uio.h

Diffstat:
 Documentation/filesystems/Locking                  |    2 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 arch/mn10300/include/asm/highmem.h                 |    4 +-
 arch/powerpc/configs/ppc6xx_defconfig              |    1 -
 arch/powerpc/configs/ps3_defconfig                 |    1 -
 arch/s390/configs/default_defconfig                |    1 -
 arch/sh/configs/rsk7203_defconfig                  |    1 -
 arch/xtensa/configs/iss_defconfig                  |    1 -
 arch/xtensa/configs/s6105_defconfig                |    1 -
 block/blk-map.c                                    |    2 +-
 drivers/block/drbd/drbd_receiver.c                 |   12 +-
 drivers/block/nbd.c                                |   48 ++-
 drivers/char/virtio_console.c                      |    4 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |   60 +---
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |   24 +-
 drivers/staging/lustre/lustre/llite/symlink.c      |   23 +-
 drivers/staging/usbip/stub_dev.c                   |    8 +-
 drivers/staging/usbip/usbip_common.c               |   25 --
 drivers/staging/usbip/usbip_common.h               |    1 -
 drivers/staging/usbip/vhci_hcd.c                   |    4 +-
 drivers/staging/usbip/vhci_sysfs.c                 |    6 +-
 drivers/vhost/net.c                                |   14 +-
 fs/bio.c                                           |   10 +-
 fs/block_dev.c                                     |    2 +-
 fs/btrfs/file.c                                    |   16 +-
 fs/buffer.c                                        |    6 +-
 fs/cachefiles/bind.c                               |    1 -
 fs/cachefiles/namei.c                              |    3 +-
 fs/ceph/file.c                                     |   12 +-
 fs/cifs/cifsfs.c                                   |    1 -
 fs/cifs/file.c                                     |  128 +++-----
 fs/exec.c                                          |    2 +-
 fs/ext4/file.c                                     |    2 +-
 fs/file.c                                          |   11 +-
 fs/file_table.c                                    |   43 +--
 fs/fuse/dev.c                                      |   14 +-
 fs/fuse/file.c                                     |    5 +-
 fs/mount.h                                         |    5 +-
 fs/namei.c                                         |   67 ++--
 fs/namespace.c                                     |   56 ++--
 fs/ncpfs/inode.c                                   |   50 +--
 fs/ncpfs/ncp_fs_sb.h                               |    2 -
 fs/ntfs/inode.c                                    |    2 -
 fs/ocfs2/cluster/tcp.c                             |   49 +--
 fs/ocfs2/file.c                                    |    9 +-
 fs/open.c                                          |   68 +---
 fs/pipe.c                                          |  133 +-------
 fs/pnode.c                                         |  198 ++++++-----
 fs/pnode.h                                         |    3 +
 fs/proc/namespaces.c                               |   14 +-
 fs/proc/self.c                                     |    2 +-
 fs/proc_namespace.c                                |    1 +
 fs/splice.c                                        |  126 ++-----
 fs/udf/file.c                                      |    2 +-
 fs/xfs/xfs_file.c                                  |   13 +-
 fs/xfs/xfs_ioctl.c                                 |   28 +-
 include/linux/bio.h                                |    5 +-
 include/linux/blkdev.h                             |    4 +-
 include/linux/buffer_head.h                        |    4 +-
 include/linux/fdtable.h                            |    2 -
 include/linux/fs.h                                 |   97 +-----
 include/linux/mount.h                              |    3 +
 include/linux/nbd.h                                |    3 +-
 include/linux/pipe_fs_i.h                          |   19 --
 include/linux/uio.h                                |   52 +++
 kernel/relay.c                                     |    4 +-
 kernel/trace/trace.c                               |    8 +-
 lib/Kconfig.debug                                  |   10 -
 mm/Makefile                                        |    2 +-
 mm/filemap.c                                       |  344 ++++----------------
 mm/iov_iter.c                                      |  224 +++++++++++++
 mm/process_vm_access.c                             |  250 +++++---------
 mm/shmem.c                                         |   79 ++---
 security/integrity/evm/evm_crypto.c                |    2 +-
 security/integrity/evm/evm_main.c                  |    2 +-
 security/tomoyo/realpath.c                         |    4 +-
 76 files changed, 910 insertions(+), 1537 deletions(-)
 create mode 100644 mm/iov_iter.c
