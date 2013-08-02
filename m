Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3HBR0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:26:07 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:16764 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab3HBR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:26:06 -0400
X-IronPort-AV: E=Sophos;i="4.89,802,1367964000"; 
   d="scan'208";a="28326206"
Message-ID: <51FBEBAB.9080300@inria.fr>
Date: Fri, 02 Aug 2013 19:26:03 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Dan Williams <djbw@fb.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "Mason, Jon" <jon.mason@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
References: <CE21305B.1D1BD%djbw@fb.com>
In-Reply-To: <CE21305B.1D1BD%djbw@fb.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/08/2013 18:57, Dan Williams a écrit :
> I like Jon¹s suggestion.  Just make raid disabled by default on non-atom
> platforms.  When if a non-atom platform comes along without the previous
> restrictions it can add itself to this list.
>
> So let¹s drop the module parameter and just cleanup the 3.2 support to
> reflect the current reality of raid being disabled.

So you want this instead ?

Brice


ioatdma: disable RAID on non-Atom platforms and reenable unaligned copies

Disable RAID on non-Atom platform and remove the 64-byte alignement
restriction on legacy DMA operations (introduced in commit f26df1a1
as a workaround for silicon errata).

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 drivers/dma/ioat/dma_v3.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: b/drivers/dma/ioat/dma_v3.c
===================================================================
--- a/drivers/dma/ioat/dma_v3.c	2013-07-31 23:06:24.163810000 +0200
+++ b/drivers/dma/ioat/dma_v3.c	2013-08-02 19:17:26.075745688 +0200
@@ -1775,15 +1775,12 @@ int ioat3_dma_probe(struct ioatdma_devic
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 
-	if (is_xeon_cb32(pdev))
-		dma->copy_align = 6;
-
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 
 	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
 
-	if (is_bwd_noraid(pdev))
+	if (is_xeon_cb32(pdev) || is_bwd_noraid(pdev))
 		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
 
 	/* dca is incompatible with raid operations */

