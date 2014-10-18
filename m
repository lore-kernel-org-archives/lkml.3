Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaJROqy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:46:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25382 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaJROqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:46:51 -0400
Date: Sat, 18 Oct 2014 08:46:44 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Core block changes for 3.18
Message-ID: <20141018144644.GA31955@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-18_02:2014-10-17,2014-10-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=3 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410180154
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the core block IO pull request for 3.18. Apart from the new and
improve flush machinery for blk-mq, this is all mostly bug fixes and
cleanups.

- blk-mq timeout updates and fixes from Christoph.

- Removal of REQ_END, also from Christoph. We pass it through the
  ->queue_rq() hook for blk-mq instead, freeing up one of the request
  bits. The space was overly tight on 32-bit, so Martin also killed
  REQ_KERNEL since it's no longer used.

- blk integrity updates and fixes from Martin and Gu Zheng.

- Update to the flush machinery for blk-mq from Ming Lei. Now we have a
  per hardware context flush request, which both cleans up the code
  should scale better for flush intensive workloads on blk-mq.

- Improve the error printing, from Rob Elliott.

- Backing device improvements and cleanups from Tejun.

- Fixup of a misplaced rq_complete() tracepoint from Hannes.

- Make blk_get_request() return error pointers, fixing up issues where
  we NULL deref when a device goes bad or missing. From Joe Lawrence.

- Prep work for drastically reducing the memory consumption of dm
  devices from Junichi Nomura. This allows creating clone bio sets
  without preallocating a lot of memory.

- Fix a blk-mq hang on certain combinations of queue depths and hardware
  queues from me.

- Limit memory consumption for blk-mq devices for crash dump scenarios
  and drivers that use crazy high depths (certain SCSI shared tag
  setups). We now just use a single queue and limited depth for that.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.18/core


----------------------------------------------------------------
Bart Van Assche (1):
      blk-mq: Make bt_clear_tag() easier to read

Christoph Hellwig (8):
      blk-mq: remove REQ_END
      blk-mq: call blk_mq_start_request from ->queue_rq
      blk-mq: rename blk_mq_end_io to blk_mq_end_request
      blk-mq: fix and simplify tag iteration for the timeout handler
      blk-mq: unshared timeout handler
      blk-mq: pass a reserved argument to the timeout handler
      block: fix blk_abort_request on blk-mq
      scsi: move blk_mq_start_request call earlier

Gu Zheng (1):
      bio-integrity: remove the needless fail handle of bip_slab creating

Hannes Reinecke (1):
      block: misplaced rq_complete tracepoint

Jens Axboe (6):
      bsg: fix potential error pointer dereference
      Merge branch 'for-linus' into for-3.18/core
      Merge branch 'for-linus' into for-3.18/core
      blk-mq: limit memory consumption if a crash dump is active
      blk-mq: fix potential hang if rolling wakeup depth is too high
      blk-mq: allocate cpumask on the home node

Joe Lawrence (2):
      block,scsi: verify return pointer from blk_get_request
      block,scsi: fixup blk_get_request dead queue scenarios

Junichi Nomura (2):
      block: use bio_clone_fast() in blk_rq_prep_clone()
      block: add bioset_create_nobvec()

Martin K. Petersen (15):
      block: Get rid of bdev_integrity_enabled()
      block: Replace bi_integrity with bi_special
      block: Remove integrity tagging functions
      block: Remove bip_buf
      block: Deprecate the use of the term sector in the context of block integrity
      block: Make protection interval calculation generic
      block: Clean up the code used to generate and verify integrity metadata
      block: Add prefix to block integrity profile flags
      block: Add a disk flag to block integrity profile
      block: Relocate bio integrity flags
      block: Integrity checksum flag
      block: Don't merge requests if integrity flags differ
      block: Add T10 Protection Information functions
      sd: Honor block layer integrity handling flags
      block: Remove REQ_KERNEL

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2

Ming Lei (13):
      blk-mq: remove unnecessary blk_clear_rq_complete()
      blk-timeout: fix blk_add_timer
      blk-mq: handle failure path for initializing hctx
      blk-mq: allocate flush_rq in blk_mq_init_flush()
      block: introduce blk_init_flush and its pair
      block: move flush initialization to blk_flush_init
      block: avoid to use q->flush_rq directly
      block: introduce blk_flush_queue to drive flush machinery
      block: remove blk_init_flush() and its pair
      block: flush: avoid to figure out flush queue unnecessarily
      block: introduce 'blk_mq_ctx' parameter to blk_get_flush_queue
      blk-mq: support per-distpatch_queue flush machinery
      blk-merge: don't compute bi_phys_segments from bi_vcnt for cloned bio

Rasmus Villemoes (1):
      block: Replace strnicmp with strncasecmp

Robert Elliott (2):
      block: make blk_update_request print prefix match ratelimited prefix
      block: include func name in __get_request prints

Tejun Heo (7):
      blkcg: remove blkcg->id
      block, bdi: an active gendisk always has a request_queue associated with it
      bdi: remove unused stuff
      bdi: remove bdi->wb_lock locking around bdi->dev clearing in bdi_unregister()
      bdi: make backing_dev_info->wb.dwork canceling stricter
      bdi: explain the dirty list transferring in bdi_destroy()
      bdi: reimplement bdev_inode_switch_bdi()

 Documentation/ABI/testing/sysfs-block       |   8 +
 Documentation/block/data-integrity.txt      |  54 +----
 block/Kconfig                               |   1 +
 block/Makefile                              |   4 +-
 block/bio-integrity.c                       | 271 ++++++---------------
 block/bio.c                                 |  61 +++--
 block/blk-cgroup.c                          |   2 -
 block/blk-cgroup.h                          |   3 -
 block/blk-core.c                            |  71 +++---
 block/blk-flush.c                           | 147 +++++++----
 block/blk-integrity.c                       | 103 +++++---
 block/blk-merge.c                           |  14 +-
 block/blk-mq-tag.c                          |  55 ++---
 block/blk-mq.c                              | 364 ++++++++++++++--------------
 block/blk-mq.h                              |   3 +-
 block/blk-settings.c                        |   4 +-
 block/blk-sysfs.c                           |   4 +-
 block/blk-timeout.c                         |  15 +-
 block/blk.h                                 |  37 ++-
 block/bsg.c                                 |   9 +-
 block/cfq-iosched.c                         |  10 +-
 block/compat_ioctl.c                        |   4 -
 block/ioctl.c                               |   4 -
 block/partitions/mac.c                      |   8 +-
 block/scsi_ioctl.c                          |  11 +-
 block/t10-pi.c                              | 197 +++++++++++++++
 drivers/block/mtip32xx/mtip32xx.c           |   9 +-
 drivers/block/null_blk.c                    |   7 +-
 drivers/block/paride/pd.c                   |   2 +
 drivers/block/pktcdvd.c                     |   2 +
 drivers/block/sx8.c                         |   2 +-
 drivers/block/virtio_blk.c                  |   8 +-
 drivers/cdrom/cdrom.c                       |   4 +-
 drivers/ide/ide-park.c                      |   2 +-
 drivers/scsi/Kconfig                        |   1 -
 drivers/scsi/device_handler/scsi_dh_alua.c  |   2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |   2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   4 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |   2 +-
 drivers/scsi/osd/osd_initiator.c            |   4 +-
 drivers/scsi/osst.c                         |   2 +-
 drivers/scsi/scsi_error.c                   |   2 +
 drivers/scsi/scsi_lib.c                     |  24 +-
 drivers/scsi/sd.c                           |  73 +++---
 drivers/scsi/sd.h                           |  66 ++++-
 drivers/scsi/sd_dif.c                       | 353 ++++-----------------------
 drivers/scsi/sg.c                           |   4 +-
 drivers/scsi/st.c                           |   2 +-
 drivers/target/target_core_pscsi.c          |   2 +-
 fs/block_dev.c                              |  34 +--
 fs/btrfs/disk-io.c                          |   2 +-
 fs/nfs/direct.c                             |  12 +-
 fs/nfs/file.c                               |   4 +-
 fs/xfs/xfs_buf.c                            |   2 -
 include/linux/backing-dev.h                 |   4 -
 include/linux/bio.h                         |  65 +++--
 include/linux/blk-mq.h                      |  22 +-
 include/linux/blk_types.h                   |  18 +-
 include/linux/blkdev.h                      |  71 +++---
 include/linux/crc-t10dif.h                  |   5 +-
 include/linux/fs.h                          |   2 -
 include/linux/nfs_fs.h                      |   4 +-
 include/linux/t10-pi.h                      |  22 ++
 include/scsi/scsi_cmnd.h                    |  36 ++-
 include/scsi/scsi_tcq.h                     |   2 +-
 mm/backing-dev.c                            |  40 ++-
 66 files changed, 1213 insertions(+), 1175 deletions(-)
 create mode 100644 block/t10-pi.c
 create mode 100644 include/linux/t10-pi.h

-- 
Jens Axboe

