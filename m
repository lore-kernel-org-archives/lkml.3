Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaFPPAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:00:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54163 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753167AbaFPPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:00:36 -0400
Date: Mon, 16 Jun 2014 11:00:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>, Peter Chen <peter.chen@freescale.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <r.baldyga@samsung.com>, <chanho61.park@samsung.com>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
In-Reply-To: <20140616013637.GA6432@shlinux1.ap.freescale.net>
Message-ID: <Pine.LNX.4.44L0.1406161047390.1292-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Peter Chen wrote:

> On Fri, Jun 13, 2014 at 10:19:36AM -0400, Alan Stern wrote:
> > On Fri, 13 Jun 2014, Peter Chen wrote:
> > 
> > > OK, we can keep our g_xxx gadget driver just support the basic feature. But
> > > the bug that causes gadget driver load fail due to udc is probed deferral should
> > > be fixed, do you think so, we can't wait until configfs has total been ready.
> > 
> > That problem has always existed.  There never has been a time when a
> > gadget driver could be loaded before the UDC driver was ready.  Does it 
> > really need to be fixed now?
> > 
> 
> Yes, otherwise, the device which the udc is probed deferral and the
> gadget driver is build-in will never work. If we skip fixing it, this
> problem will exist for more than 2 years, it is too long.
> 
> I have a support request from android team that usb peripheral function
> never works from 3.10.x kernel at one device, I think it is a common problem,
> no only I meet it.
> 
> Below are links which this problem reports:
> 
> http://marc.info/?l=linux-usb&m=139380872501745&w=2
> http://marc.info/?l=linux-usb&m=137706435611447&w=2
> 
> > If you do want to fix the problem, there's a much easier way than what
> > you posted.  See below.
> > 
> Robert Baldyga posts the similar solution, but seems Felipe doesn't
> agree it.
> http://www.spinics.net/lists/linux-usb/msg102795.html
> 
> Then, you and Felipe has a discussion for this problem:
> http://www.spinics.net/lists/linux-usb/msg106760.html

Okay, I get it.  Felipe didn't want to do this because you might end up 
loading a gadget driver that never gets bound.  There might not even be 
any UDC devices at all.

Felipe, I think the problem of having unbound gadget drivers isn't so
bad.  It's just like having unbound drivers of any sort.  For example,
the Fedora kernels have ohci-hcd and uhci-hcd built-in.  Relatively few
systems have both OHCI and UHCI controllers (lots of current machines
have neither); everybody else ends up with at least one unused driver
and no way to remove it.  If Fedora can do this, I think we can allow
users to have unnecessary gadget drivers.

In fact, I don't know of any other kind of driver module whose init 
routine will fail if there's no hardware to bind to.

I suggest you go ahead and accept Robert Baldyga's original patch -- 
except for one little problem: The patch forgets to add driver->list to 
the global driver_list if the driver gets bound immediately.  The

	list_add_tail(&driver->list, &driver_list);

call needs to be moved up near the start of usb_gadget_probe_driver().

Alan Stern

