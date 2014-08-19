Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaHSP1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:27:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:11197 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaHSP1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:27:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="586949270"
Date: Tue, 19 Aug 2014 20:42:16 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Joel Fernandes <joelf@ti.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/7] dmaengine: edma: fix two faults which happen with
 the 8250_dma user
Message-ID: <20140819151216.GO13288@intel.com>
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
 <1406660344-25307-2-git-send-email-bigeasy@linutronix.de>
 <20140731121702.GU8181@intel.com>
 <20140808162950.GA12080@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140808162950.GA12080@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 06:29:50PM +0200, Sebastian Andrzej Siewior wrote:
> * Vinod Koul | 2014-07-31 17:47:02 [+0530]:
> 
> >On Tue, Jul 29, 2014 at 08:58:58PM +0200, Sebastian Andrzej Siewior wrote:
> >> The rx path of the 8250_dma user in the RX-timeout case:
> >> - it starts the RX transfer
> >> - if the rx-timeout interrupt occures, it dmaengine_pause() the transfer
> >> - step two is dmaengine_terminate_all() on this channel.
> >Okay after this whole channel needs to be reset, which means all the
> >descriptors are discared.
> 
> >> To make the upper case work better, this patch adds dma_cookie_complete()
> >> to complete the cookie. Also it adds is an additional check for echan->edesc
> >> in case the channel has no descriptor assigned.
> >I think we are fixing the behvaiour rather than cause. terminate_all(()
> >needs to do a proper cleanup of the channel
> 
> In case you are not ignoring me but $reason here is an example that does
> not work (with both drivers);
Sorry This seems to have slipped thru, wasn't intentional!
> 
>     desc = dmaengine_prep_slave_single(rxchan, …);
>     rx_cookie = dmaengine_submit(desc);
>     dma_async_issue_pending(rxchan);
> 
>     ssleep(2);
>     /* Now assume that the transfer did not start */
>     st = dmaengine_tx_status(rxchan, rx_cookie, NULL);
>     /* st is now DMA_IN_PROGRESS as expected */
> 
>     dmaengine_terminate_all(rxchan);
>     st = dmaengine_tx_status(rxchan, rx_cookie, NULL);
and here is the culprit. You have terminated the channel. This means that
dmaengine driver is free to clean up all the allocated descriptors on the
channels and do whatever it decides to do with them.

You have already terminated the channel so what is the point in querying the
status of the cookie, which you shouldn't use anyway after invoking
terminate_all() as its result is not correct.

>     /* st is still DMA_IN_PROGRESS but _I_ expect DMA_COMPLETE because
>      * it has been terminated / canceled
>      */
> 
> Both dma driver clean up all / terminate all descriptors as required but
> _none_ of them completes the cookie. As a result dma_cookie_status()
> still thinks that the transfer is in progress.

Btw how does it matter in the driver here if the transaction completed or
not after terminate_all() was invoked. What is the purpose of querying
status.

Thanks
-- 
~Vinod
