Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaJMNws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:52:48 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:55622 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaJMNwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:52:45 -0400
Date: Mon, 13 Oct 2014 14:52:29 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tty/serial_core: Introduce lock mechanism for RS485
Message-ID: <20141013145229.4849f07a@alan.etchedpixels.co.uk>
In-Reply-To: <1412948280-30993-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412948280-30993-1-git-send-email-ricardo.ribalda@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1154,8 +1154,16 @@ static int uart_get_icount(struct tty_struct *tty,
>  static int uart_get_rs485_config(struct uart_port *port,
>  			 struct serial_rs485 __user *rs485)
>  {
> -	if (copy_to_user(rs485, &port->rs485, sizeof(port->rs485)))
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +	ret = copy_to_user(rs485, &port->rs485, sizeof(port->rs485));
> +	spin_unlock_irqrestore(&port->lock, flags);

Looks good apart from this bit.. The copy needs to go to a temporary
before the lock is taken otherwise we may sleep on a pagefault with irqs
off

Alan
