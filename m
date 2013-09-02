Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3IJRbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:31:55 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45104 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3IJRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:31:53 -0400
From: ycbzzjlby@gmail.com
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bian Yu <bianyu@kedacom.com>
Subject: [PATCH] raid5: Retry R5_ReadNoMerge flag when hit a read error.
Date: Sun,  1 Sep 2013 20:13:02 -0400
Message-Id: <1378080782-9971-1-git-send-email-ycbzzjlby@gmail.com>
X-Mailer: git-send-email 1.7.1
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bian Yu <bianyu@kedacom.com>

Because of block layer merge, one bio fails will cause other bios
which belongs to the same request fails, so raid5_end_read_request
will record all these bios as badblocks.
If retry request with R5_ReadNoMerge flag to avoid bios merge,
badblocks can only record sector which is bad exactly.

test:
hdparm --yes-i-know-what-i-am-doing --make-bad-sector 300000 /dev/sdb
mdadm -C /dev/md0 -l5 -n3 /dev/sd[bcd] --assume-clean
mdadm /dev/md0 -f /dev/sdd
mdadm /dev/md0 -r /dev/sdd
mdadm --zero-superblock /dev/sdd
mdadm /dev/md0 -a /dev/sdd

1. Without this patch:
cat /sys/block/md0/md/rd*/bad_blocks
299776 256
299776 256

2. With this patch:
cat /sys/block/md0/md/rd*/bad_blocks
300000 8
300000 8

Signed-off-by: Bian Yu <bianyu@kedacom.com>
---
 drivers/md/raid5.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ff1aecf..ee8c280 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1924,6 +1924,9 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			       mdname(conf->mddev), bdn);
 		else
 			retry = 1;
+		if (set_bad && test_bit(In_sync, &rdev->flags)
+		    && !test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
+			retry = 1;
 		if (retry)
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
 				set_bit(R5_ReadError, &sh->dev[i].flags);
-- 
1.7.1

