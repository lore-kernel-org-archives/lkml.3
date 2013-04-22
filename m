Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3DVMPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:15:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:57730 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3DVMPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:15:46 -0400
Date: Mon, 22 Apr 2013 14:15:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: vitalif@yourcmc.ru, Ben Hutchings <ben@decadent.org.uk>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        700333@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
In-Reply-To: <20130420225516.GB4649@pd.tnic>
Message-ID: <alpine.LFD.2.02.1304221409420.21884@ionos>
References: <4bded8a24b0719d575f6ffa6b38aebb6@yourcmc.ru> <1362490501.3768.409.camel@deadeye.wl.decadent.org.uk> <1b81bc6219ee47a5b8e53d03e9944939@yourcmc.ru> <20130305203952.GZ9079@decadent.org.uk> <4e8c511dcfd811c0f2ab822adaf52e50@yourcmc.ru>
 <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk> <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru> <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk> <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru> <20130420225516.GB4649@pd.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Apr 2013, Borislav Petkov wrote:

> + tglx.
> 
> On Sun, Apr 21, 2013 at 01:38:33AM +0400, vitalif@yourcmc.ru wrote:
> > >>Stack trace picture is here:
> > >>http://vmx.yourcmc.ru/var/pics/IMG_20130306_141045.jpg
> > >
> > >Vitaliy reported that his system crashes when suspending to disk.
> > >This
> > >was a regression from 3.2 to 3.7, and remains in 3.8.  Some
> > >details of
> > >this system are in the bug log at <http://bugs.debian.org/700333>.
> > >
> > >The photo shows a BUG in hrtimer_interrupt() after making the
> > >hibernation image and while resuming the non-boot CPUs.  The HPET
> > >interrupt handler was called immediately after it was registered
> > >for CPU
> > >2 (?), before the corresponding clock_event_device was registered.
> > >
> > >Seems like an obvious race condition, but then shouldn't the HPET
> > >have
> > >been stopped while the CPU was previously offlined?  And it's strange
> > >that this system apparently hits the race quite reliably.
> > 
> > Anyone?

So what happens is, that the HPET seems to have an interrupt pending
and this gets immediately fired, when the handler is installed. The
core code does not remove the hpet->event_handler, so it calls into
the hrtimer_interrupt where it hits the BUG and dies.

With the patch below, the box should survive and we should see a 

"Spurious HPET timer interrupt on HPET timer..." entry in dmesg.

That's a first workaround to confirm my theory. I'll look into the
HPET code how we can avoid that at all.

Thanks,

	tglx

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..0f0ce6e 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -323,6 +323,7 @@ static void tick_shutdown(unsigned int *cpup)
 		 */
 		dev->mode = CLOCK_EVT_MODE_UNUSED;
 		clockevents_exchange_device(dev, NULL);
+		dev->event_handler = NULL;
 		td->evtdev = NULL;
 	}
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);


