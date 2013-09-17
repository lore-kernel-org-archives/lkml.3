Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3IQBcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:32:05 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44038 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3IQBcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:32:02 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH] mtd: nand: fix memory leak in ONFI extended parameter page
Date: Mon, 16 Sep 2013 18:31:52 -0700
Message-Id: <1379381512-2007-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a memory leak in the ONFI support code for detecting the
required ECC levels from this commit:

  commit 6dcbe0cdd83fb5f77be4f44c9e06c535281c375a
  Author: Huang Shijie <b32955@freescale.com>
  Date:   Wed May 22 10:28:27 2013 +0800

      mtd: get the ECC info from the Extended Parameter Page

In the success case, we never freed the 'ep' buffer.

Also, this fixes an oversight in the same commit where we (harmlessly)
freed the NULL pointer.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>
---
David, if there are no objections, can you send this to Linus for 3.12?

If this doesn't make it into 3.12, then it will be -stable material.

 drivers/mtd/nand/nand_base.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index d4578a1..00022b4 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2869,10 +2869,8 @@ static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
 
 	len = le16_to_cpu(p->ext_param_page_length) * 16;
 	ep = kmalloc(len, GFP_KERNEL);
-	if (!ep) {
-		ret = -ENOMEM;
-		goto ext_out;
-	}
+	if (!ep)
+		return -ENOMEM;
 
 	/* Send our own NAND_CMD_PARAM. */
 	chip->cmdfunc(mtd, NAND_CMD_PARAM, 0, -1);
@@ -2920,7 +2918,7 @@ static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
 	}
 
 	pr_info("ONFI extended param page detected.\n");
-	return 0;
+	ret = 0;
 
 ext_out:
 	kfree(ep);
-- 
1.8.4

