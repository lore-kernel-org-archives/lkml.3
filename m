Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871AbaD3M3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:29:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:49528 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaD3M3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:29:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,958,1389772800"; 
   d="scan'208";a="523746369"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hrtimer:do not start hrtimer on other cpu if it is the
 leftmost timer.
Thread-Topic: [PATCH] hrtimer:do not start hrtimer on other cpu if it is the
 leftmost timer.
Thread-Index: AQHPZF/5HGLsleH9KUitYk2SC73pBJsqFiCQ
Date: Wed, 30 Apr 2014 12:29:20 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD025C6E5F@SHSMSX103.ccr.corp.intel.com>
References: <1398847391-5994-1-git-send-email-xindong.ma@intel.com>
 <CAOh2x=k2-9c8sJtM+gfVjF3NzANO5RBk-GuqOue5gd5CLY3KAg@mail.gmail.com>
In-Reply-To: <CAOh2x=k2-9c8sJtM+gfVjF3NzANO5RBk-GuqOue5gd5CLY3KAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: viresh.linux@gmail.com [mailto:viresh.linux@gmail.com] On Behalf Of
> Viresh Kumar
> Sent: Wednesday, April 30, 2014 6:36 PM
> To: Ma, Xindong
> Cc: Thomas Gleixner; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] hrtimer:do not start hrtimer on other cpu if it is the
> leftmost timer.
> 
> Hi Leon,
> 
> On Wed, Apr 30, 2014 at 2:13 PM, Leon Ma <xindong.ma@intel.com> wrote:
> > On SMP system, if cpuX is idle and it starts an hrtimer, the timer
> > will be started on cpuY. But it can not reprogram the event source on
> > cpuY. The timer is inserted into rb tree of cpuY, if it is the
> > leftmost timer on cpuY and it is a very short timer, following
> > hrtimers started on cpuY will also not set the event source. As a
> > result, the timers on cpuY will expire later than expected.
> 
> Don't know but the explanation confused me a bit :), thought the patch looked
> fine. So, in my words this is what I understood, let me know if I am on the right
> side.
> 
> Current base of timer is: cpuY and we started timer from cpuX. If cpuX is idle,
> we might select cpuY again as the base but we wouldn't be able to reprogram
> the event source as it has to be done by local CPU.
> 
> And so in this case you want to select cpuX instead, right?
Yes. Thanks Thomas to refine the changelog and make it clear:
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=012a45e3f4af68e86d85cce060c6c2fed56498b2
> 
> > When this case is detected, we should start the timer on cpuX and
> > program event source properly.
> >
> > Signed-off-by: Leon Ma <xindong.ma@intel.com>
> > ---
> >  kernel/hrtimer.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c index
> > d55092c..68becbc 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -234,6 +234,11 @@ again:
> >                         goto again;
> >                 }
> >                 timer->base = new_base;
> > +       } else {
> > +               if (cpu != this_cpu && hrtimer_check_target(timer,
> new_base)) {
> > +                       cpu = this_cpu;
> > +                       goto again;
> > +               }
> >         }
> >         return new_base;
> >  }
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
