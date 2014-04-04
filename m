Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaDDTLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbaDDTK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:10:58 -0400
Date: Fri, 4 Apr 2014 15:10:54 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jose Castillo <jcastillo@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: [git pull] device mapper changes for 3.15
Message-ID: <20140404191053.GA14111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:

  Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.15-changes

for you to fetch changes up to 0596661f0a16d9d69bf1033320e70b6ff52b5e81:

  dm cache: fix a lock-inversion (2014-04-04 14:53:05 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
. Fix dm-cache corruption caused by discard_block_size >
  cache_block_size

. Fix a lock-inversion detected by LOCKDEP in dm-cache

. Fix a dangling bio bug in the dm-thinp target's process_deferred_bios
  error path

. Fix corruption due to non-atomic transaction commit which allowed a
  metadata superblock to be written before all other metadata was
  successfully written -- this is common to all targets that use the
  persistent-data library's transaction manager (dm-thinp, dm-cache and
  dm-era).

. Various small cleanups in the DM core

. Add the dm-era target which is useful for keeping track of which
  blocks were written within a user defined period of time called an
  'era'.  Use cases include tracking changed blocks for backup software,
  and partially invalidating the contents of a cache to restore cache
  coherency after rolling back a vendor snapshot.

. Improve the on-disk layout of multithreaded writes to the dm-thin-pool
  by splitting the pool's deferred bio list to be a per-thin device list
  and then sorting that list using an rb_tree.  The subsequent read
  throughput of the data written via multiple threads improved by ~70%.

. Simplify the multipath target's handling of queuing IO by pushing
  requests back to the request queue rather than queueing the IO
  internally.

----------------------------------------------------------------
Hannes Reinecke (6):
      dm mpath: do not call pg_init when it is already running
      dm mpath: push back requests instead of queueing
      dm mpath: remove process_queued_ios()
      dm mpath: reduce memory pressure when requeuing
      dm mpath: remove map_io()
      dm-mpath: do not activate failed paths

Heinz Mauelshagen (1):
      dm cache: remove remainder of distinct discard block size

Joe Thornber (5):
      dm: add era target
      dm bitset: only flush the current word if it has been dirtied
      dm transaction manager: fix corruption due to non-atomic transaction commit
      dm: take care to copy the space map roots before locking the superblock
      dm cache: fix a lock-inversion

Jose Castillo (1):
      dm mpath: print more useful warnings in multipath_message()

Mike Snitzer (7):
      dm cache: prevent corruption caused by discard_block_size > cache_block_size
      dm table: add dm_table_run_md_queue_async
      dm mpath: remove extra nesting in map function
      dm thin: fix dangling bio in process_deferred_bios error path
      dm thin: simplify pool_is_congested
      dm thin: use per thin device deferred bio lists
      dm thin: sort the per thin deferred bios using an rb_tree

Mikulas Patocka (3):
      dm: make dm_table_alloc_md_mempools static
      dm: remove dm_get_mapinfo
      dm: stop using bi_private

Monam Agarwal (1):
      dm: use RCU_INIT_POINTER instead of rcu_assign_pointer in __unbind

 Documentation/device-mapper/era.txt                |  108 ++
 drivers/md/Kconfig                                 |   11 +
 drivers/md/Makefile                                |    2 +
 drivers/md/dm-cache-block-types.h                  |   11 -
 drivers/md/dm-cache-metadata.c                     |  132 +-
 drivers/md/dm-cache-metadata.h                     |   15 +-
 drivers/md/dm-cache-target.c                       |  131 +-
 drivers/md/dm-era-target.c                         | 1746 ++++++++++++++++++++
 drivers/md/dm-mpath.c                              |  219 +--
 drivers/md/dm-table.c                              |   21 +-
 drivers/md/dm-thin-metadata.c                      |   80 +-
 drivers/md/dm-thin.c                               |  263 ++-
 drivers/md/dm.c                                    |   24 +-
 drivers/md/dm.h                                    |    2 +-
 drivers/md/persistent-data/dm-bitset.c             |   10 +-
 drivers/md/persistent-data/dm-bitset.h             |    1 +
 drivers/md/persistent-data/dm-block-manager.c      |   15 +-
 drivers/md/persistent-data/dm-block-manager.h      |    3 +-
 .../md/persistent-data/dm-transaction-manager.c    |    5 +-
 .../md/persistent-data/dm-transaction-manager.h    |   17 +-
 include/linux/device-mapper.h                      |    8 +-
 21 files changed, 2346 insertions(+), 478 deletions(-)
 create mode 100644 Documentation/device-mapper/era.txt
 create mode 100644 drivers/md/dm-era-target.c
