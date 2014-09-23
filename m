Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaIWUzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:55:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21602 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbaIWUzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:55:07 -0400
Date: Tue, 23 Sep 2014 14:55:01 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Final block fixes for 3.17
Message-ID: <20140923205501.GA30328@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_06:2014-09-23,2014-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.43319812473797e-08 kscore.compositescore=0
 circleOfTrustscore=37.7501936418875 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=11
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409230198
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This week and last we've been fixing some corner cases related to
blk-mq, mostly. I ended up pulling most of that out of for-linus
yesterday, which is why the branch looks fresh. The rest were postponed
for 3.18.

This pull request contains:

- Fix from Christoph, avoiding a stack overflow when FUA insertion would
  recursive infinitely.

- Fix from David Hildenbrand on races between the timeout handler and
  uninitialized requests. Fixes a real issue that virtio_blk has run
  into.

- A few fixes from me:

        - Ensure that request deadline/timeout is ordered before the
          request is marked as started.

        - A potential oops on out-of-memory, when we scale the queue
          depth of the device and retry.

        - A hang fix on requeue from SCSI, where the hardware queue
          would be stopped when we attempt to re-run it (and hence
          nothing would happen, stalling progress).

        - A fix for commit 2da78092, where the cleanup path was moved
          to RCU, but a debug might_sleep() was inadvertently left in
          the code. This causes warnings for people.

Please pull!


  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to 46f341ffcfb5d8530f7d1e60f3be06cce6661b62:

  genhd: fix leftover might_sleep() in blk_free_devt() (2014-09-22 14:45:45 -0600)

----------------------------------------------------------------
Christoph Hellwig (1):
      blk-mq: avoid infinite recursion with the FUA flag

David Hildenbrand (1):
      blk-mq: Avoid race condition with uninitialized requests

Jens Axboe (4):
      blk-mq: request deadline must be visible before marking rq as started
      blk-mq: fix potential oops on out-of-memory in __blk_mq_alloc_rq_maps()
      blk-mq: use blk_mq_start_hw_queues() when running requeue work
      genhd: fix leftover might_sleep() in blk_free_devt()

 block/blk-exec.c |  1 +
 block/blk-mq.c   | 28 +++++++++++++++++-----------
 block/genhd.c    |  2 --
 3 files changed, 18 insertions(+), 13 deletions(-)

-- 
Jens Axboe

