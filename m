Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaJHQ0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:26:41 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52466 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJHQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:26:39 -0400
Date: Wed, 8 Oct 2014 12:26:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: [GIT PULL] percpu changes for v3.18-rc1
Message-ID: <20141008162636.GE8184@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A lot of activities on percpu front.  Notable changes are...

* percpu allocator now can take @gfp.  If @gfp doesn't contain
  GFP_KERNEL, it tries to allocate from what's already available to
  the allocator and a work item tries to keep the reserve around
  certain level so that these atomic allocations usually succeed.

  This will replace the ad-hoc percpu memory pool used by blk-throttle
  and also be used by the planned blkcg support for writeback IOs.

  Please note that I noticed a bug in how @gfp is interpreted while
  preparing this pull request and applied the fix 6ae833c7fe0c
  ("percpu: fix how @gfp is interpreted by the percpu allocator") just
  now.

* percpu_ref now uses longs for percpu and global counters instead of
  ints.  It leads to more sparse packing of the percpu counters on
  64bit machines but the overhead should be negligible and this allows
  using percpu_ref for refcnting pages and in-memory objects directly.

* The switching between percpu and single counter modes of a
  percpu_ref is made independent of putting the base ref and a
  percpu_ref can now optionally be initialized in single or killed
  mode.  This allows avoiding percpu shutdown latency for cases where
  the refcounted objects may be synchronously created and destroyed in
  rapid succession with only a fraction of them reaching fully
  operational status (SCSI probing does this when combined with blk-mq
  support).  It's also planned to be used to implement forced single
  mode to detect underflow more timely for debugging.

There's a separate branch percpu/for-3.18-consistent-ops which cleans
up the duplicate percpu accessors.  That branch causes a number of
conflicts with s390 and other trees.  I'll send a separate pull
request w/ resolutions once other branches are merged.

Thanks.

The following changes since commit 0a30288da1aec914e158c2d7a3482a85f632750f:

  blk-mq, percpu_ref: implement a kludge for SCSI blk-mq stall during probe (2014-09-24 08:29:36 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.18

for you to fetch changes up to 6ae833c7fe0c6ef1f0ab13cc775da230d6f4c256:

  percpu: fix how @gfp is interpreted by the percpu allocator (2014-10-08 12:01:52 -0400)

----------------------------------------------------------------
Guenter Roeck (1):
      Revert "percpu: free percpu allocation info for uniprocessor system"

Tejun Heo (33):
      percpu: remove the usage of separate populated bitmap in percpu-vm
      percpu: remove @may_alloc from pcpu_get_pages()
      percpu: move common parts out of pcpu_[de]populate_chunk()
      percpu: move region iterations out of pcpu_[de]populate_chunk()
      percpu: make percpu-km set chunk->populated bitmap properly
      percpu: restructure locking
      percpu: make pcpu_alloc_area() capable of allocating only from populated areas
      percpu: indent the population block in pcpu_alloc()
      percpu: implement [__]alloc_percpu_gfp()
      percpu: make sure chunk->map array has available space
      percpu: implmeent pcpu_nr_empty_pop_pages and chunk->nr_populated
      percpu: rename pcpu_reclaim_work to pcpu_balance_work
      percpu: implement asynchronous chunk population
      percpu_counter: make percpu_counters_lock irq-safe
      percpu_counter: add @gfp to percpu_counter_init()
      proportions: add @gfp to init functions
      percpu-refcount: add @gfp to percpu_ref_init()
      percpu: fix locking regression in the failure path of pcpu_alloc()
      percpu-refcount: improve WARN messages
      percpu-refcount: make percpu_ref based on longs instead of ints
      Merge branch 'for-linus' of git://git.kernel.org/.../axboe/linux-block into for-3.18
      Revert "blk-mq, percpu_ref: implement a kludge for SCSI blk-mq stall during probe"
      percpu_ref: relocate percpu_ref_reinit()
      percpu_ref: minor code and comment updates
      percpu_ref: replace pcpu_ prefix with percpu_
      percpu_ref: rename things to prepare for decoupling percpu/atomic mode switch
      percpu_ref: add PCPU_REF_DEAD
      percpu_ref: decouple switching to atomic mode and killing
      percpu_ref: decouple switching to percpu mode and reinit
      percpu_ref: add PERCPU_REF_INIT_* flags
      percpu_ref: make INIT_ATOMIC and switch_to_atomic() sticky
      blk-mq, percpu_ref: start q->mq_usage_counter in atomic mode
      percpu: fix how @gfp is interpreted by the percpu allocator

 arch/x86/kvm/mmu.c               |   2 +-
 block/blk-mq-sysfs.c             |   6 +
 block/blk-mq.c                   |  18 +-
 block/blk-sysfs.c                |  11 +-
 drivers/target/target_core_tpg.c |   3 +-
 fs/aio.c                         |   4 +-
 fs/btrfs/disk-io.c               |   8 +-
 fs/btrfs/extent-tree.c           |   2 +-
 fs/ext2/super.c                  |   6 +-
 fs/ext3/super.c                  |   6 +-
 fs/ext4/super.c                  |  14 +-
 fs/file_table.c                  |   2 +-
 fs/quota/dquot.c                 |   2 +-
 fs/super.c                       |   3 +-
 include/linux/blk-mq.h           |   1 +
 include/linux/flex_proportions.h |   5 +-
 include/linux/percpu-refcount.h  | 122 +++++----
 include/linux/percpu.h           |  13 +-
 include/linux/percpu_counter.h   |  10 +-
 include/linux/proportions.h      |   5 +-
 include/net/dst_ops.h            |   2 +-
 include/net/inet_frag.h          |   2 +-
 kernel/cgroup.c                  |   7 +-
 lib/flex_proportions.c           |   8 +-
 lib/percpu-refcount.c            | 305 ++++++++++++++++-------
 lib/percpu_counter.c             |  20 +-
 lib/proportions.c                |  10 +-
 mm/backing-dev.c                 |   4 +-
 mm/mmap.c                        |   2 +-
 mm/nommu.c                       |   2 +-
 mm/page-writeback.c              |   2 +-
 mm/percpu-km.c                   |  16 +-
 mm/percpu-vm.c                   | 162 +++---------
 mm/percpu.c                      | 526 +++++++++++++++++++++++++++++++--------
 mm/shmem.c                       |   2 +-
 net/dccp/proto.c                 |   2 +-
 net/ipv4/tcp.c                   |   4 +-
 net/ipv4/tcp_memcontrol.c        |   2 +-
 net/sctp/protocol.c              |   2 +-
 39 files changed, 879 insertions(+), 444 deletions(-)

-- 
tejun
