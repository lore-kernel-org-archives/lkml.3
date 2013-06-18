Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3FRKaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:30:06 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:48468 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3FRKaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:30:04 -0400
Date: Tue, 18 Jun 2013 12:23:25 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Johan Hovold <jhovold@gmail.com>, Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130618102325.GA2594@localhost>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
 <20130607180428.GB4204@kroah.com>
 <20130608100347.GO2566@localhost>
 <20130617201633.GA3903@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617201633.GA3903@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > @@ -123,8 +116,9 @@ static void return_serial(struct usb_ser
> > >  
> > >  	mutex_lock(&table_lock);
> > >  	for (i = 0; i < serial->num_ports; ++i)
> > > -		serial_table[serial->minor + i] = NULL;
> > > +		idr_remove(&serial_minors, serial->port[i]->minor);
> > >  	mutex_unlock(&table_lock);
> > > +	serial->minors_reserved = 0;
> > 
> > This isn't strictly needed as the serial struct release_serial is only
> > called once when the struct is about to be freed.
> 
> Really?  Why were we doing this type of thing before with the "not
> allocated" flag?  It seems that we were protecting some path that I
> can't remember at the moment.  So to be safe, I'll leave it for now...

It was and is only used when releasing the serial struct to check
whether minors had been allocated or not at probe and if return_serial
(release_minors) should be called. This in done in destroy_serial just
before freeing the struct, so clearing the flag is redundant, but
doesn't hurt anyone, I guess. ;)

Johan
