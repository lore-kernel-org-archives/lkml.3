Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3IZWrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:47:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab3IZWq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:46:57 -0400
Date: Thu, 26 Sep 2013 15:46:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] serial: 8250_dw: Improve unwritable LCR workaround
Message-ID: <20130926224655.GA15106@kroah.com>
References: <1380069549-9176-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380069549-9176-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 05:39:09PM -0700, Tim Kryger wrote:
> The Designware UART has a limitation where it ignores writes into the
> LCR if the UART is busy.  The current workaround stashes a copy of the
> last written LCR and writes it back down to the hardware if it receives
> a special busy interrupt which is raised when a write was ignored.
> 
> Unfortunately, interrupts are typically disabled prior to performing a
> sequence of register writes that include the LCR so the point at which
> the retry occurs is too late.  An example is serial8250_do_set_termios()
> where an ignored LCR write results in the baud divisor not being set and
> instead a garbage character is sent out the transmitter.
> 
> Furthermore, since serial_port_out() offers no way to indicate failure,
> a serious effort must be made to ensure that the LCR is actually updated
> before returning back to the caller.  This is difficult, however, as a
> UART that was busy during the first attempt is likely to still be busy
> when a subsequent attempt is made unless some extra action is taken.
> 
> This updated workaround takes the extreme action of clearing the TX/RX
> FIFOs and reading the receive buffer before writing down the LCR in the
> hope that doing so will force the UART into an idle state.  While this
> may seem unnecessarily aggressive, writes to the LCR are used to change
> the baud rate, parity, stop bit, or data length so the data that may be
> lost is likely not important.  Admittedly, this is far from ideal but it
> seems to be the best that can be done given the hardware limitations.
> 
> Lastly, the revised workaround doesn't touch the LCR in the ISR, so it
> avoids the possibility of a "serial8250: too much work for irq" lock up.
> This problem is rare in real situations but can be reproduced easily by
> wiring up two UARTs and running the following commands.
> 
>   # stty -F /dev/ttyS1 echo
>   # stty -F /dev/ttyS2 echo
>   # cat /dev/ttyS1 &
>   [1] 375
>   # echo asdf > /dev/ttyS1
>   asdf
> 
>   [   27.700000] serial8250: too much work for irq96
>   [   27.700000] serial8250: too much work for irq96
>   [   27.710000] serial8250: too much work for irq96
>   [   27.710000] serial8250: too much work for irq96
>   [   27.720000] serial8250: too much work for irq96
>   [   27.720000] serial8250: too much work for irq96
>   [   27.730000] serial8250: too much work for irq96
>   [   27.730000] serial8250: too much work for irq96
>   [   27.740000] serial8250: too much work for irq96
> 
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  drivers/tty/serial/8250/8250_dw.c | 57 +++++++++++++++++++++++++++------------
>  1 file changed, 40 insertions(+), 17 deletions(-)

This patch no longer applies to my tty-next tree, can you please refresh
it and resend so that I can apply it?

thanks,

greg k-h
