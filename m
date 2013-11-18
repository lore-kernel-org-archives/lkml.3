Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3KRTE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:04:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42953 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab3KRTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:04:26 -0500
Message-ID: <528A648F.1030007@oracle.com>
Date: Mon, 18 Nov 2013 13:03:43 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] direct IO support for loop driver
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following patches. They add the infrastructure for
kernel-initiated direct-io, change the loop driver to perform direct-io,
and change swap-over-nfs to use the new infrastructure.

These patches have been under development for a long time and have been
in linux-next since August. I'd have sent the request sooner, but I was
on vacation last week.

There are merge conflicts with several files, so I will follow up with
a merge patch.

The following changes since commit 1e52db6908ca5aa8e035caeaf96e8de2567fd84d:

  Merge tag 'vfio-v3.12-rc5' of git://github.com/awilliam/linux-vfio (2013-10-14 18:11:28 -0700)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/aio-direct-for-3.13

for you to fetch changes up to bb6f7be483180a9674f3d00b8e97e9b29b39d55d:

  tmpfs: add support for read_iter and write_iter (2013-10-18 10:56:54 -0500)

----------------------------------------------------------------
Allow the loop driver to perform direct IO to the underlying file system

----------------------------------------------------------------
Asias He (1):
      block_dev: add support for read_iter, write_iter

Dave Kleikamp (22):
      iov_iter: iov_iter_copy_from_user() should use non-atomic copy
      iov_iter: add __iovec_copy_to_user()
      fuse: convert fuse to use iov_iter_copy_[to|from]_user
      iov_iter: ii_iovec_copy_to_user should pre-fault user pages
      dio: Convert direct_IO to use iov_iter
      dio: add bio_vec support to __blockdev_direct_IO()
      aio: add aio_kernel_() interface
      aio: add aio support for iov_iter arguments
      fs: create file_readable() and file_writable() functions
      fs: use read_iter and write_iter rather than aio_read and aio_write
      fs: add read_iter and write_iter to several file systems
      ocfs2: add support for read_iter and write_iter
      ext4: add support for read_iter and write_iter
      nfs: add support for read_iter, write_iter
      nfs: simplify swap
      btrfs: add support for read_iter and write_iter
      xfs: add support for read_iter and write_iter
      gfs2: Convert aio_read/write ops to read/write_iter
      udf: convert file ops from aio_read/write to read/write_iter
      afs: add support for read_iter and write_iter
      ecrpytfs: Convert aio_read/write ops to read/write_iter
      ubifs: convert file ops from aio_read/write to read/write_iter

Hugh Dickins (1):
      tmpfs: add support for read_iter and write_iter

Zach Brown (9):
      iov_iter: move into its own file
      iov_iter: add copy_to_user support
      iov_iter: hide iovec details behind ops function pointers
      iov_iter: add bvec support
      iov_iter: add a shorten call
      iov_iter: let callers extract iovecs and bio_vecs
      fs: pull iov_iter use higher up the stack
      bio: add bvec_length(), like iov_length()
      loop: use aio to perform io on the underlying file

 Documentation/filesystems/Locking   |   6 +-
 Documentation/filesystems/vfs.txt   |  12 +-
 drivers/block/loop.c                | 158 +++++++++----
 drivers/char/raw.c                  |   4 +-
 drivers/mtd/nand/nandsim.c          |   4 +-
 drivers/usb/gadget/storage_common.c |   4 +-
 fs/9p/vfs_addr.c                    |  12 +-
 fs/9p/vfs_file.c                    |   8 +-
 fs/Makefile                         |   2 +-
 fs/adfs/file.c                      |   4 +-
 fs/affs/file.c                      |   4 +-
 fs/afs/file.c                       |   4 +-
 fs/afs/internal.h                   |   3 +-
 fs/afs/write.c                      |   9 +-
 fs/aio.c                            | 136 ++++++++++-
 fs/bad_inode.c                      |  14 ++
 fs/bfs/file.c                       |   4 +-
 fs/block_dev.c                      |  27 ++-
 fs/btrfs/file.c                     |  42 ++--
 fs/btrfs/inode.c                    |  63 +++---
 fs/ceph/addr.c                      |   3 +-
 fs/cifs/file.c                      |   4 +-
 fs/direct-io.c                      | 223 +++++++++++++------
 fs/ecryptfs/file.c                  |  15 +-
 fs/exofs/file.c                     |   4 +-
 fs/ext2/file.c                      |   4 +-
 fs/ext2/inode.c                     |   8 +-
 fs/ext3/file.c                      |   4 +-
 fs/ext3/inode.c                     |  15 +-
 fs/ext4/ext4.h                      |   3 +-
 fs/ext4/file.c                      |  34 +--
 fs/ext4/indirect.c                  |  16 +-
 fs/ext4/inode.c                     |  23 +-
 fs/f2fs/data.c                      |   4 +-
 fs/f2fs/file.c                      |   4 +-
 fs/fat/file.c                       |   4 +-
 fs/fat/inode.c                      |  10 +-
 fs/fuse/cuse.c                      |  10 +-
 fs/fuse/file.c                      |  90 ++++----
 fs/fuse/fuse_i.h                    |   5 +-
 fs/gfs2/aops.c                      |   7 +-
 fs/gfs2/file.c                      |  21 +-
 fs/hfs/inode.c                      |  11 +-
 fs/hfsplus/inode.c                  |  10 +-
 fs/hostfs/hostfs_kern.c             |   4 +-
 fs/hpfs/file.c                      |   4 +-
 fs/internal.h                       |   4 +
 fs/iov-iter.c                       | 411 ++++++++++++++++++++++++++++++++++
 fs/jffs2/file.c                     |   8 +-
 fs/jfs/file.c                       |   4 +-
 fs/jfs/inode.c                      |   7 +-
 fs/logfs/file.c                     |   4 +-
 fs/minix/file.c                     |   4 +-
 fs/nfs/direct.c                     | 301 ++++++++++++++++---------
 fs/nfs/file.c                       |  33 ++-
 fs/nfs/internal.h                   |   4 +-
 fs/nfs/nfs4file.c                   |   4 +-
 fs/nilfs2/file.c                    |   4 +-
 fs/nilfs2/inode.c                   |   8 +-
 fs/ocfs2/aops.c                     |   8 +-
 fs/ocfs2/aops.h                     |   2 +-
 fs/ocfs2/file.c                     |  55 ++---
 fs/ocfs2/ocfs2_trace.h              |   6 +-
 fs/omfs/file.c                      |   4 +-
 fs/ramfs/file-mmu.c                 |   4 +-
 fs/ramfs/file-nommu.c               |   4 +-
 fs/read_write.c                     |  78 +++++--
 fs/reiserfs/file.c                  |   4 +-
 fs/reiserfs/inode.c                 |   7 +-
 fs/romfs/mmap-nommu.c               |   2 +-
 fs/sysv/file.c                      |   4 +-
 fs/ubifs/file.c                     |  12 +-
 fs/udf/file.c                       |  13 +-
 fs/udf/inode.c                      |  10 +-
 fs/ufs/file.c                       |   4 +-
 fs/xfs/xfs_aops.c                   |  13 +-
 fs/xfs/xfs_file.c                   |  51 ++---
 include/linux/aio.h                 |  25 ++-
 include/linux/bio.h                 |   8 +
 include/linux/blk_types.h           |   2 -
 include/linux/fs.h                  | 165 ++++++++++++--
 include/linux/nfs_fs.h              |  13 +-
 include/uapi/linux/loop.h           |   1 +
 mm/filemap.c                        | 433 ++++++++++++++----------------------
 mm/page_io.c                        |  15 +-
 mm/shmem.c                          |  61 ++---
 86 files changed, 1857 insertions(+), 1003 deletions(-)
 create mode 100644 fs/iov-iter.c
