Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbaIKMvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:51:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:39845 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaIKMu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:50:58 -0400
Message-ID: <54119AAA.9080907@linutronix.de>
Date: Thu, 11 Sep 2014 14:50:50 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com>
In-Reply-To: <5411967A.6090406@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 02:32 PM, Peter Hurley wrote:
> On 09/11/2014 07:42 AM, Sebastian Andrzej Siewior wrote:
>> I also need a watchdog timer for TX since it seems that on omap3 the
>> DMA engine suddenly forgets to continue with DMA…
> 
> One difference I noticed between the omap driver and the 8250 driver is
> the way modem status interrupts are handled.
> 
> The omap driver only checks modem status for the UART_IIR_MSI interrupt type.
> The 8250 driver checks modem status at every interrupt (other than NO_INT).
> 
> I think the UART_MSR_DCTS bit always reflects that the CTS input has changed
> between reads of the MSR _even if auto CTS is on_. So perhaps the hardware
> is being stopped by uart_handle_cts_change() when auto CTS is on?

I doubt that. What I see from a timer debug is that the TX-FIFO level
is at 0, the DMA transfer for say 1024 bytes start.
The FIFO is filled to 64bytes and refilled so it doesn't drop below 50.
At the time of the stall I see that the DMA engine has outstanding
bytes which it should transfer and the TX FIFO is empty. If hardware
flow control stops the transfer, I would expect that the DMA engine
still fills the TX-FIFO until 64 and then waits. But it doesn't.
Writing bytes into the FIFO leads to bytes beeing sent (and I see them
on the other side) but the DMA transfer is still on hold. Canceling the
DMA transfer and re-programming the remaining bytes transfers the
remaining bytes.

The odd thing is that I only triggered it with "less file". It doesn't
happen on regular console interaction or "cat large-file". And it only
triggers on beagle board xm (omap34xx) and I wasn't able to reproduce
it on am335x or dra7. The latter shares the same DMA engine as beagle
board xm.

I remember also that I disabled the HW/SW float control just to make
sure it is not it.

> 
> Regards,
> Peter Hurley
> 
> [The UPF_HARD_FLOW thing was pretty much just done for omap even though
> 8250 already had auto CTS/auto RTS. Serial core hardware flow control support
> needs a redo as drivers have pretty much tacked stuff on randomly.]

Sebastian
