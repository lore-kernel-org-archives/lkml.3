Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3BGMVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:21:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345Ab3BGMVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:21:42 -0500
Date: Thu, 7 Feb 2013 13:22:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH] posix-cpu-timers: fix nanosleep task_struct leak
Message-ID: <20130207122212.GA2668@redhat.com>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
 <alpine.LFD.2.02.1302011450160.11905@ionos>
 <20130204193223.GA11910@redhat.com>
 <20130205103455.GB18313@redhat.com>
 <alpine.LFD.2.02.1302051155000.11905@ionos>
 <20130206112327.GA1824@redhat.com>
 <CA+ydwtrdNL_7AvZpmJ__06YUCVhSr7YPO8D=wzXhZiWp1-DVqg@mail.gmail.com>
 <20130206151550.GA1758@redhat.com>
 <20130206161011.GA11161@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206161011.GA11161@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 05:10:11PM +0100, Oleg Nesterov wrote:
> First of all, thank you so much. I knew it was a good idea to cc you ;)

:-)

> On 02/06, Stanislaw Gruszka wrote:
> >
> > In do_cpu_nanosleep() we do posix_cpu_timer_create(), but forgot
> > corresponding posix_cpu_timer_del(), what lead to task_struct leak.
> 
> Plus, it seems we can leave the timer on ->cpu_timers list...
> 
> > @@ -1403,6 +1403,7 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
> >  				/*
> >  				 * Our timer fired and was reset.
> >  				 */
> > +				posix_cpu_timer_del(&timer);
> >  				spin_unlock_irq(&timer.it_lock);
> >  				return 0;
> >  			}
> > @@ -1420,9 +1421,17 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
> >  		 * We were interrupted by a signal.
> >  		 */
> >  		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
> > -		posix_cpu_timer_set(&timer, 0, &zero_it, it);
> > +		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
> > +		if (!error)
> > +			posix_cpu_timer_del(&timer);
> >  		spin_unlock_irq(&timer.it_lock);
> >
> > +		while (error == TIMER_RETRY) {
> > +			spin_lock_irq(&timer.it_lock);
> > +			error = posix_cpu_timer_del(&timer);
> 
> It is not clear to me why other posix_cpu_timer_del's above can't fail..
> May be you can add a comment.

Sure, I'll add more comments.

Once posix_cpu_timer_set(..., &zero_it, it) succeed with 0 return value,
it's not possible to fire timer, so posix_cpu_timer_del() will not fail.
Similar assumption is with first posix_cpu_timer_del() call I added
in the patch.

> And I am not sure that TIMER_RETRY is the only error we should worry.
> And perhaps we need even more posix_cpu_timer_del's?
>
> For example. Suppose that posix_cpu_timer_create() succeeds and does
> get_task_struct(p). But than p dies, and the first posix_cpu_timer_set()
> fails with -ESRCH. No?

On second -ESRCH case posix_cpu_timer_set() internally call
put_task_struct(). It does not remove from cpu_timers list, but
that is done at exit(). First -ESRCH case, i.e. calling
posix_cpu_timer_set() with timer->it.cpu.task == NULL, is not possible
in our case.

BTW: I don't think we handle correctly case when traced process -
- timer->it.cpu.task will die. Tracing process - timer->it_process will
probably not be woken up.

Stanislaw
