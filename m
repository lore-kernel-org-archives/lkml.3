Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaHLVDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:03:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2131 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754908AbaHLVDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:03:02 -0400
Date: Tue, 12 Aug 2014 15:03:00 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO core bits for 3.17-rc1
Message-ID: <20140812210235.GA2294@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-12_07:2014-08-12,2014-08-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.12577208666309e-09 kscore.compositescore=0
 circleOfTrustscore=6.94282017626843 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408120216
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Small round this time, after the massive blk-mq dump for 3.16. This pull
request contains:

- Fixes for max_sectors overflow in ioctls from Akinoby Mita.

- Partition off-by-one bug fix in aix partitions from Dan Carpenter.

- Various small partition cleanups from Fabian Frederick.

- Fix for the block integrity code sometimes returning the wrong vector
  count from Gu Zheng.

- Cleanup an re-org of the blk-mq queue enter/exit percpu counters from
  Tejun. Dependent on the percpu pull for 3.17 (which was in the block
  tree too), that you have already pulled in.

- A blkcg oops fix, also from Tejun.

Please pull!

  git://git.kernel.dk/linux-block.git for-3.17/core

----------------------------------------------------------------
Akinobu Mita (2):
      block: fix BLKSECTGET ioctl when max_sectors is greater than USHRT_MAX
      block: fix SG_[GS]ET_RESERVED_SIZE ioctl when max_sectors is huge

Dan Carpenter (1):
      partitions: aix.c: off by one bug

Fabian Frederick (4):
      block/partitions/aix.c: replace count*size kzalloc by kcalloc
      block/partitions/amiga.c: replace nolevel printk by pr_err
      block/partitions/msdos.c: code clean-up
      block/partitions/efi.c: kerneldoc fixing

Gu Zheng (1):
      bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload

Jens Axboe (2):
      Merge branch 'for-3.17' of git://git.kernel.org/.../tj/percpu into for-3.17/core
      Revert "bio: modify __bio_add_page() to accept pages that don't start a new segment"

Maurizio Lombardi (1):
      bio: modify __bio_add_page() to accept pages that don't start a new segment

Tejun Heo (6):
      blk-mq: fix a memory ordering bug in blk_mq_queue_enter()
      block, blk-mq: draining can't be skipped even if bypass_depth was non-zero
      blk-mq: decouble blk-mq freezing from generic bypassing
      blk-mq: collapse __blk_mq_drain_queue() into blk_mq_freeze_queue()
      blk-mq: use percpu_ref for mq usage count
      blkcg: don't call into policy draining if root_blkg is already gone

 arch/x86/include/asm/percpu.h    |   3 +-
 block/bio-integrity.c            |  12 +-
 block/blk-cgroup.c               |   7 +
 block/blk-core.c                 |  13 +-
 block/blk-mq.c                   |  81 ++---
 block/blk-mq.h                   |   2 +-
 block/blk-sysfs.c                |   2 +-
 block/compat_ioctl.c             |   6 +-
 block/ioctl.c                    |   5 +-
 block/partitions/aix.c           |   4 +-
 block/partitions/amiga.c         |  12 +-
 block/partitions/efi.c           |  46 +--
 block/partitions/msdos.c         |  13 +-
 block/scsi_ioctl.c               |  15 +-
 drivers/target/target_core_tpg.c |   4 +-
 fs/aio.c                         |   6 +-
 include/asm-generic/percpu.h     | 410 ++++++++++++++++++++----
 include/linux/bio.h              |   1 +
 include/linux/blkdev.h           |   4 +-
 include/linux/percpu-defs.h      | 380 +++++++++++++++++++++-
 include/linux/percpu-refcount.h  |  64 ++--
 include/linux/percpu.h           | 673 ---------------------------------------
 kernel/cgroup.c                  |   8 +-
 kernel/workqueue.c               |  19 +-
 lib/percpu-refcount.c            |  86 +++--
 mm/percpu.c                      |   3 +-
 26 files changed, 947 insertions(+), 932 deletions(-)

-- 
Jens Axboe

