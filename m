Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbaDQCiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 22:38:18 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49304 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358AbaDQCiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 22:38:16 -0400
X-Sasl-enc: tb0qa1SsIlN3GEHDr9tJ1Amu5VeYDRzexWRfOG+gNng8 1397702295
Date: Wed, 16 Apr 2014 19:38:18 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
Message-ID: <20140417023818.GB6448@kroah.com>
References: <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1403240017430.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403262248170.31401@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403270940250.27563@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403311201520.14882@ionos.tec.linutronix.de>
 <20140406034750.GA7674@kroah.com>
 <alpine.DEB.2.02.1404170056140.22697@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1404170056140.22697@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:00:53AM +0200, Thomas Gleixner wrote:
> On Sat, 5 Apr 2014, Greg KH wrote:
> > On Mon, Mar 31, 2014 at 01:18:34PM +0200, Thomas Gleixner wrote:
> > > On Thu, 27 Mar 2014, Vince Weaver wrote:
> > > > On Wed, 26 Mar 2014, Thomas Gleixner wrote:
> > > > > Ok. So we know now what we are looking for.
> > > > > 
> > > > > [    1.579996] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > > > > ÿ[    1.607279] 00:09: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> > > > > [    1.615032] kobject: 'ttyS1' (ffff88011772ac10): kobject_release, parent           (null) (delayed 250)
> > > > > [    1.624534] kobject: '(null)' (ffff8801177400f0): kobject_release, parent           (null) (delayed 500)
> > > > > [    1.654213] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq = 19, base_baud = 115200) is a 16550A
> > > > > 
> > > > > [    3.294047] Invalid timer base: tmr ffff880117740150 tmr->base           (null) base ffff880118898000
> > > > > 
> > > > > 1634110us : obj: ffff880117740130 initialized kobject_delayed_cleanup+0x0/0x90
> > > > > 
> > > > > So that happens in the context of the 8250 serial driver.
> > > > > 
> > > > > ...
> > > > > 
> > > > > Below is a patch which gives us the call path of the unnamed object
> > > > > which causes the crash.
> > > > 
> > > > I've attached the boot log with that patch applied.
> > > 
> > > Vince, can you please disable CONFIG_DEBUG_KOBJECT_RELEASE and remove
> > > all the debug patches to see whether the issue goes away?
> > > 
> > > I had a deeper look down that code path and the issue is, that the
> > > serial core is not compatible with the deferred kobject release.
> > > 
> > > The tty_io layer uses a kobject embedded in its internal tty device
> > > representation and reuses that.
> > 
> > It does?  What kobject is that?  I've dug through the code and I can't
> > find it.  I see where we create a new device in
> > tty_register_device_attr() which is dynamic and should be torn down when
> > free_tty_struct() is called eventually.
> 
> It's not about the dynamic stuff.
>  
> > > So it seems that for whatever reason the tty layer releases ttyS1 and
> > > then initializes it again. So the deferred release will queue the
> > > object for release while the tty layer happily reinitializes it.
> > 
> > That's not good, but I can't find that code path, any hints?
> 
> static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
> 		unsigned int index, unsigned int count)
> {
> 	/* init here, since reused cdevs cause crashes */
> 	cdev_init(&driver->cdevs[index], &tty_fops);
> 
> The comment is interesting ...
> 
> And cdevs is an array of  struct cdev:
> 
> struct cdev {
> 	struct kobject kobj;

Those are not "real" kobjects, and are never registered with the kobject
core.

I really need to go rename those one of these days, and just make them a
separate object, as they have nothing to do with a "normal" kobject
other than the reference count and the use of the kobject map stuff.

So if this is showing up as a problem, something else is going on here,
as this should not be an issue at all.

thanks,

greg k-h
