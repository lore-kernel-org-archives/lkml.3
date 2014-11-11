Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaKKLRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:17:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaKKLLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrea Adami <andrea.adami@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 156/170] mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips
Date: Tue, 11 Nov 2014 11:08:35 +0000
Message-Id: <1415704129-12709-157-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit 89cf38dd536a7301d6b5f5ddd73f42074c01bfaa upstream.

After '#echo mem > /sys/power/state' some devices can not be properly resumed
because apparently the MTD Partition Configuration Register has been reset
to default thus the rootfs cannot be mounted cleanly on resume.
An example of this can be found in the SA-1100 Developer's Manual at 9.5.3.3
where the second step of the Sleep Shutdown Sequence is described:
"An internal reset is applied to the SA-1100. All units are reset...".

As workaround we refresh the PCR value as done initially on chip setup.

This behavior and the fix are confirmed by our tests done on 2 different Zaurus
collie units with kernel 3.17.

Fixes: 812c5fa82bae: ("mtd: cfi_cmdset_0001.c: add support for Sharp LH28F640BF NOR")
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/chips/cfi_cmdset_0001.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index a7543ba3e190..3096f3ded3ad 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2590,6 +2590,8 @@ static void cfi_intelext_resume(struct mtd_info *mtd)
 
 		/* Go to known state. Chip may have been power cycled */
 		if (chip->state == FL_PM_SUSPENDED) {
+			/* Refresh LH28F640BF Partition Config. Register */
+			fixup_LH28F640BF(mtd);
 			map_write(map, CMD(0xFF), cfi->chips[i].start);
 			chip->oldstate = chip->state = FL_READY;
 			wake_up(&chip->wq);
-- 
2.1.0

