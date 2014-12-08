Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaLHQQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:16:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbaLHQQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:16:14 -0500
Date: Mon, 8 Dec 2014 11:16:01 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Milan Broz <gmazyland@gmail.com>,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: [git pull] device mapper changes for 3.19
Message-ID: <20141208161600.GA28316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 9b460d3699324d570a4d4161c3741431887f102f:

  dm btree: fix a recursion depth bug in btree walking code (2014-11-10 15:23:58 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.19-changes

for you to fetch changes up to 1a71d6ffe18c0d0f03fc8531949cc8ed41d702ee:

  dm crypt: use memzero_explicit for on-stack buffer (2014-12-02 10:25:07 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Significant DM thin-provisioning performance improvements to meet
  performance requirements that were requested by the Gluster
  distributed filesystem.  Specifically, dm-thinp now takes care to
  aggregate IO that will be issued to the same thinp block before
  issuing IO to the underlying devices.  This really helps improve
  performance on HW RAID6 devices that have a writeback cache because it
  avoids RMW in the HW RAID controller.

- Some stable fixes: fix leak in DM bufio if integrity profiles were
  enabled, use memzero_explicit in DM crypt to avoid any potential for
  information leak, and a DM cache fix to properly mark a cache block
  dirty if it was promoted to the cache via the overwrite optimization.

- A few simple DM persistent data library fixes

- DM cache multiqueue policy block promotion improvements.

- DM cache discard improvements that take advantage of range
  (multiblock) discard support in the DM bio-prison.  This allows for
  much more efficient bulk discard processing (e.g. when mkfs.xfs
  discards the entire device).

- Some small optimizations in DM core and RCU deference cleanups

- DM core changes to suspend/resume code to introduce the new internal
  suspend/resume interface that the DM thin-pool target now uses to
  suspend/resume active thin devices when the thin-pool must
  suspend/resume.  This avoids forcing userspace to track all active
  thin volumes in a thin-pool when the thin-pool is suspended for the
  purposes of metadata or data space resize.

----------------------------------------------------------------
Dan Carpenter (1):
      dm space map metadata: fix sm_bootstrap_get_nr_blocks()

Darrick J. Wong (1):
      dm bufio: fix memleak when using a dm_buffer's inline bio

Eric Dumazet (1):
      dm: use rcu_dereference_protected instead of rcu_dereference

Hannes Reinecke (1):
      dm: do not call dm_sync_table() when creating new devices

Joe Thornber (27):
      dm bufio: switch from a huge hash table to an rbtree
      dm bufio: evict buffers that are past the max age but retain some buffers
      dm bio prison: switch to using a red black tree
      dm thin metadata: change dm_thin_find_block to allow blocking, but not issuing, IO
      dm transaction manager: add support for prefetching blocks of metadata
      dm thin: prefetch missing metadata pages
      dm thin: throttle incoming IO
      dm thin: performance improvement to discard processing
      dm thin: defer whole cells rather than individual bios
      dm thin: remap the bios in a cell immediately
      dm thin: direct dispatch when breaking sharing
      dm thin: sort the deferred cells
      dm cache policy mq: tweak algorithm that decides when to promote a block
      dm bio prison: introduce support for locking ranges of blocks
      dm cache: revert "remove remainder of distinct discard block size"
      dm cache: revert "prevent corruption caused by discard_block_size > cache_block_size"
      dm cache: improve discard support
      dm cache: emit a warning message if there are a lot of cache blocks
      dm array: if resizing the array is a noop set the new root to the old one
      dm cache: fix some issues with the new discard range support
      dm cache: when reloading a discard bitset allow for a different discard block size
      dm cache: fix a harmless race when working out if a block is discarded
      dm cache: discard block size must be a multiple of cache block size
      dm cache: only use overwrite optimisation for promotion when in writeback mode
      dm cache: dirty flag was mistakenly being cleared when promoting via overwrite
      dm cache: fix spurious cell_defer when dealing with partial block at end of device
      dm space map metadata: fix sm_bootstrap_get_count()

Mike Snitzer (14):
      dm thin: adjust max_sectors_kb based on thinp blocksize
      dm: improve documentation and code clarity in dm_merge_bvec
      dm thin: implement thin_merge
      dm thin: factor out remap_and_issue_overwrite
      dm thin: optimize retry_bios_on_resume
      dm thin: refactor requeue_io to eliminate spinlock bouncing
      dm cache policy mq: simplify ability to promote sequential IO to the cache
      dm thin: remove stale 'trim' message in block comment above pool_message
      dm: return earlier from dm_blk_ioctl if target doesn't implement .ioctl
      dm: add presuspend_undo hook to target_type
      dm thin: do not allow thin device activation while pool is suspended
      dm: enhance internal suspend and resume interface
      dm thin: suspend/resume active thin devices when reloading thin-pool
      dm thin: fix pool_io_hints to avoid looking at max_hw_sectors

Mikulas Patocka (1):
      dm thin: fix a race in thin_dtr

Milan Broz (1):
      dm crypt: use memzero_explicit for on-stack buffer

Pranith Kumar (2):
      dm: Use rcu_dereference() for accessing rcu pointer
      dm: sparse: Annotate field with __rcu for checking

 Documentation/device-mapper/cache-policies.txt     |  24 +-
 drivers/md/dm-bio-prison.c                         | 186 +++--
 drivers/md/dm-bio-prison.h                         |  28 +-
 drivers/md/dm-bufio.c                              | 226 +++---
 drivers/md/dm-cache-block-types.h                  |  11 +
 drivers/md/dm-cache-metadata.c                     |  34 +-
 drivers/md/dm-cache-metadata.h                     |   6 +-
 drivers/md/dm-cache-policy-mq.c                    |  82 ++-
 drivers/md/dm-cache-target.c                       | 378 +++++++---
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/dm-ioctl.c                              |   5 +-
 drivers/md/dm-stats.c                              |   2 +-
 drivers/md/dm-table.c                              |  36 +-
 drivers/md/dm-thin-metadata.c                      |  35 +-
 drivers/md/dm-thin-metadata.h                      |   9 +-
 drivers/md/dm-thin.c                               | 760 ++++++++++++++++-----
 drivers/md/dm.c                                    | 273 ++++++--
 drivers/md/dm.h                                    |  10 +
 drivers/md/persistent-data/dm-array.c              |   4 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   8 +-
 .../md/persistent-data/dm-transaction-manager.c    |  77 ++-
 .../md/persistent-data/dm-transaction-manager.h    |   7 +
 include/linux/device-mapper.h                      |   2 +
 include/uapi/linux/dm-ioctl.h                      |   9 +-
 24 files changed, 1634 insertions(+), 580 deletions(-)
