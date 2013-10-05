Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3JEVB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 17:01:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3JEVBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 17:01:25 -0400
Date: Sat, 5 Oct 2013 23:00:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] DMA: extend documentation to provide more API details
In-Reply-To: <20131005190200.GZ12758@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1310052203060.8097@axis700.grange>
References: <Pine.LNX.4.64.1310051925170.8097@axis700.grange>
 <20131005190200.GZ12758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:NBzMAvznLhY8sgLzxTFVal/uJNv2qTk+jNob7GCUEFe
 wgq2Uo03JlcRc5ZLgiF3Vy8q2sHS5M8zpKuhp5D+B7JLyka6Ra
 oCy30NjhIA/sV/8zzpaIwpV4o8in6VRzD3gFPri1NornLG3ge2
 v59nV6BRsnFac8z0TbJ0dnzOz3orVe9fqo6qs3a0H6eumTaJSZ
 VpsZYS2IvF3UjCUj7p2/wbGNu94Msoyg6DcAksAu1v9PTR7S/V
 U8l6wEfqI8Ny8BUqfxAYRHRpPYc/t/REKZSxiFNf9UTICg162f
 wugok02otVFSVIvfJZgn51WCg/mEIKQBiCXU1R34+NL1+G0VeG
 rODr+MoEOPpoPMLY45BrBSfQt86jnw2hVzGqbjBgV57fsuWz75
 B82bdKNeq8InA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Thanks for explanations.

On Sat, 5 Oct 2013, Russell King - ARM Linux wrote:

> On Sat, Oct 05, 2013 at 07:36:20PM +0200, Guennadi Liakhovetski wrote:
> > This patch extends dmaengine documentation to provide more details
> > on descriptor prepare stage, transaction completion requirements
> > and DMA error processing.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > These extensions reflect my understanding of some aspects of the dmaengine 
> > API. If it is wrong, I'd be happy if someone could correct me. If or where 
> > I'm right, I think, those aspects might want an update. Once we understand 
> > exactly the situation we can think about improvements to the API.
> > 
> >  Documentation/dmaengine.txt |   58 ++++++++++++++++++++++++++++++++++++------
> >  1 files changed, 49 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
> > index 879b6e3..21bb72d 100644
> > --- a/Documentation/dmaengine.txt
> > +++ b/Documentation/dmaengine.txt
> > @@ -133,8 +133,17 @@ The slave DMA usage consists of following steps:
> >  	locks before calling the callback function which may cause a
> >  	deadlock.
> >  
> > -	Note that callbacks will always be invoked from the DMA
> > -	engines tasklet, never from interrupt context.
> > +	Note that callbacks will always be invoked from the DMA engine's
> > +	interrupt processing bottom half, never from interrupt context.
> > +
> > +   Note 2:
> > +	A DMA transaction descriptor, returned to the user by one of "prep"
> > +	methods is considered as belogning to the user until it is submitted
> > +	to the dmaengine driver for transfer. However, it is recommended, that
> > +	the dmaengine driver keeps references to prepared descriptors too,
> > +	because if dmaengine_terminate_all() is called at that time, the driver
> > +	will have to recycle all allocated descriptors for the respective
> > +	channel.
> 
> No.  That's quite dangerous.  think about what can happen.
> 
> Thread 1		Thread 2
> Driver calls prepare
> 			dmaengine_terminate_all()
> 				dmaengine driver frees prepared descriptor
> driver submits descriptor
> 
> You now have a descriptor which has been freed submitted to the DMA engine
> queue.  This will cause chaos.

Yes, I understand this. So, it is intentional, that after a *_prep_* a 
descriptor belongs to the user and - if the user fails - it will simply be 
leaked. A terminate-all shouldn't recycle them and dmaengine driver 
unbinding is impossible at that time, as long as the user hasn't released 
the channel. Ok, I can rework the above just to explain this.

> >  4. Submit the transaction
> >  
> > @@ -150,15 +159,27 @@ The slave DMA usage consists of following steps:
> >     dmaengine_submit() will not start the DMA operation, it merely adds
> >     it to the pending queue.  For this, see step 5, dma_async_issue_pending.
> >  
> > -5. Issue pending DMA requests and wait for callback notification
> > +5. Issue pending DMA requests and (optionally) request callback notification
> >  
> > -   The transactions in the pending queue can be activated by calling the
> > -   issue_pending API. If channel is idle then the first transaction in
> > -   queue is started and subsequent ones queued up.
> > +   Dmaengine drivers accumulate submitted transactions on a pending queue.
> > +   After this call all such pending transactions are activated. Transactions,
> > +   submitted after this call will be queued again in a deactivated state until
> > +   this function is called again. If at the time of this call the channel is
> > +   idle then the first transaction in queue is started and subsequent ones are
> > +   queued up.
> >  
> > -   On completion of each DMA operation, the next in queue is started and
> > -   a tasklet triggered. The tasklet will then call the client driver
> > -   completion callback routine for notification, if set.
> > +   On completion of each DMA operation, the next active transaction in queue is
> > +   started and the ISR bottom half, e.g. a tasklet or a kernel thread is
> > +   triggered.
> 
> Or a kernel thread?  I don't think that's right.  It's always been
> specified that the callback will happen from tasklet context.

Do you see any problems using, say, a threaded interrupt handler, apart 
from possible performance issues? That seems to be pretty convenient. 
Otherwise we should really mandate somewhere, that bottom half processing 
should take place in a tasklet?

> > +   The dmaengine driver also has to check the DMA_CTRL_ACK flag by calling
> > +   async_tx_test_ack() on the transaction. If the function returns true, i.e.
> > +   if the transaction either has been flagged from the very beginning, or
> > +   the user has flagged it later, then the transaction descriptor can be
> > +   recycled immediately by the dmaengine driver.
> 
> "has to check" I think is wrong.  This is optional for slave only drivers,
> because most slave stuff doesn't use the ACK stuff - that's more for the
> async_tx APIs.

"most," but some do? E.g. the mx3_camera driver. Ok, that one is very 
tightly bound to the respective dmaengine driver. But if there are other 
slave drivers, using that, that can run on different platforms and use 
various dmaengine drivers?

> > If the function returns
> > +   false, the descriptor cannot be recycled yet and the dmaengine driver has
> > +   to keep polling the descriptor until it is acknowledged by the user.
> >  
> >     Interface:
> >  	void dma_async_issue_pending(struct dma_chan *chan);
> > @@ -171,6 +192,14 @@ Further APIs:
> >     discard data in the DMA FIFO which hasn't been fully transferred.
> >     No callback functions will be called for any incomplete transfers.
> >  
> > +   Note:
> > +	Transactions, aborted by this call are considered as failed. However,
> > +	if the user requests their status, using dma_async_is_complete() /
> > +	dma_async_is_complete(), as described below, one of DMA_IN_PROGRESS and
> > +	DMA_SUCCESS will be returned. So, drivers are advised not to use those
> > +	calls on transactions, submitted before a call to
> > +	dmaengine_terminate_all().
> 
> The last sentence doesn't make sense.

Right, sorry, there is a typo in the second line (to remind: this note is 
for the dmaengine_terminate_all() function):

+   Note:
+	Transactions, aborted by this call are considered as failed. However,
+	if the user requests their status, using dma_async_is_tx_complete() /
+	dma_async_is_complete(), as described below, one of DMA_IN_PROGRESS and
+	DMA_SUCCESS will be returned. So, drivers are advised not to use those
+	calls on transactions, submitted before a call to
+	dmaengine_terminate_all().

What I was trying to say, is that if you submit transactions, then 
terminate them, then try to retrieve their status using 
dma_async_is_tx_complete() / dma_async_is_complete(), this won't produce 
the expected DMA_ERROR result, instead, one of DMA_IN_PROGRESS and 
DMA_SUCCESS will be returned, unless the driver implements some 
sophisticated .device_tx_status() method. As explained further in the 
patch, this is similar and even more damaging in case of DMA errors. The 
dmaengine driver has to silently drop queued and active transactions and 
users can only use a timeout to verify, whether transactions succeeded.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
