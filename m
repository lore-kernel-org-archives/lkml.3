Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaEWGWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:22:13 -0400
Received: from imta21.fe.bosch.de ([139.15.243.226]:61580 "EHLO
	imta21.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaEWGWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:22:11 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2014 02:22:11 EDT
Message-ID: <537EE65C.5010700@de.bosch.com>
Date: Fri, 23 May 2014 08:10:36 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: imx: disable the receiver ready interrupt
 for imx_stop_rx
References: <1400819575-20435-1-git-send-email-b32955@freescale.com> <1400819575-20435-2-git-send-email-b32955@freescale.com>
In-Reply-To: <1400819575-20435-2-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.217.133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.2014 06:32, Huang Shijie wrote:
> This patch disables the receiver ready interrupt for imx_stop_rx.
> It reduces the interrupt numbers when the uart is going to close
> or suspend.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>   drivers/tty/serial/imx.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index ed6cdf7..6026101 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -440,6 +440,10 @@ static void imx_stop_rx(struct uart_port *port)
>
>   	temp = readl(sport->port.membase + UCR2);
>   	writel(temp & ~UCR2_RXEN, sport->port.membase + UCR2);
> +
> +	/* disable the `Receiver Ready Interrrupt` */
> +	temp = readl(sport->port.membase + UCR1);
> +	writel(temp & ~UCR1_RRDYEN, sport->port.membase + UCR1);
>   }

While this is about the RX irq, I've a slightly off-topic general 
question regarding the usage of the *TX* irq in TX DMA mode:

It seems to me that the TX irq is kept enabled while the TX DMA is 
running/enabled? Looking e.g. into the amba-pl011.c there it seems there 
the logic is:

- Set up/start the TX DMA
- Disable the TX irq while the TX DMA is running (only waiting for the 
TX DMA callback, then)
- Re-enable the TX irq in the TX DMA callback
- Let the TX irq fire, then. And if there are still data, set up the TX 
DMA again.

This sounds quite more logical than the implementation in imx.c.

Or is my understanding completely wrong, here?

Thanks

Dirk

