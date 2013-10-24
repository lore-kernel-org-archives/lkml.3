Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3JXRox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 13:44:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:11400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab3JXRow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 13:44:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="312295686"
Date: Thu, 24 Oct 2013 22:20:55 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Valentin Ilie <valentin.ilie@gmail.com>, Joel Fernandes <joelf@ti.com>,
        dma <dmaengine@vger.kernel.org>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: edma: Fix memory leak
Message-ID: <20131024165055.GB21230@intel.com>
References: <1382620462-9799-1-git-send-email-valentin.ilie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382620462-9799-1-git-send-email-valentin.ilie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 04:14:22PM +0300, Valentin Ilie wrote:
> When it fails to allocate a slot, edesc should be free'd before return;
> 
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  drivers/dma/edma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 098a8da..79ebac6 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -305,6 +305,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
>  						EDMA_SLOT_ANY);
>  			if (echan->slot[i] < 0) {
> +				kfree(edesc);
>  				dev_err(dev, "Failed to allocate slot\n");
>  				return NULL;
>  			}
Applied along with one more fix on the same line

-><8--
From: Vinod Koul <vinod.koul@intel.com>
Date: Thu, 24 Oct 2013 22:17:50 +0530
Subject: [PATCH] dmaengine: edma: fix another memory leak

commit 4b6271a6 fix a menory leak but one more existed in driver so fix that

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/edma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 134fa96..10b577f 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -347,6 +347,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 			ccnt = sg_dma_len(sg) / (acnt * bcnt);
 			if (ccnt > (SZ_64K - 1)) {
 				dev_err(dev, "Exceeded max SG segment size\n");
+				kfree(edesc);
 				return NULL;
 			}
 			cidx = acnt * bcnt;
-- 
1.7.0.4

~Vinod
