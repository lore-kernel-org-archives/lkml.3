Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaIAOVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:21:25 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50767 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbaIAOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:21:23 -0400
Date: Mon, 1 Sep 2014 19:51:07 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] serial: serial_core.c: printk replacement
Message-ID: <20140901142107.GA3068@sudip-PC>
References: <1409235328-24648-1-git-send-email-sudipm.mukherjee@gmail.com>
 <5403B9B1.4010407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5403B9B1.4010407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 10:11:29AM +1000, Ryan Mallon wrote:
> 
> 
> On 29/08/14 00:15, Sudip Mukherjee wrote:
> > printk replaced with corresponding pr_err, dev_alert, dev_notice and pr_info.
> > fixed two broken user-visible strings used by the corresponding printk
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> > 
> > In the first patch i sent Greg suggested to use dev_err instead of pr_err , but as later Jiri pointed out in my later patches that uport->dev is having a null check so can not be used , tty_dev is also having a put_device , so back to pr_err. 
> > 
> >  drivers/tty/serial/serial_core.c | 26 +++++++++++++-------------
> >  1 file changed, 13 insertions(+), 13 deletions(-)
> > 
> 
> > @@ -1975,12 +1976,11 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
> >  		for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
> >  			msleep(10);
> >  		if (!tries)
> > -			printk(KERN_ERR "%s%s%s%d: Unable to drain "
> > -					"transmitter\n",
> > -			       uport->dev ? dev_name(uport->dev) : "",
> > -			       uport->dev ? ": " : "",
> > -			       drv->dev_name,
> > -			       drv->tty_driver->name_base + uport->line);
> > +			pr_err("%s%s%s%d: Unable to drain transmitter\n",
> > +				uport->dev ? dev_name(uport->dev) : "",
> > +				uport->dev ? ": " : "",
> > +				drv->dev_name,
> > +				drv->tty_driver->name_base + uport->line);
> 
> dev_printk() prints the value of dev_name() and handles the NULL case,
> so this could be changed to:
> 
> 	dev_err(uport->dev, "%s%d: Unable to drain transmitter\n",
> 		drv->dev_name,
> 		drv->tty_driver->name_base + uport->line);
> 
> It might also be possible to remove drv->dev_name since dev_printk()
> also prints the driver string, but I don't know if they are equivalent
> in this case.
> 

they are not equivalent. drv->dev_name is giving "ttyS" , and the driver string as printed by dev_printk() is "serial".
So, I guess I will make a v3 of the patch and mention all these in the commit message.

thanks
sudip

> >  
> >  		if (console_suspend_enabled || !uart_console(uport))
> >  			ops->shutdown(uport);
> > @@ -2109,7 +2109,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
> >  		break;
> >  	}
> >  
> > -	printk(KERN_INFO "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
> > +	pr_info("%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
> >  	       port->dev ? dev_name(port->dev) : "",
> >  	       port->dev ? ": " : "",
> >  	       drv->dev_name,
> 
> Same here.
> 
> ~Ryan
