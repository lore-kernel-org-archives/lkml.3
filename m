Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaLJTNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:13:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42072 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141AbaLJTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:13:04 -0500
Date: Wed, 10 Dec 2014 19:13:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] vfs.git
Message-ID: <20141210191302.GO22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First pile out of several (there _definitely_ will be more).  Stuff in this
one:
	* unification of d_splice_alias()/d_materialize_unique()
	* iov_iter rewrite
	* killing a bunch of ->f_path.dentry users (and f_dentry macro).
Getting that completed will make life much simpler for unionmount/overlayfs,
since then we'll be able to limit the places sensitive to file _dentry_
to reasonably few.  Which allows to have file_inode(file) pointing to
inode in a covered layer, with dentry pointing to (negative) dentry in
union one.  Still not complete, but much closer now.
	* crapectomy in lustre (dead code removal, mostly)
	* "let's make seq_printf return nothing" preparations
	* assorted cleanups and fixes
There _definitely_ will be more piles.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (53):
      new helper: is_root_inode()
      move d_rcu from overlapping d_child to overlapping d_alias
      lustre: switch ll_intent_file_open() to struct dentry *
      ll_setxattr(): get rid of struct file on stack
      lustre: opened file can't have negative dentry
      lustre: use %p[dD]
      lustre: use file_inode()
      lustre: switch ll_release_openhandle() to struct inode *
      kill ll_mknod_generic()
      kill ll_mkdir_generic()
      kill ll_symlink_generic()
      ll_new_inode(): don't bother with name - it's always &dentry->d_name
      kill ll_rmdir_generic()
      kill ll_unlink_generic()
      kill ll_rename_generic()
      ll_get_child_fid(): callers already have the child
      kill ll_link_generic()
      lustre: get rid of duplicate mountpoint checks
      lustre: use is_root_inode()
      deal with deadlock in d_walk()
      gfs2: bugger off early if O_CREAT open finds a directory
      gfs2_create_inode(): don't bother with d_splice_alias()
      gfs2_atomic_open(): simplify the use of finish_no_open()
      d_add_ci() should just accept a hashed exact match if it finds one
      merge d_materialise_unique() into d_splice_alias()
      switch d_materialise_unique() users to d_splice_alias()
      assorted conversions to %p[dD]
      nfsd/nfsctl.c: new helper
      btrfs: get rid of f_dentry use
      cifs: get rid of ->f_path.dentry->d_sb uses, add a new helper
      afs_fsync: don't bother with ->f_path.dentry
      rpc_pipefs.c: get rid of f_dentry
      nfsd: get rid of ->f_dentry
      procfs: get rid of ->f_dentry
      lockd: get rid of ->f_path.dentry->d_sb
      kill f_dentry uses
      ncpfs: use file_inode()
      nfsd_vfs_write(): use file_inode()
      new helper: audit_file()
      kill f_dentry macro
      iov_iter.c: macros for iterating over iov_iter
      iov_iter.c: iterate_and_advance
      iov_iter.c: convert iov_iter_npages() to iterate_all_kinds
      iov_iter.c: convert iov_iter_get_pages() to iterate_all_kinds
      iov_iter.c: convert iov_iter_get_pages_alloc() to iterate_all_kinds
      iov_iter.c: convert iov_iter_zero() to iterate_and_advance
      iov_iter.c: get rid of bvec_copy_page_{to,from}_iter()
      iov_iter.c: convert copy_from_iter() to iterate_and_advance
      iov_iter.c: convert copy_to_iter() to iterate_and_advance
      iov_iter.c: handle ITER_KVEC directly
      csum_and_copy_..._iter()
      new helper: iov_iter_kvec()
      copy_from_iter_nocache()

Joe Perches (6):
      seq_file: Rename seq_overflow() to seq_has_overflowed() and make public
      netfilter: Convert print_tuple functions to return void
      dlm: Remove seq_printf() return checks and use seq_has_overflowed()
      dlm: Use seq_puts() instead of seq_printf() for constant strings
      fs: Convert show_fdinfo functions to void
      debugfs: Have debugfs_print_regs32() return void

Miklos Szeredi (1):
      vfs: make first argument of dir_context.actor typed

Mikulas Patocka (1):
      dcache: fix kmemcheck warning in switch_names

Steven Rostedt (Red Hat) (2):
      netfilter: Remove return values for print_conntrack callbacks
      netfilter: Remove checks of seq_printf() return values

Diffstat:
 Documentation/filesystems/debugfs.txt              |    2 +-
 Documentation/filesystems/nfs/Exporting            |   23 +-
 Documentation/filesystems/porting                  |    8 +
 Documentation/filesystems/seq_file.txt             |   22 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 arch/alpha/kernel/osf_sys.c                        |    7 +-
 arch/parisc/hpux/fs.c                              |    7 +-
 arch/powerpc/oprofile/cell/spu_task_sync.c         |   10 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |    2 +-
 arch/s390/hypfs/hypfs_dbfs.c                       |    3 +-
 arch/x86/ia32/ia32_aout.c                          |    8 +-
 drivers/block/drbd/drbd_debugfs.c                  |    6 +-
 drivers/gpu/drm/armada/armada_gem.c                |    2 +-
 drivers/media/pci/zoran/zoran_procfs.c             |    4 +-
 drivers/misc/genwqe/card_dev.c                     |    2 +-
 drivers/net/tun.c                                  |    4 +-
 drivers/s390/char/hmcdrv_dev.c                     |   16 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    8 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    4 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   21 +-
 drivers/staging/lustre/lustre/llite/dir.c          |    9 +-
 drivers/staging/lustre/lustre/llite/file.c         |  158 ++-
 .../staging/lustre/lustre/llite/llite_internal.h   |   10 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    8 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |   12 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    8 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |    7 +-
 drivers/staging/lustre/lustre/llite/namei.c        |  388 +++----
 drivers/staging/lustre/lustre/llite/statahead.c    |   33 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |    4 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |    9 +-
 fs/9p/vfs_inode.c                                  |    2 +-
 fs/9p/vfs_inode_dotl.c                             |    4 +-
 fs/affs/amigaffs.c                                 |    2 +-
 fs/affs/inode.c                                    |    4 +-
 fs/affs/namei.c                                    |   40 +-
 fs/afs/dir.c                                       |   80 +-
 fs/afs/inode.c                                     |    4 +-
 fs/afs/mntpt.c                                     |   22 +-
 fs/afs/write.c                                     |    9 +-
 fs/autofs4/expire.c                                |   42 +-
 fs/autofs4/root.c                                  |   25 +-
 fs/befs/linuxvfs.c                                 |   16 +-
 fs/binfmt_aout.c                                   |    8 +-
 fs/btrfs/inode.c                                   |    2 +-
 fs/btrfs/ioctl.c                                   |    2 +-
 fs/cachefiles/namei.c                              |   21 +-
 fs/cachefiles/xattr.c                              |   15 +-
 fs/ceph/debugfs.c                                  |   14 +-
 fs/ceph/dir.c                                      |   56 +-
 fs/ceph/file.c                                     |    6 +-
 fs/ceph/inode.c                                    |   18 +-
 fs/cifs/cifsfs.c                                   |    3 +-
 fs/cifs/cifsglob.h                                 |    6 +
 fs/cifs/file.c                                     |   12 +-
 fs/cifs/inode.c                                    |    2 +-
 fs/cifs/readdir.c                                  |   10 +-
 fs/coda/cache.c                                    |    2 +-
 fs/coda/coda_linux.c                               |    6 -
 fs/coda/coda_linux.h                               |    1 -
 fs/coda/dir.c                                      |   12 +-
 fs/compat.c                                        |   21 +-
 fs/configfs/dir.c                                  |    2 +-
 fs/dcache.c                                        |  271 ++---
 fs/debugfs/file.c                                  |   15 +-
 fs/debugfs/inode.c                                 |    2 +-
 fs/dlm/debug_fs.c                                  |  263 +++--
 fs/ecryptfs/crypto.c                               |    2 +-
 fs/ecryptfs/file.c                                 |    6 +-
 fs/ecryptfs/mmap.c                                 |    2 +-
 fs/efivarfs/file.c                                 |    4 +-
 fs/eventfd.c                                       |    9 +-
 fs/eventpoll.c                                     |   13 +-
 fs/exportfs/expfs.c                                |    7 +-
 fs/fat/dir.c                                       |    5 +-
 fs/fuse/dir.c                                      |    4 +-
 fs/fuse/file.c                                     |    2 +-
 fs/gfs2/export.c                                   |    8 +-
 fs/gfs2/inode.c                                    |   26 +-
 fs/hppfs/hppfs.c                                   |    5 +-
 fs/jfs/namei.c                                     |   18 +-
 fs/kernfs/dir.c                                    |    2 +-
 fs/libfs.c                                         |   12 +-
 fs/lockd/svcsubs.c                                 |    2 +-
 fs/ncpfs/dir.c                                     |   12 +-
 fs/ncpfs/file.c                                    |   14 +-
 fs/ncpfs/mmap.c                                    |    4 +-
 fs/ncpfs/ncplib_kernel.h                           |    4 +-
 fs/nfs/blocklayout/rpc_pipefs.c                    |    2 +-
 fs/nfs/dir.c                                       |    6 +-
 fs/nfs/getroot.c                                   |    4 +-
 fs/nfsd/nfs4recover.c                              |    7 +-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/nfsd/nfsctl.c                                   |   37 +-
 fs/nfsd/vfs.c                                      |   16 +-
 fs/nfsd/vfs.h                                      |    4 +-
 fs/notify/fdinfo.c                                 |   78 +-
 fs/notify/fdinfo.h                                 |    4 +-
 fs/notify/fsnotify.c                               |    4 +-
 fs/ntfs/namei.c                                    |    4 +-
 fs/ocfs2/dcache.c                                  |   20 +-
 fs/ocfs2/dir.c                                     |    8 +-
 fs/ocfs2/dlmfs/dlmfs.c                             |    4 +-
 fs/ocfs2/dlmglue.c                                 |    3 +-
 fs/ocfs2/journal.c                                 |    8 +-
 fs/open.c                                          |    4 +-
 fs/overlayfs/readdir.c                             |    8 +-
 fs/proc/base.c                                     |    4 +-
 fs/proc/fd.c                                       |    3 +-
 fs/readdir.c                                       |   21 +-
 fs/reiserfs/xattr.c                                |   21 +-
 fs/seq_file.c                                      |   15 +-
 fs/signalfd.c                                      |    4 +-
 fs/sync.c                                          |    2 +-
 fs/timerfd.c                                       |   27 +-
 fs/xattr.c                                         |   16 +-
 include/linux/audit.h                              |    9 +
 include/linux/cgroup.h                             |    4 +-
 include/linux/dcache.h                             |    9 +-
 include/linux/debugfs.h                            |    7 +-
 include/linux/fs.h                                 |   13 +-
 include/linux/seq_file.h                           |   15 +
 include/linux/uio.h                                |    6 +
 include/net/netfilter/nf_conntrack_core.h          |    2 +-
 include/net/netfilter/nf_conntrack_l3proto.h       |    4 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |    6 +-
 ipc/mqueue.c                                       |    4 +-
 kernel/auditsc.c                                   |    7 +-
 kernel/events/core.c                               |    2 +-
 kernel/taskstats.c                                 |    2 +-
 kernel/trace/trace.c                               |    4 +-
 kernel/trace/trace_events.c                        |    2 +-
 mm/iov_iter.c                                      | 1058 ++++++++------------
 mm/memcontrol.c                                    |    4 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    6 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   53 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   10 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    6 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   10 +-
 net/netfilter/nf_conntrack_l3proto_generic.c       |    5 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |   14 +-
 net/netfilter/nf_conntrack_proto_generic.c         |    5 +-
 net/netfilter/nf_conntrack_proto_gre.c             |   18 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   14 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   14 +-
 net/netfilter/nf_conntrack_proto_udp.c             |   10 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |   10 +-
 net/netfilter/nf_conntrack_standalone.c            |   77 +-
 net/netfilter/nf_log.c                             |   30 +-
 net/netfilter/nfnetlink_queue_core.c               |   13 +-
 net/netfilter/x_tables.c                           |   19 +-
 net/netfilter/xt_hashlimit.c                       |   36 +-
 security/commoncap.c                               |    2 +-
 security/integrity/ima/ima_api.c                   |    4 +-
 security/integrity/ima/ima_appraise.c              |    4 +-
 security/integrity/ima/ima_template_lib.c          |    2 +-
 security/selinux/selinuxfs.c                       |    6 +-
 security/smack/smack_lsm.c                         |    8 +-
 158 files changed, 1675 insertions(+), 2183 deletions(-)
