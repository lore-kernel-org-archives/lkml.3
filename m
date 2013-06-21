Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946260Ab3FUXG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 19:06:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:41896 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946172Ab3FUXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 19:06:55 -0400
Date: Sat, 22 Jun 2013 01:06:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
In-Reply-To: <51C44A09.9010402@citrix.com>
Message-ID: <alpine.DEB.2.02.1306212328350.4013@ionos.tec.linutronix.de>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de> <51C44A09.9010402@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, David Vrabel wrote:
> On 21/06/13 08:57, Thomas Gleixner wrote:
> > On Thu, 20 Jun 2013, David Vrabel wrote:
> > 
> >> From: David Vrabel <david.vrabel@citrix.com>
> >>
> >> The high resolution timer code gets notified of step changes to the
> >> system time with clock_was_set() or clock_was_set_delayed() calls.  If
> >> other parts of the kernel require similar notification there is no
> >> clear place to hook into.
> > 
> > You fail to explain why any other part of the kernel requires a
> > notification.
> 
> This is needed by patch 3 in this series.
> 
> "The Xen wallclock is a software only clock within the Xen hypervisor
> that is used by: a) PV guests as the equivalent of a hardware RTC; and
> b) the hypervisor as the clock source for the emulated RTC provided to
> HVM guests.
> 
> Currently the Xen wallclock is only updated every 11 minutes if NTP is
> synchronized to its clock source.  If a guest is started before NTP is
> synchronized it may see an incorrect wallclock time.

What you are saying is, that you are fixing Xens failure to implement
a proper RTC emulation by hacking a notifier into the core code. You
can't be serious about that.

According to your changelog:

  Currently the Xen wallclock is only updated every 11 minutes if NTP is
  synchronized to its clocksource.

How is that related to clock_was_set() ?

clock_was_set*() is invoked from:

	do_settimeofday()
	timekeeping_inject_offset()
	timekeeping_set_tai_offset()
	timekeeping_inject_sleeptime()
	update_wall_time()
	do_adjtimex()

The only function which calls clock_was_set() and can affect RTC is
do_adjtimex(). Though you claim that the natural place to add a
notifier is clock_was_set().

So you went the other way round this time. In the hrtimers case you
tried to fix shortcomings of the core code in some random Xen
code. With this patch you try to fix Xen nonsense in the core code.

Can you please provide a proper explanation of the problem you are
trying to solve? This means that you should explain the semantics of
the desired XEN RTC emulation and not the desired workarounds to fix
the shortcommings current implementation.

Thanks,

	tglx

