Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3CERGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:06:35 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:48683 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3CERGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:06:32 -0500
Message-ID: <1362503170.18799.33.camel@thor.lan>
Subject: Re: [Fwd: [PATCH v2 0/4] TTY: port hangup and close fixes]
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jhovold@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Mar 2013 12:06:10 -0500
In-Reply-To: <51361724.4050107@suse.cz>
References: <1362085054.3337.20.camel@thor.lan> <51361724.4050107@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 17:02 +0100, Jiri Slaby wrote:
> On 02/28/2013 09:57 PM, Peter Hurley wrote:
> > Hi Jiri,
> > 
> > Just wanted to make sure you saw this series.
> 
> Hi, thanks for letting me know. Johan, care to CC Alan Cox and me (or at
> least LKML) when you're changing the TTY core next time?

Alan asked to be dropped.

On Wed, 2013-02-13 at 17:36 +0000, Alan Cox wrote:
> [ Note that this closing of an uninitialised port seems to be a bug in
> >   itself, which these patches aim to fix. ]
> 
> You don't want to be cc'ing me on these - not my problem any more.

> I have a couple of questions for 2/4:
> 
> > Move HUPCL handling to port shutdown so that DTR is dropped also on
> > hang up (tty_port_close is a noop for hung-up ports).
> 
> It makes sense, but I'm not sure -- is this expected, i.e. does this
> conform to standards and/or BSDs?

This is the existing behavior of the serial core.

uart_hangup() -> uart_shutdown()

static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
{
	struct uart_port *uport = state->uart_port;
	struct tty_port *port = &state->port;

	/*
	 * Set the TTY IO error marker
	 */
	if (tty)
		set_bit(TTY_IO_ERROR, &tty->flags);

	if (test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags)) {
		/*
		 * Turn off DTR and RTS early.
		 */
		if (!tty || (tty->termios.c_cflag & HUPCL))
====>			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);

		uart_port_shutdown(port);
	}


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

[See my comment below]

====>              if (!tty || tty->termios.c_cflag & HUPCL)

> > +                       tty_port_lower_dtr_rts(port);
> > +
> 
> So you drop the line even thought the user didn't necessarily want to,
> in case the tty is gone already?
> 
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

Nothing. That's why it's tested in tty_port_shutdown() above.

> > +       tty_port_tty_set(port, NULL);
> >         wake_up_interruptible(&port->open_wait);
> >         wake_up_interruptible(&port->delta_msr_wait);
> > -       tty_port_shutdown(port);
> 
> Did you investigate if the order matters here? I don't know, just curious...

I did.

It makes sense to wake blocked opens only _after_ the port has been
shutdown. This way any blocked opens wake up, discover the port has been
shutdown and exit their wait loops in xxxxxx_block_til_ready().

Similarly for delta_msr_wait. Although I think the delta_msr_wait loop
is already unsafe (or at least not robust).


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
> 
> > -------- Forwarded Message --------
> > From: Johan Hovold <jhovold@gmail.com>
> > To: Greg KH <gregkh@linuxfoundation.org>
> > Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
> > linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
> > Johan Hovold <jhovold@gmail.com>
> > Subject: [PATCH v2 0/4] TTY: port hangup and close fixes
> > Date: Tue, 26 Feb 2013 12:14:28 +0100
> > 
> > These patches against tty-next fix a few issues with tty-port hangup and
> > close.
> > 
> > The first and third patch are essentially clean ups.
> > 
> > The second patch makes sure DTR is dropped also on hangup and that DTR
> > is only dropped for initialised ports (where is could have been raised
> > in the first place).
> > 
> > The fourth and final patch, make sure no tty callbacks are made from
> > tty_port_close_start when the port has not been initialised (successfully
> > opened). This was previously only done for wait_until_sent but there's
> > no reason to call flush_buffer or to honour port drain delay either.
> > The latter could cause a failed open to stall for up to two seconds.
> > 
> > As a side-effect, these patches also fix an issue in USB-serial where we could
> > get tty-port callbacks on an uninitialised port after having hung up and
> > unregistered a device after disconnect.
> > 
> > Johan
> > 
> > 
> > v2:
> >  - reuse tty reference from hangup and close in shutdown. Both call sites
> >    guarantee tty is either NULL or has a kref.
> > 
> > Changes since RFC-series:
> >  - fix up the two driver relying on tty_port_close_start directly but
> >    that did not manage DTR themselves
> > 
> > 
> > Johan Hovold (4):
> >   TTY: clean up port shutdown
> >   TTY: fix DTR not being dropped on hang up
> >   TTY: clean up port drain-delay handling
> >   TTY: fix close of uninitialised ports
> > 
> >  drivers/tty/mxser.c    |  4 +++
> >  drivers/tty/n_gsm.c    |  4 +++
> >  drivers/tty/tty_port.c | 72 +++++++++++++++++++++++++++++---------------------
> >  3 files changed, 50 insertions(+), 30 deletions(-)
> > 
> 
> thanks,


