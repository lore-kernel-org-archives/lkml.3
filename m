Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbaGWV7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:59:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:46918 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437AbaGWV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:59:34 -0400
Date: Wed, 23 Jul 2014 23:59:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V2 12/64] timekeeper: Move tk_xtime to core code
In-Reply-To: <CALAqxLX-mnLW5Ou-iwtRpRTbznhsBVzECHYPijifkvRsiHgv_Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407232358460.23352@nanos>
References: <20140716205018.175419210@linutronix.de> <20140716205053.190013055@linutronix.de> <CALAqxLX-mnLW5Ou-iwtRpRTbznhsBVzECHYPijifkvRsiHgv_Q@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, John Stultz wrote:
> On Wed, Jul 16, 2014 at 2:04 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Index: tip/kernel/time/timekeeping.c
> > ===================================================================
> > --- tip.orig/kernel/time/timekeeping.c
> > +++ tip/kernel/time/timekeeping.c
> > @@ -51,6 +51,15 @@ static inline void tk_normalize_xtime(st
> >         }
> >  }
> >
> > +static inline struct timespec64 tk_xtime(struct timekeeper *tk)
> > +{
> > +       struct timespec64 ts;
> > +
> > +       ts.tv_sec = tk->xtime_sec;
> > +       ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
> > +       return ts;
> > +}
> > +
> >  static void tk_set_xtime(struct timekeeper *tk, const struct timespec64 *ts)
> >  {
> >         tk->xtime_sec = ts->tv_sec;
> > @@ -199,6 +208,40 @@ static inline s64 timekeeping_get_ns_raw
> >         return nsec + arch_gettimeoffset();
> >  }
> >
> > +#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
> > +
> > +static inline void update_vsyscall(struct timekeeper *tk)
> > +{
> > +       struct timespec xt;
> > +
> > +       xt = tk_xtime(tk);
> > +       update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
> > +}
> 
> So one gotcha here, and I realized I missed this in my timekeeping
> timespec64 conversion patch, is that here we're calling tk_xtime()
> which returns a timespec64, and we stuff it into a timespec.
> 
> Now, the reason we didn't see the compiler gripe on this, was that the
> only VSYSCALL_OLD implementations left are ia64 and ppc64.
> 
> I'll add a fixup patch to the queue to address this.

Nice catch!

Thanks,

	tglx
