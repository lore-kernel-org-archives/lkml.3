Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbbAVNCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:02:32 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63660 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAVNCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:02:31 -0500
Message-ID: <54C0F4E4.5080505@hurleysoftware.com>
Date: Thu, 22 Jan 2015 08:02:28 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Dick Hollenbeck <dick@softplc.com>
CC: linux-kernel@vger.kernel.org,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Frans Klaver <fransklaver@gmail.com>
Subject: Re: [PATCH 1/1] 8250_core.c
References: <54C09112.4010306@softplc.com>
In-Reply-To: <54C09112.4010306@softplc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc linux-serial, Greg, Frans ]

Hi Dick,

On 01/22/2015 12:56 AM, Dick Hollenbeck wrote:
> This was generated from 3.14 kernel, but since its so small it will likely apply to newer
> kernels without issue.

Thanks for finding this.

In addition to Frans' comments, I've expanded the patch inline for further
comment (which is why attached patches are of limited value).

> A lesser travelled code path specifically crafted for "tx interrupt buggy"
> UARTs seems to be testing the wrong bit for whether or not to prime the
> transmit pump.  The result is that the tx interrupt never occurs on one chip
> I am using that falls into the UART_BUG_TXEN category as I understand it.

What UART is this?

> The 16550 data sheet even names the interrupt "THRE" and not transmit
> shift register empty.  The interrupt is fired when the holding register, or its
> logical equivalent, the fifo, goes empty;  not when the shift register goes
> empty.

Please include a description of why this test is broken. For example,

"So, if the fifo is already empty but the shifter is still transmitting,
no further THRE interrupt will occur, and tx will stall."

The remainder of the commit message can be dropped (except Signed-off-by).

>  This is a code bug in code hoping to fix a bug in hardware.
> 
> The reason this is so late coming to the surface is that lately the 8250
> interrupt handler polls for all kinds of special status beyond the intention
> of the hardware's purpose specific interrupt. Therefore so long as you
> were in the interrupt handler (even if for purposes of servicing a recv
> interrupt, you could recover from the broken transmit chain.  But if you are
> only transmitting, not receiving, then this bug can manifest itself.
> 
> This is the fix.  It is harmless because so long as the fifo is empty, it
> should be legal to re-fill it fully anyways.
> 
> Signed-off-by: Dick Hollenbeck <dick@softplc.com>
> 
> === modified file 'drivers/tty/serial/8250/8250_core.c'
> --- old/drivers/tty/serial/8250/8250_core.c	2014-07-14 18:39:13 +0000
> +++ new/drivers/tty/serial/8250/8250_core.c	2015-01-22 05:28:33 +0000
> @@ -1302,11 +1302,15 @@ static void serial8250_start_tx(struct u
> 		up->ier |= UART_IER_THRI;
> 		serial_port_out(port, UART_IER, up->ier);
> 
> +		/*
> +		 * If setting UART_IER_THRI does not cause an
> +		 * immediate tx interrupt
> +		 */

Please make this comment one line? Eg.,

		/* Prime tx pump for buggy UARTs */

> 		if (up->bugs & UART_BUG_TXEN) {
> 			unsigned char lsr;
> 			lsr = serial_in(up, UART_LSR);
> 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
> -			if (lsr & UART_LSR_TEMT)
> +			if (lsr & UART_LSR_THRE)
> 				serial8250_tx_chars(up);
> 		}
> 	}

Regards,
Peter Hurley
 

