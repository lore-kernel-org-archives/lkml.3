Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaBMPyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:54:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30195 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaBMPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:54:35 -0500
Date: Thu, 13 Feb 2014 08:54:16 -0700
From: Jens Axboe <axboe@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO fixes for 3.14-rc2
Message-ID: <20140213155416.GA10926@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-13_04:2014-02-13,2014-02-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Second round of updates and fixes for 3.14-rc2. Most of this stuff has
been queued up for a while. The notable exception is the blk-mq changes,
which are naturally a bit more in flux still.

The pull request contains:

- Two bug fixes for the new immutable vecs, causing crashes with raid or
  swap. From Kent.

- Various blk-mq tweaks and fixes from Christoph. A fix for integrity
  bio's from Nic. 

- A few bcache fixes from Kent and Darrick Wong.

- xen-blk{front,back} fixes from David Vrabel, Matt Rushton, Nicolas
  Swenson, and Roger Pau Monne.

- Fix for a vec miscount with integrity vectors from Martin.

- Minor annotations or fixes from Masanari Iida and Rashika Kheria.

- Tweak to null_blk to do more normal FIFO processing of requests from
  Shlomo Pongratz.

- Elevator switching bypass fix from Tejun.

- Softlockup in blkdev_issue_discard() fix when !CONFIG_PREEMPT from me.

Please pull!


  git://git.kernel.dk/linux-block.git for-linus



Christoph Hellwig (10):
      blk-mq: support at_head inserations for blk_execute_rq
      blk-mq: divert __blk_put_request for MQ ops
      blk-mq: handle dma_drain_size
      blk-mq: initialize sg_reserved_size
      blk-mq: rework I/O completions
      virtio_blk: use blk_mq_complete_request
      null_blk: use blk_complete_request and blk_mq_complete_request
      blk-mq: rework flush sequencing logic
      blk-mq: dont assume rq->errors is set when returning an error from ->queue_rq
      blk-mq: pair blk_mq_start_request / blk_mq_requeue_request

Darrick J. Wong (1):
      bcache: fix BUG_ON due to integer overflow with GC_SECTORS_USED

David Vrabel (1):
      xen-blkfront: handle backend CLOSED without CLOSING

Jens Axboe (3):
      Merge branch 'bcache-for-3.14' of git://evilpiepirate.org/~kent/linux-bcache into for-linus
      Merge branch 'stable/for-jens-3.14' of git://git.kernel.org/.../xen/tip into for-linus
      block: add cond_resched() to potentially long running ioctl discard loop

Kent Overstreet (3):
      bcache: Minor fixes from kbuild robot
      block: Explicitly handle discard/write same segments
      block: Fix cloning of discard/write same bios

Martin K. Petersen (1):
      block: Fix nr_vecs for inline integrity vectors

Masanari Iida (1):
      block: Fix type mismatch in ssize_t_blk_mq_tag_sysfs_show

Matt Rushton (1):
      xen-blkback: fix memory leak when persistent grants are used

Nicholas Bellinger (1):
      blk-mq: Add bio_integrity setup to blk_mq_make_request

Nicholas Swenson (1):
      bcache: bugfix - gc thread now gets woken when cache is full

Rashika Kheria (2):
      fs: Mark function as static in fs/bio-integrity.c
      fs: Add prototype declaration to appropriate header file include/linux/bio.h

Roger Pau Monne (4):
      xen-blkback: fix memory leaks
      xen-blkback: fix shutdown race
      xen-blkif: drop struct blkif_request_segment_aligned
      xen-blkback: init persistent_purge_work work_struct

Shaohua Li (2):
      percpu_ida: fix a live lock
      blk-mq: Don't reserve a tag for flush request

Shlomo Pongratz (1):
      block/null_blk: Fix completion processing from LIFO to FIFO

Tejun Heo (1):
      block: __elv_next_request() shouldn't call into the elevator if bypassing

 block/blk-core.c                    |  20 ++++-
 block/blk-exec.c                    |   2 +-
 block/blk-flush.c                   | 101 ++++++++++---------------
 block/blk-lib.c                     |   8 ++
 block/blk-merge.c                   |  91 +++++++++++++++--------
 block/blk-mq-tag.c                  |   2 +-
 block/blk-mq.c                      | 143 ++++++++++++++++++++++--------------
 block/blk-mq.h                      |   4 +-
 block/blk-sysfs.c                   |   2 +
 block/blk-timeout.c                 |   2 +-
 block/blk.h                         |   2 +-
 drivers/block/null_blk.c            |  97 +++++++++---------------
 drivers/block/virtio_blk.c          |   7 +-
 drivers/block/xen-blkback/blkback.c |  66 +++++++++++------
 drivers/block/xen-blkback/common.h  |   5 +-
 drivers/block/xen-blkback/xenbus.c  |  14 ++++
 drivers/block/xen-blkfront.c        |  11 ++-
 drivers/md/bcache/bcache.h          |   4 +-
 drivers/md/bcache/bset.c            |   7 +-
 drivers/md/bcache/btree.c           |   4 +-
 drivers/md/bcache/extents.c         |   2 +-
 drivers/md/bcache/request.c         |   6 +-
 drivers/md/bcache/sysfs.c           |   2 +-
 fs/bio-integrity.c                  |  13 +++-
 fs/bio.c                            |  15 ++--
 include/linux/bio.h                 |  12 +++
 include/linux/blk-mq.h              |   9 ++-
 include/linux/blkdev.h              |  11 +--
 include/xen/interface/io/blkif.h    |  34 ++++-----
 lib/percpu_ida.c                    |   7 +-
 30 files changed, 398 insertions(+), 305 deletions(-)

-- 
Jens Axboe

