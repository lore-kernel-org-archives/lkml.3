Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3GHTsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:48:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40894 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3GHTsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:48:42 -0400
Date: Mon, 8 Jul 2013 21:48:39 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block IO core bits for 3.11
Message-ID: <20130708194839.GY9625@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the core IO block bits for 3.11. It contains:

- A tweak to the reserved tag logic from Jan, for weirdo devices with
  just 3 free tags. But for those it improves things substantially for
  random writes.

- Periodic writeback fix from Jan. Marked for stable as well.

- Fix for a race condition in IO scheduler switching from Jianpeng.

- The hierarchical blk-cgroup support from Tejun. This is the grunt of
  the series.

- blk-throttle fix from Vivek.

Just a note that I'm in the middle of a relocation, whole family is
flying out tomorrow. Hence I will be awal the remainder of this week,
but back at work again on Monday the 15th. CC'ing Tejun, since any
potential "surprises" will most likely be from the blk-cgroup work. But
it's been brewing for a while and sitting in my tree and linux-next for
a long time, so should be solid.

Please pull!

  git://git.kernel.dk/linux-block.git for-3.11/core

Jan Kara (2):
      writeback: Fix periodic writeback after fs mount
      block: Reserve only one queue tag for sync IO if only 3 tags are available

Jianpeng Ma (1):
      elevator: Fix a race in elevator switching

Tejun Heo (32):
      blkcg: fix error return path in blkg_create()
      blkcg: move blkg_for_each_descendant_pre() to block/blk-cgroup.h
      blkcg: implement blkg_for_each_descendant_post()
      blkcg: invoke blkcg_policy->pd_init() after parent is linked
      blkcg: move bulk of blkcg_gq release operations to the RCU callback
      blk-throttle: remove spurious throtl_enqueue_tg() call from throtl_select_dispatch()
      blk-throttle: remove deferred config application mechanism
      blk-throttle: collapse throtl_dispatch() into the work function
      blk-throttle: relocate throtl_schedule_delayed_work()
      blk-throttle: remove pointless throtl_nr_queued() optimizations
      blk-throttle: rename throtl_rb_root to throtl_service_queue
      blk-throttle: simplify throtl_grp flag handling
      blk-throttle: add backlink pointer from throtl_grp to throtl_data
      blk-throttle: pass around throtl_service_queue instead of throtl_data
      blk-throttle: reorganize throtl_service_queue passed around as argument
      blk-throttle: add throtl_grp->service_queue
      blk-throttle: move bio_lists[] and friends to throtl_service_queue
      blk-throttle: dispatch to throtl_data->service_queue.bio_lists[]
      blk-throttle: generalize update_disptime optimization in blk_throtl_bio()
      blk-throttle: add throtl_service_queue->parent_sq
      blk-throttle: implement sq_to_tg(), sq_to_td() and throtl_log()
      blk-throttle: set REQ_THROTTLED from throtl_charge_bio() and gate stats update with it
      blk-throttle: separate out throtl_service_queue->pending_timer from throtl_data->dispatch_work
      blk-throttle: implement dispatch looping
      blk-throttle: dispatch from throtl_pending_timer_fn()
      blk-throttle: make blk_throtl_drain() ready for hierarchy
      blk-throttle: make blk_throtl_bio() ready for hierarchy
      blk-throttle: make tg_dispatch_one_bio() ready for hierarchy
      blk-throttle: make throtl_pending_timer_fn() ready for hierarchy
      blk-throttle: add throtl_qnode for dispatch fairness
      blk-throttle: implement throtl_grp->has_rules[]
      blk-throttle: implement proper hierarchy support

Vivek Goyal (1):
      blk-throttle: Account for child group's start time in parent while bio climbs up

 Documentation/cgroups/blkio-controller.txt |   29 +-
 block/blk-cgroup.c                         |  105 ++-
 block/blk-cgroup.h                         |   38 +-
 block/blk-tag.c                            |   11 +-
 block/blk-throttle.c                       | 1064 +++++++++++++++++++---------
 block/cfq-iosched.c                        |   17 +-
 block/deadline-iosched.c                   |   16 +-
 block/elevator.c                           |   25 +-
 block/noop-iosched.c                       |   17 +-
 fs/block_dev.c                             |    9 +-
 include/linux/cgroup.h                     |    2 +
 include/linux/elevator.h                   |    6 +-
 12 files changed, 905 insertions(+), 434 deletions(-)


-- 
Jens Axboe

