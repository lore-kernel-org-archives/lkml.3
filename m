Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3CFTPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:15:43 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:40054 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3CFTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:15:40 -0500
Message-ID: <1362597296.18799.198.camel@thor.lan>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
From: Peter Hurley <peter@hurleysoftware.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 06 Mar 2013 14:14:56 -0500
In-Reply-To: <20130306165211.GA23635@localhost>
References: <1362085054.3337.20.camel@thor.lan> <51361724.4050107@suse.cz>
	 <20130306165211.GA23635@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 17:52 +0100, Johan Hovold wrote:

> > > @@ -225,15 +232,13 @@ void tty_port_hangup(struct tty_port *port)
> >         spin_lock_irqsave(&port->lock, flags);
> >         port->count = 0;
> >         port->flags &= ~ASYNC_NORMAL_ACTIVE;
> > -       if (port->tty) {
> > +       if (port->tty)
> >                 set_bit(TTY_IO_ERROR, &port->tty->flags);
> > -               tty_kref_put(port->tty);
> > -       }
> > -       port->tty = NULL;
> >         spin_unlock_irqrestore(&port->lock, flags);
> > > +       tty_port_shutdown(port, port->tty);
> > 
> > What prevents port->tty to be NULL here already?
> 
> Nothing, I'll get a new reference within the port lock section as you
> just suggested elsewhere in this thread.

Don't do that. Steal the tty and put the kref after like this:

void tty_port_hangup(struct tty_port *port)
{
	struct tty_struct *tty;
	unsigned long flags;

	spin_lock_irqsave(&port->lock, flags);
	port->count = 0;
	port->flags &= ~ASYNC_NORMAL_ACTIVE;
	tty = port->tty;
	port->tty = NULL;
	if (tty)
		set_bit(TTY_IO_ERROR, &tty->flags);
	spin_unlock_irqrestore(&port->lock, flags);
	tty_port_shutdown(port, tty);
	tty_kref_put(tty);
	wake_up_interruptible(&port->open_wait);
	wake_up_interruptible(&port->delta_msr_wait);
}



> Yes, I did. First, the order should not matter for blocked opens as they
> will exit their wait loops based on tty_hung_up_p(filp) either way.

Only if the open() was ever successful, otherwise the filp won't be in
the tty->tty_files list. That's why the blocking opens also check
ASYNC_INITIALIZED (or ASYNCB_INITIALIZED depending on which they use).

Which is why I said it was actually better to shutdown() first, then
wake up the blocked opens.

> As for delta_msr_wait the changed order is actually preferred as it
> allows the waiting process to return based on ASYNC_INITIALIZED. This is
> also the order used by serial_core. Note however that the current
> serial_core TIOCMIWAIT is broken in that it doesn't return on hangups at
> all.
> 
> Perhaps I should separate this to a patch of its own, and send a fix
> for serial_core TIOCMIWAIT as well.

uart_wait_modem_status() is what I was referring to and should be fixed.

Patches always welcome.

Regards,
Peter Hurley


