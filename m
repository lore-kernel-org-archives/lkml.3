Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3JRNOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:14:46 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63891 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3JRNOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:14:44 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk, willy@linux.intel.com, keith.busch@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Matias Bjorling <m@bjorling.me>
Subject: [PATCH 0/3] Convert from bio-based to blk-mq v2
Date: Fri, 18 Oct 2013 15:14:19 +0200
Message-Id: <1382102062-22270-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are against the "new-queue" branch in Axboe's repo:

git://git.kernel.dk/linux-block.git

The nvme driver implements itself as a bio-based driver. This primarily because
of high lock congestion for high-performance nvm devices. To remove
congestions within the traditional block layer, a multi-queue block layer is
being implemented.

These patches enable mq within the nvme driver. The first patchh is a simple
blk-fix, second is a trivial refactoring, and the third is the big patch for
converting the driver.

Changes from v2:

 * Rebased on top of 3.12-rc5
 * Gone away from maintaining queue allocation/deallocation using
   [init/exit]_hctx callbacks.
 * Command ids are now retrieved using the mq tag framework.
 * Converted all bio-related functions to rq-related.
 * Timeouts are implemented for both admin and managed nvme queues.

Performance study:

System: HGST Research NVMe prototype, Haswell i7-4770 3.4Ghz, 32GB 1333Mhz

fio flags: --bs=4k --ioengine=libaio --size=378m --direct=1 --runtime=5
--time_based --rw=randwrite --norandommap --group_reporting --output .output
--filename=/dev/nvme0n1 --cpus_allowed=0-3

numjobs=X, iodepth=Y:  MQ IOPS,  MQ CPU User,  MQ CPU Sys,  MQ Latencies
                    - Bio IOPS, Bio CPU User, Bio CPU Sys, Bio Latencies

1,1:     81.8K,  9.76%, 21.12%, min=11, max= 111, avg=11.90, stdev= 0.46
      -  85.1K,  7.44%, 22.42%, min=10, max=2116, avg=11.44, stdev= 3.31
1,2:    155.2K, 20.64%, 40.32%, min= 8, max= 168, avg=12.53, stdev= 0.95
      - 166.0K  19.92%  23.68%, min= 7, max=2117, avg=11.77, stdev= 3.40
1,4:    242K,   32.96%, 40.72%, min=11, max= 132, avg=16.32, stdev= 1.51
      - 238K,   14.32%, 45.76%, min= 9, max=4907, avg=16.51, stdev= 9.08
1,8:    270K,   32.00%, 45.52%, min=13, max= 148, avg=29.34, stdev= 1.68
      - 266K,   15.69%, 46.56%, min=11, max=2138, avg=29.78, stdev= 7.80
1,16:   271K,   32.16%, 44.88%, min=26, max= 181, avg=58.97, stdev= 1.81
      - 266K,   16.96%, 45.20%, min=22, max=2169, avg=59.81, stdev=13.10
1,128:  270K,   26.24%, 48.88%, min=196, max= 942, avg=473.90, stdev= 4.43
      - 266K,   17.92%, 44.60%, min=156, max=2585, avg=480.36, stdev=23.39
1,1024: 270K,   25.19%, 39.98%, min=1386, max=6693, avg=3798.54, stdev=76.23
      - 266K,   15.83%, 75.31%, min=1179, max=7667, avg=3845.50, stdev=109.20
1,2048: 269K,   27.75%, 37.43%, min=2818, max=10448, avg=7593.71, stdev=119.93
      - 265K,    7.43%, 92.33%, min=3877, max=14982, avg=7706.68, stdev=344.34

4,1:    238K,   13.14%, 12.58%, min=9,  max= 150, avg=16.35, stdev= 1.53
      - 238K,   12.02%, 20.36%, min=10, max=2122, avg=16.41, stdev= 4.23
4,2:    270K,   11.58%, 13.26%, min=10, max= 175, avg=29.26, stdev= 1.77
      - 267K,   10.02%, 16.28%, min=12, max=2132, avg=29.61, stdev= 5.77
4,4:    270K,   12.12%, 12.40%, min=12, max= 225, avg=58.94, stdev= 2.05
      - 266K,   10.56%, 16.28%, min=12, max=2167, avg=59.60, stdev=10.87
4,8:    270K,   10.54%, 13.32%, min=19, max= 338, avg=118.20, stdev= 2.39
      - 267K,    9.84%, 17.58%, min=15, max= 311, avg=119.40, stdev= 4.69
4,16:   270K,   10.10%, 12.78%, min=35, max= 453, avg=236.81, stdev= 2.88
      - 267K,   10.12%, 16.88%, min=28, max=2349, avg=239.25, stdev=15.89
4,128:  270K,    9.90%, 12.64%, min=262, max=3873, avg=1897.58, stdev=31.38
      - 266K,    9.54%, 15.38%, min=207, max=4065, avg=1917.73, stdev=54.19
4,1024: 270K,   10.77%, 18.57%, min=   2,  max=124,  avg=   15.15, stdev= 21.02
      - 266K,    5.42%, 54.88%, min=6829, max=31097, avg=15373.44, stdev=685.93
4,2048: 270K,   10.51%, 18.83%, min=   2, max=233, avg=30.17, stdev=45.28
      - 266K,    5.96%, 56.98%, min=  15, max= 62, avg=30.66, stdev= 1.85

Throughput: the bio-based driver is faster at low CPU and low queue depth. When
multiple cores submits IOs, the bio-based driver uses significantly more CPU
resources.
Latency: For single core submission, blk-mq have higher min latencies, while
significantly lower max latencives. Averages are slightly higher for blk-mq.
For multiple cores IO submissions, the same is applicable, while the bio-based
has significant outliers on high queue depths. Averages are the same as
bio-based.

I don't have access to 2+ sockets systems. I expect to see significant
improvements over a bio-based approach.

Outstanding issues:
 * Suspend/resume. This is currently disabled. The difference between the
   managed mq queues and the admin queue has to be properly taken care of.
 * NOT_VIRT_MERGEABLE moved within blk-mq. Decide if mq has the reponsibility or
   layers higher up should be aware.
 * Only issue doorbell on REQ_END.
 * Understand if nvmeq->q_suspended is necessary with blk-mq.
 * Only a single name-space is supported. Keith suggests extending gendisk to be
   namespace aware.

Matias Bjorling (3):
  blk-mq: call exit_hctx on hw queue teardown
  NVMe: Extract admin queue size
  NVMe: Convert to blk-mq

 block/blk-mq.c            |   2 +
 drivers/block/nvme-core.c | 768 +++++++++++++++++++++++-----------------------
 drivers/block/nvme-scsi.c |  39 +--
 include/linux/nvme.h      |   7 +-
 4 files changed, 389 insertions(+), 427 deletions(-)

-- 
1.8.1.2

