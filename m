Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbaCZWAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:00:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:35093 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaCZWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:00:48 -0400
Date: Wed, 26 Mar 2014 23:00:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Greg KH <greg@kroah.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403262248170.31401@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201056020.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403201609540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403210956000.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403211610430.30801@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403240017430.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-46563982-1395871256=:31401"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-46563982-1395871256=:31401
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 26 Mar 2014, Vince Weaver wrote:
> On Tue, 25 Mar 2014, Thomas Gleixner wrote:
> > Do you happen to have the full bootlog up to the crash handy?
> 
> attached is the full bootlog followed by the tracedump.

Ok. So we know now what we are looking for.

[    1.579996] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    1.607279] 00:09: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.615032] kobject: 'ttyS1' (ffff88011772ac10): kobject_release, parent           (null) (delayed 250)
[    1.624534] kobject: '(null)' (ffff8801177400f0): kobject_release, parent           (null) (delayed 500)
[    1.654213] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq = 19, base_baud = 115200) is a 16550A

[    3.294047] Invalid timer base: tmr ffff880117740150 tmr->base           (null) base ffff880118898000

1634110us : obj: ffff880117740130 initialized kobject_delayed_cleanup+0x0/0x90

So that happens in the context of the 8250 serial driver.
 
> > Adding "initcall_debug" to the kernel command line might give us a
> > further hint what is adding the delayed_work, but I guess once we see
> > the function in the trace we have a good chance to find the place
> > right away. Then we have to figure out what scribbles over it .....
> 
> I haven't tried the initcall_debug yet but can if needed.

Below is a patch which gives us the call path of the unnamed object
which causes the crash.

Greg???

Thanks,

	tglx

---
 lib/kobject.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/lib/kobject.c
===================================================================
--- linux-2.6.orig/lib/kobject.c
+++ linux-2.6/lib/kobject.c
@@ -645,6 +645,9 @@ static void kobject_release(struct kref
 	struct kobject *kobj = container_of(kref, struct kobject, kref);
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
 	unsigned long delay = HZ + HZ * (get_random_int() & 0x3);
+
+	WARN_ON(!kobject_name(kobj));
+
 	pr_info("kobject: '%s' (%p): %s, parent %p (delayed %ld)\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent, delay);
 	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
--8323329-46563982-1395871256=:31401--
