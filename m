Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3ITULe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:11:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41402 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3ITUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Norris <computersforpeace@gmail.com>,
        Matthieu Castet <matthieu.castet@parrot.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 04/93] mtd: nand: fix NAND_BUSWIDTH_AUTO for x16 devices
Date: Fri, 20 Sep 2013 13:07:59 -0700
Message-Id: <1379707768-1804-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit 68e8078072e802e77134664f11d2ffbfbd2f8fbe upstream.

The code for NAND_BUSWIDTH_AUTO is broken. According to Alexander:

  "I have a problem with attach NAND UBI in 16 bit mode.
   NAND works fine if I specify NAND_BUSWIDTH_16 option, but not
   working with NAND_BUSWIDTH_AUTO option. In second case NAND
   chip is identifyed with ONFI."

See his report for the rest of the details:

  http://lists.infradead.org/pipermail/linux-mtd/2013-July/047515.html

Anyway, the problem is that nand_set_defaults() is called twice, we
intend it to reset the chip functions to their x16 buswidth verions
if the buswidth changed from x8 to x16; however, nand_set_defaults()
does exactly nothing if called a second time.

Fix this by hacking nand_set_defaults() to reset the buswidth-dependent
functions if they were set to the x8 version the first time. Note that
this does not do anything to reset from x16 to x8, but that's not the
supported use case for NAND_BUSWIDTH_AUTO anyway.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Reported-by: Alexander Shiyan <shc_work@mail.ru>
Tested-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/nand/nand_base.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index db04f53..d831091 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2810,7 +2810,9 @@ static void nand_set_defaults(struct nand_chip *chip, int busw)
 
 	if (!chip->select_chip)
 		chip->select_chip = nand_select_chip;
-	if (!chip->read_byte)
+
+	/* If called twice, pointers that depend on busw may need to be reset */
+	if (!chip->read_byte || chip->read_byte == nand_read_byte)
 		chip->read_byte = busw ? nand_read_byte16 : nand_read_byte;
 	if (!chip->read_word)
 		chip->read_word = nand_read_word;
@@ -2818,9 +2820,9 @@ static void nand_set_defaults(struct nand_chip *chip, int busw)
 		chip->block_bad = nand_block_bad;
 	if (!chip->block_markbad)
 		chip->block_markbad = nand_default_block_markbad;
-	if (!chip->write_buf)
+	if (!chip->write_buf || chip->write_buf == nand_write_buf)
 		chip->write_buf = busw ? nand_write_buf16 : nand_write_buf;
-	if (!chip->read_buf)
+	if (!chip->read_buf || chip->read_buf == nand_read_buf)
 		chip->read_buf = busw ? nand_read_buf16 : nand_read_buf;
 	if (!chip->scan_bbt)
 		chip->scan_bbt = nand_default_bbt;
-- 
1.8.1.2

