Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab3GCUTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:19:36 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20195 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab3GCUTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:19:34 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 00/25] Lockless update of reference count protected by spinlock
Date: Wed,  3 Jul 2013 16:18:58 -0400
Message-Id: <1372882741-22563-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:
 - Completely revamp the packaging by adding a new lockref data
   structure that combines the spinlock with the reference
   count. Helper functions are also added to manipulate the new data
   structure. That results in modifying over 50 files, but the changes
   were trivial in most of them.
 - Change initial spinlock wait to use a timeout.
 - Force 64-bit alignment of the spinlock & reference count structure.
 - Add a new way to use the combo by using a new union and helper
   functions.

v1->v2:
 - Add one more layer of indirection to LOCK_WITH_REFCOUNT macro.
 - Add __LINUX_SPINLOCK_REFCOUNT_H protection to spinlock_refcount.h.
 - Add some generic get/put macros into spinlock_refcount.h.

This patchset supports a generic mechanism to atomically update
a reference count that is protected by a spinlock without actually
acquiring the lock itself. If the update doesn't succeeed, the caller
will have to acquire the lock and update the reference count in the
the old way.  This will help in situation where there is a lot of
spinlock contention because of frequent reference count update.

The d_lock and d_count fields of the struct dentry in dcache.h was
modified to use the new lockref data structure and the associated
helper functions to access the spinlock and the reference count. This
change cause significant performance improvement in the short workload
of the AIM7 benchmark on a 8-socket x86-64 machine with 80 cores.

patch 1: Introduce the new lockref data structure
patch 2: Enable x86 architecture to use the feature
patch 3: Change the dentry structure to use lockref to improve
	 performance for high contention situation
patches 4-25: Use new helper functions to access the d_lock and
	      d_count fields of the original dentry structure.

Thank to Thomas Gleixner, Andi Kleen and Linus for their valuable
input in shaping this patchset.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (25):
  spinlock: A new lockref structure for lockless update of refcount
  spinlock: Enable x86 architecture to do lockless refcount update
  dcache: Enable lockless update of d_count in dentry structure
  powerpc: Change how dentry's d_lock field is accessed
  infiniband: Change how dentry's d_lock field is accessed
  9p-fs: Change how dentry's d_lock field is accessed
  afs-fs: Change how dentry's d_lock field is accessed
  auto-fs: Change how dentry's d_lock and d_count fields are accessed
  ceph-fs: Change how dentry's d_lock and d_count fields are accessed
  cifs: Change how dentry's d_lock field is accessed
  coda-fs: Change how dentry's d_lock and d_count fields are accessed
  config-fs: Change how dentry's d_lock and d_count fields are accessed
  vfs: Change how dentry's d_lock and d_count fields are accessed
  ecrypt-fs: Change how dentry's d_count field is accessed
  export-fs: Change how dentry's d_lock field is accessed
  vfat: Change how dentry's d_lock field is accessed
  file locking: Change how dentry's d_lock and d_count fields are
    accessed
  ncp-fs: Change how dentry's d_lock field is accessed
  nfs: Change how dentry's d_lock and d_count fields are accessed
  nilfs2: Change how dentry's d_count field is accessed
  fsnotify: Change how dentry's d_lock field is accessed
  ocfs2: Change how dentry's d_lock field is accessed
  cgroup: Change how dentry's d_lock field is accessed
  sunrpc: Change how dentry's d_lock field is accessed
  selinux: Change how dentry's d_lock field is accessed

 arch/powerpc/platforms/cell/spufs/inode.c |    6 +-
 arch/x86/Kconfig                          |    3 +
 arch/x86/include/asm/spinlock_refcount.h  |    1 +
 drivers/infiniband/hw/ipath/ipath_fs.c    |    6 +-
 drivers/infiniband/hw/qib/qib_fs.c        |    6 +-
 fs/9p/fid.c                               |   14 +-
 fs/afs/dir.c                              |    4 +-
 fs/autofs4/autofs_i.h                     |   24 +-
 fs/autofs4/expire.c                       |   48 ++--
 fs/autofs4/root.c                         |   14 +-
 fs/ceph/caps.c                            |    8 +-
 fs/ceph/debugfs.c                         |    8 +-
 fs/ceph/dir.c                             |   34 ++--
 fs/ceph/export.c                          |    4 +-
 fs/ceph/inode.c                           |   24 +-
 fs/ceph/mds_client.c                      |   22 +-
 fs/cifs/dir.c                             |   10 +-
 fs/coda/cache.c                           |    4 +-
 fs/coda/dir.c                             |    4 +-
 fs/configfs/configfs_internal.h           |    4 +-
 fs/configfs/dir.c                         |    2 +-
 fs/configfs/inode.c                       |    6 +-
 fs/dcache.c                               |  324 +++++++++++++++--------------
 fs/dcookies.c                             |    8 +-
 fs/ecryptfs/inode.c                       |    2 +-
 fs/exportfs/expfs.c                       |    8 +-
 fs/fat/namei_vfat.c                       |    4 +-
 fs/fs-writeback.c                         |    4 +-
 fs/libfs.c                                |   36 ++--
 fs/locks.c                                |    2 +-
 fs/namei.c                                |   28 ++--
 fs/namespace.c                            |   10 +-
 fs/ncpfs/dir.c                            |    6 +-
 fs/ncpfs/ncplib_kernel.h                  |    8 +-
 fs/nfs/dir.c                              |   14 +-
 fs/nfs/getroot.c                          |    8 +-
 fs/nfs/namespace.c                        |   16 +-
 fs/nfs/unlink.c                           |   22 +-
 fs/nilfs2/super.c                         |    2 +-
 fs/notify/fsnotify.c                      |    8 +-
 fs/notify/vfsmount_mark.c                 |   24 +-
 fs/ocfs2/dcache.c                         |    6 +-
 include/asm-generic/spinlock_refcount.h   |   98 +++++++++
 include/linux/dcache.h                    |   52 ++++--
 include/linux/fs.h                        |    4 +-
 include/linux/fsnotify_backend.h          |    6 +-
 include/linux/spinlock_refcount.h         |  159 ++++++++++++++
 kernel/Kconfig.locks                      |    5 +
 kernel/cgroup.c                           |   10 +-
 lib/Makefile                              |    2 +
 lib/spinlock_refcount.c                   |  229 ++++++++++++++++++++
 net/sunrpc/rpc_pipe.c                     |    6 +-
 security/selinux/selinuxfs.c              |   14 +-
 53 files changed, 958 insertions(+), 423 deletions(-)
 create mode 100644 arch/x86/include/asm/spinlock_refcount.h
 create mode 100644 include/asm-generic/spinlock_refcount.h
 create mode 100644 include/linux/spinlock_refcount.h
 create mode 100644 lib/spinlock_refcount.c

