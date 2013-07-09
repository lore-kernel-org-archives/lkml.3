Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3GIBRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:17:44 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11414 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3GIBRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:17:41 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v6 00/14] Lockless update of reference count protected by spinlock
Date: Mon,  8 Jul 2013 21:09:50 -0400
Message-Id: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5->v6:
 - Add a new GENERIC_SPINLOCK_REFCOUNT config parameter for using the
   generic implementation.
 - Add two parameters LOCKREF_WAIT_SHIFT and LOCKREF_RETRY_COUNT which
   can be specified differently for each architecture.
 - Update various spinlock_refcount.* files to incorporate review
   comments.
 - Replace reference of d_refcount() macro in Lustre filesystem code in
   the staging tree to use the new d_count() helper function.

v4->v5:
 - Add a d_count() helper for readonly access of reference count and
   change all references to d_count outside of dcache.c, dcache.h
   and namei.c to use d_count().

v3->v4:
 - Replace helper function access to d_lock and d_count by using
   macros to redefine the old d_lock name to the spinlock and new
   d_refcount name to the reference count. This greatly reduces the
   size of this patchset from 25 to 12 and make it easier to review.

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
modified to use the new lockref data structure and the d_lock name
is now a macro to the actual spinlock. The d_count name, however,
cannot be reused as it has collision elsewhere in the kernel. So a
new d_refcount macro is now used for the reference count and files
outside of dcache.c, dcache.h and namei.c are modified to use the
d_count() helper function.

The various patches were applied and built one-by-one to make sure
that there were no broken build.

This patch set causes significant performance improvement in the
short workload of the AIM7 benchmark on a 8-socket x86-64 machine
with 80 cores.

patch 1:	Introduce the new lockref data structure
patch 2:	Enable x86 architecture to use the feature
patch 3:	Introduce the new d_count() helper function
patches 4-11:	Rename all d_count references to d_count() helper
patch 12:	Replace d_refcount() macro to d_count() helper
patch 13:	Rename the d_count field to d_refcount
patch 14:	Change the dentry structure to use the lockref
		structure to improve performance for high contention
		cases

Thank to Thomas Gleixner, Andi Kleen and Linus for their valuable
input in shaping this patchset.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (14):
  spinlock: A new lockref structure for lockless update of refcount
  spinlock: Enable x86 architecture to do lockless refcount update
  dcache: Add a new helper function d_count() to return refcount
  auto-fs: replace direct access of d_count with the d_count() helper
  ceph-fs: replace direct access of d_count with the d_count() helper
  coda-fs: replace direct access of d_count with the d_count() helper
  config-fs: replace direct access of d_count with the d_count() helper
  ecrypt-fs: replace direct access of d_count with the d_count() helper
  file locking: replace direct access of d_count with the d_count()
    helper
  nfs: replace direct access of d_count with the d_count() helper
  nilfs2: replace direct access of d_count with the d_count() helper
  lustre-fs: Use the standard d_count() helper to access refcount
  dcache: rename d_count field of dentry to d_refcount
  dcache: Enable lockless update of refcount in dentry structure

 arch/x86/Kconfig                                   |    3 +
 .../lustre/include/linux/lustre_patchless_compat.h |    2 -
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    2 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |    8 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |    4 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    2 +-
 drivers/staging/lustre/lustre/llite/namei.c        |    4 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    4 +-
 fs/autofs4/expire.c                                |    8 +-
 fs/autofs4/root.c                                  |    2 +-
 fs/ceph/inode.c                                    |    4 +-
 fs/ceph/mds_client.c                               |    2 +-
 fs/coda/dir.c                                      |    2 +-
 fs/configfs/dir.c                                  |    2 +-
 fs/dcache.c                                        |   72 ++++---
 fs/ecryptfs/inode.c                                |    2 +-
 fs/locks.c                                         |    2 +-
 fs/namei.c                                         |    6 +-
 fs/nfs/dir.c                                       |    6 +-
 fs/nfs/unlink.c                                    |    2 +-
 fs/nilfs2/super.c                                  |    2 +-
 include/asm-generic/spinlock_refcount.h            |   46 ++++
 include/linux/dcache.h                             |   31 ++-
 include/linux/spinlock_refcount.h                  |  142 +++++++++++++
 kernel/Kconfig.locks                               |   15 ++
 lib/Makefile                                       |    2 +
 lib/spinlock_refcount.c                            |  218 ++++++++++++++++++++
 27 files changed, 519 insertions(+), 76 deletions(-)
 create mode 100644 include/asm-generic/spinlock_refcount.h
 create mode 100644 include/linux/spinlock_refcount.h
 create mode 100644 lib/spinlock_refcount.c

