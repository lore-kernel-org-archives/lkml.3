Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaHUNJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:09:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:57941 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaHUNJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:09:20 -0400
Message-ID: <53F5EF78.2050800@linutronix.de>
Date: Thu, 21 Aug 2014 15:09:12 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Joel Fernandes <joelf@ti.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/7] dmaengine: edma: fix two faults which happen with
 the 8250_dma user
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de> <1406660344-25307-2-git-send-email-bigeasy@linutronix.de> <20140731121702.GU8181@intel.com> <20140808162950.GA12080@linutronix.de> <20140819151216.GO13288@intel.com>
In-Reply-To: <20140819151216.GO13288@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 05:12 PM, Vinod Koul wrote:
>>
>>     desc = dmaengine_prep_slave_single(rxchan, …);
>>     rx_cookie = dmaengine_submit(desc);
>>     dma_async_issue_pending(rxchan);
>>
>>     ssleep(2);
>>     /* Now assume that the transfer did not start */
>>     st = dmaengine_tx_status(rxchan, rx_cookie, NULL);
>>     /* st is now DMA_IN_PROGRESS as expected */
>>
>>     dmaengine_terminate_all(rxchan);
>>     st = dmaengine_tx_status(rxchan, rx_cookie, NULL);
> and here is the culprit. You have terminated the channel. This means that
> dmaengine driver is free to clean up all the allocated descriptors on the
> channels and do whatever it decides to do with them.

descriptors, yes.

> You have already terminated the channel so what is the point in querying the
> status of the cookie, which you shouldn't use anyway after invoking
> terminate_all() as its result is not correct.

The point is to check (later, after terminate_all()) if there is an
outstanding DMA transfer or not _and_ how much data was really
transfered. Looking at edma it does not really support the latter if
the transfer is already completed. On the plus side the HW does not
support partly transfers :)

But where is it written that the life time of the cookie is limited?
Looking at the "cooking check" code there is no such thing. It is
simply compare of completed vs passed number but okay, this is an
implementation detail.
>From [0] it says under "4. Submit the transaction":

| This returns a cookie can be used to check the progress of DMA engine
| activity via other DMA engine calls not covered in this document.

no life time limit mentioned here. Which brings to the question: Why is
it okay to use the cookie after the transaction "terminated" normally
but not if it has been canceled?

And from [0] the API explanation  "4. … dma_async_is_tx_complete()":

|Note:
|    Not all DMA engine drivers can return reliable information for
|    a running DMA channel.  It is recommended that DMA engine users
|    pause or stop (via dmaengine_terminate_all) the channel before
|    using this API.

So the documentation says to use the cookie with
dma_async_is_tx_complete() and before doing so it is recommended that
the transfer should be paused or stopped. _Exactly_ what is done here.

>>     /* st is still DMA_IN_PROGRESS but _I_ expect DMA_COMPLETE because
>>      * it has been terminated / canceled
>>      */
>>
>> Both dma driver clean up all / terminate all descriptors as required but
>> _none_ of them completes the cookie. As a result dma_cookie_status()
>> still thinks that the transfer is in progress.
> 
> Btw how does it matter in the driver here if the transaction completed or
> not after terminate_all() was invoked. What is the purpose of querying
> status.

In the RX interrupt (of the 8250 unit), the code checks if the transfer
has been already started or not via querying the status. So if it
returns DMA_COMPLETE then a new transfer will be started. If it returns
DMA_IN_PROGRESS then the code returns doing nothing because the DMA
engine should start moving data anytime now so the RX interrupt goes
away.

That means: If the transfer is canceled then it won't be started again.

Btw: the current (probably only) dma driver that is used by 8250-dma is
dw/core.c. That one does cookie complete on terminate:
 dwc_control(DMA_TERMINATE_ALL) -> dwc_descriptor_complete() ->
 dma_cookie_complete().

That is why it works for them…

[0] Documentation/dmaengine.txt

> 
> Thanks
> 

Sebastian
