Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3CDClI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:41:08 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40997 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3CDClF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:41:05 -0500
Date: Mon, 4 Mar 2013 10:41:16 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        linux-serial@vger.kernel.org
Subject: Re: [ 019/150] serial_core: Fix type definition for
 PORT_BRCM_TRUMANAGE.
Message-ID: <20130304024116.GA9309@kroah.com>
References: <20130226235523.930663721@linuxfoundation.org>
 <20130226235526.246172467@linuxfoundation.org>
 <1362009959.3768.85.camel@deadeye.wl.decadent.org.uk>
 <20130228003906.GA3754@kroah.com>
 <1362279084.3768.200.camel@deadeye.wl.decadent.org.uk>
 <1362281921.3768.204.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362281921.3768.204.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 03:38:41AM +0000, Ben Hutchings wrote:
> I've queued up the following for 3.2.y.  Let me know if you see any
> issue with this or want to ack it.
> 
> Ben.
> 
> ---
> From: Ben Hutchings <ben@decadent.org.uk>
> Subject: 8250: use correct value for PORT_BRCM_TRUMANAGE
> Date: Sun, 03 Mar 2013 03:24:34 +0000
> 
> When backporting commit ebebd49a8eab ('8250/16?50: Add support for
> Broadcom TruManage redirected serial port') I took the next
> available port type number for PORT_BRCM_TRUMANAGE (22).
> 
> However, the 8250 port type numbers are exposed to userland through
> the TIOC{G,S}SERIAL ioctls and so must remain stable.  Redefine
> PORT_BRCM_TRUMANAGE as 25, matching mainline as of commit
> 85f024401bf807.
> 
> This leaves port types 22-24 within the valid range for 8250 but not
> implemented there.  Change serial8250_verify_port() to specifically
> reject these and change serial8250_type() to return "unknown" for them
> (though I'm not sure why it would ever see them).
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> --- a/drivers/tty/serial/8250.c
> +++ b/drivers/tty/serial/8250.c
> @@ -2695,7 +2695,7 @@ serial8250_verify_port(struct uart_port
>  	if (ser->irq >= nr_irqs || ser->irq < 0 ||
>  	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
>  	    ser->type >= ARRAY_SIZE(uart_config) || ser->type == PORT_CIRRUS ||
> -	    ser->type == PORT_STARTECH)
> +	    ser->type == PORT_STARTECH || uart_config[ser->type].name == NULL)
>  		return -EINVAL;
>  	return 0;
>  }
> @@ -2705,7 +2705,7 @@ serial8250_type(struct uart_port *port)
>  {
>  	int type = port->type;
>  
> -	if (type >= ARRAY_SIZE(uart_config))
> +	if (type >= ARRAY_SIZE(uart_config) || uart_config[type].name == NULL)

I don't think these two changes are really needed, as you point out
above, no one should really see, or care, about this.  But if you do,
these changes should go upstream first, right?

>  		type = 0;
>  	return uart_config[type].name;
>  }
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -47,8 +47,8 @@
>  #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
>  #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
>  #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
> -#define PORT_BRCM_TRUMANAGE	22
> -#define PORT_MAX_8250	22	/* max port ID */
> +#define PORT_BRCM_TRUMANAGE	25
> +#define PORT_MAX_8250	25	/* max port ID */

This one is good to have though, I have no objection to this hunk going
into 3.2, for it, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

