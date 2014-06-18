Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaFRQcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:32:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62883 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbaFRQcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:32:03 -0400
Date: Wed, 18 Jun 2014 09:31:50 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <snitzer@redhat.com>
Subject: [GIT PULL] Block fixes for 3.16-rc1
Message-ID: <20140618163150.GA15142@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-18_06:2014-06-17,2014-06-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.00550905157704e-07 kscore.compositescore=0
 circleOfTrustscore=10.6662100015605 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406180192
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A smaller collection of fixes for the block core that would be nice to
have in -rc2. This pull request contains:

- Fixes for races in the wait/wakeup logic used in blk-mq from
  Alexander. No issues have been observed, but it is definitely a bit
  flakey currently. Alternatively, we may drop the cyclic wakeups going
  forward, but that needs more testing.

- Some cleanups from Christoph.

- Fix for an oops in null_blk if queue_mode=1 and softirq completions
  are used. From me.

- A fix for a regression caused by the chunk size setting. It
  inadvertently used max_hw_sectors instead of max_sectors, which is
  incorrect, and causes hangs on btrfs multi-disk setups (where hw
  sectors apparently isn't set). From me.

- Removal of WQ_POWER_EFFICIENT in the kblockd creation. This was a
  recent addition as well, but it actually breaks blk-mq which relies on
  strict scheduling. If the workqueue power_efficient mode is turned on,
  this breaks blk-mq. From Matias.

- null_blk module parameter description fix from Mike.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus


----------------------------------------------------------------
Alexander Gordeev (3):
      blk-mq: bitmap tag: fix races on shared ::wake_index fields
      blk-mq: bitmap tag: fix race on blk_mq_bitmap_tags::wake_cnt
      blk-mq: bitmap tag: fix races in bt_get() function

Christoph Hellwig (3):
      block: remove elv_abort_queue and blk_abort_flushes
      blk-mq: properly drain stopped queues
      blk-mq: merge blk_mq_drain_queue and __blk_mq_drain_queue

Jens Axboe (2):
      null_blk: fix softirq completions for queue_mode == 1
      block: blk_max_size_offset() should check ->max_sectors

Matias Bjørling (1):
      block: remove WQ_POWER_EFFICIENT from kblockd

Mike Snitzer (1):
      null_blk: fix name and description of 'queue_mode' module parameter

 block/blk-core.c         |  3 +--
 block/blk-flush.c        | 38 -------------------------------
 block/blk-mq-tag.c       | 59 +++++++++++++++++++++++++++++++-----------------
 block/blk-mq-tag.h       |  2 +-
 block/blk-mq.c           | 11 +++------
 block/blk.h              |  1 -
 block/elevator.c         | 20 ----------------
 drivers/block/null_blk.c |  7 ++++--
 include/linux/blk-mq.h   |  2 +-
 include/linux/blkdev.h   |  2 +-
 include/linux/elevator.h |  1 -
 11 files changed, 50 insertions(+), 96 deletions(-)

-- 
Jens Axboe

