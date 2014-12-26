Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaLZVZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 16:25:12 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44859 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaLZVZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 16:25:09 -0500
MIME-Version: 1.0
In-Reply-To: <1418891601-53769-2-git-send-email-eddie.huang@mediatek.com>
References: <1418891601-53769-1-git-send-email-eddie.huang@mediatek.com> <1418891601-53769-2-git-send-email-eddie.huang@mediatek.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 26 Dec 2014 15:24:47 -0600
Message-ID: <CAL_JsqKp+1ZWPK4rB4_vxrx-dtNCy7Hc3S67uQ9VHdAby8erjg@mail.gmail.com>
Subject: Re: [PATCH 1/2] tty: serial: 8250_mtk: Add earlycon
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, yingjoe.chen@mediatek.com,
        yh.chen@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 2:33 AM, Eddie Huang <eddie.huang@mediatek.com> wrote:
> Mediatek UART has highspeed register, but 8250_early.c doesn't
> support this, so add earlycon in 8250_mtk.c

I don't see any highspeed register setup here. More generically,
aren't you just skipping any UART setup? That may be useful on other
platforms with 8250s, too. With the kernel command line version, you
could perhaps add a "noinit" flag. The DT case is harder, and I'm not
sure how we should handle that. We could perhaps add a
"stdout-path-initialized" flag to chosen.

>
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> ---
>  drivers/tty/serial/8250/8250_mtk.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
> index de7aae5..65dd569 100644
> --- a/drivers/tty/serial/8250/8250_mtk.c
> +++ b/drivers/tty/serial/8250/8250_mtk.c
> @@ -23,6 +23,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/serial_8250.h>
>  #include <linux/serial_reg.h>
> +#include <linux/console.h>
>
>  #include "8250.h"
>
> @@ -289,6 +290,38 @@ static struct platform_driver mtk8250_platform_driver = {
>  };
>  module_platform_driver(mtk8250_platform_driver);
>
> +#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
> +
> +static void __init mtk8250_serial_putc(struct uart_port *port, int c)
> +{
> +       while ((readl(port->membase + (UART_LSR << 2)) & BOTH_EMPTY) !=
> +               BOTH_EMPTY)
> +               ;
> +       writel(c, port->membase + (UART_TX << 2));
> +}
> +
> +static void __init early_mtk8250_write(struct console *console,
> +                                       const char *s, unsigned int count)

Is there a reason early_serial8250_write can't work for you other than
it is currently static?

Rob

> +{
> +       struct earlycon_device *dev = console->data;
> +
> +       uart_console_write(&dev->port, s, count, mtk8250_serial_putc);
> +}
> +
> +static int __init early_mtk8250_setup(struct earlycon_device *device,
> +                                       const char *options)
> +{
> +       if (!device->port.membase)
> +               return -ENODEV;
> +
> +       device->con->write = early_mtk8250_write;
> +
> +       return 0;
> +}
> +
> +EARLYCON_DECLARE(mtk8250, early_mtk8250_setup);
> +OF_EARLYCON_DECLARE(mtk8250, "mediatek,mt6577-uart", early_mtk8250_setup);
> +
>  MODULE_AUTHOR("Matthias Brugger");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Mediatek 8250 serial port driver");
> --
> 1.8.1.1.dirty
>
