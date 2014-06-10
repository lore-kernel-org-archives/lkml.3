Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaFJTYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:24:46 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:48834 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFJTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:24:45 -0400
Date: Tue, 10 Jun 2014 21:24:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>
Subject: Re: Linux 3.15: SPARC serial console regression
Message-ID: <20140610192438.GA6846@ravnborg.org>
References: <20140609205917.GA913@drone.musicnaut.iki.fi>
 <1402357697-20976-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402357697-20976-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Hurley <peter@hurleysoftware.com>
> Date: Mon, 9 Jun 2014 19:21:43 -0400
> Subject: [PATCH] serial: sunsab: Test for no tx data on tx restart
> 
> Commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
> 'serial_core: Fix conditional start_tx on ring buffer not empty'
> exposes an incorrect assumption in sunsab's start_tx method; the
> tx ring buffer can, in fact, be empty when restarting tx when
> performing flow control.
> 
> Test for empty tx ring buffer when in sunsab's start_tx method.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Hi Peter.

Can you please take a look at sunzilog.c.
It looks like the same test is missing in sunzilog_start_tx():
        } else {
                struct circ_buf *xmit = &port->state->xmit;

                writeb(xmit->buf[xmit->tail], &channel->data);
                ZSDELAY();
                ZS_WSYNC(channel);

                xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
                port->icount.tx++;

                if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
                        uart_write_wakeup(&up->port);
        }


I did not review all drives - only a few sun drivers
and this was the only one that occured to me also
required this check.

I also noticed the typical pattern is:

    if (uart_circ_empty(xmit) || uart_tx_stopped(port))

Should you use this pattern also in sunsab.c?

	Sam
