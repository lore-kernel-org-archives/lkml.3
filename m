Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3HLHQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:16:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44593 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3HLHQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:16:32 -0400
Message-ID: <52088B8B.9040000@ti.com>
Date: Mon, 12 Aug 2013 12:45:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 01/12] dma: edma: Setup parameters to DMA MAX_NR_SG
 at a time
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-2-git-send-email-joelf@ti.com>
In-Reply-To: <1375719297-12871-2-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
> Changes are made here for configuring existing parameters to support
> DMA'ing them out in batches as needed.
> 
> Also allocate as many as slots as needed by the SG list, but not more
> than MAX_NR_SG. Then these slots will be reused accordingly.
> For ex, if MAX_NR_SG=10, and number of SG entries is 40, still only
> 10 slots will be allocated to DMA the entire SG list of size 40.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  drivers/dma/edma.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 5f3e532..7b0853c 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -222,9 +222,9 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  	enum dma_slave_buswidth dev_width;
>  	u32 burst;
>  	struct scatterlist *sg;
> -	int i;
>  	int acnt, bcnt, ccnt, src, dst, cidx;
>  	int src_bidx, dst_bidx, src_cidx, dst_cidx;
> +	int i, num_slots_needed;

'nslots' is more to my liking. Better keep variable names short.

>  
>  	if (unlikely(!echan || !sgl || !sg_len))
>  		return NULL;
> @@ -262,8 +262,11 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  
>  	edesc->pset_nr = sg_len;
>  
> -	for_each_sg(sgl, sg, sg_len, i) {
> -		/* Allocate a PaRAM slot, if needed */
> +	/* Allocate a PaRAM slot, if needed */
> +
> +	num_slots_needed = sg_len > MAX_NR_SG ? MAX_NR_SG : sg_len;

nslots = min(MAX_NR_SG, sg_len);

> +
> +	for (i = 0; i < num_slots_needed; i++) {
>  		if (echan->slot[i] < 0) {
>  			echan->slot[i] =
>  				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
> @@ -273,6 +276,10 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  				return NULL;
>  			}
>  		}
> +	}
> +
> +	/* Configure PaRAM sets for each SG */
> +	for_each_sg(sgl, sg, sg_len, i) {
>  
>  		acnt = dev_width;
>  
> @@ -330,6 +337,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  		/* Configure A or AB synchronized transfers */
>  		if (edesc->absync)
>  			edesc->pset[i].opt |= SYNCDIM;
> +

Random extra newline.

The patch as such is fine, but I dont think it makes lot of sense
standalone. This needs to be merged into the patch where you actually
handle the entire SG list in batches.

Thanks,
Sekhar

