Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaGBTiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:38:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49802 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757830AbaGBTiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:38:23 -0400
Date: Wed, 2 Jul 2014 15:38:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Stefan Klug <stefan.klug@baslerweb.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
In-Reply-To: <1404327517.10859.3.camel@linux-fkkt.site>
Message-ID: <Pine.LNX.4.44L0.1407021532370.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Oliver Neukum wrote:

> On Wed, 2014-07-02 at 17:53 +0200, Stefan Klug wrote:
> 
> > Implementation details:
> > The patch only touches drivers/usb/core/devio.c.
> > In procy_do_submiturb(), it is checked if zerocopy is allowed. This is 
> > currently a rough
> > check which compares the number of required pages to 
> > ps->dev->bus->sg_tablesize.
> 
> It seems to me that the check is per call, so using
> multiple calls one could still pin unlimited amounts
> of memory.

usbfs keeps track of the total amount of pinned memory and enforces an
overall limit.  It will be necessary to add the size of the transfer
buffer to that total.

> > I don't know if there is more to check there.
> > Then the user memory provided inside the usbdevfs_urb structure is 
> > pinned to
> > physical memory using get_user_pages_fast().
> > All the user pages are added to the scatter-gather list and the logic 
> > continues as before.
> 
> How do you enforce the cache coherency rules?

There is no way to do this.  If the user program accesses memory when 
it shouldn't, the transfer might not work right.

> Also you don't have a fall back if get_user_pages_fast()
> returns less than requested. It seems to me that than you
> ought to fall back buffered IO.

Agreed.

Alan Stern

