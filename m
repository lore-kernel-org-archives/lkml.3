Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbaGRIfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:35:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:46087 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGRIfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:35:18 -0400
Message-ID: <53C8DC3E.3020701@linutronix.de>
Date: Fri, 18 Jul 2014 10:35:10 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Peter Hurley <peter@hurleysoftware.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de> <1405521903-5877-5-git-send-email-bigeasy@linutronix.de> <20140716151604.GG1365@saruman.home> <53C6A050.2050409@linutronix.de> <20140716160614.GI1365@saruman.home> <53C7EC6F.6060902@hurleysoftware.com> <20140717154300.GA16623@linutronix.de> <20140717160206.GI10459@saruman.home> <53C7F4A3.5080508@linutronix.de> <20140717161848.GK10459@saruman.home>
In-Reply-To: <20140717161848.GK10459@saruman.home>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 06:18 PM, Felipe Balbi wrote:

>> No, this is okay. If you look, it checks for "up->ier & 
>> UART_IER_THRI". On the second invocation it will see that this
>> bit is already set and therefore won't call get_sync() for the
>> second time. That bit is removed in the _stop_tx() path.
> 
> oh, right. But that's actually unnecessary. Calling
> pm_runtime_get() multiple times will just increment the usage
> counter multiple times, which means you can call __stop_tx()
> multiple times too and everything gets balanced, right ?

No. start_tx() will be called multiple times but only the first
invocation invoke pm_runtime_get(). Now I noticed that I forgot to
remove pm_runtime_put_autosuspend() at the bottom of it. But you get
the idea right?
pm_get() on the while the UART_IER_THRI is not yet set. pm_put() once
the fifo is completely empty.

>> Do you have other ideas? It doesn't look like this is exported at
>> all. If we call _stop_tx() right away, then we have 64 bytes in
>> the TX fifo in the worst case. They should be gone "soon" but the
>> HW-flow control may delay it (in theory for a long time)).
> 
> this can be problematic, specially for OMAP which can go into OFF
> while idle. Whatever is in the FIFO would get lost. It seems like
> omap-serial solved this within transmit_chars().

No, it didn't.

> See how transmit_chars() is called from within IRQ handler with
> clocks enabled then it conditionally calls serial_omap_stop_tx()
> which will pm_runtime_get_sync() -> do_the_harlem_shake() -> 
> pm_runtime_put_autosuspend(). That leaves one unbalanced 
> pm_runtime_get() which is balanced when we're exitting the IRQ
> handler.

omap-serial and the 8250 do the following on tx path:
- start_tx()
  -> sets UART_IER_THRI. This will generate an interrupt once the FIFO
     is empty.
- interrupt, notices the empty fifo, invokes serial8250_start_tx()/
  transmit_chars().
  Both have a while loop that fills the FIFO. This loop is left once
  the tty-buffer is empty (uart_circ_empty() is true) or the FIFO full.

Lets say you filled 64 bytes into the FIFO and then left because your
FIFO is full and tty-buffer is empty. That means you will invoke
serial_omap_stop_tx() and remove UART_IER_THRI bit.
This is okay because you are not interested in further FIFO empty
interrupts because you don't have any TX-bytes to be sent. However,
once you leave the transmit_chars() you leave serial_omap_irq() which
does the last pm_put(). That means you have data in the TX FIFO that is
about to be sent and the device is in auto-suspend.
This is "fine" as long as the timeout is greater then the time required
for the data be sent (plus assuming HW-float control does not stall it
for too long) so nobody notices a thing.

For that reason I added the hack / #if0 block in the 8250 driver. To
ensure we do not disable the TX-FIFO-empty interrupt even if there is
nothing to send. Instead we enter serial8250_tx_chars() once again with
empty FIFO and empty tty-buffer and will invoke _stop_tx() which also
finally does the pm_put().
That is the plan. The problem I have is how to figure out that the
device is using auto-suspend. If I don't then I would have to remove
the #if0 block and that would mean for everybody an extra interrupt
(which I wanted to avoid).

> This seems work fine and dandy without DMA, but for DMA work, I
> think we need to make sure this IP stays powered until we get DMA
> completion callback. But that's future, I guess.

Yes, probably. That means one get at dma start, one put at dma complete
callback. And I assume we get that callbacks once the DMA transfer is
complete, not when the FIFO is empty :) So lets leave it to the future
for now…

Sebastian
