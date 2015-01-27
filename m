Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbbA0Mn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:43:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbbA0MRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 040/126] mtd: nand: omap: Fix NAND enumeration on 3430 LDP
Date: Tue, 27 Jan 2015 12:15:45 +0000
Message-Id: <1422361031-19364-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 775a9134f4398ca98a10af8cc3cf9b664017267f upstream.

3430LDP has NAND flash with 32 bytes OOB size which is sufficient to hold
BCH8 codes but the small page check introduced in
commit b491da7233d5 ("mtd: nand: omap: clean-up ecc layout for BCH ecc schemes")
considers anything below 64 bytes unsuitable for BCH4/8/16. There is another
bug in that code where it doesn't skip the check for OMAP_ECC_HAM1_CODE_SW.

Get rid of that small page check code as it is insufficient and redundant
because we are checking for OOB available bytes vs ecc layout before calling
nand_scan_tail().

Fixes: b491da7233d5 ("mtd: nand: omap: clean-up ecc layout for BCH ecc schemes")

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/nand/omap2.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index e2b9b345177a..575a015c8394 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1700,13 +1700,6 @@ static int omap_nand_probe(struct platform_device *pdev)
 		goto return_error;
 	}
 
-	/* check for small page devices */
-	if ((mtd->oobsize < 64) && (pdata->ecc_opt != OMAP_ECC_HAM1_CODE_HW)) {
-		pr_err("small page devices are not supported\n");
-		err = -EINVAL;
-		goto return_error;
-	}
-
 	/* re-populate low-level callbacks based on xfer modes */
 	switch (pdata->xfer_type) {
 	case NAND_OMAP_PREFETCH_POLLED:
-- 
2.1.4

