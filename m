Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3JKHPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:15:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:50680 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab3JKHPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:15:43 -0400
Message-ID: <1381475711.5630.67.camel@pasglop>
Subject: Re: [PATCH 1/2] tty/hvc_console: Add DTR/RTS callback to handle
 HUPCL control
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, brueckner@linux.vnet.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Fri, 11 Oct 2013 18:15:11 +1100
In-Reply-To: <1372777635-10423-2-git-send-email-brueckner@linux.vnet.ibm.com>
References: <1372777635-10423-1-git-send-email-brueckner@linux.vnet.ibm.com>
	 <1372777635-10423-2-git-send-email-brueckner@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 17:07 +0200, Hendrik Brueckner wrote:
> Introduce a new callback to explicitly handle the HUPCL termios control flag.
> This prepares for a follow-up commit for the hvc_iucv device driver to
> improve handling when to drop an established network connection.
> 
> The callback naming is based on the recently added tty_port interface to
> facilitate a potential refactoring of the hvc_console to use tty_port
> functions.

I only just noticed that ... oops. Why add those dtr_rts() calls ? We
already have tiocmset in there which is used to set DTR on HVSI consoles
such as hvc_opal when using hvsi_lib...

Any reason why a separate callback was needed ?

Cheers,
Ben.

> Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> ---
>  drivers/tty/hvc/hvc_console.c |   11 ++++++++++-
>  drivers/tty/hvc/hvc_console.h |    3 +++
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
> index eb255e8..9eba119 100644
> --- a/drivers/tty/hvc/hvc_console.c
> +++ b/drivers/tty/hvc/hvc_console.c
> @@ -361,7 +361,12 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
>  		tty->driver_data = NULL;
>  		tty_port_put(&hp->port);
>  		printk(KERN_ERR "hvc_open: request_irq failed with rc %d.\n", rc);
> -	}
> +	} else
> +		/* We are ready... raise DTR/RTS */
> +		if (C_BAUD(tty))
> +			if (hp->ops->dtr_rts)
> +				hp->ops->dtr_rts(hp, 1);
> +
>  	/* Force wakeup of the polling thread */
>  	hvc_kick();
>  
> @@ -393,6 +398,10 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
>  		/* We are done with the tty pointer now. */
>  		tty_port_tty_set(&hp->port, NULL);
>  
> +		if (C_HUPCL(tty))
> +			if (hp->ops->dtr_rts)
> +				hp->ops->dtr_rts(hp, 0);
> +
>  		if (hp->ops->notifier_del)
>  			hp->ops->notifier_del(hp, hp->data);
>  
> diff --git a/drivers/tty/hvc/hvc_console.h b/drivers/tty/hvc/hvc_console.h
> index 674d23c..9131019 100644
> --- a/drivers/tty/hvc/hvc_console.h
> +++ b/drivers/tty/hvc/hvc_console.h
> @@ -75,6 +75,9 @@ struct hv_ops {
>  	/* tiocmget/set implementation */
>  	int (*tiocmget)(struct hvc_struct *hp);
>  	int (*tiocmset)(struct hvc_struct *hp, unsigned int set, unsigned int clear);
> +
> +	/* Callbacks to handle tty ports */
> +	void (*dtr_rts)(struct hvc_struct *hp, int raise);
>  };
>  
>  /* Register a vterm and a slot index for use as a console (console_init) */


