Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3FDONw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:13:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35274 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755898Ab3FDONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:13:48 -0400
Date: Tue, 4 Jun 2013 10:13:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] raise the maximum number of usb-serial devices to 512
In-Reply-To: <20130604024959.GA10697@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1306041007410.1093-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, Greg KH wrote:

> On Mon, May 27, 2013 at 02:28:51PM +0200, Bjørn Mork wrote:
> > But, IMHO, a nicer approach would be to make the allocation completely
> > dynamic, using e.g. the idr subsystem. Static tables are always feel
> > like straight jackets to me, no matter how big they are :)
> 
> You are right, I didn't change the code to use idr (it predates idr by
> about a decade or so), because I thought we needed the "rage" logic that
> the usb-serial minor reservation does.
> 
> But I'm not so sure anymore, so here's a patch to change to use the idr
> code, and should remove all minor number limitations (well 65k is the
> limit the tty core should be setting I think.)
> 
> Tobias, can you test this patch out?  Note, I only compiled it, did not
> get the chance to actually run it, so it might not work at all.
> 
> thanks,
> 
> greg k-h


> @@ -61,59 +62,52 @@ static LIST_HEAD(usb_serial_driver_list);
>  struct usb_serial *usb_serial_get_by_index(unsigned index)
>  {
>  	struct usb_serial *serial;
> +	struct usb_serial_port *port;
>  
>  	mutex_lock(&table_lock);
> -	serial = serial_table[index];
> -
> -	if (serial) {
> -		mutex_lock(&serial->disc_mutex);
> -		if (serial->disconnected) {
> -			mutex_unlock(&serial->disc_mutex);
> -			serial = NULL;
> -		} else {
> -			kref_get(&serial->kref);
> -		}
> -	}
> +	port = idr_find(&serial_minors, index);
>  	mutex_unlock(&table_lock);
> +	if (!port)
> +		return NULL;
> +
> +	serial = port->serial;
> +	kref_get(&serial->kref);
>  	return serial;
>  }

The test for serial->disconnected got lost.  And the locking isn't 
right; the routine is documented to return with serial->disc_mutex held 
(in the case where the device hasn't been disconnected).

Also, the kref_get() needs to occur within the scope of the table_lock.

I didn't check the rest of the patch for similar errors.  Finding three 
in the first function seemed like enough.  :-)

Alan Stern

