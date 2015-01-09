Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbbAIRy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:54:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9064 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbbAIRy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:54:57 -0500
Date: Fri, 9 Jan 2015 10:54:51 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block changes for 3.19-rc3
Message-ID: <20150109175451.GA28862@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-09_07:2015-01-09,2015-01-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.40838468559923e-14 kscore.compositescore=0
 circleOfTrustscore=33.2965958620397 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=10
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501090151
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a collection of fixes for the current series, collected and
tested since the initial pull request. The two major things in here are
the 4k partition fixes from Boaz/Matthew, which have been pending for a
few series but is now in a shape to get in, so I don't think it should
wait for 3.20-rc. The other major part is an update to the NVMe driver,
fixing various issues around surprise removal and hung controllers. Most
of that is from Keith, and parts are simple blk-mq fixes or
exports/additions of minor functions to aid this effort, and parts are
changes directly to the NVMe driver.

Apart from the above, this pull request contains:

- Small blk-mq change from me, killing an unused member of the hardware
  queue structure.

- Small fix from Ming Lei, fixing up a few drivers that didn't properly
  check for ERR_PTR() returns from blk_mq_init_queue().


Please pull!


----------------------------------------------------------------
Boaz Harrosh (2):
      brd: Fix all partitions BUGs
      brd: Request from fdisk 4k alignment

Jens Axboe (3):
      block: wake up waiters when a queue is marked dying
      blk-mq: get rid of ->cmd_size in the hardware queue
      blk-mq: Add helper to abort requeued requests

Keith Busch (14):
      blk-mq: Exit queue on alloc failure
      blk-mq: Export freeze/unfreeze functions
      NVMe: Fix double free irq
      blk-mq: Wake tasks entering queue on dying
      blk-mq: Export if requests were started
      blk-mq: Let drivers cancel requeue_work
      blk-mq: Allow requests to never expire
      blk-mq: End unstarted requests on a dying queue
      NVMe: Start all requests
      NVMe: Reference count admin queue usage
      NVMe: Admin queue removal handling
      NVMe: Command abort handling fixes
      NVMe: Start and stop h/w queues on reset
      NVMe: Fix locking on abort handling

Matthew Wilcox (2):
      axonram: Fix bug in direct_access
      block: Change direct_access calling convention

Ming Lei (1):
      block: fix checking return value of blk_mq_init_queue

 Documentation/filesystems/xip.txt |  15 ++--
 arch/powerpc/sysdev/axonram.c     |  19 ++---
 block/blk-core.c                  |  21 ++++-
 block/blk-mq-tag.c                |  14 ++-
 block/blk-mq-tag.h                |   1 +
 block/blk-mq.c                    |  75 ++++++++++++++--
 block/blk-mq.h                    |   1 +
 block/blk-timeout.c               |   3 +
 drivers/block/brd.c               | 123 ++++++++++++---------------
 drivers/block/null_blk.c          |   2 +-
 drivers/block/nvme-core.c         | 175 +++++++++++++++++++++++++++-----------
 drivers/block/virtio_blk.c        |   2 +-
 drivers/s390/block/dcssblk.c      |  21 ++---
 fs/block_dev.c                    |  40 +++++++++
 fs/ext2/xip.c                     |  31 +++----
 include/linux/blk-mq.h            |   8 +-
 include/linux/blk_types.h         |   2 +
 include/linux/blkdev.h            |   6 +-
 18 files changed, 374 insertions(+), 185 deletions(-)

-- 
Jens Axboe

