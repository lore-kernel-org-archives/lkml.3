Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbaHHQaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:30:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:54033 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbaHHQaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:30:02 -0400
Date: Fri, 8 Aug 2014 18:29:50 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Joel Fernandes <joelf@ti.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/7] dmaengine: edma: fix two faults which happen with
 the 8250_dma user
Message-ID: <20140808162950.GA12080@linutronix.de>
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
 <1406660344-25307-2-git-send-email-bigeasy@linutronix.de>
 <20140731121702.GU8181@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140731121702.GU8181@intel.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vinod Koul | 2014-07-31 17:47:02 [+0530]:

>On Tue, Jul 29, 2014 at 08:58:58PM +0200, Sebastian Andrzej Siewior wrote:
>> The rx path of the 8250_dma user in the RX-timeout case:
>> - it starts the RX transfer
>> - if the rx-timeout interrupt occures, it dmaengine_pause() the transfer
>> - step two is dmaengine_terminate_all() on this channel.
>Okay after this whole channel needs to be reset, which means all the
>descriptors are discared.

>> To make the upper case work better, this patch adds dma_cookie_complete()
>> to complete the cookie. Also it adds is an additional check for echan->edesc
>> in case the channel has no descriptor assigned.
>I think we are fixing the behvaiour rather than cause. terminate_all(()
>needs to do a proper cleanup of the channel

In case you are not ignoring me but $reason here is an example that does
not work (with both drivers);

    desc = dmaengine_prep_slave_single(rxchan, …);
    rx_cookie = dmaengine_submit(desc);
    dma_async_issue_pending(rxchan);

    ssleep(2);
    /* Now assume that the transfer did not start */
    st = dmaengine_tx_status(rxchan, rx_cookie, NULL);
    /* st is now DMA_IN_PROGRESS as expected */

    dmaengine_terminate_all(rxchan);
    st = dmaengine_tx_status(rxchan, rx_cookie, NULL);
    /* st is still DMA_IN_PROGRESS but _I_ expect DMA_COMPLETE because
     * it has been terminated / canceled
     */

Both dma driver clean up all / terminate all descriptors as required but
_none_ of them completes the cookie. As a result dma_cookie_status()
still thinks that the transfer is in progress.

Sebastian
