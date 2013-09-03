Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959Ab3ICVIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:08:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41373 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3ICVIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:08:41 -0400
Message-ID: <52264FD4.1090809@linux.vnet.ibm.com>
Date: Tue, 03 Sep 2013 16:08:36 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] rsxx: Moving pci_map_page to prevent overflow
References: <20130827225924.GC7368@oc6784271780.ibm.com>
In-Reply-To: <20130827225924.GC7368@oc6784271780.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090321-5806-0000-0000-0000229E58D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 05:59 PM, Philip J. Kelleher wrote:
> diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
> --- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-08-12 15:22:18.612863489 -0500
> +++ linux-block/drivers/block/rsxx/dma.c	2013-08-12 15:23:22.158858765 -0500
> @@ -433,6 +434,27 @@ static void rsxx_issue_dmas(struct rsxx_
>  			continue;
>  		}
> 
> +		if (dma->cmd == HW_CMD_BLK_WRITE)
> +			dir = PCI_DMA_TODEVICE;
> +		else
> +			dir = PCI_DMA_FROMDEVICE;
> +
> +		/*
> +		 * The function pci_map_page is placed here because we can
> +		 * only, by design, issue up to 255 commands to the hardware
> +		 * at one time per DMA channel. So the maximum amount of mapped
> +		 * memory would be 255 * 4 channels * 4096 Bytes which is less
> +		 * than 2GB, the limit of a x8 Non-HWWD PCIe slot. This way the
> +		 * pci_map_page function should never fail because of a
> +		 * lack of mappable memory.
> +		 */
> +		dma->dma_addr = pci_map_page(ctrl->card->dev, dma->page,
> +				     dma->pg_off, dma->sub_page.cnt << 9, dir);
> +		if (pci_dma_mapping_error(ctrl->card->dev, dma->dma_addr)) {

Do you also need to do a push_tracker here as well so you don't leak a tag?
Why is this error case handled different compared to the dma_fault case earlier
in this same function?

> +			kmem_cache_free(rsxx_dma_pool, dma);
> +			return;
> +		}
> +
>  		set_tracker_dma(ctrl->trackers, tag, dma);
>  		hw_cmd_buf[ctrl->cmd.idx].command  = dma->cmd;
>  		hw_cmd_buf[ctrl->cmd.idx].tag      = tag;

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


