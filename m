Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3CFQxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:53:07 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:48540 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3CFQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:53:04 -0500
Date: Wed, 6 Mar 2013 17:52:11 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jhovold@gmail.com, Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
Message-ID: <20130306165211.GA23635@localhost>
References: <1362085054.3337.20.camel@thor.lan>
 <51361724.4050107@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51361724.4050107@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Mar 05, 2013 at 05:02:44PM +0100, Jiri Slaby wrote:
> On 02/28/2013 09:57 PM, Peter Hurley wrote:
> > Hi Jiri,
> > 
> > Just wanted to make sure you saw this series.
> 
> Hi, thanks for letting me know. Johan, care to CC Alan Cox and me (or at
> least LKML) when you're changing the TTY core next time?

Sorry about that. Thought it was a bit odd I didn't hear anything from
you actually. ;) Everything was posted to linux-serial (and Alan
initially), but I'll remember to CC you in the future as well.

> I have a couple of questions for 2/4:
>
> > Move HUPCL handling to port shutdown so that DTR is dropped also on
> > hang up (tty_port_close is a noop for hung-up ports).
> 
> It makes sense, but I'm not sure -- is this expected, i.e. does this
> conform to standards and/or BSDs?

As Peter also mentioned, this is how serial_core (and another seven tty
drivers) work today.

There are currently seven drivers (counting usb-serial as one) that
manipulate DTR at open/close but do not drop DTR on hangup, and five of
those (including usb-serial) don't do it because they use the tty_port
implementation.

> > @@ -196,13 +196,20 @@ void tty_port_tty_set(struct tty_port *port, struct
> > tty_struct *tty)
> >  }
> >  EXPORT_SYMBOL(tty_port_tty_set);
> 
> -static void tty_port_shutdown(struct tty_port *port)
> +static void tty_port_shutdown(struct tty_port *port, struct tty_struct
> *tty)
>  {
>         mutex_lock(&port->mutex);
>         if (port->console)
>                 goto out;
> 
>         if (test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags)) {
> +               /*
> +                * Drop DTR/RTS if HUPCL is set. This causes any attached
> +                * modem to hang up the line.
> +                */
> +               if (!tty || tty->termios.c_cflag & HUPCL)
> > +                       tty_port_lower_dtr_rts(port);
> > +
> 
> So you drop the line even thought the user didn't necessarily want to,
> in case the tty is gone already?

You have a point in that it might be better to do it the other way round
and not touch DTR unless we know for sure it was requested. [ But see my
answer to you next question as well. ]

Several drivers (including serial_core) had a similar construct in their
shutdown() but tty is never NULL when called from hangup in those cases.

> > @@ -225,15 +232,13 @@ void tty_port_hangup(struct tty_port *port)
>         spin_lock_irqsave(&port->lock, flags);
>         port->count = 0;
>         port->flags &= ~ASYNC_NORMAL_ACTIVE;
> -       if (port->tty) {
> +       if (port->tty)
>                 set_bit(TTY_IO_ERROR, &port->tty->flags);
> -               tty_kref_put(port->tty);
> -       }
> -       port->tty = NULL;
>         spin_unlock_irqrestore(&port->lock, flags);
> > +       tty_port_shutdown(port, port->tty);
> 
> What prevents port->tty to be NULL here already?

Nothing, I'll get a new reference within the port lock section as you
just suggested elsewhere in this thread.

But this should never be the case when using both tty_port_close and
tty_port_hangup, as then port->tty will only be NULL if the port has
already been shut down, right?

> > +       tty_port_tty_set(port, NULL);
> >         wake_up_interruptible(&port->open_wait);
> >         wake_up_interruptible(&port->delta_msr_wait);
> > -       tty_port_shutdown(port);
> 
> Did you investigate if the order matters here? I don't know, just curious...

Yes, I did. First, the order should not matter for blocked opens as they
will exit their wait loops based on tty_hung_up_p(filp) either way.

As for delta_msr_wait the changed order is actually preferred as it
allows the waiting process to return based on ASYNC_INITIALIZED. This is
also the order used by serial_core. Note however that the current
serial_core TIOCMIWAIT is broken in that it doesn't return on hangups at
all.

Perhaps I should separate this to a patch of its own, and send a fix
for serial_core TIOCMIWAIT as well.

Thanks,
Johan

> > @@ -452,11 +457,6 @@ int tty_port_close_start(struct tty_port *port,
>         /* Flush the ldisc buffering */
>         tty_ldisc_flush(tty);
> 
> -       /* Drop DTR/RTS if HUPCL is set. This causes any attached modem to
> -          hang up the line */
> -       if (tty->termios.c_cflag & HUPCL)
> -               tty_port_lower_dtr_rts(port);
> -
>         /* Don't call port->drop for the last reference. Callers will want
>            to drop the last active reference in ->shutdown() or the tty
> >            shutdown path */
