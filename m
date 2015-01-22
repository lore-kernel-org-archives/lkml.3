Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbbAVGBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:01:43 -0500
Received: from mail.softplc.com ([205.238.213.17]:45362 "EHLO mail.softplc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbAVGBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:01:36 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 01:01:36 EST
Message-ID: <54C09112.4010306@softplc.com>
Date: Wed, 21 Jan 2015 23:56:34 -0600
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_softplc-vm-10115-1421906195-0001-2"
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] 8250_core.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_softplc-vm-10115-1421906195-0001-2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

This was generated from 3.14 kernel, but since its so small it will likely apply to newer
kernels without issue.


--=_softplc-vm-10115-1421906195-0001-2
Content-Type: text/x-patch; name="8250_core.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="8250_core.patch"

A lesser travelled code path specifically crafted for "tx interrupt buggy"
UARTs seems to be testing the wrong bit for whether or not to prime the
transmit pump.  The result is that the tx interrupt never occurs on one chip
I am using that falls into the UART_BUG_TXEN category as I understand it.

The 16550 data sheet even names the interrupt "THRE" and not transmit
shift register empty.  The interrupt is fired when the holding register, or its
logical equivalent, the fifo, goes empty;  not when the shift register goes
empty.  This is a code bug in code hoping to fix a bug in hardware.

The reason this is so late coming to the surface is that lately the 8250
interrupt handler polls for all kinds of special status beyond the intention
of the hardware's purpose specific interrupt. Therefore so long as you
were in the interrupt handler (even if for purposes of servicing a recv
interrupt, you could recover from the broken transmit chain.  But if you are
only transmitting, not receiving, then this bug can manifest itself.

This is the fix.  It is harmless because so long as the fifo is empty, it
should be legal to re-fill it fully anyways.

Signed-off-by: Dick Hollenbeck <dick@softplc.com>

=== modified file 'drivers/tty/serial/8250/8250_core.c'
--- old/drivers/tty/serial/8250/8250_core.c	2014-07-14 18:39:13 +0000
+++ new/drivers/tty/serial/8250/8250_core.c	2015-01-22 05:28:33 +0000
@@ -1302,11 +1302,15 @@ static void serial8250_start_tx(struct u
		up->ier |= UART_IER_THRI;
		serial_port_out(port, UART_IER, up->ier);

+		/*
+		 * If setting UART_IER_THRI does not cause an
+		 * immediate tx interrupt
+		 */
		if (up->bugs & UART_BUG_TXEN) {
			unsigned char lsr;
			lsr = serial_in(up, UART_LSR);
			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-			if (lsr & UART_LSR_TEMT)
+			if (lsr & UART_LSR_THRE)
				serial8250_tx_chars(up);
		}
	}


--=_softplc-vm-10115-1421906195-0001-2--
