Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3IIRsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:48:19 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48270 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3IIRsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:48:18 -0400
Date: Mon, 9 Sep 2013 19:48:16 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] USB : serial : remove tty arg of handle_dcd_change.
Message-ID: <20130909174816.GC7726@localhost>
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
 <1378742480-2146-2-git-send-email-paul.chavent@onera.fr>
 <20130909174523.GB7726@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909174523.GB7726@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 07:45:23PM +0200, Johan Hovold wrote:
> On Mon, Sep 09, 2013 at 06:01:16PM +0200, Paul Chavent wrote:
> > Do the same way as in serialcore.c for uart_handle_dcd_change.  It
> > removes duplicated code around the usb_serial_handle_dcd_change calls.
> > 
> > Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
> > ---
> >  drivers/usb/serial/ch341.c   | 7 ++-----
> >  drivers/usb/serial/generic.c | 4 ++--
> >  drivers/usb/serial/pl2303.c  | 7 +------
> >  include/linux/usb/serial.h   | 1 -
> >  4 files changed, 5 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
> > index c2a4171..51c3d3a 100644
> > --- a/drivers/usb/serial/ch341.c
> > +++ b/drivers/usb/serial/ch341.c
> > @@ -481,11 +481,8 @@ static void ch341_read_int_callback(struct urb *urb)
> >  		spin_unlock_irqrestore(&priv->lock, flags);
> >  
> >  		if ((priv->line_status ^ prev_line_status) & CH341_BIT_DCD) {
> > -			struct tty_struct *tty = tty_port_tty_get(&port->port);
> > -			if (tty)
> > -				usb_serial_handle_dcd_change(port, tty,
> > -					    priv->line_status & CH341_BIT_DCD);
> > -			tty_kref_put(tty);
> > +			usb_serial_handle_dcd_change(port,
> > +				    priv->line_status & CH341_BIT_DCD);
> >  		}
> >  
> >  		wake_up_interruptible(&port->port.delta_msr_wait);
> > diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> > index 1f31e6b..33f1df1 100644
> > --- a/drivers/usb/serial/generic.c
> > +++ b/drivers/usb/serial/generic.c
> > @@ -560,13 +560,13 @@ EXPORT_SYMBOL_GPL(usb_serial_handle_break);
> >  /**
> >   *	usb_serial_handle_dcd_change - handle a change of carrier detect state
> >   *	@port: usb_serial_port structure for the open port
> > - *	@tty: tty_struct structure for the port
> >   *	@status: new carrier detect status, nonzero if active
> >   */
> >  void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
> > -				struct tty_struct *tty, unsigned int status)
> > +				unsigned int status)
> >  {
> >  	struct tty_port *port = &usb_port->port;
> > +	struct tty_struct *tty = port->tty;
> 
> No, this is not right. There's a reason tty_port_tty_get was used. You
> cannot simply remove it (even if your next patch adds it back, but
> without the NULL check).

My bad, the NULL check was already there. But this still would have to
be done as one patch, although I prefer keeping the current interface
for now.

Johan
