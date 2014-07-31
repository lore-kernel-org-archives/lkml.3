Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbaGaNG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:06:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:33636 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGaNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:06:55 -0400
Message-ID: <53DA3F69.4000803@linutronix.de>
Date: Thu, 31 Jul 2014 15:06:49 +0200
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
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de> <1406660344-25307-2-git-send-email-bigeasy@linutronix.de> <20140731121702.GU8181@intel.com>
In-Reply-To: <20140731121702.GU8181@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 02:17 PM, Vinod Koul wrote:
> On Tue, Jul 29, 2014 at 08:58:58PM +0200, Sebastian Andrzej Siewior wrote:
>> The rx path of the 8250_dma user in the RX-timeout case:
>> - it starts the RX transfer
>> - if the rx-timeout interrupt occures, it dmaengine_pause() the transfer
>> - step two is dmaengine_terminate_all() on this channel.
> Okay after this whole channel needs to be reset, which means all the
> descriptors are discared.
>> - based on dmaengine_tx_status() it learns the number of transfered
>>   bytes.
>> - the rx interrupt occures,
> why, channel is terminated, so existing txn needs to be aborted too

serial8250_rx_dma() is invoked on 8250' RX interrupt to move all the
data from the FIFO to memory. This is when the dma transfer is
programmed (on all platforms but omap because we need to program it
before the data is in the FIFO but this detail shouldn't matter).

On Omap (atleast) it happens that if there are not enough characters in
the FIFO over a given time the UART triggers a RX-timeout and no bytes
are moved by the DMA engine. This is when UART_IIR_RX_TIMEOUT is hit.
At that point it invokes the completion hanlder
(__dma_rx_do_complete()) to learn how much bytes were transfered and to
cancel the transfer (so the remaining bytes can be fetched via PIO).

>>   it does not start the RX-transfer because
>>   according to dmaengine_tx_status() the status of the current transfer
>>   is still DMA_IN_PROGRESS because the earlier dmaengine_terminate_all()
>>   did not reset this.
> there is no current transfer anymore

That is correct but since we never completed that cookie,
dmaengine_tx_status() returns DMA_IN_PROGRESS and the 8250_dma does no
book keeping of its own.

>> - on rx-timeout it invokes dmaengine_pause() again. This time, it
>>   segfaults because the channel has no descriptor yet.
>>
>> To make the upper case work better, this patch adds dma_cookie_complete()
>> to complete the cookie. Also it adds is an additional check for echan->edesc
>> in case the channel has no descriptor assigned.
> I think we are fixing the behvaiour rather than cause. terminate_all(()
> needs to do a proper cleanup of the channel

The channel is clean an can be reused. Since the cookie has never been
completed / incremented, serial8250_rx_dma() never enqueues another
transfer.

Are you suggesting that the 8250_dma driver should have its own book
keeping whether it started a transfer or not?

Either way, it looks wrong that dmaengine_tx_status() reports
DMA_IN_PROGRESS even that the transfer got aborted and the channel is
properly cleaned up.

> And this looks a series, without cover letter sent to all. Which makes it a
> bit hard to see what is getting done

What is getting done, is getting 8250_dma used on omap after the 8250
based driver is used for uart. The UART is mostly the same on am335x
(where edma is used) as on DRA7 (where omap-dma is used) that is why I
made the two patches for the two dma engines. The cover letter is at
[1]. I tried to cover the problem and all informations in the patch
description so you have all the required informations.

[0] drivers/tty/serial/8250/8250_dma.c
[1] https://lkml.org/lkml/2014/7/29/513

Sebastian
