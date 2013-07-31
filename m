Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab3GaWFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:05:55 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25312 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667Ab3GaWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:05:54 -0400
X-IronPort-AV: E=Sophos;i="4.89,790,1367964000"; 
   d="scan'208";a="28117048"
Message-ID: <51F98A3F.3000102@inria.fr>
Date: Thu, 01 Aug 2013 00:05:51 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Dan Williams <djbw@fb.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: ioatdma: add ioat_raid_enabled module parameter
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioatdma: add ioat_raid_enabled module parameter

Commit f26df1a1 added a 64-byte alignment requirement for legacy
operations to work around a silicon errata when mixing legacy and
RAID descriptors.
Passing ioat_raid_enabled=0 now disables RAID offload entirely in
the ioatdma driver so that legacy operations (memcpy, etc.) can
work without alignment restrictions anymore.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 drivers/dma/ioat/dma_v3.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/dma/ioat/dma_v3.c
===================================================================
--- a/drivers/dma/ioat/dma_v3.c	2013-07-31 23:06:24.163810000 +0200
+++ b/drivers/dma/ioat/dma_v3.c	2013-07-31 23:47:54.246719841 +0200
@@ -67,6 +67,11 @@
 #include "dma.h"
 #include "dma_v2.h"
 
+static int ioat_raid_enabled = 1;
+module_param(ioat_raid_enabled, int, 0444);
+MODULE_PARM_DESC(ioat_raid_enabled,
+		 "control support of RAID offload (default: 1)");
+
 /* ioat hardware assumes at least two sources for raid operations */
 #define src_cnt_to_sw(x) ((x) + 2)
 #define src_cnt_to_hw(x) ((x) - 2)
@@ -1775,7 +1780,7 @@ int ioat3_dma_probe(struct ioatdma_devic
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 
-	if (is_xeon_cb32(pdev))
+	if (is_xeon_cb32(pdev) && ioat_raid_enabled)
 		dma->copy_align = 6;
 
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
@@ -1783,7 +1788,7 @@ int ioat3_dma_probe(struct ioatdma_devic
 
 	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
 
-	if (is_bwd_noraid(pdev))
+	if (!ioat_raid_enabled || is_bwd_noraid(pdev))
 		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
 
 	/* dca is incompatible with raid operations */

