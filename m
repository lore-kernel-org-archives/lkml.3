Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab3KHRtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:49:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55503 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab3KHRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:48:58 -0500
Date: Fri, 8 Nov 2013 10:48:56 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block IO core bits for 3.13
Message-ID: <20131108174856.GA3195@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the pull request for the core changes in the block layer for
3.13. It contains:

- The new blk-mq request interface. This is a new and more scalable
  queueing model that marries the best part of the request based
  interface we currently have (which is fully featured, but scales
  poorly) and the bio based "interface" which the new drivers for high
  IOPS devices end up using because it's much faster than the request
  based one. The bio interface has no block layer support, since it taps
  into the stack much earlier. This means that drivers end up having to
  implement a lot of functionality on their own, like tagging, timeout
  handling, requeue, etc. The blk-mq interface provides all these. Some
  drivers even provide a switch to select bio or rq and has code to
  handle both, since things like merging only works in the rq model and
  hence is faster for some workloads. This is a huge mess. Conversion of
  these drivers nets us a substantial code reduction. Initial results on
  converting SCSI to this model even shows an 8x improvement on single
  queue devices. So while the model was intended to work on the newer
  multiqueue devices, it has substantial improvements for "classic"
  hardware as well. This code has gone through extensive testing and
  development, it's now ready to go. A pull request is coming to convert
  virtio-blk to this model will be will be coming as well, with more
  drivers scheduled for 3.14 conversion.

- Two blktrace fixes from Jan and Chen Gang.

- A plug merge fix from Alireza Haghdoost.

- Conversion of __get_cpu_var() from Christoph Lameter.

- Fix for sector_div() with 64-bit divider from Geert Uytterhoeven.

- A fix for a race between request completion and the timeout handling
  from Jeff Moyer. This is what caused the merge conflict with
  blk-mq/core, in case you are looking at that.

- A dm stacking fix from Mike Snitzer.

- A code consolidation fix and duplicated code removal from Kent
  Overstreet.

- A handful of block bug fixes from Mikulas Patocka, fixing a loop crash
  and memory corruption on blk cg.

- Elevator switch bug fix from Tomoki Sekiyama.


A heads-up that I had to rebase this branch. Initially the immutable
bio_vecs had been queued up for inclusion, but a week later, it became
clear that it wasn't fully cooked yet. So the decision was made to pull
this out and postpone it until 3.14. It was a straight forward rebase,
just pruning out the immutable series and the later fixes of problems
with it. The rest of the patches applied directly and no further changes
were made.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.13/core

for you to fetch changes up to e37459b8e2c7db6735e39e019e448b76e5e77647:

  Merge branch 'blk-mq/core' into for-3.13/core (2013-11-08 09:08:12 -0700)

----------------------------------------------------------------

Alireza Haghdoost (1):
      block: Enable sysfs nomerge control for I/O requests in the plug list

Chen Gang (1):
      kernel: trace: blktrace: remove redundent memcpy() in compat_blk_trace_setup()

Christoph Hellwig (3):
      block: remove request ref_count
      blk-mq: add blk_mq_stop_hw_queues
      blk-mq: fix for flush deadlock

Christoph Lameter (1):
      block: Replace __get_cpu_var uses

Duan Jiong (2):
      block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
      block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Geert Uytterhoeven (1):
      block: Do not call sector_div() with a 64-bit divisor

Jan Kara (1):
      blktrace: Send BLK_TN_PROCESS events to all running traces

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Jens Axboe (7):
      smp: export __smp_call_function_single()
      smp: don't warn about csd->flags having CSD_FLAG_LOCK cleared for !wait
      block: make rq->cmd_flags be 64-bit
      blk-mq: new multi-queue block IO queueing mechanism
      null_blk: multi queue aware block test driver
      blk-mq: don't disallow request merges for req->special being set
      Merge branch 'blk-mq/core' into for-3.13/core

Kent Overstreet (2):
      block: Use rw_copy_check_uvector()
      block: Consolidate duplicated bio_trim() implementations

Mike Snitzer (1):
      block: properly stack underlying max_segment_size to DM device

Mikulas Patocka (4):
      blk-core: Fix memory corruption if blkcg_init_queue fails
      loop: fix crash if blk_alloc_queue fails
      block: fix a probe argument to blk_register_region
      bdi: test bdi_init failure

Shaohua Li (5):
      percpu_counter: make APIs irq safe
      percpu_ida: make percpu_ida percpu size/batch configurable
      percpu_ida: add percpu_ida_for_each_free
      percpu_ida: add an API to return free tags
      blk-mq: mq plug list breakage

Tomoki Sekiyama (2):
      elevator: Fix a race in elevator switching and md device initialization
      elevator: acquire q->sysfs_lock in elevator_change()

 block/Makefile               |    5 +-
 block/blk-core.c             |  175 +++--
 block/blk-exec.c             |   14 +-
 block/blk-flush.c            |  154 ++++-
 block/blk-iopoll.c           |    6 +-
 block/blk-lib.c              |   10 +-
 block/blk-merge.c            |   17 +-
 block/blk-mq-cpu.c           |   93 +++
 block/blk-mq-cpumap.c        |  108 +++
 block/blk-mq-sysfs.c         |  384 +++++++++++
 block/blk-mq-tag.c           |  204 ++++++
 block/blk-mq-tag.h           |   27 +
 block/blk-mq.c               | 1500 ++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq.h               |   52 ++
 block/blk-settings.c         |    1 +
 block/blk-softirq.c          |    8 +-
 block/blk-sysfs.c            |   13 +
 block/blk-timeout.c          |   77 ++-
 block/blk.h                  |   17 +
 block/elevator.c             |   22 +-
 block/ioctl.c                |    2 +-
 block/scsi_ioctl.c           |   39 +-
 drivers/block/Kconfig        |    3 +
 drivers/block/Makefile       |    1 +
 drivers/block/brd.c          |    2 +-
 drivers/block/floppy.c       |    4 +-
 drivers/block/loop.c         |    6 +-
 drivers/block/null_blk.c     |  635 ++++++++++++++++++
 drivers/block/xen-blkfront.c |   53 +-
 drivers/md/md.c              |   40 --
 drivers/md/md.h              |    1 -
 drivers/md/raid1.c           |   10 +-
 drivers/md/raid10.c          |   18 +-
 drivers/scsi/sd.c            |    2 +-
 fs/bio.c                     |   46 ++
 fs/char_dev.c                |    3 +-
 fs/fscache/object.c          |    2 +-
 include/linux/backing-dev.h  |    4 +-
 include/linux/bio.h          |    3 +
 include/linux/blk-mq.h       |  183 ++++++
 include/linux/blk_types.h    |   68 +-
 include/linux/blkdev.h       |   60 +-
 include/linux/blktrace_api.h |    4 +-
 include/linux/percpu_ida.h   |   23 +-
 kernel/smp.c                 |    7 +-
 kernel/trace/blktrace.c      |   36 +-
 lib/percpu_counter.c         |   15 +-
 lib/percpu_ida.c             |   89 ++-
 mm/swap.c                    |    3 +-
 49 files changed, 3885 insertions(+), 364 deletions(-)
 create mode 100644 block/blk-mq-cpu.c
 create mode 100644 block/blk-mq-cpumap.c
 create mode 100644 block/blk-mq-sysfs.c
 create mode 100644 block/blk-mq-tag.c
 create mode 100644 block/blk-mq-tag.h
 create mode 100644 block/blk-mq.c
 create mode 100644 block/blk-mq.h
 create mode 100644 drivers/block/null_blk.c
 create mode 100644 include/linux/blk-mq.h

-- 
Jens Axboe

