Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaIJMPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:15:48 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34547 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaIJMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:15:45 -0400
Message-ID: <541040ED.1020800@suse.cz>
Date: Wed, 10 Sep 2014 14:15:41 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] tty: serial: men_z135_uart: Fix driver for changes
 in hardware
References: <1410329329-4327-1-git-send-email-johannes.thumshirn@men.de>
In-Reply-To: <1410329329-4327-1-git-send-email-johannes.thumshirn@men.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014, 08:08 AM, Johannes Thumshirn wrote:
> * Add module parameter to configure the (baud rate dependent) RX timeout.
>   Character timeout in seconds = (timeout_reg * baud_reg * 4)/freq_reg.

Buried in the log. Instead, it would be nice to have this in
MODULE_PARM_DESC.

> --- a/drivers/tty/serial/men_z135_uart.c
> +++ b/drivers/tty/serial/men_z135_uart.c
...
> @@ -118,6 +117,10 @@ static int align;
>  module_param(align, int, S_IRUGO);
>  MODULE_PARM_DESC(align, "Keep hardware FIFO write pointer aligned, default 0");
> 
> +static int rx_timeout;
> +module_param(rx_timeout, uint, S_IRUGO);

int variable vs. uint handler.

> @@ -373,43 +376,47 @@ out:
>   * @irq: The IRQ number
>   * @data: Pointer to UART port
>   *
> - * Check IIR register to see which tasklet to start.
> + * Check IIR register to find the cause of the interrupt and handle it.
> + * It is possible that multiple interrupts reason bits are set and reading
> + * the IIR is a destructive read, so we always need to check for all possible
> + * interrupts and handle them.
>   */
>  static irqreturn_t men_z135_intr(int irq, void *data)
>  {
>  	struct men_z135_port *uart = (struct men_z135_port *)data;
>  	struct uart_port *port = &uart->port;
> +	int handled = 0;

This can be bool or use IRQ_NONE directly.

...
> -	return IRQ_HANDLED;
> +	if (irq_id & MEN_Z135_IRQ_ID_RDA || irq_id & MEN_Z135_IRQ_ID_CTI) {

A matter of taste, but
 irq_id & (MEN_Z135_IRQ_ID_RDA | MEN_Z135_IRQ_ID_CTI)
looks and works better.

thanks,
-- 
js
suse labs
