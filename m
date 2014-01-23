Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaAWAgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:36:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbaAWAgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:36:51 -0500
Date: Wed, 22 Jan 2014 19:36:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Dongmao Zhang <dmzhang@suse.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [git pull] device mapper changes for 3.14
Message-ID: <20140123003635.GA30979@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.14-changes

for you to fetch changes up to 5066a4df1f427faac8372d20494483bb09a4a1cd:

  dm log userspace: allow mark requests to piggyback on flush requests (2014-01-21 23:46:27 -0500)

----------------------------------------------------------------
A set of device-mapper changes for 3.14.

A lot of attention was paid to improving the thin-provisioning target's
handling of metadata operation failures and running out of space.  A new
'error_if_no_space' feature was added to allow users to error IOs rather
than queue them when either the data or metadata space is exhausted.

Additional fixes/features include:
- a few fixes to properly support thin metadata device resizing
- a solution for reliably waiting for a DM device's embedded kobject to
  be released before destroying the device
- old dm-snapshot is updated to use the dm-bufio interface to take
  advantage of readahead capabilities that improve snapshot activation
- new dm-cache target tunables to control how quickly data is promoted
  to the cache (fast) device
- improved write efficiency of cluster mirror target by combining
  userspace flush and mark requests

----------------------------------------------------------------
Chuansheng Liu (1):
      dm snapshot: call destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()

Dongmao Zhang (1):
      dm log userspace: allow mark requests to piggyback on flush requests

Joe Thornber (9):
      dm thin: fix discard support to a previously shared block
      dm thin: return error from alloc_data_block if pool is not in write mode
      dm thin: factor out check_low_water_mark and use bools
      dm thin: handle metadata failures more consistently
      dm cache policy mq: introduce three promotion threshold tunables
      dm space map common: make sure new space is used during extend
      dm space map metadata: fix extending the space map
      dm btree: add dm_btree_find_lowest_key
      dm space map metadata: fix bug in resizing of thin metadata

Mike Snitzer (14):
      dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
      dm space map metadata: limit errors in sm_metadata_new_block
      dm persistent data: cleanup dm-thin specific references in text
      dm thin: use bool rather than unsigned for flags in structures
      dm thin: add mappings to end of prepared_* lists
      dm thin: log info when growing the data or metadata device
      dm thin: cleanup and improve no space handling
      dm thin: requeue bios to DM core if no_free_space and in read-only mode
      dm thin: add error_if_no_space feature
      dm thin: eliminate the no_free_space flag
      dm thin: fix set_pool_mode exposed pool operation races
      dm cache: add block sizes and total cache blocks to status output
      dm thin: fix pool feature parsing
      dm cache: add policy name to status output

Mikulas Patocka (9):
      dm table: remove unused buggy code that extends the targets array
      dm delay: use per-bio data instead of a mempool and slab cache
      dm: remove pointless kobject comparison in dm_get_from_kobject
      dm: wait until embedded kobject is released before destroying a device
      dm snapshot: use GFP_KERNEL when initializing exceptions
      dm snapshot: prepare for switch to using dm-bufio
      dm snapshot: use dm-bufio
      dm snapshot: use dm-bufio prefetch
      dm sysfs: fix a module unload race

Wei Yongjun (1):
      dm cache policy mq: use list_del_init instead of list_del + INIT_LIST_HEAD

 Documentation/device-mapper/cache-policies.txt     |  16 +-
 Documentation/device-mapper/cache.txt              |  51 ++--
 Documentation/device-mapper/thin-provisioning.txt  |   7 +
 drivers/md/Kconfig                                 |  11 +-
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-bufio.c                              |  36 ++-
 drivers/md/dm-bufio.h                              |  12 +
 drivers/md/dm-builtin.c                            |  48 ++++
 drivers/md/dm-cache-policy-mq.c                    |  70 +++--
 drivers/md/dm-cache-policy.c                       |   4 +
 drivers/md/dm-cache-policy.h                       |   6 +
 drivers/md/dm-cache-target.c                       |  20 +-
 drivers/md/dm-delay.c                              |  35 +--
 drivers/md/dm-log-userspace-base.c                 | 206 +++++++++++----
 drivers/md/dm-snap-persistent.c                    |  87 +++++--
 drivers/md/dm-snap.c                               |  10 +-
 drivers/md/dm-sysfs.c                              |   5 +-
 drivers/md/dm-table.c                              |  22 +-
 drivers/md/dm-thin-metadata.c                      |  20 ++
 drivers/md/dm-thin-metadata.h                      |   4 +-
 drivers/md/dm-thin.c                               | 284 +++++++++++++--------
 drivers/md/dm.c                                    |  15 +-
 drivers/md/dm.h                                    |  17 ++
 drivers/md/persistent-data/dm-block-manager.c      |   2 +-
 drivers/md/persistent-data/dm-btree.c              |  33 ++-
 drivers/md/persistent-data/dm-btree.h              |   8 +
 drivers/md/persistent-data/dm-space-map-common.c   |   6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |  32 ++-
 include/uapi/linux/dm-log-userspace.h              |  20 +-
 29 files changed, 767 insertions(+), 321 deletions(-)
 create mode 100644 drivers/md/dm-builtin.c
