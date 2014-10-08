Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaJHUL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:11:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:6407 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbaJHULy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,679,1406617200"; 
   d="scan'208";a="585590633"
Message-ID: <1412799101.28467.68.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH 03/12] serial_core: Handle TIOC[GS]RS485 ioctls.
From: Alan Cox <alan@linux.intel.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2014 21:11:41 +0100
In-Reply-To: <1412798258-23655-4-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1412798258-23655-4-git-send-email-ricardo.ribalda@gmail.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 21:57 +0200, Ricardo Ribalda Delgado wrote:
> The following drivers: 8250_core, atmel_serial, max310x, mcf, omap-serial
> and sci16is7xx implement code to handle RS485 ioctls.

>  
> +static int uart_get_rs485_config(struct uart_port *port,
> +			 struct serial_rs485 __user *rs485)
> +{
> +	if (!port->rs485_config)
> +		return -ENOIOCTLCMD;
> +
> +	if (copy_to_user(rs485, &port->rs485, sizeof(port->rs485)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int uart_set_rs485_config(struct uart_port *port,
> +			 struct serial_rs485 __user *rs485_user)
> +{
> +	struct serial_rs485 rs485;
> +	int ret;
> +
> +	if (!port->rs485_config)
> +		return -ENOIOCTLCMD;
> +
> +	if (copy_from_user(&rs485, rs485_user, sizeof(rs485_user)))
> +		return -EFAULT;
> +
> +	ret = port->rs485_config(port, &rs485);
> +	if (ret)
> +		return ret;
> +
> +	if (copy_to_user(rs485_user, &port->rs485, sizeof(port->rs485)))
> +		return -EFAULT;
> +
> +	return 0;
> +

What is the locking between setting/getting/driver use of the config ?
This really needs a lock (termios sem I think is perhaps appropriate
given when the values are normally referenced).

Alan


