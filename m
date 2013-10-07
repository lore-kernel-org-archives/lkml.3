Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3JGHkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 03:40:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63818 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab3JGHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 03:40:38 -0400
Date: Mon, 7 Oct 2013 09:40:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] DMA: extend documentation to provide more API details
In-Reply-To: <20131005233137.GA12758@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1310070900550.20796@axis700.grange>
References: <Pine.LNX.4.64.1310051925170.8097@axis700.grange>
 <20131005190200.GZ12758@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1310052203060.8097@axis700.grange>
 <20131005233137.GA12758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6MjJH3nu/cy6IuXhYCyKU63XEHW3cYKhuwJCocYQ2Qg
 db+DqrKpYpAzwRdA+htapv/B8fSv+irpPwga5eBZ/DUX8H3oud
 XfC2J3dMhZg73Pdoj0LjkUShSZFrsMj101XFUDLPIaGIx/yQtf
 2z+XUJtSk0tyq+SxJhEhQLEUaVIxEzwTDOuZjxKv+vxxsGVRFu
 d8QgS56cKUin8RAnk85UDo8IVWivBr3T0OTDheYUjNexJNe7oH
 U/U0TS8xoitJcqoVoQg3+PDzdc8URaLQJkZs+KSiSk3TwBesfZ
 3kGBcTHHqz/JEz74TLH5c+DlVCk8wi8JYj9d+55tq5jW/tWieo
 3EhfOND7BU+ef1CQqvxF60FBLrgZ/Bbxv4Dwa2oLi1jhTcH5XO
 FZDDMp4461IIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell

On Sun, 6 Oct 2013, Russell King - ARM Linux wrote:

> On Sat, Oct 05, 2013 at 11:00:45PM +0200, Guennadi Liakhovetski wrote:
> > On Sat, 5 Oct 2013, Russell King - ARM Linux wrote:
> > 
> > > On Sat, Oct 05, 2013 at 07:36:20PM +0200, Guennadi Liakhovetski wrote:
> > > > +	A DMA transaction descriptor, returned to the user by one of "prep"
> > > > +	methods is considered as belogning to the user until it is submitted
> > > > +	to the dmaengine driver for transfer. However, it is recommended, that
> > > > +	the dmaengine driver keeps references to prepared descriptors too,
> > > > +	because if dmaengine_terminate_all() is called at that time, the driver
> > > > +	will have to recycle all allocated descriptors for the respective
> > > > +	channel.
> > > 
> > > No.  That's quite dangerous.  think about what can happen.
> > > 
> > > Thread 1		Thread 2
> > > Driver calls prepare
> > > 			dmaengine_terminate_all()
> > > 				dmaengine driver frees prepared descriptor
> > > driver submits descriptor
> > > 
> > > You now have a descriptor which has been freed submitted to the DMA engine
> > > queue.  This will cause chaos.
> > 
> > Yes, I understand this. So, it is intentional, that after a *_prep_* a 
> > descriptor belongs to the user and - if the user fails - it will simply be 
> > leaked. A terminate-all shouldn't recycle them and dmaengine driver 
> > unbinding is impossible at that time, as long as the user hasn't released 
> > the channel. Ok, I can rework the above just to explain this.
> 
> "the user fails" should be very difficult.  One of the requirements here
> is that any "user" submits the prepared descriptor as soon as possible
> after preparation.  Some DMA engine implementations hold a spinlock
> between preparation and submission so this is absolutely necessary.

Ouch...

> As Dan Williams explained to me, the reason for the separate submission
> step is there to allow the callback information to be set.  So literally
> any "user" of this should do this:
> 
> 	desc = prepare();
> 	if (!desc)
> 		goto failed_to_prepare;
> 
> 	desc->callback = function;
> 	desc->callback_param = param;
> 	dmaengine_submit(desc);
> 
> There should be very little possiblity of the user failing between those
> two calls.

I see.

> > > > -   On completion of each DMA operation, the next in queue is started and
> > > > -   a tasklet triggered. The tasklet will then call the client driver
>           ^^^^^^^^^^^^^^^^^^^^
> > > > -   completion callback routine for notification, if set.
> > > > +   On completion of each DMA operation, the next active transaction in queue is
> > > > +   started and the ISR bottom half, e.g. a tasklet or a kernel thread is
> > > > +   triggered.
> > > 
> > > Or a kernel thread?  I don't think that's right.  It's always been
> > > specified that the callback will happen from tasklet context.
> > 
> > Do you see any problems using, say, a threaded interrupt handler, apart 
> > from possible performance issues? That seems to be pretty convenient. 
> > Otherwise we should really mandate somewhere, that bottom half processing 
> > should take place in a tasklet?
> 
> The documentation has always stated that callbacks will be made from
> tasklet context.  The problem with allowing different contexts from
> different drivers is taht spinlocking becomes problematical.  Remember
> that we have _bh() variants which lock against tasklets but allow IRQs.

Spinlocks are local to dmaengine drivers, and I currently see quite a few 
of them doing spin_lock_irq(save)() instead of _bh(). Some also take that 
lock in their ISR, like the pl330 does.

The disadvantage of using a threaded IRQ, that I see so far, is that you 
then can only wake up the thread from the ISR, not from other contexts, 
but even then it should be possible, at least for some designs.

> > > > +   The dmaengine driver also has to check the DMA_CTRL_ACK flag by calling
> > > > +   async_tx_test_ack() on the transaction. If the function returns true, i.e.
> > > > +   if the transaction either has been flagged from the very beginning, or
> > > > +   the user has flagged it later, then the transaction descriptor can be
> > > > +   recycled immediately by the dmaengine driver.
> > > 
> > > "has to check" I think is wrong.  This is optional for slave only drivers,
> > > because most slave stuff doesn't use the ACK stuff - that's more for the
> > > async_tx APIs.
> > 
> > "most," but some do? E.g. the mx3_camera driver. Ok, that one is very 
> > tightly bound to the respective dmaengine driver. But if there are other 
> > slave drivers, using that, that can run on different platforms and use 
> > various dmaengine drivers?
> 
> I'm not aware of any which actually make use of the ack stuff.  Only those
> which implement the async_tx must implement this because it gets used for
> chaining and dependency stuff.  However, there was a plan to remove this
> and replace it with proper refcounting.

Ok.

> > > > If the function returns
> > > > +   false, the descriptor cannot be recycled yet and the dmaengine driver has
> > > > +   to keep polling the descriptor until it is acknowledged by the user.
> > > >  
> > > >     Interface:
> > > >  	void dma_async_issue_pending(struct dma_chan *chan);
> > > > @@ -171,6 +192,14 @@ Further APIs:
> > > >     discard data in the DMA FIFO which hasn't been fully transferred.
> > > >     No callback functions will be called for any incomplete transfers.
> > > >  
> > > > +   Note:
> > > > +	Transactions, aborted by this call are considered as failed. However,
> > > > +	if the user requests their status, using dma_async_is_complete() /
> > > > +	dma_async_is_complete(), as described below, one of DMA_IN_PROGRESS and
> > > > +	DMA_SUCCESS will be returned. So, drivers are advised not to use those
> > > > +	calls on transactions, submitted before a call to
> > > > +	dmaengine_terminate_all().
> > > 
> > > The last sentence doesn't make sense.
> > 
> > Right, sorry, there is a typo in the second line (to remind: this note is 
> > for the dmaengine_terminate_all() function):
> > 
> > +   Note:
> > +	Transactions, aborted by this call are considered as failed. However,
> > +	if the user requests their status, using dma_async_is_tx_complete() /
> > +	dma_async_is_complete(), as described below, one of DMA_IN_PROGRESS and
> > +	DMA_SUCCESS will be returned. So, drivers are advised not to use those
> > +	calls on transactions, submitted before a call to
> > +	dmaengine_terminate_all().
> > 
> > What I was trying to say, is that if you submit transactions, then 
> > terminate them, then try to retrieve their status using 
> > dma_async_is_tx_complete() / dma_async_is_complete(), this won't produce 
> > the expected DMA_ERROR result, instead, one of DMA_IN_PROGRESS and 
> > DMA_SUCCESS will be returned, unless the driver implements some 
> > sophisticated .device_tx_status() method.
> 
> Remember that dmaengine_terminate_all() is targetted to a specific
> channel - it terminates all submitted transactions on that channel
> and stops any in-process transaction.  It doesn't affect any other
> channel on the controller.
> 
> In the case of slave DMA users, you have to "own" the channel.  This
> means it's up to the user to sort out what happens should _they_ call
> dmaengine_terminate_all() on it.
> 
> For non-slave DMA users, I don't believe that terminating transactions
> is permitted - they're expected to complete.

Ok, but the DMA error case remains, right? I.e. in case the dmaengine 
driver had to drop transactions due to a hardware problem, the client 
driver has no way to retrieve their status?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
