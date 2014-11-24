Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaKXJF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:05:28 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:43370 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaKXJFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:05:25 -0500
Date: Mon, 24 Nov 2014 09:04:45 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, San Mehat <san@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC] serial_core: Add wake_peer uart operation
Message-ID: <20141124090445.4340f747@lxorguk.ukuu.org.uk>
In-Reply-To: <1416293401-7714-1-git-send-email-kiran.kumar@linaro.org>
References: <1416293401-7714-1-git-send-email-kiran.kumar@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is one of the number of patches from the Android AOSP common.git tree,
> which is used on almost all Android devices.  I wanted to submit it for review
> to see if it should go upstream.
> 
>  drivers/tty/serial/serial_core.c | 3 +++
>  include/linux/serial_core.h      | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index df3a8c7..dc45c4b 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -95,6 +95,9 @@ static void __uart_start(struct tty_struct *tty)
>  	struct uart_state *state = tty->driver_data;
>  	struct uart_port *port = state->uart_port;
>  
> +	if (port->ops->wake_peer)
> +		port->ops->wake_peer(port);
> +
>  	if (!uart_tx_stopped(port))
>  		port->ops->start_tx(port);
>  }
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 21c2e05..219b6a3 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -66,6 +66,7 @@ struct uart_ops {
>  	void		(*set_ldisc)(struct uart_port *, int new);
>  	void		(*pm)(struct uart_port *, unsigned int state,
>  			      unsigned int oldstate);
> +	void		(*wake_peer)(struct uart_port *);
>  
>  	/*
>  	 * Return a string describing the type of the port

Can we please document the locking and call semantics for this - eg what
stop the peer going back to sleep as this call is made ? when does the
peer go back to sleep ? how does the peer decide to go back to sleep ?
Who sets wake_peer, when may it be set, why is it a uart_op when it's
likely to be per port and really ought to be a bit more dynamic ?

It's probably obvious to Android folks, but the rules are not afaik
written down anywhere in kernel land.

Also I guess why is the power management framework not appropriate for
this should also be answered.

I'm less worried about users - there are a lot of GPL out of tree drivers
using it, and several in tree ones with patches you add for Android use
which exist solely to fix up wake peer and the old wakelocks.

Alan
