Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3FDQb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:31:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32973 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783Ab3FDQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:31:55 -0400
X-Sasl-enc: UGMLBQGsGcBWmtJ6BbpFNE9aWnaeUAsE2lHDUUZPbJzA 1370363509
Date: Tue, 4 Jun 2013 09:31:48 -0700
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] raise the maximum number of usb-serial devices to 512
Message-ID: <20130604163148.GA31202@kroah.com>
References: <1369721825.2776.36@driftwood>
 <51A327A4.7020908@linuxdingsda.de>
 <87obbwbo8s.fsf@nemi.mork.no>
 <51A332E2.1090403@linuxdingsda.de>
 <20130604024959.GA10697@kroah.com>
 <20130604110401.GA2566@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130604110401.GA2566@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 01:04:01PM +0200, Johan Hovold wrote:
> On Mon, Jun 03, 2013 at 07:49:59PM -0700, Greg KH wrote:
> > On Mon, May 27, 2013 at 02:28:51PM +0200, Bjørn Mork wrote:
> > > But, IMHO, a nicer approach would be to make the allocation completely
> > > dynamic, using e.g. the idr subsystem. Static tables are always feel
> > > like straight jackets to me, no matter how big they are :)
> > 
> > You are right, I didn't change the code to use idr (it predates idr by
> > about a decade or so), because I thought we needed the "rage" logic that
> > the usb-serial minor reservation does.
> > 
> > But I'm not so sure anymore, so here's a patch to change to use the idr
> > code, and should remove all minor number limitations (well 65k is the
> > limit the tty core should be setting I think.)
> > 
> > Tobias, can you test this patch out?  Note, I only compiled it, did not
> > get the chance to actually run it, so it might not work at all.
> 
> I'm afraid this won't work in it's current form. Several drivers and
> parts of usb-serial core still depend on the minor numbers being
> consecutive for multi-port devices.

You are right, let me go fix up the "port->number" assumption first,
which will let this become easier.  That should have been fixed a long
time ago.

> There are also still references to SERIAL_TTY_NO_MINOR (255) as well
> as SERIAL_TTY_MINORS that need to be addressed.

Yeah, I knew it was too good to be true that a simple 45 line patch
would solve this properly :)

> > +	port = idr_find(&serial_minors, index);
> >  	mutex_unlock(&table_lock);
> > +	if (!port)
> > +		return NULL;
> > +
> > +	serial = port->serial;
> > +	kref_get(&serial->kref);
> >  	return serial;
> >  }
> 
> We would still need to handle disconnect, and make sure to return with
> the disc_mutex held unless disconnected.

Alan noticed this as well, I've now fixed that, thanks.

> > +	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
> > +
> > +	*minor = 0xffffffff;
> > +	for (i = 0; i < num_ports; ++i) {
> > +		x = get_free_port(serial->port[i]);
> > +		if (x < 0)
> > +			goto error;
> > +		if (*minor == 0xffffffff)
> > +			*minor = x;
> >  	}
> > -	mutex_unlock(&table_lock);
> > -	return NULL;
> > +	return 0;
> > +error:
> > +	// FIXME unwind the already allocated minors
> > +	return -ENODEV;
> >  }
> 
> As mentioned above, usb-serial core and several drivers currently depend
> on us returning the first minor in a consecutive range. It's mostly used
> to determine the per device port index, so storing that index in the port
> structure could possibly be sufficient.

Yes, I'll go fix that up first, before making these changes, as it's
independant.

> > @@ -1233,9 +1226,6 @@ static int __init usb_serial_init(void)
> >  		return -ENOMEM;
> >  
> >  	/* Initialize our global data */
> 
> You could remove the above comment as well.
> 
> > -	for (i = 0; i < SERIAL_TTY_MINORS; ++i)
> > -		serial_table[i] = NULL;
> > -
> >  	result = bus_register(&usb_serial_bus_type);

I thought about it, but we also register the bus variables, and some
other things here as well, so I left it in.

thanks for the review.

greg k-h
