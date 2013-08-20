Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3HTP52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:57:28 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49983 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3HTP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:57:27 -0400
MIME-Version: 1.0
In-Reply-To: <1373277884-3006-1-git-send-email-oleksandr.savchenko@ti.com>
References: <1373277884-3006-1-git-send-email-oleksandr.savchenko@ti.com>
Date: Tue, 20 Aug 2013 08:57:25 -0700
Message-ID: <CAGa+x866vUhX-uctWfZpw42hW7bRTG92Qz=4j=gWL-vgpdryDg@mail.gmail.com>
Subject: Re: [PATCH] OMAP: UART: Keep the TX fifo full when possible
From: Kevin Hilman <khilman@linaro.org>
To: Alexander Savchenko <oleksandr.savchenko@ti.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, matts@commtech-fastcom.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, dhowells@redhat.com,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Felipe

On Mon, Jul 8, 2013 at 3:04 AM, Alexander Savchenko
<oleksandr.savchenko@ti.com> wrote:
> From: Dmitry Fink <finik@ti.com>
>
> Current logic results in interrupt storm since the fifo
> is constantly below the threshold level. Change the logic
> to fill all the available spaces in the fifo as long as
> we have data to minimize the possibilty of underflow and
> elimiate excessive interrupts.
>
> Signed-off-by: Dmitry Fink <finik@ti.com>
> Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>

Hmm, another OMAP serial patch that wasn't Cc'd to linux-omap where
OMAP users might have seen it. :(

I just bisected a strange problem in linux-next on OMAP3 down to this
patch.  Reverting it fixes the problem.

On OMAP3530 Beagle and Overo, after boot, doing a 'cat /proc/cpuinfo'
was not returning to a prompt, suggesting something strange with the
FIFO.  Hitting return gets me back to a prompt.

Greg, this one should also be dropped from tty-next until it can be
further investgated and the problem solved.

Thanks,

Kevin


> ---
>  drivers/tty/serial/omap-serial.c |    3 ++-
>  include/uapi/linux/serial_reg.h  |    1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index b6d1728..5c9b074 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -310,7 +310,8 @@ static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
>                 serial_omap_stop_tx(&up->port);
>                 return;
>         }
> -       count = up->port.fifosize / 4;
> +       count = up->port.fifosize -
> +               (serial_in(up, UART_OMAP_TXFIFO_LVL) & 0xFF);
>         do {
>                 serial_out(up, UART_TX, xmit->buf[xmit->tail]);
>                 xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
> diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
> index e632260..97c26be 100644
> --- a/include/uapi/linux/serial_reg.h
> +++ b/include/uapi/linux/serial_reg.h
> @@ -366,6 +366,7 @@
>  #define UART_OMAP_MDR1_FIR_MODE                0x05    /* FIR mode */
>  #define UART_OMAP_MDR1_CIR_MODE                0x06    /* CIR mode */
>  #define UART_OMAP_MDR1_DISABLE         0x07    /* Disable (default state) */
> +#define UART_OMAP_TXFIFO_LVL           0x1A    /* TX FIFO fullness */
>
>  /*
>   * These are definitions for the Exar XR17V35X and XR17(C|D)15X
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
