Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaLMDCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 22:02:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40919 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbaLMDC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 22:02:28 -0500
Date: Fri, 12 Dec 2014 20:02:24 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Core block IO bits for 3.19
Message-ID: <20141213025932.GA11631@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-13_02:2014-12-13,2014-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.38777878078145e-15 kscore.compositescore=0
 circleOfTrustscore=33.2965958620397 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=11
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412130027
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the pull request for the core block IO changes for 3.19. Not a
huge round this time, mostly lots of little good fixes. The pull request
contains:

- Fix a bug in sysfs blktrace interface causing a NULL pointer
  dereference, when enabled/disabled through that API. From Arianna
  Avanzini.

- Various updates/fixes/improvements for blk-mq:

        - A set of updates from Bart, mostly fixing buts in the tag
          handling.

        - Cleanup/code consolidation from Christoph.

        - Extend queue_rq API to be able to handle batching issues of IO
          requests. NVMe will utilize this shortly. From me.

        - A few tag and request handling updates from me.

        - Cleanup of the preempt handling for running queues from Paolo.

        - Prevent running of unmapped hardware queues from Ming Lei.

        - Move the kdump memory limiting check to be in the correct
          location, from Shaohua.

        - Initialize all software queues at init time from Takashi. This
          prevents a kobject warning when CPUs are brought online that
          weren't online when a queue was registered.

- Single writeback fix for I_DIRTY clearing from Tejun. Queued with the
  core IO changes, since it's just a single fix.

- Version X of the __bio_add_page() segment addition retry from
  Maurizio. Hope the Xth time is the charm.

- Documentation fixup for IO scheduler merging from Jan.

- Introduce (and use) generic IO stat accounting helpers for non-rq
  drivers, from Gu Zheng.

- Kill off artificial limiting of max sectors in a request from
  Christoph.


Please pull!

  git://git.kernel.dk/linux-block.git for-3.19/core

----------------------------------------------------------------
Arianna Avanzini (1):
      blktrace: don't let the sysfs interface remove trace from running list

Bart Van Assche (6):
      blk-mq: fix hang in bt_get()
      blk-mq: Fix a use-after-free
      blk-mq: Avoid that __bt_get_word() wraps multiple times
      blk-mq: Fix a race between bt_clear_tag() and bt_get()
      blk-mq: Micro-optimize bt_get()
      blk-mq: Use all available hardware queues

Christoph Hellwig (2):
      block: remove artifical max_hw_sectors cap
      blk-mq: handle the single queue case in blk_mq_hctx_next_cpu

Gu Zheng (1):
      blk: introduce generic io stat accounting help function

Jan Kara (1):
      block: Expand a bit documentation about elevator_allow_merge_fn

Jens Axboe (8):
      blk-mq: add a 'list' parameter to ->queue_rq()
      blk-mq: add BLK_MQ_F_DEFER_ISSUE support flag
      blk-mq: export blk_mq_free_request()
      blk-mq: add blk_mq_free_hctx_request()
      genhd: check for int overflow in disk_expand_part_tbl()
      blk-mq: use 'nr_cpu_ids' as highest CPU ID count for hwq <-> cpu map
      blk-mq: cleanup tag free handling
      blk-mq: re-check for available tags after running the hardware queue

Maurizio Lombardi (1):
      bio: modify __bio_add_page() to accept pages that don't start a new segment

Ming Lei (1):
      blk-mq: prevent unmapped hw queue from being scheduled

Paolo Bonzini (2):
      blk_mq: call preempt_disable/enable in blk_mq_run_hw_queue, and only if needed
      blk-mq: use get_cpu/put_cpu instead of preempt_disable/preempt_enable

Shaohua Li (1):
      blk-mq: move the kdump check to blk_mq_alloc_tag_set

Takashi Iwai (1):
      blk-mq: Fix uninitialized kobject at CPU hotplugging

Tejun Heo (1):
      writeback: fix a subtle race condition in I_DIRTY clearing

 Documentation/block/biodoc.txt    |   6 +-
 block/bio.c                       |  82 +++++++++++++++++--------
 block/blk-core.c                  |   3 +
 block/blk-mq-cpumap.c             |   4 +-
 block/blk-mq-sysfs.c              |   9 ++-
 block/blk-mq-tag.c                |  60 +++++++++---------
 block/blk-mq.c                    | 126 ++++++++++++++++++++++++--------------
 block/blk-mq.h                    |   5 ++
 block/blk-settings.c              |   4 +-
 block/blk-sysfs.c                 |  12 ++--
 block/genhd.c                     |  11 +++-
 drivers/block/aoe/aoeblk.c        |   2 +-
 drivers/block/mtip32xx/mtip32xx.c |   5 +-
 drivers/block/null_blk.c          |  10 +--
 drivers/block/virtio_blk.c        |   7 ++-
 drivers/scsi/scsi_lib.c           |   5 +-
 fs/fs-writeback.c                 |  29 ++++++---
 include/linux/bio.h               |   5 ++
 include/linux/blk-mq.h            |  10 ++-
 include/linux/blkdev.h            |   1 -
 kernel/trace/blktrace.c           |   3 -
 21 files changed, 254 insertions(+), 145 deletions(-)

-- 
Jens Axboe

