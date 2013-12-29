Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3L2COE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:14:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55841 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616Ab3L2CN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:13:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Brian Norris" <computersforpeace@gmail.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.876510865@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 033/185] mtd: nand: hack ONFI for non-power-of-2
 dimensions
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit 4355b70cf48363c50a9de450b01178c83aba8f6a upstream.

Some bright specification writers decided to write this in the ONFI spec
(from ONFI 3.0, Section 3.1):

  "The number of blocks and number of pages per block is not required to
  be a power of two. In the case where one of these values is not a
  power of two, the corresponding address shall be rounded to an
  integral number of bits such that it addresses a range up to the
  subsequent power of two value. The host shall not access upper
  addresses in a range that is shown as not supported."

This breaks every assumption MTD makes about NAND block/chip-size
dimensions -- they *must* be a power of two!

And of course, an enterprising manufacturer has made use of this lovely
freedom. Exhibit A: Micron MT29F32G08CBADAWP

  "- Plane size: 2 planes x 1064 blocks per plane
   - Device size: 32Gb: 2128 blockss [sic]"

This quickly hits a BUG() in nand_base.c, since the extra dimensions
overflow so we think it's a second chip (on my single-chip setup):

    ONFI param page 0 valid
    ONFI flash detected
    NAND device: Manufacturer ID: 0x2c, Chip ID: 0x44 (Micron MT29F32G08CBADAWP), 4256MiB, page size: 8192, OOB size: 744
    ------------[ cut here ]------------
    kernel BUG at drivers/mtd/nand/nand_base.c:203!
    Internal error: Oops - BUG: 0 [#1] SMP ARM
    [... trim ...]
    [<c02cf3e4>] (nand_select_chip+0x18/0x2c) from [<c02d25c0>] (nand_do_read_ops+0x90/0x424)
    [<c02d25c0>] (nand_do_read_ops+0x90/0x424) from [<c02d2dd8>] (nand_read+0x54/0x78)
    [<c02d2dd8>] (nand_read+0x54/0x78) from [<c02ad2c8>] (mtd_read+0x84/0xbc)
    [<c02ad2c8>] (mtd_read+0x84/0xbc) from [<c02d4b28>] (scan_read.clone.4+0x4c/0x64)
    [<c02d4b28>] (scan_read.clone.4+0x4c/0x64) from [<c02d4c88>] (search_bbt+0x148/0x290)
    [<c02d4c88>] (search_bbt+0x148/0x290) from [<c02d4ea4>] (nand_scan_bbt+0xd4/0x5c0)
    [... trim ...]
    ---[ end trace 0c9363860d865ff2 ]---

So to fix this, just truncate these dimensions down to the greatest
power-of-2 dimension that is less than or equal to the specified
dimension.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
[bwh: Backported to 3.2:
 - Adjust context
 - p->lun_count is not used]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/nand/nand_base.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2895,10 +2895,22 @@ static int nand_flash_detect_onfi(struct
 	sanitize_string(p->model, sizeof(p->model));
 	if (!mtd->name)
 		mtd->name = p->model;
+
 	mtd->writesize = le32_to_cpu(p->byte_per_page);
-	mtd->erasesize = le32_to_cpu(p->pages_per_block) * mtd->writesize;
+
+	/*
+	 * pages_per_block and blocks_per_lun may not be a power-of-2 size
+	 * (don't ask me who thought of this...). MTD assumes that these
+	 * dimensions will be power-of-2, so just truncate the remaining area.
+	 */
+	mtd->erasesize = 1 << (fls(le32_to_cpu(p->pages_per_block)) - 1);
+	mtd->erasesize *= mtd->writesize;
+
 	mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
-	chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) * mtd->erasesize;
+
+	/* See erasesize comment */
+	chip->chipsize = 1 << (fls(le32_to_cpu(p->blocks_per_lun)) - 1);
+	chip->chipsize *= (uint64_t)mtd->erasesize;
 	*busw = 0;
 	if (le16_to_cpu(p->features) & 1)
 		*busw = NAND_BUSWIDTH_16;

