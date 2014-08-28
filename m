Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaH1ThP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:37:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:42580 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaH1ThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:37:10 -0400
Message-ID: <53FF84DF.7080406@linutronix.de>
Date: Thu, 28 Aug 2014 21:37:03 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <1408124563-31541-16-git-send-email-bigeasy@linutronix.de> <20140815210211.GD9239@atomide.com> <53F5AF0D.5060409@linutronix.de> <20140821184416.GF10066@atomide.com> <53FE3779.5090908@linutronix.de> <20140827202313.GF16006@atomide.com> <20140828082348.GA5413@linutronix.de> <20140828164645.GG16006@atomide.com>
In-Reply-To: <20140828164645.GG16006@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 06:46 PM, Tony Lindgren wrote:
>> To use DMA you don't have to enable it in SCR register you can also use
>> the FCR register. The manual says that you can only write this DMA
>> enable bit in the FCR register if the baud clock is not running. And
>> guess what: same thing: I only *toggle* the DMA enable bit here (it
>> remains 0 later) and the core won't hit idle.
>> Same effect if I toggle this bit while the baud clock is running (the
>> manual says that this bit can only be written if the baud clock is not
>> running). Seems like the UART is following its own specification and it
>> remains blocking once the DMA was enabled.
>> It would be nice if someone from the UART-IP team could ACK this.
> 
> Sounds like there should be some way to clear that state.. I wonder
> if omap-serial.c had something before it's DMA support was removed?

Its DMA was removed? Like there was DMA support?

> I'd assume when the UART is powered down by runtime PM it's state
> is completetely reset and we could restore the non-DMA state?

I tried that by canceling the RX-DMA request and removing the DMA-enable
bits from UART but it didn't help. Then I noticed that once that DMA en
bit is set, the UART won't do any idle.

> Maybe post your current patches and a test patch to try to toggle
> the DMA on and off?

Oh. I pushed my dirty tree to
 git://git.breakpoint.cc/bigeasy/linux.git uart_v8_wip

The top most commit does not setup dma at all and adds commented out
code how to enable DMA via SCR or FCR register. With this I hit
core-off. Once _one_ of the modes are enabled, it doesn't work anymore.

I will try to address review comments tomorrow and hopefully post a v8
based on -rc2. The same goes for your patch (which I will try tomorrow).

>> Bah. Does it make sense to use runtime-PM if we can't hit core-off? I'm
>> thinking to add a printk once dma is enabled says that runtime-pm is
>> switched off.
> 
> Well if we can't find a way to unset the DMA registers in the UART,
> how about only enable it if a kernel cmdline option is specified?

Hmmm. So removing DMA properties from DT is not an option? Currently I
added a message that DMA might forbid low power mode so people might
remove "dma-names" from DT (or assign "") and DMA is off. However if
this is no good, then I guess I could add kernel module which enables
DMA.

> 
> We do have runtime PM working without it, and the serial console
> super important for any kind of debugging no matter what idle
> mode the SoC hits.. So let's not break that.

Yeah, I know. I've been debugging while I broke something which means
uart wasn't working :)

> 
> Regards,
> 
> Tony

Sebastian
