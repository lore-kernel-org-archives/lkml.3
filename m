Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbaJVXXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:23:08 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60876 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbaJVXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:23:06 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Riesch <christian.riesch@omicron.at>,
        Jingoo Han <jg1.han@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrea Adami <andrea.adami@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips
Date: Thu, 23 Oct 2014 01:23:01 +0200
Message-Id: <1414020181-8855-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After '#echo mem > /sys/power/state' some devices can not be properly resumed
because apparently the MTD Partition Configuration Register has been reset
to default thus the rootfs cannot be mounted cleanly on resume.
An example of this can be found in the SA-1100 Developer's Manual at 9.5.3.3
where the second step of the Sleep Shutdown Sequence is described:
"An internal reset is applied to the SA-1100. All units are reset...".

As workaround we refresh the PCR value as done initially on chip setup.

This behavior and the fix are confirmed by our tests done on 2 different Zaurus
collie units with kernel 3.17.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 drivers/mtd/chips/cfi_cmdset_0001.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index a7543ba..59e2355 100644
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
1.9.1

