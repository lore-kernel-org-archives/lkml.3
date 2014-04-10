Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbaDJP4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:56:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1680 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758537AbaDJP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:56:22 -0400
Date: Thu, 10 Apr 2014 09:56:23 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block fixes for 3.15-rc1
Message-ID: <20140410155623.GA3484@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-10_04:2014-04-10,2014-04-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=3 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404100250
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of fixes that should go in before -rc1. The pull
request contains:

- A two patch fix for a regression with block enabled tagging caused by
  a commit in the initial pull request. One patch is from Martin and
  ensures that SCSI doesn't truncate 64-bit block flags, the other one
  is from me and prevents us from double using struct request queuelist
  for both completion and busy tags. This caused anything from a boot
  crash for some, to crashes under load.

- A blk-mq fix for a potential soft stall when hot unplugging CPUs with
  busy IO.

- percpu_counter fix is listed in here, that caused a suspend issue with
  virtio-blk due to percpu counters having an inconsistent state during
  CPU removal. Andrew sent this in separately a few days ago, but it's
  here. JFYI.

- A few fixes for block integrity from Martin.

- A ratelimit fix for loop from Mike Galbraith, to avoid spewing too
  much in error cases.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Jens Axboe (3):
      percpu_counter: fix bad counter state during suspend
      blk-mq: fix potential stall during CPU unplug with IO pending
      block: fix regression with block enabled tagging

Martin K. Petersen (4):
      block: Fix for_each_bvec()
      block: Fix integrity verification
      block: Ensure we only enable integrity metadata for reads and writes
      scsi: Make sure cmd_flags are 64-bit

Mike Galbraith (1):
      drivers/block/loop.c: ratelimit error messages

 block/blk-core.c           |  2 +-
 block/blk-mq.c             |  8 ++++++--
 block/blk-softirq.c        | 17 ++++++-----------
 block/blk.h                |  2 +-
 block/elevator.c           |  2 ++
 drivers/block/loop.c       |  8 ++++----
 drivers/scsi/scsi_lib.c    |  4 ++--
 fs/bio-integrity.c         | 22 ++++++++++++----------
 include/linux/bio.h        |  6 +++---
 include/linux/blk_types.h  |  2 ++
 include/linux/blkdev.h     | 13 ++++++++++++-
 include/scsi/scsi_device.h |  4 ++--
 lib/percpu_counter.c       |  2 +-
 13 files changed, 54 insertions(+), 38 deletions(-)

-- 
Jens Axboe

