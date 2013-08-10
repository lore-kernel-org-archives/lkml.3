Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030930Ab3HJHrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 03:47:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49824 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030825Ab3HJHrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 03:47:06 -0400
Date: Sat, 10 Aug 2013 10:46:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] dmaengine: make dma_submit_error() return an error code
Message-ID: <20130810074650.GA14390@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem here is that the dma_xfer() functions in
drivers/ata/pata_arasan_cf.c and drivers/mtd/nand/fsmc_nand.c expect
dma_submit_error() to return an error code so they return 1 when they
intended to return a negative.

So far as I can tell, none of the ->tx_submit() functions ever do
return error codes so this patch should have no effect in the current
code.

I also changed it from a define to an inline.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5692bc3..16321fb 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -38,7 +38,10 @@ typedef s32 dma_cookie_t;
 #define DMA_MIN_COOKIE	1
 #define DMA_MAX_COOKIE	INT_MAX
 
-#define dma_submit_error(cookie) ((cookie) < 0 ? 1 : 0)
+static inline int dma_submit_error(dma_cookie_t cookie)
+{
+	return cookie < 0 ? cookie : 0;
+}
 
 /**
  * enum dma_status - DMA transaction status
