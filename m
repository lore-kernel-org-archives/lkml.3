Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbbANH3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:29:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbANH3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Roger Quadros <rogerq@ti.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.18 110/150] mtd: nand: omap: Fix NAND enumeration on 3430 LDP
Date: Tue, 13 Jan 2015 23:23:01 -0800
Message-Id: <20150114072100.845306024@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/omap2.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1741,13 +1741,6 @@ static int omap_nand_probe(struct platfo
 		goto return_error;
 	}
 
-	/* check for small page devices */
-	if ((mtd->oobsize < 64) && (pdata->ecc_opt != OMAP_ECC_HAM1_CODE_HW)) {
-		dev_err(&info->pdev->dev, "small page devices are not supported\n");
-		err = -EINVAL;
-		goto return_error;
-	}
-
 	/* re-populate low-level callbacks based on xfer modes */
 	switch (pdata->xfer_type) {
 	case NAND_OMAP_PREFETCH_POLLED:


