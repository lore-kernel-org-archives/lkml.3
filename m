Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3JYGcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 02:32:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3JYGcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 02:32:54 -0400
Date: Fri, 25 Oct 2013 08:32:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
In-Reply-To: <20131025042310.GC21230@intel.com>
Message-ID: <Pine.LNX.4.64.1310250813370.6186@axis700.grange>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com> <20131017142755.GA4477@breakpoint.cc>
 <20131017134846.GG14013@intel.com> <Pine.LNX.4.64.1310242326500.2900@axis700.grange>
 <20131025042310.GC21230@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:u5RevS61emX0mfsQFOgAhQejLLL1seHw5svnoRU/O8r
 W5IWA+kezRbuToZkqh884n46Sz3jg4OJyWoZBo6mzDO7GMvoA3
 +xpmYnDkaOFlCBRcD5Hu2rUrWjzI/UpCTCG2ypWWQcG2BcV0yU
 VsJsaept7zIdLNz6HYulh48QmREMiwRSE6odGpGgBiYbmEssRp
 UuZUTgtIP6am12QWO1MLk23vUyi4Fc/IOlIOAacDqve8aGL2ax
 esJsrxMMDGih20Fos5ClsbPnnV9NwNHb59onSCpA09iGYGRgL2
 kt1MXpvz7QqP/4YcBQvxAuR9BPsbOOIby7F7n/PJIVOiMtG49l
 +E9IEpwSmh+WT5iYJYlLU5N6JmzgmVafxoGbB9RHena0j1v6Ru
 v3wO7e1Z8LuMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Fri, 25 Oct 2013, Vinod Koul wrote:

> On Thu, Oct 24, 2013 at 11:28:29PM +0200, Guennadi Liakhovetski wrote:
> > Hi Vinod
> > 
> > On Thu, 17 Oct 2013, Vinod Koul wrote:
> > > Yes i missed it in first place update the patch to fix that
> > 
> > Are you planning to post a fixed version of this patch or you just fix it 
> > internally? Would be good to have it posted to be able to ack it and other 
> > relevant patches.
> looks like you missed it... I had posted updated patch [1] in this thread here
> and I posted 29th patch as removal one [2]

No, I didn't miss those, but as Sebastian pointed out and as I commented 
too, also that v2 version wasn't correct, so, a fixed v3 was needed. 
Consider this:

In patch 1 you do:

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0bc7275..683c380 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -45,16 +45,17 @@ static inline int dma_submit_error(dma_cookie_t cookie)
 
 /**
  * enum dma_status - DMA transaction status
- * @DMA_SUCCESS: transaction completed successfully
+ * @DMA_COMPLETE: transaction completed
  * @DMA_IN_PROGRESS: transaction not yet processed
  * @DMA_PAUSED: transaction is paused
  * @DMA_ERROR: transaction failed
  */
 enum dma_status {
-	DMA_SUCCESS,
+	DMA_COMPLETE,
 	DMA_IN_PROGRESS,
 	DMA_PAUSED,
 	DMA_ERROR,
+	DMA_SUCCESS,
 };
 
 /**

and then in a couple of places

-			return DMA_SUCCESS;
+			return DMA_COMPLETE;

So, after that your patch dmaengine would be returning DMA_COMPLETE in 
case of success, i.e. 0. But all the DMAC and user drivers would still be 
checking for

	if (status != DMA_COMPLETE) {

i.e. comparing status with 4 and thus detecting false errors, until your 
further 28 patches fix them. That's why, as Sebastian pointed out it was 
important to define DMA_COMPLETE and DMA_SUCCESS with the _same_ numerical 
value in your patch 1.

> Both were pushed to -next after few days

That's a pity, but I still don't see them in upstream -next, so, maybe 
it's still possible to fix?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
