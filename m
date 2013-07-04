Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab3GDDd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:33:27 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:36893 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab3GDDd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:33:26 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 00/12] Lockless update of reference count protected by spinlock
Date: Wed,  3 Jul 2013 23:32:48 -0400
Message-Id: <1372908771-33260-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
new d_refcount name is now used for the reference count.

This patch set causes significant performance improvement in the
short workload of the AIM7 benchmark on a 8-socket x86-64 machine
with 80 cores.

patch 1:	Introduce the new lockref data structure
patch 2:	Enable x86 architecture to use the feature
patches 3-11:	Rename all the d_count references to d_refcount
patch 12:	Change the dentry structure to use the lockref
		structure to improve performance for high contention
		cases

Thank to Thomas Gleixner, Andi Kleen and Linus for their valuable
input in shaping this patchset.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (12):
  spinlock: A new lockref structure for lockless update of refcount
  spinlock: Enable x86 architecture to do lockless refcount update
  dcache: rename d_count field of dentry to d_refcount
  auto-fs: rename d_count field of dentry to d_refcount
  ceph-fs: rename d_count field of dentry to d_refcount
  coda-fs: rename d_count field of dentry to d_refcount
  config-fs: rename d_count field of dentry to d_refcount
  ecrypt-fs: rename d_count field of dentry to d_refcount
  file locking: rename d_count field of dentry to d_refcount
  nfs: rename d_count field of dentry to d_refcount
  nilfs2: rename d_count field of dentry to d_refcount
  dcache: Enable lockless update of refcount in dentry structure

 arch/x86/Kconfig                         |    3 +
 arch/x86/include/asm/spinlock_refcount.h |    1 +
 fs/autofs4/expire.c                      |    8 +-
 fs/autofs4/root.c                        |    2 +-
 fs/ceph/inode.c                          |    4 +-
 fs/ceph/mds_client.c                     |    2 +-
 fs/coda/dir.c                            |    4 +-
 fs/configfs/dir.c                        |    2 +-
 fs/dcache.c                              |   72 +++++-----
 fs/ecryptfs/inode.c                      |    2 +-
 fs/locks.c                               |    2 +-
 fs/namei.c                               |    6 +-
 fs/nfs/dir.c                             |    8 +-
 fs/nfs/unlink.c                          |    2 +-
 fs/nilfs2/super.c                        |    2 +-
 include/asm-generic/spinlock_refcount.h  |   46 ++++++
 include/linux/dcache.h                   |   21 ++--
 include/linux/spinlock_refcount.h        |  107 ++++++++++++++
 kernel/Kconfig.locks                     |    5 +
 lib/Makefile                             |    2 +
 lib/spinlock_refcount.c                  |  229 ++++++++++++++++++++++++++++++
 21 files changed, 466 insertions(+), 64 deletions(-)
 create mode 100644 arch/x86/include/asm/spinlock_refcount.h
 create mode 100644 include/asm-generic/spinlock_refcount.h
 create mode 100644 include/linux/spinlock_refcount.h
 create mode 100644 lib/spinlock_refcount.c

