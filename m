Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3AKSeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:34:23 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:60151 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3AKSeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:34:22 -0500
MIME-Version: 1.0
In-Reply-To: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Fri, 11 Jan 2013 19:34:21 +0100
Message-ID: <CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
Subject: Re: [PATCH] ARM: PL011: Add support for Rx DMA buffer polling
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 7:13 AM, Chanho Min <chanho.min@lge.com> wrote:

> In DMA support, Received data is not triggered until the DMA buffer is filled.

Interesting! As you can see in commits:

commit ead76f329f777c7301e0a5456a0a1c7a081570bd
"ARM: 6763/1: pl011: add optional RX DMA to PL011 v2"

commit 5d7b8467e18b14ed44c5781d77993bfdcd8c826b
"mach-ux500: config Ux500 PL011 PL022 PL180 for DMA"

commit ec8f12533b4a439a8feb0d1a3bf15516781804be
"mach-u300: config U300 PL180 PL011 PL022 for DMA"

We have enabled RX DMA for Ux500 and U300.
It does work on our machines, I'm using it every day
and deploying the ux500 systems in the millions.

Let's recap how this can work for us. As you can see, when
using DMA we turn off UART011_RXIM and instead rely on
either:

1) DMA completes and we read in the entire buffer to
 the TTY

or

2) UART011_RTIM (recieve timeout) to happen. This is a
 timeout that need to be set low enough so that interactivity
 on a console will not be hampered.

Apparently this timeout cannot be configured on the ARM
variants while the ST variant has a register for that (which
is currently unused.)

The amazing thing is that we're using this. We're getting
timeouts, so the small set of characters in the FIFO on
an interactive console is polled perfectly.

This even works on the U300, which has the ARM version
of the PL011 and I have once tested it on the RealView
PB11MPcore (the only reference design with a working
PL08x DMA controller) and it worked on that system
as well.

As we've discussed before, in order for this to work,
the PL011 refman says:

----------8<------------------8<-----------------
UARTRXDMASREQ
Single character DMA transfer request, asserted by the UART.
For receive, one character consists of up to 12 bits. This signal
is asserted when the receive FIFO contains at least one character.

UARTRXDMABREQ
Burst DMA transfer request, asserted by the UART. This
signal is asserted when the receive FIFO contains more
characters than the programmed watermark level. You can
program the watermark level for each FIFO through the
UARTIFLS register.

UARTRXDMACLR
DMA request clear, asserted by the DMA controller to clear
the receive request signals. If DMA burst transfer is
requested, the clear signal is asserted during the transfer of
the last data in the burst.
----------8<------------------8<-----------------

We were worried that DMA would suck out characters
of the FIFO so quickly that it would never contain the
one character necessary to trigger the timeout, so that
we would read out the data from the DMA page, due
to this part of the refman:

----------8<------------------8<-----------------
UARTRTINTR
The receive timeout interrupt is asserted when the receive FIFO is
not empty, and no further data is received over a 32-bit period. The
receive timeout interrupt is cleared either when the FIFO becomes
empty through reading all the data (or by reading the holding register),
or when a 1 is written to the corresponding bit of the UARTICR
register.
----------8<------------------8<-----------------

The crucial part is "FIFO is not empty" - when using DMA
the FIFO will of course be empty, as DMA is sucking out
anything immediately. See this discussion:
http://comments.gmane.org/gmane.linux.ports.arm.kernel/92513

But when I tried it out in practice, it must be
wired differently or contain some VHDL hacks, because it
worked like a charm. I got the timeout IRQs and all. I never
managed to get it to fail. Sadly I don't have the VHDL code
for the PL011 so I cannot confirm how they (ARMs
IP core engineers) solved this. (Paging Pawel on this.)

So I suspect that maybe your DMA controller is badly
configured, or erroneous, atleast if this is a stock PL011:

- What DMA controller are you using with the
  PL011?

- How are the burst lines configured in the DMA
  controller? (This is often a platform-specific
  property.) Did you make sure both single and burst
  request lines are enabled? If only burst is enabled
  you will get *exactly* the phenomena you are trying
  to work around above...

- If they cannot be software-configured, how are
  they then configured in hardware? Burst-only?

Yours,
Linus Walleij
