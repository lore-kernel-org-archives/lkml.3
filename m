Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab3CIC7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:59:32 -0500
Received: from netrider.rowland.org ([192.131.102.5]:51587 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760092Ab3CIC7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:59:30 -0500
Date: Fri, 8 Mar 2013 21:59:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
In-Reply-To: <2925850.6XPAdGF0iQ@linux-5eaq.site>
Message-ID: <Pine.LNX.4.44L0.1303082154360.28403-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Oliver Neukum wrote:

> On Friday 08 March 2013 12:55:08 Alan Stern wrote:
> > On Sat, 9 Mar 2013, Alexey Khoroshilov wrote:
> > 
> > > As it was described by Oliver Neukum in commit acbe2fe
> > > "USB: Don't use GFP_KERNEL while we cannot reset a storage device":
> > > 
> > >   Memory allocations with GFP_KERNEL can cause IO to a storage device
> > >   which can fail resulting in a need to reset the device. Therefore
> > >   GFP_KERNEL cannot be safely used between usb_lock_device()
> > >   and usb_unlock_device(). Replace by GFP_NOIO.
> > > 
> > > The patch fixes the same issue in usb/core/devio.c.
> > > All the allocations fixed are under usb_lock_device() from usbdev_do_ioctl().
> > > 
> > > Found by Linux Driver Verification project (linuxtesting.org).
> > 
> > I don't know if this is a good idea.  People can and do submit 
> > transfers requiring a lot of buffer space.  Switching to GFP_NOIO 
> > will make those allocations a lot more likely to fail.
> > 
> > Oliver, what do you think?
> 
> Ideally we'd split memory allocation and use, by it fixes a bug.
> Better allocation failure than deadlock.

In fact we wouldn't deadlock.  This is because 
usb_lock_device_for_reset() gives up if it can't obtain the device lock 
after one second of trying.  We'd just end up with a failure to reset, 
leading to an I/O failure.

Probably the mass-storage device would be taken off-line...  but there
wouldn't be a deadlock.  Under the circumstances, I'd say that the 
consequences of merging this patch would be worse than the consequences 
of keeping things as they are now.

Alan Stern

