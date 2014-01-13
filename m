Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaAMKhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:37:53 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:60707 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaAMKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:37:51 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Huang Shijie <b32955@freescale.com>, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] mtd: mtd_oobtest: fix verify errors due to incorrect use of prandom_bytes_state()
Date: Mon, 13 Jan 2014 11:25:39 +0100
Message-Id: <1389608739-10945-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using prandom_bytes_state() it is critical to use the same block
size in all invocations that are to produce the same random sequence.
Otherwise the state of the PRNG will be out of sync if the blocksize
is not divisible by 4.
This leads to bogus verification errors in several tests which use
different block sizes to initialize the buffer for writing and
comparison.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/mtd/tests/oobtest.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index 2e9e2d1..72c7359 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -213,8 +213,15 @@ static int verify_eraseblock_in_one_go(int ebnum)
 	int err = 0;
 	loff_t addr = ebnum * mtd->erasesize;
 	size_t len = mtd->ecclayout->oobavail * pgcnt;
+	int i;
+
+	for (i = 0; i < pgcnt; i++)
+		prandom_bytes_state(&rnd_state, &writebuf[i * use_len],
+				use_len);
+	if (len % use_len)
+		prandom_bytes_state(&rnd_state, &writebuf[i * use_len],
+				len % use_len);
 
-	prandom_bytes_state(&rnd_state, writebuf, len);
 	ops.mode      = MTD_OPS_AUTO_OOB;
 	ops.len       = 0;
 	ops.retlen    = 0;
@@ -594,7 +601,10 @@ static int __init mtd_oobtest_init(void)
 		if (bbt[i] || bbt[i + 1])
 			continue;
 		prandom_bytes_state(&rnd_state, writebuf,
-					mtd->ecclayout->oobavail * 2);
+					mtd->ecclayout->oobavail);
+		prandom_bytes_state(&rnd_state,
+					writebuf + mtd->ecclayout->oobavail,
+					mtd->ecclayout->oobavail);
 		addr = (i + 1) * mtd->erasesize - mtd->writesize;
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
-- 
1.7.2.5

