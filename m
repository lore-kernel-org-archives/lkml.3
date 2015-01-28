Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbbA2Btq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:49:46 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53630 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbbA2Btn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:49:43 -0500
Date: Wed, 28 Jan 2015 19:22:08 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: JBottomley@parallels.com
Cc: hch@lst.de, hare@suse.de, michaelc@cs.wisc.edu, martin.petersen@oracle.com,
        daeseok.youn@gmail.com, ben@decadent.org.uk,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: missing iounmap for mvi->regs_ex
Message-ID: <20150128102208.GA16509@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It also need to call iounmap() when it fails to get res_start and
res_len from pci_resource_start{len}(pdev, bar).

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 53030b0..2508db2 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -348,15 +348,15 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 	else
 		mvi->regs = ioremap_nocache(res_start, res_len);
 
-	if (!mvi->regs) {
-		if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
-			iounmap(mvi->regs_ex);
-		mvi->regs_ex = NULL;
+	if (!mvi->regs)
 		goto err_out;
-	}
 
 	return 0;
 err_out:
+	if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
+		iounmap(mvi->regs_ex);
+	mvi->regs_ex = NULL;
+
 	return -1;
 }
 
-- 
1.7.1

