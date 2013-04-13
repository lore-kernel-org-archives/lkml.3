Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3DMNiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 09:38:10 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:64755 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3DMNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 09:38:08 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com
Cc: linux-mtd@lists.infradead.org, nbd-general@lists.sourceforge.net,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 0/8] fix max discard sectors limit
Date: Sat, 13 Apr 2013 22:37:29 +0900
Message-Id: <1365860249-21193-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 
(block: add plug for blkdev_issue_discard )

For example,
1) DISCARD rq-1 with size size 4GB
2) DISCARD rq-2 with size size 1GB

If these 2 discard requests get merged, final request size will be 5GB.

In this case, request's __data_len field may overflow as it can store
max 4GB(unsigned int).

This issue was observed while doing mkfs.f2fs on 5GB SD card:
https://lkml.org/lkml/2013/4/1/292

# mkfs.f2fs /dev/mmcblk0p3
Info: sector size = 512
Info: total sectors = 11370496 (in 512bytes)
Info: zone aligned segment0 blkaddr: 512
[  257.789764] blk_update_request: bio idx 0 >= vcnt 0

mkfs process gets stuck in D state and I see the following in the dmesg:

[  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
[  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
[  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
[  257.789764] blk_update_request: bio idx 0 >= vcnt 0
[  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
[  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
[  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656

Few drivers(e.g. mmc, mtd..) set q->limits.max_discard_sectors
more than UINT_MAX >> 9 sectors which is incorrect and it may lead to overflow
of request's __data_len field if merged discard request's size exceeds 4GB.

This patchset fixes this issue by updating helper function
blk_queue_max_discard_sectors which is used to set max_discard_sectors limit.

This patchset also replaces "q->limits.max_discard_sector = max_discard_sectors"
with blk_queue_max_discard_sectors call in other drivers like mmc, mtd etc.

Namjae Jeon (8):
  block: fix max discard sectors limit
  mmc: fix max_discard_sectors
  mtd: use generic helper to set max_discard_sectors
  loop: use generic helper to set max_discard_sectors
  nbd: use generic helper to set max_discard_sectors
  brd: use generic helper to set max_discard_sectors
  dm thin: use generic helper to set max_discard_sectors
  bcache: use generic helper to set max_discard_sectors
-- 
1.7.9.5

