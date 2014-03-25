Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaCYXze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:55:34 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:43691 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaCYXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:55:33 -0400
From: Gwendal Grignou <gwendal@chromium.org>
To: axboe@kernel.dk, ulf.hansson@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH 0/4] Set max_discard_sectors maximal value to UINT_MAX>>9
Date: Tue, 25 Mar 2014 16:48:22 -0700
Message-Id: <1395791307-23727-1-git-send-email-gwendal@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this change, 'blkdiscard /dev/mmcblk0' would panic:
Because max_discard_sectors was set to 4G sectors, discard request issued
on behalf of blkdiscard would be merged, leading to request larger than 4GB:
[  169.035929] __end_that: dev mmcblk0: type=1, flags=122c8081
[  169.041464]   sector 0, nr/cnr 0/4294966272
[  169.045689]   bio ebb7a380, biotail ebb7aa80, buffer   (null), len 0
[  169.052106] blk_update_request: bio idx 0 >= vcnt 0
[  169.057068] request botched: dev mmcblk0: type=1, flags=122c8081
[  169.063138]   sector 0, nr/cnr 0/4294966272
[  169.067436]   bio ebb7a380, biotail ebb7aa80, buffer   (null), len 0
The IOCTL would be stuck in the kernel, a watchdog would reboot the machine.

After this change, blkdiscard works fine. With blktrace/blkparse, I verified
the discard requests are sane: 8387584 is 4GB in sectors rounded down.
Example of a ~16GB device:
 9368  Q   D 0 + 8387584 [blkdiscard]
    0  m   N cfq9368 alloced
 9368  G   D 0 + 8387584 [blkdiscard]
 9368  P   N [blkdiscard]
 9368  Q   D 8387584 + 8387584 [blkdiscard]
 9368  G   D 8387584 + 8387584 [blkdiscard]
 9368  Q   D 16775168 + 8387584 [blkdiscard]
 9368  G   D 16775168 + 8387584 [blkdiscard]
 9368  Q   D 25162752 + 5372928 [blkdiscard]
 9368  G   D 25162752 + 5372928 [blkdiscard]
 9368  I   D 0 + 8387584 [blkdiscard]
    0  m   N cfq9368 insert_request
    0  m   N cfq9368 add_to_rr
 9368  I   D 8387584 + 8387584 [blkdiscard]
    0  m   N cfq9368 insert_request
 9368  I   D 16775168 + 8387584 [blkdiscard]
    0  m   N cfq9368 insert_request
 9368  I   D 25162752 + 5372928 [blkdiscard]
    0  m   N cfq9368 insert_request
 9368  U   N [blkdiscard] 4
 ...

I fixed the other locations where max_discard_sectors was set to
UINT_MAX and checked the other settings were in units of 512 bytes
sectors.

Gwendal Grignou (4):
  Limit max_discard_sectors to UINT_MAX>>9
  Limit max_discard_sectors to UINT_MAX>>9
  Limit max_discard_sectors to UINT_MAX>>9
  Limit max_discard_sectors to UINT_MAX>>9

 block/blk-lib.c           | 2 +-
 drivers/block/nbd.c       | 2 +-
 drivers/mmc/core/core.c   | 6 ++++--
 drivers/mtd/mtd_blkdevs.c | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.9.1.423.g4596e3a

