Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaIAALg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:11:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32840 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaIAALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:11:34 -0400
Message-ID: <5403B9B1.4010407@gmail.com>
Date: Mon, 01 Sep 2014 10:11:29 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] serial: serial_core.c: printk replacement
References: <1409235328-24648-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1409235328-24648-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/08/14 00:15, Sudip Mukherjee wrote:
> printk replaced with corresponding pr_err, dev_alert, dev_notice and pr_info.
> fixed two broken user-visible strings used by the corresponding printk
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> In the first patch i sent Greg suggested to use dev_err instead of pr_err , but as later Jiri pointed out in my later patches that uport->dev is having a null check so can not be used , tty_dev is also having a put_device , so back to pr_err. 
> 
>  drivers/tty/serial/serial_core.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 

> @@ -1975,12 +1976,11 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>  		for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
>  			msleep(10);
>  		if (!tries)
> -			printk(KERN_ERR "%s%s%s%d: Unable to drain "
> -					"transmitter\n",
> -			       uport->dev ? dev_name(uport->dev) : "",
> -			       uport->dev ? ": " : "",
> -			       drv->dev_name,
> -			       drv->tty_driver->name_base + uport->line);
> +			pr_err("%s%s%s%d: Unable to drain transmitter\n",
> +				uport->dev ? dev_name(uport->dev) : "",
> +				uport->dev ? ": " : "",
> +				drv->dev_name,
> +				drv->tty_driver->name_base + uport->line);

dev_printk() prints the value of dev_name() and handles the NULL case,
so this could be changed to:

	dev_err(uport->dev, "%s%d: Unable to drain transmitter\n",
		drv->dev_name,
		drv->tty_driver->name_base + uport->line);

It might also be possible to remove drv->dev_name since dev_printk()
also prints the driver string, but I don't know if they are equivalent
in this case.

>  
>  		if (console_suspend_enabled || !uart_console(uport))
>  			ops->shutdown(uport);
> @@ -2109,7 +2109,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
>  		break;
>  	}
>  
> -	printk(KERN_INFO "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
> +	pr_info("%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
>  	       port->dev ? dev_name(port->dev) : "",
>  	       port->dev ? ": " : "",
>  	       drv->dev_name,

Same here.

~Ryan
