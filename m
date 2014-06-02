Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaFBOvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:51:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40490 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbaFBOvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:51:11 -0400
Date: Mon, 2 Jun 2014 08:51:22 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Core block IO bits for 3.16
Message-ID: <20140602145122.GA4384@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_02:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=11 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406020190
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

With the merge window open, I thought I'd send off the core bits sooner
rather than later. It's a big(ish) round this time, lots of development
effort has gone into blk-mq in the last 3 months. Generally we're
heading to where 3.16 will be a feature complete and performant blk-mq.
scsi-mq is progressing nicely and will hopefully be in 3.17. A nvme port
is in progress, and the Micron pci-e flash driver, mtip32xx, is
converted and will be sent in with the driver pull request for 3.16.

This pull request contains:

- Lots of prep and support patches for scsi-mq have been integrated. All
  from Christoph.

- API and code cleanups for blk-mq from Christoph.

- Lots of good corner case and error handling cleanup fixes for blk-mq
  from Ming Lei.

- A flew of blk-mq updates from me:

        - Provide strict mappings so that the driver can rely on the CPU
          to queue mapping. This enables optimizations in the driver.

        - Provided a bitmap tagging instead of percpu_ida, which never
          really worked well for blk-mq. percpu_ida relies on the fact
          that we have a lot more tags available than we really need,
          it fails miserably for cases where we exhaust (or are close to
          exhausting) the tag space.

        - Provide sane support for shared tag maps, as utilized by
          scsi-mq.

        - Various fixes for IO timeouts.

        - API cleanups, and lots of perf tweaks and optimizations.

- Remove 'buffer' from struct request. This is ancient code, from when
  requests were always virtually mapped. Kill it, to reclaim some space
  in struct request. From me.

- Remove 'magic' from blk_plug. Since we store these on the stack and
  since we've never caught any actual bugs with this, lets just get rid
  of it. From me.

- Only call part_in_flight() once for IO completion, as includes two
  atomic reads. Hopefully we'll get a better implementation soon, as the
  part IO stats are now one of the more expensive parts of doing IO on
  blk-mq. From me.

- File migration of block code from {mm,fs}/ to block/. This includes
  bio.c, bio-integrity.c, bounce.c, and ioprio.c. From me, from a
  discussion on lkml.


That should describe the meat of the pull request. Also has various
little fixes and cleanups from Dave Jones, Shaohua Li, Duan Jiong,
Fengguang Wu, Fabian Frederick, Randy Dunlap, Robert Elliott,
and Sam Bradshaw.

Please pull! Should merge cleanly into master.


  git://git.kernel.dk/linux-block.git for-3.16/core


----------------------------------------------------------------
Christoph Hellwig (27):
      blk-mq: initialize resid_len
      blk-mq: do not initialize req->special
      blk-mq: make ->flush_rq fully transparent to drivers
      blk-mq: add ->init_request and ->exit_request methods
      blk-mq: initialize request on allocation
      blk-mq: split out tag initialization, support shared tags
      block: all blk-mq requests are tagged
      blk-mq: allow drivers to hook into I/O completion
      blk-mq: bidi support
      blk-mq: add async parameter to blk_mq_start_stopped_hw_queues
      blk-mq: add blk_mq_delay_queue
      blk-mq: add blk_mq_start_hw_queues
      blk-mq: add blk_mq_requeue_request
      blk-mq: rename mq_flush_work struct request member
      block: export blk_finish_request
      blk-mq: respect rq_affinity
      block: fold __blk_add_timer into blk_add_timer
      random: export add_disk_randomness
      blk-mq: initialize struct request fields individually
      blk-mq: idle all hardware contexts before freeing a queue
      blk-mq: add helper to insert requests from irq context
      blk-mq: merge blk_mq_alloc_reserved_request into blk_mq_alloc_request
      blk-mq: initialize request in __blk_mq_alloc_request
      blk-mq: remove blk_mq_wait_for_tags
      blk-mq: do not use blk_mq_alloc_request_pinned in blk_mq_map_request
      blk-mq: remove blk_mq_alloc_request_pinned
      blk-mq: remove alloc_hctx and free_hctx methods

Dave Jones (1):
      block: remove dead code in scsi_ioctl:blk_verify_command

Duan Jiong (1):
      block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Fabian Frederick (6):
      block/blk-throttle.c: add static to blk_throtl_dispatch_work_fn
      fs/bio: remove bs paramater in biovec_create_pool
      fs/bio.c: remove nr_segs (unused function parameter)
      block/blk-iopoll.c: use iop instead of iopoll
      block/blk-throttle.c: fix return of 0/1 with return type bool
      block/blk-lib.c: make __blkdev_issue_zeroout static

Fengguang Wu (1):
      blk-mq: blk_mq_unregister_hctx() can be static

Jens Axboe (50):
      block: remove 'q' parameter from kblockd_schedule_*_work()
      block: add kblockd_schedule_delayed_work_on()
      blk-mq: ensure that hardware queues are always run on the mapped CPUs
      blk-mq: simplify blk_mq_hw_sysfs_cpus_show()
      Merge tag 'v3.15-rc1' into for-3.16/core
      block: remove struct request buffer member
      gdrom: missed conversion from req->buffer
      blk-mq: don't use preempt_count() to check for right CPU
      blk-mq: kill preempt disable/enable in blk_mq_work_fn()
      block: relax when to modify the timeout timer
      jsflash: missed conversion from rq->buffer to bio_data(rq->bio)
      sd/skd: stuff discard page in request->completion_data
      Revert "blk-mq: initialize req->q in allocation"
      blk-mq: fix race with timeouts and requeue events
      blk-mq: fix waiting for reserved tags
      blk-mq remove debug BUG_ON() when draining software queues
      blk-mq: refactor request insertion/merging
      blk-mq: remove extra requeue trace
      blk-mq: add basic round-robin of what CPU to queue workqueue work on
      blk-mq: update a hotplug comment for grammar
      blk-mq: implement new and more efficient tagging scheme
      blk-mq: use sparser tag layout for lower queue depth
      blk-mq: fix race in IO start accounting
      block: only calculate part_in_flight() once
      Merge branch 'for-3.16/blk-mq-tagging' into for-3.16/core
      blk-mq: improve support for shared tags maps
      block: move bio.c and bio-integrity.c from fs/ to block/
      block: move ioprio.c from fs/ to block/
      blk-mq: move the cache friendly bitmap type of out blk-mq-tag
      blk-mq: switch ctx pending map to the sparser blk_align_bitmap
      Merge branch 'for-3.16/blk-mq-tagging' into for-3.16/core
      block: move mm/bounce.c to block/
      htmldocs: fix bio.c location
      blk-mq: allow changing of queue depth through sysfs
      blk-mq: initialize q->nr_requests after calling blk_queue_make_request()
      blk-mq: allow the hctx cpu hotplug notifier to return errors
      blk-mq: save memory by freeing requests on unused hardware queues
      blk-mq: split make request handler for multi and single queue
      blk-mq: allow setting of per-request timeouts
      blk-mq: pass in suggested NUMA node to ->alloc_hctx()
      blk-mq: allow non-softirq completions
      blk-mq: remove stale comment for blk_mq_complete_request()
      blk-mq: add file comments and update copyright notices
      block: remove 'magic' from struct blk_plug
      block: add queue flag for disabling SG merging
      blk-mq: request initialization optimizations
      blk-mq: make the sysfs mq/ layout reflect current mappings
      block: ensure that the timer is always added
      blk-mq: remember to start timeout handler for direct queue
      blk-mq: push IPI or local end_io decision to __blk_mq_complete_request()

Masanari Iida (1):
      block: Fix format string mismatch in cfq-iosched.c

Ming Lei (12):
      blk-mq: free hctx->ctx_map when init failed
      blk-mq: fix allocation of set->tags
      blk-mq: user (1 << order) to implement order_to_size()
      blk-mq: initialize req->q in allocation
      blk-mq: fix leak of set->tags
      blk-mq: bitmap tag: use clear_bit_unlock in bt_clear_tag()
      blk-mq: bitmap tag: remove barrier in bt_clear_tag()
      blk-mq: bitmap tag: select random tag betweet 0 and (depth - 1)
      blk-mq: bitmap tag: cleanup blk_mq_init_tags
      blk-mq: fix leak of hctx->ctx_map
      blk-mq: avoid code duplication
      block: only allocate/free mq_usage_counter in blk-mq

Randy Dunlap (1):
      fs: fix new kernel-doc warnings in fs/bio.c

Robert Elliott (1):
      blk-mq: Micro-optimize blk_queue_nomerges() check

Sam Bradshaw (1):
      blk-mq: export blk_mq_tag_busy_iter

Shaohua Li (1):
      blk-mq: blk_mq_tag_to_rq should handle flush request

 Documentation/DocBook/filesystems.tmpl |    2 +-
 block/Makefile                         |    7 +-
 {fs => block}/bio-integrity.c          |    2 +-
 {fs => block}/bio.c                    |   11 +-
 block/blk-core.c                       |  113 ++-
 block/blk-flush.c                      |   40 +-
 block/blk-iopoll.c                     |    4 +-
 block/blk-lib.c                        |    4 +-
 block/blk-map.c                        |    3 -
 block/blk-merge.c                      |   28 +-
 block/blk-mq-cpu.c                     |   17 +-
 block/blk-mq-cpumap.c                  |   27 +-
 block/blk-mq-sysfs.c                   |  160 ++--
 block/blk-mq-tag.c                     |  561 +++++++++++--
 block/blk-mq-tag.h                     |   71 +-
 block/blk-mq.c                         | 1421 ++++++++++++++++++++++----------
 block/blk-mq.h                         |   32 +-
 block/blk-sysfs.c                      |   47 +-
 block/blk-throttle.c                   |   10 +-
 block/blk-timeout.c                    |   60 +-
 block/blk.h                            |    9 +-
 {mm => block}/bounce.c                 |    0
 block/cfq-iosched.c                    |    4 +-
 {fs => block}/ioprio.c                 |    0
 block/scsi_ioctl.c                     |    4 -
 drivers/block/amiflop.c                |    2 +-
 drivers/block/ataflop.c                |    2 +-
 drivers/block/floppy.c                 |   18 +-
 drivers/block/hd.c                     |   10 +-
 drivers/block/mg_disk.c                |   12 +-
 drivers/block/null_blk.c               |  117 +--
 drivers/block/paride/pcd.c             |    2 +-
 drivers/block/paride/pd.c              |    4 +-
 drivers/block/paride/pf.c              |    4 +-
 drivers/block/skd_main.c               |    5 +-
 drivers/block/swim.c                   |    2 +-
 drivers/block/swim3.c                  |    6 +-
 drivers/block/virtio_blk.c             |   75 +-
 drivers/block/xen-blkfront.c           |    4 +-
 drivers/block/xsysace.c                |    4 +-
 drivers/block/z2ram.c                  |    6 +-
 drivers/cdrom/gdrom.c                  |    2 +-
 drivers/char/random.c                  |    1 +
 drivers/ide/ide-disk.c                 |    5 +-
 drivers/md/dm.c                        |    1 -
 drivers/mtd/mtd_blkdevs.c              |    3 +-
 drivers/mtd/ubi/block.c                |    2 +-
 drivers/sbus/char/jsflash.c            |    2 +-
 drivers/scsi/scsi_lib.c                |    5 +-
 drivers/scsi/sd.c                      |   13 +-
 fs/Makefile                            |    3 +-
 include/linux/bio.h                    |    2 +-
 include/linux/blk-mq.h                 |  101 ++-
 include/linux/blk_types.h              |    2 +
 include/linux/blkdev.h                 |   27 +-
 mm/Makefile                            |    1 -
 56 files changed, 2091 insertions(+), 989 deletions(-)
 rename {fs => block}/bio-integrity.c (99%)
 rename {fs => block}/bio.c (99%)
 rename {mm => block}/bounce.c (100%)
 rename {fs => block}/ioprio.c (100%)


-- 
Jens Axboe

