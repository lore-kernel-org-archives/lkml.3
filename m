Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3HMAGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:06:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43556 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3HMAGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:06:08 -0400
Message-ID: <5209784D.8080502@ti.com>
Date: Mon, 12 Aug 2013 19:05:33 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 01/12] dma: edma: Setup parameters to DMA MAX_NR_SG
 at a time
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-2-git-send-email-joelf@ti.com> <52088B8B.9040000@ti.com>
In-Reply-To: <52088B8B.9040000@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Responding to other comments in this post,

On 08/12/2013 02:15 AM, Sekhar Nori wrote:

[..]
>>  	if (unlikely(!echan || !sgl || !sg_len))
>>  		return NULL;
>> @@ -262,8 +262,11 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>>  
>>  	edesc->pset_nr = sg_len;
>>  
>> -	for_each_sg(sgl, sg, sg_len, i) {
>> -		/* Allocate a PaRAM slot, if needed */
>> +	/* Allocate a PaRAM slot, if needed */
>> +
>> +	num_slots_needed = sg_len > MAX_NR_SG ? MAX_NR_SG : sg_len;
> 
> nslots = min(MAX_NR_SG, sg_len);

Changed to this, with the +1

> 
>> +
>> +	for (i = 0; i < num_slots_needed; i++) {
>>  		if (echan->slot[i] < 0) {
>>  			echan->slot[i] =
>>  				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
>> @@ -273,6 +276,10 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>>  				return NULL;
>>  			}
>>  		}
>> +	}
>> +
>> +	/* Configure PaRAM sets for each SG */
>> +	for_each_sg(sgl, sg, sg_len, i) {
>>  
>>  		acnt = dev_width;
>>  
>> @@ -330,6 +337,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>>  		/* Configure A or AB synchronized transfers */
>>  		if (edesc->absync)
>>  			edesc->pset[i].opt |= SYNCDIM;
>> +
> 
> Random extra newline.

Removing..

> 
> The patch as such is fine, but I dont think it makes lot of sense
> standalone. This needs to be merged into the patch where you actually
> handle the entire SG list in batches.

I think it does actually, this patch just takes care of preparing the
param set list correctly and allocating slots. It doesn't the actual DMA
or take part in the algorithm. As a result, the patch can be reused
incase in future the main algorithm is rewritten in a subsequent series.
Further this patch was reused straight from old implementation so it
proved to be useful being a separate patch last time. I also plan to
rewrite just this functionality in the future.

Thanks,

-Joel


