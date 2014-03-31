Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaCaLqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:46:51 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55917 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaCaLqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:46:49 -0400
Date: Mon, 31 Mar 2014 13:46:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Greg KH <greg@kroah.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
Message-ID: <20140331114645.GA8619@gmail.com>
References: <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1403240017430.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403262248170.31401@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403270940250.27563@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403311201520.14882@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1403311201520.14882@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 27 Mar 2014, Vince Weaver wrote:
> > On Wed, 26 Mar 2014, Thomas Gleixner wrote:
> > > Ok. So we know now what we are looking for.
> > > 
> > > [    1.579996] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > > ÿ[    1.607279] 00:09: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> > > [    1.615032] kobject: 'ttyS1' (ffff88011772ac10): kobject_release, parent           (null) (delayed 250)
> > > [    1.624534] kobject: '(null)' (ffff8801177400f0): kobject_release, parent           (null) (delayed 500)
> > > [    1.654213] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq = 19, base_baud = 115200) is a 16550A
> > > 
> > > [    3.294047] Invalid timer base: tmr ffff880117740150 tmr->base           (null) base ffff880118898000
> > > 
> > > 1634110us : obj: ffff880117740130 initialized kobject_delayed_cleanup+0x0/0x90
> > > 
> > > So that happens in the context of the 8250 serial driver.
> > > 
> > > ...
> > > 
> > > Below is a patch which gives us the call path of the unnamed object
> > > which causes the crash.
> > 
> > I've attached the boot log with that patch applied.
> 
> Vince, can you please disable CONFIG_DEBUG_KOBJECT_RELEASE and remove
> all the debug patches to see whether the issue goes away?
> 
> I had a deeper look down that code path and the issue is, that the
> serial core is not compatible with the deferred kobject release.
> 
> The tty_io layer uses a kobject embedded in its internal tty device
> representation and reuses that.
> 
> So it seems that for whatever reason the tty layer releases ttyS1 and
> then initializes it again. So the deferred release will queue the
> object for release while the tty layer happily reinitializes it.
> 
> See tty_register_device() and tty_unregister.
> 
> Greg?

Hm, this reminds me of the following randconfig testing patch I've 
been carrying for some time:

================>
$ cat patches/qa-dont-boot-DEBUG_KOBJECT_RELEASE.patch
Subject: qa: dont boot DEBUG_KOBJECT_RELEASE
From: Ingo Molnar <mingo@kernel.org>
Date: Mon Oct 7 16:15:46 CEST 2013

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/Kconfig.debug |    3 +++
 1 file changed, 3 insertions(+)

Index: linux2/lib/Kconfig.debug
===================================================================
--- linux2.orig/lib/Kconfig.debug
+++ linux2/lib/Kconfig.debug
@@ -1025,6 +1025,9 @@ config DEBUG_KOBJECT
 config DEBUG_KOBJECT_RELEASE
        bool "kobject release debugging"
        depends on DEBUG_OBJECTS_TIMERS
+       # Frequent, hard to debug crashes:
+       depends on BROKEN_BOOT_ALLOWED
+       select BROKEN_BOOT
        help
          kobjects are reference counted objects.  This means that their
          last reference count put is not predictable, and the kobject can

I never fully tracked it down and forgot about it.

Thanks,

		Ingo
