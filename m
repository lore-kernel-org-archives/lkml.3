Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3CGJoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:44:17 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:56957 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3CGJoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:44:13 -0500
Date: Thu, 7 Mar 2013 10:43:20 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
Message-ID: <20130307094320.GB23635@localhost>
References: <1362085054.3337.20.camel@thor.lan>
 <51361724.4050107@suse.cz>
 <20130306165211.GA23635@localhost>
 <1362597296.18799.198.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362597296.18799.198.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 02:14:56PM -0500, Peter Hurley wrote:
> On Wed, 2013-03-06 at 17:52 +0100, Johan Hovold wrote:
> 
> > > > @@ -225,15 +232,13 @@ void tty_port_hangup(struct tty_port *port)
> > >         spin_lock_irqsave(&port->lock, flags);
> > >         port->count = 0;
> > >         port->flags &= ~ASYNC_NORMAL_ACTIVE;
> > > -       if (port->tty) {
> > > +       if (port->tty)
> > >                 set_bit(TTY_IO_ERROR, &port->tty->flags);
> > > -               tty_kref_put(port->tty);
> > > -       }
> > > -       port->tty = NULL;
> > >         spin_unlock_irqrestore(&port->lock, flags);
> > > > +       tty_port_shutdown(port, port->tty);
> > > 
> > > What prevents port->tty to be NULL here already?
> > 
> > Nothing, I'll get a new reference within the port lock section as you
> > just suggested elsewhere in this thread.
> 
> Don't do that. Steal the tty and put the kref after like this:
 
Allright.

> > Yes, I did. First, the order should not matter for blocked opens as they
> > will exit their wait loops based on tty_hung_up_p(filp) either way.
> 
> Only if the open() was ever successful, otherwise the filp won't be in
> the tty->tty_files list. That's why the blocking opens also check
> ASYNC_INITIALIZED (or ASYNCB_INITIALIZED depending on which they use).
> Which is why I said it was actually better to shutdown() first, then
> wake up the blocked opens.

ASYNC_INITIALIZED have also been cleared when the blocked opens are
being woken up from tty_port_close_end.

And the filp is added to tty_files before open() is called:

===>    tty_add_file(tty, filp);

	check_tty_count(tty, __func__);
	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
	    tty->driver->subtype == PTY_TYPE_MASTER)
		noctty = 1;
#ifdef TTY_DEBUG_HANGUP
	printk(KERN_DEBUG "%s: opening %s...\n", __func__, tty->name);
#endif
	if (tty->ops->open)
===>		retval = tty->ops->open(tty, filp);

so a blocked open must have hung_up_tty_fops when woken up from hangup,
right?

Either way, postponing wake-up somewhat in tty_port_hangup should be
fine.

Thanks,
Johan
