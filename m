Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaH1UxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:53:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:42375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaH1UxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:53:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473593579"
Subject: [PATCH 1/6] ntb: Add alignment check to meet hardware requirement
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@kudzu.us
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 13:53:02 -0700
Message-ID: <20140828205302.165750.3398.stgit@djiang5-desk2.amr.corp.intel.com>
In-Reply-To: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
References: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NTB translate register must have the value to be BAR size aligned.
This alignment check make sure that the DMA memory allocated has the
proper alignment. Another requirement for NTB to function properly with
memory window BAR size greater or equal to 4M is to use the CMA feature
in 3.16 kernel with the appropriate CONFIG_CMA_ALIGNMENT and
CONFIG_CMA_SIZE_MBYTES set.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/ntb/ntb_transport.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 611fef4..24f0ac1 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -576,6 +576,19 @@ static int ntb_set_mw(struct ntb_transport *nt, int num_mw, unsigned int size)
 		return -ENOMEM;
 	}
 
+	/*
+	 * we must ensure that the memory address allocated is BAR size
+	 * aligned in order for the XLAT register to take the value. This
+	 * is a requirement of the hardware. It is recommended to setup CMA
+	 * for BAR sizes equal or greater than 4MB.
+	 */
+	if (!IS_ALIGNED(mw->dma_addr, mw->size)) {
+		dev_err(&pdev->dev, "DMA memory %#Lx not aligned to BAR size\n",
+			mw->dma_addr);
+		ntb_free_mw(nt, num_mw);
+		return -ENOMEM;
+	}
+
 	/* Notify HW the memory location of the receive buffer */
 	ntb_set_mw_addr(nt->ndev, num_mw, mw->dma_addr);
 

