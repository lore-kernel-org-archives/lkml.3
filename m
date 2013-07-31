Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab3GaEQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:53 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34980 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab3GaEQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbgzvAAhcOAQEWJig9gkQjGIECA4hDDbhdjSaBIgSFQgOsUSqBLQ
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 00/11] Sync and VFS scalability improvements
Date: Wed, 31 Jul 2013 14:15:39 +1000
Message-Id: <1375244150-27296-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This series of patches is against the curent mmotm tree here:

http://git.cmpxchg.org/cgit/linux-mmotm.git/

It addresses several VFS scalability issues, the most pressing of which is lock
contention triggered by concurrent sync(2) calls.

The patches in the series are:

writeback: plug writeback at a high level

This patch greatly reduces writeback IOPS on XFS when writing lots of small
files. Improves performance by ~20-30% on XFS on fast devices by reducing small
file write IOPS by 95%, but doesn't seem to impact ext4 or btrfs performance or
IOPS in any noticable way.

inode: add IOP_NOTHASHED to avoid inode hash lock in evict

Roughly 5-10% of the spinlock contention on 16-way create workloads on XFS comes
from inode_hash_remove(), even though XFS doesn't use the inode hash and uses
inode_hash_fake() to avoid neeeding to insert inodes into the hash. We still
take the lock to remove it form the hash. This patch avoids the lock on inode
eviction, too.

inode: convert inode_sb_list_lock to per-sb
sync: serialise per-superblock sync operations
inode: rename i_wb_list to i_io_list
bdi: add a new writeback list for sync
writeback: periodically trim the writeback list

This series removes the global inode_sb_list_lock and all the contention points
related to sync(2) The global lock is first converted to a per-filesystem lock
to reduce the scope of global contention, a mutex is add to wait_sb_inodes() to
avoid concurrent sync(2) operations from walking the inode list at the same time
while still guaranteeing sync(2) waits for all the IO it needs to.  It then adds
patches to track inodes under writeback for sync(2) in an optimal manner,
greatly reducing the overhead of sync(2) on large inode caches.

inode: convert per-sb inode list to a list_lru

This patch converts the per-sb list and lock to the per-node list_lru structures
to remove the global lock bottleneck for workloads that have heavy cache
insertion and removal concurrency. A 4-node numa machine saw a 3.5x speedup on
inode cache intensive concurrent bulkstat operation (cycling 1.7 million
inodes/s through the XFS inode cache) as a result of this patch.

c8cb115 fs: Use RCU lookups for inode cache

Lockless inode hash traversals for ext4 and btrfs. Both see signficant speedups
for directory traversal intensive workloads with this patch as it removes the
inode_hash_lock from cache lookups. The inode_hash_lock is still a limiting
factor for inode cache inserts and removals, but that's a much more complex
problem to solve.

8925a8d list_lru: don't need node lock in list_lru_count_node
4411917 list_lru: don't lock during add/del if unnecessary

Optimisations for the list_lru primitives. Because of the sheer number of calls
to these functions under heavy concurrent VFS workloads, these functions show up
quite hot in profiles. Hence making sure we don't take locks when we don't
really need to makes a measurable difference to the CPU consumption shown in the
profiles.


Performance Summary
-------------------

Concurrent sync:

Load 8 million XFs inodes into the cache - all clean - and run
100 concurrent sync calls using;

$ time (for i in `seq 0 1 100`; do sync & done; wait)

		inodes		   total sync time
				  real		 system
mmotm		8366826		146.080s	1481.698s
patched		8560697		  0.109s	   0.346s

System interactivity on mmotm is crap - it's completely CPU bound and takes
seconds to repsond to input.

Run fsmark creating 10 million 4k files with 16 threads, run the above 100
concurrent sync calls when when 1.5 million files have been created.

		fsmark		sync		sync system time
mmotm		259s		502.794s	4893.977s
patched		204s		 62.423s	   3.224s

Note: the difference in fsmark performance on this workload is due to the
first patch in the series - the writeback plugging patch.

Inode cache modification intensive workloads:

Simple workloads:

	- 16 way fsmark to create 51.2 million empty files.
	- multithreaded bulkstat, one thread per AG
	- 16-way 'find /mnt/N -ctime 1' (directory + inode read)
	- 16-way unlink

Storage: 100TB sparse filesystem image with a 1MB extent size hint on XFS on
4x64GB SSD RAID 0 (i.e. thin-provisioned with 1MB allocation granularity):

XFS		create		bulkstat	lookup	unlink
mmotm		4m28s		2m42s		2m20	6m46s
patched		4m22s		0m37s		1m59s	6m45s

create and unlink are no faster as the reduction in lock contention on the
inode lists translated into causing more contention on the XFS transaction
commit code (I have other patches to address that). The bulkstat scaled almost
linearly with the number of inode lists, and lookup improved significantly as
well.

For ext4, I didn't bother with unlinks because they are single threaded due to
the orphan list locking, so it there's not much point in waiting for half an
hour to get the same result each time.

ext4		create		lookup
mmotm		7m35s		4m46
patched		7m40s		2m01s

See the links for more detailed analysis including profiles:

http://oss.sgi.com/archives/xfs/2013-07/msg00084.html
http://oss.sgi.com/archives/xfs/2013-07/msg00110.html

Testing:

- xfstests on 1p, 2p, and 8p VMs, with both xfs and ext4.
- benchmarking using fsmark as per above with xfs, ext4 and btrfs.
- prolonged stress testing with fsstress, dbench and postmark

Comments, thoughts, testing and flames are all welcome....

Cheers,

Dave.

---
 fs/block_dev.c                   |  77 +++++++++------
 fs/drop_caches.c                 |  57 +++++++----
 fs/fs-writeback.c                | 163 ++++++++++++++++++++++++++-----
 fs/inode.c                       | 217 ++++++++++++++++++++++-------------------
 fs/internal.h                    |   1 -
 fs/notify/inode_mark.c           | 111 +++++++++------------
 fs/quota/dquot.c                 | 174 +++++++++++++++++++++------------
 fs/super.c                       |  11 ++-
 fs/xfs/xfs_iops.c                |   2 +
 include/linux/backing-dev.h      |   3 +
 include/linux/fs.h               |  16 ++-
 include/linux/fsnotify_backend.h |   2 +-
 mm/backing-dev.c                 |   7 +-
 mm/list_lru.c                    |  14 +--
 mm/page-writeback.c              |  14 +++
 15 files changed, 550 insertions(+), 319 deletions(-)

