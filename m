Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3JBJrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:47:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:21796 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab3JBJrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1018,1371106800"; 
   d="scan'208";a="412872377"
Date: Wed, 2 Oct 2013 12:47:07 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Message-ID: <20131002094707.GA10383@xps8300>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 01, 2013 at 10:18:08AM -0700, Tim Kryger wrote:
> When configured with UART_16550_COMPATIBLE=NO or in versions prior to
> the introduction of this option, the Designware UART will ignore writes
> to the LCR if the UART is busy.  The current workaround saves a copy of
> the last written LCR and re-writes it in the ISR for a special interrupt
> that is raised when a write was ignored.
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
> This updated workaround reads back the LCR after each write to confirm
> that the new value was accepted by the hardware.  Should the hardware
> ignore a write, the TX/RX FIFOs are cleared and the receive buffer read
> before attempting to rewrite the LCR out of the hope that doing so will
> force the UART into an idle state.  While this may seem unnecessarily
> aggressive, writes to the LCR are used to change the baud rate, parity,
> stop bit, or data length so the data that may be lost is likely not
> important.  Admittedly, this is far from ideal but it seems to be the
> best that can be done given the hardware limitations.
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
> 
> Changes in v2:
>   - Rebased on tty-next
>   - Updated commit messsage to mention UART_16550_COMPATIBLE
>   - Removed potentially unnecessary read of LSR and MSR
>   - Only attempt workaround when LCR write is ignored

I'm OK with this.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>


Br,

-- 
heikki
