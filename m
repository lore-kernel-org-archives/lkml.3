Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3B1On3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:43:29 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:59592 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3B1On1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:43:27 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 09:43:27 EST
X-ASG-Debug-ID: 1362062137-03d6a5664859390001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Date: Thu, 28 Feb 2013 15:35:33 +0100
From: Jens Axboe <jaxboe@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO core bits for 3.9
Message-ID: <20130228143533.GC4727@kernel.dk>
X-ASG-Orig-Subj: [GIT PULL] Block IO core bits for 3.9
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362062137
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.123854
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below are the core block IO bits for 3.9. It was delayed a few days
since my workstation kept crashing every 2-8h after pulling it into
current -git, but turns out it is a bug in the new pstate code (divide
by zero, will report separately). In any case, it contains:

- The big cfq/blkcg update from Tejun and and Vivek.

- Additional block and writeback tracepoints from Tejun.

- Improvement of the should sort (based on queues) logic in the plug
  flushing.

- _io() variants of the wait_for_completion() interface, using
  io_schedule() instead of schedule() to contribute to io wait properly.

- Various little fixes.

You'll get two trivial merge conflicts, which should be easy enough to
fix up.

Please pull!

  git://git.kernel.dk/linux-block.git for-3.9/core




Cong Ding (1):
      drivers/block/swim3.c: fix null pointer dereference

Glauber Costa (1):
      cfq: fix lock imbalance with failed allocations

Guo Chao (2):
      block: use i_size_write() in bd_set_size()
      block: remove redundant check to bd_openers()

Jens Axboe (1):
      Merge branch 'blkcg-cfq-hierarchy' of git://git.kernel.org/.../tj/cgroup into for-3.9/core

Jianpeng Ma (1):
      block: Remove should_sort judgement when flush blk_plug

Mikulas Patocka (1):
      block: don't select PERCPU_RWSEM

Sasha Levin (1):
      block,elevator: use new hashtable implementation

Tejun Heo (24):
      blkcg: fix minor bug in blkg_alloc()
      blkcg: reorganize blkg_lookup_create() and friends
      blkcg: cosmetic updates to blkg_create()
      blkcg: make blkcg_gq's hierarchical
      cfq-iosched: add leaf_weight
      cfq-iosched: implement cfq_group->nr_active and ->children_weight
      cfq-iosched: implement hierarchy-ready cfq_group charge scaling
      cfq-iosched: convert cfq_group_slice() to use cfqg->vfraction
      cfq-iosched: enable full blkcg hierarchy support
      blkcg: add blkg_policy_data->plid
      blkcg: implement blkcg_policy->on/offline_pd_fn() and blkcg_gq->online
      blkcg: s/blkg_rwstat_sum()/blkg_rwstat_total()/
      blkcg: export __blkg_prfill_rwstat()
      blkcg: implement blkg_[rw]stat_recursive_sum() and blkg_[rw]stat_merge()
      block: RCU free request_queue
      blkcg: make blkcg_print_blkgs() grab q locks instead of blkcg lock
      cfq-iosched: separate out cfqg_stats_reset() from cfq_pd_reset_stats()
      cfq-iosched: collect stats from dead cfqgs
      cfq-iosched: add hierarchical cfq_group statistics
      block: add missing block_bio_complete() tracepoint
      block: add @req to bio_{front|back}_merge tracepoints
      buffer: make touch_buffer() an exported function
      block: add block_{touch|dirty}_buffer tracepoint
      writeback: add more tracepoints

Vivek Goyal (6):
      cfq-iosched: Properly name all references to IO class
      cfq-iosched: More renaming to better represent wl_class and wl_type
      cfq-iosched: Rename "service_tree" to "st" at some places
      cfq-iosched: Rename few functions related to selecting workload
      cfq-iosched: Get rid of unnecessary local variable
      cfq-iosched: Print sync-noidle information in blktrace messages

Vladimir Davydov (2):
      sched: add wait_for_completion_io[_timeout]
      block: account iowait time when waiting for completion of IO request

 Documentation/block/cfq-iosched.txt        |  58 +++
 Documentation/cgroups/blkio-controller.txt |  35 +-
 block/Kconfig                              |   1 -
 block/blk-cgroup.c                         | 277 +++++++++++--
 block/blk-cgroup.h                         |  68 +++-
 block/blk-core.c                           |  18 +-
 block/blk-exec.c                           |   4 +-
 block/blk-flush.c                          |   2 +-
 block/blk-lib.c                            |   6 +-
 block/blk-sysfs.c                          |   9 +-
 block/blk.h                                |   2 +-
 block/cfq-iosched.c                        | 629 +++++++++++++++++++++++------
 block/elevator.c                           |  23 +-
 drivers/block/swim3.c                      |   5 +-
 drivers/md/dm.c                            |   1 -
 drivers/md/raid5.c                         |  11 +-
 fs/bio.c                                   |   2 +
 fs/block_dev.c                             |   6 +-
 fs/buffer.c                                |  10 +
 fs/fs-writeback.c                          |  16 +-
 include/linux/blkdev.h                     |   3 +-
 include/linux/blktrace_api.h               |   1 +
 include/linux/buffer_head.h                |   2 +-
 include/linux/completion.h                 |   3 +
 include/linux/elevator.h                   |   5 +-
 include/trace/events/block.h               | 104 ++++-
 include/trace/events/writeback.h           | 116 ++++++
 kernel/sched/core.c                        |  57 ++-
 kernel/trace/blktrace.c                    |  28 +-
 mm/page-writeback.c                        |   2 +
 30 files changed, 1246 insertions(+), 258 deletions(-)

-- 
Jens Axboe

