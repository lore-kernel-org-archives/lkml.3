Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaLOJmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:42:12 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56103 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaLOJmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:42:10 -0500
Date: Mon, 15 Dec 2014 10:42:06 +0100
From: Johan Hovold <johan@kernel.org>
To: George McCollister <george.mccollister@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: serial: add nt124 usb to serial driver
Message-ID: <20141215094206.GA6778@localhost>
References: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
 <20141210130412.GJ14346@localhost>
 <CAFSKS=PnDa+_2eBk0M7xiE5me-7muo2ddVzhk=gHWMYoXhZtmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=PnDa+_2eBk0M7xiE5me-7muo2ddVzhk=gHWMYoXhZtmw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 09:01:03AM -0600, George McCollister wrote:
> On Wed, Dec 10, 2014 at 7:04 AM, Johan Hovold <johan@kernel.org> wrote:
> > On Mon, Dec 08, 2014 at 05:24:17PM -0600, George McCollister wrote:

> >> +     switch (termios->c_cflag & CSIZE) {
> >
> > C_CSIZE(tty)
> Okay
> >
> >> +     case CS5:
> >> +             newline.bDataBits = 5;
> >> +             break;
> >> +     case CS6:
> >> +             newline.bDataBits = 6;
> >> +             break;
> I should probably just remove CS5 and CS6 since I don't think they
> will work anyway.

Ok. Remember to update the passed termios with the settings that you
actually end up using (i.e. settings from old_termios).

> >> +static int nt124_open(struct tty_struct *tty,
> >> +                   struct usb_serial_port *port)
> >> +{
> >> +     struct nt124_private *priv = usb_get_serial_port_data(port);
> >> +     int result = 0;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&port->lock, flags);
> >> +     port->throttled = 0;
> >> +     port->throttle_req = 0;
> >> +     spin_unlock_irqrestore(&port->lock, flags);
> >> +
> >> +     priv->flowctrl = 0;
> >
> > Drop this and keep the current settings.
> Okay
> >
> >> +     nt124_set_termios(tty, port, NULL);
> >> +     nt124_set_flowctrl(port, priv->flowctrl);
> >
> > Drop this. This is handled by tty and dtr_rts().
> Okay
> >
> >> +
> >> +     if (port->bulk_in_size)
> >> +             result = usb_serial_generic_submit_read_urbs(port, GFP_KERNEL);
> >
> > Call usb_serial_generic_open() instead (and skip the throttle-flags bit
> > above).
> Okay, so looks like the only thing I will do in this function is call
> nt124_set_termios() followed by usb_serial_generic_open().

Yes, that should do it.

> >> +static struct usb_serial_driver nt124_device = {
> >> +     .driver = {
> >> +             .owner =        THIS_MODULE,
> >> +             .name =         "nt124",
> >> +     },
> >> +     .id_table =             id_table,
> >> +     .num_ports =            1,
> >> +     .bulk_in_size =         32,
> >> +     .bulk_out_size =        32,
> >
> > Why do you reduce these buffer sizes? They can be bigger than the
> > endpoint size for increased throughput.
> I'll leave them out like most of the other drivers (and retest) unless
> you have another suggestion.

That's perfectly fine, and means that the buffer sizes will match the
endpoint sizes (they will in fact never be smaller than that).

Johan
