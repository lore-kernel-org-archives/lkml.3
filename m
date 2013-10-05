Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3JETCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 15:02:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40554 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3JETCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 15:02:18 -0400
Date: Sat, 5 Oct 2013 20:02:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] DMA: extend documentation to provide more API details
Message-ID: <20131005190200.GZ12758@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1310051925170.8097@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1310051925170.8097@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 07:36:20PM +0200, Guennadi Liakhovetski wrote:
> This patch extends dmaengine documentation to provide more details
> on descriptor prepare stage, transaction completion requirements
> and DMA error processing.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> These extensions reflect my understanding of some aspects of the dmaengine 
> API. If it is wrong, I'd be happy if someone could correct me. If or where 
> I'm right, I think, those aspects might want an update. Once we understand 
> exactly the situation we can think about improvements to the API.
> 
>  Documentation/dmaengine.txt |   58 ++++++++++++++++++++++++++++++++++++------
>  1 files changed, 49 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
> index 879b6e3..21bb72d 100644
> --- a/Documentation/dmaengine.txt
> +++ b/Documentation/dmaengine.txt
> @@ -133,8 +133,17 @@ The slave DMA usage consists of following steps:
>  	locks before calling the callback function which may cause a
>  	deadlock.
>  
> -	Note that callbacks will always be invoked from the DMA
> -	engines tasklet, never from interrupt context.
> +	Note that callbacks will always be invoked from the DMA engine's
> +	interrupt processing bottom half, never from interrupt context.
> +
> +   Note 2:
> +	A DMA transaction descriptor, returned to the user by one of "prep"
> +	methods is considered as belogning to the user until it is submitted
> +	to the dmaengine driver for transfer. However, it is recommended, that
> +	the dmaengine driver keeps references to prepared descriptors too,
> +	because if dmaengine_terminate_all() is called at that time, the driver
> +	will have to recycle all allocated descriptors for the respective
> +	channel.

No.  That's quite dangerous.  think about what can happen.

Thread 1		Thread 2
Driver calls prepare
			dmaengine_terminate_all()
				dmaengine driver frees prepared descriptor
driver submits descriptor

You now have a descriptor which has been freed submitted to the DMA engine
queue.  This will cause chaos.

>  4. Submit the transaction
>  
> @@ -150,15 +159,27 @@ The slave DMA usage consists of following steps:
>     dmaengine_submit() will not start the DMA operation, it merely adds
>     it to the pending queue.  For this, see step 5, dma_async_issue_pending.
>  
> -5. Issue pending DMA requests and wait for callback notification
> +5. Issue pending DMA requests and (optionally) request callback notification
>  
> -   The transactions in the pending queue can be activated by calling the
> -   issue_pending API. If channel is idle then the first transaction in
> -   queue is started and subsequent ones queued up.
> +   Dmaengine drivers accumulate submitted transactions on a pending queue.
> +   After this call all such pending transactions are activated. Transactions,
> +   submitted after this call will be queued again in a deactivated state until
> +   this function is called again. If at the time of this call the channel is
> +   idle then the first transaction in queue is started and subsequent ones are
> +   queued up.
>  
> -   On completion of each DMA operation, the next in queue is started and
> -   a tasklet triggered. The tasklet will then call the client driver
> -   completion callback routine for notification, if set.
> +   On completion of each DMA operation, the next active transaction in queue is
> +   started and the ISR bottom half, e.g. a tasklet or a kernel thread is
> +   triggered.

Or a kernel thread?  I don't think that's right.  It's always been
specified that the callback will happen from tasklet context.

> +   The dmaengine driver also has to check the DMA_CTRL_ACK flag by calling
> +   async_tx_test_ack() on the transaction. If the function returns true, i.e.
> +   if the transaction either has been flagged from the very beginning, or
> +   the user has flagged it later, then the transaction descriptor can be
> +   recycled immediately by the dmaengine driver.

"has to check" I think is wrong.  This is optional for slave only drivers,
because most slave stuff doesn't use the ACK stuff - that's more for the
async_tx APIs.

> If the function returns
> +   false, the descriptor cannot be recycled yet and the dmaengine driver has
> +   to keep polling the descriptor until it is acknowledged by the user.
>  
>     Interface:
>  	void dma_async_issue_pending(struct dma_chan *chan);
> @@ -171,6 +192,14 @@ Further APIs:
>     discard data in the DMA FIFO which hasn't been fully transferred.
>     No callback functions will be called for any incomplete transfers.
>  
> +   Note:
> +	Transactions, aborted by this call are considered as failed. However,
> +	if the user requests their status, using dma_async_is_complete() /
> +	dma_async_is_complete(), as described below, one of DMA_IN_PROGRESS and
> +	DMA_SUCCESS will be returned. So, drivers are advised not to use those
> +	calls on transactions, submitted before a call to
> +	dmaengine_terminate_all().

The last sentence doesn't make sense.
