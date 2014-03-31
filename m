Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaCaLS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:18:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:59268 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaCaLS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:18:26 -0400
Date: Mon, 31 Mar 2014 13:18:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Greg KH <greg@kroah.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403270940250.27563@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403311201520.14882@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201609540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403210956000.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403211610430.30801@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403240017430.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403262248170.31401@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403270940250.27563@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1788903429-1396264715=:14882"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1788903429-1396264715=:14882
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 27 Mar 2014, Vince Weaver wrote:
> On Wed, 26 Mar 2014, Thomas Gleixner wrote:
> > Ok. So we know now what we are looking for.
> > 
> > [    1.579996] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > ÿ[    1.607279] 00:09: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> > [    1.615032] kobject: 'ttyS1' (ffff88011772ac10): kobject_release, parent           (null) (delayed 250)
> > [    1.624534] kobject: '(null)' (ffff8801177400f0): kobject_release, parent           (null) (delayed 500)
> > [    1.654213] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq = 19, base_baud = 115200) is a 16550A
> > 
> > [    3.294047] Invalid timer base: tmr ffff880117740150 tmr->base           (null) base ffff880118898000
> > 
> > 1634110us : obj: ffff880117740130 initialized kobject_delayed_cleanup+0x0/0x90
> > 
> > So that happens in the context of the 8250 serial driver.
> > 
> > ...
> > 
> > Below is a patch which gives us the call path of the unnamed object
> > which causes the crash.
> 
> I've attached the boot log with that patch applied.

Vince, can you please disable CONFIG_DEBUG_KOBJECT_RELEASE and remove
all the debug patches to see whether the issue goes away?

I had a deeper look down that code path and the issue is, that the
serial core is not compatible with the deferred kobject release.

The tty_io layer uses a kobject embedded in its internal tty device
representation and reuses that.

So it seems that for whatever reason the tty layer releases ttyS1 and
then initializes it again. So the deferred release will queue the
object for release while the tty layer happily reinitializes it.

See tty_register_device() and tty_unregister.

Greg?

Thanks,

	tglx
--8323329-1788903429-1396264715=:14882--
