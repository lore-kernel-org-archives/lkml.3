Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3KNRG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:06:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60377 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3KNRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:06:17 -0500
Date: Thu, 14 Nov 2013 10:06:16 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] 2nd round block driver updates for 3.13-rc1
Message-ID: <20131114170616.GB7533@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As mentioned in the original pull request, the bcache bits were pulled
because of their dependency on the immutable bio vecs. Kent redid this
part and resubmitted it, so here's the 2nd round of (mostly) driver
updates for 3.13. It contains:

- The bcache work from Kent.

- Conversion of virtio-blk to blk-mq. This removes the bio and request
  path, and substitutes with the blk-mq path instead. The end result
  almost 200 deleted lines. Patch is acked by Asias and Christoph, who
  both did a bunch of testing.

- A removal of bootmem.h include from Grygorii Strashko, part of a
  larger series of his killing the dependency on that header file.

- Removal of __cpuinit from blk-mq from Paul Gortmaker.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to 1cf7e9c68fe84248174e998922b39e508375e7c1:

  virtio_blk: blk-mq support (2013-11-14 08:40:44 -0700)

----------------------------------------------------------------
Grygorii Strashko (1):
      block: cleanup removing dependency on bootmem headers

Jens Axboe (2):
      Merge branch 'for-3.13/post-mq-drivers' into for-linus
      virtio_blk: blk-mq support

Kees Cook (1):
      bcache: defensively handle format strings

Kent Overstreet (52):
      bcache: Fix dirty_data accounting
      bcache: Fix a journalling performance bug
      bcache: Fix a lockdep splat
      bcache: Use blkdev_issue_discard()
      bcache: Add on error panic/unregister setting
      bcache: Stripe size isn't necessarily a power of two
      bcache: Remove unnecessary check in should_split()
      bcache: Explicitly track btree node's parent
      bcache: Add btree_insert_node()
      bcache: Insert multiple keys at a time
      bcache: Convert btree_insert_check_key() to btree_insert_node()
      bcache: Add explicit keylist arg to btree_insert()
      bcache: Clean up keylist code
      bcache: Refactor request_write()
      bcache: Refactor read request code a bit
      bcache: Refactor journalling flow control
      bcache: Move keylist out of btree_op
      bcache: Convert try_wait to wait_queue_head_t
      bcache: Convert bucket_wait to wait_queue_head_t
      bcache: Convert gc to a kthread
      bcache: Convert writeback to a kthread
      bcache: Add btree_map() functions
      bcache: Move some stuff to btree.c
      bcache: Convert bch_btree_read_async() to bch_btree_map_keys()
      bcache: Clean up cache_lookup_fn
      bcache: Prune struct btree_op
      bcache: Kill op->cl
      bcache: Drop some closure stuff
      bcache: Kill op->replace
      bcache: Don't use op->insert_collision
      bcache: Convert bch_btree_insert() to bch_btree_map_leaf_nodes()
      bcache: Break up struct search
      bcache: Move sector allocator to alloc.c
      bcache: Pull on disk data structures out into a separate header
      bcache: Fix bch_ptr_bad()
      bcache: Debug code improvements
      bcache: Don't bother with bucket refcount for btree node allocations
      bcache: bch_(btree|extent)_ptr_invalid()
      bcache: PRECEDING_KEY()
      bcache: Add btree_node_write_sync()
      bcache: Add make_btree_freeing_key()
      bcache: Incremental gc
      bcache: Avoid deadlocking in garbage collection
      bcache: Kill bch_next_recurse_key()
      bcache: Kill sequential_merge option
      bcache: Move spinlock into struct time_stats
      bcache: Have btree_split() insert into parent directly
      bcache: Better full stripe scanning
      bcache: Fix sysfs splat on shutdown with flash only devs
      bcache: Use ida for bcache block dev minor
      bcache: Delete some slower inline asm
      bcache: Bypass torture test

Paul Gortmaker (1):
      blk-mq: remove newly added instances of __cpuinit

 block/blk-ioc.c               |    1 -
 block/blk-mq-cpu.c            |    8 +-
 block/blk-mq.c                |    6 +-
 drivers/block/virtio_blk.c    |  322 ++--------
 drivers/md/bcache/Kconfig     |   11 +-
 drivers/md/bcache/alloc.c     |  383 ++++++-----
 drivers/md/bcache/bcache.h    |  327 +---------
 drivers/md/bcache/bset.c      |  289 ++++-----
 drivers/md/bcache/bset.h      |   93 +--
 drivers/md/bcache/btree.c     | 1396 ++++++++++++++++++++++-------------------
 drivers/md/bcache/btree.h     |  195 ++----
 drivers/md/bcache/closure.c   |  103 +--
 drivers/md/bcache/closure.h   |  183 +-----
 drivers/md/bcache/debug.c     |  185 +++---
 drivers/md/bcache/debug.h     |   50 +-
 drivers/md/bcache/journal.c   |  293 +++++----
 drivers/md/bcache/journal.h   |   52 +-
 drivers/md/bcache/movinggc.c  |   87 ++-
 drivers/md/bcache/request.c   | 1102 ++++++++++++++++----------------
 drivers/md/bcache/request.h   |   43 +-
 drivers/md/bcache/stats.c     |   26 +-
 drivers/md/bcache/stats.h     |   13 +-
 drivers/md/bcache/super.c     |  190 +++---
 drivers/md/bcache/sysfs.c     |   42 +-
 drivers/md/bcache/trace.c     |    1 -
 drivers/md/bcache/util.c      |   12 +-
 drivers/md/bcache/util.h      |   15 +-
 drivers/md/bcache/writeback.c |  455 +++++++-------
 drivers/md/bcache/writeback.h |   46 +-
 include/trace/events/bcache.h |   47 +-
 include/uapi/linux/bcache.h   |  373 +++++++++++
 31 files changed, 3069 insertions(+), 3280 deletions(-)
 create mode 100644 include/uapi/linux/bcache.h

-- 
Jens Axboe

